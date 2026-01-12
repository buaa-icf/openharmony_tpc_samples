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

#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <string>
#include <sys/stat.h>

#include "keygen2.h"
#include "libssh/callbacks.h"
#include "napi/ssh2_constant.h"
#include "utils/log/ohos_log.h"

struct arguments_st {
    enum ssh_keytypes_e type;
    unsigned long bits;
    char *file;
    char *passphrase;
    char *format;
    int action_list;
};

static int ValidateArgs(struct arguments_st *args) {
    int rc = 0;
    if (args == NULL) {
        return EINVAL;
    }
    if (args->action_list) {
        return 0;
    }
    switch (args->type) {
    case SSH_KEYTYPE_RSA:
        switch (args->bits) {
        case 0:
            args->bits = 3072;
            break;
        case 1024:
        case 2048:
        case 3072:
        case 4096:
        case 8192:
            break;
        default:
            LOGE("Error: Invalid bits parameter provided\n");
            rc = EINVAL;
            break;
        }
        if (args->file == NULL) {
            args->file = strdup("id_rsa");
            if (args->file == NULL) {
                rc = ENOMEM;
                break;
            }
        }

        break;
    case SSH_KEYTYPE_ECDSA:
        switch (args->bits) {
        case 0:
            args->bits = 256;
            break;
        case 256:
        case 384:
        case 521:
            break;
        default:
            LOGE("Error: Invalid bits parameter provided\n");
            rc = EINVAL;
            break;
        }
        if (args->file == NULL) {
            args->file = strdup("id_ecdsa");
            if (args->file == NULL) {
                rc = ENOMEM;
                break;
            }
        }

        break;
    case SSH_KEYTYPE_ED25519:
        args->bits = 0;
        if (args->file == NULL) {
            args->file = strdup("id_ed25519");
            if (args->file == NULL) {
                rc = ENOMEM;
                break;
            }
        }
        break;
    default:
        LOGE("Error: unknown key type\n");
        rc = EINVAL;
        break;
    }
    return rc;
}

ssh_keytypes_e KeyTypeStringToSSHKeyType(const std::string &keyType) {
    static const char *keyTypeStrings[] = {"SSH_KEYTYPE_UNKNOWN",
                                           "SSH_KEYTYPE_DSS",
                                           "SSH_KEYTYPE_RSA",
                                           "SSH_KEYTYPE_RSA1",
                                           "SSH_KEYTYPE_ECDSA",
                                           "SSH_KEYTYPE_ED25519",
                                           "SSH_KEYTYPE_DSS_CERT01",
                                           "SSH_KEYTYPE_RSA_CERT01",
                                           "SSH_KEYTYPE_ECDSA_P256",
                                           "SSH_KEYTYPE_ECDSA_P384",
                                           "SSH_KEYTYPE_ECDSA_P521",
                                           "SSH_KEYTYPE_ECDSA_P256_CERT01",
                                           "SSH_KEYTYPE_ECDSA_P384_CERT01",
                                           "SSH_KEYTYPE_ECDSA_P521_CERT01",
                                           "SSH_KEYTYPE_ED25519_CERT01",
                                           "SSH_KEYTYPE_SK_ECDSA",
                                           "SSH_KEYTYPE_SK_ECDSA_CERT01",
                                           "SSH_KEYTYPE_SK_ED25519",
                                           "SSH_KEYTYPE_SK_ED25519_CERT01"};
    for (size_t i = 0; i < (sizeof(keyTypeStrings) / sizeof(keyTypeStrings[0])); ++i) {
        if (keyType == keyTypeStrings[i]) {
            return static_cast<ssh_keytypes_e>(i);
        }
    }
    return SSH_KEYTYPE_UNKNOWN;
}

