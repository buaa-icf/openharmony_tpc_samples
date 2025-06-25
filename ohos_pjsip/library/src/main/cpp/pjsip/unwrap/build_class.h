//
// Created on 2025/2/21.
//
// Node APIs are not fully supported. To solve the compilation error of the interface cannot be found,
// please include "napi/native_api.h".

#include "napi/native_api.h"
#include <arkui/native_node_napi.h>

#ifndef OHOS_PJSIP_PROJECT_BUILDCLASS_H
#define OHOS_PJSIP_PROJECT_BUILDCLASS_H

class BuildClass {
public:
//     static BuildClass *GetInstance();
    static napi_value Export(napi_env env, napi_value exports);
    static napi_value JsConstructor(napi_env env, napi_callback_info info);
    static napi_value InitPjsip(napi_env env, napi_callback_info info);
    static napi_value MakeCall(napi_env env, napi_callback_info info);
    static napi_value ModifyAccount(napi_env env, napi_callback_info info);
    static napi_value AcceptCall(napi_env env, napi_callback_info info);
    static napi_value HandUpCall(napi_env env, napi_callback_info info);
    static napi_value AddInCallingListener(napi_env env, napi_callback_info info);
    static napi_value AddInCallStateListener(napi_env env, napi_callback_info info);
    static napi_value SetSurfaceID(napi_env env, napi_callback_info info);
    static napi_value Destroy(napi_env env, napi_callback_info info);
};

#endif // OHOS_PJSIP_PROJECT_BUILDCLASS_H
