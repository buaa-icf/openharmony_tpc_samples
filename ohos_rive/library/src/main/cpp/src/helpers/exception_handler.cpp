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

#include "../../include/helpers/exception_handler.h"
#include <sstream>

namespace ohos_rive {
std::string NapiExceptionHandler::GetExceptionMessage(napi_env env, napi_value exception)
{
    std::ostringstream errorMsg;
    AppendValueMessage(env, exception, errorMsg);

    napi_value cause;
    napi_status status = napi_get_named_property(env, exception, "cause", &cause);
    if (status == napi_ok && IsValueValid(env, cause)) {
        errorMsg << "\nCaused by: ";
        AppendValueMessage(env, cause, errorMsg);
    }

    return errorMsg.str();
}

void NapiExceptionHandler::AppendValueMessage(napi_env env, napi_value value, std::ostringstream &errorMsg)
{
    napi_value toString;
    napi_status status = napi_get_named_property(env, value, "toString", &toString);
    if (status != napi_ok) {
        errorMsg << "\n[Unable to get toString method]";
        return;
    }

    napi_value result;
    status = napi_call_function(env, value, toString, 0, nullptr, &result);
    if (status != napi_ok) {
        errorMsg << "\n[Unable to call toString method]";
        return;
    }

    char buffer[4096] = {0};
    size_t length = 0;
    status = napi_get_value_string_utf8(env, result, buffer, sizeof(buffer) - 1, &length);
    if (status == napi_ok) {
        errorMsg << "\n" << buffer;
    }

    AppendStackTrace(env, value, errorMsg);
}

void NapiExceptionHandler::AppendStackTrace(napi_env env, napi_value value, std::ostringstream &errorMsg)
{
    napi_value stack;
    napi_status status = napi_get_named_property(env, value, "stack", &stack);
    if (status != napi_ok) {
        return;
    }

    char stackBuffer[8192] = {0};
    size_t stackLength = 0;
    status = napi_get_value_string_utf8(env, stack, stackBuffer, sizeof(stackBuffer) - 1, &stackLength);
    if (status == napi_ok && stackLength > 0) {
        errorMsg << "\nStack trace:\n" << stackBuffer;
    }
}

bool NapiExceptionHandler::IsValueValid(napi_env env, napi_value value)
{
    napi_valuetype type;
    napi_status status = napi_typeof(env, value, &type);
    if (status != napi_ok) {
        return false;
    }
    return type != napi_undefined && type != napi_null;
}

void NapiExceptionHandler::CheckAndRethrow(napi_env env)
{
    napi_value exception;
    napi_status status = napi_get_and_clear_last_exception(env, &exception);
    if (status != napi_ok || !IsValueValid(env, exception)) {
        return;
    }

    std::string errorMsg = GetExceptionMessage(env, exception);
    LOGE("NAPI Exception: %s", errorMsg.c_str());

    napi_value newError;
    napi_value errorMsgValue;
    napi_create_string_utf8(env, errorMsg.c_str(), NAPI_AUTO_LENGTH, &errorMsgValue);
    napi_create_error(env, nullptr, errorMsgValue, &newError);
    napi_throw(env, newError);
}

napi_value NapiExceptionHandler::CallNapiMethod(napi_env env,
                                                napi_value object,
                                                const char *methodName,
                                                size_t argc,
                                                napi_value *argv)
{
    napi_value method;
    napi_status status = napi_get_named_property(env, object, methodName, &method);
    if (status != napi_ok) {
        LOGE("Failed to get method: %{public}s", methodName);
        return nullptr;
    }

    napi_value result;
    status = napi_call_function(env, object, method, argc, argv, &result);
    if (status != napi_ok) {
        CheckAndRethrow(env);
        return nullptr;
    }

    return result;
}

napi_value NapiExceptionHandler::CallObjectMethod(napi_env env,
                                                  napi_value obj,
                                                  const char *methodName,
                                                  size_t argc,
                                                  napi_value *argv)
{
    return CallNapiMethod(env, obj, methodName, argc, argv);
}

void NapiExceptionHandler::CallVoidMethod(napi_env env,
                                          napi_value obj,
                                          const char *methodName,
                                          size_t argc,
                                          napi_value *argv)
{
    napi_value result = CallNapiMethod(env, obj, methodName, argc, argv);
}

int32_t NapiExceptionHandler::CallIntMethod(napi_env env,
                                            napi_value obj,
                                            const char *methodName,
                                            size_t argc,
                                            napi_value *argv)
{
    napi_value result = CallNapiMethod(env, obj, methodName, argc, argv);
    if (result == nullptr) {
        return 0;
    }

    int32_t intValue = 0;
    napi_status status = napi_get_value_int32(env, result, &intValue);
    if (status != napi_ok) {
        CheckAndRethrow(env);
        return 0;
    }
    return intValue;
}

bool NapiExceptionHandler::CallBooleanMethod(napi_env env,
                                             napi_value obj,
                                             const char *methodName,
                                             size_t argc,
                                             napi_value *argv)
{
    napi_value result = CallNapiMethod(env, obj, methodName, argc, argv);
    if (result == nullptr) {
        return false;
    }

    bool boolValue = false;
    napi_status status = napi_get_value_bool(env, result, &boolValue);
    if (status != napi_ok) {
        CheckAndRethrow(env);
        return false;
    }
    return boolValue;
}

double NapiExceptionHandler::CallDoubleMethod(napi_env env,
                                              napi_value obj,
                                              const char *methodName,
                                              size_t argc,
                                              napi_value *argv)
{
    napi_value result = CallNapiMethod(env, obj, methodName, argc, argv);
    if (result == nullptr) {
        return 0.0;
    }

    double doubleValue = 0.0;
    napi_status status = napi_get_value_double(env, result, &doubleValue);
    if (status != napi_ok) {
        CheckAndRethrow(env);
        return 0.0;
    }
    return doubleValue;
}

napi_value NapiExceptionHandler::CallStaticObjectMethod(napi_env env,
                                                        napi_value constructor,
                                                        const char *methodName,
                                                        size_t argc,
                                                        napi_value *argv)
{
    return CallNapiMethod(env, constructor, methodName, argc, argv);
}

napi_value NapiExceptionHandler::GetProperty(napi_env env, napi_value object, const char *propertyName)
{
    napi_value property;
    napi_status status = napi_get_named_property(env, object, propertyName, &property);
    if (status != napi_ok) {
        CheckAndRethrow(env);
        return nullptr;
    }
    return property;
}

bool NapiExceptionHandler::SetProperty(napi_env env, napi_value object, const char *propertyName, napi_value value)
{
    napi_status status = napi_set_named_property(env, object, propertyName, value);
    if (status != napi_ok) {
        CheckAndRethrow(env);
        return false;
    }
    return true;
}

napi_value NapiExceptionHandler::CreateString(napi_env env, const char *str)
{
    napi_value result;
    napi_status status = napi_create_string_utf8(env, str, NAPI_AUTO_LENGTH, &result);
    if (status != napi_ok) {
        CheckAndRethrow(env);
        return nullptr;
    }
    return result;
}

std::string NapiExceptionHandler::GetStringValue(napi_env env, napi_value value)
{
    if (!IsValueValid(env, value)) {
        return "";
    }

    char buffer[4096] = {0};
    size_t length = 0;
    napi_status status = napi_get_value_string_utf8(env, value, buffer, sizeof(buffer) - 1, &length);
    if (status != napi_ok) {
        CheckAndRethrow(env);
        return "";
    }
    return std::string(buffer, length);
}
} // namespace ohos_rive
