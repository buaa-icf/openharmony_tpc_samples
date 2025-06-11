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

#ifndef SSHAPPLICATION_SSH2_NAPI_H
#define SSHAPPLICATION_SSH2_NAPI_H
#include "napi/ssh2_client.h"
#include <napi/native_api.h>
#include <string>

class SSH2Napi {



public:
    SSH2Napi() : _user(nullptr),_pass(nullptr),_ssh2Client(NULL),_ip(nullptr),_port(nullptr),_privateKeyPath(nullptr){}
    ~SSH2Napi() {}
    static napi_value ClassConstructor(napi_env env, napi_callback_info info);
    static napi_value StartSSHClient(napi_env env, napi_callback_info info);
    static napi_value StartSFTPServer(napi_env env, napi_callback_info info);
    static napi_value Keygen(napi_env env, napi_callback_info info);
    static napi_value CreateShell(napi_env env, napi_callback_info info);
    static napi_value SetUser(napi_env env, napi_callback_info info);
    static napi_value ExecuteSSHCommand(napi_env env, napi_callback_info info);
    static napi_value StopSSHClient(napi_env env, napi_callback_info info);
    static napi_value StopSFTPServer(napi_env env, napi_callback_info info);
    static napi_value SetSFTPKeyexChangeCer(napi_env env, napi_callback_info info);
    static napi_value SetSFTPServerCer(napi_env env, napi_callback_info info);
    static napi_value SetSFTPMessageCer(napi_env env, napi_callback_info info);
    static napi_value SftpRequestRead(napi_env env, napi_callback_info info);
    static napi_value GetPublicKeyFingerprint(napi_env env, napi_callback_info info);

public:
    napi_env _env;
    napi_ref _ssh2ClientCallBackRef;
    napi_ref _sftpServerCallBackRef;

private:
    std::string _user;
    std::string _pass;
    SSH2Client *_ssh2Client;
    std::string _ip;
    std::string _port;
    std::string _privateKeyPath;
};

#endif // SSHAPPLICATION_SSH2_NAPI_H
