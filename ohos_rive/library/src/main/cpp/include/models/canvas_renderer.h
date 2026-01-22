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

#ifndef OHOS_RIVE_CANVAS_RENDERER_H
#define OHOS_RIVE_CANVAS_RENDERER_H

#include "../helpers/exception_handler.h"
#include "../helpers/general.h"
#include "rive/renderer.hpp"
#include <native_drawing/drawing_canvas.h>
#include <native_drawing/drawing_surface.h>

namespace ohos_rive {
class CanvasRenderer : public rive::Renderer {
protected:
    OH_Drawing_Canvas *m_ohCanvas = nullptr;
    int m_width = -1;
    int m_height = -1;

private:
    static OH_Drawing_Canvas *GetCanvas(OH_Drawing_Surface *surface)
    {
        return OH_Drawing_SurfaceGetCanvas(surface);
    }

    static void Clear(OH_Drawing_Canvas *canvas)
    {
        OH_Drawing_CanvasClear(canvas, 0x00000000);
    }

public:
    ~CanvasRenderer() override
    {
        if (m_ohCanvas != nullptr) {
            m_ohCanvas = nullptr;
        }
    }
    void save() override;
    void restore() override;
    void transform(const rive::Mat2D &transform) override;
    void clipPath(rive::RenderPath *path) override;
    void drawPath(rive::RenderPath *path, rive::RenderPaint *paint) override;
    void drawImage(const rive::RenderImage *, rive::ImageSampler options, rive::BlendMode, float opacity) override;
    void drawImageMesh(const rive::RenderImage *,
                       rive::ImageSampler options,
                       rive::rcp<rive::RenderBuffer> vertices_f32,
                       rive::rcp<rive::RenderBuffer> uvCoords_f32,
                       rive::rcp<rive::RenderBuffer> indices_u16,
                       uint32_t vertexCount,
                       uint32_t indexCount,
                       rive::BlendMode,
                       float opacity) override;

    [[nodiscard]] int Width() const
    {
        return m_width;
    }
    [[nodiscard]] int Height() const
    {
        return m_height;
    }

    void BindCanvas(OH_Drawing_Canvas *canvas)
    {
        // Old canvas needs to be unbound as it might not be valid anymore.
        m_ohCanvas = canvas;
        m_width = OH_Drawing_CanvasGetWidth(m_ohCanvas);
        m_height = OH_Drawing_CanvasGetHeight(m_ohCanvas);
        Clear(m_ohCanvas);
    }

    void UnlockAndPost()
    {
        m_width = -1;
        m_height = -1;
    }
};
} // namespace ohos_rive

#endif // OHOS_RIVE_CANVAS_RENDERER_H

