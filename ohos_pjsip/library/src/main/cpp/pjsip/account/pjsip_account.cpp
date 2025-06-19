//
// Created on 2025/2/18.
//
// Node APIs are not fully supported. To solve the compilation error of the interface cannot be found,
// please include "napi/native_api.h".

#include "pjsip_account.h"
#include "DebugLog.h"
#include "listener/pjsip_struct.h"
#include "napi_helper.h"
#include "pjsip_call.h"
#include <uv.h>

namespace pjsip {

Pjsip_Account::Pjsip_Account(pj::AccountConfig config) :accountConfig(config){ }

Pjsip_Account::~Pjsip_Account() {
    if (call_) {
        delete call_;
        call_ = nullptr;
    }
    if (remoteWindow) {
        OH_NativeWindow_DestroyNativeWindow(remoteWindow);
        delete remoteWindow;
        remoteWindow = nullptr;
    }
}

void Pjsip_Account::onRegState(pj::OnRegStateParam &prm) {
    LOGI("pjsip_app onRegState code:%{public}d", prm.code);
    LOGI("pjsip_app onRegState reason:%{public}s", prm.reason.c_str());
    LOGI("pjsip_app onRegState status:%{public}d", prm.status);
    LOGI("pjsip_app onRegState expiration:%{public}d", prm.expiration);
}

void Pjsip_Account::onIncomingCall(pj::OnIncomingCallParam &prm) {
    LOGI("pjsip_app pjsua_acc onIncomingCall prm.getCallId():%{public}d", prm.callId);

    pjsip::Pjsip_Call *pjsip_Call = new Pjsip_Call(*this, prm.callId);
    pj::CallOpParam callOpParam;
    callOpParam.statusCode = PJSIP_SC_RINGING;
    pjsip_Call->answer(callOpParam);
    if (inCallingCallBack) {
        EmptyParamCallback *requestCallback = new EmptyParamCallback{
            .env_ = env_,
            .callbackRef = inCallingCallBack,

        };
        uv_loop_s *loopMessage = nullptr;
        napi_get_uv_event_loop(env_, &loopMessage);
        if (loopMessage == nullptr) {
            return;
        }
        uv_work_t *work = new (std::nothrow) uv_work_t;
        if (work == nullptr) {
            return;
        }
        work->data = requestCallback;
        uv_queue_work(
            loopMessage, work, [](uv_work_t *work) {},
            [](uv_work_t *work, int status) {
                EmptyParamCallback *requestCallback = (EmptyParamCallback *)(work->data);
                napi_value callback = nullptr;
                napi_value ret = 0;
                napi_get_reference_value(requestCallback->env_, requestCallback->callbackRef, &callback);
                napi_call_function(requestCallback->env_, nullptr, callback, 0, nullptr, &ret);
            });
    }
    setCall(pjsip_Call);
    pjsip_Call->setPjsipListener(this);
    LOGI("pjsip_app onIncomingCall ------->end");
}


void Pjsip_Account::onInstantMessage(pj::OnInstantMessageParam &prm) {
    LOGI("pjsip_app onInstantMessage contactUri():%{public}s", prm.contactUri.c_str());
    LOGI("pjsip_app onInstantMessage fromUri():%{public}s", prm.fromUri.c_str());
    LOGI("pjsip_app onInstantMessage toUri():%{public}s", prm.toUri.c_str());
    LOGI("pjsip_app onInstantMessage msgBody():%{public}s", prm.msgBody.c_str());
    LOGI("pjsip_app onInstantMessage contentType():%{public}s", prm.contentType.c_str());
}

void Pjsip_Account::SetInCallingCallBack(napi_env env, napi_ref callBack) {
    inCallingCallBack = std::move(callBack);
    env_ = env;
}
void Pjsip_Account::SetInCallStateCallBack(napi_env env, napi_ref callBack) {
    inCallStateCallBack = std::move(callBack);
    env_ = env;
}
void Pjsip_Account::setCall(pj::Call *call) { call_ = call; }
void Pjsip_Account::setRemoteSurfaceId(const std::string& surfaceId) { this->surfaceId = surfaceId; }
void Pjsip_Account::acceptCall() {
    LOGI("pjsip_app ------->acceptCall start");
    if (call_) {
        try {
            pj::CallOpParam callOpParam;
            callOpParam.statusCode = PJSIP_SC_OK;
            call_->answer(callOpParam);
        } catch (pj::Error &e) {
            LOGE("pjsip_app ------->acceptCall error");
        }

        LOGI("pjsip_app ------->acceptCall end");
    }
}
void Pjsip_Account::hangup() {
    LOGI("pjsip_app ------->hangup start");
    if (call_) {
        try {
            pj::CallOpParam callOpParam;
            callOpParam.statusCode = PJSIP_SC_DECLINE;
            call_->hangup(callOpParam);
        } catch (pj::Error &e) {
            LOGE("pjsip_app ------->hangup error");
        }
        LOGI("pjsip_app ------->hangup end");
    }
}

void Pjsip_Account::makeCall(std::string uri) {
    try {
        pjsip::Pjsip_Call *pjsip_Call = new Pjsip_Call(*this, -1);
        setCall(pjsip_Call);
        pjsip_Call->setPjsipListener(this);
        pj::CallOpParam *callOpParam = new pj::CallOpParam(true);
        pjsip_Call->makeCall(uri, callOpParam);
    } catch (pj::Error &e) {
        LOGE("pjsip_app ------->makeCall error");
    }
}

void Pjsip_Account::onCallStateChange(int32_t callStatus) {
    EmptyParamCallback *requestCallback = new EmptyParamCallback{
        .env_ = env_,
        .callbackRef = inCallStateCallBack,
        .code = callStatus,
    };

    uv_loop_s *loopMessage = nullptr;
    napi_get_uv_event_loop(env_, &loopMessage);
    if (loopMessage == nullptr) {
        return;
    }
    uv_work_t *work = new (std::nothrow) uv_work_t;
    if (work == nullptr) {
        return;
    }
    work->data = requestCallback;
    uv_queue_work(
        loopMessage, work, [](uv_work_t *work) {},
        [](uv_work_t *work, int status) {
            EmptyParamCallback *requestCallback = (EmptyParamCallback *)(work->data);
            napi_value callback = nullptr;
            napi_value ret = 0;
            napi_value sta;
            napi_create_int32(requestCallback->env_, requestCallback->code, &sta);
            napi_get_reference_value(requestCallback->env_, requestCallback->callbackRef, &callback);
            napi_value param[] = {sta};
            napi_call_function(requestCallback->env_, nullptr, callback, 1, param, &ret);
        });
    if (callStatus == PJSIP_INV_STATE_DISCONNECTED) {
        if (remoteWindow) {
            OH_NativeWindow_DestroyNativeWindow(remoteWindow);
            remoteWindow = nullptr;
        }
    }
}

void Pjsip_Account::onCallMediaEvent(int32_t mid) {
    int32_t ret = 0;
    if (!remoteWindow) {
        ret = OH_NativeWindow_CreateNativeWindowFromSurfaceId(std::stoull(surfaceId), &remoteWindow);
    }
    if (ret == 0) {
        ret = OH_NativeWindow_NativeWindowSetScalingModeV2(remoteWindow,OHScalingModeV2::OH_SCALING_MODE_SCALE_TO_WINDOW_V2);
        LOGE("pjsip_app ------->onCallMediaEvent11 create OH_NativeWindow ret%{public}d",ret);
        if (call_ && remoteWindow) {
            pj::VideoWindowHandle wh;
            wh.handle.window = remoteWindow;
            call_->getInfo().media[mid].videoWindow.setWindow(wh);
        }
    } else {
        LOGE("pjsip_app ------->onCallMediaEvent create OH_NativeWindow fail");
    }
}
} // namespace pjsip
