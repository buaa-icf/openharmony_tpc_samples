//
// Created on 2025/2/20.
//
// Node APIs are not fully supported. To solve the compilation error of the interface cannot be found,
// please include "napi/native_api.h".

#ifndef OHOS_PJSIP_PROJECT_PJSIP_CALL_H
#define OHOS_PJSIP_PROJECT_PJSIP_CALL_H
#include "pjsip_account.h"
#include "pjsua2/call.hpp"
namespace pjsip {
class Pjsip_Call : public pj::Call {

public:
    Pjsip_Call(Pjsip_Account &pjsip_Account, int callID);
    ~Pjsip_Call() override;
    void onCallState(pj::OnCallStateParam &prm) override;
    void onCallTsxState(pj::OnCallTsxStateParam &prm) override;
    void onCallMediaState(pj::OnCallMediaStateParam &prm) override;
    void onCallSdpCreated(pj::OnCallSdpCreatedParam &prm) override;
    void onStreamPreCreate(pj::OnStreamPreCreateParam &prm) override;
    void onStreamCreated(pj::OnStreamCreatedParam &prm) override;
    void onCallMediaEvent(pj::OnCallMediaEventParam &prm) override;
    void setPjsipListener(pjsip::Pjsip_Listener *pjsip_Listener);

public:
    bool isInit{false};
    pj::VideoPreview *videoPreview{nullptr};
    bool vidPrevStarted{false};
    Pjsip_Listener *listener{nullptr};
};
} // namespace pjsip


#endif // OHOS_PJSIP_PROJECT_PJSIP_CALL_H
