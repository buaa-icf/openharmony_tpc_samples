/*
 * Copyright (C) 2022 Huawei Device Co., Ltd.
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

export default class Logger {
  static DOMAIN = 0xFE42;
  static TAG = 'OHOS_NTP';

  static debug(message, ...args) {
    hilog.debug(Logger.DOMAIN, Logger.TAG, message, args);
  }

  static info(message, ...args) {
    hilog.info(Logger.DOMAIN, Logger.TAG, message, args);
  }

  static warn(message, ...args) {
    hilog.warn(Logger.DOMAIN, Logger.TAG, message, args);
  }

  static error(message, ...args) {
    hilog.error(Logger.DOMAIN, Logger.TAG, message, args);
  }
}