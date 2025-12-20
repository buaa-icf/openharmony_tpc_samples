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

#include "../../include/helpers/resource.h"
#include "../../include/helpers/general.h"

#include <codecvt>
#include <locale>
#include <string>
#include <vector>

namespace ohos_rive {
constexpr size_t ARG_NUM_ONE = 1;
constexpr size_t ARG_NUM_TWO = 2;
constexpr size_t BUFFER_SIZE = 256;

std::unordered_map<std::string, napi_ref> g_classRegistry;

static std::string GetClassName(napi_env env, napi_value cls)
{
    if (!env || !cls) {
        return "";
    }

    napi_valuetype type;
    napi_typeof(env, cls, &type);
    if (type != napi_function) {
        return "";
    }

    napi_value nameValue;
    napi_status status = napi_get_named_property(env, cls, "name", &nameValue);
    if (status != napi_ok) {
        return "";
    }

    char buffer[BUFFER_SIZE] = {0};
    size_t length = 0;
    status = napi_get_value_string_utf8(env, nameValue, buffer, sizeof(buffer) - 1, &length);
    if (status != napi_ok) {
        return "";
    }

    return std::string(buffer, length);
}

std::string GetEnumName(napi_env env, napi_value enumName)
{
    std::string enumNameStr;
    size_t length = 0;
    if (enumName == nullptr) {
        LOGE("Failed to parse arguments for RegisterClass");
        return "";
    }
    auto status = napi_get_value_string_utf8(env, enumName, nullptr, 0, &length);
    if (status != napi_ok || length == 0) {
        LOGE("Failed to parse arguments for RegisterClass");
        return "";
    }
    enumNameStr.resize(length);
    status = napi_get_value_string_utf8(env, enumName, &enumNameStr[0], length + 1, &length);
    if (status != napi_ok) {
        LOGE("Failed to parse arguments for RegisterClass");
        return "";
    }
    return enumNameStr;
}

void RegisterClass(napi_env env, napi_value args[], size_t argc)
{
    std::string className;
    if (argc == ARG_NUM_ONE) {
        className = GetClassName(env, args[0]);
    } else if (argc == ARG_NUM_TWO) {
        className = GetEnumName(env, args[ARG_NUM_ONE]);
    }

    if (className.empty()) {
        return;
    }

    napi_ref classRef;
    napi_create_reference(env, args[0], 1, &classRef);
    g_classRegistry[className] = classRef;
}

void UnregisterClass(napi_env env, napi_value args[], size_t argc)
{
    std::string className;
    if (argc == ARG_NUM_ONE) {
        className = GetClassName(env, args[0]);
    } else if (argc == ARG_NUM_TWO) {
        className = GetEnumName(env, args[ARG_NUM_ONE]);
    }

    if (className.empty()) {
        return;
    }

    auto it = g_classRegistry.find(className);
    if (it != g_classRegistry.end()) {
        napi_delete_reference(env, it->second);
        g_classRegistry.erase(it);
    }
}

NativeResource<napi_value> FindClass(napi_env env, const char *name)
{
    if (!name) {
        return NativeResource<napi_value>(nullptr, env);
    }

    auto it = g_classRegistry.find(std::string(name));
    if (it != g_classRegistry.end()) {
        napi_value clazz;
        napi_status status = napi_get_reference_value(env, it->second, &clazz);
        if (status == napi_ok) {
            return NativeResource<napi_value>(clazz, env);
        }
    }

    return NativeResource<napi_value>(nullptr, env);
}

NativeResource<napi_value> GetObjectClass(napi_env env, napi_value obj)
{
    napi_value prototype;
    napi_status status = napi_get_prototype(env, obj, &prototype);
    if (status != napi_ok) {
        return NativeResource<napi_value>(nullptr, env);
    }

    return NativeResource<napi_value>(prototype, env);
}

NativeResource<napi_value> GetStaticObjectField(napi_env env, napi_value clazz, const char *fieldName)
{
    napi_value value;
    napi_status status = napi_get_named_property(env, clazz, fieldName, &value);
    if (status != napi_ok) {
        return NativeResource<napi_value>(nullptr, env);
    }

    return NativeResource<napi_value>(value, env);
}

NativeResource<napi_value> GetObjectFromMethod(napi_env env,
                                               napi_value obj,
                                               const char *methodName,
                                               int argc,
                                               napi_value *argv)
{
    napi_value method;
    napi_status status = napi_get_named_property(env, obj, methodName, &method);
    if (status != napi_ok) {
        LOGE("Failed to get method(%s): %d", methodName, status);
        return NativeResource<napi_value>(nullptr, env);
    }

    napi_valuetype valueType;
    status = napi_typeof(env, method, &valueType);
    if (status != napi_ok || valueType != napi_function) {
        LOGE("method(%s) is not a function: %d", methodName, status);
        return NativeResource<napi_value>(nullptr, env);
    }

    napi_value result = nullptr;
    status = napi_call_function(env, obj, method, argc, argv, &result);
    if (status != napi_ok) {
        LOGE("Failed to call method(%s): %d", methodName, status);
        return NativeResource<napi_value>(nullptr, env);
    }

    return NativeResource<napi_value>(result, env);
}

NativeResource<napi_value> GetObjectArrayElement(napi_env env, napi_value jarray, size_t index)
{
    napi_value element;
    napi_status status = napi_get_element(env, jarray, static_cast<uint32_t>(index), &element);
    if (status != napi_ok) {
        return NativeResource<napi_value>(nullptr, env);
    }

    return NativeResource<napi_value>(element, env);
}

NativeResource<napi_value> MakeObject(napi_env env, napi_value method, int argsCount, napi_value *args)
{
    napi_valuetype valueType;
    napi_status status = napi_typeof(env, method, &valueType);
    if (status != napi_ok || valueType != napi_function) {
        return NativeResource<napi_value>(nullptr, env);
    }

    napi_value result = nullptr;
    status = napi_new_instance(env, method, argsCount, args, &result);
    if (status != napi_ok) {
        return NativeResource<napi_value>(nullptr, env);
    }

    return NativeResource<napi_value>(result, env);
}

NativeResource<napi_value> MakeNapiString(napi_env env, const char *str)
{
    if (!str) {
        return NativeResource<napi_value>(nullptr, env);
    }

    napi_value value;
    napi_status status = napi_create_string_utf8(env, str, NAPI_AUTO_LENGTH, &value);
    if (status != napi_ok) {
        return NativeResource<napi_value>(nullptr, env);
    }

    return NativeResource<napi_value>(value, env);
}

NativeResource<napi_value> MakeNapiString(napi_env env, const std::string &str)
{
    return MakeNapiString(env, str.c_str());
}

void ArrayBufferProcess(napi_env env, napi_value byteArray, std::vector<uint8_t> &result)
{
    uint32_t arrayLength = 0;
    if (napi_get_array_length(env, byteArray, &arrayLength) != napi_ok) {
        return;
    }
    result.resize(arrayLength);
    for (uint32_t i = 0; i < arrayLength; i++) {
        napi_value element;
        if (napi_get_element(env, byteArray, i, &element) == napi_ok) {
            double value;
            if (napi_get_value_double(env, element, &value) == napi_ok) {
                result[i] = static_cast<uint8_t>(value);
            }
        }
    }
}

std::vector<uint8_t> ByteArrayToUint8Vec(napi_env env, napi_value byteArray)
{
    std::vector<uint8_t> result;
    void *data = nullptr;
    size_t length = 0;
    bool isTypedArray = false;
    napi_is_typedarray(env, byteArray, &isTypedArray);
    if (isTypedArray) {
        napi_typedarray_type arrayType;
        napi_value buffer;
        size_t byteOffset;
        napi_status status = napi_get_typedarray_info(env, byteArray, &arrayType, &length, &data, &buffer, &byteOffset);
        if (status != napi_ok) {
            LOGE("Failed to get typed array info, status: %d", status);
            return result;
        }

        if (arrayType != napi_uint8_array) {
            LOGE("Invalid typed array type: expected napi_uint8_array, got %d", arrayType);
            return result;
        }
    } else {
        bool isArrayBuffer = false;
        napi_is_arraybuffer(env, byteArray, &isArrayBuffer);
        if (isArrayBuffer) {
            napi_status status = napi_get_arraybuffer_info(env, byteArray, &data, &length);
            if (status != napi_ok) {
                LOGE("Failed to get array buffer info, status: %d", status);
                return result;
            }
        } else {
            LOGW("Input is neither a TypedArray nor an ArrayBuffer");
            ArrayBufferProcess(env, byteArray, result);
            return result;
        }
    }

    result.assign(static_cast<uint8_t *>(data), static_cast<uint8_t *>(data) + length);
    return result;
}

NativeResource<napi_value> VecStringToNapiStringList(napi_env env, const std::vector<std::string> &strs)
{
    napi_value array;
    napi_status status = napi_create_array_with_length(env, strs.size(), &array);
    if (status != napi_ok) {
        return NativeResource<napi_value>(nullptr, env);
    }

    for (size_t i = 0; i < strs.size(); i++) {
        auto str = MakeNapiString(env, strs[i]);
        if (str.Get()) {
            status = napi_set_element(env, array, static_cast<uint32_t>(i), str.Get());
        }
    }

    return NativeResource<napi_value>(array, env);
}
} // namespace ohos_rive
