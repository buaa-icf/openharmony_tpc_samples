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

    abstract appenderOpen(level: number, mode: number, cacheDir: string, logDir: string,
                 nameprefix: string, cacheDays: number): void;

    abstract appenderClose(): void;

    abstract appenderFlush(isSync: boolean): void;

    abstract setConsoleLogOpen(isOpen: boolean): void;

    abstract setMaxFileSize(aliveSeconds: number): void;

    abstract setMaxAliveTime(aliveSeconds: number): void;
  }

  class LogDebug extends LogImp {
    level: number = 0;
    logInstance: number = 0;
    constructor(level: number) {
      super();
      this.level = level;
    }

    public logV(tag: string, filename: string, funcname: string,
      line: number, log: string): void {
      if (this.level <= Log.LEVEL_VERBOSE) {
        console.log(log);
      }
    }

    public logI(tag: string, filename: string, funcname: string,
      line: number, log: string): void {
      if (this.level <= Log.LEVEL_INFO) {
        console.info(log);
      }
    }

    public logD(tag: string, filename: string, funcname: string,
      line: number, log: string): void {
      if (this.level <= Log.LEVEL_DEBUG) {
        console.debug(log);
      }
    }

    public logW(tag: string, filename: string, funcname: string,
      line: number, log: string): void {
      if (this.level <= Log.LEVEL_WARNING) {
        console.warn(log);
      }

    }

    public logE(tag: string, filename: string, funcname: string,
      line: number, log: string): void {
      if (this.level <= Log.LEVEL_ERROR) {
        console.error(log);
      }
    }

    public logF(tag: string, filename: string, funcname: string,
      line: number, log: string): void {
      if (this.level > Log.LEVEL_FATAL) {
        return;
      }
      console.error(log);
    }

    public getLogLevel(): number {
      console.log(`mock: 006 getLogLevel ${level}`)
      return this.level;
    }

    public setAppenderMode(mode: number): void {

    }

    public release(): void {

    }

    public appenderOpen(level: number, mode: number, cacheDir: string, logDir: string, nameprefix: string, cacheDays: number): void {

    }

    public appenderClose(): void {

    }

    public appenderFlush(isSync: boolean): void {
    }

    public setConsoleLogOpen(isOpen: boolean): void {

    }

    public setMaxAliveTime(aliveSeconds: number): void {

    }

    public setMaxFileSize(aliveSeconds: number): void {
    }
  }

  class LogInstance {
    public mPrefix: string = "";

    public constructor(level: number, mode: number, cacheDir: string, logDir: string, nameprefix: string, cacheDays: number) {
      if (logImp != null) {
        this.mPrefix = nameprefix;
      }
    }

    public f(tag: string, format: string, obj: string): void {
      if (logImp != null && this.getLogLevel() <= Log.LEVEL_FATAL) {
        let log: string = obj == null ? format : obj;
        logImp.logF(tag, "", "", 0, log);
      }
    }

    public e(tag: string, format: string, obj: string): void {
      if (logImp != null && this.getLogLevel() <= Log.LEVEL_ERROR) {
        let log: string = obj == null ? format : obj;
        if (log == null) {
          log = "";
        }
        logImp.logE(tag, "", "", 0, log);
      }
    }

    public w(tag: string, format: string, obj: string): void {
      if (logImp != null && this.getLogLevel() <= Log.LEVEL_WARNING) {
        let log: string = obj == null ? format : obj;
        if (log == null) {
          log = "";
        }
        logImp.logW(tag, "", "", 0, log);
      }
    }

    public i(tag: string, format: string, obj: string): void {
      if (logImp != null && this.getLogLevel() <= Log.LEVEL_INFO) {
        let log: string = obj == null ? format : obj;
        if (log == null) {
          log = "";
        }
        logImp.logI(tag, "", "", 0, log);
      }
    }

    public d(tag: string, format: string, obj: string): void {
      if (logImp != null && this.getLogLevel() <= Log.LEVEL_DEBUG) {
        let log: string = obj == null ? format : obj;
        if (log == null) {
          log = "";
        }
        logImp.logD(tag, "", "", 0, log);
      }
    }

    public v(tag: string, format: string, obj: string): void {
      if (logImp != null && this.getLogLevel() <= Log.LEVEL_VERBOSE) {
        let log: string = obj == null ? format : obj;
        if (log == null) {
          log = "";
        }
        logImp.logV(tag, "", "", 0, log);
      }
    }

    public printErrStackTrace(tag: string, tr: Error, format: string, obj: string): void {
      if (logImp != null && this.getLogLevel() <= Log.LEVEL_ERROR) {
        let log: string = obj == null ? format : obj;
        if (log == null) {
          log = "";
        }
        log += '  ' + tr.stack;
        logImp.logE(tag, "", "", process.pid, log);
      }
    }

    public appenderFlush(): void {
      if (logImp != null) {
        logImp.appenderFlush(false);
      }
    }

    public appenderFlushSync(): void {
      if (logImp != null) {
        logImp.appenderFlush(true);
      }
    }

    public getLogLevel(): number {
      if (logImp != null) {
        return logImp.getLogLevel();
      }
      return Log.LEVEL_NONE;
    }

    public setConsoleLogOpen(isOpen: boolean): void {
      if (null != logImp) {
        logImp.setConsoleLogOpen(isOpen);
      }
    }
  }

  let level: number = Log.LEVEL_NONE;
  let logImp: LogImp = new LogDebug(level);

  export function setLogImp(imp: Log.LogImp): void {
    logImp = imp;
  }

  export function getImpl(): Log.LogImp {
    return logImp;
  }

  export function appenderOpen(level: number, mode: number, cacheDir: string,
    logDir: string, nameprefix: string, cacheDays: number): void {
    if (logImp != null) {
      logImp.appenderOpen(level, mode, cacheDir, logDir, nameprefix, cacheDays);
    }
  }

  export function appenderClose(): void {
    if (logImp != null) {
      logImp.appenderClose();
      for (let entry of sLogInstanceMap.entries()) {
        closeLogInstance(entry[0]);
      }
    }
  }

  export function  appenderFlush(): void {
    if (logImp != null) {
      logImp.appenderFlush(false);
      for (let entry of sLogInstanceMap.entries()) {
        entry[1].appenderFlush();
      }
    }
  }

  export function appenderFlushSync(isSync: boolean): void {
    if (logImp != null) {
      logImp.appenderFlush(isSync);
    }
  }

  export function getLogLevel(): number {
    if (logImp != null) {
      return logImp.getLogLevel();
    }
    return Log.LEVEL_NONE;
  }

  export function setLevel(level: number, isNapi: boolean): void {
    level = level;
    console.warn('new log level: ' + level);
    if (isNapi) {
      console.error('no jni log level support');
    }
  }

  export function setConsoleLogOpen(isOpen: boolean): void {
    if (logImp != null) {
      logImp.setConsoleLogOpen(isOpen);
    }
  }

  /**
   * use f(tag, format, obj) instead
   *
   * @param tag
   * @param msg
   */
  export function f(tag: string, msg: string): void {
    fFunction(tag, msg, null);
  }

  /**
   * use e(tag, format, obj) instead
   *
   * @param tag
   * @param msg
   */
  export function e(tag: string, msg: string): void {
    eFunction(tag, msg, null);
  }

  /**
   * use w(tag, format, obj) instead
   *
   * @param tag
   * @param msg
   */
  export function w(tag: string, msg: string): void {
    wFunction(tag, msg, null);
  }

  /**
   * use i(tag, format, obj) instead
   *
   * @param tag
   * @param msg
   */
  export function i(tag: string, msg: string): void {
    iFunction(tag, msg, null);
  }

  /**
   * use d(tag, format, obj) instead
   *
   * @param tag
   * @param msg
   */
  export function d(tag: string, msg: string): void {
    dFunction(tag, msg, null);
  }

  /**
   * use v(tag, format, obj) instead
   *
   * @param tag
   * @param msg
   */
  export function v(tag: string, msg: string): void {
    vFunction(tag, msg, null);
  }

  export function fFunction(tag: string, format: string, obj: string|null): void {
    if (logImp != null && logImp.getLogLevel() <= LEVEL_FATAL) {
      let log: string = obj == null ? format : obj;
      logImp.logF(tag, "", "", 0, log);
    }
  }

  export function eFunction(tag: string, format: string, obj: string|null): void {
    if (logImp != null && logImp.getLogLevel() <= LEVEL_ERROR) {
      let log: string = obj == null ? format : obj;
      if (log == null) {
        log = "";
      }
      logImp.logE(tag, "", "", 0, log);
    }
  }

  export function wFunction(tag: string, format: string, obj: string|null): void {
    if (logImp != null && logImp.getLogLevel() <= LEVEL_WARNING) {
      let log: string = obj == null ? format : obj;
      if (log == null) {
        log = "";
      }
      logImp.logW(tag, "", "", 0, log);
    }
  }

  export function iFunction(tag: string, format: string, obj: string|null): void {
    if (logImp != null && logImp.getLogLevel() <= LEVEL_INFO) {
      let log: string = obj == null ? format : obj;
      if (log == null) {
        log = "";
      }
      logImp.logI(tag, "", "", 0, log);
    }
  }

  export function dFunction(tag: string, format: string, obj: string|null): void {
    if (logImp != null && logImp.getLogLevel() <= LEVEL_DEBUG) {
      let log: string = obj == null ? format : obj;
      if (log == null) {
        log = "";
      }
      logImp.logD(tag, "", "", 0, log);
    }
  }

  export function vFunction(tag: string, format: string, obj: string|null): void {
    if (logImp != null && logImp.getLogLevel() <= LEVEL_VERBOSE) {
      let log: string = obj == null ? format : obj;
      if (log == null) {
        log = "";
      }
      logImp.logV(tag, "", "", 0, log);
    }
  }

  export function printErrStackTrace(tag: string, tr: Error, format: string, obj: string|null): void {
    if (logImp != null && logImp.getLogLevel() <= LEVEL_ERROR) {
      let log: string = obj == null ? format : obj;
      if (log == null) {
        log = '';
      }
      log += '  ' + tr.stack;
    }
  }

  let SYS_INFO: string;
  export function getDeviceInfo(): void {
    let sb: string = "";
    try {
      sb = `VERSION.RELEASE:[ ${deviceInfo.osFullName} ]
      VERSION.CODENAME:[ ${deviceInfo.osReleaseType} ]
      VERSION.INCREMENTAL:[ ${deviceInfo.incrementalVersion} ]
      DISPLAY:[ ${deviceInfo.displayVersion} ]
      HOST:[ ${deviceInfo.buildHost} ]
      MANUFACTURER:[ ${deviceInfo.manufacture} ]
      PRODUCT:[ ${deviceInfo.productModel} ]
      TYPE:[ ${deviceInfo.buildType} ]
      USER:[ ${deviceInfo.buildUser} ]`
    } catch(error) {
      console.info('Process Failed.getDeviceInfo Cause: ' + error);
    }
    SYS_INFO = sb;
  }

  export function getSysInfo(): string {
    return SYS_INFO;
  }

  let sLogInstanceMap: Map<string, LogInstance> = new Map<string, LogInstance>();

  export function openLogInstance(level: number, mode: number, cacheDir: string, logDir: string, nameprefix: string, cacheDays: number): LogInstance|undefined {
    if (sLogInstanceMap.has(nameprefix)) {
      return sLogInstanceMap.get(nameprefix);
    }
    let instance = new LogInstance(level, mode, cacheDir, logDir, nameprefix, cacheDays);
    sLogInstanceMap.set(nameprefix, instance);
    return instance;
  }

  export function closeLogInstance(prefix: string): void {
    if (null != logImp) {
      if (sLogInstanceMap.has(prefix)) {
        let logInst = sLogInstanceMap.get(prefix);
        if (logInst != undefined) {
        }
        sLogInstanceMap.delete(prefix);
        logImp.release();
      }
    }
  }

  export function getLogInstance(prefix: string): LogInstance|undefined {
    if (sLogInstanceMap.has(prefix)) {
      return sLogInstanceMap.get(prefix);
    }
    return undefined;
  }
}

export default Log;