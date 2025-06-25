//
// Created on 2025/2/18.
//
// Node APIs are not fully supported. To solve the compilation error of the interface cannot be found,
// please include "napi/native_api.h".

#ifndef OHOS_PJSIP_PROJECT_PJSIP_ACCOUNT_H
#define OHOS_PJSIP_PROJECT_PJSIP_ACCOUNT_H

#include "listener/pjsip_listener.h"
#include "pjsua2/account.hpp"
#include "pjsua2/types.hpp"
#include <native_window/external_window.h>
#include <pjsua2.hpp>
#include "napi/native_api.h"

namespace pjsip {
class Pjsip_Account : public pj::Account, pjsip::Pjsip_Listener {

public:
    Pjsip_Account(pj::AccountConfig config);
    ~Pjsip_Account() override;
    void onRegState(pj::OnRegStateParam &prm) override;
    void onIncomingCall(pj::OnIncomingCallParam &prm) override;
    void onInstantMessage(pj::OnInstantMessageParam &prm) override;
    void onCallStateChange(int32_t status) override;
    void onCallMediaEvent(int32_t mid) override;
    void SetInCallingCallBack(napi_env env, napi_ref callBack);
    void SetInCallStateCallBack(napi_env env, napi_ref callBack);
    void setCall(pj::Call *call);
    void acceptCall();
    void hangup();
    void makeCall(std::string uri);
    void setRemoteSurfaceId(const std::string& surfaceId);
    pj::AccountConfig accountConfig;

private:
    int testInde = 0;
    napi_ref inCallingCallBack;
    napi_ref inCallStateCallBack;
    napi_env env_;
    pj::Call *call_{nullptr};
    OHNativeWindow *remoteWindow{nullptr};
    std::string surfaceId;
};
} // namespace pjsip


#endif // OHOS_PJSIP_PROJECT_PJSIP_ACCOUNT_H
