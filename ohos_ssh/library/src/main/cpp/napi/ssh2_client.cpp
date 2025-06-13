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

#include "ssh2_client.h"
#include "../utils/log/ohos_log.h"
#include "ssh2_constant.h"
#include "utils/napi/napi_utils.h"
#include <cstddef>
#include <cstring>
#include <libssh/callbacks.h>
#include <libssh/libssh.h>
#include <libssh/server.h>
#include <libssh/sftp.h>
#include <stdio.h>
#include <stdlib.h>
#include <string>

void SSH2Client::SetUser(const std::string &user, const std::string &pass) {
    this->user_ = user;
    this->pass_ = pass;
}

int SSH2Client::Start(std::string ip, std::string port, std::string privateKeyPath, std::string user,
                      std::string pass) {
    ssh_session ssh_session;
    int rc;
    ssh_session = ssh_new();
    this->_ssh_session = ssh_session;
    if (ssh_session == NULL) {
        LOGE("无法创建SSH会话\n");
        return NAPI_FAILED;
    }
    ssh_options_set(ssh_session, SSH_OPTIONS_HOST, ip.c_str());
    LOGE("SSH_OPTIONS_USER %s", user.c_str());
    ssh_options_set(ssh_session, SSH_OPTIONS_USER, user.c_str());
    int _port = NapiUtil::StringToInt(port);
    ssh_options_set(ssh_session, SSH_OPTIONS_PORT, &_port);
    ssh_options_set(ssh_session, SSH_OPTIONS_IDENTITY, privateKeyPath.c_str());
    rc = ssh_connect(ssh_session);
    if (rc != SSH_OK) {
        LOGE("连接错误: %s\n", ssh_get_error(ssh_session));
        ssh_free(ssh_session);
        return NAPI_FAILED;
    }
    ssh_key server_key;
    if (ssh_get_server_publickey(ssh_session, &server_key) != SSH_OK) {
        LOGE("获取服务器公钥失败\n");
        ssh_disconnect(ssh_session);
        ssh_free(ssh_session);
        return NAPI_FAILED;
    }
    unsigned char *hash = NULL;
    size_t hash_len;
    if (ssh_get_publickey_hash(server_key, SSH_PUBLICKEY_HASH_SHA256, &hash, &hash_len) != SSH_OK) {
        LOGE("获取公钥哈希失败\n");
        ssh_key_free(server_key);
        ssh_disconnect(ssh_session);
        ssh_free(ssh_session);
        return NAPI_FAILED;
    }
    ssh_clean_pubkey_hash(&hash);
    ssh_key_free(server_key);
    rc = ssh_userauth_publickey_auto(ssh_session, nullptr, nullptr);
    if (rc != SSH_AUTH_SUCCESS) {
        LOGE("公钥认证失败: %s\n", ssh_get_error(ssh_session));
        rc = ssh_userauth_password(ssh_session, user.c_str(), pass.c_str());
        if (rc != SSH_AUTH_SUCCESS) {
            LOGE("密码认证失败: %s\n", ssh_get_error(ssh_session));
            ssh_disconnect(ssh_session);
            ssh_free(ssh_session);
            return NAPI_FAILED;
        } else {
            LOGE("密码认证成功");
        }
    } else {
        LOGE("客户端收到回调公钥认证成功");
    }
    return NAPI_SUCCESS;
}

int SSH2Client::CreateShell(){
    
    if(!this->_ssh_session){
         LOGE("_ssh_session: 失效。");
        return NAPI_FAILED;
    }
    
    ssh_channel channel = ssh_channel_new(this->_ssh_session);
    if (ssh_channel_open_session(channel) != SSH_OK) {
        LOGE("打开通道失败: %s", ssh_get_error(this->_ssh_session));
        return NAPI_FAILED;
    }

    // 请求 PTY 和 shell
    if (ssh_channel_request_pty_size(channel, "xterm", 80, 24) != SSH_OK ||
        ssh_channel_request_shell(channel) != SSH_OK) {
        LOGE("启动交互式shell失败: %s", ssh_get_error(this->_ssh_session));
        return NAPI_FAILED;
    }

    this->_ssh_channel = channel;
    
    LOGE("CreateShell: 创建 shell 成功,可以开始交互了...");
    
    return NAPI_SUCCESS;
}

std::string SSH2Client::ExecuteSSHCommd(std::string command,int timeout_ms) {
    LOGE("ExecuteSSHCommd timeout_ms: %d", timeout_ms);
    if (!ssh_channel_is_open(this->_ssh_channel)) {
        LOGE("channel 异常或者已经关闭。");
        return "channel 异常或者已经关闭，尝试重新启动。";
    }

    // 添加 \n 表示回车执行
    std::string full_command = command + "\n";
    if (ssh_channel_write(this->_ssh_channel, full_command.c_str(), full_command.size()) != full_command.size()) {
        LOGE("执行命令失败");
        return "执行命令失败";
    }

    LOGE("已发送命令: %s", command.c_str());

    // 读取输出直到看到自定义提示符 CMD_OUTPUT_END
    std::string output;
    if(timeout_ms > 0){
        output = ReadUntilPrompt(timeout_ms);
    } else {
        output = ReadUntilPrompt();
    }
    

    // 去除命令本身和提示符内容
    size_t start_pos = output.find(command);
    if (start_pos != std::string::npos) {
        start_pos += command.length();
        output = output.substr(start_pos, output.length() - 1);
    }
    return output;
}

