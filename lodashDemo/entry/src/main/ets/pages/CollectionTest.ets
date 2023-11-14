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

import { forEach, sample, flatMap } from "lodash";

@Entry
@Component
struct Index {
  @State resultArray: number[] = [];
  @State sampleArray: number[] = [];
  // @State resultArray: number[] = [];

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Button('遍历集合中的每个元素')
        .onClick(() => {
          forEach([1, 2, 'a', 'b'], (value: number) =>
          console.log("forEach:" + value)
          )
        }).margin(10)

      Text("显示集合中一个随机元素:" + JSON.stringify(this.sampleArray))
      Button('将获得集合中一个随机元素')
        .onClick(() => {
          this.sampleArray = sample([0, undefined, 1, false, 2, 'string', 3, true, null])
          console.log('sample:' + JSON.stringify(this.sampleArray))
        }).margin(10)

      Text("显示新扁平化数组:" + JSON.stringify(this.resultArray))
      Button('展示新扁平化数组')
        .onClick(() => {
          let duplicate: (n: number) => void = (n: number): number[] => {
             return [n, n]
          }
          this.resultArray = flatMap([1, 2], duplicate)
          console.log('flatMap:' + JSON.stringify(this.resultArray))
        }).margin(10)
    }
    .width('100%')
    .height('100%')
  }
}
