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
#include "native_common.h"
#include "ohos_log.h"
#include <functional>
#include <napi/native_api.h>
#include <cinttypes>
#include <string>
#include <unordered_map>
#include "napi_object.h"

const int32_t NAPI_MAX_ARGV = 8;
const int32_t INDEX_0 = 0;
const int32_t INDEX_1 = 1;
const int32_t INDEX_2 = 2;
const int32_t INDEX_3 = 3;
const int32_t INDEX_4 = 4;
const int32_t INDEX_5 = 5;
const int32_t INDEX_6 = 6;
const int32_t INDEX_7 = 7;
const int32_t PARAM_COUNT_0 = 0;
const int32_t PARAM_COUNT_1 = 1;
const int32_t PARAM_COUNT_2 = 2;
const int32_t PARAM_COUNT_3 = 3;
const int32_t PARAM_COUNT_4 = 4;
const int32_t PARAM_COUNT_5 = 5;
const int32_t PARAM_COUNT_6 = 6;
const int32_t PARAM_COUNT_7 = 7;
const int32_t PARAM_COUNT_8 = 8;

using ArrayBuffer = std::vector<uint8_t>;

template <class T>
using Parser = std::function<T(const napi_value &)>;
template <class T>
using Serializer = std::function<napi_value(const T &)>;

class NapiHandler {
public:
    NapiHandler(const napi_env &env, napi_callback_info &info, int argn = 0);
    explicit NapiHandler(const napi_env &env);
    virtual ~NapiHandler();

    napi_env GetEnv()
    {
        return env_;
    }

    napi_value GetArg(int32_t index);
    napi_value CreateObject();
    napi_status ParseArgs(int index, const std::function<napi_status(const napi_value &)> &doArgs);

    bool HasArgIndex(int index);
    napi_valuetype GetArgType(int index);

    template <typename T>
    T ParseArg(const napi_value &arg) const;

    template <typename T>
    T ParseArgAs(int index) const
    {
        T result;
        NAPI_ASSERT_BASE(env_, index < argc_, "Index out of range", result);
        result = ParseArg<T>(argv_[index]);
        return result;
    }

    template <typename T>
    T ParseArgAs(int index, const Parser<T> &doArgs) const
    {
        T result;
        NAPI_ASSERT_BASE(env_, index < argc_, "Index out of range", result);
        result = doArgs(argv_[index]);
        return result;
    }

    napi_value GetVoidValue();
    void DelRefValue(napi_ref ref);

    template <class T>
    napi_value GetNapiValue(const T &v);
    template <class T>
    napi_value GetNapiValue(const T &v, const Serializer<T> &doSerialize)
    {
        return doSerialize(v);
    }

    template <class T>
    void SetObjectProp(napi_value &obj, const std::string &prop, const T &value)
    {
        napi_value result = GetNapiValue<T>(value);
        if (result == nullptr) {
            return;
        }
        napi_set_named_property(env_, obj, prop.c_str(), result);
    }

    template <class T>
    void SetObjectProp(napi_value &obj, const std::string &prop, const T &value, const Serializer<T> doSerialize)
    {
        napi_value result = GetNapiValue<T>(value, doSerialize);
        if (result == nullptr) {
            return;
        }
        napi_set_named_property(env_, obj, prop.c_str(), result);
    }

    template <class T>
    T GetObjectProp(int index, const std::string &prop, const Parser<T> &doArgs)
    {
        napi_value result;
        T t;
        NAPI_ASSERT_BASE(env_, index < argc_, "Index out of range", result);
        return GetObjectProp<T>(argv_[index], prop, doArgs);
    }

    bool HasObjectProp(int index, const std::string &prop);

    template <class T>
    T GetObjectProp(int index, const std::string &prop)
    {
        T t;
        napi_value result;
        NAPI_ASSERT_BASE(env_, index < argc_, "Index out of range", t);
        return GetObjectProp<T>(argv_[index], prop);
    }

    template <class T>
    T GetObjectProp(napi_value obj, const std::string &prop, const Parser<T> &doArgs)
    {
        napi_value result;
        T t;
        NAPI_CALL_HANDLE(env_, napi_get_named_property(env_, obj, prop.c_str(), &result), t);
        return doArgs(result);
    }

    template <class T>
    T GetObjectProp(napi_value obj, const std::string &prop)
    {
        T t;
        napi_value result;
        NAPI_CALL_HANDLE(env_, napi_get_named_property(env_, obj, prop.c_str(), &result), t);
        return ParseArg<T>(result);
    }

    void QueueWork(const napi_ref &funcRef, const std::vector<napi_value> &args = {});

    template <class T>
    T CallMethod(const napi_ref &funcRef, const std::vector<napi_value> &args = {})
    {
        napi_value jsFunc;
        NAPI_CALL_HANDLE(env_, napi_get_reference_value(env_, funcRef, &jsFunc), DefaultValue<T>());
        napi_value result;
        NAPI_CALL_HANDLE(
            env_, napi_call_function(env_, nullptr, jsFunc, args.size(), args.data(), &result), DefaultValue<T>());
        return ParseArg<T>(result);
    }

    template <class T>
    T CallMethod(const napi_ref &funcRef, const std::vector<napi_value> &args, const Parser<T> &doArgs)
    {
        T v;
        napi_value jsFunc;
        NAPI_CALL_HANDLE(env_, napi_get_reference_value(env_, funcRef, &jsFunc), v);
        napi_value result;
        NAPI_CALL_HANDLE(env_, napi_call_function(env_, nullptr, jsFunc, args.size(), args.data(), &result), v);
        if (doArgs != nullptr) {
            v = doArgs(result);
        }
        return v;
    }

    napi_value CreateArray(int len, const std::function<napi_value(int)> &doArray);

    napi_value BindObject(void *object, napi_finalize destructor);
    template <class T>
    T *UnbindObject()
    {
        T *t = nullptr;
        NAPI_CALL_HANDLE(env_, napi_unwrap(env_, thisArg_, reinterpret_cast<void **>(&t)), t);
        return t;
    }

    napi_value BindSendableObject(NapiObject *object, napi_finalize destructor);
    template <class T>
    T *UnbindSendableObject()
    {
        T *t = nullptr;
        NAPI_CALL_HANDLE(env_, napi_unwrap_sendable(env_, thisArg_, reinterpret_cast<void **>(&t)), t);
        return t;
    }

    napi_value BindSafeObject(const std::shared_ptr<NapiObject> &object, napi_finalize destructor);
    std::shared_ptr<NapiObject> UnbindSafeObject();
    void UnrefSafeObject(void *ptr);
    std::shared_ptr<NapiObject> GetSafeObject(void *ptr);

    napi_value Promise(NapiAsyncHandler *asyncHandler);
    void JsCall(NapiAsyncHandler *asyncHandler);

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
#endif // UTILS_NAPI_HANDLER_H
