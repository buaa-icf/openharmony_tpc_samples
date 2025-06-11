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

#include "napi_utils.h"
#include <codecvt>
#include <cstdio>
#include <locale>
#include <string>
#include "../log/ohos_log.h"

const int32_t MAX_STR_LENGTH = 2048;
void NapiUtil::JsValueToString(const napi_env & env, const napi_value & value,
                               const int32_t bufLen, std::string & target)
{
    if (bufLen <= 0 || bufLen > MAX_STR_LENGTH) {
        LOGI("%s string too long malloc failed", __func__);
        return;
    }

    std::unique_ptr < char[] > buf = std::make_unique < char[] >(bufLen);
    if (buf.get() == nullptr) {
        LOGI("%s nullptr js object to string malloc failed", __func__);
        return;
    }
    (void)memset(buf.get(), 0, bufLen);
    size_t result = 0;
    napi_get_value_string_utf8(env, value, buf.get(), bufLen, &result);
    target = buf.get();
}

napi_value NapiUtil::SetNapiCallInt32(const napi_env &env,  const int32_t &intValue)
{
    napi_value result;
    napi_create_int32(env, intValue, &result);
    return result;
}

napi_value NapiUtil::SetNapiCallString(const napi_env &env,  const std::string &strValue)
{
    napi_value result;
    napi_create_string_utf8(env, strValue.c_str(), NAPI_AUTO_LENGTH, &result);
    return result;
}

int NapiUtil::StringToInt(std::string value)
{
    return atoi(static_cast<const char*>(value.c_str()));
}

bool NapiUtil::StringToBool(const std::string value)
{
    return value == "true" ? true : false;
}

