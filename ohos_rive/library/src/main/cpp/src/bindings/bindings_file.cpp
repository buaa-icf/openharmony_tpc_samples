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

#include "bindings/bindings_file.h"
#include "helpers/exception_handler.h"
#include "helpers/factories.h"
#include "helpers/general.h"
#include "helpers/resource.h"
#include "rive/file.hpp"
#include "rive/viewmodel/runtime/viewmodel_runtime.hpp"
#include "rive/viewmodel/viewmodel.hpp"
#include <js_native_api.h>
namespace ohos_rive {
constexpr size_t ARG_NUM_ZERO = 0;
constexpr size_t ARG_NUM_ONE = 1;
constexpr size_t ARG_NUM_TWO = 2;
constexpr size_t ARG_NUM_THREE = 3;
std::string NapiValueToString(napi_env env, napi_value value)
{
    if (value == nullptr) {
        return "";
    }

    size_t length = 0;
    napi_get_value_string_utf8(env, value, nullptr, 0, &length);

    std::string result;
    if (length > 0) {
        result.resize(length);
        napi_get_value_string_utf8(env, value, &result[0], length + 1, &length);
    }

    return result;
}

napi_value CreateNapiString(napi_env env, const std::string &str)
{
    napi_value result;
    napi_create_string_utf8(env, str.c_str(), str.length(), &result);
    return result;
}

// FILE
napi_value Napi_File_import(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_THREE;
    napi_value args[ARG_NUM_THREE];
    napi_value thisArg;
    void *data;

    napi_get_cb_info(env, info, &argc, args, &thisArg, &data);
    if (argc < ARG_NUM_THREE) {
        LOGE("Wrong number of arguments for import");
        return nullptr;
    }

    void *arrayBufferData;
    size_t arrayBufferLength;
    napi_get_arraybuffer_info(env, args[ARG_NUM_ZERO], &arrayBufferData, &arrayBufferLength);

    int32_t rendererType;
    napi_get_value_int32(env, args[ARG_NUM_ONE], &rendererType);
    uint64_t fileAssetLoaderPtr;
    bool lossless = false;
    auto status = napi_get_value_bigint_uint64(env, args[ARG_NUM_TWO], &fileAssetLoaderPtr, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get fileAssetLoaderPtr for import");
        return nullptr;
    }

    auto *assetLoader = reinterpret_cast<rive::FileAssetLoader *>(fileAssetLoaderPtr);
    auto filePtr = Import(env, reinterpret_cast<uint8_t *>(arrayBufferData), static_cast<int32_t>(arrayBufferLength),
                          static_cast<RendererType>(rendererType), assetLoader);

    napi_value result;
    status = napi_create_bigint_uint64(env, reinterpret_cast<uint64_t>(filePtr), &result);
    if (status != napi_ok) {
        LOGE("Failed to create bigint for filePtr");
        return nullptr;
    }

    return result;
}

napi_value Napi_File_cppEnums(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_ONE;
    napi_value args[ARG_NUM_ONE];
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_ONE) {
        LOGE("Expected 1 argument");
        return nullptr;
    }

    uint64_t ref;
    bool lossless = false;
    auto status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &ref, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get file reference for cppEnums");
        return nullptr;
    }
    auto *file = reinterpret_cast<rive::File *>(ref);

    if (!file) {
        LOGE("Invalid file reference");
        return nullptr;
    }

    auto enumItems = file->enums();
    napi_value resultArray;
    napi_create_array_with_length(env, enumItems.size(), &resultArray);

    uint32_t enumIndex = 0;
    for (const auto &enumItem : enumItems) {
        // { name: string, values: string[] }
        napi_value enumObj;
        napi_create_object(env, &enumObj);

        auto enumName = MakeNapiString(env, enumItem->enumName());
        if (enumName.Get()) {
            napi_set_named_property(env, enumObj, "name", enumName.Get());
        }

        auto values = enumItem->values();
        napi_value valuesArray;
        napi_create_array_with_length(env, values.size(), &valuesArray);

        uint32_t valueIndex = 0;
        for (const auto &value : values) {
            auto valueName = MakeNapiString(env, value->key());
            if (valueName.Get()) {
                napi_set_element(env, valuesArray, valueIndex, valueName.Get());
                valueIndex++;
            }
        }

        napi_set_named_property(env, enumObj, "values", valuesArray);
        napi_set_element(env, resultArray, enumIndex, enumObj);
        enumIndex++;
    }

    return resultArray;
}

napi_value FileCppArtboardByName(napi_env env, napi_callback_info info)
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

    uint64_t fileRef;
    bool lossless = false;
    auto status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &fileRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get file reference for artboardByName");
        return nullptr;
    }

    std::string name = NapiValueToString(env, args[ARG_NUM_ONE]);
    auto file = reinterpret_cast<rive::File *>(fileRef);
    auto artboard = file->artboardNamed(name);
    if (artboard != nullptr) {
        artboard->advance(0.0);
    }

    napi_value result;
    status = napi_create_bigint_uint64(env, reinterpret_cast<uint64_t>(artboard.release()), &result);
    if (status != napi_ok) {
        LOGE("Failed to create bigint for artboard");
        return nullptr;
    }
    return result;
}

napi_value FileCppDelete(napi_env env, napi_callback_info info)
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

    uint64_t fileRef;
    bool lossless = false;
    auto status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &fileRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get file reference for delete");
        return nullptr;
    }
    auto file = reinterpret_cast<rive::File *>(fileRef);
    file->unref();

    napi_value result;
    napi_get_undefined(env, &result);
    return result;
}

