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

#include "bindings/bindings_bindable_artboard.h"
#include "helpers/general.h"
#include "rive/assets/file_asset.hpp"
#include <js_native_api.h>
#include <string>
namespace ohos_rive {
static rive::BindableArtboard *GetBindableArtboardFromNapiValue(napi_env env, napi_value value)
{
    napi_valuetype valueType;
    napi_typeof(env, value, &valueType);

    if (valueType != napi_external) {
        LOGE("Invalid napi value type, expected external");
        return nullptr;
    }

    void *data = nullptr;
    napi_status status = napi_get_value_external(env, value, &data);
    if (status != napi_ok || data == nullptr) {
        LOGE("Failed to get external value");
        return nullptr;
    }

    return reinterpret_cast<rive::BindableArtboard *>(data);
}

static napi_value CreateNapiValueFromPointer(napi_env env, void *pointer)
{
    napi_value externalValue;
    napi_status status = napi_create_external(env, pointer, nullptr, nullptr, &externalValue);
    if (status != napi_ok) {
        LOGE("Failed to create external napi value");
        return nullptr;
    }
    return externalValue;
}

napi_value BindableArtboardDelete(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1];
    napi_value thisArg;
    void *data;

    napi_status status = napi_get_cb_info(env, info, &argc, args, &thisArg, &data);
    if (status != napi_ok || argc < 1) {
        LOGE("Failed to get callback info");
        return nullptr;
    }

    uint64_t bindableArtboardPtr = 0;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[0], &bindableArtboardPtr, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get BindableArtboard pointer from int64");
        return nullptr;
    }

    if (bindableArtboardPtr == 0) {
        LOGE("Invalid BindableArtboard pointer (0)");
        return nullptr;
    }

    rive::BindableArtboard *bindableArtboard = reinterpret_cast<rive::BindableArtboard *>(bindableArtboardPtr);
    LOGI("Deleting BindableArtboard at address: %{public}p", bindableArtboard);

    bindableArtboard->unref();
    napi_value result;
    napi_get_undefined(env, &result);
    return result;
}

napi_value BindableArtboardGetName(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1];
    napi_value thisArg;
    void *data;

    napi_status status = napi_get_cb_info(env, info, &argc, args, &thisArg, &data);
    if (status != napi_ok || argc < 1) {
        LOGE("Failed to get callback info");
        return nullptr;
    }

    uint64_t bindableArtboardPtr = 0;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[0], &bindableArtboardPtr, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get BindableArtboard pointer from int64");
        return nullptr;
    }

    if (bindableArtboardPtr == 0) {
        LOGE("Invalid BindableArtboard pointer (0)");
        return nullptr;
    }

    rive::BindableArtboard *bindableArtboard = reinterpret_cast<rive::BindableArtboard *>(bindableArtboardPtr);
    auto name = bindableArtboard->artboard()->name();
    LOGI("Get artboard name: %{public}s", name.c_str());

    napi_value result;
    status = napi_create_string_utf8(env, name.c_str(), NAPI_AUTO_LENGTH, &result);
    if (status != napi_ok) {
        LOGE("Failed to create string result");
        return nullptr;
    }

    return result;
}
} // namespace ohos_rive
