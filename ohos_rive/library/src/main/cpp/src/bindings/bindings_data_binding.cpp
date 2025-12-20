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

#include "bindings/bindings_data_binding.h"
#include "helpers/exception_handler.h"
#include "helpers/general.h"
#include "refs.h"
#include "rive/viewmodel/runtime/viewmodel_instance_number_runtime.hpp"
#include "rive/viewmodel/runtime/viewmodel_instance_runtime.hpp"
#include "rive/viewmodel/runtime/viewmodel_runtime.hpp"
#include <cstdio>
#include <js_native_api.h>
#include <string>

namespace ohos_rive {
constexpr size_t ARG_NUM_ZERO = 0;
constexpr size_t ARG_NUM_ONE = 1;
constexpr size_t ARG_NUM_TWO = 2;
constexpr size_t ARG_NUM_THREE = 3;
napi_value ViewModelName(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_ONE;
    napi_value args[ARG_NUM_ONE];

    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_ONE) {
        LOGE("Invalid arguments - expected view model reference");
        return nullptr;
    }

    // get view model pointer
    uint64_t viewModelRef;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &viewModelRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get view model reference");
        return nullptr;
    }
    auto viewModel = reinterpret_cast<rive::ViewModelRuntime *>(viewModelRef);
    if (!viewModel) {
        LOGE("Invalid view model reference");
        return nullptr;
    }

    // get name of the view model
    std::string name = viewModel->name();
    napi_value result;
    status = napi_create_string_utf8(env, name.c_str(), name.length(), &result);
    if (status != napi_ok) {
        LOGE("Failed to create string result");
        return nullptr;
    }
    LOGI("ViewModel name: %{public}s", name.c_str());
    return result;
}

napi_value ViewModelInstanceCount(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_ONE;
    napi_value args[ARG_NUM_ONE];

    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_ONE) {
        LOGE("Invalid arguments - expected view model reference");
        return nullptr;
    }

    // get view model pointer
    uint64_t viewModelRef;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &viewModelRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get view model reference");
        return nullptr;
    }
    auto viewModel = reinterpret_cast<rive::ViewModelRuntime *>(viewModelRef);
    if (!viewModel) {
        LOGE("Invalid view model reference");
        return nullptr;
    }

    int count = static_cast<int>(viewModel->instanceCount());
    napi_value result;
    status = napi_create_int32(env, count, &result);
    if (status != napi_ok) {
        LOGE("Failed to create result");
        return nullptr;
    }
    LOGI("ViewModel instance count: %{public}d", count);
    return result;
}

napi_value ViewModelPropertyCount(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_ONE;
    napi_value args[ARG_NUM_ONE];

    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_ONE) {
        LOGE("Invalid arguments - expected view model reference");
        return nullptr;
    }

    uint64_t viewModelRef;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &viewModelRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get view model reference");
        return nullptr;
    }
    auto viewModel = reinterpret_cast<rive::ViewModelRuntime *>(viewModelRef);
    if (!viewModel) {
        LOGE("Invalid view model reference");
        return nullptr;
    }

    int count = static_cast<int>(viewModel->propertyCount());

    napi_value result;
    status = napi_create_int32(env, count, &result);
    if (status != napi_ok) {
        LOGE("Failed to create result");
        return nullptr;
    }
    LOGI("ViewModel property count: %{public}d", count);
    return result;
}

static rive::ViewModelRuntime *GetViewModelFromArgs(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_ONE;
    napi_value args[ARG_NUM_ONE];

    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_ONE) {
        LOGE("Invalid arguments - expected view model reference");
        return nullptr;
    }

    uint64_t viewModelRef;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &viewModelRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get view model reference");
        return nullptr;
    }

    auto viewModel = reinterpret_cast<rive::ViewModelRuntime *>(viewModelRef);
    if (!viewModel) {
        LOGE("Invalid view model reference");
    }

    return viewModel;
}

static napi_value BuildPropertiesArray(napi_env env, rive::ViewModelRuntime *viewModel)
{
    auto properties = viewModel->properties();
    napi_value array;
    napi_status status = napi_create_array(env, &array);
    if (status != napi_ok) {
        LOGE("Failed to create array");
        return nullptr;
    }

    napi_value cls = FindClass(env, "PropertyData").Get();
    napi_value cls2 = FindClass(env, "PropertyDataUtils").Get();

    size_t index = 0;
    for (const auto &property : properties) {
        LOGI("ViewModelGetProperties property name: %{public}s, property type = %{public}d", property.name.c_str(),
             property.type);
        auto name = MakeNapiString(env, property.name);

        napi_value propertyType;
        napi_create_int32(env, (int)property.type, &propertyType);

        napi_value args[1] = {propertyType};
        napi_value methodId2 = GetStaticMethodId(env, cls2, "fromIndex");
        napi_value result;
        status = napi_call_function(env, cls2, methodId2, 1, args, &result);
        if (status != napi_ok) {
            LOGE("Failed to call function");
            return nullptr;
        }

        napi_value propertyArgs[ARG_NUM_TWO];
        propertyArgs[ARG_NUM_ZERO] = result;
        propertyArgs[ARG_NUM_ONE] = name.Get();
        auto propertyObject = MakeObject(env, cls, 2, propertyArgs);
        napi_set_element(env, array, index, propertyObject.Get());
        index++;
    }

    return array;
}

napi_value ViewModelGetProperties(napi_env env, napi_callback_info info)
{
    auto viewModel = GetViewModelFromArgs(env, info);
    if (!viewModel) {
        return nullptr;
    }
    return BuildPropertiesArray(env, viewModel);
}

