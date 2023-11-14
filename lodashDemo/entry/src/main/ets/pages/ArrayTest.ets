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

import { chunk, compact, uniq, union } from "lodash";

@Entry
@Component
struct Index {
  private sampleArray = [1, 'a', 4, 7, 9, 's', 'r',2, 5, 'o', 's', 'p', 34, 'k'];
  @State resultArray: number[] = [];

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Text("显示运行结果:" + JSON.stringify(this.resultArray))
      Button('将数组拆分成多个长度的区块，组成一个新数组')
         .onClick(() => {
          this.resultArray = chunk(this.sampleArray, 5)
          console.log('chunk:' + JSON.stringify(this.resultArray))
        }).margin(10)

      //false, null,0, "", undefined, 和 NaN 都是被认为是“假值”
      Button('将数组过滤掉假值組成新数组')
        .onClick(() => {
          this.resultArray = compact([0, undefined, 1, false, 2, '', 3, true, null])
          console.log('compact:' + JSON.stringify(this.resultArray))
        }).margin(10)

      Button('展示去重后的数组')
        .onClick(() => {
          this.resultArray = uniq([12,2,3,2,1,2,2,1,1,3,4])
          console.log('[12,2,3,2,1,2,2,1,1,3,4] uniq:' + JSON.stringify(this.resultArray));
        }).margin(10)

      Button('展示合并多个数组后新生成的数组')
        .onClick(() => {
          this.resultArray = union([12,2,6,1],[3,2,1,3,4,6,2],[2,1])
          console.log('[12,2,6,1],[3,2,1,3,4,6,2],[2,1] union:' + JSON.stringify(this.resultArray))
        }).margin(10)
    }
    .width('100%')
    .height('100%')
  }
}
