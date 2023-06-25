/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

// @ts-ignore
import { get12, get24 } from 'time-ampm';
import isLeapYear from 'leap-year';

@Entry
@Component
struct TimePage {

  @State time12: string = '';
  @State time24: string = '';

  build() {
    Column() {
      Row() {
        Button('get12()')
          .fontSize(18)
          .margin({ left: 18 })
          .onClick(() => {
            this.time12 = get12(0)
          })
        Text('get12(0)为：'+this.time12)
          .fontSize(18)
      }
      .padding({ top: 18, bottom: 18 })
      Row() {
        Button('get24()')
          .fontSize(18)
          .margin({ left: 18 })
          .onClick(() => {
            this.time24 = get24('10 pm')
          })
        Text('get24(10 pm)为：'+this.time24)
          .fontSize(18)
      }
      .padding({ top: 18, bottom: 18 })

      Row() {
        Button('2016是否闰年'+isLeapYear(2016))
          .fontSize(18)
          .margin({ left: 18 })
        Button('2018是否闰年'+isLeapYear(2018))
          .fontSize(18)
          .margin({ left: 18 })
      }
      .padding({ top: 18, bottom: 18 })

      Row() {
        Button('2020是否闰年'+isLeapYear(2020))
          .fontSize(18)
          .margin({ left: 18 })
        Button('2022是否闰年'+isLeapYear(2022))
          .fontSize(18)
          .margin({ left: 18 })
      }
      .padding({ top: 18, bottom: 18 })

    }
  }
}