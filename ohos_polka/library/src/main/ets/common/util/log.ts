/**
 * MIT License
 *
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the 'Software'), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to all conditions.
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import hilog from "@ohos.hilog";

function toString(args: unknown[], maxLength?: number): string {
  let s = args.map(v => {
    if (typeof v == "string") {
      return v;
    } else if (v && v.toString) {
      return v.toString();
    } else {
      try {
        const s = JSON.stringify(v);
        return s;
      } catch (e: unknown) {
        return v as string;
      }
    }
  }).join(" ");
  if (maxLength && maxLength > 0 && s.length > maxLength) {
    s = s.substring(0, maxLength);
  }
  return s;
}

let _logLevel: hilog.LogLevel = hilog.LogLevel.INFO;
export function setLogLevel(level: hilog.LogLevel): void {
  _logLevel = level;
}

export function showDebugLog(show: boolean): void {
  if (show) {
    _logLevel = hilog.LogLevel.DEBUG;
  } else if (_logLevel == hilog.LogLevel.DEBUG) {
    _logLevel = hilog.LogLevel.INFO;
  }
}

const _disabledLogNameList: string[] = [];

export function disableLogName(name: string): void {
  if (!_disabledLogNameList.includes(name)) {
    _disabledLogNameList.push(name);
  }
}

export function enableLogName(name: string): void {
  const index = _disabledLogNameList.indexOf(name);
  if (index >= 0) {
    _disabledLogNameList.splice(index, 1);
  }
}

function canLog(name: string, level: hilog.LogLevel): boolean {
  return level >= _logLevel && !_disabledLogNameList.includes(name);
}

export class Logger {
  prefix: string = "[mccm]";
  name: string;
  maxLength: number = 2000

  constructor(name: string) {
    this.prefix += name;
    this.name = name;
  }

  addPrefix(prefix: string): void {
    this.prefix += prefix;
  }

  setLineLimit(max: number): void {
    this.maxLength = max;
  }

  trace(...args: unknown[]): void {
    if (canLog(this.name, hilog.LogLevel.DEBUG)) {
      hilog.debug(2, this.prefix, toString(args));
    }
  }

  debug(...args: unknown[]): void {
    if (canLog(this.name, hilog.LogLevel.DEBUG)) {
      hilog.debug(1, this.prefix, toString(args, this.maxLength));
    }
  }

  info(...args: unknown[]): void {
    if (canLog(this.name, hilog.LogLevel.INFO)) {
      hilog.info(1, this.prefix, toString(args, this.maxLength));
    }
  }

  warn(...args: unknown[]): void {
    if (canLog(this.name, hilog.LogLevel.WARN)) {
      hilog.warn(1, this.prefix, toString(args, this.maxLength));
    }
  }

  error(...args: unknown[]): void {
    if (canLog(this.name, hilog.LogLevel.ERROR)) {
      hilog.error(1, this.prefix, toString(args));
    }
  }

  fatal(...args: unknown[]): void {
    if (canLog(this.name, hilog.LogLevel.FATAL)) {
      hilog.fatal(1, this.prefix, toString(args));
    }
  }

  log(...args: unknown[]): void {
    this.info(...args);
  }
}

export function getLogger(name: string): Logger {
  return new Logger(name);
}
