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

#include "napi_async_handler.h"
#include "ohos_log.h"
#include <codecvt>
#include <cstdio>
#include <locale>
#include <memory>
#include <string>

NapiAsyncHandler::NapiAsyncHandler(napi_env env, const std::string &resName) : env_(env), resName_(resName) {}

NapiAsyncHandler::~NapiAsyncHandler()
{
    if (freeFunc_) {
        freeFunc_(data_.get());
    }
    if (safeFunc_) {}
}

napi_value NapiAsyncHandler::CreatePromise()
{
    napi_value promise;
    NAPI_CALL(env_, napi_create_promise(env_, &deferred_, &promise));
    return promise;
}

napi_value NapiAsyncHandler::GetResource()
{
    if (resource_ == nullptr) {
        napi_create_string_utf8(env_, resName_.c_str(), resName_.length(), &resource_);
    }
    return resource_;
}

void NapiAsyncHandler::SetStatus(napi_status status)
{
    status_ = status;
}

napi_status NapiAsyncHandler::GetStatus()
{
    return status_;
}

void NapiAsyncHandler::DoWork(napi_env env)
{
    if (workFunc_) {
        status_ = workFunc_(env, data_.get());
        LOGD("async work running, %d", status_);
    }
}

void NapiAsyncHandler::DoFinish(napi_env env)
{
    napi_value result = nullptr;
    if (finishFunc_ && status_ == napi_ok) {
        LOGD("async work finish, %d", status_);
        result = finishFunc_(env, data_.get());
    }
    if ((deferred_ != nullptr)) {
        if ((status_ == napi_ok) && (result != nullptr)) {
            napi_resolve_deferred(env, deferred_, result);
        } else {
            napi_get_null(env, &result);
            napi_reject_deferred(env, deferred_, result);
        }
    }
}

void NapiAsyncHandler::OnWork(std::function<napi_status(napi_env, void *)> workFunc)
{
    workFunc_ = workFunc;
}

void NapiAsyncHandler::OnFinish(std::function<napi_value(napi_env, void *)> finishFunc)
{
    finishFunc_ = finishFunc;
}

void NapiAsyncHandler::OnFree(std::function<void(void *)> freeFunc)
{
    freeFunc_ = freeFunc;
}

void NapiAsyncHandler::Work()
{
    if (workFunc_) {
        status_ = workFunc_(env_, data_.get());
        LOGD("async work running, %d", status_);
    }
}

void NapiAsyncHandler::Finish()
{
    if (finishFunc_) {
        LOGD("async work finish, %d", status_);
        finishFunc_(env_, data_.get());
    }
}

void NapiAsyncHandler::CallMethod(napi_env env)
{
    if (funcRef_ == nullptr) {
        LOGE("not bind method ref");
        return;
    }
    if (env == nullptr) {
        env = env_;
    }
    LOGD("call method");
    napi_value exception;
    status_ = napi_get_and_clear_last_exception(env, &exception);
    std::vector<napi_value> params;
    if (paramFunc_ != nullptr) {
        LOGD("get params, %p", env);
        paramFunc_(env, params);
    }

    napi_value jsFunc, result;
    LOGD("get ref, %p, param, %d", funcRef_, params.size());
    status_ = napi_get_reference_value(env, funcRef_, &jsFunc);
    if (status_ != napi_ok) {
        LOGE("get ref, status = %d", status_);
        return;
    }
    napi_valuetype vt;
    napi_typeof(env, jsFunc, &vt);
    LOGD("call function, %p, %d", jsFunc, vt);
    if (vt != napi_function) {
        LOGE("not function type");
        return;
    }
    napi_value global;
    napi_get_global(env, &global);
    status_ = napi_call_function(env, global, jsFunc, params.size(), params.data(), &result);
    if (status_ != napi_ok) {
        LOGE("call method, status = %d", status_);
    }
}

void NapiAsyncHandler::CallSafeMethod()
{
    if (safeFunc_ == nullptr) {
        LOGE("not bind safe func");
        return;
    }
    napi_acquire_threadsafe_function(safeFunc_);
    napi_call_threadsafe_function(safeFunc_, nullptr, napi_tsfn_blocking);
}

void NapiAsyncHandler::OnParams(ParamSerializer paramFunc)
{
    paramFunc_ = paramFunc;
}

void NapiAsyncHandler::BindMethodRef(napi_ref funcRef)
{
    funcRef_ = funcRef;
#if 0
    napi_value jsFunc;
    NAPI_CALL_RETURN_VOID(env_, napi_get_reference_value(env_, funcRef, &jsFunc));

    status_ = napi_create_threadsafe_function(
        env_, jsFunc, nullptr, GetResource(), 0, 1, this,
        [](napi_env env, void *finalize_data, void *finalize_hint) {
            LOGD("Threadsafe function finalized");
        },
        this,
        [](napi_env env, napi_value jsFunc, void *context, void *data) {
            LOGD("enter safe function");
            napi_value result;
            NapiAsyncHandler *h = reinterpret_cast<NapiAsyncHandler *>(context);
            h->CallMethod(env);
        },
        &safeFunc_);
#endif
}

void NapiAsyncHandler::BindWrapper(NapiWrapper *wrapper)
{
    wrapper_ = wrapper;
}

NapiWrapper* NapiAsyncHandler::GetWrapper()
{
    return wrapper_;
}
