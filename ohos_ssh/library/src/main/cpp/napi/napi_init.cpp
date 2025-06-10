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

#include "napi/native_api.h"
#include "ssh2_napi.h"


EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports) {
    napi_property_descriptor desc[] = {
        {"createShell", nullptr, SSH2Napi::CreateShell, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"keygen", nullptr, SSH2Napi::Keygen, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setUser", nullptr, SSH2Napi::SetUser, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"startSFTPServer", nullptr, SSH2Napi::StartSFTPServer, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"startSSHClient", nullptr, SSH2Napi::StartSSHClient, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"executeSSHCommand", nullptr, SSH2Napi::ExecuteSSHCommand, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"stopSSHClient", nullptr, SSH2Napi::StopSSHClient, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"stopSFTPServer", nullptr, SSH2Napi::StopSFTPServer, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setSFTPKeyexChangeCer", nullptr, SSH2Napi::SetSFTPKeyexChangeCer, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setSFTPServerCer", nullptr, SSH2Napi::SetSFTPServerCer, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setSFTPMessageCer", nullptr, SSH2Napi::SetSFTPMessageCer, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"sftpRequestRead", nullptr, SSH2Napi::SftpRequestRead, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getPublicKeyFingerprint", nullptr, SSH2Napi::GetPublicKeyFingerprint, nullptr, nullptr, nullptr, napi_default, nullptr},
    };
     napi_value ssh2Napi = nullptr;
    const char *classBindName = "SSH2Napi";
    int methodSize = std::end(desc) - std::begin(desc);
    napi_define_class(env, classBindName, strlen(classBindName), SSH2Napi::ClassConstructor, nullptr, methodSize, desc,
                      &ssh2Napi);
    napi_set_named_property(env, exports, "SSH2Napi", ssh2Napi);
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}
EXTERN_C_END

static napi_module demoModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "ssh_ohos_napi",
    .nm_priv = ((void *)0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void) { napi_module_register(&demoModule); }
