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

#ifndef OHOS_RIVE_EXCEPTION_HANDLER_H
#define OHOS_RIVE_EXCEPTION_HANDLER_H

#include "general.h"
#include "napi/native_api.h"
#include <arkui/native_node_napi.h>
#include <sstream>
#include <string>

namespace ohos_rive {
/**
 * A utility class to facilitate JNI calls and manage exceptions.
 *
 * This class provides helper methods for invoking JVM calls from native code.
 * After executing a JNI call, it checks if an exception has occurred, and if
 * so, rethrows it with additional context information, including the full stack
 * trace from the JVM. This enhances the clarity of error reporting, making it
 * easier to debug issues originating from Java code.
 */
class NapiExceptionHandler {
private:
    static napi_value CallNapiMethod(napi_env env,
                                     napi_value object,
                                     const char *methodName,
                                     size_t argc = 0,
                                     napi_value *argv = nullptr);
    static void AppendValueMessage(napi_env env, napi_value value, std::ostringstream &errorMsg);
    static void AppendStackTrace(napi_env env, napi_value value, std::ostringstream &errorMsg);

public:
    static std::string GetExceptionMessage(napi_env env, napi_value exception);

    static void CheckAndRethrow(napi_env env);

    static napi_value CallObjectMethod(napi_env env,
                                       napi_value obj,
                                       const char *methodName,
                                       size_t argc = 0,
                                       napi_value *argv = nullptr);

    static void CallVoidMethod(napi_env env,
                               napi_value obj,
                               const char *methodName,
                               size_t argc = 0,
                               napi_value *argv = nullptr);

    static int32_t CallIntMethod(napi_env env,
                                 napi_value obj,
                                 const char *methodName,
                                 size_t argc = 0,
                                 napi_value *argv = nullptr);

    static bool CallBooleanMethod(napi_env env,
                                  napi_value obj,
                                  const char *methodName,
                                  size_t argc = 0,
                                  napi_value *argv = nullptr);

    static double CallDoubleMethod(napi_env env,
                                   napi_value obj,
                                   const char *methodName,
                                   size_t argc = 0,
                                   napi_value *argv = nullptr);

    static napi_value CallStaticObjectMethod(napi_env env,
                                             napi_value constructor,
                                             const char *methodName,
                                             size_t argc = 0,
                                             napi_value *argv = nullptr);

    static napi_value GetProperty(napi_env env, napi_value object, const char *propertyName);

    static bool SetProperty(napi_env env, napi_value object, const char *propertyName, napi_value value);

    static napi_value CreateString(napi_env env, const char *str);

    static std::string GetStringValue(napi_env env, napi_value value);

    static bool IsValueValid(napi_env env, napi_value value);
};
} // namespace ohos_rive

#endif // OHOS_RIVE_EXCEPTION_HANDLER_H