napi_value ViewModelCreateBlankInstance(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_ONE;
    napi_value args[ARG_NUM_ONE];

    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_ONE) {
        LOGE("Invalid arguments - expected view model reference");
        return nullptr;
    }

    uint64_t viewModelRef;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &viewModelRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get view model reference");
        return nullptr;
    }
    auto viewModel = reinterpret_cast<rive::ViewModelRuntime *>(viewModelRef);
    if (!viewModel) {
        LOGE("Invalid view model reference");
        return nullptr;
    }

    auto instance = viewModel->createInstance();
    if (!instance) {
        LOGE("Failed to create view model instance");
        return nullptr;
    }

    napi_value result;
    status = napi_create_bigint_uint64(env, reinterpret_cast<uint64_t>(instance.release()), &result);
    if (status != napi_ok) {
        LOGE("Failed to create result");
        return nullptr;
    }
    return result;
}

napi_value ViewModelCreateDefaultInstance(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_ONE;
    napi_value args[ARG_NUM_ONE];

    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_ONE) {
        LOGE("Invalid arguments - expected view model reference");
        return nullptr;
    }

    uint64_t viewModelRef;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &viewModelRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get view model reference");
        return nullptr;
    }
    auto viewModel = reinterpret_cast<rive::ViewModelRuntime *>(viewModelRef);
    if (!viewModel) {
        LOGE("Invalid view model reference");
        return nullptr;
    }

    auto instance = viewModel->createDefaultInstance();
    if (!instance) {
        LOGE("Failed to create default view model instance");
        return nullptr;
    }
    napi_value result;
    status = napi_create_bigint_uint64(env, reinterpret_cast<uint64_t>(instance.release()), &result);
    if (status != napi_ok) {
        LOGE("Failed to create result");
        return nullptr;
    }
    return result;
}

napi_value ViewModelCreateInstanceFromIndex(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO];

    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_TWO) {
        LOGE("Invalid arguments - expected view model reference and index");
        return nullptr;
    }

    uint64_t viewModelRef;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &viewModelRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get view model reference");
        return nullptr;
    }
    int32_t index;
    status = napi_get_value_int32(env, args[ARG_NUM_ONE], &index);
    if (status != napi_ok) {
        LOGE("Failed to get instance index");
        return nullptr;
    }
    auto viewModel = reinterpret_cast<rive::ViewModelRuntime *>(viewModelRef);
    if (!viewModel) {
        LOGE("Invalid view model reference");
        return nullptr;
    }

    auto instance = viewModel->createInstanceFromIndex(static_cast<size_t>(index));
    if (!instance) {
        LOGE("Failed to create view model instance from index: %{public}d", index);
        return nullptr;
    }
    napi_value result;
    status = napi_create_bigint_uint64(env, reinterpret_cast<uint64_t>(instance.release()), &result);
    if (status != napi_ok) {
        LOGE("Failed to create result");
        return nullptr;
    }
    LOGI("View model instance created from index: %{public}d", index);
    return result;
}

napi_value ViewModelCreateInstanceFromName(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO];

    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_TWO) {
        LOGE("Invalid arguments - expected view model reference and name");
        return nullptr;
    }

    uint64_t viewModelRef;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &viewModelRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get view model reference");
        return nullptr;
    }
    std::string instanceName = NapiStringToString(env, args[ARG_NUM_ONE]);
    auto viewModel = reinterpret_cast<rive::ViewModelRuntime *>(viewModelRef);
    if (!viewModel) {
        LOGE("Invalid view model reference");
        return nullptr;
    }

    auto instance = viewModel->createInstanceFromName(instanceName);
    if (!instance) {
        LOGE("Failed to create view model instance from name: %{public}s", instanceName.c_str());
        return nullptr;
    }
    napi_value result;
    status = napi_create_bigint_uint64(env, reinterpret_cast<uint64_t>(instance.release()), &result);
    if (status != napi_ok) {
        LOGE("Failed to create result");
        return nullptr;
    }
    LOGI("View model instance created from name: %{public}s", instanceName.c_str());
    return result;
}

napi_value ViewModelInstanceName(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_ONE;
    napi_value args[ARG_NUM_ONE];

    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_ONE) {
        LOGE("Invalid arguments - expected view model instance reference");
        return nullptr;
    }

    uint64_t viewModelInstanceRef;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &viewModelInstanceRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get view model instance reference");
        return nullptr;
    }
    auto viewModelInstance = reinterpret_cast<rive::ViewModelInstanceRuntime *>(viewModelInstanceRef);
    if (!viewModelInstance) {
        LOGE("Invalid view model instance reference");
        return nullptr;
    }

    std::string name = viewModelInstance->name();
    napi_value result;
    status = napi_create_string_utf8(env, name.c_str(), name.length(), &result);
    if (status != napi_ok) {
        LOGE("Failed to create string result");
        return nullptr;
    }
    LOGI("View model instance name: %{public}s", name.c_str());
    return result;
}

napi_value ViewModelInstancePropertyNumber(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO];

    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_TWO) {
        LOGE("Invalid arguments - expected view model instance reference and path");
        return nullptr;
    }

    uint64_t viewModelInstanceRef;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &viewModelInstanceRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get view model instance reference");
        return nullptr;
    }

    std::string propertyPath = NapiStringToString(env, args[ARG_NUM_ONE]);
    auto viewModelInstance = reinterpret_cast<rive::ViewModelInstanceRuntime *>(viewModelInstanceRef);
    if (!viewModelInstance) {
        LOGE("Invalid view model instance reference");
        return nullptr;
    }

    auto propertyNumber = viewModelInstance->propertyNumber(propertyPath);
    napi_value result;
    status = napi_create_bigint_uint64(env, reinterpret_cast<uint64_t>(propertyNumber), &result);
    if (status != napi_ok) {
        LOGE("Failed to create result");
        return nullptr;
    }
    LOGI("View model instance property number: %{public}d", propertyNumber->dataType());
    return result;
}

