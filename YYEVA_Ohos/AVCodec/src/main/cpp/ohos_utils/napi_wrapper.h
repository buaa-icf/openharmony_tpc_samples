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

#ifndef UTILS_NAPI_WRAPPER_H
#define UTILS_NAPI_WRAPPER_H
#include "native_common.h"
#include "ohos_log.h"
#include <functional>
#include <memory>
#include <napi/native_api.h>
#include <stdint.h>
#include <string>
#include <atomic>
#include <mutex>
#include <limits>
#include <unordered_map>

constexpr uint32_t NW_NEVER = std::numeric_limits<uint32_t>::max();
using ParamSerializer = std::function<void(napi_env, std::vector<napi_value> &)>;

class NapiWrapper {
public:
    NapiWrapper(napi_env env, uint32_t ref_count = 1);
    ~NapiWrapper();

    napi_env GetEnv();

    const uint32_t UseCount();
    void ReleaseOne();
    void BindMethod(const std::string &method, napi_ref funcRef);
    void CallJsMethod(const std::string &method, ParamSerializer paramSerializer);

    napi_ref FindAsyncHandler(const std::string &method);

    static void JsCall(const std::shared_ptr<NapiWrapper> &wrapper, const std::string &method, ParamSerializer paramSerializer);

private:
    napi_env env_ = nullptr;
    std::mutex mutex_;
    uint32_t ref_count_;
    std::unordered_map<std::string, napi_ref> funcMap_;
};
#endif // UTILS_NAPI_WRAPPER_H

#define NAPI_HANDLER_CHECK_GET(napiHandler, userData)
//  \
//     NapiWrapper *napiHandler = static_cast<NapiWrapper *>(userData); \
//     if (napiHandler == nullptr) {                                    \
//         LOGE("handler is nullptr in %s", __func__);                  \
//         return;                                                      \
//     }

#define NAPI_METHOD_CALL(userData, method, lambda)             \
    do {                                                       \
        NapiWrapper *h = static_cast<NapiWrapper *>(userData); \
        if (h == nullptr) {                                    \
            LOGE("method call handler is nullptr,%s", method); \
            return;                                            \
        }                                                      \
        NapiWrapper::JsCall(h, method, lambda);                \
    } while (0)
