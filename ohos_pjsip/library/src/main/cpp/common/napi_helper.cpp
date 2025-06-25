//
// Created on 2025/2/21.
//
// Node APIs are not fully supported. To solve the compilation error of the interface cannot be found,
// please include "napi/native_api.h".

#include "napi_helper.h"

NapiHelper::NapiHelper(napi_env env) : env_(env) {}
std::string NapiHelper::GetString(napi_env env_, napi_value value) {
    size_t length;
    napi_status status;
    status = napi_get_value_string_utf8(env_, value, nullptr, 0, &length);
    NapiHelper::MaybeThrowFromStatus(env_, status, "Failed to get the length of the string");
    std::string buffer(length, '\0');
    status = napi_get_value_string_utf8(env_, value, &buffer[0], length + 1, &length);
    NapiHelper::MaybeThrowFromStatus(env_, status, "Failed to get the string data");
    return buffer;
}

void NapiHelper::MaybeThrowFromStatus(napi_env env, napi_status status, const char *message) {
    if (status != napi_ok) {
        napi_extended_error_info const *error_info;
        napi_get_last_error_info(env, &error_info);
        std::string msg_str = message;
        std::string error_code_msg_str = "Error code: ";
        std::string status_str = error_info->error_message;
        std::string full_msg = msg_str + error_code_msg_str + status_str;
        napi_throw_error(env, nullptr, message);
        throw std::runtime_error(full_msg);
    }
}

napi_value NapiHelper::Call(napi_env env, napi_value thisObject, napi_value callback, int argsCount,
                            const napi_value *args) {
    napi_value result = nullptr;
    auto status = napi_call_function(env, thisObject, callback, argsCount, args, &result);
    MaybeRethrowAsCpp(env, status);
    return result;
}

void NapiHelper::MaybeRethrowAsCpp(napi_env env_, napi_status status) {
    if (status == napi_ok) {
        return;
    }
    bool hasThrown;
    napi_is_exception_pending(env_, &hasThrown);
    if (status != napi_pending_exception && !hasThrown) {
        return;
    }
    napi_value nError;
    napi_get_and_clear_last_exception(env_, &nError);

    auto message = GetObjectProperty(env_, nError, "message");
    auto messageStr = GetString(env_, message);
    throw std::runtime_error(messageStr);
}

napi_value NapiHelper::GetObjectProperty(napi_env env_, napi_value object, std::string const &key) {
    napi_value result;
    napi_value str;
    auto status = napi_create_string_utf8(env_, key.c_str(), key.length(), &str);
    status = napi_get_property(env_, object, str, &result);
    MaybeThrowFromStatus(env_, status, "Failed to retrieve property from object");
    return result;
}