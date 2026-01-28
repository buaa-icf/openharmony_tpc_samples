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

#include "napi_threadsafe_handler.h"
#include "ohos_log.h"
#include <codecvt>
#include <cstdio>
#include <locale>
#include <memory>
#include <string>
#include "napi_scope.h"
#include "napi_safe_wrapper.h"

NapiThreadsafeHandler::NapiThreadsafeHandler(napi_env env, const std::string &resName)
    : context_(env), resName_(resName)
{
    context_.OnCleanUp([this]() {
        LOGD("ThreadSafe context clean up");
        OnCleanUp();
    });
}

NapiThreadsafeHandler::NapiThreadsafeHandler(napi_env env) : context_(env)
{
    context_.OnCleanUp([this]() {
        LOGD("ThreadSafe context clean up");
        OnCleanUp();
    });
}

NapiThreadsafeHandler::~NapiThreadsafeHandler() {}

void NapiThreadsafeHandler::OnCleanUp()
{
    ReleaseSafeMethod(true);
    if (funcRef_) {
        uint32_t count = 0;
        napi_reference_unref(context_.GetEnv(), funcRef_, &count);
        if (count == 0) {
            napi_delete_reference(context_.GetEnv(), funcRef_);
            funcRef_ = nullptr;
        }
    }
    resource_ = nullptr;
}

napi_value NapiThreadsafeHandler::GetResource()
{
    if (resource_ == nullptr) {
        napi_create_string_utf8(context_.GetEnv(), resName_.c_str(), resName_.length(), &resource_);
    }
    return resource_;
}

void NapiThreadsafeHandler::CallMethod(napi_env env, napi_value func)
{
    if (funcRef_ == nullptr && func == nullptr) {
        LOGE("CallMethod, not bind method ref");
        return;
    }
    if (env == nullptr) {
        env = context_.GetEnv();
    }

    NapiScope scope(env);

    napi_value exception;
    napi_status status = napi_get_and_clear_last_exception(env, &exception);
    std::vector<napi_value> params;
    if (paramFunc_ != nullptr) {
        paramFunc_(env, params);
    }

    napi_value jsFunc;
    if (func == nullptr) {
        status = napi_get_reference_value(env, funcRef_, &jsFunc);
        if (status != napi_ok) {
            LOGE("CallMethod get ref, status = %d", status);
            return;
        }
    } else {
        jsFunc = func;
    }
    napi_valuetype vt;
    napi_typeof(env, jsFunc, &vt);
    if (vt != napi_function) {
        LOGE("CallMethod, not function type");
        return;
    }
    napi_value result;
    napi_value global;
    napi_get_global(env, &global);
    status = napi_call_function(env, global, jsFunc, params.size(), params.data(), &result);
    if (status != napi_ok) {
        LOGE("CallMethod, status = %d", status);
    }
}

void NapiThreadsafeHandler::CallSafeMethod()
{
    std::unique_lock<std::mutex> lock(sfMutex_);
    if (safeFunc_ == nullptr) {
        LOGE("ThreadSafe call failed, not create");
        return;
    }
    napi_acquire_threadsafe_function(safeFunc_);
    napi_call_threadsafe_function(safeFunc_, nullptr, napi_tsfn_blocking);
}

void NapiThreadsafeHandler::ReleaseSafeMethod(bool final)
{
    std::unique_lock<std::mutex> lock(sfMutex_);
    if (safeFunc_ == nullptr) {
        LOGE("ThreadSafe release invalid, not create");
        return;
    }

    if (final) {
        napi_release_threadsafe_function(safeFunc_, napi_tsfn_abort);
        safeFunc_ = nullptr;
    } else {
        napi_release_threadsafe_function(safeFunc_, napi_tsfn_release);
    }
}

void NapiThreadsafeHandler::OnParams(ParameterSerializer paramFunc)
{
    paramFunc_ = paramFunc;
}

void NapiThreadsafeHandler::BindMethodRef(napi_value func)
{
    napi_create_reference(context_.GetEnv(), func, 1, &funcRef_);
}

void NapiThreadsafeHandler::CreateSafeThread(const std::string &resName)
{
    resName_ = resName;
    napi_value jsFunc;
    napi_status status = napi_get_reference_value(context_.GetEnv(), funcRef_, &jsFunc);
    if (status != napi_ok) {
        LOGE("get ref, status = %d", status);
        return;
    }

    status = napi_create_threadsafe_function(
        context_.GetEnv(), jsFunc, NULL, GetResource(), 1, 1, this,
        [](napi_env env, void *finalize_data, void *finalize_hint) {
            LOGD("ThreadSafe delete");
        },
        this,
        [](napi_env env, napi_value jsCb, void *context, void *data) {
            NapiThreadsafeHandler *wrapper = static_cast<NapiThreadsafeHandler *>(context);
            wrapper->CallMethod(env, jsCb);
            wrapper->ReleaseSafeMethod(false);
        },
        &safeFunc_);
    if (status != napi_ok) {
        LOGE("ThreadSafe create failed, status = %d", status);
        return;
    }
    LOGE("ThreadSafe create %s success", resName_.c_str());
}

std::string NapiThreadsafeHandler::GetName() const
{
    return resName_;
}
