/*
 * Copyright (C) 2021 Huawei Device Co., Ltd.
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

import { clamp, inRange, random } from "lodash";

@Entry
@Component
struct Index {

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Button('点击获取限制在一个区间之间的值')
        .onClick(() => {
          let numberClamp = clamp(10, -5, 5);
          // => 5
          console.log('限制在一个区间之间的值：' + numberClamp);
        }).margin(10);

      Button('点击检查一个数值是否在某一区间之内')
        .onClick(() => {
          let isRange = inRange(3, 2, 4);
          // => true
          console.log('检查一个数值是否在某一区间之内：' + isRange);
        }).margin(10)

      Button('点击产生一个包括某一区间之间的数')
        .onClick(() => {
          let randomNumber = random(0, 5);
          // => an integer between 0 and 5
          console.log('产生一个包括某一区间之间的数:' + randomNumber);
        }).margin(10)
    }
    .width('100%')
    .height('100%')
  }
}

