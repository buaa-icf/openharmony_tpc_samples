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

#ifndef OHOS_RIVE_MPF_DIMENSIONS_HELPER_H
#define OHOS_RIVE_MPF_DIMENSIONS_HELPER_H

#include "rive/renderer.hpp"
#include <napi/native_api.h>

namespace ohos_rive {
constexpr size_t INDEX_THREE = 3;
class DimensionsHelper : public rive::Renderer {
private:
    float m_width;
    float m_height;
    float m_scaleX;
    float m_scaleY;
    void save() override {}
    void restore() override {}
    void transform(const rive::Mat2D &transform) override
    {
        m_scaleX = transform[0];
        m_scaleY = transform[INDEX_THREE];
    }
    void drawPath(rive::RenderPath *path, rive::RenderPaint *paint) override {}

    void clipPath(rive::RenderPath *path) override {}

    void drawImage(const rive::RenderImage *image,
                   const rive::ImageSampler options,
                   rive::BlendMode value,
                   float opacity) override
    {
    }

    void drawImageMesh(const rive::RenderImage *image,
                       const rive::ImageSampler options,
                       rive::rcp<rive::RenderBuffer> vertices_f32,
                       rive::rcp<rive::RenderBuffer> uvCoords_f32,
                       rive::rcp<rive::RenderBuffer> indices_u16,
                       uint32_t vertexCount,
                       uint32_t indexCount,
                       rive::BlendMode blendMode,
                       float opacity) override
    {
    }

public:
    DimensionsHelper() : m_width(0.0f), m_height(0.0f), m_scaleX(1.0f), m_scaleY(1.0f) {}
    // clang-format off
    ~DimensionsHelper() override = default;
    // clang-format on

    [[nodiscard]] float Width() const
    {
        return m_width;
    }
    [[nodiscard]] float Height() const
    {
        return m_height;
    }
    [[nodiscard]] float ScaleX() const
    {
        return m_scaleX;
    }
    [[nodiscard]] float ScaleY() const
    {
        return m_scaleY;
    }

    rive::AABB computeDimensions(rive::Fit fit,
                                 rive::Alignment alignment,
                                 const rive::AABB &frame,
                                 const rive::AABB &content,
                                 float scaleFactor);
};
} // namespace ohos_rive
#endif // OHOS_RIVE_MPF_DIMENSIONS_HELPER_H

