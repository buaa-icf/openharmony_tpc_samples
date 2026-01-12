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

#include "ssh2_server.h"
#include "napi/native_api.h"
#include "napi/ssh2_struct.h"
#include "ssh2_constant.h"
#include "utils/log/ohos_log.h"
#include <cstring>
#include <iostream>
#include <libssh/callbacks.h>
#include <libssh/libssh.h>
#include <libssh/server.h>
#include <libssh/sftp.h>
#include <libssh/sftpserver.h>
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <sys/stat.h>
#include <sys/wait.h>
#include <thread>

// 认证公钥
char authorizedkeys[DEF_STR_SIZE] = {0};
// 是否停止server
bool isStopServer = false;
// 消息认证
std::string OPTIONS_HMAC_C_S;
// 私钥交互
std::string OPTIONS_KEY_EXCHANGE;
// 服务加密
std::string OPTIONS_CIPHERS_C_S;
// 存储用户和密码
std::unordered_map<std::string, std::string> g_usersMap;
// 绑定端口
ssh_bind sshbind;
// 连接会话
ssh_session session;
struct channel_data_struct {
    ssh_event event;
    sftp_session sftp;
};

struct session_data_struct {
    ssh_channel channel;
    int auth_attempts;
    int authenticated;
};

bool FindUserComparison(const std::string &username, std::string &password) {
    auto it = g_usersMap.find(username);
    std::string findPassword;
    if (it != g_usersMap.end()) {
        findPassword = it->second;
    }
    return findPassword == password;
}

static int AuthPassword(ssh_session session, const char *user, const char *pass, void *userdata) {
    struct session_data_struct *sdata = (struct session_data_struct *)userdata;
    (void)session;
    std::string userStr = user;
    std::string passStr = pass;
    if (FindUserComparison(userStr, passStr)) {
        sdata->authenticated = 1;
        LOGD("密码认证成功");
        return SSH_AUTH_SUCCESS;
    }
    sdata->auth_attempts++;
    return SSH_AUTH_DENIED;
}

static int AuthPublicKey(ssh_session session, const char *user, struct ssh_key_struct *pubkey, char signature_state,
                         void *userdata) {
    struct session_data_struct *sdata = (struct session_data_struct *)userdata;
    (void)session;
    (void)user;
    if (signature_state == SSH_PUBLICKEY_STATE_NONE) {
        return SSH_AUTH_SUCCESS;
    }
    if (signature_state != SSH_PUBLICKEY_STATE_VALID) {
        return SSH_AUTH_DENIED;
    }
    if (authorizedkeys[0]) {
        ssh_key key = NULL;
        struct stat buf;
        if (stat(authorizedkeys, &buf) == 0) {
            int result;
            result = ssh_pki_import_pubkey_file(authorizedkeys, &key);
            if ((result != SSH_OK) || (key == NULL)) {
                LOGE("Unable to import public key file");
            } else {
                result = ssh_key_cmp(key, pubkey, SSH_KEY_CMP_PUBLIC);
                ssh_key_free(key);
                if (result == 0) {
                    sdata->authenticated = 1;
                    LOGD("公钥认证成功");
                    return SSH_AUTH_SUCCESS;
                }
            }
        }
    }
    sdata->authenticated = 0;
    return SSH_AUTH_DENIED;
}

static ssh_channel ChannelOpen(ssh_session session, void *userdata) {
    struct session_data_struct *sdata = (struct session_data_struct *)userdata;
    sdata->channel = ssh_channel_new(session);
    return sdata->channel;
}

