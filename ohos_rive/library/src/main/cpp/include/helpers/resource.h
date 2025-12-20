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

#ifndef OHOS_RIVE_RESOURCE_H
#define OHOS_RIVE_RESOURCE_H

#include "napi/native_api.h"
#include <arkui/native_node_napi.h>
#include <vector>

namespace ohos_rive {
template <typename T>
class NativeResource {
private:
    T resource;
    napi_env env;

public:
    NativeResource(const NativeResource &) = delete;
    NativeResource &operator=(const NativeResource &) = delete;

    NativeResource(T res, napi_env env) : resource(res), env(env) {}

    NativeResource(NativeResource &&other) noexcept : resource(other.resource), env(other.env)
    {
        other.resource = nullptr;
        other.env = nullptr;
    }

    ~NativeResource() noexcept
    {
        if (resource != nullptr) {
            if constexpr (std::is_same_v<T, napi_ref>) {
                napi_delete_reference(env, resource);
            }
            resource = nullptr;
        }
    }

    NativeResource &operator=(NativeResource &&other) noexcept
    {
        if (this != &other) {
            if (resource && env) {
                if (std::is_same<T, napi_ref>::value) {
                    napi_delete_reference(env, resource);
                }
            }
            resource = other.resource;
            env = other.env;
            other.resource = nullptr;
            other.env = nullptr;
        }
        return *this;
    }

    explicit operator T() const
    {
        return resource;
    }

    T Get() const
    {
        return resource;
    }

    T Release() noexcept
    {
        T toRelease = resource;
        resource = nullptr;
        return toRelease;
    }
};

template <typename T>
NativeResource<T> MakeNativeResource(T res, napi_env env)
{
    return NativeResource<T>(res, env);
}

void RegisterClass(napi_env env, napi_value args[], size_t argc);
void UnregisterClass(napi_env env, napi_value args[], size_t argc);

NativeResource<napi_value> FindClass(napi_env env, const char *name);

NativeResource<napi_value> GetObjectClass(napi_env env, napi_value obj);

NativeResource<napi_value> GetStaticObjectField(napi_env env, napi_value clazz, const char *fieldName);

NativeResource<napi_value> GetObjectFromMethod(napi_env env,
                                               napi_value obj,
                                               const char *methodName,
                                               int argc,
                                               napi_value *argv);

NativeResource<napi_value> GetObjectArrayElement(napi_env env, napi_value jarray, size_t index);

NativeResource<napi_value> MakeObject(napi_env env, napi_value method, int argsCount, napi_value *args);

NativeResource<napi_value> MakeNapiString(napi_env env, const char *str);
NativeResource<napi_value> MakeNapiString(napi_env env, const std::string &str);

std::vector<uint8_t> ByteArrayToUint8Vec(napi_env env, napi_value byteArray);
NativeResource<napi_value> VecStringToNapiStringList(napi_env env, const std::vector<std::string> &strs);

} // namespace ohos_rive

#endif // OHOS_RIVE_RESOURCE_H

