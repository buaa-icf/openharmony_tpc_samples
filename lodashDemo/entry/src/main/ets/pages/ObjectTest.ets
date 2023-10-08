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

import { assignIn, findKey, forIn, functions, constant, get, invert } from "lodash";

@Entry
@Component
struct Index {

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Button('点击遍历并继承分配来源对象的可枚举属性到目标对象上')
        .onClick(() => {
          function Foo() {
            this.a = 1;
          }

          function Bar() {
            this.c = 3;
          }

          Foo.prototype.b = 2;
          Bar.prototype.d = 4;

          let object = assignIn({ 'a': 0 }, new Foo, new Bar);
          // => { 'a': 1, 'b': 2, 'c': 3, 'd': 4 }
          console.log('遍历并继承分配来源对象的可枚举属性到目标对象上：' + JSON.stringify(object));
        }).margin(10);

      Button('点击访问集合的每个值,在一定条件下获取匹配的元素')
        .onClick(() => {
          let users = {
            'meetu':  { 'salary':36000, 'active':true },
            'teetu':  { 'salary':40000, 'active':false },
            'seetu':  { 'salary':10000,  'active':true }
          };

          let found_elem = findKey(users, function(o) {
            return o.salary < 40000;
          });
          console.log('访问集合的每个值,在一定条件下获取匹配的元素为：' + found_elem);
        }).margin(10)

      Button('点击遍历对象')
        .onClick(() => {
          function Foo() {
            this.a = 1;
            this.b = 2;
          }

          Foo.prototype.c = 3;

          let item = forIn(new Foo, function(value, key) {
            console.log(key);
          });
          console.log('遍历的对象:' + JSON.stringify(item));
        }).margin(10)

      Button('点击创建一个函数属性名称的数组')
        .onClick(() => {
          function Foo() {
            this.a = constant('a');
            this.b = constant('b');
          }

          Foo.prototype.c = constant('c');

          functions(new Foo);
          // => ['a', 'b']
          console.log('创建一个函数属性名称的数组:' + JSON.stringify(functions(new Foo)));
        }).margin(10)

      Button('点击根据对象的path路径获取值')
        .onClick(() => {
          let object = { 'a': [{ 'b': { 'c': 3 } }] };

          let get1 = get(object, 'a[0].b.c');
          // => 3

          let get2 = get(object, ['a', '0', 'b', 'c']);
          // => 3

          let get3 = get(object, 'a.b.c', 'default');
          // => 'default'
          console.log('根据对象的path路径获取值:' + get1 + ' ' + get2 + ' ' + get3);
        }).margin(10)

      Button('点击创建一个object键值倒置后的对象')
        .onClick(() => {
          let object = { 'a': 1, 'b': 2, 'c': 1 };

          let invertObject = invert(object);
          // => { '1': 'c', '2': 'b' }
          console.log('创建一个object键值倒置后的对象:' + JSON.stringify(invertObject));
        }).margin(10)
    }
    .width('100%')
    .height('100%')
  }
}

