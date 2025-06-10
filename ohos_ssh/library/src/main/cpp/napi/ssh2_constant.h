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

#ifndef SSHAPPLICATION_SSH2_CONSTANT_H
const int NUM_1 = 1;
const int NUM_2 = 2;
const int NUM_3 = 3;
const int NUM_5 = 5;
const int STR_DEFAULT_SIZE = 2048;
const int INDEX_0 = 0;
const int INDEX_1 = 1;
const int INDEX_2 = 2;
const int INDEX_3 = 3;
const int INDEX_4 = 4;
const int INDEX_5 = 5;
const int INDEX_6 = 6;
const int INDEX_7 = 7;
const int PARAM_COUNT_0 = 0;
const int PARAM_COUNT_1 = 1;
const int PARAM_COUNT_2 = 2;
const int PARAM_COUNT_3 = 3;
const int PARAM_COUNT_4 = 4;
const int PARAM_COUNT_5 = 5;
const int PARAM_COUNT_6 = 6;
const int PARAM_COUNT_7 = 7;
const int PARAM_COUNT_8 = 8;
const int DEF_STR_SIZE =  1024;
#define SESSION_END (SSH_CLOSED | SSH_CLOSED_ERROR)
//密钥生成成功
#define KEY_GEN_SUCCESS 0
//密钥生成失败
#define KEY_GEN_FAILED 1
//NAPI接口返回成功
#define NAPI_SUCCESS 0
//NAPI接口返回失败
#define NAPI_FAILED 1
//sshclient启动成功
#define SSH2_START_SUCCESS 0
//sshclient启动失败
#define SSH2_START_FAILED 1
//sftpserver启动成功
#define SFTP_SERVER_START_SUCCESS 2
//sftpserver启动失败
#define SFTP_SERVER_START_FAILED 3
//sftpserver连接客户端成功
#define SFTP_SERVER_CONNECT_SUCCESS 4
//sftpserver连接客户端失败
#define SFTP_SERVER_CONNECT_FAILED 5

#define SSHAPPLICATION_SSH2_CONSTANT_H

#endif //SSHAPPLICATION_SSH2_CONSTANT_H
