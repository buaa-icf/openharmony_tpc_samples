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

#ifndef OHOS_FILE_ASSET_LOADER_HPP
#define OHOS_FILE_ASSET_LOADER_HPP

#include "models/file_asset_loader.h"
#include "helpers/exception_handler.h"
#include "helpers/factories.h"
#include "helpers/general.h"
#include "refs.h"
#include <js_native_api.h>

namespace ohos_rive {
constexpr size_t ARG_NUM_TWO = 2;

FileAssetLoader::FileAssetLoader(napi_env env, napi_value jsObject)
{
    m_env = env;

    napi_valuetype valueType;
    napi_typeof(env, jsObject, &valueType);
    if (valueType != napi_object) {
        LOGE("Invalid JavaScript object provided");
        return;
    }

    napi_status status = napi_create_reference(env, jsObject, 1, &m_jsFileAssetLoaderRef);
    if (status != napi_ok) {
        LOGE("Failed to create reference");
        return;
    }

    napi_value loadContentsMethod;
    status = napi_get_named_property(env, jsObject, "loadContents", &loadContentsMethod);
    if (status != napi_ok) {
        LOGE("loadContents method not found on ETS object");
        return;
    }

    napi_valuetype methodType;
    napi_typeof(env, loadContentsMethod, &methodType);
    if (methodType != napi_function) {
        LOGE("loadContents is not a function");
        return;
    }

    status = napi_create_reference(env, loadContentsMethod, 1, &m_jsLoadContentsMethodRef);
    if (status != napi_ok) {
        LOGE("Failed to cache loadContents method reference");
        return;
    }

    LOGI("FileAssetLoader successfully initialized with cached method");
    if (!g_riveFactory) {
        g_riveFactory = new OhosRiveRenderFactory(env);
    }
}

FileAssetLoader::~FileAssetLoader()
{
    if (m_jsFileAssetLoaderRef) {
        napi_delete_reference(m_env, m_jsFileAssetLoaderRef);
        m_jsFileAssetLoaderRef = nullptr;
    }
    if (m_jsLoadContentsMethodRef) {
        napi_delete_reference(m_env, m_jsLoadContentsMethodRef);
        m_jsLoadContentsMethodRef = nullptr;
    }
}

bool FileAssetLoader::loadContents(rive::FileAsset &asset,
                                   rive::Span<const uint8_t> inBandBytes,
                                   rive::Factory *factory)
{
    if (m_rendererType == RendererType::NONE || !m_jsFileAssetLoaderRef || !m_jsLoadContentsMethodRef) {
        LOGE("Renderer type is not set or JavaScript object or method reference not available");
        return false;
    }

    napi_value jsLoaderObject;
    napi_value loadContentsMethod;
    napi_status status = napi_get_reference_value(m_env, m_jsFileAssetLoaderRef, &jsLoaderObject);
    if (status != napi_ok) {
        LOGE("Failed to get loader object");
        return false;
    }

    status = napi_get_reference_value(m_env, m_jsLoadContentsMethodRef, &loadContentsMethod);
    if (status != napi_ok) {
        LOGE("Failed to get cached loadContents method");
        return false;
    }

    napi_value jsFileAsset = MakeJsAsset(m_env, asset, m_rendererType);
    napi_value jsByteArray = CreateByteArray(m_env, inBandBytes);
    if (!jsFileAsset || !jsByteArray) {
        LOGE("Failed to create method parameters");
        return false;
    }

    napi_value argv[ARG_NUM_TWO] = {jsFileAsset, jsByteArray};
    napi_value callResult;
    status = napi_call_function(m_env, jsLoaderObject, loadContentsMethod, ARG_NUM_TWO, argv, &callResult);
    if (status != napi_ok) {
        LOGE("Failed to call loadContents method");
        return false;
    }

    bool result = false;
    status = napi_get_value_bool(m_env, callResult, &result);
    if (status != napi_ok) {
        LOGI("Failed to get boolean result");
        return false;
    }

    LOGI("ETS loadContents returned: %{public}d", result);
    return result;
}

napi_value FileAssetLoader::MakeJsAsset(napi_env env, rive::FileAsset &asset, RendererType rendererType)
{
    const char *className = nullptr;
    if (asset.is<rive::ImageAsset>()) {
        className = "ImageAsset";
    } else if (asset.is<rive::FontAsset>()) {
        className = "FontAsset";
    } else if (asset.is<rive::AudioAsset>()) {
        className = "AudioAsset";
    } else {
        LOGE("Unknown file asset type: %{public}d for asset: %{public}s", asset.typeKey, asset.name().c_str());
        return nullptr;
    }
    napi_value assetClass = GetClass(env, className);
    if (!assetClass) {
        LOGE("Failed to get %{public}s class from registry", className);
        return nullptr;
    }

    napi_value constructorArgs[ARG_NUM_TWO];
    napi_status status;

    status = napi_create_bigint_uint64(env, reinterpret_cast<uint64_t>(&asset), &constructorArgs[0]);
    if (status != napi_ok) {
        LOGE("Failed to create pointer argument");
        return nullptr;
    }

    status = napi_create_int32(env, static_cast<int32_t>(rendererType), &constructorArgs[1]);
    if (status != napi_ok) {
        LOGE("Failed to create rendererType argument");
        return nullptr;
    }

    napi_value jsAsset;
    status = napi_new_instance(env, assetClass, ARG_NUM_TWO, constructorArgs, &jsAsset);
    if (status != napi_ok) {
        LOGE("Failed to create %{public}s instance, status: %{public}d", className, status);
        napi_value exception;
        napi_get_and_clear_last_exception(env, &exception);
        if (exception) {
            LOGE("Exception occurred while creating %{public}s instance", className);
        }
        return nullptr;
    }
    LOGI("Successfully created %{public}s instance for asset: %{public}s", className, asset.name().c_str());
    return jsAsset;
}

static bool OpenHandleScope(napi_env env, napi_handle_scope *outScope)
{
    napi_status status = napi_open_handle_scope(env, outScope);
    if (status != napi_ok) {
        LOGE("Failed to open handle scope: %d", status);
        return false;
    }
    return true;
}

static napi_value CreateEmptyByteArray(napi_env env)
{
    LOGI("Creating empty byte array");
    napi_value global;
    napi_status status = napi_get_global(env, &global);
    if (status != napi_ok) {
        LOGE("Failed to get global object: %d", status);
        return nullptr;
    }

    napi_value uint8ArrayConstructor;
    status = napi_get_named_property(env, global, "Uint8Array", &uint8ArrayConstructor);
    if (status != napi_ok) {
        LOGE("Failed to get Uint8Array constructor: %d", status);
        return nullptr;
    }

    napi_value emptyArray;
    status = napi_create_array_with_length(env, 0, &emptyArray);
    if (status != napi_ok) {
        LOGE("Failed to create empty array: %d", status);
        return nullptr;
    }

    napi_value fromMethod;
    status = napi_get_named_property(env, uint8ArrayConstructor, "from", &fromMethod);
    if (status == napi_ok) {
        napi_value args[1] = {emptyArray};
        napi_value result;
        status = napi_call_function(env, uint8ArrayConstructor, fromMethod, 1, args, &result);
        if (status == napi_ok) {
            return result;
        }
        LOGE("Uint8Array.from failed: %d", status);
    }

    napi_value result;
    status = napi_create_typedarray(env, napi_uint8_array, 0, nullptr, 0, &result);
    if (status != napi_ok) {
        LOGE("All methods failed to create empty typed array: %d", status);
        return nullptr;
    }
    return result;
}

static napi_value CreateNonEmptyByteArray(napi_env env, rive::Span<const uint8_t> data)
{
    napi_value arrayBuffer;
    void *arrayBufferData = nullptr;
    napi_status status = napi_create_arraybuffer(env, data.size(), &arrayBufferData, &arrayBuffer);
    if (status != napi_ok) {
        LOGE("Failed to create ArrayBuffer, status: %{public}d", status);
        return nullptr;
    }

    if (!arrayBufferData) {
        LOGE("ArrayBuffer data is null");
        return nullptr;
    }

    std::copy(data.data(), data.data() + data.size(), static_cast<uint8_t *>(arrayBufferData));
    napi_value typedArray;
    status = napi_create_typedarray(env, napi_uint8_array, data.size(), arrayBuffer, 0, &typedArray);
    if (status != napi_ok) {
        LOGE("Failed to create Uint8Array, status: %{public}d", status);
        return nullptr;
    }

    LOGI("Successfully created byte array with size: %{public}zu", data.size());
    return typedArray;
}

napi_value FileAssetLoader::CreateByteArray(napi_env env, rive::Span<const uint8_t> data)
{
    LOGI("CreateByteArray called with data size: %{public}zu, data pointer: %{public}p", data.size(), data.data());
    if (data.size() > 0 && data.data() == nullptr) {
        LOGE("Invalid data: size > 0 but data pointer is null");
        return nullptr;
    }

    napi_handle_scope scope;
    if (!OpenHandleScope(env, &scope)) {
        return nullptr;
    }

    napi_value result = nullptr;
    if (data.size() == 0) {
        result = CreateEmptyByteArray(env);
    } else {
        napi_close_handle_scope(env, scope);
        return CreateNonEmptyByteArray(env, data);
    }

    napi_close_handle_scope(env, scope);
    return result;
}

napi_env FileAssetLoader::GetEnv() const
{
    return m_env;
}

void FileAssetLoader::setRendererType(RendererType rendererType)
{
    if (m_rendererType != rendererType) {
        m_rendererType = rendererType;
    }
}

RendererType FileAssetLoader::getRendererType() const
{
    return m_rendererType;
}
} // namespace ohos_rive
#endif // OHOS_FILE_ASSET_LOADER_HPP