napi_value ViewModelInstancePropertyString(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO];

    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_TWO) {
        LOGE("Invalid arguments - expected view model instance reference and path");
        return nullptr;
    }

    uint64_t viewModelInstanceRef;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &viewModelInstanceRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get view model instance reference");
        return nullptr;
    }

    std::string propertyPath = NapiStringToString(env, args[ARG_NUM_ONE]);
    auto viewModelInstance = reinterpret_cast<rive::ViewModelInstanceRuntime *>(viewModelInstanceRef);
    if (!viewModelInstance) {
        LOGE("Invalid view model instance reference");
        return nullptr;
    }

    auto propertyString = viewModelInstance->propertyString(propertyPath);
    if (!propertyString) {
        LOGE("String property not found for path: %{public}s", propertyPath.c_str());
        return nullptr;
    }
    napi_value result;
    status = napi_create_bigint_uint64(env, reinterpret_cast<uint64_t>(propertyString), &result);
    if (status != napi_ok) {
        LOGE("Failed to create result");
        return nullptr;
    }
    LOGI("View model instance property string: %{public}d", propertyString->dataType());
    return result;
}

napi_value ViewModelInstancePropertyBoolean(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO];
    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_TWO) {
        LOGE("Invalid arguments - expected view model instance reference and path");
        return nullptr;
    }

    uint64_t viewModelInstanceRef;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &viewModelInstanceRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get view model instance reference");
        return nullptr;
    }

    std::string propertyPath = NapiStringToString(env, args[ARG_NUM_ONE]);
    auto viewModelInstance = reinterpret_cast<rive::ViewModelInstanceRuntime *>(viewModelInstanceRef);
    if (!viewModelInstance) {
        LOGE("Invalid view model instance reference");
        return nullptr;
    }

    auto propertyBoolean = viewModelInstance->propertyBoolean(propertyPath);
    if (!propertyBoolean) {
        LOGE("Boolean property not found for path: %{public}s", propertyPath.c_str());
        return nullptr;
    }
    napi_value result;
    status = napi_create_bigint_uint64(env, reinterpret_cast<uint64_t>(propertyBoolean), &result);
    if (status != napi_ok) {
        LOGE("Failed to create result");
        return nullptr;
    }
    LOGI("Boolean property found for path: %{public}s", propertyPath.c_str());
    return result;
}

napi_value ViewModelInstancePropertyColor(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO];
    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_TWO) {
        LOGE("Invalid arguments - expected view model instance reference and path");
        return nullptr;
    }

    uint64_t viewModelInstanceRef;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &viewModelInstanceRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get view model instance reference");
        return nullptr;
    }

    std::string propertyPath = NapiStringToString(env, args[ARG_NUM_ONE]);
    auto viewModelInstance = reinterpret_cast<rive::ViewModelInstanceRuntime *>(viewModelInstanceRef);
    if (!viewModelInstance) {
        LOGE("Invalid view model instance reference");
        return nullptr;
    }

    auto propertyColor = viewModelInstance->propertyColor(propertyPath);
    if (!propertyColor) {
        LOGE("Color property not found for path: %{public}s", propertyPath.c_str());
        return nullptr;
    }
    napi_value result;
    status = napi_create_bigint_uint64(env, reinterpret_cast<uint64_t>(propertyColor), &result);
    if (status != napi_ok) {
        LOGE("Failed to create result");
        return nullptr;
    }
    LOGI("Color property found for path: %{public}s", propertyPath.c_str());
    return result;
}

napi_value ViewModelInstancePropertyEnum(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO];
    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_TWO) {
        LOGE("Invalid arguments - expected view model instance reference and path");
        return nullptr;
    }

    uint64_t viewModelInstanceRef;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &viewModelInstanceRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get view model instance reference");
        return nullptr;
    }
    std::string propertyPath = NapiStringToString(env, args[ARG_NUM_ONE]);
    auto viewModelInstance = reinterpret_cast<rive::ViewModelInstanceRuntime *>(viewModelInstanceRef);
    if (!viewModelInstance) {
        LOGE("Invalid view model instance reference");
        return nullptr;
    }

    auto propertyEnum = viewModelInstance->propertyEnum(propertyPath);
    if (!propertyEnum) {
        LOGE("Enum property not found for path: %{public}s", propertyPath.c_str());
        return nullptr;
    }
    napi_value result;
    status = napi_create_bigint_uint64(env, reinterpret_cast<uint64_t>(propertyEnum), &result);
    if (status != napi_ok) {
        LOGE("Failed to create result");
        return nullptr;
    }
    LOGI("Enum property found for path: %{public}s", propertyPath.c_str());
    return result;
}

napi_value ViewModelInstancePropertyTrigger(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO];
    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_TWO) {
        LOGE("Invalid arguments - expected view model instance reference and path");
        return nullptr;
    }

    uint64_t viewModelInstanceRef;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &viewModelInstanceRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get view model instance reference");
        return nullptr;
    }

    std::string propertyPath = NapiStringToString(env, args[ARG_NUM_ONE]);
    auto viewModelInstance = reinterpret_cast<rive::ViewModelInstanceRuntime *>(viewModelInstanceRef);
    if (!viewModelInstance) {
        LOGE("Invalid view model instance reference");
        return nullptr;
    }

    auto propertyTrigger = viewModelInstance->propertyTrigger(propertyPath);
    if (!propertyTrigger) {
        LOGE("Trigger property not found for path: %{public}s", propertyPath.c_str());
        return nullptr;
    }
    napi_value result;
    status = napi_create_bigint_uint64(env, reinterpret_cast<uint64_t>(propertyTrigger), &result);
    if (status != napi_ok) {
        LOGE("Failed to create result");
        return nullptr;
    }
    LOGI("Trigger property found for path: %{public}s", propertyPath.c_str());
    return result;
}

