/*
 * Copyright (C) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import hilog from '@ohos.hilog';


export default class LogUtil {
  public static readonly DOMAIN: number = 0x200;
  public static readonly TAG: string = 'metadata-extractor::';
  public static ON: boolean = true
  public static OFF: boolean = false
  public static mLogLevel: boolean = LogUtil.ON

  public static debug(pageTag: string, message: string, ...args: Object[]) {
    if (LogUtil.mLogLevel == LogUtil.ON) {
      hilog.debug(LogUtil.DOMAIN, LogUtil.TAG, `${pageTag} ${message}`, args)
    }
  }

  public static info(pageTag: string, message: string, ...args: Object[]) {
    if (LogUtil.mLogLevel == LogUtil.ON) {
      hilog.info(LogUtil.DOMAIN, LogUtil.TAG, `${pageTag} ${message}`, args)
    }
  }

  public static log(pageTag: string, message: string, ...args: Object[]) {
    if (LogUtil.mLogLevel == LogUtil.ON) {
      hilog.debug(LogUtil.DOMAIN, LogUtil.TAG, `${pageTag} ${message}`, args)
    }
  }

  public static warn(pageTag: string, message: string, ...args: Object[]) {
    hilog.warn(LogUtil.DOMAIN, LogUtil.TAG, `${pageTag} ${message}`, args)
  }

  public static error(pageTag: string, message: string, ...args: Object[]) {
    hilog.error(LogUtil.DOMAIN, LogUtil.TAG, `${pageTag} ${message}`, args)
  }
}