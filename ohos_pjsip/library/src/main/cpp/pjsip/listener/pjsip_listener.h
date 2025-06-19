//
// Created on 2025/2/21.
//
// Node APIs are not fully supported. To solve the compilation error of the interface cannot be found,
// please include "napi/native_api.h".

#include "napi/native_api.h"
#include <cstdint>
#include <functional>

#ifndef OHOS_PJSIP_PROJECT_PJSIP_LISTENER_H
#define OHOS_PJSIP_PROJECT_PJSIP_LISTENER_H

namespace pjsip {
class Pjsip_Listener {
public:
    virtual ~Pjsip_Listener() = default;
    virtual void onCallStateChange(int32_t status){};
    virtual void onCallMediaEvent(int32_t mid){};
};
} // namespace pjsip

#endif // OHOS_PJSIP_PROJECT_PJSIP_LISTENER_H
