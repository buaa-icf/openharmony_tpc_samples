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

#ifndef UTILS_NAPI_HANDLER_H
#define UTILS_NAPI_HANDLER_H
#include "napi_async_handler.h"
#include "napi_threadsafe_handler.h"
#include "native_common.h"
#include "ohos_log.h"
#include <functional>
#include <napi/native_api.h>
#include <cinttypes>
#include <string>
#include <unordered_map>
#include "napi_safe_wrapper.h"

class NapiHandler {
public:
    NapiHandler(const napi_env &env, napi_callback_info &info, int argn = 0);
    explicit NapiHandler(const napi_env &env);
    virtual ~NapiHandler();

    napi_env GetEnv() const;
    napi_value GetArg(int32_t index);
    napi_value GetThis();

    napi_value CreateObject();

    bool HasArgIndex(int index);
    napi_valuetype GetArgType(int index);

    template <typename T>
    T ParseArg(const napi_value &arg) const;

    template <typename T>
    T ParseArgAs(int index) const;

    template <typename T>
    T ParseArgAs(int index, const Parser<T> &doArgs) const;

    std::shared_ptr<NapiThreadsafeHandler> ParseSafeMethod(int index, const std::string &method);

    napi_value GetVoidValue();
    void DelRefValue(napi_ref ref);

    template <class T>
    napi_value GetNapiValue(const T &v);

    template <class T>
    napi_value GetNapiValue(const T &v, const Serializer<T> &doSerialize);

    template <class T>
    void SetObjectProp(napi_value &obj, const std::string &prop, const T &value);

    template <class T>
    void SetObjectProp(napi_value &obj, const std::string &prop, const T &value, const Serializer<T> doSerialize);

    template <class T>
    T GetObjectProp(int index, const std::string &prop, const Parser<T> &doArgs);

    bool HasObjectProp(int index, const std::string &prop);

    template <class T>
    T GetObjectProp(int index, const std::string &prop);

    template <class T>
    T GetObjectProp(napi_value obj, const std::string &prop, const Parser<T> &doArgs);

    template <class T>
    T GetObjectProp(napi_value obj, const std::string &prop);

    template <class T>
    T CallMethod(const napi_ref &funcRef, const std::vector<napi_value> &args = {});

    template <class T>
    T CallMethod(const napi_ref &funcRef, const std::vector<napi_value> &args, const Parser<T> &doArgs);

    napi_value CreateArray(int len, const std::function<napi_value(int)> &doArray);

    napi_value BindObject(void *object, napi_finalize destructor);
    void *UnbindObject();

    template <class T>
    napi_value BindSendableObject(const std::shared_ptr<T> &object, napi_finalize destructor);

    template <class T>
    std::shared_ptr<T> *UnbindSendableObject();

    template <class T>
    napi_value BindSafeObject(const std::shared_ptr<T> &object, napi_finalize destructor);

    template <class T>
    napi_value AttachSafeObject(const std::shared_ptr<T> &object, napi_value instance);

    template <class T>
    std::shared_ptr<T> UnbindSafeObject();

    template <class T>
    void ReleaseSafeObject();

    template <class T>
    void DeleteSafeObject(void *ptr);

    template <typename T>
    napi_value PromiseCall(
        const std::string &resName, const AsyncWorker<T> &workFunc, const AsyncFinalizer<T> &finishFunc = nullptr,
        const AsyncFree<T> &freeWork = nullptr);

    template <class T>
    static T DefaultValue();

private:
    napi_env env_;
    size_t argc_ = 0;
    napi_value *argv_ = nullptr;
    napi_value thisArg_ = nullptr;
    void *data_ = nullptr;
    napi_ref instance_;
};

#include "napi_handler_hpp.h"
#endif // UTILS_NAPI_HANDLER_H
