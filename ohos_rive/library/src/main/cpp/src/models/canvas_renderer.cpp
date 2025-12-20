/*
 * Copyright (C) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "../../include/models/canvas_renderer.h"
#include "../../include/helpers/canvas_render_objects.h"
#include "utils/factory_utils.hpp"

namespace ohos_rive {
constexpr size_t INDEX_TWO = 2;
constexpr size_t ALPHA_MAX = 255;
void CanvasRenderer::save()
{
    // bind m_ohCanvas before calling these methods.
    if (m_ohCanvas == nullptr) {
        LOGE("Canvas is null, cannot proceed with save.");
        return;
    }
    OH_Drawing_CanvasSave(m_ohCanvas);
}

void CanvasRenderer::restore()
{
    // bind m_ohCanvas before calling these methods.
    if (m_ohCanvas == nullptr) {
        LOGE("Canvas is null, cannot proceed with restore.");
        return;
    }
    OH_Drawing_CanvasRestore(m_ohCanvas);
}

void CanvasRenderer::transform(const rive::Mat2D &transform)
{
    // bind m_ohCanvas before calling these methods.
    if (m_ohCanvas == nullptr) {
        LOGE("Canvas is null, cannot proceed with transform.");
        return;
    }

    OH_Drawing_Matrix *matrix = OH_Drawing_MatrixCreate();
    OH_Drawing_MatrixSetMatrix(matrix, transform.xx(), transform.yx(), transform.tx(), transform.xy(), transform.yy(),
                               transform.ty(), 0, 0, 1);
    OH_Drawing_CanvasConcatMatrix(m_ohCanvas, matrix);
}

void CanvasRenderer::clipPath(rive::RenderPath *path)
{
    // bind m_ohCanvas before calling these methods.
    if (m_ohCanvas == nullptr) {
        LOGE("Canvas is null, cannot proceed with clipPath.");
        return;
    }
    auto *canvasPath = static_cast<CanvasRenderPath *>(path);
    OH_Drawing_CanvasClipPath(m_ohCanvas, canvasPath->ohosPath(), INTERSECT, true);
}

void CanvasRenderer::drawPath(rive::RenderPath *path, rive::RenderPaint *paint)
{
    // bind m_ohCanvas before calling these methods.
    if (m_ohCanvas == nullptr) {
        LOGE("Canvas is null, cannot proceed with drawPath.");
        return;
    }
    auto *canvasPath = static_cast<CanvasRenderPath *>(path);
    auto *canvasPaint = static_cast<CanvasRenderPaint *>(paint);
    OhosPaint *ohosPaint = canvasPaint->GetOhosPaint();

    if (ohosPaint->style == OhosPaint::PaintStyle::STROKE) {
        OH_Drawing_CanvasAttachPen(m_ohCanvas, ohosPaint->pen);
        OH_Drawing_CanvasDrawPath(m_ohCanvas, canvasPath->ohosPath());
        OH_Drawing_CanvasDetachPen(m_ohCanvas);
    } else {
        OH_Drawing_CanvasAttachBrush(m_ohCanvas, ohosPaint->brush);
        OH_Drawing_CanvasDrawPath(m_ohCanvas, canvasPath->ohosPath());
        OH_Drawing_CanvasDetachBrush(m_ohCanvas);
    }
}

void CanvasRenderer::drawImage(const rive::RenderImage *image,
                               const rive::ImageSampler options,
                               rive::BlendMode blendMode,
                               float opacity)
{
    if (m_ohCanvas == nullptr) {
        LOGE("Canvas is null, cannot proceed with drawImage.");
        return;
    }

    const auto *canvasImage = static_cast<const CanvasRenderImage *>(image);
    OhosPaint *ohosPaint = canvasImage->OhosPaint();

    LOGD("drawImage: blendMode=%{public}d, opacity=%{public}.2f", static_cast<int>(blendMode), opacity);

    CanvasRenderPaint::SetPaintAlpha(ohosPaint, static_cast<int>(opacity * ALPHA_MAX));
    CanvasRenderPaint::SetBlendMode(ohosPaint, blendMode);

    OH_Drawing_Image *drawingImage = OH_Drawing_ImageCreate();
    if (!drawingImage) {
        LOGE("Failed to create drawing image");
        return;
    }

    bool buildResult = OH_Drawing_ImageBuildFromBitmap(drawingImage, canvasImage->OhosBitmap());
    if (!buildResult) {
        LOGE("Failed to build image from bitmap");
        OH_Drawing_ImageDestroy(drawingImage);
        return;
    }

    OH_Drawing_Rect *rect = OH_Drawing_RectCreate(0, 0, image->width(), image->height());
    OH_Drawing_SamplingOptions *samplingOpts = OH_Drawing_SamplingOptionsCreate(FILTER_MODE_LINEAR, MIPMAP_MODE_NONE);

    if (ohosPaint->style == OhosPaint::PaintStyle::STROKE) {
        OH_Drawing_CanvasAttachPen(m_ohCanvas, ohosPaint->pen);
        OH_Drawing_CanvasDrawImageRect(m_ohCanvas, drawingImage, rect, samplingOpts);
        OH_Drawing_CanvasDetachPen(m_ohCanvas);
    } else {
        OH_Drawing_CanvasAttachBrush(m_ohCanvas, ohosPaint->brush);
        OH_Drawing_CanvasDrawImageRect(m_ohCanvas, drawingImage, rect, samplingOpts);
        OH_Drawing_CanvasDetachBrush(m_ohCanvas);
    }

    OH_Drawing_SamplingOptionsDestroy(samplingOpts);
    OH_Drawing_RectDestroy(rect);
    OH_Drawing_ImageDestroy(drawingImage);
}

void CanvasRenderer::drawImageMesh(const rive::RenderImage *image,
                                   const rive::ImageSampler options,
                                   rive::rcp<rive::RenderBuffer> vertices_f32,
                                   rive::rcp<rive::RenderBuffer> uvCoords_f32,
                                   rive::rcp<rive::RenderBuffer> indices_u16,
                                   uint32_t vertexCount,
                                   uint32_t indexCount,
                                   rive::BlendMode blendMode,
                                   float opacity)
{
    // bind m_ohCanvas before calling these methods.
    if (m_ohCanvas == nullptr) {
        LOGE("Canvas is null, cannot proceed with drawImageMesh.");
        return;
    }
    const auto *canvasImage = static_cast<const CanvasRenderImage *>(image);
    OhosPaint *ohPaint = canvasImage->OhosPaint();
    // Opacity is [0.0f..1.0f] while setAlpha() needs [0..255]
    CanvasRenderPaint::SetPaintAlpha(ohPaint, static_cast<int>(opacity * ALPHA_MAX));
    CanvasRenderPaint::SetBlendMode(ohPaint, blendMode);

    OH_Drawing_ShaderEffect *shader = CanvasRenderImage::CreateBitmapShader(canvasImage->OhosBitmap());
    CanvasRenderPaint::SetShader(ohPaint, shader);

    OH_Drawing_VertexMode vertexMode = VERTEX_MODE_TRIANGLES;

    /** Set up the vertices */
    const float *vertices = static_cast<rive::DataRenderBuffer *>(vertices_f32.get())->f32s();

    std::vector<OH_Drawing_Point2D> positions(vertexCount);
    for (int i = 0; i < vertexCount; i++) {
        positions[i].x = vertices[i * INDEX_TWO];
        positions[i].y = vertices[i * INDEX_TWO + 1];
    }

    /** Set up the uvs */
    const float *uvs = static_cast<rive::DataRenderBuffer *>(uvCoords_f32.get())->f32s();
    std::vector<OH_Drawing_Point2D> scaledUVs(vertexCount);
    for (int i = 0; i < vertexCount; i++) {
        // Need to manually scale UVs for canvas.drawVertices() to work.
        scaledUVs[i].x = uvs[i * INDEX_TWO] * image->width();
        scaledUVs[i].y = uvs[i * INDEX_TWO + 1] * image->height();
    }

    /** Set up the indices */
    const uint16_t *indices = static_cast<rive::DataRenderBuffer *>(indices_u16.get())->u16s();
    uint32_t *noColors = nullptr;

    if (ohPaint->style == OhosPaint::PaintStyle::STROKE) {
        OH_Drawing_CanvasAttachPen(m_ohCanvas, ohPaint->pen);
        OH_Drawing_CanvasDrawVertices(m_ohCanvas, vertexMode, vertexCount, positions.data(), scaledUVs.data(), noColors,
                                      indexCount, indices, RiveBlendModeToOhosBlendMode(blendMode));
        OH_Drawing_CanvasDetachPen(m_ohCanvas);
    } else {
        OH_Drawing_CanvasAttachBrush(m_ohCanvas, ohPaint->brush);
        OH_Drawing_CanvasDrawVertices(m_ohCanvas, vertexMode, vertexCount, positions.data(), scaledUVs.data(), noColors,
                                      indexCount, indices, RiveBlendModeToOhosBlendMode(blendMode));
        OH_Drawing_CanvasDetachBrush(m_ohCanvas);
    }
    OH_Drawing_ShaderEffectDestroy(shader);
}
} // namespace ohos_rive

