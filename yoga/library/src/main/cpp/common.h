/**
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

#ifndef OHOS_YOGA_NAPI_COMMON_H
#define OHOS_YOGA_NAPI_COMMON_H

#include <napi/native_api.h>
#include <hilog/log.h>
#include <yoga/Yoga.h>

namespace YOGA_NAPI {

/**
 * Log print domain.
 */
const unsigned int LOG_PRINT_DOMAIN = 0xFF00;
#define YOGA_LOG_TAG "YogaTag"

// Argument index
constexpr int32_t ARG_INDEX_ZERO = 0;
constexpr int32_t ARG_INDEX_ONE = 1;
constexpr int32_t ARG_INDEX_TWO = 2;
constexpr int32_t ARG_INDEX_THREE = 3;
constexpr int32_t ARG_INDEX_FOUR = 4;
// Argument count
constexpr int32_t ARG_COUNT_ONE = 1;
constexpr int32_t ARG_COUNT_TWO = 2;
constexpr int32_t ARG_COUNT_THREE = 3;
constexpr int32_t ARG_COUNT_FOUR = 4;
constexpr int32_t ARG_COUNT_FIVE = 5;
// Mask
constexpr uint64_t MASK_32_BITS = 0xFFFFFFFF;
constexpr int SHIFT_32_BITS = 32;

// W-writable E-enumerable C-configurable napi_default is not WEC
#define DECLARE_NAPI_FUNCTION(name, func)                                         \
    {                                                                             \
        (name), nullptr, (func), nullptr, nullptr, nullptr, napi_default, nullptr \
    }

// Get params
#define GET_PARAMS(env, info, num)    \
    size_t argc = num;                \
    napi_value args[num] = {nullptr}; \
    napi_value thisVar = nullptr;     \
    napi_get_cb_info(env, info, &argc, args, &thisVar, nullptr)

// Get params with check
#define GET_PARAMS_WITH_CHECK(env, info, expected)                   \
    GET_PARAMS(env, info, expected);                                 \
    if (argc != expected) {                                          \
        napi_throw_error(env, nullptr, "Wrong number of arguments"); \
        return nullptr;                                              \
    }

// Extract reference pointer
template <typename T>
inline T *ExtractRefPtr(napi_env env, napi_value obj, const char *refName)
{
    napi_value refValue;
    napi_get_named_property(env, obj, refName, &refValue);

    void *data;
    napi_get_value_external(env, refValue, &data);

    return static_cast<T *>(data);
}

// Utility to create a YogaValue object for JS
napi_value CreateYogaValue(napi_env env, YGValue value);

}  // namespace YOGA_NAPI

#endif  // OHOS_YOGA_NAPI_COMMON_H