std::string SSH2Client::ReadUntilPrompt(int timeout_ms) {
    char buffer[1024] = {0};
    std::string output;

    // 循环读取数据直到超时或找到提示符
    while (ssh_channel_is_open(this->_ssh_channel) && !ssh_channel_is_eof(this->_ssh_channel)) {
        usleep(timeout_ms * 1000);
        int nbytes = ssh_channel_read_nonblocking(this->_ssh_channel, buffer, sizeof(buffer), 0);
        
        LOGE("ssh_channel_read_nonblocking: %d", nbytes);

        if (nbytes == SSH_OK) {  // 读完了
            LOGE("读取数据结束");
            break;
        }

        if (nbytes > 0) {  // 没读完
            output.append(buffer, nbytes);
            LOGE("读取数据: %d_%s", output.size(), output.c_str());
        }
        
        memset(buffer, 0, 1024);

        if (nbytes == SSH_AGAIN) {  // 超时/非阻塞模式下也能代表数据已读完
            LOGW("SSH_AGAIN: 读取数据结束");
            break;
        }
        
        if (nbytes == SSH_ERROR) {  // 报错了
            LOGE("SSH_ERROR: 读取通道数据时出现错误: %s", ssh_get_error(this->_ssh_session));
            output = ssh_get_error(this->_ssh_session);
            break;
        }
        
        if (nbytes == SSH_EOF) {  // 超时/非阻塞模式下也能代表数据已读完
            LOGW("SSH_EOF: 读取数据结束");
            break;
        }
    }
    
    if(!ssh_channel_is_open(this->_ssh_channel)){
        LOGW("SSH_EOF: ssh_channel_is_open");
        ssh_channel_free(this->_ssh_channel);
        this->_ssh_channel = NULL;
        
        ssh_disconnect(this->_ssh_session);
        ssh_free(this->_ssh_session);
        this->_ssh_session = NULL;
        this->isStop = true;
    }
    
    return output;
}

std::string SSH2Client::SftpRequestRead(std::string ip, std::string port, std::string privateKeyPath, std::string user,
                                        std::string pass, std::string fileDir) {
    int result = this->Start(ip, port, privateKeyPath, user, pass);
    if (result == NAPI_SUCCESS) {
        sftp_session sftp_session;
        sftp_session = sftp_new(_ssh_session);
        if (sftp_session == NULL) {
            LOGE("创建SFTP会话失败: %s", ssh_get_error(_ssh_session));
            return "";
        }
        int rc = sftp_init(sftp_session);
        if (rc != SSH_OK) {
            LOGE("初始化SFTP失败: %s", ssh_get_error(_ssh_session));
            sftp_free(sftp_session);
            return "";
        }
        if (fileDir.empty()) {
            LOGE("目录地址空");
            return "";
        }
        sftp_dir dir = sftp_opendir(sftp_session, fileDir.c_str());
        std::string readResult = "";
        if (!dir) {
            LOGE("无法打开目录: %s", ssh_get_error(_ssh_session));
        } else {
            sftp_attributes file;
            while ((file = sftp_readdir(sftp_session, dir)) != NULL) {
                LOGE("读取sftp数据:%s", file->name);
                readResult.append(file->name);
                readResult.append(",");
                sftp_attributes_free(file);
            }
            sftp_closedir(dir);
        }
        sftp_free(sftp_session);
        return readResult;
    }
    return "";
}


int SSH2Client::Stop() {
    if(!this->_ssh_channel) {
        ssh_channel_close(this->_ssh_channel);
        ssh_channel_free(this->_ssh_channel);
        this->_ssh_channel = NULL;
    }

    ssh_disconnect(this->_ssh_session);
    ssh_free(this->_ssh_session);
    this->_ssh_session = NULL;
    this->isStop = true;
    return NAPI_SUCCESS;
}

char* SSH2Client::GetPublicKeyFingerprint(std::string publicKeyPath) {
    ssh_key key = NULL;
    unsigned char *hash = NULL;
    size_t hash_len;
    char *sha256 = NULL;
    if (ssh_pki_import_pubkey_file(publicKeyPath.c_str(), &key) != SSH_OK) {
        LOGE("Failed to import public key %s", publicKeyPath.c_str());
        return "";
    }
    if (ssh_get_publickey_hash(key, SSH_PUBLICKEY_HASH_SHA256, &hash, &hash_len) != SSH_OK) {
        LOGE("获取公钥哈希失败");
        ssh_key_free(key);
        return "";
    }
    sha256 = ssh_get_fingerprint_hash(SSH_PUBLICKEY_HASH_SHA256,
                                      (unsigned char *)hash,
                                      hash_len);
    LOGE("服务器公钥指纹: %s", sha256);
    ssh_clean_pubkey_hash(&hash);
    ssh_key_free(key);
    return sha256;
}



