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

#include "bindings/bindings_rive_texture_view.h"
#include "helpers/general.h"
#include "models/renderer.h"
#include <js_native_api.h>
#include <string>
namespace ohos_rive {
napi_value RiveTextureViewGetAverageFps(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1];

    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < 1) {
        LOGE("Invalid arguments - expected renderer reference");
        return nullptr;
    }

    uint64_t rendererRef;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[0], &rendererRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get renderer reference");
        return nullptr;
    }
    auto renderer = reinterpret_cast<Renderer *>(rendererRef);
    if (!renderer) {
        LOGE("Invalid renderer reference");
        return nullptr;
    }

    float fps = renderer->AverageFps();

    napi_value result;
    status = napi_create_double(env, fps, &result);
    if (status != napi_ok) {
        LOGE("Failed to create result");
        return nullptr;
    }
    LOGI("Average FPS: %{public}f", fps);
    return result;
}

} // namespace ohos_rive