napi_value ViewModelInstancePropertyImage(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO];
    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_TWO) {
        LOGE("Invalid arguments - expected view model instance reference and path");
        return nullptr;
    }

    uint64_t viewModelInstanceRef;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &viewModelInstanceRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get view model instance reference");
        return nullptr;
    }

    std::string propertyPath = NapiStringToString(env, args[ARG_NUM_ONE]);
    auto viewModelInstance = reinterpret_cast<rive::ViewModelInstanceRuntime *>(viewModelInstanceRef);
    if (!viewModelInstance) {
        LOGE("Invalid view model instance reference");
        return nullptr;
    }

    auto propertyImage = viewModelInstance->propertyImage(propertyPath);
    if (!propertyImage) {
        LOGE("Image property not found for path: %{public}s", propertyPath.c_str());
        return nullptr;
    }
    napi_value result;
    status = napi_create_bigint_uint64(env, reinterpret_cast<uint64_t>(propertyImage), &result);
    if (status != napi_ok) {
        LOGE("Failed to create result");
        return nullptr;
    }
    LOGI("Image property found for path: %{public}s", propertyPath.c_str());
    return result;
}

napi_value ViewModelInstancePropertyList(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO];
    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_TWO) {
        LOGE("Invalid arguments - expected view model instance reference and path");
        return nullptr;
    }

    uint64_t viewModelInstanceRef;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &viewModelInstanceRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get view model instance reference");
        return nullptr;
    }

    std::string propertyPath = NapiStringToString(env, args[ARG_NUM_ONE]);
    auto viewModelInstance = reinterpret_cast<rive::ViewModelInstanceRuntime *>(viewModelInstanceRef);
    if (!viewModelInstance) {
        LOGE("Invalid view model instance reference");
        return nullptr;
    }

    auto propertyList = viewModelInstance->propertyList(propertyPath);
    if (!propertyList) {
        LOGE("List property not found for path: %{public}s", propertyPath.c_str());
        return nullptr;
    }
    napi_value result;
    status = napi_create_bigint_uint64(env, reinterpret_cast<uint64_t>(propertyList), &result);
    if (status != napi_ok) {
        LOGE("Failed to create result");
        return nullptr;
    }
    LOGI("List property found for path: %{public}s", propertyPath.c_str());
    return result;
}

napi_value ViewModelInstancePropertyArtboard(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO];
    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_TWO) {
        LOGE("Invalid arguments - expected view model instance reference and path");
        return nullptr;
    }

    uint64_t viewModelInstanceRef;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &viewModelInstanceRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get view model instance reference");
        return nullptr;
    }

    std::string propertyPath = NapiStringToString(env, args[ARG_NUM_ONE]);
    auto viewModelInstance = reinterpret_cast<rive::ViewModelInstanceRuntime *>(viewModelInstanceRef);
    if (!viewModelInstance) {
        LOGE("Invalid view model instance reference");
        return nullptr;
    }

    auto propertyArtboard = viewModelInstance->propertyArtboard(propertyPath);
    if (!propertyArtboard) {
        LOGE("Artboard property not found for path: %{public}s", propertyPath.c_str());
        return nullptr;
    }
    napi_value result;
    status = napi_create_bigint_uint64(env, reinterpret_cast<uint64_t>(propertyArtboard), &result);
    if (status != napi_ok) {
        LOGE("Failed to create result");
        return nullptr;
    }
    LOGI("Artboard property found for path: %{public}s", propertyPath.c_str());
    return result;
}

napi_value ViewModelInstancePropertyInstance(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO];
    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_TWO) {
        LOGE("Invalid arguments - expected view model instance reference and path");
        return nullptr;
    }

    uint64_t viewModelInstanceRef;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &viewModelInstanceRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get view model instance reference");
        return nullptr;
    }

    std::string propertyPath = NapiStringToString(env, args[ARG_NUM_ONE]);
    auto viewModelInstance = reinterpret_cast<rive::ViewModelInstanceRuntime *>(viewModelInstanceRef);
    if (!viewModelInstance) {
        LOGE("Invalid view model instance reference");
        return nullptr;
    }

    auto propertyInstance = viewModelInstance->propertyViewModel(propertyPath);
    if (!propertyInstance) {
        LOGE("View model instance property not found for path: %{public}s", propertyPath.c_str());
        return nullptr;
    }
    napi_value result;
    status = napi_create_bigint_uint64(env, reinterpret_cast<uint64_t>(propertyInstance.release()), &result);
    if (status != napi_ok) {
        LOGE("Failed to create result");
        return nullptr;
    }
    LOGI("View model instance property found for path: %{public}s", propertyPath.c_str());
    return result;
}

napi_value ViewModelInstanceSetInstanceProperty(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_THREE;
    napi_value args[ARG_NUM_THREE];
    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_THREE) {
        LOGE("Invalid arguments - expected view model instance reference, path and property reference");
        return nullptr;
    }

    uint64_t viewModelInstanceRef;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &viewModelInstanceRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get view model instance reference");
        return nullptr;
    }

    std::string propertyPath = NapiStringToString(env, args[ARG_NUM_ONE]);
    uint64_t propertyRef;
    lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_TWO], &propertyRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get property instance reference");
        return nullptr;
    }
    auto viewModelInstance = reinterpret_cast<rive::ViewModelInstanceRuntime *>(viewModelInstanceRef);
    if (!viewModelInstance) {
        LOGE("Invalid view model instance reference");
        return nullptr;
    }
    auto propertyInstance = reinterpret_cast<rive::ViewModelInstanceRuntime *>(propertyRef);
    if (!propertyInstance) {
        LOGE("Invalid property instance reference");
        return nullptr;
    }

    bool result = viewModelInstance->replaceViewModel(propertyPath, propertyInstance);

    napi_value jsResult;
    status = napi_get_boolean(env, result, &jsResult);
    if (status != napi_ok) {
        LOGE("Failed to create boolean result");
        return nullptr;
    }
    return jsResult;
}