void HandleSession(ssh_event event, ssh_session session) {
    int n;
    struct channel_data_struct cdata = {
        .sftp = NULL,
    };
    struct session_data_struct sdata = {
        .channel = NULL,
        .auth_attempts = 0,
        .authenticated = 0,
    };
    struct ssh_channel_callbacks_struct channel_cb = {
        .userdata = &(cdata.sftp),
        .channel_data_function = sftp_channel_default_data_callback,
        .channel_subsystem_request_function = sftp_channel_default_subsystem_request,
    };
    struct ssh_server_callbacks_struct server_cb = {
        .userdata = &sdata,
        .auth_password_function = AuthPassword,
        .channel_open_request_session_function = ChannelOpen,
    };
    if (authorizedkeys[0]) {
        server_cb.auth_pubkey_function = AuthPublicKey;
        ssh_set_auth_methods(session, SSH_AUTH_METHOD_PASSWORD | SSH_AUTH_METHOD_PUBLICKEY);
    } else
        ssh_set_auth_methods(session, SSH_AUTH_METHOD_PASSWORD);
    ssh_callbacks_init(&server_cb);
    ssh_callbacks_init(&channel_cb);
    ssh_set_server_callbacks(session, &server_cb);

    if (ssh_handle_key_exchange(session) != SSH_OK) {
        return;
    }
    ssh_event_add_session(event, session);
    n = 0;
    while (sdata.authenticated == 0 || sdata.channel == NULL) {
        if (sdata.auth_attempts >= 3 || n >= 100) {
            return;
        }
        if (ssh_event_dopoll(event, 100) == SSH_ERROR) {
            return;
        }
        n++;
    }

    ssh_set_channel_callbacks(sdata.channel, &channel_cb);
    do {
        if (ssh_event_dopoll(event, -1) == SSH_ERROR) {
            ssh_channel_close(sdata.channel);
        }
        if (cdata.event != NULL) {
            continue;
        }
    } while (ssh_channel_is_open(sdata.channel));

    ssh_channel_send_eof(sdata.channel);
    ssh_channel_close(sdata.channel);
    for (n = 0; n < 50 && (ssh_get_status(session) & SESSION_END) == 0; n++) {
        ssh_event_dopoll(event, 100);
    }
}

void SigchldHandler(int signo) {
    (void)signo;
    while (waitpid(-1, NULL, WNOHANG) > 0)
        ;
}

void SetUserPass(const std::string &user, const std::string &password) { g_usersMap[user] = password; }

void SetPublicKeyPath(const std::string &publicKeyPath) {
    if (publicKeyPath.empty()) {
        authorizedkeys[0] = '\0';
        return;
    }
    if (publicKeyPath.length() >= STR_DEFAULT_SIZE) {
        return;
    }
    std::strcpy(authorizedkeys, publicKeyPath.c_str());
}

void StartServer(std::string privateKeyPath, std::string port, ServerCallbacks serverCallbacks) {
    isStopServer = false;
    if (privateKeyPath.empty() || port.empty()) {
        serverCallbacks.onStartFailed();
        return;
    }
    sshbind = ssh_bind_new();
    ssh_bind_options_set(sshbind, SSH_BIND_OPTIONS_HOSTKEY, privateKeyPath.c_str());
    ssh_bind_options_set(sshbind, SSH_BIND_OPTIONS_BINDPORT_STR, port.c_str());
    struct sigaction sa;
    sa.sa_handler = SigchldHandler;
    sigemptyset(&sa.sa_mask);
    sa.sa_flags = SA_RESTART | SA_NOCLDSTOP;
    if (ssh_bind_listen(sshbind) < 0) {
        LOGE("监听失败: %s", ssh_get_error(sshbind));
        serverCallbacks.onStartFailed();
        return;
    }
    serverCallbacks.onStartSuccess();
    while (!isStopServer) {
        session = ssh_new();
        if (!OPTIONS_CIPHERS_C_S.empty()) {
            ssh_options_set(session, SSH_OPTIONS_CIPHERS_C_S, OPTIONS_CIPHERS_C_S.c_str());
        }
        if (!OPTIONS_HMAC_C_S.empty()) {
            ssh_options_set(session, SSH_OPTIONS_HMAC_C_S, OPTIONS_HMAC_C_S.c_str());
        }
        if (!OPTIONS_KEY_EXCHANGE.empty()) {
            ssh_options_set(session, SSH_OPTIONS_KEY_EXCHANGE, OPTIONS_KEY_EXCHANGE.c_str());
        }
        if (ssh_bind_accept(sshbind, session) != SSH_OK) {
            serverCallbacks.onConnectFailed();
            ssh_free(session);
            continue;
        }
        auto task = [](const ssh_session &session, const ServerCallbacks &serverCallbacks) {
            serverCallbacks.onConnectSuccess();
            ssh_event event = ssh_event_new();
            HandleSession(event, session);
        };
        std::thread t(task, session, serverCallbacks);
        t.detach();
    }
}

void StopServer() {
    isStopServer = true;
    if (sshbind && session) {
        ssh_bind_free(sshbind);
        ssh_disconnect(session);
    }
}

void SetSFTPKeyexChangeCerOption(const std::string &option) { OPTIONS_KEY_EXCHANGE = option; }

void SetSFTPServerCerOption(const std::string &option) { OPTIONS_CIPHERS_C_S = option; }

void SetSFTPMessageCerOption(const std::string &option) { OPTIONS_HMAC_C_S = option; }