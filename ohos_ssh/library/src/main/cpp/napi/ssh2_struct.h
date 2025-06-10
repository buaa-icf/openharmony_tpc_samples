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

#ifndef SSHAPPLICATION_SSH2_STRUCT_H
#define SSHAPPLICATION_SSH2_STRUCT_H
#include "napi/native_api.h"
#include "napi/ssh2_client.h"
#include "napi/ssh2_napi.h"
#include <node_api_types.h>
#include <string>
struct SSH2ClientContext {
    napi_env env;
    napi_async_work asyncWork;
    napi_deferred deferred;
    std::string ip;
    std::string port;
    std::string privateKeyPath;
    std::string publicKeyPath;
    SSH2Client *ssh2Client;
    std::string user;
    std::string pass;
    std::string fileDir;
    int result;
    std::string command;
    int time_ms;
    std::string buffer;
    char* hashFingerprint;
    ssh_session ssh_session;
    napi_ref callbackRef;
    SSH2Napi *ssh2Napi;
};

struct SSH2ServerContext {
    napi_env env;
    napi_async_work asyncWork;
    napi_deferred deferred;
    std::string port;
    std::string privateKeyPath;
    std::string publicKeyPath;
    int result;
    SSH2Napi *ssh2Napi;
};

struct ServerCallbacks {
    std::function<void()> onStartSuccess;
    std::function<void()> onStartFailed;
    std::function<void()> onConnectSuccess;
    std::function<void()> onConnectFailed;
};

struct CallJsContext {
    int type;
    napi_env env;
    napi_async_work asyncWork;
    napi_deferred deferred;
    napi_ref callbackRef;
};

#endif // SSHAPPLICATION_SSH2_STRUCT_H
