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

#ifndef UTILS_NAPI_ASYNC_HANDLER_H
#define UTILS_NAPI_ASYNC_HANDLER_H
#include "native_common.h"
#include "ohos_log.h"
#include <functional>
#include <memory>
#include <napi/native_api.h>
#include <cinttypes>
#include <string>
#include <mutex>
#include "napi_context.h"
#include "napi_async_data.h"

class NapiAsyncHandler {
public:
    NapiAsyncHandler(napi_env env, const std::string &resName);
    explicit NapiAsyncHandler(napi_env env);
    virtual ~NapiAsyncHandler();

    void OnCleanUp();

    std::string GetName() const;
    napi_value CreatePromise();
    napi_value GetResource();
    void SetStatus(napi_status status);
    napi_status GetStatus();

    void GetDeferred(napi_env env, napi_value result = nullptr);

    template <class T>
    void AsyncCall(NapiAsyncData<NapiAsyncHandler, T> *asyncData)
    {
        napi_status status = napi_create_async_work(
            context_.GetEnv(), nullptr, GetResource(),
            [](napi_env env, void *data) {
                NapiAsyncData<NapiAsyncHandler, T> *asyncData =
                    reinterpret_cast<NapiAsyncData<NapiAsyncHandler, T> *>(data);
                asyncData->DoWork(env);
            },
            [](napi_env env, napi_status status, void *data) {
                NapiAsyncData<NapiAsyncHandler, T> *asyncData =
                    reinterpret_cast<NapiAsyncData<NapiAsyncHandler, T> *>(data);
                napi_value result = asyncData->DoFinish(env);
                (*asyncData)->GetDeferred(env, result);
                delete asyncData;
            },
            (void *)asyncData, &asyncWork_);
        if (status != napi_ok) {
            LOGE("AsyncCall: create async work failed, %d", status);
            return;
        }
        status = napi_queue_async_work(context_.GetEnv(), asyncWork_);
    }

private:
    NapiContext context_;
    napi_status status_ = napi_ok;
    napi_deferred deferred_ = nullptr;
    napi_value resource_ = nullptr;
    std::string resName_;
    napi_async_work asyncWork_ = nullptr;
};
#endif // UTILS_NAPI_ASYNC_HANDLER_H
