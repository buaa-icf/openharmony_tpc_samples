/**
 * Copyright (C) 2023 Huawei Device Co., Ltd.
 *
 * This software is distributed under a license. The full license
 * agreement can be found in the file LICENSE in this distribution.
 * This software may not be copied, modified, sold or distributed
 * other than expressed in the named license agreement.
 *
 * This software is distributed without any warranty.
 */

#include <node_api.h>
#include "log.h"
#include "MyMUCInvitationHandler.h"

using namespace gloox;

struct ThreadSafeInfo {
    std::string result;
};

static struct ThreadSafeInfo g_threadInfo = {};
static napi_threadsafe_function tsfn;

static void CallJs(napi_env env, napi_value jsCb, void *context, void *data)
{
    LOGI("SMACK_TAG--------->MyMUCInvitationHandler CallJs0: %s:  %d", "CallJs: ", __LINE__);
    napi_value undefined;
    napi_value ret;
    napi_value argv;
    
    ThreadSafeInfo *arg = (ThreadSafeInfo *)data;
    if (arg == nullptr) {
        LOGE("SMACK_TAG---------> [MyMUC....CallJs]arg is null");
        return;
    }
    LOGI("SMACK_TAG--------->MyMUCInvitationHandler CallJs2: %s:  %d", (arg->result).c_str(), __LINE__);
    napi_create_string_utf8(env, (arg->result).c_str(), NAPI_AUTO_LENGTH, &argv);
    LOGI("SMACK_TAG--------->CallJs4: %s:  %d", "CallJs: ", __LINE__);

    napi_status status = napi_call_function(env, undefined, jsCb, 1, &argv, &ret);
    LOGI("SMACK_TAG--------->MyMUCInvitationHandler CallJs5: %d:  %d", status, __LINE__);
}

void MyMUCInvitationHandler::recvMUCInvitation(napi_env env, napi_value jsCb)
{
    napi_value workName;
    napi_create_string_utf8(env, "recvMUCInvitation", NAPI_AUTO_LENGTH, &workName);
    LOGI("SMACK_TAG--------->: %s:  %d", "recvMUCInvitation: ", __LINE__);
    napi_create_threadsafe_function(env, jsCb, nullptr, workName, 0, 1, nullptr, nullptr, nullptr, CallJs, &tsfn);
    LOGI("SMACK_TAG--------->: %s:  %d", "recvMUCInvitation: ", __LINE__);
}

void MyMUCInvitationHandler::handleMUCInvitation(const JID &room, const JID &from, const std::string &reason,
                                                 const std::string &body, const std::string &password,
                                                 bool cont, const std::string &thread)
{
    std::string jsonStr;
    jsonStr.append("{");
    jsonStr.append("\"room\":\"");
    jsonStr.append(room.full().c_str());
    jsonStr.append("\",");
    jsonStr.append("\"from\":\"");
    jsonStr.append(from.full().c_str());
    jsonStr.append("\",");
    jsonStr.append("\"reason\":\"");
    jsonStr.append(reason.c_str());
    jsonStr.append("\",");
    jsonStr.append("\"body\":\"");
    jsonStr.append(body.c_str());
    jsonStr.append("\",");
    jsonStr.append("\"password\":\"");
    jsonStr.append(password.c_str());
    jsonStr.append("\",");
    jsonStr.append("\"cont\":\"");
    jsonStr.append("");
    jsonStr.append("\",");
    jsonStr.append("\"thread\":\"");
    jsonStr.append(thread.c_str());

    jsonStr.append("\"");
    jsonStr.append("}");

    LOGI("Test MyMUCInvitationHandler %s", jsonStr.c_str());
    LOGI("Test MyMUCInvitationHandler handleMUCInvitation room: %s, from: %s, reason: %s, body: %s,"
        "password: %s, cont: %s, thread: %s",
        room.full().c_str(), from.full().c_str(), reason.c_str(), body.c_str(), password.c_str(),
        cont, thread.c_str());

    ThreadSafeInfo *data = &g_threadInfo;
    if (data == nullptr) {
        LOGE("SMACK_TAG---------> [MyMUC....handleMUCInvitation]data is null");
        return;
    }
    data->result = jsonStr.c_str();
    napi_acquire_threadsafe_function(tsfn);
    
    napi_call_threadsafe_function(tsfn, data, napi_tsfn_blocking);
    LOGI("SMACK_TAG--------->: %s:  %d", "handleMUCInvitation: ", __LINE__);
}

MyMUCInvitationHandler::MyMUCInvitationHandler(ClientBase *parent) : MUCInvitationHandler(parent)
{
    if (parent == nullptr) {
        LOGE("SMACK_TAG---------> [MyMUC.....MyMUCInvitationHandler]parent is null");
        return;
    }
    clientBase = parent;
}
