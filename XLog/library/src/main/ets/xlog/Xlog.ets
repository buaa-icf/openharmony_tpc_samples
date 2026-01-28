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

import Log from './Log';
import {
  XLoggerInfo,
  XLogConfig,
  default as native
} from 'libxlog_napi.so';

class Xlog extends Log.LogImp {
  public static readonly LEVEL_ALL: number = 0;
  public static readonly LEVEL_VERBOSE: number = 0;
  public static readonly LEVEL_DEBUG: number = 1;
  public static readonly LEVEL_INFO: number = 2;
  public static readonly LEVEL_WARNING: number = 3;
  public static readonly LEVEL_ERROR: number = 4;
  public static readonly LEVEL_FATAL: number = 5;
  public static readonly LEVEL_NONE: number = 6;
  public static readonly COMPRESS_LEVEL1: number = 1;
  public static readonly COMPRESS_LEVEL2: number = 2;
  public static readonly COMPRESS_LEVEL3: number = 3;
  public static readonly COMPRESS_LEVEL4: number = 4;
  public static readonly COMPRESS_LEVEL5: number = 5;
  public static readonly COMPRESS_LEVEL6: number = 6;
  public static readonly COMPRESS_LEVEL7: number = 7;
  public static readonly COMPRESS_LEVEL8: number = 8;
  public static readonly COMPRESS_LEVEL9: number = 9;
  public static readonly AppednerModeAsync: number = 0;
  public static readonly AppednerModeSync: number = 1;
  public static readonly ZLIB_MODE: number = 0;
  public static readonly ZSTD_MODE: number = 1;
  private compressmode: number = 0;
  private logInstance: number = -1;
  private xlogConfig: XLogConfig = {}

  private static getXLogConfig(
    level?: number,
    mode?: number,
    logDir?: string,
    nameprefix?: string,
    pubkey?: string,
    compressmode?: number,
    compresslevel?: number,
    cacheDir?: string,
    cacheDays?: number): XLogConfig {
    return {
      level: level ?? Xlog.LEVEL_INFO,
      mode: mode ?? Xlog.AppednerModeAsync,
      logdir: logDir ?? "",
      nameprefix: nameprefix ?? "",
      pubkey: pubkey ?? "",
      compressmode: compressmode ?? Xlog.ZLIB_MODE,
      compresslevel: compresslevel ?? 0,
      cachedir: cacheDir ?? "",
      cachedays: cacheDays ?? 0
    }
  }

  private static decryptTag(tag: string): string {
    return tag;
  }

  public logV(tag: string, filename: string, funcname: string,
    line: number, log: string): void {
    this.logWrite2(Xlog.LEVEL_VERBOSE, Xlog.decryptTag(tag), filename, funcname, line, -1, -1, -1, log);
  }

  public logD(tag: string, filename: string, funcname: string,
    line: number, log: string): void {
    this.logWrite2(Xlog.LEVEL_DEBUG, Xlog.decryptTag(tag), filename, funcname, line, -1, -1, -1, log);
  }

  public logI(tag: string, filename: string, funcname: string,
    line: number, log: string): void {
    this.logWrite2(Xlog.LEVEL_INFO, Xlog.decryptTag(tag), filename, funcname, line, -1, -1, -1, log);
  }

  public logW(tag: string, filename: string, funcname: string,
    line: number, log: string): void {
    this.logWrite2(Xlog.LEVEL_WARNING, Xlog.decryptTag(tag), filename, funcname, line, -1, -1, -1, log);
  }

  public logE(tag: string, filename: string, funcname: string,
    line: number, log: string): void {
    this.logWrite2(Xlog.LEVEL_ERROR, Xlog.decryptTag(tag), filename, funcname, line, -1, -1, -1, log);
  }

  public logF(tag: string, filename: string, funcname: string,
    line: number, log: string): void {
    this.logWrite2(Xlog.LEVEL_FATAL, Xlog.decryptTag(tag), filename, funcname, line, -1, -1, -1, log);
  }

