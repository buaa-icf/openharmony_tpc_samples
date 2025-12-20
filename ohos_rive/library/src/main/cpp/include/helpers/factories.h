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

#ifndef OHOS_RIVE_FACTORIES_H
#define OHOS_RIVE_FACTORIES_H

#include "helpers/render_type.h"
#include "helpers/worker_ref.h"
#include "napi/native_api.h"
#include "rive/refcnt.hpp"
#include "rive/renderer.hpp"
#include "rive/renderer/rive_render_factory.hpp"
#include "rive/renderer/rive_render_image.hpp"
#include "utils/factory_utils.hpp"
#include <arkui/native_node_napi.h>
#include <vector>

using namespace rive;

namespace ohos_rive {
// Forward declare template specialization.
template <typename AssetType>
rive::rcp<AssetType> decode(rive::Span<const uint8_t>, RendererType);

template <typename AssetType>
rive::rcp<AssetType> decodeAsset(napi_env env, napi_value byteArrayValue, int32_t rendererTypeIdx)
{
    void *data = nullptr;
    size_t count = 0;

    // 检查是否为 TypedArray (Uint8Array)
    bool isTypedArray = false;
    napi_is_typedarray(env, byteArrayValue, &isTypedArray);

    if (isTypedArray) {
        napi_typedarray_type arrayType;
        napi_value buffer;
        size_t byteOffset;
        napi_get_typedarray_info(env, byteArrayValue, &arrayType, &count, &data, &buffer, &byteOffset);

        if (arrayType != napi_uint8_array) {
            return nullptr;
        }
    } else {
        bool isArrayBuffer = false;
        napi_is_arraybuffer(env, byteArrayValue, &isArrayBuffer);
        if (isArrayBuffer) {
            napi_get_arraybuffer_info(env, byteArrayValue, &data, &count);
        } else {
            return nullptr;
        }
    }

    rive::Span<const uint8_t> dataSpan(reinterpret_cast<const uint8_t *>(data), count);
    RendererType rendererType = static_cast<RendererType>(rendererTypeIdx);
    rive::rcp<AssetType> asset = decode<AssetType>(dataSpan, rendererType);

    return asset;
}

template <typename T>
void ReleaseAsset(uint64_t ref)
{
    if (ref == 0 || ref == 0x9) {
        LOGE("Attempt to release invalid pointer: %lu", ref);
        return;
    }

    auto *asset = reinterpret_cast<T *>(ref);
    if (asset) {
        delete asset;
    }
}

class OhosRiveRenderFactory : public rive::RiveRenderFactory {
public:
    explicit OhosRiveRenderFactory(napi_env env) : env(env) {}
    rive::rcp<rive::RenderBuffer> makeRenderBuffer(rive::RenderBufferType, rive::RenderBufferFlags, size_t) override;

    rive::rcp<rive::RenderImage> decodeImage(rive::Span<const uint8_t>) override;

    bool IsMesh()
    {
        return m_isMesh;
    }

private:
    napi_env env;
    bool m_isMesh = false;
};

class OhosImage : public rive::RiveRenderImage {
public:
    OhosImage(int width, int height, std::unique_ptr<const uint8_t[]> imageDataRGBAPtr);

    ~OhosImage() override;

private:
    const rive::rcp<RefWorker> m_glWorker;
    RefWorker::WorkID m_textureCreationWorkID;
};

class OhosCanvasFactory : public Factory {
public:
    rcp<RenderBuffer> makeRenderBuffer(RenderBufferType type, RenderBufferFlags flags, size_t sizeInBytes) override;

    rcp<RenderImage> decodeImage(Span<const uint8_t> encodedBytes) override;

    rcp<RenderShader> makeLinearGradient(float sx,
                                         float sy,
                                         float ex,
                                         float ey,
                                         const ColorInt colors[], // [count]
                                         const float stops[],     // [count]
                                         size_t count) override;

    rcp<RenderShader> makeRadialGradient(float cx,
                                         float cy,
                                         float radius,
                                         const ColorInt colors[], // [count]
                                         const float stops[],     // [count]
                                         size_t count) override;

    rcp<RenderPath> makeRenderPath(RawPath &rawPath, FillRule fillRule) override;

    rcp<RenderPath> makeEmptyRenderPath() override;

    rcp<RenderPaint> makeRenderPaint() override;
};

// Node-API 辅助函数
class NAPIHelpers {
public:
    static bool GetUint8ArrayData(napi_env env, napi_value value, const uint8_t **data, size_t *length)
    {
        bool isTypedArray = false;
        napi_is_typedarray(env, value, &isTypedArray);

        if (!isTypedArray) {
            return false;
        }

        napi_typedarray_type arrayType;
        napi_value buffer;
        size_t byteOffset;
        void *arrayData = nullptr;
        size_t arrayLength = 0;

        napi_status status =
            napi_get_typedarray_info(env, value, &arrayType, &arrayLength, &arrayData, &buffer, &byteOffset);
        if (status != napi_ok || arrayType != napi_uint8_array) {
            return false;
        }

        *data = static_cast<const uint8_t *>(arrayData);
        *length = arrayLength;
        return true;
    }

    static napi_value CreatePointerValue(napi_env env, void *ptr)
    {
        napi_value result;
        napi_status status = napi_create_bigint_uint64(env, reinterpret_cast<uint64_t>(ptr), &result);
        if (status != napi_ok) {
            LOGE("Failed to create pointer argument");
            return nullptr;
        }
        return result;
    }

    template <typename T>
    static T *GetPointerFromValue(napi_env env, napi_value value)
    {
        uint64_t ptrValue = 0;
        bool lossless = false;
        napi_status status = napi_get_value_bigint_uint64(env, value, &ptrValue, &lossless);
        if (status != napi_ok || !lossless) {
            LOGE("Failed to get pointer value");
            return nullptr;
        }
        return reinterpret_cast<T *>(ptrValue);
    }
};

extern OhosRiveRenderFactory *g_riveFactory;
} // namespace ohos_rive
#endif // OHOS_RIVE_FACTORIES_H

