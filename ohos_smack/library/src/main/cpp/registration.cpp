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

#include <js_native_api.h>
#include <node_api.h>
#include <node_api_types.h>
#include <src/base64.h>
#include <src/message.h>
#include <unistd.h>
#include <ctime>

#include "gloox/src/disco.h"
#include "log.h"
#include "registration.h"

using namespace gloox;
constexpr int REG_DELAY_TM_40S = (5 * 1000 * 500); // 延时约40秒

struct ThreadSafeInfo {
    int result;
};
static constexpr const size_t CALL_JS_ARGV_SIZE = 1;
static struct ThreadSafeInfo g_threadInfo = {};
static napi_threadsafe_function tsfn;

static void DelayMsecs(int msec)
{
    clock_t now = clock();
    if (now > 0) {
        while (clock() - now < msec) {}
    }
}

static void CallJs(napi_env env, napi_value jsCb, void *context, void *data)
{
    LOGI("SMACK_TAG--------->CallJS:", "%{public}d", __LINE__);
    napi_value undefined;
    napi_status undefinedStatus = napi_get_null(env, &undefined);
    if (undefinedStatus != napi_ok) {
        LOGE("SMACK_TAG--------->CallJS get globalThis fail");
        return;
    }

    napi_value ret;

    napi_value argv;

    // 解析参数 data
    ThreadSafeInfo *arg = (ThreadSafeInfo *)data;
    if (arg == nullptr) {
        LOGE("SMACK_TAG---------> [createAccounts.CallJs]arg is null");
        return;
    }
    napi_create_int32(env, arg->result, &argv);
    // 调用 js 回调函数
    napi_status status;
    if (jsCb != nullptr && argv != nullptr) {
        LOGI("SMACK_TAG--------->createAccounts CallJs3:  %{public}d", __LINE__);
        status = napi_call_function(env, undefined, jsCb, CALL_JS_ARGV_SIZE, &argv, &ret);
        LOGI("SMACK_TAG--------->createAccounts CallJs4:  %{public}d", __LINE__);
    }
    tsfn = nullptr;
    LOGI("SMACK_TAG--------->createAccounts CallJs5: %d:  %d", status, __LINE__);
}

void registration::createAccounts(const std::string &ipStr, const std::string &nameStr, const std::string &pwdStr,
                                  napi_env env, napi_value jsCb)
{
    LOGI("SMACK_TAG--------->createAccounts: %{public}d", __LINE__);
    
    napi_value workName;
    napi_create_string_utf8(env, "createAccounts", NAPI_AUTO_LENGTH, &workName);
    LOGI("SMACK_TAG--------->createAccounts 1: %{public}d", __LINE__);
    napi_create_threadsafe_function(env, jsCb, nullptr, workName, 0, 1, nullptr, nullptr, nullptr, CallJs, &tsfn);
    LOGI("SMACK_TAG--------->createAccounts 2: %{public}d", __LINE__);
    
    name = nameStr;
    pwd = pwdStr;
    j = new Client(ipStr);

    j->disableRoster();
    j->registerConnectionListener(this);

    m_reg = new Registration(j);
    m_reg->registerRegistrationHandler(this);

    j->logInstance().registerLogHandler(LogLevelDebug, LogAreaAll, this);
    j->disco()->setVersion("messageTest", GLOOX_VERSION, "OHOS");
    j->disco()->setIdentity("client", "bot");
    j->disco()->addFeature(XMLNS_CHAT_STATES);

    j->connect();
}

void registration::onConnect()
{
    LOGI("onConnect!!!\n");
    if (m_reg != nullptr)
        m_reg->fetchRegistrationFields();
}

void registration::onDisconnect(ConnectionError e)
{
    LOGI("onDisconnect: %{public}d\n", e);
    if (e == ConnAuthenticationFailed)
        LOGD("auth failed. reason: %d\n", j->authError());
}

bool registration::onTLSConnect(const CertInfo &info)
{
    time_t from(info.date_from);
    time_t to(info.date_to);

    LOGI("onTLSConnect status: %d\nissuer: %s\npeer: %s\nprotocol: %s\nmac: %s\ncipher: %s\ncompression: %s\n"
         "from: %s\nto: %s\n",
         info.status, info.issuer.c_str(), info.server.c_str(),
         info.protocol.c_str(), info.mac.c_str(), info.cipher.c_str(),
         info.compression.c_str(), ctime(&from), ctime(&to));
    return true;
}

void registration::onResourceBind(const std::string &resource)
{
    LOGI("onResourceBind: %s", resource.c_str());
}

void registration::onResourceBindError(const Error *error)
{
    LOGI("onResourceBindError: %d\n", error);
}

void registration::onSessionCreateError(const Error *error)
{
    LOGI("onSessionCreateError: %d\n", error);
}

void registration::handleLog(LogLevel level, LogArea area, const std::string &message)
{
    LOGI("handleLog area: 0x%x, msg: %s", area, message.c_str());
}

void registration::onStreamEvent(StreamEvent event)
{
    LOGI("onStreamEvent");
}

void registration::handleRegistrationFields(const JID &from, int fields, std::string instructions)
{
    LOGI("handleRegistrationFields", "handleRegistrationFields fields: %d instructions: %s ,from %s", fields,
        instructions.c_str(), from.full().c_str());
    RegistrationFields vals;
    vals.username = name;
    vals.password = pwd;
    bool isRegSuc = m_reg->createAccount(fields, vals);
}

void registration::handleRegistrationResult(const JID & /* from */, RegistrationResult result)
{
    LOGI("SMACK_TAG---------->", "handleRegistrationResult result: %{public}d", result);

    ThreadSafeInfo *data = &g_threadInfo;
    if (data == nullptr) {
        LOGE("SMACK_TAG---------> [registration.handleRegistrationResult]data is null");
        return;
    }
    data->result = result;
    napi_acquire_threadsafe_function(tsfn);
    LOGI("SMACK_TAG--------->: %s:  %d", "handleRegistrationResult: ", __LINE__);
    // 调用主线程函数，传入 Data
    napi_call_threadsafe_function(tsfn, data, napi_tsfn_blocking);
    LOGI("SMACK_TAG--------->: %s:  %d", "handleRegistrationResult: ", __LINE__);
    j->disconnect();
}

void registration::handleAlreadyRegistered(const JID & /* from */)
{
    LOGI("handleAlreadyRegistered", "handleAlreadyRegistered the account already exists.\n");
}

void registration::handleDataForm(const JID & /* from */, const DataForm & /* form */)
{
    LOGI("handleDataForm datForm received\n");
}

void registration::handleOOB(const JID & /* from */, const OOB &oob)
{
    LOGI("handleOOB OOB registration requested. %s: %s\n", oob.desc().c_str(), oob.url().c_str());
}
