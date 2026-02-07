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
#include "napi_context.h"

NapiContext::NapiContext(napi_env env, TaskContextFlag flag) : flag_(flag), env_(env)
{
    std::lock_guard<std::recursive_mutex> lock(mtx_);
    switch (flag_) {
        case TASK_FLAG_NEW_CONTEXT:

            break;
        case TASK_FLAG_NEW_RUNTIME:
            napi_create_ark_runtime(&env_new_);
            break;
        case TASK_FLAG_NONE:
        default:
            env_new_ = env_;
            break;
    }
    napi_add_env_cleanup_hook(env_new_, CleanUp, this);
}

NapiContext::~NapiContext()
{
    std::lock_guard<std::recursive_mutex> lock(mtx_);
    napi_remove_env_cleanup_hook(env_new_, CleanUp, this);
    Release();
}

bool NapiContext::Valid()
{
    std::lock_guard<std::recursive_mutex> lock(mtx_);
    return env_new_ != nullptr;
}

void NapiContext::CleanUp(void *context)
{
    NapiContext *nc = static_cast<NapiContext *>(context);
    LOGD("CleanUp");
    nc->Release();
}

void NapiContext::OnCleanUp(const std::function<void()> &cleanFunc)
{
    cleanFunc_ = cleanFunc;
}

void NapiContext::Release()
{
    std::lock_guard<std::recursive_mutex> lock(mtx_);
    if (env_new_ == nullptr) {
        return;
    }
    if (cleanFunc_) {
        cleanFunc_();
    }
    switch (flag_) {
        case TASK_FLAG_NEW_CONTEXT:
            break;
        case TASK_FLAG_NEW_RUNTIME:
            napi_destroy_ark_runtime(&env_new_);
            break;
        case TASK_FLAG_NONE:
        default:
            break;
    }
    env_new_ = nullptr;
}

napi_env NapiContext::GetEnv()
{
    std::lock_guard<std::recursive_mutex> lock(mtx_);
    return env_new_;
}
