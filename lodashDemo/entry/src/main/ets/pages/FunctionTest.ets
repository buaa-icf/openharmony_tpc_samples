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

import { map, ary, curry, debounce, delay } from "lodash";

@Entry
@Component
struct Index {

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Button('返回新的有上限的函数')
        .onClick(() => {
          //[6,8,10]
          let array: number[] = map(['6', '8', '10'], ary(parseInt, 1))
          console.log('返回新的有上限的函数' + JSON.stringify(array));
        }).margin(10);

      Button('返回新的柯里化（curry）函数')
        .onClick(() => {
          let abc = (a: number, b: number ,c: number) => {
            return [a, b, c];
          };
          let curried: ESObject = curry(abc);
          //[1,2,3]
          let curryFunction: number[] = curried(1)(2)(3);
          console.log('返回新的柯里化（curry）函数' + JSON.stringify(curryFunction));
        }).margin(10)

      Button('返回新的去抖动函数')
        .onClick(() => {
          let debounce_fun: Function = debounce( ()=>{
            console.log('去抖动函数: Function debounced after 1000ms!');
          }, 1000);
          debounce_fun()
        }).margin(10)

      Button('延迟wait毫秒后调用 func,返回计时器id')
        .onClick(() => {
          let delayId: number = delay( (text: string) => {
            console.log('一秒后输出参数: '+text);
          }, 1000, 'later');
          console.log('延迟1000毫秒后调用func,返回计时器id: ' + delayId);
        }).margin(10)
    }
    .width('100%')
    .height('100%')
  }
}

