/*
 * Copyright (C) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import hilog from '@ohos.hilog';

export class LogUtil {
  static DOMAIN = 0xF010;
  static TAG = '[dialogs]: ';

  static debug(message:string) {
    hilog.debug(LogUtil.DOMAIN, LogUtil.TAG, message)
  }

  static info(message:string) {
    hilog.info(LogUtil.DOMAIN, LogUtil.TAG, message)
  }

  static log(message:string) {
    hilog.debug(LogUtil.DOMAIN, LogUtil.TAG, message)
  }

  static warn(message:string) {
    hilog.warn(LogUtil.DOMAIN, LogUtil.TAG, message)
  }

  static error(message:string) {
    hilog.error(LogUtil.DOMAIN, LogUtil.TAG, message)
  }
}