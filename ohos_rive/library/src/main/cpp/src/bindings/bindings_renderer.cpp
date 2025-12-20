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

#include "bindings/bindings_renderer.h"
#include "helpers/general.h"
#include "helpers/resource.h"
#include "models/renderer.h"
#include "models/worker_impl.h"
#include "refs.h"
#include <js_native_api.h>
#include <thread>
namespace ohos_rive {
constexpr size_t ARG_NUM_ONE = 1;
constexpr size_t ARG_NUM_TWO = 2;
constexpr size_t ARG_NUM_THREE = 3;
constexpr size_t ARG_NUM_FOUR = 4;
constexpr size_t ARG_NUM_FIVE = 5;
constexpr size_t ARG_NUM_SIX = 6;
constexpr size_t ARG_NUM_SEVEN = 7;

uint64_t GetRenderer(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1];
    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < 1) {
        LOGE("Failed to get callback info for GetRenderer");
        return 0;
    }

    uint64_t rendererPtr;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[0], &rendererPtr, &lossless);
    if (status != napi_ok || rendererPtr <= 0 || !lossless) {
        LOGE("Failed to get value for GetRenderer");
        return 0;
    }
    return rendererPtr;
}

OHNativeWindow *CreateNativeWindow(int64_t surfaceId)
{
    OHNativeWindow *nativeWindow;
    auto ret = OH_NativeWindow_CreateNativeWindowFromSurfaceId(surfaceId, &nativeWindow);
    if (ret != 0) {
        LOGE("Failed to create OHNativeWindow for RendererCppSetSurface");
        return nullptr;
    }
    return nativeWindow;
}

napi_value RendererConstructor(napi_env env, napi_callback_info info)
{
    napi_value result;
    napi_get_undefined(env, &result);

    size_t argc = ARG_NUM_THREE; // 3: number of arguments expected for RendererConstructor
    napi_value args[ARG_NUM_THREE] = {nullptr};
    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_THREE) {
        LOGE("Failed to parse arguments for RendererConstructor");
        return result;
    }

    bool trace = false;
    status = napi_get_value_bool(env, args[1], &trace); // 1: index of trace parameter in args array
    if (status != napi_ok) {
        LOGE("Get trace parameter failed for RendererConstructor");
        return result;
    }

    RendererType type = RendererType::RIVE;
    int typeValue = 0;
    status = napi_get_value_int32(env, args[ARG_NUM_TWO], &typeValue); // 2: index of type parameter in args array
    if (status == napi_ok) {
        type = static_cast<RendererType>(typeValue);
    } else {
        LOGE("Get type parameter failed for RendererConstructor");
        return result;
    }

    auto *renderer = new Renderer(env, args[0], trace, type); // 0: index of renderer parameter in args array
    if (!renderer) {
        LOGE("Failed to create Renderer instance for RendererConstructor");
        return result;
    }

    RendererType actualType = renderer->GetRendererType();
    if (type != actualType) {
        auto ktRendererClass = GetObjectClass(env, args[0]);
        napi_value typeParam;
        status = napi_create_uint32(env, static_cast<int>(actualType), &typeParam);
        if (status != napi_ok) {
            LOGE("Failed to create actualType parameter: %{public}d", status);
            return result;
        }
        GetObjectFromMethod(env, ktRendererClass.Get(), "setRendererType", 1, &typeParam);
    }

    napi_value rendererRef;
    status = napi_create_bigint_uint64(env, reinterpret_cast<uint64_t>(renderer), &rendererRef);
    if (status != napi_ok) {
        LOGE("Failed to create napi value for renderer");
        delete renderer;
        return result;
    }
    return rendererRef;
}

napi_value RendererCppDelete(napi_env env, napi_callback_info info)
{
    auto rendererPtr = GetRenderer(env, info);
    auto *renderer = reinterpret_cast<Renderer *>(rendererPtr);
    if (renderer) {
        renderer->ScheduleDispose();
    }
    napi_value result;
    napi_get_undefined(env, &result);
    return result;
}

napi_value RendererCppStop(napi_env env, napi_callback_info info)
{
    auto rendererPtr = GetRenderer(env, info);
    auto *renderer = reinterpret_cast<Renderer *>(rendererPtr);
    if (renderer) {
        renderer->Stop();
    }
    napi_value result;
    napi_get_undefined(env, &result);
    return result;
}

