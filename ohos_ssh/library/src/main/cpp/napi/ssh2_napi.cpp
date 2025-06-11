/*
 * Copyright (C) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "ssh2_napi.h"
#include "napi/keygen2.h"
#include "napi/ssh2_struct.h"
#include "ssh2_constant.h"
#include "ssh2_server.h"
#include "utils/log/ohos_log.h"
#include "utils/napi/napi_utils.h"
#include <cstring>
#include <libssh/callbacks.h>
#include <libssh/libssh.h>
#include <libssh/server.h>
#include <libssh/sftp.h>
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <uv.h>

//---------------------------处理回调callback开始-------------------//

void (*g_postEvent)(SSH2Napi *ssh2Napi, int type);

void MessageCallback(void (*postEventFunction)(SSH2Napi *ssh2Napi, int type)) { g_postEvent = postEventFunction; }

void CallJs(uv_work_t *work) {
    if (!work) {
        return;
    }
    CallJsContext *callJsContext = (CallJsContext *)(work->data);
    napi_handle_scope scope = nullptr;
    napi_open_handle_scope(callJsContext->env, &scope);
    napi_value typeNV;
    napi_create_int32(callJsContext->env, callJsContext->type, &typeNV);
    napi_value ret = 0;
    napi_value callback = nullptr;
    LOGE("napi-->uv_queue_work type: %d", callJsContext->type);
    if (!callJsContext->callbackRef) {
        delete work;
        return;
    }
    napi_get_reference_value(callJsContext->env, callJsContext->callbackRef, &callback);
    napi_value argv_1[] = {typeNV};
    napi_call_function(callJsContext->env, nullptr, callback, NUM_1, argv_1, &ret);
    napi_close_handle_scope(callJsContext->env, scope);
    delete work;
    delete callJsContext;
    callJsContext = nullptr;
}

void OnEventListener(SSH2Napi *ssh2Napi, int type) {
    uv_loop_s *loopMessage = nullptr;
    napi_get_uv_event_loop(ssh2Napi->_env, &loopMessage);
    if (loopMessage == nullptr) {
        return;
    }
    uv_work_t *work = new (std::nothrow) uv_work_t;
    if (work == nullptr) {
        return;
    }

    if (type == SSH2_START_SUCCESS || type == SSH2_START_FAILED) {
        CallJsContext *callJsContext =
            new CallJsContext{.type = type, .env = ssh2Napi->_env, .callbackRef = ssh2Napi->_ssh2ClientCallBackRef};
        work->data = callJsContext;
    } else {
        CallJsContext *callJsContext =
            new CallJsContext{.type = type, .env = ssh2Napi->_env, .callbackRef = ssh2Napi->_sftpServerCallBackRef};
        work->data = callJsContext;
    }
    uv_queue_work(
        loopMessage, work, [](uv_work_t *work) {}, [](uv_work_t *work, int status) { CallJs(work); });
}

//---------------------------处理回调callback结束-------------------//

napi_value SSH2Napi::ClassConstructor(napi_env env, napi_callback_info info) {
    napi_value targetObj = nullptr;
    size_t argc = PARAM_COUNT_0;
    napi_value args[PARAM_COUNT_1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, &targetObj, nullptr);
    SSH2Napi *ssh2Napi = new SSH2Napi();
    LOGE("new ClassConstructor");
    napi_wrap(
        env, targetObj, ssh2Napi,
        [](napi_env env, void *data, void *hint) {
            LOGE("ClassConstructor end");
            SSH2Napi *ssh2NapiObj = static_cast<SSH2Napi *>(data);
            delete ssh2NapiObj;
            ssh2NapiObj = nullptr;
        },
        nullptr, nullptr);
    return targetObj;
}

napi_value SSH2Napi::StartSSHClient(napi_env env, napi_callback_info info) {
    size_t argc = PARAM_COUNT_4;
    napi_value args[PARAM_COUNT_4] = {nullptr};
    napi_value thisVal = nullptr;
    napi_get_cb_info(env, info, &argc, args, &thisVal, nullptr);
    std::string ip;
    NapiUtil::JsValueToString(env, args[INDEX_0], STR_DEFAULT_SIZE, ip);
    std::string port;
    NapiUtil::JsValueToString(env, args[INDEX_1], STR_DEFAULT_SIZE, port);
    std::string privateKeyPath;
    NapiUtil::JsValueToString(env, args[INDEX_2], STR_DEFAULT_SIZE, privateKeyPath);
    napi_value callback = args[INDEX_3];
    napi_ref callBackRef;
    napi_create_reference(env, callback, 1, &callBackRef);
    napi_deferred deferred;
    napi_value promise;
    napi_create_promise(env, &deferred, &promise);
    napi_value resourceName;
    napi_create_string_latin1(env, "startSSHClient", NAPI_AUTO_LENGTH, &resourceName);
    SSH2Client *ss2Client = new SSH2Client();
    SSH2Napi *ssh2Napi = nullptr;
    napi_unwrap(env, thisVal, (void **)&ssh2Napi);
    if (!ssh2Napi) {
        return nullptr;
    }
    LOGE("StartSSHClient ip %s port %s privateKeyPath %s ss2Client %p", ip.c_str(), port.c_str(),
         privateKeyPath.c_str(), ss2Client);
    ssh2Napi->_ssh2Client = ss2Client;
    ssh2Napi->_ip = ip;
    ssh2Napi->_port = port;
    ssh2Napi->_privateKeyPath = privateKeyPath;
    ssh2Napi->_ssh2ClientCallBackRef = callBackRef;
    ssh2Napi->_env = env;
    MessageCallback(OnEventListener);
    SSH2ClientContext *ssh2ClientContext = new SSH2ClientContext{.env = env,
                                                                 .asyncWork = nullptr,
                                                                 .deferred = deferred,
                                                                 .ip = ip,
                                                                 .port = port,
                                                                 .privateKeyPath = privateKeyPath,
                                                                 .ssh2Client = ss2Client,
                                                                 .user = ssh2Napi->_user,
                                                                 .pass = ssh2Napi->_pass,
                                                                 .callbackRef = callBackRef,
                                                                 .ssh2Napi = ssh2Napi};
    napi_create_async_work(
        env, nullptr, resourceName,
        [](napi_env env, void *data) {
            SSH2ClientContext *ssh2ClientContext = (SSH2ClientContext *)data;
            ssh2ClientContext->result = ssh2ClientContext->ssh2Client->Start(
                ssh2ClientContext->ip, ssh2ClientContext->port, ssh2ClientContext->privateKeyPath,
                ssh2ClientContext->user, ssh2ClientContext->pass);
            if (ssh2ClientContext->result != NAPI_SUCCESS) {
                g_postEvent(ssh2ClientContext->ssh2Napi, SSH2_START_FAILED);
                return;
            }
            g_postEvent(ssh2ClientContext->ssh2Napi, SSH2_START_SUCCESS);
            while (!ssh2ClientContext->ssh2Client->isStop) {
                sleep(1);
                LOGE("sshclient runing ...");
            }
        },
        [](napi_env env, napi_status status, void *data) {
            SSH2ClientContext *ssh2ClientContext = (SSH2ClientContext *)data;
            napi_value result;
            napi_create_int32(env, ssh2ClientContext->result, &result);
            napi_resolve_deferred(ssh2ClientContext->env, ssh2ClientContext->deferred, result);
            napi_delete_async_work(env, ssh2ClientContext->asyncWork);
            delete ssh2ClientContext;
            ssh2ClientContext = nullptr;
        },
        ssh2ClientContext, &ssh2ClientContext->asyncWork);
    napi_queue_async_work(env, ssh2ClientContext->asyncWork);
    return promise;
}

napi_value SSH2Napi::ExecuteSSHCommand(napi_env env, napi_callback_info info) {
    size_t argc = PARAM_COUNT_2;
    napi_value args[PARAM_COUNT_2] = {nullptr};
    napi_value thisVal = nullptr;
    napi_get_cb_info(env, info, &argc, args, &thisVal, nullptr);
    std::string command;
    NapiUtil::JsValueToString(env, args[INDEX_0], STR_DEFAULT_SIZE, command);
    int time_ms = 0;
    napi_get_value_int32(env, args[INDEX_1], &time_ms);
    napi_deferred deferred;
    napi_value promise;
    napi_create_promise(env, &deferred, &promise);
    napi_value resourceName;
    napi_create_string_latin1(env, "executeSSHCommand", NAPI_AUTO_LENGTH, &resourceName);
    SSH2Napi *ssh2Napi = nullptr;
    napi_unwrap(env, thisVal, (void **)&ssh2Napi);
    if (!ssh2Napi) {
        return nullptr;
    }
    SSH2ClientContext *ssh2ClientContext = new SSH2ClientContext{.env = env,
                                                                 .asyncWork = nullptr,
                                                                 .deferred = deferred,
                                                                 .ip = ssh2Napi->_ip,
                                                                 .port = ssh2Napi->_port,
                                                                 .privateKeyPath = ssh2Napi->_privateKeyPath,
                                                                 .ssh2Client = ssh2Napi->_ssh2Client,
                                                                 .user = ssh2Napi->_user,
                                                                 .pass = ssh2Napi->_pass,
                                                                 .ssh_session = ssh2Napi->_ssh2Client->_ssh_session,
                                                                 .command = command,
                                                                 .time_ms = time_ms};

    napi_create_async_work(
        env, nullptr, resourceName,
        [](napi_env env, void *data) {
            SSH2ClientContext *ssh2ClientContext = (SSH2ClientContext *)data;
            if (!ssh2ClientContext->ssh2Client) {
                LOGE("Error ssh2Client NULL");
                return;
            }
            LOGE("ssh2Client %p user %s ", ssh2ClientContext->ssh2Client, ssh2ClientContext->user.c_str());
            ssh2ClientContext->buffer =
                ssh2ClientContext->ssh2Client->ExecuteSSHCommd(ssh2ClientContext->command, ssh2ClientContext->time_ms);
            // 发送失败重连一次再发
            if (ssh2ClientContext->buffer.length() == 0) {
                int result = ssh2ClientContext->ssh2Client->Start(ssh2ClientContext->ip, ssh2ClientContext->port,
                                                                  ssh2ClientContext->privateKeyPath,
                                                                  ssh2ClientContext->user, ssh2ClientContext->pass);
                if (result == NAPI_SUCCESS) {
                    ssh2ClientContext->buffer = ssh2ClientContext->ssh2Client->ExecuteSSHCommd(
                        ssh2ClientContext->command, ssh2ClientContext->time_ms);
                }
            }
        },
        [](napi_env env, napi_status status, void *data) {
            SSH2ClientContext *ssh2ClientContext = (SSH2ClientContext *)data;
            LOGE("发送命令结束");
            napi_value result = NapiUtil::SetNapiCallString(
                ssh2ClientContext->env, ssh2ClientContext->buffer.length() > 0 ? ssh2ClientContext->buffer : "");
            napi_resolve_deferred(ssh2ClientContext->env, ssh2ClientContext->deferred, result);
            napi_delete_async_work(env, ssh2ClientContext->asyncWork);
        },
        ssh2ClientContext, &ssh2ClientContext->asyncWork);
    napi_queue_async_work(env, ssh2ClientContext->asyncWork);
    return promise;
}

napi_value SSH2Napi::StartSFTPServer(napi_env env, napi_callback_info info) {
    size_t argc = PARAM_COUNT_4;
    napi_value args[PARAM_COUNT_4] = {nullptr};
    napi_value thisVal = nullptr;
    napi_get_cb_info(env, info, &argc, args, &thisVal, nullptr);
    std::string privateKeyPath;
    NapiUtil::JsValueToString(env, args[INDEX_0], STR_DEFAULT_SIZE, privateKeyPath);
    std::string publicKeyPath;
    NapiUtil::JsValueToString(env, args[INDEX_1], STR_DEFAULT_SIZE, publicKeyPath);
    std::string port;
    NapiUtil::JsValueToString(env, args[INDEX_2], STR_DEFAULT_SIZE, port);
    napi_value callback = args[INDEX_3];
    napi_ref callBackRef;
    napi_create_reference(env, callback, 1, &callBackRef);
    SSH2Napi *ssh2Napi = nullptr;
    napi_unwrap(env, thisVal, (void **)&ssh2Napi);
    if (!ssh2Napi) {
        return nullptr;
    }
    ssh2Napi->_sftpServerCallBackRef = callBackRef;
    ssh2Napi->_env = env;
    MessageCallback(OnEventListener);
    // 设置公钥
    SetPublicKeyPath(publicKeyPath);
    napi_deferred deferred;
    napi_value promise;
    napi_create_promise(env, &deferred, &promise);
    napi_value resourceName;
    napi_create_string_latin1(env, "startSFTPServer", NAPI_AUTO_LENGTH, &resourceName);
    SSH2ServerContext *ssh2ServerContext = new SSH2ServerContext{.env = env,
                                                                 .asyncWork = nullptr,
                                                                 .deferred = deferred,
                                                                 .port = port,
                                                                 .privateKeyPath = privateKeyPath,
                                                                 .ssh2Napi = ssh2Napi};
    napi_create_async_work(
        env, nullptr, resourceName,
        [](napi_env env, void *data) {
            SSH2ServerContext *ssh2ServerContext = (SSH2ServerContext *)data;
            ServerCallbacks serverCallBack{.onStartSuccess =
                                               [&ssh2ServerContext]() {
                                                   LOGE("启动Server成功");
                                                   g_postEvent(ssh2ServerContext->ssh2Napi, SFTP_SERVER_START_SUCCESS);
                                               },
                                           .onStartFailed =
                                               [&ssh2ServerContext]() {
                                                   LOGE("启动Server失败");
                                                   g_postEvent(ssh2ServerContext->ssh2Napi, SFTP_SERVER_START_FAILED);
                                               },
                                           .onConnectSuccess =
                                               [&ssh2ServerContext]() {
                                                   LOGE("连接Server成功");
                                                   g_postEvent(ssh2ServerContext->ssh2Napi,
                                                               SFTP_SERVER_CONNECT_SUCCESS);
                                               },
                                           .onConnectFailed =
                                               [&ssh2ServerContext]() {
                                                   LOGE("连接Server失败");
                                                   g_postEvent(ssh2ServerContext->ssh2Napi, SFTP_SERVER_CONNECT_FAILED);
                                               }};
            StartServer(ssh2ServerContext->privateKeyPath, ssh2ServerContext->port, serverCallBack);
        },
        [](napi_env env, napi_status status, void *data) {
            SSH2ServerContext *ssh2ServerContext = (SSH2ServerContext *)data;
            napi_value result;
            napi_create_int32(env, 1, &result);
            napi_resolve_deferred(ssh2ServerContext->env, ssh2ServerContext->deferred, result);
            napi_delete_async_work(env, ssh2ServerContext->asyncWork);
            delete ssh2ServerContext;
            ssh2ServerContext = nullptr;
        },
        ssh2ServerContext, &ssh2ServerContext->asyncWork);
    napi_queue_async_work(env, ssh2ServerContext->asyncWork);
    return promise;
}

napi_value SSH2Napi::Keygen(napi_env env, napi_callback_info info) {
    size_t argc = PARAM_COUNT_3;
    napi_value args[PARAM_COUNT_3] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    std::string privateKeyPath;
    NapiUtil::JsValueToString(env, args[INDEX_0], STR_DEFAULT_SIZE, privateKeyPath);
    std::string publicKeyPath;
    NapiUtil::JsValueToString(env, args[INDEX_1], STR_DEFAULT_SIZE, publicKeyPath);
    std::string type;
    NapiUtil::JsValueToString(env, args[INDEX_2], STR_DEFAULT_SIZE, type);
    int result = Keygen2(privateKeyPath, publicKeyPath, type);
    return NapiUtil::SetNapiCallInt32(env, result);
}

napi_value SSH2Napi::CreateShell(napi_env env, napi_callback_info info) {
    size_t argc = PARAM_COUNT_3;
    napi_value args[PARAM_COUNT_3] = {nullptr};
    napi_value thisVal = nullptr;
    napi_get_cb_info(env, info, &argc, args, &thisVal, nullptr);
    SSH2Napi *ssh2Napi = nullptr;
    napi_unwrap(env, thisVal, (void **)&ssh2Napi);
    if (!ssh2Napi) {
        return NapiUtil::SetNapiCallInt32(env, NAPI_FAILED);
    }
    int result = ssh2Napi->_ssh2Client->CreateShell();
    return NapiUtil::SetNapiCallInt32(env, result);
}

napi_value SSH2Napi::SetUser(napi_env env, napi_callback_info info) {
    size_t argc = PARAM_COUNT_2;
    napi_value args[PARAM_COUNT_2] = {nullptr};
    napi_value thisVal = nullptr;
    napi_get_cb_info(env, info, &argc, args, &thisVal, nullptr);
    std::string user;
    NapiUtil::JsValueToString(env, args[INDEX_0], STR_DEFAULT_SIZE, user);
    std::string pass;
    NapiUtil::JsValueToString(env, args[INDEX_1], STR_DEFAULT_SIZE, pass);
    if (user.empty() || pass.empty()) {
        return NapiUtil::SetNapiCallInt32(env, NAPI_FAILED);
    }
    SSH2Napi *ssh2Napi = nullptr;
    napi_unwrap(env, thisVal, (void **)&ssh2Napi);
    if (!ssh2Napi) {
        return NapiUtil::SetNapiCallInt32(env, NAPI_FAILED);
    }
    if (ssh2Napi) {
        ssh2Napi->_user = user;
        ssh2Napi->_pass = pass;
    }
    SetUserPass(user, pass);
    LOGE("SetUser success user: %s pass: %s", user.c_str(), pass.c_str());
    return NapiUtil::SetNapiCallInt32(env, NAPI_SUCCESS);
}

napi_value SSH2Napi::StopSSHClient(napi_env env, napi_callback_info info) {
    size_t argc = PARAM_COUNT_2;
    napi_value args[PARAM_COUNT_2] = {nullptr};
    napi_value thisVal = nullptr;
    napi_get_cb_info(env, info, &argc, args, &thisVal, nullptr);
    SSH2Napi *ssh2Napi = nullptr;
    napi_unwrap(env, thisVal, (void **)&ssh2Napi);
    if (!ssh2Napi) {
        return NapiUtil::SetNapiCallInt32(env, NAPI_FAILED);
    }
    ssh2Napi->_ssh2Client->Stop();
    LOGE("StopSSHClient ss2client success");
    return NapiUtil::SetNapiCallInt32(env, NAPI_SUCCESS);
}

napi_value SSH2Napi::StopSFTPServer(napi_env env, napi_callback_info info) {
    size_t argc = PARAM_COUNT_2;
    napi_value args[PARAM_COUNT_2] = {nullptr};
    napi_value thisVal = nullptr;
    napi_get_cb_info(env, info, &argc, args, &thisVal, nullptr);
    StopServer();
    LOGE("StopSFTPServer success");
    return NapiUtil::SetNapiCallInt32(env, NAPI_SUCCESS);
}

napi_value SSH2Napi::SetSFTPKeyexChangeCer(napi_env env, napi_callback_info info) {
    size_t argc = PARAM_COUNT_2;
    napi_value args[PARAM_COUNT_2] = {nullptr};
    napi_value thisVal = nullptr;
    napi_get_cb_info(env, info, &argc, args, &thisVal, nullptr);
    std::string param;
    NapiUtil::JsValueToString(env, args[INDEX_0], STR_DEFAULT_SIZE, param);
    SetSFTPKeyexChangeCerOption(param);
    LOGE("SetSFTPKeyexChangeCer %s", param.c_str());
    return NapiUtil::SetNapiCallInt32(env, NAPI_SUCCESS);
}

napi_value SSH2Napi::SetSFTPServerCer(napi_env env, napi_callback_info info) {
    size_t argc = PARAM_COUNT_2;
    napi_value args[PARAM_COUNT_2] = {nullptr};
    napi_value thisVal = nullptr;
    napi_get_cb_info(env, info, &argc, args, &thisVal, nullptr);
    std::string param;
    NapiUtil::JsValueToString(env, args[INDEX_0], STR_DEFAULT_SIZE, param);
    SetSFTPServerCerOption(param);
    LOGE("SetSFTPServerCer %s", param.c_str());
    return NapiUtil::SetNapiCallInt32(env, NAPI_SUCCESS);
}

napi_value SSH2Napi::SetSFTPMessageCer(napi_env env, napi_callback_info info) {
    size_t argc = PARAM_COUNT_2;
    napi_value args[PARAM_COUNT_2] = {nullptr};
    napi_value thisVal = nullptr;
    napi_get_cb_info(env, info, &argc, args, &thisVal, nullptr);
    std::string param;
    NapiUtil::JsValueToString(env, args[INDEX_0], STR_DEFAULT_SIZE, param);
    SetSFTPMessageCerOption(param);
    LOGE("SetSFTPMessageCer %s", param.c_str());
    return NapiUtil::SetNapiCallInt32(env, NAPI_SUCCESS);
}

napi_value SSH2Napi::SftpRequestRead(napi_env env, napi_callback_info info) {
    size_t argc = PARAM_COUNT_4;
    napi_value args[PARAM_COUNT_4] = {nullptr};
    napi_value thisVal = nullptr;
    napi_get_cb_info(env, info, &argc, args, &thisVal, nullptr);
    std::string ip;
    NapiUtil::JsValueToString(env, args[INDEX_0], STR_DEFAULT_SIZE, ip);
    std::string port;
    NapiUtil::JsValueToString(env, args[INDEX_1], STR_DEFAULT_SIZE, port);
    std::string privateKeyPath;
    NapiUtil::JsValueToString(env, args[INDEX_2], STR_DEFAULT_SIZE, privateKeyPath);
    std::string fileDir;
    NapiUtil::JsValueToString(env, args[INDEX_3], STR_DEFAULT_SIZE, fileDir);
    napi_deferred deferred;
    napi_value promise;
    napi_create_promise(env, &deferred, &promise);
    napi_value resourceName;
    napi_create_string_latin1(env, "SftpRequestRead", NAPI_AUTO_LENGTH, &resourceName);
    SSH2Client *ss2Client = new SSH2Client();
    SSH2Napi *ssh2Napi = nullptr;
    napi_unwrap(env, thisVal, (void **)&ssh2Napi);
    if (!ssh2Napi) {
        return nullptr;
    }
    LOGE("StartSSHClient ip %s port %s privateKeyPath %s fileDir %s", ip.c_str(), port.c_str(), privateKeyPath.c_str(),
         fileDir.c_str());
    ssh2Napi->_ssh2Client = ss2Client;
    ssh2Napi->_ip = ip;
    ssh2Napi->_port = port;
    ssh2Napi->_privateKeyPath = privateKeyPath;
    SSH2ClientContext *ssh2ClientContext = new SSH2ClientContext{
        .env = env,
        .asyncWork = nullptr,
        .deferred = deferred,
        .ip = ip,
        .port = port,
        .privateKeyPath = privateKeyPath,
        .ssh2Client = ss2Client,
        .user = ssh2Napi->_user,
        .pass = ssh2Napi->_pass,
        .fileDir = fileDir,
    };
    napi_create_async_work(
        env, nullptr, resourceName,
        [](napi_env env, void *data) {
            SSH2ClientContext *ssh2ClientContext = (SSH2ClientContext *)data;
            ssh2ClientContext->buffer =
                (char *)ssh2ClientContext->ssh2Client
                    ->SftpRequestRead(ssh2ClientContext->ip, ssh2ClientContext->port, ssh2ClientContext->privateKeyPath,
                                      ssh2ClientContext->user, ssh2ClientContext->pass, ssh2ClientContext->fileDir)
                    .c_str();
        },
        [](napi_env env, napi_status status, void *data) {
            SSH2ClientContext *ssh2ClientContext = (SSH2ClientContext *)data;
            napi_value result = NapiUtil::SetNapiCallString(ssh2ClientContext->env,
                                                            ssh2ClientContext->buffer.length() > 0 ? ssh2ClientContext->buffer : "");
            napi_resolve_deferred(ssh2ClientContext->env, ssh2ClientContext->deferred, result);
            napi_delete_async_work(env, ssh2ClientContext->asyncWork);
            delete ssh2ClientContext;
            ssh2ClientContext = nullptr;
        },
        ssh2ClientContext, &ssh2ClientContext->asyncWork);
    napi_queue_async_work(env, ssh2ClientContext->asyncWork);
    return promise;
}

napi_value SSH2Napi::GetPublicKeyFingerprint(napi_env env, napi_callback_info info) {
    size_t argc = PARAM_COUNT_1;
    napi_value args[PARAM_COUNT_1] = {nullptr};
    napi_value thisVal = nullptr;
    napi_get_cb_info(env, info, &argc, args, &thisVal, nullptr);
    std::string publicKeyPath;
    NapiUtil::JsValueToString(env, args[INDEX_0], STR_DEFAULT_SIZE, publicKeyPath);
    napi_deferred deferred;
    napi_value promise;
    napi_create_promise(env, &deferred, &promise);
    napi_value resourceName;
    napi_create_string_latin1(env, "getPublicKeyFingerprint", NAPI_AUTO_LENGTH, &resourceName);
    SSH2Client *ss2Client = new SSH2Client();
    SSH2Napi *ssh2Napi = nullptr;
    napi_unwrap(env, thisVal, (void **)&ssh2Napi);
    if (!ssh2Napi) {
        return nullptr;
    }
    LOGE("GetPublicKeyFingerprint publicKeyPath %s ss2Client %p", publicKeyPath.c_str(), ss2Client);
    SSH2ClientContext *ssh2ClientContext = new SSH2ClientContext{.env = env,
                                                                 .asyncWork = nullptr,
                                                                 .deferred = deferred,
                                                                 .publicKeyPath = publicKeyPath,
                                                                 .ssh2Client = ss2Client,
                                                                };
    napi_create_async_work(
        env, nullptr, resourceName,
        [](napi_env env, void *data) {
            SSH2ClientContext *ssh2ClientContext = (SSH2ClientContext *)data;
            ssh2ClientContext->hashFingerprint = ssh2ClientContext->ssh2Client->GetPublicKeyFingerprint(
                ssh2ClientContext->publicKeyPath);
        },
        [](napi_env env, napi_status status, void *data) {
            SSH2ClientContext *ssh2ClientContext = (SSH2ClientContext *)data;
            napi_value result = NapiUtil::SetNapiCallString(ssh2ClientContext->env,
                                                            ssh2ClientContext->hashFingerprint ? ssh2ClientContext->hashFingerprint : "");
            napi_resolve_deferred(ssh2ClientContext->env, ssh2ClientContext->deferred, result);
            napi_delete_async_work(env, ssh2ClientContext->asyncWork);
            delete ssh2ClientContext;
            ssh2ClientContext = nullptr;
        },
        ssh2ClientContext, &ssh2ClientContext->asyncWork);
    napi_queue_async_work(env, ssh2ClientContext->asyncWork);
    return promise;
}