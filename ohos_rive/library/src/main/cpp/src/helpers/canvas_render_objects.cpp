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

#include "../../include/helpers/canvas_render_objects.h"
#include "../../include/helpers/general.h"
#include <memory>
#include <vector>

namespace ohos_rive {
constexpr size_t INDEX_TWO = 2;
constexpr size_t INDEX_THREE = 3;

OH_Drawing_Matrix *RiveMatrixToOhosMatrix(const rive::Mat2D &matrix)
{
    auto ohosMatrix = OH_Drawing_MatrixCreate();
    OH_Drawing_MatrixSetMatrix(ohosMatrix, matrix.xx(), matrix.xy(), matrix.tx(), matrix.yx(), matrix.yy(), matrix.ty(),
                               0, 0, 1);
    return ohosMatrix;
}

OH_Drawing_BlendMode RiveBlendModeToOhosBlendMode(rive::BlendMode value)
{
    switch (value) {
        case rive::BlendMode::srcOver:
            return BLEND_MODE_SRC_OVER;
        case rive::BlendMode::screen:
            return BLEND_MODE_SCREEN;
        case rive::BlendMode::overlay:
            return BLEND_MODE_OVERLAY;
        case rive::BlendMode::darken:
            return BLEND_MODE_DARKEN;
        case rive::BlendMode::lighten:
            return BLEND_MODE_LIGHTEN;
        case rive::BlendMode::colorDodge:
            return BLEND_MODE_COLOR_DODGE;
        case rive::BlendMode::colorBurn:
            return BLEND_MODE_COLOR_BURN;
        case rive::BlendMode::hardLight:
            return BLEND_MODE_HARD_LIGHT;
        case rive::BlendMode::softLight:
            return BLEND_MODE_SOFT_LIGHT;
        case rive::BlendMode::difference:
            return BLEND_MODE_DIFFERENCE;
        case rive::BlendMode::exclusion:
            return BLEND_MODE_EXCLUSION;
        case rive::BlendMode::multiply:
            return BLEND_MODE_MULTIPLY;
        case rive::BlendMode::hue:
            return BLEND_MODE_HUE;
        case rive::BlendMode::saturation:
            return BLEND_MODE_SATURATION;
        case rive::BlendMode::color:
            return BLEND_MODE_COLOR;
        case rive::BlendMode::luminosity:
            return BLEND_MODE_LUMINOSITY;
    }
    return BLEND_MODE_SRC_OVER;
}

OH_Drawing_Bitmap *ConvertPixelMapToBitmap(OH_PixelmapNative *nativePixelMap)
{
    if (nativePixelMap == nullptr) {
        return nullptr;
    }

    uint32_t width;
    uint32_t height;
    OH_Pixelmap_ImageInfo *imageInfo;
    OH_PixelmapImageInfo_Create(&imageInfo);
    auto result = OH_PixelmapNative_GetImageInfo(nativePixelMap, imageInfo);
    if (result != IMAGE_SUCCESS) {
        OH_PixelmapImageInfo_Release(imageInfo);
        return nullptr;
    }
    OH_PixelmapImageInfo_GetWidth(imageInfo, &width);
    OH_PixelmapImageInfo_GetHeight(imageInfo, &height);
    OH_PixelmapImageInfo_Release(imageInfo);
    OH_Drawing_Bitmap *bitmap = OH_Drawing_BitmapCreate();
    if (bitmap == nullptr) {
        return nullptr;
    }

    OH_Drawing_BitmapFormat bitmapFormat = {.colorFormat = COLOR_FORMAT_RGBA_8888, .alphaFormat = ALPHA_FORMAT_PREMUL};

    OH_Drawing_BitmapBuild(bitmap, width, height, &bitmapFormat);
    OH_Drawing_Canvas *canvas = OH_Drawing_CanvasCreate();
    if (canvas == nullptr) {
        OH_Drawing_BitmapDestroy(bitmap);
        return nullptr;
    }
    OH_Drawing_CanvasBind(canvas, bitmap);
    OH_Drawing_Rect *srcRect = OH_Drawing_RectCreate(0, 0, width, height);
    OH_Drawing_Rect *dstRect = OH_Drawing_RectCreate(0, 0, width, height);
    auto samplingOpts = OH_Drawing_SamplingOptionsCreate(FILTER_MODE_LINEAR, MIPMAP_MODE_NONE);

    OH_Drawing_PixelMap *pixelMap = OH_Drawing_PixelMapGetFromOhPixelMapNative(nativePixelMap);
    OH_Drawing_CanvasDrawPixelMapRect(canvas, pixelMap, srcRect, dstRect, samplingOpts);
    OH_Drawing_CanvasDestroy(canvas);
    return bitmap;
}

OH_Drawing_Path *CanvasRenderPath::CreatePath()
{
    auto path = OH_Drawing_PathCreate();
    if (path == nullptr) {
        LOGE("Failed to create OHOS Drawing Path");
    }
    return path;
}

CanvasRenderPath::CanvasRenderPath() : m_FillRule(rive::FillRule::nonZero), m_ohosPath(CreatePath())
{
    LOGD("CanvasRenderPath created");
}

static void addRawPathToCanvasPath(OH_Drawing_Path *ohosPath, const rive::RawPath &path)
{
    if (!ohosPath) {
        LOGE("addRawPathToCanvasPath: null path");
        return;
    }

    auto points = path.points();
    auto pointsData = points.data();
    auto pathVerbs = path.verbs();

    for (auto verb : pathVerbs) {
        switch (verb) {
            case rive::PathVerb::move: {
                auto point = pointsData[0];
                OH_Drawing_PathMoveTo(ohosPath, point.x, point.y);
                pointsData += 1;
                break;
            }
            case rive::PathVerb::line: {
                auto point = pointsData[0];
                OH_Drawing_PathLineTo(ohosPath, point.x, point.y);
                pointsData += 1;
                break;
            }
            case rive::PathVerb::cubic: {
                auto cp0 = pointsData[0];
                auto cp1 = pointsData[1];
                auto to = pointsData[INDEX_TWO];
                OH_Drawing_PathCubicTo(ohosPath, cp0.x, cp0.y, cp1.x, cp1.y, to.x, to.y);
                pointsData += INDEX_THREE;
                break;
            }
            case rive::PathVerb::close: {
                OH_Drawing_PathClose(ohosPath);
                break;
            }
            default:
                LOGW("Unknown path verb: %d", static_cast<int>(verb));
                break;
        }
    }
}

CanvasRenderPath::CanvasRenderPath(rive::RawPath &path, rive::FillRule rule)
    : m_FillRule(rule), m_ohosPath(CreatePath())
{
    addRawPathToCanvasPath(m_ohosPath, path);
    LOGD("CanvasRenderPath created from RawPath");
}

CanvasRenderPath::~CanvasRenderPath()
{
    OH_Drawing_PathDestroy(m_ohosPath);
    LOGD("CanvasRenderPath destroyed");
}

void CanvasRenderPath::rewind()
{
    if (m_ohosPath) {
        OH_Drawing_PathReset(m_ohosPath);
    }
}

void CanvasRenderPath::addRawPath(const rive::RawPath &path)
{
    addRawPathToCanvasPath(m_ohosPath, path);
}

void CanvasRenderPath::addRenderPath(rive::RenderPath *path, const rive::Mat2D &transform)
{
    if (!path || !m_ohosPath) {
        LOGE("addRenderPath: invalid parameters");
        return;
    }

    auto otherPath = reinterpret_cast<CanvasRenderPath *>(path);
    if (!otherPath->m_ohosPath) {
        LOGE("addRenderPath: other path is null");
        return;
    }

    // 创建变换矩阵并添加路�?
    auto matrix = RiveMatrixToOhosMatrix(transform);
    OH_Drawing_PathAddPath(m_ohosPath, otherPath->m_ohosPath, matrix);
}

void CanvasRenderPath::moveTo(float x, float y)
{
    if (m_ohosPath) {
        OH_Drawing_PathMoveTo(m_ohosPath, x, y);
    }
}

void CanvasRenderPath::lineTo(float x, float y)
{
    if (m_ohosPath) {
        OH_Drawing_PathLineTo(m_ohosPath, x, y);
    }
}

void CanvasRenderPath::cubicTo(float ox, float oy, float ix, float iy, float x, float y)
{
    if (m_ohosPath) {
        OH_Drawing_PathCubicTo(m_ohosPath, ox, oy, ix, iy, x, y);
    }
}

void CanvasRenderPath::close()
{
    if (m_ohosPath) {
        OH_Drawing_PathClose(m_ohosPath);
    }
}

void CanvasRenderPath::fillRule(rive::FillRule value)
{
    m_FillRule = value;
    if (!m_ohosPath) {
        return;
    }

    OH_Drawing_PathFillType fillType;
    switch (m_FillRule) {
        case rive::FillRule::evenOdd:
            fillType = PATH_FILL_TYPE_EVEN_ODD;
            break;
        case rive::FillRule::nonZero:
        case rive::FillRule::clockwise:
        default:
            fillType = PATH_FILL_TYPE_WINDING;
            break;
    }

    OH_Drawing_PathSetFillType(m_ohosPath, fillType);
}

LinearGradientCanvasShader::LinearGradientCanvasShader(const LinearData &position,
                                                       const rive::ColorInt colors[], // [count]
                                                       const float stops[],           // [count]
                                                       size_t count)
{
    if (count == 0 || !colors || !stops) {
        LOGE("LinearGradientCanvasShader: invalid parameters");
        return;
    }

    std::vector<uint32_t> colorsVec;
    colorsVec.reserve(count);
    for (size_t i = 0; i < count; ++i) {
        colorsVec.emplace_back(colors[i]);
    }

    m_OhosShader = OH_Drawing_ShaderEffectCreateLinearGradient(OH_Drawing_PointCreate(position.sx, position.sy),
                                                               OH_Drawing_PointCreate(position.ex, position.ey),
                                                               colorsVec.data(), stops, count, CLAMP);
    if (m_OhosShader == nullptr) {
        LOGE("Failed to create LinearGradientCanvasShader");
    } else {
        LOGD("LinearGradientCanvasShader created successfully");
    }
}

RadialGradientCanvasShader::RadialGradientCanvasShader(const RadialData &position,
                                                       const rive::ColorInt colors[], // [count]
                                                       const float stops[],           // [count]
                                                       size_t count)
{
    if (count == 0 || !colors || !stops) {
        LOGE("RadialGradientCanvasShader: invalid parameters");
        return;
    }

    std::vector<uint32_t> colorsVec;
    colorsVec.reserve(count);
    for (size_t i = 0; i < count; ++i) {
        colorsVec.emplace_back(colors[i]);
    }

    m_OhosShader = OH_Drawing_ShaderEffectCreateRadialGradient(OH_Drawing_PointCreate(position.cx, position.cy),
                                                               position.radius, colorsVec.data(), stops, count, CLAMP);
    if (m_OhosShader == nullptr) {
        LOGE("Failed to create RadialGradientCanvasShader");
    } else {
        LOGD("RadialGradientCanvasShader created successfully");
    }
}

CanvasRenderPaint::CanvasRenderPaint()
{
    m_ohPaint = new OhosPaint();
    if (m_ohPaint == nullptr) {
        LOGE("Failed to create OhosPaint");
        return;
    }
    // Default Fill Mode
    m_ohPaint->brush = OH_Drawing_BrushCreate();
    if (m_ohPaint->brush == nullptr) {
        LOGE("Failed to create Brush");
        return;
    }
    OH_Drawing_BrushSetAntiAlias(m_ohPaint->brush, true);
    LOGD("CanvasRenderPaint created successfully");
}

CanvasRenderPaint::~CanvasRenderPaint()
{
    if (m_ohPaint->style == OhosPaint::PaintStyle::STROKE) {
        OH_Drawing_PenDestroy(m_ohPaint->pen);
    } else {
        OH_Drawing_BrushDestroy(m_ohPaint->brush);
    }
    delete m_ohPaint;
    LOGD("CanvasRenderPaint destroyed");
}

void CanvasRenderPaint::style(rive::RenderPaintStyle style)
{
    SetStyle(m_ohPaint, style);
}

void CanvasRenderPaint::thickness(float value)
{
    SetThickness(m_ohPaint, value);
}

void CanvasRenderPaint::join(rive::StrokeJoin join)
{
    SetJoin(m_ohPaint, join);
}

void CanvasRenderPaint::color(rive::ColorInt value)
{
    SetColor(m_ohPaint, value);
}

void CanvasRenderPaint::cap(rive::StrokeCap cap)
{
    SetCap(m_ohPaint, cap);
}

void CanvasRenderPaint::shader(rive::rcp<rive::RenderShader> shader)
{
    OH_Drawing_ShaderEffect *shaderObject =
        shader == nullptr ? nullptr : reinterpret_cast<CanvasShader *>(shader.get())->ohosShader();
    SetShader(m_ohPaint, shaderObject);
}

void CanvasRenderPaint::blendMode(rive::BlendMode blendMode)
{
    SetBlendMode(m_ohPaint, blendMode);
}

void CanvasRenderPaint::SetStyle(OhosPaint *paint, rive::RenderPaintStyle style)
{
    if (style == rive::RenderPaintStyle::stroke) {
        if (paint->style == OhosPaint::PaintStyle::STROKE) {
            return;
        }
        paint->style = OhosPaint::PaintStyle::STROKE;

        if (!paint->brush) {
            OH_Drawing_BrushDestroy(paint->brush);
            paint->brush = nullptr;
        }

        paint->pen = OH_Drawing_PenCreate();
        OH_Drawing_PenSetAntiAlias(paint->pen, true);
    } else {
        if (paint->style == OhosPaint::PaintStyle::FILL) {
            return;
        }
        paint->style = OhosPaint::PaintStyle::FILL;

        if (!paint->pen) {
            OH_Drawing_PenDestroy(paint->pen);
            paint->pen = nullptr;
        }

        paint->brush = OH_Drawing_BrushCreate();
        OH_Drawing_BrushSetAntiAlias(paint->brush, true);
    }
}

void CanvasRenderPaint::SetThickness(OhosPaint *paint, float value)
{
    if (paint->style != OhosPaint::PaintStyle::STROKE || paint->pen == nullptr) {
        LOGE("Set thickness error: style error");
        return;
    }
    OH_Drawing_PenSetWidth(paint->pen, value);
}

void CanvasRenderPaint::SetJoin(OhosPaint *paint, rive::StrokeJoin value)
{
    if (paint->style != OhosPaint::PaintStyle::STROKE || paint->pen == nullptr) {
        LOGE("Set join error: style error");
        return;
    }

    OH_Drawing_PenLineJoinStyle joinStyle;
    switch (value) {
        case rive::StrokeJoin::round:
            joinStyle = LINE_ROUND_JOIN;
            break;
        case rive::StrokeJoin::bevel:
            joinStyle = LINE_BEVEL_JOIN;
            break;
        default:
        case rive::StrokeJoin::miter:
            joinStyle = LINE_MITER_JOIN;
            break;
    }

    OH_Drawing_PenSetJoin(paint->pen, joinStyle);
}

void CanvasRenderPaint::SetColor(OhosPaint *paint, rive::ColorInt value)
{
    if (paint->style == OhosPaint::PaintStyle::STROKE && paint->pen != nullptr) {
        OH_Drawing_PenSetColor(paint->pen, value);
    } else if (paint->style == OhosPaint::PaintStyle::FILL && paint->brush != nullptr) {
        OH_Drawing_BrushSetColor(paint->brush, value);
    } else {
        LOGE("Set Color error: style mismatch");
    }
}

void CanvasRenderPaint::SetCap(OhosPaint *paint, rive::StrokeCap value)
{
    if (paint->style != OhosPaint::PaintStyle::STROKE || paint->pen == nullptr) {
        LOGE("Set cap error: style error");
        return;
    }
    OH_Drawing_PenLineCapStyle capStyle;
    switch (value) {
        case rive::StrokeCap::butt:
            capStyle = LINE_FLAT_CAP;
            break;
        case rive::StrokeCap::round:
            capStyle = LINE_ROUND_CAP;
            break;
        case rive::StrokeCap::square:
            capStyle = LINE_SQUARE_CAP;
            break;
        default:
            capStyle = LINE_FLAT_CAP;
            break;
    }
    OH_Drawing_PenSetCap(paint->pen, capStyle);
}

void CanvasRenderPaint::SetShader(OhosPaint *paint, OH_Drawing_ShaderEffect *shader)
{
    if (paint->style == OhosPaint::PaintStyle::STROKE && paint->pen != nullptr) {
        OH_Drawing_PenSetShaderEffect(paint->pen, shader);
    } else if (paint->style == OhosPaint::PaintStyle::FILL && paint->brush != nullptr) {
        OH_Drawing_BrushSetShaderEffect(paint->brush, shader);
    } else {
        LOGE("Set Shader error: style mismatch");
    }
}

OhosPaint *CanvasRenderPaint::CreateOhosPaint()
{
    auto ohPaint = new OhosPaint();
    // Default Fill Mode
    ohPaint->brush = OH_Drawing_BrushCreate();
    if (ohPaint->brush == nullptr) {
        LOGE("Failed to create Brush");
        return nullptr;
    }
    OH_Drawing_BrushSetAntiAlias(ohPaint->brush, true);
    LOGD("CanvasRenderPaint created successfully");

    return ohPaint;
}

void CanvasRenderPaint::SetBlendMode(OhosPaint *paint, rive::BlendMode value)
{
    auto blendMode = RiveBlendModeToOhosBlendMode(value);
    if (paint->style == OhosPaint::PaintStyle::STROKE && paint->pen != nullptr) {
        OH_Drawing_PenSetBlendMode(paint->pen, blendMode);
    } else if (paint->style == OhosPaint::PaintStyle::FILL && paint->brush != nullptr) {
        OH_Drawing_BrushSetBlendMode(paint->brush, blendMode);
    } else {
        LOGE("Set Blend Mode error: style mismatch");
    }
}

void CanvasRenderPaint::SetPaintAlpha(OhosPaint *paint, int alpha)
{
    if (paint->style == OhosPaint::PaintStyle::STROKE && paint->pen != nullptr) {
        OH_Drawing_PenSetAlpha(paint->pen, alpha);
    } else if (paint->style == OhosPaint::PaintStyle::FILL && paint->brush != nullptr) {
        OH_Drawing_BrushSetAlpha(paint->brush, alpha);
    } else {
        LOGE("Set Alpha error: style mismatch");
    }
}

OH_Drawing_Bitmap *CanvasRenderImage::CreateBitmapFrom(rive::Span<const uint8_t> &encodedBytes)
{
    OH_ImageSourceNative *imageSource = nullptr;
    std::unique_ptr<uint8_t[]> buffer = std::make_unique<uint8_t[]>(encodedBytes.size());
    std::copy(encodedBytes.data(), encodedBytes.data() + encodedBytes.size(), buffer.get());
    auto result = OH_ImageSourceNative_CreateFromData(buffer.get(), encodedBytes.size(), &imageSource);
    if (result != IMAGE_SUCCESS || imageSource == nullptr) {
        LOGE("CreateBitmapFrom() - Failed to create ImageSourceNative.");
        return nullptr;
    }

    OH_DecodingOptions *decodingOptions = nullptr;
    result = OH_DecodingOptions_Create(&decodingOptions);
    if (result != IMAGE_SUCCESS || decodingOptions == nullptr) {
        LOGE("CreateBitmapFrom() - Failed to create Decoding Options.");
        OH_ImageSourceNative_Release(imageSource);
        return nullptr;
    }

    OH_PixelmapNative *pixelmap = nullptr;
    result = OH_ImageSourceNative_CreatePixelmap(imageSource, decodingOptions, &pixelmap);
    OH_DecodingOptions_Release(decodingOptions);
    OH_ImageSourceNative_Release(imageSource);
    if (result != IMAGE_SUCCESS || pixelmap == nullptr) {
        LOGE("CreateBitmapFrom() - Failed to create Pixel Map.");
        return nullptr;
    }
    auto bitmap = ConvertPixelMapToBitmap(pixelmap);
    OH_PixelmapNative_Release(pixelmap);
    return bitmap;
}

CanvasRenderImage::CanvasRenderImage(rive::Span<const uint8_t> encodedBytes)
{
    m_ohosBitmap = CreateBitmapFrom(encodedBytes);
    if (m_ohosBitmap == nullptr) {
        LOGE("CanvasRenderImage() - Failed to create a bitmap.");
        return;
    }
    m_Width = OH_Drawing_BitmapGetWidth(m_ohosBitmap);
    m_Height = OH_Drawing_BitmapGetHeight(m_ohosBitmap);

    m_ohosPaint = CanvasRenderPaint::CreateOhosPaint();
    CanvasRenderPaint::SetStyle(m_ohosPaint, rive::RenderPaintStyle::fill);
}

CanvasRenderImage::CanvasRenderImage(OH_PixelmapNative *pixelMap)
{
    if (pixelMap == nullptr) {
        LOGE("CanvasRenderImage(jBitmap) - pixelMap is null.");
        return;
    }

    m_ohosBitmap = ConvertPixelMapToBitmap(pixelMap);
    OH_PixelmapNative_Release(pixelMap);
    m_Width = OH_Drawing_BitmapGetWidth(m_ohosBitmap);
    m_Height = OH_Drawing_BitmapGetHeight(m_ohosBitmap);

    m_ohosPaint = CanvasRenderPaint::CreateOhosPaint();
}

CanvasRenderImage::~CanvasRenderImage()
{
    if (m_ohosBitmap) {
        OH_Drawing_BitmapDestroy(m_ohosBitmap);
        m_ohosBitmap = nullptr;
    }
    if (m_ohosPaint) {
        if (m_ohosPaint->pen) {
            OH_Drawing_PenDestroy(m_ohosPaint->pen);
        }
        if (m_ohosPaint->brush) {
            OH_Drawing_BrushDestroy(m_ohosPaint->brush);
        }

        delete m_ohosPaint;
    }
}

OH_Drawing_ShaderEffect *CanvasRenderImage::CreateBitmapShader(OH_Drawing_Bitmap *bitmap)
{
    if (!bitmap) {
        LOGE("CreateBitmapShader: null bitmap");
        return nullptr;
    }

    auto image = OH_Drawing_ImageCreate();
    auto result = OH_Drawing_ImageBuildFromBitmap(image, bitmap);
    if (!result) {
        LOGE("CreateBitmapShader: Image Build From Bitmap failed");
        return nullptr;
    }

    OH_Drawing_SamplingOptions *samplingOptions =
        OH_Drawing_SamplingOptionsCreate(FILTER_MODE_LINEAR, MIPMAP_MODE_NONE);

    OH_Drawing_ShaderEffect *shader =
        OH_Drawing_ShaderEffectCreateImageShader(image, CLAMP, CLAMP, samplingOptions, nullptr);
    if (shader == nullptr) {
        LOGE("Failed to create bitmap shader");
    }

    OH_Drawing_SamplingOptionsDestroy(samplingOptions);
    OH_Drawing_ImageDestroy(image);
    return shader;
}

} // namespace ohos_rive