napi_value ViewModelInstanceRefInstance(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_ONE;
    napi_value args[ARG_NUM_ONE];
    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_ONE) {
        LOGE("Invalid arguments - expected view model instance reference");
        return nullptr;
    }

    uint64_t viewModelInstanceRef;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &viewModelInstanceRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get view model instance reference");
        return nullptr;
    }
    auto viewModelInstance = reinterpret_cast<rive::ViewModelInstanceRuntime *>(viewModelInstanceRef);
    if (!viewModelInstance) {
        LOGE("Invalid view model instance reference");
        return nullptr;
    }

    viewModelInstance->ref();
    LOGI("View model instance reference count increased");
    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value ViewModelInstanceDerefInstance(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_ONE;
    napi_value args[ARG_NUM_ONE];
    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_ONE) {
        LOGE("Invalid arguments - expected view model instance reference");
        return nullptr;
    }

    uint64_t viewModelInstanceRef;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &viewModelInstanceRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get view model instance reference");
        return nullptr;
    }
    auto viewModelInstance = reinterpret_cast<rive::ViewModelInstanceRuntime *>(viewModelInstanceRef);
    if (!viewModelInstance) {
        LOGE("Invalid view model instance reference");
        return nullptr;
    }

    viewModelInstance->unref();
    LOGI("View model instance reference count decreased");
    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value ViewModelPropertyName(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_ONE;
    napi_value args[ARG_NUM_ONE];
    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_ONE) {
        LOGE("Invalid arguments - expected view model property reference");
        return nullptr;
    }
    uint64_t propertyRef;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &propertyRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get view model property reference");
        return nullptr;
    }
    auto property = reinterpret_cast<rive::ViewModelInstanceValueRuntime *>(propertyRef);
    if (!property) {
        LOGE("Invalid view model property reference");
        return nullptr;
    }

    std::string name = property->name();
    napi_value result;
    status = napi_create_string_utf8(env, name.c_str(), name.length(), &result);
    if (status != napi_ok) {
        LOGE("Failed to create string result");
        return nullptr;
    }
    LOGI("View model property name: %{public}s", name.c_str());
    return result;
}

napi_value ViewModelPropertyHasChanged(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_ONE;
    napi_value args[ARG_NUM_ONE];
    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_ONE) {
        LOGE("Invalid arguments - expected view model property reference");
        return nullptr;
    }

    uint64_t propertyRef;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &propertyRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get view model property reference");
        return nullptr;
    }
    auto property = reinterpret_cast<rive::ViewModelInstanceValueRuntime *>(propertyRef);
    if (!property) {
        LOGE("Invalid view model property reference");
        return nullptr;
    }

    bool hasChanged = property->hasChanged();
    napi_value result;
    status = napi_get_boolean(env, hasChanged, &result);
    if (status != napi_ok) {
        LOGE("Failed to create boolean result");
        return nullptr;
    }
    LOGI("View model property changed status: %{public}s", hasChanged ? "true" : "false");
    return result;
}

napi_value ViewModelPropertyFlushChanges(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_ONE;
    napi_value args[ARG_NUM_ONE];
    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_ONE) {
        LOGE("Invalid arguments - expected view model property reference");
        return nullptr;
    }
    uint64_t propertyRef;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &propertyRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get view model property reference");
        return nullptr;
    }
    auto property = reinterpret_cast<rive::ViewModelInstanceValueRuntime *>(propertyRef);
    if (!property) {
        LOGE("Invalid view model property reference");
        return nullptr;
    }
    bool result = property->flushChanges();
    napi_value jsResult;
    status = napi_get_boolean(env, result, &jsResult);
    if (status != napi_ok) {
        LOGE("Failed to create boolean result");
        return nullptr;
    }
    LOGI("View model property flush changes %{public}s", result ? "successful" : "failed");
    return jsResult;
}

napi_value ViewModelNumberPropertyGetValue(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_ONE;
    napi_value args[ARG_NUM_ONE];
    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_ONE) {
        LOGE("Invalid arguments - expected view model number property reference");
        return nullptr;
    }

    uint64_t propertyRef;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &propertyRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get view model number property reference");
        return nullptr;
    }
    auto property = reinterpret_cast<rive::ViewModelInstanceNumberRuntime *>(propertyRef);
    if (!property) {
        LOGE("Invalid view model number property reference");
        return nullptr;
    }

    float value = property->value();
    napi_value result;
    status = napi_create_double(env, value, &result);
    if (status != napi_ok) {
        LOGE("Failed to create result");
        return nullptr;
    }
    LOGI("View model number property value: %{public}f", value);
    return result;
}

