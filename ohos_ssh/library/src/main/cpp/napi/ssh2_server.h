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

#ifndef SSHAPPLICATION_SSH2_SERVER_H
#define SSHAPPLICATION_SSH2_SERVER_H
#include "libssh/libssh.h"
#include "napi/ssh2_struct.h"
#include <string>

/**
 * 设置用户密码
 * @param user
 * @param password
 */
void SetUserPass(const std::string &user, const std::string &password);

/**
 * 设置公钥
 * @param publicKeyPath
 */
void SetPublicKeyPath(const std::string &publicKeyPath);

/**
 * 处理请求
 * @param event
 * @param session
 */
void HandleSession(ssh_event event, ssh_session session);

/**
 * 用于处理子进程状态变化的信号
 * @param signo
 */
void SigchldHandler(int signo);

/**
 * 启动server
 * @param privateKeyPath
 * @param port
 */
void StartServer(std::string privateKeyPath, std::string port, ServerCallbacks serverCallbacks);

/**
 * 停止服务
 */
void StopServer();

/**
 * 私钥交互算法
 * @param option
 */
void SetSFTPKeyexChangeCerOption(const std::string &option);

/**
 * 服务加密算法
 * @param option
 */
void SetSFTPServerCerOption(const std::string &option);

/**
 * 消息认证算法
 * @param option
 */
void SetSFTPMessageCerOption(const std::string &option);

#endif // SSHAPPLICATION_SSH2_SERVER_H
