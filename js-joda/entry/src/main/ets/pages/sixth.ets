/**
 * Copyright (C) 2023 Huawei Device Co., Ltd.
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

import { DateTimeFormatter, LocalDateTime, ZonedDateTime } from '@js-joda/core'
// import '@js-joda/timezone'
import { Locale } from '@ohos/localeEnUs'

@Entry
@Component
struct Sixth {
  @State message: string = ''

  build() {
    Row() {
      Scroll() {
        Column() {
          Button('日期时间格式化', { type: ButtonType.Capsule, stateEffect: true })
            .backgroundColor(0x317aff)
            .width(240)
            .onClick(() => {
              this.message = testFormatter();
            })
          Text(this.message)
            .fontSize(20)
            .margin(10)
            .fontColor(Color.Blue)
        }
      }
      .width('100%')
    }
    .height('100%')
  }
}

// 日期时间格式化
function testFormatter(): string {
  // 基础格式化
  const dateTime = LocalDateTime.parse("2018-04-28T12:34");
  // 日期格式化 4/28/2018
  console.info(dateTime.format(DateTimeFormatter.ofPattern('M/d/yyyy')));
  // 时间格式化 12:34
  console.info(dateTime.format(DateTimeFormatter.ofPattern('HH:mm')));


  // 按照英语格式进行日期时间格式化 2021-10-05T17:08:24+01:00[GMT]
  const dateTimeFormatter:ESObject = DateTimeFormatter.ofPattern('EEE, dd MMM yyyy HH:mm:ss z').withLocale(Locale.ENGLISH);
  const zoneDateTime = ZonedDateTime.parse('Tue, 05 Oct 2021 17:08:24 GMT', dateTimeFormatter);
  console.log(zoneDateTime.toString());

  return "基础日期格式化： " + dateTime.format(DateTimeFormatter.ofPattern('M/d/yyyy')) + '\n' +
  "时间格式化： " + dateTime.format(DateTimeFormatter.ofPattern('HH:mm')) + '\n' +
  "给定日期时间格式化： " + zoneDateTime.toString();

}