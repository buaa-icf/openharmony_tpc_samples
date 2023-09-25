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

import { castArray, clone, eq, isArrayBuffer, isNumber } from "lodash"

@Entry
@Component
struct Index {

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Button('点击将非数组数组强制转为数组')
        .onClick(() => {
          let arry1 = castArray({ 'a': 1 });
          // => [{ 'a': 1 }]

          let arry2 = castArray('abc');
          // => ['abc']
          console.log('强制转化后的型数组:' + JSON.stringify(arry1)+ ' ' + JSON.stringify(arry2));
          let timestampEnd = Date.now();
          console.log('castArray 时间戳：',  (timestampEnd - timestampStart)/1000 + 's' );
        }).margin(10);

      Button('点击获取拷贝后的值')
        .onClick(() => {
          var objects = [{ 'a': 1 }, { 'b': 2 }];
          var shallow = clone(objects);
          console.log('拷贝后的值：' + JSON.stringify(shallow));
          let timestampEnd = Date.now();
          console.log('clone 时间戳：',  (timestampEnd - timestampStart)/1000 + 's' );
        }).margin(10)

      Button('点击比较两者的值')
        .onClick(() => {
          let object = { 'a': 1 };
          let other = { 'a': 1 };
          let eqs1 = eq(object, object);
          // => true

          let eqs2 = eq(object, other);
          // => false
          console.log('比较两者的值,两个值相等返回true,否则返回false: ' + eqs1+ ' ' + eqs2);
        }).margin(10)

      Button('点击检查值是否是ArrayBuffer对象')
        .onClick(() => {
          let arrayBuffer = isArrayBuffer(new ArrayBuffer(2));
          // => true
          console.log('检查值是否是ArrayBuffer对象: ' + arrayBuffer);
        }).margin(10)

      Button('点击检查值是否是原始Number数值型或者对象')
        .onClick(() => {
          let isNumber1 = isNumber(3);
          // => true

          let isNumber2 = isNumber('3');
          // => false
          console.log('检查值是否是原始Number数值型或者对象: ' + isNumber1+ ' ' + isNumber2);
        }).margin(10)
    }
    .width('100%')
    .height('100%')
  }
}

