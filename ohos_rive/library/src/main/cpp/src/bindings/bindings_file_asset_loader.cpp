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

#include "bindings/bindings_file_asset_loader.h"
#include "helpers/general.h"
#include "models/file_asset_loader.h"
#include <js_native_api.h>
namespace ohos_rive {
constexpr size_t ARG_NUM_ZERO = 0;
constexpr size_t ARG_NUM_ONE = 1;
constexpr size_t ARG_NUM_TWO = 2;
napi_value FileAssetLoaderCreate(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_ONE;
    napi_value args[ARG_NUM_ONE];
    napi_value thisArg;
    void *data;

    napi_get_cb_info(env, info, &argc, args, &thisArg, &data);

    if (argc < ARG_NUM_ONE) {
        napi_throw_error(env, nullptr, "FileAssetLoader constructor requires an ETS object parameter");
        return nullptr;
    }

    napi_valuetype valueType;
    napi_typeof(env, args[ARG_NUM_ZERO], &valueType);
    if (valueType != napi_object) {
        napi_throw_error(env, nullptr, "FileAssetLoader requires a JavaScript object");
        return nullptr;
    }

    LOGI("Napi_FileAssetLoader_constructor: Creating FileAssetLoader with ETS object");
    FileAssetLoader *fileAssetLoader = new FileAssetLoader(env, args[ARG_NUM_ZERO]);
    if (!fileAssetLoader) {
        napi_throw_error(env, nullptr, "Failed to create FileAssetLoader instance");
        return nullptr;
    }

    napi_value result;
    napi_status status = napi_create_bigint_uint64(env, reinterpret_cast<uint64_t>(fileAssetLoader), &result);
    if (status != napi_ok) {
        delete fileAssetLoader;
        napi_throw_error(env, nullptr, "Failed to create return value");
        return nullptr;
    }

    LOGI("Napi_FileAssetLoader_constructor: Successfully created FileAssetLoader, pointer: %{public}p",
         fileAssetLoader);
    return result;
}

napi_value FileAssetLoaderDelete(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_ONE;
    napi_value args[ARG_NUM_ONE];
    napi_value thisArg;
    void *data;

    napi_get_cb_info(env, info, &argc, args, &thisArg, &data);

    if (argc < ARG_NUM_ONE) {
        LOGE("Wrong number of arguments");
        return nullptr;
    }

    uint64_t pointerValue;
    bool lossless = false;
    napi_status status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &pointerValue, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Invalid pointer argument");
        return nullptr;
    }

    auto *fileAssetLoader = reinterpret_cast<FileAssetLoader *>(pointerValue);
    if (fileAssetLoader) {
        LOGI("FileAssetLoader unref: %{public}p", fileAssetLoader);
        fileAssetLoader->unref();
    }

    napi_value result;
    napi_get_undefined(env, &result);
    return result;
}

napi_value FileAssetLoaderRef(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_ONE;
    napi_value args[ARG_NUM_ONE];
    napi_value thisArg;
    void *data;

    napi_get_cb_info(env, info, &argc, args, &thisArg, &data);

    if (argc < ARG_NUM_ONE) {
        LOGE("Wrong number of arguments");
        return nullptr;
    }

    uint64_t pointerValue;
    bool lossless = false;
    napi_status status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &pointerValue, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Invalid pointer argument");
        return nullptr;
    }

    auto *fileAssetLoader = reinterpret_cast<FileAssetLoader *>(pointerValue);
    if (fileAssetLoader) {
        fileAssetLoader->ref();
    }

    napi_value result;
    napi_get_undefined(env, &result);
    return result;
}

napi_value FileAssetLoaderSetRendererType(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO];
    napi_value thisArg;
    void *data;

    napi_get_cb_info(env, info, &argc, args, &thisArg, &data);

    if (argc < ARG_NUM_TWO) {
        LOGE("Wrong number of arguments");
        return nullptr;
    }

    uint64_t pointerValue;
    bool lossless = false;
    napi_status status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &pointerValue, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Invalid pointer argument");
        return nullptr;
    }

    int32_t rendererType;
    napi_get_value_int32(env, args[ARG_NUM_ONE], &rendererType);

    auto *fileAssetLoader = reinterpret_cast<FileAssetLoader *>(pointerValue);
    if (fileAssetLoader) {
        fileAssetLoader->setRendererType(static_cast<RendererType>(rendererType));
    }

    napi_value result;
    napi_get_undefined(env, &result);
    return result;
}
} // namespace ohos_rive
