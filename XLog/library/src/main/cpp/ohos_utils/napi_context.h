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

#ifndef UTILS_NAPI_CONTEXT_H
#define UTILS_NAPI_CONTEXT_H
#include "ohos_log.h"
#include <napi/native_api.h>
#include <cinttypes>
#include <mutex>
#include <functional>

typedef enum { TASK_FLAG_NONE = 0, TASK_FLAG_NEW_CONTEXT, TASK_FLAG_NEW_RUNTIME } TaskContextFlag;
using ParameterSerializer = std::function<void(napi_env, std::vector<napi_value> &)>;

class NapiContext {
public:
    explicit NapiContext(napi_env env, TaskContextFlag flag = TASK_FLAG_NONE);
    virtual ~NapiContext();
    napi_env GetEnv();
    bool Valid();

    static void CleanUp(void *context);
    void OnCleanUp(const std::function<void()> &cleanFunc);

private:
    void Release();

private:
    napi_env env_;
    TaskContextFlag flag_;
    napi_env env_new_ = nullptr;
    std::recursive_mutex mtx_;

    std::function<void()> cleanFunc_ = nullptr;
};
#endif