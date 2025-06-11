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

export declare class SSH2Napi {
  createShell: () => number;
  keygen: (privateKeyPath: string, publicKeyPath: string, type: string) => number;
  setUser: (username: string, userpass: string) => number;
  startSFTPServer: (privateKeyPath: string, publicKeyPath: string, port: string, callback: Function) => void;
  startSSHClient: (ip: string, port: string, privateKeyPath: string, callback: Function) => Promise<number>;
  executeSSHCommand: (command: string, time_ms?: number) => Promise<string>;
  stopSSHClient: () => number;
  stopSFTPServer: () => number;
  setSFTPKeyexChangeCer: (cer: string) => number;
  setSFTPServerCer: (cer: string) => number;
  setSFTPMessageCer: (cer: string) => number;
  sftpRequestRead: (ip: string, port: string, privateKeyPath: string, fileDir: string) => Promise<string>;
  getPublicKeyFingerprint: (publicKeyPath: string) => Promise<string>;
}