napi_value ViewModelNumberPropertySetValue(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO];
    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_TWO) {
        LOGE("Invalid arguments - expected view model number property reference and value");
        return nullptr;
    }

    uint64_t propertyRef;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &propertyRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get view model number property reference");
        return nullptr;
    }

    double value;
    status = napi_get_value_double(env, args[ARG_NUM_ONE], &value);
    if (status != napi_ok) {
        LOGE("Failed to get value");
        return nullptr;
    }
    auto property = reinterpret_cast<rive::ViewModelInstanceNumberRuntime *>(propertyRef);
    if (!property) {
        LOGE("Invalid view model number property reference");
        return nullptr;
    }

    property->value(static_cast<float>(value));
    LOGI("View model number property value set to: %{public}f", value);
    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value ViewModelStringPropertyGetValue(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_ONE;
    napi_value args[ARG_NUM_ONE];
    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_ONE) {
        LOGE("Invalid arguments - expected view model string property reference");
        return nullptr;
    }

    uint64_t propertyRef;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &propertyRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get view model string property reference");
        return nullptr;
    }
    auto property = reinterpret_cast<rive::ViewModelInstanceStringRuntime *>(propertyRef);
    if (!property) {
        LOGE("Invalid view model string property reference");
        return nullptr;
    }

    std::string value = property->value();
    napi_value result;
    status = napi_create_string_utf8(env, value.c_str(), value.length(), &result);
    if (status != napi_ok) {
        LOGE("Failed to create string result");
        return nullptr;
    }
    LOGI("View model string property value: %{public}s", value.c_str());
    return result;
}

napi_value ViewModelStringPropertySetValue(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO];
    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_TWO) {
        LOGE("Invalid arguments - expected view model string property reference and value");
        return nullptr;
    }

    uint64_t propertyRef;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &propertyRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get view model string property reference");
        return nullptr;
    }

    std::string stringValue = NapiStringToString(env, args[ARG_NUM_ONE]);
    auto property = reinterpret_cast<rive::ViewModelInstanceStringRuntime *>(propertyRef);
    if (!property) {
        LOGE("Invalid view model string property reference");
        return nullptr;
    }

    property->value(stringValue);
    LOGI("View model string property value set to: %{public}s", stringValue.c_str());
    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value ViewModelBooleanPropertyGetValue(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_ONE;
    napi_value args[ARG_NUM_ONE];
    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_ONE) {
        LOGE("Invalid arguments - expected view model boolean property reference");
        return nullptr;
    }

    uint64_t propertyRef;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &propertyRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get view model boolean property reference");
        return nullptr;
    }
    auto property = reinterpret_cast<rive::ViewModelInstanceBooleanRuntime *>(propertyRef);
    if (!property) {
        LOGE("Invalid view model boolean property reference");
        return nullptr;
    }

    bool value = property->value();

    napi_value result;
    status = napi_get_boolean(env, value, &result);
    if (status != napi_ok) {
        LOGE("Failed to create boolean result");
        return nullptr;
    }
    LOGI("View model boolean property value: %{public}s", value ? "true" : "false");
    return result;
}

napi_value ViewModelBooleanPropertySetValue(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO];
    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_TWO) {
        LOGE("Invalid arguments - expected view model boolean property reference and value");
        return nullptr;
    }

    uint64_t propertyRef;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &propertyRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get view model boolean property reference");
        return nullptr;
    }

    bool value;
    status = napi_get_value_bool(env, args[ARG_NUM_ONE], &value);
    if (status != napi_ok) {
        LOGE("Failed to get boolean value");
        return nullptr;
    }
    auto property = reinterpret_cast<rive::ViewModelInstanceBooleanRuntime *>(propertyRef);
    if (!property) {
        LOGE("Invalid view model boolean property reference");
        return nullptr;
    }

    property->value(value);
    LOGI("View model boolean property value set to: %{public}s", value ? "true" : "false");
    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value ViewModelColorPropertyGetValue(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_ONE;
    napi_value args[ARG_NUM_ONE];
    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_ONE) {
        LOGE("Invalid arguments - expected view model color property reference");
        return nullptr;
    }

    uint64_t propertyRef;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &propertyRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get view model color property reference");
        return nullptr;
    }
    auto property = reinterpret_cast<rive::ViewModelInstanceColorRuntime *>(propertyRef);
    if (!property) {
        LOGE("Invalid view model color property reference");
        return nullptr;
    }

    int value = property->value();
    napi_value result;
    status = napi_create_int32(env, value, &result);
    if (status != napi_ok) {
        LOGE("Failed to create result");
        return nullptr;
    }
    LOGI("View model color property value: 0x%{public}X", value);
    return result;
}

napi_value ViewModelColorPropertySetValue(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO];
    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_TWO) {
        LOGE("Invalid arguments - expected view model color property reference and value");
        return nullptr;
    }

    uint64_t propertyRef;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &propertyRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get view model color property reference");
        return nullptr;
    }

    int32_t value;
    status = napi_get_value_int32(env, args[ARG_NUM_ONE], &value);
    if (status != napi_ok) {
        LOGE("Failed to get color value");
        return nullptr;
    }
    auto property = reinterpret_cast<rive::ViewModelInstanceColorRuntime *>(propertyRef);
    if (!property) {
        LOGE("Invalid view model color property reference");
        return nullptr;
    }

    property->value(value);
    LOGI("View model color property value set to: 0x%{public}X", value);
    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value ViewModelEnumPropertyGetValue(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_ONE;
    napi_value args[ARG_NUM_ONE];
    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_ONE) {
        LOGE("Invalid arguments - expected view model enum property reference");
        return nullptr;
    }

    uint64_t propertyRef;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &propertyRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get view model enum property reference");
        return nullptr;
    }
    auto property = reinterpret_cast<rive::ViewModelInstanceEnumRuntime *>(propertyRef);
    if (!property) {
        LOGE("Invalid view model enum property reference");
        return nullptr;
    }

    std::string value = property->value();
    napi_value result;
    status = napi_create_string_utf8(env, value.c_str(), value.length(), &result);
    if (status != napi_ok) {
        LOGE("Failed to create string result");
        return nullptr;
    }
    LOGI("View model enum property value: %{public}s", value.c_str());
    return result;
}

