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

#ifndef SSHAPPLICATION_SSH2_CLIENT_H
#define SSHAPPLICATION_SSH2_CLIENT_H
#include "libssh/libssh.h"
#include <string>


class SSH2Client {

public:
    SSH2Client() {}

    void SetUser(const std::string &user, const std::string &pass);

    int Start(std::string ip, std::string port, std::string privateKeyPath, std::string user, std::string pass);

    std::string ExecuteSSHCommd(std::string command, int timeout_ms);
    std::string ReadUntilPrompt(int timeout_ms = 500);
    
    int CreateShell();

    int Stop();

    std::string SftpRequestRead(std::string ip, std::string port, std::string privateKeyPath, std::string user,
                                std::string pass, std::string fileDir);

    char* GetPublicKeyFingerprint(std::string publicKeyPath);

public:
    ssh_session _ssh_session;
    ssh_channel _ssh_channel;
    bool isStop{false};

private:
    std::string user_;
    std::string pass_;
};

#endif // SSHAPPLICATION_SSH2_CLIENT_H
