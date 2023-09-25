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
      Button('点击遍历集合中的每个元素')
        .onClick(() => {
          let timestampStart = Date.now();
           function Foo() {
               this.a = 1;
           }
          function Bar() {
              this.c = 3;
          }
          Foo.prototype.b = 2;
          Bar.prototype.d = 4;
          forEach([1, 2, 'a', 'b'], value =>
          console.log("forEach:" + value)
          )
          let timestampEnd = Date.now();
          console.log('forEach 时间戳：',  (timestampEnd - timestampStart)/1000 + 's' );
        }).margin(10)

      Text("显示集合中一个随机元素:" + JSON.stringify(this.sampleArray))
      Button('点击将获得集合中一个随机元素')
        .onClick(() => {
          let timestampStart = Date.now();
          this.sampleArray = sample([0, undefined, 1, false, 2, 'string', 3, true, null])
          console.log('sample:' + JSON.stringify(this.sampleArray))
          let timestampEnd = Date.now();
          console.log('sample 时间戳：',  (timestampEnd - timestampStart)/1000 + 's' );
        }).margin(10)

      Text("显示新扁平化数组:" + JSON.stringify(this.resultArray))
      Button('点击展示新扁平化数组')
        .onClick(() => {
          let timestampStart = Date.now();
          function duplicate(n) {
             return [n, n]
          }
          this.resultArray = flatMap([1, 2], duplicate)
          console.log('flatMap:' + JSON.stringify(this.resultArray))
          let timestampEnd = Date.now();
          console.log('flatMap 时间戳：',  (timestampEnd - timestampStart)/1000 + 's' );
        }).margin(10)
    }
    .width('100%')
    .height('100%')
  }
}
