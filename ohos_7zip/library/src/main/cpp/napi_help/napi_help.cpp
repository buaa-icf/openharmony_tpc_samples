/*
 * Copyright (C) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "napi_help.h"
#include <napi/native_api.h>
#include <node_api.h>

namespace Oh7zip {

NapiHelp::NapiHelp(napi_env env) : env_(env)
{
}

NapiHelp::~NapiHelp()
{
}

napi_value NapiHelp::CreateString(const std::string &str)
{
    napi_value result = nullptr;
    napi_create_string_utf8(env_, str.c_str(), str.size(), &result);
    return result;
}

bool NapiHelp::CheckHasproperty(napi_value value, const std::string &name)
{
    bool isExist = false;
    napi_has_named_property(env_, value, name.c_str(), &isExist);
    return isExist;
}

napi_value NapiHelp::GetObjectProperty(napi_value object, const std::string &name)
{
    napi_value result = nullptr;
    napi_value nameValue = nullptr;

    nameValue = CreateString(name);
    napi_get_property(env_, object, nameValue, &result);
    return result;
}

std::string NapiHelp::GetString(napi_value object)
{
    constexpr size_t Max = 512;
    char buffer[Max] = {0};
    size_t len = 0;
    napi_get_value_string_utf8(env_, object, buffer, Max, &len);
    return std::string(buffer, len);
}

int NapiHelp::GetInt(napi_value object)
{
    int result = 0;
    napi_get_value_int32(env_, object, &result);
    return result;
}

std::vector<std::string> NapiHelp::GetVecStringFromObject(napi_value object, const std::string &name)
{
    std::vector<std::string> vec;
    napi_value value = GetObjectProperty(object, name);
    napi_valuetype type;
    napi_typeof(env_, value, &type);
    if (type == napi_string) {
        vec.push_back(GetString(value));
    } else if (type == napi_object) {
        uint32_t length = 0;
        napi_get_array_length(env_, value, &length);
        for (uint32_t i = 0; i < length; i++) {
            napi_value element;
            napi_get_element(env_, value, i, &element);
            vec.push_back(GetString(element));
        }
    }
    return vec;
}

std::string NapiHelp::GetStringFromObject(napi_value object, const std::string &name)
{
    napi_value value = GetObjectProperty(object, name);
    return GetString(value);
}

std::vector<napi_value> NapiHelp::GetCallbackInfoArgs(napi_callback_info info)
{
    size_t argc = 0;
    napi_get_cb_info(env_, info, &argc, nullptr, nullptr, nullptr);
    std::vector<napi_value> vec(argc, nullptr);
    napi_get_cb_info(env_, info, &argc, vec.data(), nullptr, nullptr);
    return vec;
}

napi_value NapiHelp::GetCallbackInfoJsObject(napi_callback_info info)
{
    napi_value jsObject;
    napi_get_cb_info(env_, info, nullptr, nullptr, &jsObject, nullptr);
    return jsObject;
}

napi_value NapiHelp::CreateInt32(int32_t number)
{
    napi_value result;
    napi_create_int32(env_, number, &result);
    return result;
}

void *NapiHelp::Unwrap(napi_value jsObject)
{
    void *result = nullptr;
    napi_unwrap(env_, jsObject, &result);
    return result;
}

void NapiHelp::Wrap(napi_value jsObject, napi_finalize finalize_cb, void *finalize)
{
    napi_wrap(env_, jsObject, finalize, finalize_cb, nullptr, nullptr);
}

void NapiHelp::DefineClass(const std::string &className, napi_callback callback, const napi_property_descriptor *des,
                           size_t size, napi_value *result)
{
    napi_define_class(env_, className.c_str(), NAPI_AUTO_LENGTH, callback, nullptr, size, des, result);
}

napi_ref *NapiHelp::CreateReference(napi_value value, size_t count)
{
    napi_ref *ref = new napi_ref;
    napi_create_reference(env_, value, count, ref);
    return ref;
}

void NapiHelp::SetProportyWithName(napi_value object, const std::string &name, napi_value proporty)
{
    napi_set_named_property(env_, object, name.c_str(), proporty);
}

void NapiHelp::CreatePromise(napi_deferred *deferred, napi_value *promise)
{
    napi_create_promise(env_, deferred, promise);
}

void NapiHelp::CreateAsyncWorker(const std::string &name, napi_async_execute_callback execute,
                                 napi_async_complete_callback complete, void *data, napi_async_work *result)
{
    napi_value jsName = CreateString(name);
    napi_create_async_work(env_, nullptr, jsName, execute, complete, data, result);
}

void NapiHelp::DeleteAsyncWorker(napi_async_work worker)
{
    napi_delete_async_work(env_, worker);
}

void NapiHelp::QueueAsyncWorker(napi_async_work work, napi_qos_t qos)
{
    napi_queue_async_work_with_qos(env_, work, qos);
}

void NapiHelp::ResolveDeferred(napi_deferred deferred, napi_value resolution)
{
    napi_resolve_deferred(env_, deferred, resolution);
}

}