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

#include "napi_wrapper.h"
#include "ohos_log.h"
#include <codecvt>
#include <cstdio>
#include <locale>
#include <memory>
#include <string>
#include <uv.h>
#include "napi_async_handler.h"

NapiWrapper::NapiWrapper(napi_env env, uint32_t refCount) : env_(env), refCount_(refCount) {}

NapiWrapper::~NapiWrapper() {}

napi_env NapiWrapper::GetEnv()
{
    return env_;
}

const uint32_t NapiWrapper::UseCount()
{
    std::lock_guard<std::mutex> lock(mutex_);
    return refCount_;
}

void NapiWrapper::ReleaseOne()
{
    std::lock_guard<std::mutex> lock(mutex_);
    --refCount_;
}

napi_ref NapiWrapper::FindAsyncHandler(const std::string &method)
{
    if (funcMap_.find(method) == funcMap_.end()) {
        LOGE("not find method: %s", method.c_str());
        return nullptr;
    }
    return funcMap_[method];
}

void NapiWrapper::JsCall(
    const std::shared_ptr<NapiWrapper> &wrapper, const std::string &method, ParamSerializer paramSerializer)
{
    napi_ref funcRef = wrapper->FindAsyncHandler(method);
    if (funcRef == nullptr) {
        LOGE("not find method handler, %s", method.c_str());
        return;
    }
    NapiAsyncHandler *asyncHandler = new NapiAsyncHandler(wrapper->GetEnv(), method);
    asyncHandler->BindMethodRef(funcRef);
    asyncHandler->OnParams(paramSerializer);
    asyncHandler->BindWrapper(wrapper);
#ifdef OHOS_USE_LIBUV
    uv_loop_s *loop = nullptr;
    napi_get_uv_event_loop(wrapper->GetEnv(), &loop);
    uv_work_t *work = new uv_work_t;
    work->data = asyncHandler;
    uv_queue_work(
        loop, work, [](uv_work_t *work) {},
        [](uv_work_t *work, int status) {
            NapiAsyncHandler *tmpHandler = reinterpret_cast<NapiAsyncHandler *>(work->data);
            tmpHandler->CallMethod();
            delete tmpHandler;
            delete work;
        });
#endif
}

void NapiWrapper::BindMethod(const std::string &method, napi_ref funcRef)
{
    funcMap_[method] = funcRef;
}
