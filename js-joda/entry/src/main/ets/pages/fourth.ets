/**
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

import {
  ZonedDateTime,
  ZoneId
} from '@js-joda/core'
// import '@js-joda/timezone'
import router from '@ohos.router';

@Entry
@Component
struct Fourth {
  @State message: string = ''

  build() {
    Row() {
      Scroll() {
        Column() {
          Button('带时区日期时间测试', { type: ButtonType.Capsule, stateEffect: true })
            .backgroundColor(0x317aff)
            .width(240)
            .onClick(() => {
              this.message = testZonedDateTime();
            })
          Text(this.message)
            .fontSize(20)
            .margin(10)
            .fontColor(Color.Blue)

          Button('下一页', { type: ButtonType.Capsule, stateEffect: true })
            .backgroundColor(0x317aff)
            .width(240)
            .onClick(() => {
              router.push({ url: 'pages/fifth' })
            })
        }
      }
      .width('100%')
    }
    .height('100%')
  }
}

// 带时区日期时间测试
function testZonedDateTime() {
  // 获取默认时区的日期时间 协调世界时
  console.info(ZonedDateTime.now().toString());
  // 转换固定偏移量日期时间
  console.info(ZonedDateTime.now().withFixedOffsetZone().toString());
  // 指定城市的日期时间
  console.info(ZonedDateTime.now(ZoneId.systemDefault()).toString());

  console.info(ZonedDateTime.now(ZoneId.systemDefault()).toString());

  return "获取带时区日期时间： " + ZonedDateTime.now().toString() + '\n' +
  "获取国内上海日期时间： " + ZonedDateTime.now(ZoneId.systemDefault()).toString() + '\n';
}