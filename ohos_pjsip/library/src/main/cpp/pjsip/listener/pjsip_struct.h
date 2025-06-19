//
// Created on 2025/2/24.
//
// Node APIs are not fully supported. To solve the compilation error of the interface cannot be found,
// please include "napi/native_api.h".

#include "napi/native_api.h"
#include "pjsip_call.h"
#include <cstdint>


#ifndef OHOS_PJSIP_PROJECT_PJSIP_STRUCT_H
#define OHOS_PJSIP_PROJECT_PJSIP_STRUCT_H

struct EmptyParamCallback {
    napi_env env_;
    napi_ref callbackRef;
    int32_t code;
};

struct CallMediaEvent {
    int medIdx;
    pjsip::Pjsip_Call &call;
};

#endif // OHOS_PJSIP_PROJECT_PJSIP_STRUCT_H
