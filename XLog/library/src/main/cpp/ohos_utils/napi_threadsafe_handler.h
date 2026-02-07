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

#ifndef UTILS_NAPI_THREADSAFE_HANDLER_H
#define UTILS_NAPI_THREADSAFE_HANDLER_H
#include "native_common.h"
#include "ohos_log.h"
#include <functional>
#include <memory>
#include <napi/native_api.h>
#include <cinttypes>
#include <string>
#include <mutex>
#include "napi_context.h"

class NapiThreadsafeHandler {
public:
    NapiThreadsafeHandler(napi_env env, const std::string &resName);
    explicit NapiThreadsafeHandler(napi_env env);
    virtual ~NapiThreadsafeHandler();
    void OnCleanUp();

    std::string GetName() const;
    napi_value GetResource();

    void CallMethod(napi_env env = nullptr, napi_value func = nullptr);
    void CallSafeMethod();
    void CreateSafeThread(const std::string &resName);
    void ReleaseSafeMethod(bool final);

    void OnParams(ParameterSerializer paramFunc);
    void BindMethodRef(napi_value func);

private:
    NapiContext context_;
    napi_ref funcRef_ = nullptr;
    // safe thread
    std::mutex sfMutex_;
    napi_threadsafe_function safeFunc_ = nullptr;
    ParameterSerializer paramFunc_ = nullptr;

    napi_value resource_ = nullptr;
    std::string resName_;
};
#endif // UTILS_NAPI_THREADSAFE_HANDLER_H