napi_value ViewModelEnumPropertySetValue(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO];
    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_TWO) {
        LOGE("Invalid arguments - expected view model enum property reference and value");
        return nullptr;
    }

    uint64_t propertyRef;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &propertyRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get view model enum property reference");
        return nullptr;
    }

    std::string enumValue = NapiStringToString(env, args[ARG_NUM_ONE]);
    auto property = reinterpret_cast<rive::ViewModelInstanceEnumRuntime *>(propertyRef);
    if (!property) {
        LOGE("Invalid view model enum property reference");
        return nullptr;
    }
    property->value(enumValue);
    LOGI("View model enum property value set to: %{public}s", enumValue.c_str());
    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value ViewModelTriggerPropertyTrigger(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_ONE;
    napi_value args[ARG_NUM_ONE];
    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_ONE) {
        LOGE("Invalid arguments - expected view model trigger property reference");
        return nullptr;
    }

    uint64_t propertyRef;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &propertyRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get view model trigger property reference");
        return nullptr;
    }
    auto property = reinterpret_cast<rive::ViewModelInstanceTriggerRuntime *>(propertyRef);
    if (!property) {
        LOGE("Invalid view model trigger property reference");
        return nullptr;
    }

    property->trigger();
    LOGI("View model trigger property triggered");
    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value ViewModelImagePropertySetValue(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO];
    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_TWO) {
        LOGE("Invalid arguments - expected view model image property reference and image reference");
        return nullptr;
    }

    uint64_t propertyRef;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &propertyRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get view model image property reference");
        return nullptr;
    }

    uint64_t imageRef;
    lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ONE], &imageRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get image reference");
        return nullptr;
    }
    auto property = reinterpret_cast<rive::ViewModelInstanceAssetImageRuntime *>(propertyRef);
    if (!property) {
        LOGE("Invalid view model image property reference");
        return nullptr;
    }
    auto image = reinterpret_cast<rive::RenderImage *>(imageRef);
    if (!image) {
        LOGE("Invalid image reference");
        return nullptr;
    }

    property->value(image);
    LOGI("View model image property value set successfully");
    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value ViewModelListPropertySize(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_ONE;
    napi_value args[ARG_NUM_ONE];
    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_ONE) {
        LOGE("Invalid arguments - expected view model list property reference");
        return nullptr;
    }

    uint64_t propertyRef;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &propertyRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get view model list property reference");
        return nullptr;
    }
    auto property = reinterpret_cast<rive::ViewModelInstanceListRuntime *>(propertyRef);
    if (!property) {
        LOGE("Invalid view model list property reference");
        return nullptr;
    }

    int size = static_cast<int>(property->size());
    napi_value result;
    status = napi_create_int32(env, size, &result);
    if (status != napi_ok) {
        LOGE("Failed to create result");
        return nullptr;
    }
    LOGI("View model list property size: %{public}d", size);
    return result;
}

napi_value ViewModelListPropertyElementAt(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO];
    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_TWO) {
        LOGE("Invalid arguments - expected view model list property reference and index");
        return nullptr;
    }

    uint64_t propertyRef;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &propertyRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get view model list property reference");
        return nullptr;
    }
    int32_t index;
    status = napi_get_value_int32(env, args[ARG_NUM_ONE], &index);
    if (status != napi_ok) {
        LOGE("Failed to get element index");
        return nullptr;
    }
    auto property = reinterpret_cast<rive::ViewModelInstanceListRuntime *>(propertyRef);
    if (!property) {
        LOGE("Invalid view model list property reference");
        return nullptr;
    }

    auto element = property->instanceAt(index);
    if (!element) {
        LOGE("Element not found at index: %{public}d", index);
        return nullptr;
    }
    napi_value result;
    status = napi_create_bigint_uint64(env, reinterpret_cast<uint64_t>(element.release()), &result);
    if (status != napi_ok) {
        LOGE("Failed to create result");
        return nullptr;
    }
    LOGI("View model list element found at index: %{public}d", index);
    return result;
}

