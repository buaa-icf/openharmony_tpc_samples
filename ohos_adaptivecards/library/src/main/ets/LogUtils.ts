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

import hilog from '@ohos.hilog';

export class LogUtils {
  private isOpen: boolean = false;
  public static readonly TAG: string = "adaptivecards:js";
  private static instance: LogUtils;
  public static readonly DOMAIN: number = 0xD002220;

  private constructor() {
  };

  public static getInstance() {
    if (!LogUtils.instance) {
      LogUtils.instance = new LogUtils();
    }
    return LogUtils.instance;
  }

  setLogOpen(open: boolean) {
    this.isOpen = open;
  }

  debug(message: string, ...args: Object[]) {
    if (!this.isOpen) {
      return;
    }
    hilog.debug(LogUtils.DOMAIN, LogUtils.TAG, message, args)
  }

  info(message: string, ...args: Object[]) {
    if (!this.isOpen) {
      return;
    }
    hilog.info(LogUtils.DOMAIN, LogUtils.TAG, message, args)
  }

  warn(message: string, ...args: Object[]) {
    if (!this.isOpen) {
      return;
    }
    hilog.warn(LogUtils.DOMAIN, LogUtils.TAG, message, args)
  }

  error(message: string, ...args: Object[]) {
    if (!this.isOpen) {
      return;
    }
    hilog.error(LogUtils.DOMAIN, LogUtils.TAG, message, args)
  }
}