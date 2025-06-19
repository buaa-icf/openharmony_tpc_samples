//
// Created on 2025/2/20.
//
// Node APIs are not fully supported. To solve the compilation error of the interface cannot be found,
// please include "napi/native_api.h".

#include "pjsip_call.h"
#include "DebugLog.h"
#include "listener/pjsip_struct.h"
#include "pjsip_app.h"
#include "pjsua2/call.hpp"
#include "pjsua2/media.hpp"
#include "pjsua2/types.hpp"

namespace pjsip {
Pjsip_Call::Pjsip_Call(pjsip::Pjsip_Account &pjsip_account, int callID) : pj::Call(pjsip_account, callID) {}
Pjsip_Call::~Pjsip_Call() {
    if (listener) {
        listener = nullptr;
    }
    if (videoPreview) {
        if (vidPrevStarted) {
            videoPreview->stop();
        }
        delete videoPreview;
        videoPreview = nullptr;
        vidPrevStarted = false;
    }
}
void Pjsip_Call::onCallState(pj::OnCallStateParam &prm) {
    LOGI("pjsip_app onCallState---->state:%{public}d; stateString:%{public}s", getInfo().state,
         getInfo().stateText.c_str());
    if (getInfo().state == PJSIP_INV_STATE_DISCONNECTED) {
        try {
            if (vidPrevStarted && videoPreview) {
                videoPreview->stop();
                videoPreview = nullptr;
                vidPrevStarted = false;
            }
        } catch (pj::Error &e) {
            LOGE("pjsip_app onCallState stop videoPreview error");
        }
    }
    if (listener) {
        listener->onCallStateChange(getInfo().state);
    }
}
void Pjsip_Call::onCallTsxState(pj::OnCallTsxStateParam &prm) {
    LOGI("pjsip_app onCallTsxState----> type:%{public}d", prm.e.type);
}
void Pjsip_Call::onCallMediaState(pj::OnCallMediaStateParam &prm) {
    LOGE("pjsip_app onCallMediaState-------------->>");
    auto callInfo = getInfo();
    pj::CallMediaInfoVector callMedia = callInfo.media;
    if (callMedia.size() == 0) {
        return;
    }
    for (int i; i < callMedia.size(); i++) {
        auto el = callMedia[i];
        auto type = el.type;
        auto status = el.status;
        LOGE("pjsip_app ohos_video_dev onCallMediaState status: %{public}d ;type:%{public}d", status, type);
        if (type == PJMEDIA_TYPE_AUDIO &&
            (status == PJSUA_CALL_MEDIA_ACTIVE || status == PJSUA_CALL_MEDIA_REMOTE_HOLD)) {
            // 音頻
            try {
                pj::AudioMedia audioMedia = getAudioMedia(i);
                pjsip::PjsipApp::endpoint->audDevManager().getCaptureDevMedia().startTransmit(audioMedia);
                audioMedia.startTransmit(pjsip::PjsipApp::endpoint->audDevManager().getPlaybackDevMedia());
            } catch (pj::Error &e) {
                LOGE("pjsip_app onCallMediaState setAudioMedia %{public}s", e.info(false).c_str());
            }
        }
        if (type == PJMEDIA_TYPE_VIDEO && status == PJSUA_CALL_MEDIA_ACTIVE) {
            try {
                if (vidPrevStarted && videoPreview) {
                    videoPreview->stop();
                    delete videoPreview;
                    videoPreview = nullptr;
                    vidPrevStarted = false;
                }
            } catch (pj::Error &e) {
                LOGE("pjsip_app stop videoPreview error");
            }

            // 視頻
            auto windowId = el.videoIncomingWindowId;
            if (windowId == pj::INVALID_ID) {
                LOGE("pjsip_app create window id is INVALID_ID");
                return;
            }
            if ((el.dir & PJMEDIA_DIR_ENCODING) != 0 && !vidPrevStarted) {
                try {
                    videoPreview = new pj::VideoPreview(el.videoCapDev);
                    pj::VideoPreviewOpParam pram;
                    pram.rendId = PJMEDIA_VID_DEFAULT_RENDER_DEV;
                    pram.show = PJ_TRUE;
                    pram.windowFlags = 0;
                    videoPreview->start(pram);
                    vidPrevStarted = true;
                } catch (pj::Error &e) {
                    LOGE("pjsip_app start videoPreview error");
                }
            }
        }
    }
}
void Pjsip_Call::onCallSdpCreated(pj::OnCallSdpCreatedParam &prm) { LOGI("pjsip_app onCallSdpCreated---->"); }
void Pjsip_Call::onStreamPreCreate(pj::OnStreamPreCreateParam &prm) { LOGI("pjsip_app onStreamPreCreate---->"); }
void Pjsip_Call::onStreamCreated(pj::OnStreamCreatedParam &prm) { LOGI("pjsip_app onStreamCreated---->"); }
void Pjsip_Call::onCallMediaEvent(pj::OnCallMediaEventParam &prm) {
    auto type = prm.ev.type;
    auto midIndex = prm.medIdx;
    auto streamIdx = vidGetStreamIdx();
    LOGE("pjsip_app onCallMediaEvent----------->midIndex:%{public}d,type:%{public}d,streamIdx:%{public}d", midIndex,
         type, streamIdx);
    if (!isInit && type == PJMEDIA_EVENT_FMT_CHANGED && streamIdx == midIndex) {
        isInit = true;
        if (listener) {
            listener->onCallMediaEvent(midIndex);
        }
    }
}

void Pjsip_Call::setPjsipListener(pjsip::Pjsip_Listener *pjsip_Listener) { listener = pjsip_Listener; }
}