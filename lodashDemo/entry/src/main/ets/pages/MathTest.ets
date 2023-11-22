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

import { add, ceil, meanBy } from "lodash";

class Objects {
  n: number = 0
}
@Entry
@Component
struct Index {
  @State augend: number = 0
  @State addend: number = 0
  @State ceilNumber: number = 0
  @State precision: number = 0
  @State mean: number = 0

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {

      Button('进行加法运算（10+7）')
        .onClick(() => {
          let additionCount: number = add(10, 7);
          console.log('additionCount（10+7）:' + Math.round(additionCount))
        }).margin(5)

      Button('进行保留几位小数运算（6.004向上舍入保留2位小數）')
        .onClick(() => {
          let ceilCount: number = ceil(6.004, 2);
          console.log('ceil number:' + ceilCount)
        }).margin(5)

      Text("数组平均值：" + this.mean)
      Button('求数组平均值')
        .onClick(() => {
          let sampleObjects: Objects[] = [{ n: 4 }, { n: 2 }, { n: 8 }, { n: 6 }];
          this.mean = meanBy(sampleObjects, (o: Objects) => { return o.n; })
          console.log('mean:' + this.mean)
        }).margin(5)
    }
    .width('100%')
    .height('100%')
  }
}
