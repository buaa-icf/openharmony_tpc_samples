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
#include "napi_scope.h"
#include "napi_safe_wrapper.h"

NapiAsyncHandler::NapiAsyncHandler(napi_env env, const std::string &resName) : context_(env), resName_(resName)
{
    context_.OnCleanUp([this]() {
        OnCleanUp();
    });
}

NapiAsyncHandler::NapiAsyncHandler(napi_env env) : context_(env)
{
    context_.OnCleanUp([this]() {
        OnCleanUp();
    });
}

void NapiAsyncHandler::OnCleanUp()
{
    if (asyncWork_) {
        napi_delete_async_work(context_.GetEnv(), asyncWork_);
    }
}

NapiAsyncHandler::~NapiAsyncHandler() {}

napi_value NapiAsyncHandler::CreatePromise()
{
    napi_value promise;
    NapiCall(context_.GetEnv(), napi_create_promise(context_.GetEnv(), &deferred_, &promise));
    return promise;
}

napi_value NapiAsyncHandler::GetResource()
{
    if (resource_ == nullptr) {
        napi_create_string_utf8(context_.GetEnv(), resName_.c_str(), resName_.length(), &resource_);
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

void NapiAsyncHandler::GetDeferred(napi_env env, napi_value result)
{
    if ((deferred_ != nullptr)) {
        if (result == nullptr) {
            napi_get_null(env, &result);
            napi_reject_deferred(env, deferred_, result);
        } else {
            napi_resolve_deferred(env, deferred_, result);
        }
    }
}

std::string NapiAsyncHandler::GetName() const
{
    return resName_;
}
