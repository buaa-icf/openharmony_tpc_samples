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

import { Duration, LocalDateTime, Period } from '@js-joda/core'
// import '@js-joda/timezone'
import router from '@ohos.router';

@Entry
@Component
struct Fifth {
  @State message: string = ''

  build() {
    Row() {
      Scroll() {
        Column() {
          Button('时间量测试', { type: ButtonType.Capsule, stateEffect: true })
            .backgroundColor(0x317aff)
            .width(240)
            .onClick(() => {
              this.message = testDurationTime();
            })
          Text(this.message)
            .fontSize(20)
            .margin(10)
            .fontColor(Color.Blue)

          Button('下一页', { type: ButtonType.Capsule, stateEffect: true })
            .backgroundColor(0x317aff)
            .width(240)
            .onClick(() => {
              router.push({ url: 'pages/sixth' })
            })
        }
      }
      .width('100%')
    }
    .height('100%')
  }
}

// 时间量测试
function testDurationTime(): string {
  // 时间量 PT10H
  console.info(Duration.ofHours(10).toString());
  // 时间量 P10Y45D
  console.info(Period.ofYears(10).plusDays(45).toString());
  // 时间量计算 2012-12-24T22:30
  let mDateTime = LocalDateTime.parse("2012-12-24T12:00");

  console.info(mDateTime.plus(Duration.ofHours(10).plusMinutes(30)).toString());

  return "获取十小时时间量表示： " + Duration.ofHours(10).toString() + '\n' +
  "获取10年45天时间量表示： " + Period.ofYears(10).plusDays(45).toString() + '\n' +
  "给定时间加10小时30分： " + mDateTime.plus(Duration.ofHours(10).plusMinutes(30)).toString();
}