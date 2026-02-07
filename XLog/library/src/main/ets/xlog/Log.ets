/*
 * Copyright (C) 2024 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
import deviceInfo from '@ohos.deviceInfo';
import process from '@ohos.process';
import { XLogConfig } from 'libxlog_napi.so';

namespace Log {
  export const TAG: string = 'mars.xlog.log';

  export const LEVEL_VERBOSE: number = 0;
  export const LEVEL_DEBUG: number = 1;
  export const LEVEL_INFO: number = 2;
  export const LEVEL_WARNING: number = 3;
  export const LEVEL_ERROR: number = 4;
  export const LEVEL_FATAL: number = 5;
  export const LEVEL_NONE: number = 6;

  export abstract class LogImp {
    abstract logV(tag: string, filename: string, funcname: string, line: number, log: string): void;

    abstract logI(tag: string, filename: string, funcname: string, line: number, log: string): void;

    abstract logD(tag: string, filename: string, funcname: string, line: number, log: string): void;

    abstract logW(tag: string, filename: string, funcname: string, line: number, log: string): void;

    abstract logE(tag: string, filename: string, funcname: string, line: number, log: string): void;

    abstract logF(tag: string, filename: string, funcname: string, line: number, log: string): void;

    abstract getLogLevel(): number;

    abstract setAppenderMode(mode: number): void;

    abstract release(): void;

    abstract appenderFlush(isSync: boolean): void;

    abstract setConsoleLogOpen(isOpen: boolean): void;

    abstract setMaxFileSize(aliveSeconds: number): void;

    abstract setMaxAliveTime(aliveSeconds: number): void;
  }
}

export default Log;