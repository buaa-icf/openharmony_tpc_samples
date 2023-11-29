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

import { assignIn, findKey, forIn, keys, get, invert } from "lodash";

class C {
  c: number = 0
}
class B {
  b: C | ESObject
}
class Objects {
  a: B[] = []
}
class ABC {
  a: string = ''
  b: string = ''
  c: string = ''
}

class Info{
  Name: string = ''
  password: string = ''
  username: string = ''
}
@Entry
@Component
struct Index {
  @State a: number = 0;
  @State b: number = 0;
  @State c: number = 0;
  @State d: number = 0;

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Button('遍历并继承分配来源对象的可枚举属性到目标对象上')
        .onClick(() => {
          let object: object = assignIn( { a:4 }, {b: 1}, {c: 3});
          // => {"a":4,"b":1,"c":3}
          console.log('遍历并继承分配来源对象的可枚举属性到目标对象上：' + JSON.stringify(object));
        }).margin(10);

      Button('访问集合的每个值,在一定条件下获取匹配的元素')
        .onClick(() => {
          class User {
            salary: number = 0
            active: boolean = true
          }
          class MeetuS {
            meetu: User | ESObject
            teetu: User | ESObject
            seetu: User | ESObject
          }
          let users: MeetuS = {
            meetu:  { salary:36000, active:true },
            teetu:  { salary:40000, active:false },
            seetu:  { salary:10000, active:true }
          };

          let found_elem: number = findKey(users, (o: ESObject) => {
            return o.salary < 40000;
          });
          console.log('访问集合的每个值,在一定条件下获取匹配的元素为：' + found_elem);
        }).margin(10)

      Button('遍历对象')
        .onClick(() => {
          let object: ABC = {a: 'a', b: 'b', c: 'c'}
          let item: string = forIn(object, (value: ESObject, key: ESObject) => {
            console.log(key);
          });
          console.log('遍历的对象:' + JSON.stringify(item));
        }).margin(10)

      Button('创建一个object自身和继承的可枚举属性名为数组')
        .onClick(() => {
          let obj: Info = {
            Name:"Geeks for Geeks",
            password:"@1234",
            username:"your_geeks"
          }
          // => ["Name","password","username"]
          console.log('创建一个object自身和继承的可枚举属性名为数组:' + JSON.stringify(keys(obj)));
        }).margin(10)

      Button('根据对象的path路径获取值')
        .onClick(() => {
          let object: Objects = { a: [{ b: { c: 3 } }] };

          let get1: object = get(object, 'a[0].b.c');
          // => 3

          let get2: object = get(object, ['a', '0', 'b', 'c']);
          // => 3

          let get3: object = get(object, 'a.b.c', 'default');
          // => 'default'
          console.log('根据对象的path路径获取值:' + get1 + ' ' + get2 + ' ' + get3);
        }).margin(10)

      Button('创建一个object键值倒置后的对象')
        .onClick(() => {
          class AObject {
            a: number = 0
            b: number = 0
            c: number = 0
          }
          let object: AObject = { a: 1, b: 2, c: 1 };

          let invertObject: object = invert(object);
          // => { '1': 'c', '2': 'b' }
          console.log('创建一个object键值倒置后的对象:' + JSON.stringify(invertObject));
        }).margin(10)
    }
    .width('100%')
    .height('100%')
  }
}

