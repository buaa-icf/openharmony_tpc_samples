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

#ifndef OHOS_RIVE_CANVAS_RENDER_OBJECTS_H
#define OHOS_RIVE_CANVAS_RENDER_OBJECTS_H

#include "../../include/helpers/general.h"
#include "../../include/helpers/worker_ref.h"
#include "rive/component_dirt.hpp"
#include "rive/shapes/shape.hpp"
#include "rive/text/font_hb.hpp"
#include <memory>

#include <multimedia/image_framework/image/image_source_native.h>
#include <multimedia/image_framework/image/pixelmap_native.h>
#include <native_drawing/drawing_bitmap.h>
#include <native_drawing/drawing_brush.h>
#include <native_drawing/drawing_canvas.h>
#include <native_drawing/drawing_color.h>
#include <native_drawing/drawing_image.h>
#include <native_drawing/drawing_matrix.h>
#include <native_drawing/drawing_path.h>
#include <native_drawing/drawing_pen.h>
#include <native_drawing/drawing_pixel_map.h>
#include <native_drawing/drawing_point.h>
#include <native_drawing/drawing_rect.h>
#include <native_drawing/drawing_sampling_options.h>
#include <native_drawing/drawing_shader_effect.h>

namespace ohos_rive {

struct LinearData {
    float sx = 0.0f;
    float sy = 0.0f;
    float ex = 0.0f;
    float ey = 0.0f;
};

struct RadialData {
    float cx = 0.0f;
    float cy = 0.0f;
    float radius = 0.0f;
};

class CanvasRenderPath : public rive::RenderPath {
private:
    rive::FillRule m_FillRule;
    OH_Drawing_Path *m_ohosPath = nullptr;

    static OH_Drawing_Path *CreatePath();

public:
    CanvasRenderPath();

    CanvasRenderPath(rive::RawPath &, rive::FillRule);

    ~CanvasRenderPath() override;

    OH_Drawing_Path *ohosPath() const
    {
        return m_ohosPath;
    }

    void rewind() override;

    void addRenderPath(rive::RenderPath *, const rive::Mat2D &) override;
    void addRawPath(const rive::RawPath &path) override;

    void moveTo(float x, float y) override;

    void lineTo(float x, float y) override;

    void cubicTo(float ox, float oy, float ix, float iy, float x, float y) override;

    void close() override;

    void fillRule(rive::FillRule value) override;
};

class CanvasShader : public rive::RenderShader {
protected:
    OH_Drawing_ShaderEffect *m_OhosShader = nullptr;

public:
    CanvasShader() = default;

    ~CanvasShader() override
    {
        if (m_OhosShader != nullptr) {
            OH_Drawing_ShaderEffectDestroy(m_OhosShader);
        }
    }

    OH_Drawing_ShaderEffect *ohosShader() const
    {
        return m_OhosShader;
    }
};

class LinearGradientCanvasShader : public CanvasShader {
public:
    LinearGradientCanvasShader(const LinearData &position,
                               const rive::ColorInt colors[], // [count]
                               const float stops[],           // [count]
                               size_t count);
};

class RadialGradientCanvasShader : public CanvasShader {
public:
    RadialGradientCanvasShader(const RadialData &position,
                               const rive::ColorInt colors[], // [count]
                               const float stops[],           // [count]
                               size_t count);
};

typedef struct OhosPaint {
    enum class PaintStyle { FILL, STROKE };
    OH_Drawing_Pen *pen = nullptr;
    OH_Drawing_Brush *brush = nullptr;
    PaintStyle style = PaintStyle::FILL;
} OhosPaint;

class CanvasRenderPaint : public rive::RenderPaint {
private:
    OhosPaint *m_ohPaint;

public:
    CanvasRenderPaint();

    ~CanvasRenderPaint();

    void style(rive::RenderPaintStyle) override;

    void thickness(float) override;

    void join(rive::StrokeJoin) override;

    void color(rive::ColorInt) override;

    void cap(rive::StrokeCap) override;

    void blendMode(rive::BlendMode) override;

    void shader(rive::rcp<rive::RenderShader>) override;

    void invalidateStroke() override {}

    OhosPaint *GetOhosPaint() const
    {
        return m_ohPaint;
    }

    static OhosPaint *CreateOhosPaint();

    static void SetStyle(OhosPaint *, rive::RenderPaintStyle);

    static void SetThickness(OhosPaint *, float value);

    static void SetJoin(OhosPaint *, rive::StrokeJoin);

    static void SetColor(OhosPaint *, rive::ColorInt);

    static void SetCap(OhosPaint *, rive::StrokeCap);

    static void SetBlendMode(OhosPaint *, rive::BlendMode);

    static void SetShader(OhosPaint *, OH_Drawing_ShaderEffect *);

    static void SetPaintAlpha(OhosPaint *, int);
};

class CanvasRenderImage : public rive::RenderImage {
private:
    OH_Drawing_Bitmap *m_ohosBitmap = nullptr;
    OhosPaint *m_ohosPaint = nullptr;

    static OH_Drawing_Bitmap *CreateBitmapFrom(rive::Span<const uint8_t> &);

public:
    explicit CanvasRenderImage(rive::Span<const uint8_t> encodedBytes);
    explicit CanvasRenderImage(OH_PixelmapNative *pixelMap);

    ~CanvasRenderImage();

    OH_Drawing_Bitmap *OhosBitmap() const
    {
        return m_ohosBitmap;
    }

    OhosPaint *OhosPaint() const
    {
        return m_ohosPaint;
    }

    // 创建位图着色器
    static OH_Drawing_ShaderEffect *CreateBitmapShader(OH_Drawing_Bitmap *bitmap);
};

OH_Drawing_BlendMode RiveBlendModeToOhosBlendMode(rive::BlendMode value);

} // namespace ohos_rive
#endif // OHOS_RIVE_CANVAS_RENDER_OBJECTS_H

