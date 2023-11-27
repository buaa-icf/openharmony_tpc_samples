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

class cloneObject {
  a: number = 0
}

class bObject {
  b: number = 0
}

class A {
  a: number = 0
}
@Entry
@Component
struct Index {

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Button('将非数组数组强制转为数组')
        .onClick(() => {
          let array1: number[] = castArray({ 'a': 1 });
          // => [{ 'a': 1 }]

          let array2: number[] = castArray('abc');
          // => ['abc']
          console.log('强制转化后的型数组:' + JSON.stringify(array1)+ ' ' + JSON.stringify(array2));
        }).margin(10);

      Button('获取拷贝后的值')
        .onClick(() => {
          let objects = [{ a: 1 } as cloneObject, { b: 2 } as bObject];
          let shallow: ESObject = clone(objects);
          console.log('拷贝后的值：' + JSON.stringify(shallow));
        }).margin(10)

      Button('比较两者的值')
        .onClick(() => {
          let object: A = { a: 1 };
          let other: A = { a: 1 };
          let eqs1: boolean = eq(object, object);
          // => true

          let eqs2: boolean = eq(object, other);
          // => false
          console.log('比较两者的值,两个值相等返回true,否则返回false: ' + eqs1+ ' ' + eqs2);
        }).margin(10)

      Button('检查值是否是ArrayBuffer对象')
        .onClick(() => {
          let arrayBuffer: boolean = isArrayBuffer(new ArrayBuffer(2));
          // => true
          console.log('检查值是否是ArrayBuffer对象: ' + arrayBuffer);
        }).margin(10)

      Button('检查值是否是原始Number数值型或者对象')
        .onClick(() => {
          let isNumber1: boolean = isNumber(3);
          // => true

          let isNumber2: boolean = isNumber('3');
          // => false
          console.log('检查值是否是原始Number数值型或者对象: ' + isNumber1+ ' ' + isNumber2);
        }).margin(10)
    }
    .width('100%')
    .height('100%')
  }
}

