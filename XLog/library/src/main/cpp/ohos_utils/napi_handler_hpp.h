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

#ifndef UTILS_NAPI_HANDLER_HPP_H
#define UTILS_NAPI_HANDLER_HPP_H
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
#include "napi_handler.h"
#include "napi_async_data.h"

template <typename T>
T NapiHandler::ParseArgAs(int index) const
{
    T result = {};
    NAPI_ASSERT_BASE(env_, static_cast<size_t>(index) < argc_, "Index out of range", result);
    result = ParseArg<T>(argv_[index]);
    return result;
}

template <typename T>
T NapiHandler::ParseArgAs(int index, const Parser<T> &doArgs) const
{
    T result;
    NAPI_ASSERT_BASE(env_, static_cast<size_t>(index) < argc_, "Index out of range", result);
    result = doArgs(env_, argv_[index]);
    return result;
}

template <class T>
napi_value NapiHandler::GetNapiValue(const T &v, const Serializer<T> &doSerialize)
{
    return doSerialize(env_, v);
}

template <class T>
void NapiHandler::SetObjectProp(napi_value &obj, const std::string &prop, const T &value)
{
    napi_value result = GetNapiValue<T>(value);
    if (result == nullptr) {
        return;
    }
    napi_set_named_property(env_, obj, prop.c_str(), result);
}

template <class T>
void NapiHandler::SetObjectProp(
    napi_value &obj, const std::string &prop, const T &value, const Serializer<T> doSerialize)
{
    napi_value result = GetNapiValue<T>(value, doSerialize);
    if (result == nullptr) {
        return;
    }
    napi_set_named_property(env_, obj, prop.c_str(), result);
}

template <class T>
T NapiHandler::GetObjectProp(int index, const std::string &prop, const Parser<T> &doArgs)
{
    napi_value result;
    T t;
    NAPI_ASSERT_BASE(env_, static_cast<size_t>(index) < argc_, "Index out of range", result);
    return GetObjectProp<T>(argv_[index], prop, doArgs);
}

template <class T>
T NapiHandler::GetObjectProp(int index, const std::string &prop)
{
    T t;
    NAPI_ASSERT_BASE(env_, static_cast<size_t>(index) < argc_, "Index out of range", t);
    return GetObjectProp<T>(argv_[index], prop);
}

template <class T>
T NapiHandler::GetObjectProp(napi_value obj, const std::string &prop, const Parser<T> &doArgs)
{
    napi_value result;
    T t;
    NAPI_CALL_HANDLE(env_, napi_get_named_property(env_, obj, prop.c_str(), &result), t);
    return doArgs(env_, result);
}

template <class T>
T NapiHandler::GetObjectProp(napi_value obj, const std::string &prop)
{
    T t;
    napi_value result;
    NAPI_CALL_HANDLE(env_, napi_get_named_property(env_, obj, prop.c_str(), &result), t);
    return ParseArg<T>(result);
}

template <class T>
T NapiHandler::CallMethod(const napi_ref &funcRef, const std::vector<napi_value> &args)
{
    napi_value jsFunc;
    NAPI_CALL_HANDLE(env_, napi_get_reference_value(env_, funcRef, &jsFunc), DefaultValue<T>());
    napi_value result;
    NAPI_CALL_HANDLE(
        env_, napi_call_function(env_, nullptr, jsFunc, args.size(), args.data(), &result), DefaultValue<T>());
    return ParseArg<T>(result);
}

template <class T>
T NapiHandler::CallMethod(const napi_ref &funcRef, const std::vector<napi_value> &args, const Parser<T> &doArgs)
{
    T v;
    napi_value jsFunc;
    NAPI_CALL_HANDLE(env_, napi_get_reference_value(env_, funcRef, &jsFunc), v);
    napi_value result;
    NAPI_CALL_HANDLE(env_, napi_call_function(env_, nullptr, jsFunc, args.size(), args.data(), &result), v);
    if (doArgs != nullptr) {
        v = doArgs(env_, result);
    }
    return v;
}

template <class T>
napi_value NapiHandler::BindSendableObject(const std::shared_ptr<T> &object, napi_finalize destructor)
{
    NapiSafeWrapper<T> *wrapper = new NapiSafeWrapper<T>(object);
    NAPI_CALL(env_, napi_wrap_sendable(env_, thisArg_, static_cast<void *>(wrapper), destructor, nullptr));
    return thisArg_;
}

template <class T>
std::shared_ptr<T> *NapiHandler::UnbindSendableObject()
{
    NapiSafeWrapper<T> *t = nullptr;
    NAPI_CALL_HANDLE(env_, napi_unwrap_sendable(env_, thisArg_, reinterpret_cast<void **>(&t)), t);
    if (t == nullptr) {
        return nullptr;
    }
    return t->GetSafeObject();
}

template <class T>
napi_value NapiHandler::BindSafeObject(const std::shared_ptr<T> &object, napi_finalize destructor)
{
    NapiSafeWrapper<T> *wrapper = new NapiSafeWrapper<T>(object);
    napi_ref ref = nullptr;
    NAPI_CALL(env_, napi_wrap(env_, thisArg_, static_cast<void *>(wrapper), destructor, nullptr, nullptr));
    wrapper->SetJsWrapper(env_, ref);
    return thisArg_;
}

template <class T>
napi_value NapiHandler::AttachSafeObject(const std::shared_ptr<T> &object, napi_value instance)
{
    NapiSafeWrapper<T> *t = nullptr;
    NAPI_CALL_HANDLE(env_, napi_unwrap(env_, instance, reinterpret_cast<void **>(&t)), nullptr);
    if (t == nullptr) {
        return nullptr;
    }
    t->SetSafeObject(object);
    return instance;
}

template <class T>
std::shared_ptr<T> NapiHandler::UnbindSafeObject()
{
    NapiSafeWrapper<T> *t = nullptr;
    NAPI_CALL_HANDLE(env_, napi_unwrap(env_, thisArg_, reinterpret_cast<void **>(&t)), nullptr);
    if (t == nullptr) {
        return nullptr;
    }
    return t->GetSafeObject();
}

template <class T>
void NapiHandler::ReleaseSafeObject()
{
    NapiSafeWrapper<T> *t = nullptr;
    NAPI_CALL_RETURN_VOID(env_, napi_unwrap(env_, thisArg_, reinterpret_cast<void **>(&t)));
    if (t == nullptr) {
        return;
    }
    t->ReleaseJsWrapper();
}

template <class T>
void NapiHandler::DeleteSafeObject(void *ptr)
{
    NapiSafeWrapper<T> *t = static_cast<NapiSafeWrapper<T> *>(ptr);
    if (t == nullptr) {
        return;
    }
    delete t;
}

template <class T>
napi_value NapiHandler::PromiseCall(
    const std::string &resName, const AsyncWorker<T> &workFunc, const AsyncFinalizer<T> &finishFunc,
    const AsyncFree<T> &freeWork)
{
    NapiAsyncData<NapiAsyncHandler, T> *asyncData = new NapiAsyncData<NapiAsyncHandler, T>(env_, resName);
    asyncData->OnWork(workFunc);
    asyncData->OnFinish(finishFunc);
    asyncData->OnFree(freeWork);
    napi_value promise = (*asyncData)->CreatePromise();
    (*asyncData)->template AsyncCall<T>(asyncData);
    return promise;
}

#endif // UTILS_NAPI_HANDLER_HPP_H
