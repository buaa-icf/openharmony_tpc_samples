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

import { SSH2Napi } from 'libssh_ohos_napi.so';

export class libssh {
  private ssh2Napi: SSH2Napi;

  constructor() {
    this.ssh2Napi = new SSH2Napi();
  }

  setUser(username: string, userpass: string): number {
    return this.ssh2Napi.setUser(username, userpass);
  }

  createShell(): number {
    return this.ssh2Napi.createShell();
  }

  setSFTPKeyexChangeCer(cer: string): number {
    return this.ssh2Napi.setSFTPKeyexChangeCer(cer);
  }

  setSFTPServerCer(cer: string): number {
    return this.ssh2Napi.setSFTPServerCer(cer);
  }

  setSFTPMessageCer(cer: string): number {
    return this.ssh2Napi.setSFTPMessageCer(cer);
  }

  startSFTPServer(privateKeyPath: string, publicKeyPath: string, port: number, callback: Function): void {
    return this.ssh2Napi.startSFTPServer(privateKeyPath, publicKeyPath, port + "", callback);
  }

  startSSHClient(ip: string, port: number, privateKeyPath: string, callback: Function): Promise<number> {
    return this.ssh2Napi.startSSHClient(ip, port + "", privateKeyPath, callback);
  }

  keygen(privateKeyPath: string, publicKeyPath: string, type: SSH_KEYTYPES): number {
    return this.ssh2Napi.keygen(privateKeyPath, publicKeyPath, this.keyTypeToString(type));
  }

  executeSSHComm(command: string, time_ms?: number): Promise<string> {
    return this.ssh2Napi.executeSSHCommand(command, time_ms);
  }

  sftpRequestRead(ip: string, port: number, privateKeyPath: string, fileDir: string): Promise<string> {
    return this.ssh2Napi.sftpRequestRead(ip, port + "", privateKeyPath, fileDir);
  }

  stopSFTPServer(): number {
    return this.ssh2Napi.stopSFTPServer();
  }

  stopSSHClient(): number {
    return this.ssh2Napi.stopSSHClient();
  }

  getPublicKeyFingerprint(publicKeyPath: string): Promise<string> {
    return this.ssh2Napi.getPublicKeyFingerprint(publicKeyPath);
  }

  keyTypeToString(type: SSH_KEYTYPES): string {
    switch (type) {
      case SSH_KEYTYPES.SSH_KEYTYPE_UNKNOWN:
        return "SSH_KEYTYPE_UNKNOWN";
      case SSH_KEYTYPES.SSH_KEYTYPE_DSS:
        return "SSH_KEYTYPE_DSS"; // deprecated
      case SSH_KEYTYPES.SSH_KEYTYPE_RSA:
        return "SSH_KEYTYPE_RSA";
      case SSH_KEYTYPES.SSH_KEYTYPE_RSA1:
        return "SSH_KEYTYPE_RSA1";
      case SSH_KEYTYPES.SSH_KEYTYPE_ECDSA:
        return "SSH_KEYTYPE_ECDSA"; // deprecated
      case SSH_KEYTYPES.SSH_KEYTYPE_ED25519:
        return "SSH_KEYTYPE_ED25519";
      case SSH_KEYTYPES.SSH_KEYTYPE_DSS_CERT01:
        return "SSH_KEYTYPE_DSS_CERT01"; // deprecated
      case SSH_KEYTYPES.SSH_KEYTYPE_RSA_CERT01:
        return "SSH_KEYTYPE_RSA_CERT01";
      case SSH_KEYTYPES.SSH_KEYTYPE_ECDSA_P256:
        return "SSH_KEYTYPE_ECDSA_P256";
      case SSH_KEYTYPES.SSH_KEYTYPE_ECDSA_P384:
        return "SSH_KEYTYPE_ECDSA_P384";
      case SSH_KEYTYPES.SSH_KEYTYPE_ECDSA_P521:
        return "SSH_KEYTYPE_ECDSA_P521";
      case SSH_KEYTYPES.SSH_KEYTYPE_ECDSA_P256_CERT01:
        return "SSH_KEYTYPE_ECDSA_P256_CERT01";
      case SSH_KEYTYPES.SSH_KEYTYPE_ECDSA_P384_CERT01:
        return "SSH_KEYTYPE_ECDSA_P384_CERT01";
      case SSH_KEYTYPES.SSH_KEYTYPE_ECDSA_P521_CERT01:
        return "SSH_KEYTYPE_ECDSA_P521_CERT01";
      case SSH_KEYTYPES.SSH_KEYTYPE_ED25519_CERT01:
        return "SSH_KEYTYPE_ED25519_CERT01";
      case SSH_KEYTYPES.SSH_KEYTYPE_SK_ECDSA:
        return "SSH_KEYTYPE_SK_ECDSA";
      case SSH_KEYTYPES.SSH_KEYTYPE_SK_ECDSA_CERT01:
        return "SSH_KEYTYPE_SK_ECDSA_CERT01";
      case SSH_KEYTYPES.SSH_KEYTYPE_SK_ED25519:
        return "SSH_KEYTYPE_SK_ED25519";
      case SSH_KEYTYPES.SSH_KEYTYPE_SK_ED25519_CERT01:
        return "SSH_KEYTYPE_SK_ED25519_CERT01";
      default:
        return "SSH_KEYTYPE_UNKNOWN";
    }
  }
}

export enum SSH_KEYTYPES {
  SSH_KEYTYPE_UNKNOWN = 0,
  SSH_KEYTYPE_DSS = 1, /* deprecated */
  SSH_KEYTYPE_RSA,
  SSH_KEYTYPE_RSA1,
  SSH_KEYTYPE_ECDSA, /* deprecated */
  SSH_KEYTYPE_ED25519,
  SSH_KEYTYPE_DSS_CERT01, /* deprecated */
  SSH_KEYTYPE_RSA_CERT01,
  SSH_KEYTYPE_ECDSA_P256,
  SSH_KEYTYPE_ECDSA_P384,
  SSH_KEYTYPE_ECDSA_P521,
  SSH_KEYTYPE_ECDSA_P256_CERT01,
  SSH_KEYTYPE_ECDSA_P384_CERT01,
  SSH_KEYTYPE_ECDSA_P521_CERT01,
  SSH_KEYTYPE_ED25519_CERT01,
  SSH_KEYTYPE_SK_ECDSA,
  SSH_KEYTYPE_SK_ECDSA_CERT01,
  SSH_KEYTYPE_SK_ED25519,
  SSH_KEYTYPE_SK_ED25519_CERT01,
}