napi_value FileCppArtboardCount(napi_env env, napi_callback_info info)
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

    uint64_t fileRef;
    bool lossless = false;
    auto status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &fileRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get file reference for artboardCount");
        return nullptr;
    }
    auto file = reinterpret_cast<rive::File *>(fileRef);
    int32_t count = static_cast<int32_t>(file->artboardCount());

    napi_value result;
    napi_create_int32(env, count, &result);
    return result;
}

napi_value FileCppArtboardByIndex(napi_env env, napi_callback_info info)
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

    uint64_t fileRef;
    bool lossless = false;
    auto status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &fileRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get file reference for artboardByIndex");
        return nullptr;
    }
    int32_t index;
    napi_get_value_int32(env, args[ARG_NUM_ONE], &index);
    auto file = reinterpret_cast<rive::File *>(fileRef);
    auto artboard = file->artboardAt(index);
    if (artboard != nullptr) {
        artboard->advance(0.0);
    }
    napi_value result;
    status = napi_create_bigint_uint64(env, reinterpret_cast<uint64_t>(artboard.release()), &result);
    if (status != napi_ok) {
        LOGE("Failed to create bigint for artboard");
        return nullptr;
    }
    return result;
}

napi_value FileCppArtboardNameByIndex(napi_env env, napi_callback_info info)
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

    uint64_t fileRef;
    bool lossless = false;
    auto status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &fileRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get file reference for artboardNameByIndex");
        return nullptr;
    }
    int32_t index;
    napi_get_value_int32(env, args[ARG_NUM_ONE], &index);

    auto file = reinterpret_cast<rive::File *>(fileRef);
    auto artboard = file->artboard(index);
    auto name = artboard->name();

    return CreateNapiString(env, name);
}

napi_value FileCppCreateBindableArtboardByName(napi_env env, napi_callback_info info)
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

    uint64_t fileRef;
    bool lossless = false;
    auto status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &fileRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get file reference for createBindableArtboardByName");
        return nullptr;
    }

    std::string name = NapiValueToString(env, args[ARG_NUM_ONE]);
    auto file = reinterpret_cast<rive::File *>(fileRef);
    auto bindableArtboard = file->bindableArtboardNamed(name);

    napi_value result;
    status = napi_create_bigint_uint64(env, reinterpret_cast<uint64_t>(bindableArtboard.release()), &result);
    if (status != napi_ok) {
        LOGE("Failed to create bigint for bindableArtboard");
        return nullptr;
    }
    return result;
}

napi_value FileCppCreateDefaultBindableArtboard(napi_env env, napi_callback_info info)
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

    uint64_t fileRef;
    bool lossless = false;
    auto status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &fileRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get file reference for createDefaultBindableArtboard");
        return nullptr;
    }

    auto file = reinterpret_cast<rive::File *>(fileRef);
    auto bindableArtboard = file->bindableArtboardDefault();

    napi_value result;
    status = napi_create_bigint_uint64(env, reinterpret_cast<uint64_t>(bindableArtboard.release()), &result);
    if (status != napi_ok) {
        LOGE("Failed to create bigint for bindableArtboard");
        return nullptr;
    }
    return result;
}

napi_value FileCppViewModelCount(napi_env env, napi_callback_info info)
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

    uint64_t fileRef;
    bool lossless = false;
    auto status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &fileRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get file reference for viewModelCount");
        return nullptr;
    }

    auto file = reinterpret_cast<rive::File *>(fileRef);
    int32_t count = static_cast<int32_t>(file->viewModelCount());

    napi_value result;
    napi_create_int32(env, count, &result);
    return result;
}

napi_value FileCppViewModelByIndex(napi_env env, napi_callback_info info)
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

    uint64_t fileRef;
    bool lossless = false;
    auto status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &fileRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get file reference for viewModelByIndex");
        return nullptr;
    }

    int32_t index;
    napi_get_value_int32(env, args[ARG_NUM_ONE], &index);

    auto file = reinterpret_cast<rive::File *>(fileRef);
    auto viewModel = file->viewModelByIndex(index);

    napi_value result;
    status = napi_create_bigint_uint64(env, reinterpret_cast<uint64_t>(viewModel), &result);
    if (status != napi_ok) {
        LOGE("Failed to create bigint for viewModel");
        return nullptr;
    }
    return result;
}

napi_value FileCppViewModelByName(napi_env env, napi_callback_info info)
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

    uint64_t fileRef;
    bool lossless = false;
    auto status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &fileRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get file reference for viewModelByName");
        return nullptr;
    }

    std::string name = NapiValueToString(env, args[ARG_NUM_ONE]);

    auto file = reinterpret_cast<rive::File *>(fileRef);
    auto viewModel = file->viewModelByName(name);

    napi_value result;
    status = napi_create_bigint_uint64(env, reinterpret_cast<uint64_t>(viewModel), &result);
    if (status != napi_ok) {
        LOGE("Failed to create bigint for viewModel");
        return nullptr;
    }
    return result;
}

napi_value FileCppDefaultViewModelForArtboard(napi_env env, napi_callback_info info)
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

    uint64_t fileRef;
    bool lossless = false;
    auto status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &fileRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get file reference for defaultArtboardViewModel");
        return nullptr;
    }

    uint64_t artboardRef;
    lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ONE], &artboardRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get artboard reference for defaultArtboardViewModel");
        return nullptr;
    }

    auto file = reinterpret_cast<rive::File *>(fileRef);
    auto artboard = reinterpret_cast<rive::Artboard *>(artboardRef);
    auto viewModel = file->defaultArtboardViewModel(artboard);

    napi_value result;
    status = napi_create_bigint_uint64(env, reinterpret_cast<uint64_t>(viewModel), &result);
    if (status != napi_ok) {
        LOGE("Failed to create bigint for defaultArtboardViewModel");
        return nullptr;
    }
    return result;
}
} // namespace ohos_rive

