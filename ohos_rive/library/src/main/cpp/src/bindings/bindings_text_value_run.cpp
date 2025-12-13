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

#include "bindings/bindings_text_value_run.h"
#include "helpers/general.h"
#include <js_native_api.h>
namespace ohos_rive {

using namespace rive;
constexpr size_t ARG_NUM_TWO = 2;

static rive::TextValueRun *GetNativePtr(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value argv[1];
    napi_value thisArg;
    void *data;

    napi_status status = napi_get_cb_info(env, info, &argc, argv, &thisArg, &data);
    if (status != napi_ok) {
        LOGE("Failed to parse arguments");
        return nullptr;
    }

    if (argc < 1) {
        LOGE("Wrong number of arguments");
        return nullptr;
    }

    uint64_t nativePtr;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, argv[0], &nativePtr, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get TextValueRun pointer from int64");
        return nullptr;
    }
    if (nativePtr == 0) {
        LOGE("Invalid TextValueRun pointer (0)");
        return nullptr;
    }

    return reinterpret_cast<rive::TextValueRun *>(nativePtr);
}

napi_value TextValueRunGetText(napi_env env, napi_callback_info info)
{
    auto *run = GetNativePtr(env, info);
    if (run == nullptr) {
        LOGE("Invalid native pointer");
        return nullptr;
    }

    const std::string &text = run->text();
    napi_value result;
    napi_status status = napi_create_string_utf8(env, text.c_str(), text.length(), &result);
    if (status != napi_ok) {
        LOGE("Failed to create string result");
        return nullptr;
    }

    return result;
}

napi_value TextValueRunSetText(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO; // 2: number of arguments
    napi_value argv[ARG_NUM_TWO];
    napi_value thisArg;
    void *data;

    napi_status status = napi_get_cb_info(env, info, &argc, argv, &thisArg, &data);
    if (status != napi_ok) {
        LOGE("Failed to parse arguments");
        return nullptr;
    }

    if (argc < ARG_NUM_TWO) {
        LOGE("Wrong number of arguments");
        return nullptr;
    }

    auto *run = reinterpret_cast<rive::TextValueRun *>(data);
    if (run == nullptr) {
        uint64_t nativePtr;
        bool lossless = false;
        status = napi_get_value_bigint_uint64(env, argv[0], &nativePtr, &lossless);
        if (status != napi_ok || !lossless) {
            LOGE("Failed to get native pointer");
            return nullptr;
        }
        run = reinterpret_cast<rive::TextValueRun *>(nativePtr);
    }

    if (run == nullptr) {
        LOGE("Invalid native pointer");
        return nullptr;
    }

    size_t textLength;
    status = napi_get_value_string_utf8(env, argv[1], nullptr, 0, &textLength);
    if (status != napi_ok) {
        LOGE("Failed to get text length");
        return nullptr;
    }

    char *buffer = new char[textLength + 1];
    size_t copied;
    status = napi_get_value_string_utf8(env, argv[1], buffer, textLength + 1, &copied);
    if (status != napi_ok) {
        delete[] buffer;
        LOGE("Failed to get text value");
        return nullptr;
    }

    std::string newText(buffer, copied);
    delete[] buffer;
    run->text(newText);

    napi_value result;
    napi_get_undefined(env, &result);
    return result;
}
} // namespace ohos_rive
