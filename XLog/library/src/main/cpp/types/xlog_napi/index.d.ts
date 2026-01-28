/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

export interface XLoggerInfo {
  level: number;
  tag: string;
  filename: string;
  funcname: string;
  line: number;
  pid: number;
  tid: number;
  maintid: number;
}

export interface XLogConfig {
  level?: number; // = Xlog.LEVEL_INFO;
  mode?: number;
  logdir?: string;
  nameprefix?: string;
  pubkey?: string;
  compressmode?: number;
  compresslevel?: number;
  cachedir?: string;
  cachedays?: number;
}

export const native_logWrite: (logInfo: XLoggerInfo, log: string) => boolean;
export const native_logWrite2: (logInstancePtr: number, xinfo: XLoggerInfo, log: string) => boolean;
export const native_setLogLevel: (logInstancePtr: number, level: number) => boolean;
export const native_getLogLevel: (logInstancePtr: number) => number;
export const native_setAppenderMode: (logInstancePtr: number, mode: number) => boolean;
export const native_getXlogInstance: (nameprefix: string) => number;
export const native_releaseXlogInstance: (nameprefix: string) => boolean;
export const native_newXlogInstance: (logConfig: XLogConfig) => number;
export const native_setConsoleLogOpen: (logInstancePtr: number, isOpen: boolean) => boolean;
export const native_appenderOpen: (logConfig: XLogConfig) => boolean;
export const native_appenderClose: () => void;
export const native_setMaxFileSize: (logInstancePtr: number, aliveSeconds: number) => boolean;
export const native_appenderFlush: (logInstancePtr: number, isSync: boolean) => boolean;
export const native_setMaxAliveTime: (logInstancePtr: number, aliveSeconds: number) => boolean;