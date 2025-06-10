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

#ifndef HTTP2_NAPI_UTILS_H
#define HTTP2_NAPI_UTILS_H
#include <string>
#include <napi/native_api.h>

class NapiUtil {
public:
    static void JsValueToString(const napi_env &env, const napi_value &value, const int32_t bufLen,
        std::string &target);
    static napi_value SetNapiCallInt32(const napi_env &env,  const int32_t &intValue);
    static napi_value SetNapiCallString(const napi_env &env,  const std::string &strValue);
    static int StringToInt(std::string value);
    static bool StringToBool(std::string value);
};


#endif //HTTP2_NAPI_UTILS_H
