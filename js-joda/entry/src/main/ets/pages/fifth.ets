/**
 * BSD License
 *
 * Copyright (c) 2023 Huawei Device Co., Ltd. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * * Redistributions of source code must retain the above copyright notice, this
 *  list of conditions and the following disclaimer.
 *
 * * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * * Neither the name Facebook nor the names of its contributors may be used to
 * endorse or promote products derived from this software without specific
 * prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
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
          Button($r('app.string.time_measurement_test'), { type: ButtonType.Capsule, stateEffect: true })
            .backgroundColor(0x317aff)
            .width(240)
            .onClick(() => {
              this.message = testDurationTime();
            })
          Text(this.message)
            .fontSize(15)
            .margin(10)
            .fontColor(Color.Blue)

          Button($r('app.string.next_page'), { type: ButtonType.Capsule, stateEffect: true })
            .backgroundColor(0x317aff)
            .width(240)
            .onClick(() => {
              router.pushUrl({ url: 'pages/sixth' })
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

  return getContext().resourceManager.getStringByNameSync("a_ten_hour_time_quantity_representation") + Duration.ofHours(10).toString() + '\n' +
  getContext().resourceManager.getStringByNameSync('a_10_year_and_45_day_time_quantity_representation') + Period.ofYears(10).plusDays(45).toString() + '\n' +
  getContext().resourceManager.getStringByNameSync('Given_time_plus_10_hours_and_30_minutes') + mDateTime.plus(Duration.ofHours(10).plusMinutes(30)).toString();
}