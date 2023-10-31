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

import { conforms, filter, defaultTo, identity, nthArg, stubObject, times } from "lodash";

@Entry
@Component
struct Index {

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Button('点击获取新函数，并作为filter的参数筛选出对应的内容')
        .onClick(() => {
          let objects = [
            { 'a': 2, 'b': 1 },
            { 'a': 1, 'b': 2 }
          ];
          let result = filter(objects, conforms({ 'b': function(n) {
            return n > 1;
          } }));
          // => [{ 'a': 1, 'b': 2 }]
          console.log('conforms：' + JSON.stringify(result));
        }).margin(10);

      Button('点击检查值，以确定一个默认值是否应被返回')
        .onClick(() => {
          let isDefault = defaultTo(undefined, 10);
          // => 10
          console.log('如果检查值为NaN, null, 或者 undefined，返回默认值，否则返回检查值：' + JSON.stringify(isDefault));
        }).margin(10)

      Button('点击获取接收的第一个参数')
        .onClick(() => {
          let user = [
            { 'name':'XXXX', 'age':36, 'active':true },
            { 'name':'YYYY',   'age':40, 'active':false }
          ];
          let parameter = identity(user);
          console.log('获取接收的第一个参数:' + JSON.stringify(parameter));
        }).margin(10)

      Button('点击创建一个函数，这个函数返回第n个参数')
        .onClick(() => {
          let func = nthArg(2);
          // 'c'
          console.log('创建一个函数，这个函数返回第n个参数为:' + JSON.stringify(func('a', 'b', 'c', 'd')));
        }).margin(10)

      Button('点击获取一个空对象')
        .onClick(() => {
          let objects = times(2, stubObject);
          // => [{}, {}]
          console.log('返回一个空对象为:' + JSON.stringify(objects));
        }).margin(10)
    }
    .width('100%')
    .height('100%')
  }
}