int Keygen2(const std::string &privateKeyPath, const std::string &publicKeyPath, const std::string &keyType) {
    ssh_key key = NULL;
    int rc = 0;
    struct arguments_st arguments = {
        .type = SSH_KEYTYPE_UNKNOWN,
        .bits = 0, //新加长度
        .file = NULL,
        .passphrase = NULL,
        .action_list = 0,
        .format = "DEFAULT"
    };     
    arguments.type = KeyTypeStringToSSHKeyType(keyType);
    if(arguments.type == SSH_KEYTYPE_RSA) {
        arguments.bits = 4096; //TODO 暂时先固定
    }
    rc = ValidateArgs(&arguments);
    if (rc != 0) {
        return KEY_GEN_FAILED;
    }
    errno = 0;
    if (privateKeyPath.empty()) {
        return KEY_GEN_FAILED;
    }
    arguments.file = (char *)privateKeyPath.c_str();

    rc = open(arguments.file, O_CREAT | O_EXCL | O_WRONLY, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
    if (rc < 0) {
        if (errno == EEXIST) {
            rc = open(arguments.file, O_WRONLY);
            if (rc > 0) {
                close(rc);
                errno = 0;
                rc = chmod(arguments.file, S_IRUSR | S_IWUSR);
                if (rc != 0) {
                    LOGE("Error(%d): Could not set file permissions\n", errno);
                    return KEY_GEN_FAILED;
                }
            } else {
                LOGE("Error: Could not create private key file\n");
                return KEY_GEN_FAILED;
            }
        } else {
            LOGE("Error opening \"%s\" file\n", arguments.file);
            return KEY_GEN_FAILED;
        }
    } else {
        close(rc);
    }

    /* Generate a new private key */
    rc = ssh_pki_generate(arguments.type, arguments.bits, &key);
    if (rc != SSH_OK) {
        LOGE("Error: Failed to generate keys");
        return KEY_GEN_FAILED;
    }

    /* Write the private key */
    if (arguments.format != NULL) {
        if (strcasecmp(arguments.format, "PEM") == 0) {
            rc = ssh_pki_export_privkey_file_format(key, arguments.passphrase, NULL, NULL, arguments.file,
                                                    SSH_FILE_FORMAT_PEM);
        } else if (strcasecmp(arguments.format, "OpenSSH") == 0) {
            rc = ssh_pki_export_privkey_file_format(key, arguments.passphrase, NULL, NULL, arguments.file,
                                                    SSH_FILE_FORMAT_OPENSSH);
        } else {
            rc = ssh_pki_export_privkey_file_format(key, arguments.passphrase, NULL, NULL, arguments.file,
                                                    SSH_FILE_FORMAT_DEFAULT);
        }
    } else {
        rc = ssh_pki_export_privkey_file(key, arguments.passphrase, NULL, NULL, arguments.file);
    }
    if (rc != SSH_OK) {
        LOGE("Error: Failed to write private key file");
        return KEY_GEN_FAILED;
    }
    if (publicKeyPath.empty()) {
        return KEY_GEN_FAILED;
    }
    errno = 0;
    rc = open(publicKeyPath.c_str(), O_CREAT | O_EXCL | O_WRONLY, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
    if (rc < 0) {
        if (errno == EEXIST) {
            rc = open(publicKeyPath.c_str(), O_WRONLY);
            if (rc > 0) {
                close(rc);
                errno = 0;
                rc = chmod(publicKeyPath.c_str(), S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
                if (rc != 0) {
                    LOGE("Error(%d): Could not set file permissions\n", errno);
                    return KEY_GEN_FAILED;
                }
            } else {
                LOGE("Error: Could not create public key file\n");
                return KEY_GEN_FAILED;
            }
        } else {
            LOGE("Error opening \"%s\" file\n", publicKeyPath.c_str());
            return KEY_GEN_FAILED;
        }
    } else {
        close(rc);
    }
    rc = ssh_pki_export_pubkey_file(key, publicKeyPath.c_str());
    if (rc != SSH_OK) {
        LOGE("Error: Failed to write public key file");
        return KEY_GEN_FAILED;
    }
    return KEY_GEN_SUCCESS;
}
