//
// Created on 2025/2/21.
//
// Node APIs are not fully supported. To solve the compilation error of the interface cannot be found,
// please include "napi/native_api.h".
#include <string>
#include "napi/native_api.h"

#ifndef OHOS_PJSIP_PROJECT_NAPI_HELPER_H
#define OHOS_PJSIP_PROJECT_NAPI_HELPER_H

class NapiHelper {
public:
    NapiHelper(napi_env env);
    static std::string GetString(napi_env env, napi_value value);
    static napi_value Call(napi_env env, napi_value thisObject, napi_value callback, int argsCount,
                           const napi_value *args);
    static void MaybeRethrowAsCpp(napi_env env_, napi_status status);
    static napi_value GetObjectProperty(napi_env env_, napi_value object, std::string const &key);

private:
    static void MaybeThrowFromStatus(napi_env env, napi_status status, const char *message);

private:
    napi_env env_;
};

#endif // OHOS_PJSIP_PROJECT_NAPI_HELPER_H
