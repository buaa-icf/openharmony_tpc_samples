//
// Created on 2025/2/17.
//
// Node APIs are not fully supported. To solve the compilation error of the interface cannot be found,
// please include "napi/native_api.h".

#include "pjsip_app.h"
#include "DebugLog.h"
#include "account/pjsip_account.h"
#include "pjsip_call.h"
#include "pjsip_log_writer.h"
#include "pjsua2/media.hpp"
#include <native_window/external_window.h>
#include <pjsua.h>


namespace pjsip {
const int LOG_LEVEL = 5;
const int SIP_PORT = 6000;
std::shared_ptr<pj::Endpoint> PjsipApp::endpoint = nullptr;

int PjsipApp::initPJSIP() {
    LOGI("pjsip_app init_app initPJSIP start");
    if (isInit) {
        return 0;
    }
    isInit = true;
    endpoint = std::make_shared<pj::Endpoint>();
    try {
        endpoint->libCreate();
    } catch (pj::Error &e) {
        LOGE("pjsip_app libCreate Error %{public}s", e.info(false).c_str());
        return PJ_FALSE;
    }
    epConfig.logConfig.level = LOG_LEVEL;
    epConfig.logConfig.consoleLevel = LOG_LEVEL;

    epConfig.logConfig.writer = new PJSIP_Writer();
    epConfig.logConfig.decor = epConfig.logConfig.decor & ~256 | 128;

    std::string agent = "Pjsua2 HarmonyOs " + endpoint->libVersion().full;
    epConfig.uaConfig.userAgent = agent;

    try {
        endpoint->libInit(epConfig);
    } catch (pj::Error &e) {
        LOGE("pjsip_app libInit Error %{public}s", e.info(false).c_str());
        return PJ_FALSE;
    }
    transportConfig.port = SIP_PORT;
    try {
        endpoint->transportCreate(::pjsip_transport_type_e::PJSIP_TRANSPORT_UDP, transportConfig); // PJ_SUCCESS

    } catch (pj::Error &e) {
        LOGE("pjsip_app transportCreate PJSIP_TRANSPORT_UDP Error %{public}s", e.info(false).c_str());
        return PJ_FALSE;
    }
    try {
        endpoint->transportCreate(::pjsip_transport_type_e::PJSIP_TRANSPORT_TCP, transportConfig);
    } catch (pj::Error &e) {
        LOGE("pjsip_app transportCreate PJSIP_TRANSPORT_TCP Error %{public}s", e.info(false).c_str());
        return PJ_FALSE;
    }
    try {
        endpoint->libStart();
    } catch (pj::Error &e) {
        LOGE("pjsip_app libStart Error %{public}s", e.info(false).c_str());
        return PJ_FALSE;
    }

    pj::CodecInfoVector2 codecs = endpoint->videoCodecEnum2();
    std::string codecId = "H264/";
    for (pj::CodecInfo c : codecs) {
        LOGI("pjsip_app CodecInfo----<> %{public}s", c.codecId.c_str());
        if (c.codecId.rfind(codecId, 0) == 0) {
            codecId = c.codecId;
            break;
        }
    }
    pj::VidCodecParam param = endpoint->getVideoCodecParam(codecId);
    param.encFmt.width = 240;
    param.encFmt.height = 320;
    endpoint->setVideoCodecParam(codecId, param);


    config.idUri = "sip:1007";
    config.natConfig.iceEnabled = true;
    config.videoConfig.autoTransmitOutgoing = true;
    config.videoConfig.autoShowIncoming = true;

    config.callConfig.timerMinSESec = 90;
    config.callConfig.timerSessExpiresSec = 1800;
    if (!account) {
        account = new pjsip::Pjsip_Account(config);
    }
    try {
        account->create(config);
    } catch (pj::Error &e) {
        LOGE("pjsip_app create account Error %{public}s", e.info(false).c_str());
        return PJ_FALSE;
    }
    LOGI("pjsip_app init_app success");
    return PJ_SUCCESS;
}

int PjsipApp::modifyAccount(const std::string &idUri, const std::string &registrarUri, const std::string &userName, const std::string &pwd) {
    if (!account) {
        return PJ_FALSE;
    }
    config.idUri = idUri;
    config.regConfig.registrarUri = registrarUri;
    config.sipConfig.authCreds.clear();

    pj::AuthCredInfo authCredInfo;
    authCredInfo.scheme = "Digest";
    authCredInfo.realm = "*";
    authCredInfo.username = userName;
    authCredInfo.dataType = 0;
    authCredInfo.data = pwd;
    config.sipConfig.authCreds.push_back(authCredInfo);
    config.sipConfig.proxies.clear();

    config.natConfig.iceEnabled = true;
    config.videoConfig.autoTransmitOutgoing = true;
    config.videoConfig.autoShowIncoming = true;

    try {
        account->modify(config);
    } catch (pj::Error &e) {
        return PJ_FALSE;
    }
    return PJ_SUCCESS;
}
void PjsipApp::SetInCallingCallBack(napi_env env, napi_ref callBack) {
    if (account) {
        account->SetInCallingCallBack(env, callBack);
    }
}

void PjsipApp::SetInCallStateCallBack(napi_env env, napi_ref callBack) {
    if (account) {
        account->SetInCallStateCallBack(env, callBack);
    }
}

void PjsipApp::accept_call() {
    if (account) {
        account->acceptCall();
    }
}
void PjsipApp::handUp_call() {
    if (account) {
        account->hangup();
    }
}
void PjsipApp::make_call(std::string uri) {
    if (account) {
        account->makeCall(uri);
    }
}

void PjsipApp::setRemoteSurfaceId(std::string surfaceId) {
    if (!account) {
        account = new pjsip::Pjsip_Account(config);
    }
    account->setRemoteSurfaceId(surfaceId);
}

void PjsipApp::destroy() {
    if (endpoint) {
        endpoint->libDestroy();
        endpoint = nullptr;
    }
    if (account) {
        delete account;
        account = nullptr;
    }
}
}