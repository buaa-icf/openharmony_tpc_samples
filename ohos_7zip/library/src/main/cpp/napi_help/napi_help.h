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

#ifndef __7Z_NAPI_HELLP_H__
#define __7Z_NAPI_HELLP_H__

#include <js_native_api.h>
#include <js_native_api_types.h>

#include <napi/common.h>
#include <node_api_types.h>
#include <string>
namespace Oh7zip {
class NapiHelp {
public:
    explicit NapiHelp(napi_env env);
    ~NapiHelp();
    napi_value CreateString(std::string str);
    bool CheckHasproperty(napi_value value, std::string name);
    napi_value GetObjectProperty(napi_value object, std::string& name);
    std::string GetString(napi_value object);
    std::string GetStringFromObject(napi_value object, std::string name);
    std::vector<napi_value> GetCallbackInfoArgs(napi_callback_info info);
    napi_value GetCallbackInfoJsObject(napi_callback_info info);
    napi_value CreateInt32(int32_t number);
    void *Unwrap(napi_value jsObject);
    void Wrap(napi_value jsObject, napi_finalize finalize_cb, void *finalize);
    void DefineClass(std::string className, napi_callback callback, const napi_property_descriptor *des, size_t size,
                     napi_value *result);
    napi_ref *CreateReference(napi_value value, size_t count);
    void SetProportyWithName(napi_value object, std::string name, napi_value proporty);
    void CreatePromise(napi_deferred *deferred, napi_value *promise);
    void CreateAsyncWorker(const std::string& name, napi_async_execute_callback execute, napi_async_complete_callback complete,
                           void *data, napi_async_work *result);
    void DeleteAsyncWorker(napi_async_work worker);
    void QueueAsyncWorker(napi_async_work work, napi_qos_t qos);
    void ResolveDeferred(napi_deferred deferred, napi_value resolution);

private:
    napi_env env_;
};
} // namespace Oh7zip

#endif