napi_value RendererCppStart(napi_env env, napi_callback_info info)
{
    auto rendererPtr = GetRenderer(env, info);
    auto *renderer = reinterpret_cast<Renderer *>(rendererPtr);
    if (renderer) {
        renderer->Start();
    }
    napi_value result;
    napi_get_undefined(env, &result);
    return result;
}

napi_value RendererCppDoFrame(napi_env env, napi_callback_info info)
{
    auto rendererPtr = GetRenderer(env, info);
    auto *renderer = reinterpret_cast<Renderer *>(rendererPtr);
    if (renderer) {
        renderer->DoFrame();
    }
    napi_value result;
    napi_get_undefined(env, &result);
    return result;
}

napi_value RendererCppSetSurface(napi_env env, napi_callback_info info)
{
    napi_value result;
    napi_get_undefined(env, &result);

    auto rendererPtr = GetRenderer(env, info);
    auto *renderer = reinterpret_cast<Renderer *>(rendererPtr);
    if (!renderer) {
        return result;
    }

    napi_status status;
    size_t argc = ARG_NUM_TWO; // 2: number of arguments expected for RendererCppSetSurface
    napi_value args[ARG_NUM_TWO] = {nullptr};
    status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_TWO) {
        LOGE("Failed to parse arguments for RendererCppSetSurface");
        return result;
    }

    int64_t surfaceId;
    bool lossless = true;
    status = napi_get_value_bigint_int64(env, args[1], &surfaceId, &lossless);
    if (status != napi_ok) {
        LOGE("Failed to get surfaceId for RendererCppSetSurface");
        return result;
    }
    LOGI("surfaceId %{public}ld", surfaceId);

    if (renderer->GetRendererType() != RendererType::CANVAS) {
        OHNativeWindow *nativeWindow = CreateNativeWindow(surfaceId);
        SurfaceVariant surfaceVariant = reinterpret_cast<EGLNativeWindowType>(nativeWindow);
        renderer->SetSurface(surfaceVariant);
        if (nativeWindow) {
            OH_NativeWindow_DestroyNativeWindow(nativeWindow);
        }
    } else {
        OHNativeWindow *nativeWindow = CreateNativeWindow(surfaceId);
        SurfaceVariant surfaceVariant = nativeWindow;
        renderer->SetSurface(surfaceVariant);
        if (nativeWindow) {
            OH_NativeWindow_DestroyNativeWindow(nativeWindow);
        }
    }

    return result;
}

napi_value RendererCppDestroySurface(napi_env env, napi_callback_info info)
{
    auto rendererPtr = GetRenderer(env, info);
    auto *renderer = reinterpret_cast<Renderer *>(rendererPtr);
    if (renderer) {
        SurfaceVariant surfaceVariant = std::monostate{};
        renderer->SetSurface(surfaceVariant);
    }

    napi_value result;
    napi_get_undefined(env, &result);
    return result;
}

napi_value RendererCppSave(napi_env env, napi_callback_info info)
{
    auto rendererPtr = GetRenderer(env, info);
    auto *renderer = reinterpret_cast<Renderer *>(rendererPtr);
    if (renderer) {
        renderer->GetRendererOnWorkerThread()->save();
    }

    napi_value result;
    napi_get_undefined(env, &result);
    return result;
}

napi_value RendererCppRestore(napi_env env, napi_callback_info info)
{
    auto rendererPtr = GetRenderer(env, info);
    auto *renderer = reinterpret_cast<Renderer *>(rendererPtr);
    if (renderer) {
        renderer->GetRendererOnWorkerThread()->restore();
    }

    napi_value result;
    napi_get_undefined(env, &result);
    return result;
}

