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
#include <stdint.h>
#include <string>
#include "napi_wrapper.h"

class NapiWrapper;

class NapiAsyncHandler {
public:
    NapiAsyncHandler(napi_env env, const std::string &resName);
    virtual ~NapiAsyncHandler();
    napi_value CreatePromise();
    napi_value GetResource();
    void SetStatus(napi_status status);
    napi_status GetStatus();

    void DoWork(napi_env env);
    void DoFinish(napi_env env);

    void Work();
    void Finish();
    void CallMethod(napi_env env = nullptr);
    void CallSafeMethod();

    void OnWork(std::function<napi_status(napi_env, void *)> workFunc);
    void OnFinish(std::function<napi_value(napi_env, void *)> finishFunc);
    void OnFree(std::function<void(void *)> freeFunc);
    void OnParams(ParamSerializer paramFunc);

    void BindMethodRef(napi_ref funcRef);
    void BindWrapper(NapiWrapper *wrapper);
    NapiWrapper* GetWrapper();

    template <class T>
    std::shared_ptr<T> Bind()
    {
        data_ = std::make_shared<T>();
        return std::static_pointer_cast<T>(data_);
    }

    template <class T>
    std::shared_ptr<T> Get()
    {
        if (data_ == nullptr) {
            return nullptr;
        }
        return std::static_pointer_cast<T>(data_);
    }

private:
    napi_env env_;
    napi_ref funcRef_;
    napi_threadsafe_function safeFunc_;
    napi_status status_;
    napi_deferred deferred_ = nullptr;
    napi_value resource_ = nullptr;
    std::string resName_;
    std::function<napi_status(napi_env, void *)> workFunc_ = nullptr;
    std::function<napi_value(napi_env, void *)> finishFunc_ = nullptr;
    std::function<void(void *)> freeFunc_ = nullptr;
    ParamSerializer paramFunc_ = nullptr;
    std::shared_ptr<void> data_;
    NapiWrapper *wrapper_ = nullptr;
};
#endif // UTILS_NAPI_ASYNC_HANDLER_H
