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
#ifndef NAPI_NATIVE_COMMON_H_
#define NAPI_NATIVE_COMMON_H_

#include "ohos_log.h"
#include <functional>
#include <napi/native_api.h>
#include <cinttypes>
#include <string>

inline void GetAndThrowLastError(napi_env env)
{
    const napi_extended_error_info *errorInfo = nullptr;
    napi_get_last_error_info(env, &errorInfo);
    bool isPending = false;
    napi_is_exception_pending((env), &isPending);
    if (!isPending && errorInfo != nullptr) {
        const char *errorMessage =
            errorInfo->error_message != nullptr ? errorInfo->error_message : "empty error message";
        napi_throw_error(env, nullptr, errorMessage);
    }
}

inline void NapiAssertBase(napi_env env, bool assertion, const std::string &message)
{
    if (!(assertion)) {
        LOGE("assertion %s failed: %s", __func__, message.c_str());
        napi_throw_error(env, nullptr, message.c_str());
    }
}

inline void NapiAssert(napi_env env, bool assertion, const std::string &message)
{
    NapiAssertBase(env, assertion, message);
}

inline napi_status NapiCallBase(napi_env env, napi_status status)
{
    if (status != napi_ok) {
        LOGE("fail to call %s, status: %d", __func__, status);
        GetAndThrowLastError(env);
    }
    return status;
}

inline napi_status NapiCall(napi_env env, napi_status status)
{
    return NapiCallBase(env, status);
}

#define DECLARE_NAPI_FUNCTION(name, func)                                         \
    {                                                                             \
        (name), nullptr, (func), nullptr, nullptr, nullptr, napi_default, nullptr \
    }

#include <functional>
#include <napi/native_api.h>

const int32_t NAPI_MAX_ARGV = 10;
const int32_t INDEX_0 = 0;
const int32_t INDEX_1 = 1;
const int32_t INDEX_2 = 2;
const int32_t INDEX_3 = 3;
const int32_t INDEX_4 = 4;
const int32_t INDEX_5 = 5;
const int32_t INDEX_6 = 6;
const int32_t INDEX_7 = 7;
const int32_t INDEX_8 = 8;
const int32_t INDEX_9 = 9;
const int32_t PARAM_COUNT_0 = 0;
const int32_t PARAM_COUNT_1 = 1;
const int32_t PARAM_COUNT_2 = 2;
const int32_t PARAM_COUNT_3 = 3;
const int32_t PARAM_COUNT_4 = 4;
const int32_t PARAM_COUNT_5 = 5;
const int32_t PARAM_COUNT_6 = 6;
const int32_t PARAM_COUNT_7 = 7;
const int32_t PARAM_COUNT_8 = 8;
const int32_t PARAM_COUNT_9 = 9;
const int32_t PARAM_COUNT_10 = 10;

using ArrayBuffer = std::vector<uint8_t>;

template <class T>
using Parser = std::function<T(const napi_env env, const napi_value &)>;
template <class T>
using Serializer = std::function<napi_value(const napi_env env, const T &)>;
#endif /* NAPI_NATIVE_COMMON_H_ */
