//
// Created on 2025/2/17.
//
// Node APIs are not fully supported. To solve the compilation error of the interface cannot be found,
// please include "napi/native_api.h".
#include "pjsip_account.h"
#include "napi/native_api.h"
#include <arkui/native_node_napi.h>
#include <native_window/external_window.h>
#include <pjsua2.hpp>

#ifndef OHOS_PJSIP_PROJECT_PJSIP_APP_H
#define OHOS_PJSIP_PROJECT_PJSIP_APP_H

namespace pjsip {
class PjsipApp {
public:
    PjsipApp() = default;
    int initPJSIP();
    int modifyAccount(const std::string &idUri, const std::string &registrarUri, const std::string &userName, const std::string &pwd);
    void SetInCallingCallBack(napi_env env, napi_ref callBack);
    void SetInCallStateCallBack(napi_env env, napi_ref callBack);
    void accept_call();
    void handUp_call();
    void make_call(std::string uri);
    void setRemoteSurfaceId(std::string surfaceId);
    void destroy();

public:
    static std::shared_ptr<pj::Endpoint> endpoint;
    static void Export(napi_env env, napi_value exports);

private:
    bool isInit{false};
    pj::EpConfig epConfig;
    pj::AccountConfig config;
    pj::TransportConfig transportConfig;
    pjsip::Pjsip_Account *account;
    unsigned routes;
};
} // namespace pjsip
#endif // OHOS_PJSIP_PROJECT_PJSIP_APP_H