napi_value ViewModelListPropertyAdd(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO];
    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_TWO) {
        LOGE("Invalid arguments - expected view model list property reference and item reference");
        return nullptr;
    }

    uint64_t propertyRef;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &propertyRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get view model list property reference");
        return nullptr;
    }
    uint64_t itemRef;
    lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ONE], &itemRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get item reference");
        return nullptr;
    }
    auto property = reinterpret_cast<rive::ViewModelInstanceListRuntime *>(propertyRef);
    if (!property) {
        LOGE("Invalid view model list property reference");
        return nullptr;
    }
    auto item = reinterpret_cast<rive::ViewModelInstanceRuntime *>(itemRef);
    if (!item) {
        LOGE("Invalid item reference");
        return nullptr;
    }

    property->addInstance(item);
    LOGI("Item added to view model list property successfully");
    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value ViewModelListPropertyAddAt(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_THREE;
    napi_value args[ARG_NUM_THREE];
    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_THREE) {
        LOGE("Invalid arguments - expected view model list property reference, index and item reference");
        return nullptr;
    }

    uint64_t propertyRef;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &propertyRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get view model list property reference");
        return nullptr;
    }

    int32_t index;
    status = napi_get_value_int32(env, args[ARG_NUM_ONE], &index);
    if (status != napi_ok) {
        LOGE("Failed to get index");
        return nullptr;
    }
    uint64_t itemRef;
    lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_TWO], &itemRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get item reference");
        return nullptr;
    }
    auto property = reinterpret_cast<rive::ViewModelInstanceListRuntime *>(propertyRef);
    if (!property) {
        LOGE("Invalid view model list property reference");
        return nullptr;
    }
    auto item = reinterpret_cast<rive::ViewModelInstanceRuntime *>(itemRef);
    if (!item) {
        LOGE("Invalid item reference");
        return nullptr;
    }

    property->addInstanceAt(item, index);
    LOGI("Item added to view model list property at index: %{public}d", index);
    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value ViewModelListPropertyRemove(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO];
    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_TWO) {
        LOGE("Invalid arguments - expected view model list property reference and item reference");
        return nullptr;
    }
    uint64_t propertyRef;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &propertyRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get view model list property reference");
        return nullptr;
    }
    uint64_t itemRef;
    lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ONE], &itemRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get item reference");
        return nullptr;
    }
    auto property = reinterpret_cast<rive::ViewModelInstanceListRuntime *>(propertyRef);
    if (!property) {
        LOGE("Invalid view model list property reference");
        return nullptr;
    }
    auto item = reinterpret_cast<rive::ViewModelInstanceRuntime *>(itemRef);
    if (!item) {
        LOGE("Invalid item reference");
        return nullptr;
    }

    property->removeInstance(item);
    LOGI("Item removed from view model list property successfully");
    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value ViewModelListPropertyRemoveAt(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO];
    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_TWO) {
        LOGE("Invalid arguments - expected view model list property reference and index");
        return nullptr;
    }

    uint64_t propertyRef;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &propertyRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get view model list property reference");
        return nullptr;
    }
    int32_t index;
    status = napi_get_value_int32(env, args[ARG_NUM_ONE], &index);
    if (status != napi_ok) {
        LOGE("Failed to get index");
        return nullptr;
    }
    auto property = reinterpret_cast<rive::ViewModelInstanceListRuntime *>(propertyRef);
    if (!property) {
        LOGE("Invalid view model list property reference");
        return nullptr;
    }

    property->removeInstanceAt(index);
    LOGI("Item removed from view model list property at index: %{public}d", index);
    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value ViewModelListPropertySwap(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_THREE;
    napi_value args[ARG_NUM_THREE];
    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_THREE) {
        LOGE("Invalid arguments - expected view model list property reference and two indices");
        return nullptr;
    }

    uint64_t propertyRef;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &propertyRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get view model list property reference");
        return nullptr;
    }
    int32_t indexA;
    status = napi_get_value_int32(env, args[ARG_NUM_ONE], &indexA);
    if (status != napi_ok) {
        LOGE("Failed to get first index");
        return nullptr;
    }
    int32_t indexB;
    status = napi_get_value_int32(env, args[ARG_NUM_TWO], &indexB);
    if (status != napi_ok) {
        LOGE("Failed to get second index");
        return nullptr;
    }
    auto property = reinterpret_cast<rive::ViewModelInstanceListRuntime *>(propertyRef);
    if (!property) {
        LOGE("Invalid view model list property reference");
        return nullptr;
    }

    property->swap(indexA, indexB);
    LOGI("Items swapped at indices: %{public}d and %{public}d", indexA, indexB);
    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

static bool ExtractAndCheckReference(napi_env env, napi_value value, uint64_t &ref, const char *errorMsg)
{
    bool lossless = false;
    napi_status status = napi_get_value_bigint_uint64(env, value, &ref, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("%{public}s", errorMsg);
        return false;
    }
    return true;
}

napi_value ViewModelArtboardPropertySetArtboard(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_THREE;
    napi_value args[ARG_NUM_THREE];
    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_THREE) {
        LOGE(
            "Invalid arguments - expected view model artboard property reference, file reference and artboard "
            "reference");
        return nullptr;
    }

    uint64_t propertyRef = 0;
    uint64_t fileRef = 0;
    uint64_t artboardRef = 0;
    if (!ExtractAndCheckReference(env, args[ARG_NUM_ZERO], propertyRef,
                                  "Failed to get view model artboard property reference")) {
        return nullptr;
    }
    if (!ExtractAndCheckReference(env, args[ARG_NUM_ONE], fileRef, "Failed to get file reference")) {
        return nullptr;
    }
    if (!ExtractAndCheckReference(env, args[ARG_NUM_TWO], artboardRef, "Failed to get artboard reference")) {
        return nullptr;
    }

    auto property = reinterpret_cast<rive::ViewModelInstanceArtboardRuntime *>(propertyRef);
    if (!property) {
        LOGE("Invalid view model artboard property reference");
        return nullptr;
    }
    auto file = reinterpret_cast<rive::File *>(fileRef);
    if (!file) {
        LOGE("Invalid file reference");
        return nullptr;
    }
    auto artboard = reinterpret_cast<rive::Artboard *>(artboardRef);
    if (!artboard) {
        LOGE("Invalid artboard reference");
        return nullptr;
    }

    auto bindableArtboard = file->internalBindableArtboardFromArtboard(artboard);
    property->value(bindableArtboard);
    LOGI("View model artboard property value set successfully");
    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value ViewModelArtboardPropertySetBindableArtboard(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO];
    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_TWO) {
        LOGE("Invalid arguments - expected view model artboard property reference and bindable artboard reference");
        return nullptr;
    }

    uint64_t propertyRef;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &propertyRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get view model artboard property reference");
        return nullptr;
    }
    uint64_t bindableArtboardRef;
    lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ONE], &bindableArtboardRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get bindable artboard reference");
        return nullptr;
    }
    auto property = reinterpret_cast<rive::ViewModelInstanceArtboardRuntime *>(propertyRef);
    if (!property) {
        LOGE("Invalid view model artboard property reference");
        return nullptr;
    }
    auto bindableArtboard = reinterpret_cast<rive::BindableArtboard *>(bindableArtboardRef);
    if (!bindableArtboard) {
        LOGE("Invalid bindable artboard reference");
        return nullptr;
    }
    auto rcpBindableArtboard = rive::rcp(bindableArtboard);
    property->value(rcpBindableArtboard);

    rcpBindableArtboard.release();
    LOGI("View model bindable artboard property value set successfully");
    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}
} // namespace ohos_rive