napi_value RendererCppAlign(napi_env env, napi_callback_info info)
{
    napi_value result;
    napi_get_undefined(env, &result);

    auto rendererPtr = GetRenderer(env, info);
    auto *renderer = reinterpret_cast<Renderer *>(rendererPtr);
    if (!renderer) {
        return result;
    }

    napi_status status;
    size_t argc = ARG_NUM_SIX; // 6: number of arguments expected for RendererCppAlign
    napi_value args[ARG_NUM_SIX] = {nullptr};
    status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_SIX) {
        LOGE("Failed to parse arguments for RendererCppAlign");
        return result;
    }

    rive::Fit fit = GetFit(env, args[ARG_NUM_ONE]);                   // 1: arg index 1 is fit
    rive::Alignment alignment = GetAlignment(env, args[ARG_NUM_TWO]); // 2: arg index 2 is alignment
    rive::AABB targetBounds = RectFToAABB(env, args[ARG_NUM_THREE]);  // 3: arg index 3 is targetBounds
    rive::AABB sourceBounds = RectFToAABB(env, args[ARG_NUM_FOUR]);   // 4: arg index 4 is sourceBounds

    double scaleFactor = 0.0f;
    status = napi_get_value_double(env, args[ARG_NUM_FIVE], &scaleFactor); // 5: arg index 5 is scaleFactor
    if (status != napi_ok) {
        LOGE("Failed to parse scaleFactor for RendererCppAlign");
        return result;
    }
    renderer->GetRendererOnWorkerThread()->align(fit, alignment, targetBounds, sourceBounds, scaleFactor);

    return result;
}

static bool ParseTransformArgs(napi_env env, napi_value *args, rive::Mat2D &outTransform)
{
    double x;
    double sy;
    double sx;
    double y;
    double tx;
    double ty;
    napi_status status;

    status = napi_get_value_double(env, args[ARG_NUM_ONE], &x);
    if (status != napi_ok) {
        LOGE("Failed to parse x for RendererCppTransform");
        return false;
    }

    status = napi_get_value_double(env, args[ARG_NUM_TWO], &sy);
    if (status != napi_ok) {
        LOGE("Failed to parse sy for RendererCppTransform");
        return false;
    }

    status = napi_get_value_double(env, args[ARG_NUM_THREE], &sx);
    if (status != napi_ok) {
        LOGE("Failed to parse sx for RendererCppTransform");
        return false;
    }

    status = napi_get_value_double(env, args[ARG_NUM_FOUR], &y);
    if (status != napi_ok) {
        LOGE("Failed to parse y for RendererCppTransform");
        return false;
    }

    status = napi_get_value_double(env, args[ARG_NUM_FIVE], &tx);
    if (status != napi_ok) {
        LOGE("Failed to parse tx for RendererCppTransform");
        return false;
    }

    status = napi_get_value_double(env, args[ARG_NUM_SIX], &ty);
    if (status != napi_ok) {
        LOGE("Failed to parse ty for RendererCppTransform");
        return false;
    }

    outTransform = rive::Mat2D(x, sy, sx, y, tx, ty);
    return true;
}

napi_value RendererCppTransform(napi_env env, napi_callback_info info)
{
    napi_value result;
    napi_get_undefined(env, &result);

    auto rendererPtr = GetRenderer(env, info);
    auto *renderer = reinterpret_cast<Renderer *>(rendererPtr);
    if (!renderer) {
        return result;
    }

    napi_status status;
    size_t argc = ARG_NUM_SEVEN;
    napi_value args[ARG_NUM_SEVEN] = {nullptr};
    status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_SEVEN) {
        LOGE("Failed to parse arguments for RendererCppTransform");
        return result;
    }

    rive::Mat2D transform;
    if (!ParseTransformArgs(env, args, transform)) {
        return result;
    }

    renderer->GetRendererOnWorkerThread()->transform(transform);
    return result;
}

napi_value RendererCppWidth(napi_env env, napi_callback_info info)
{
    napi_value result;
    auto rendererPtr = GetRenderer(env, info);
    auto *renderer = reinterpret_cast<Renderer *>(rendererPtr);
    if (renderer) {
        int width = renderer->GetWidth();
        napi_create_int32(env, width, &result);
        return result;
    }

    napi_get_undefined(env, &result);
    return result;
}

napi_value RendererCppHeight(napi_env env, napi_callback_info info)
{
    napi_value result;
    auto rendererPtr = GetRenderer(env, info);
    auto *renderer = reinterpret_cast<Renderer *>(rendererPtr);
    if (renderer) {
        int height = renderer->GetHeight();
        napi_create_int32(env, height, &result);
        return result;
    }

    napi_get_undefined(env, &result);
    return result;
}

napi_value RendererCppAvgFps(napi_env env, napi_callback_info info)
{
    napi_value result;
    auto rendererPtr = GetRenderer(env, info);
    auto *renderer = reinterpret_cast<Renderer *>(rendererPtr);
    if (renderer) {
        double fps = renderer->AverageFps();
        napi_create_double(env, fps, &result);
        return result;
    }

    napi_get_undefined(env, &result);
    return result;
}
} // namespace ohos_rive