  public static logWrite(logInfo: XLoggerInfo, log: string): boolean {
    console.log('native_logWrite')
    return native.native_logWrite(logInfo, log);
  }

  public static fromLogConfig(config: XLogConfig): Xlog|null {
    let logInstance = native.native_newXlogInstance(config);
    if (logInstance == -1) {
      console.error('创建Xlog失败')
      return null;
    }
    let log = new Xlog(logInstance, config.nameprefix??"");
    log.setConfig(config);
    return log;
  }

  public loadFromNameprefix(nameprefix: string): boolean {
    let logInstance = native.native_getXlogInstance(nameprefix);
    if (logInstance == -1) {
      console.error('加载Xlog失败')
      return false;
    }
    this.logInstance = logInstance;
    return true;
  }

  private constructor(logInstance: number, nameprefix: string) {
    super();
    this.logInstance = logInstance;
    this.xlogConfig.nameprefix = nameprefix;
  }

  public setConfig(xlogConfig: XLogConfig) {
    this.xlogConfig = xlogConfig;
  }

  public logWrite2(level: number, tag: string, filename: string, funcname: string,
    line: number, pid: number, tid: number, maintid: number, log: string): boolean {
    if (this.logInstance < 0) {
      console.error('Xlog没有创建')
      return false
    }
    let xinfo: XLoggerInfo = {
      level: level,
      tag: tag,
      filename: filename,
      funcname: funcname,
      line: line,
      pid: pid,
      tid: tid,
      maintid: maintid
    };
    native.native_logWrite2(this.logInstance, xinfo, log);
    return true;
  }

  public setLogLevel(level: number): boolean {
    if (this.logInstance < 0) {
      console.error('Xlog没有创建')
      return false
    }
    return native.native_setLogLevel(this.logInstance, level);
  }

  public getLogLevel(): number {
    if (this.logInstance < 0) {
      console.error('Xlog没有创建')
      return 0
    }
    return native.native_getLogLevel(this.logInstance);
  }

  public setAppenderMode(mode: number): boolean {
    if (this.logInstance < 0) {
      console.error('Xlog没有创建')
      return false
    }
    return native.native_setAppenderMode(this.logInstance, mode);
  }

  public release(): void {
    if (this.logInstance < 0) {
      console.error('Xlog已经释放')
      return
    }
    this.logInstance = -1;
    native.native_releaseXlogInstance(this.xlogConfig.nameprefix);
  }

  public setConsoleLogOpen(isOpen: boolean): boolean {
    if (this.logInstance < 0) {
      console.error('Xlog没有创建')
      return false
    }
    return native.native_setConsoleLogOpen(this.logInstance, isOpen);
  }

  public appenderOpen(level: number, mode: number, cacheDir: string, logDir: string, nameprefix: string, cacheDays: number): void {
    let logConfig: XLogConfig = Xlog.getXLogConfig(level, mode, logDir, nameprefix, "", Xlog.ZLIB_MODE, 0, cacheDir, cacheDays)
    native.native_appenderOpen(logConfig);
  }

  public appenderClose(): void {
    console.log('native_appenderClose')
    return native.native_appenderClose();
  }

  public appenderFlush(isSync: boolean): void {
    if (this.logInstance < 0) {
      console.error('Xlog没有创建')
      return
    }
    native.native_appenderFlush(this.logInstance, isSync);
  }

  public setMaxFileSize(aliveSeconds: number): boolean {
    if (this.logInstance < 0) {
      console.error('Xlog没有创建')
      return false
    }
    return native.native_setMaxFileSize(this.logInstance, aliveSeconds);
  }

  public setMaxAliveTime(aliveSeconds: number): boolean {
    if (this.logInstance < 0) {
      console.error('Xlog没有创建')
      return false
    }
    return native.native_setMaxAliveTime(this.logInstance, aliveSeconds);
  }
}
export default Xlog;