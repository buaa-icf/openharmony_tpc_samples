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

#include "bindings/bindings_font.h"
#include "helpers/font_helper.h"
#include "helpers/general.h"
#include "helpers/resource.h"
#include <iostream>

namespace ohos_rive {
napi_value FontCppRegisterFallbackFont(napi_env env, napi_callback_info info)
{
    if (!env) {
        LOGE("Invalid N-API environment in RiveCppRegisterFallbackFont");
        return nullptr;
    }

    napi_value result;
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < 1) {
        LOGE("Failed to parse arguments for RegisterFallbackFont");
        napi_get_boolean(env, false, &result);
        return result;
    }

    status = napi_get_boolean(env, FontHelper::RegisterFallbackFont(env, args[0]), &result);
    if (status != napi_ok) {
        LOGE("Failed to create boolean result");
        napi_get_boolean(env, false, &result);
        return result;
    }

    return result;
}

napi_value FontCppResetFontCache(napi_env env, napi_callback_info info)
{
    FontHelper::ResetCache();

    napi_value result;
    napi_get_undefined(env, &result);
    return result;
}
} // namespace ohos_rive
