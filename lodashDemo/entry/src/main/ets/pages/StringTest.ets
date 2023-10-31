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

import { camelCase, capitalize, escape, kebabCase, pad, parseInt, map } from "lodash";

@Entry
@Component
struct Index {

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Button('点击转换字符串为驼峰写法')
        .onClick(() => {
          let camelCaseString = camelCase('__FOO_BAR__');
          // => 'fooBar'
          console.log('转换字符串为驼峰写法为：' + JSON.stringify(camelCaseString));
        }).margin(10);

      Button('点击转换字符串首字母为大写，剩下为小写')
        .onClick(() => {
          let capitalizeString = capitalize('FRED');
          // => 'Fred'
          console.log('转换字符串首字母为大写，剩下为小写为：' + JSON.stringify(capitalizeString));
        }).margin(10)

      Button('点击将给定字符串的字符“&”，“ <”，“>”，“”和“‘”转换为它们相应的HTML实体')
        .onClick(() => {
          let escapeString = escape('fred, barney, & pebbles');
          // => 'fred, barney, &amp; pebbles'
          console.log('转换为:' + JSON.stringify(escapeString));
        }).margin(10)

      Button('点击转换字符串为kebab case')
        .onClick(() => {
          let kebabCaseString = kebabCase('__FOO_BAR__');
          // => 'foo-bar'
          console.log('转换字符串为kebab case为:' + JSON.stringify(kebabCaseString));
        }).margin(10)

      Button('点击从左侧和右侧填充字符')
        .onClick(() => {
          let paddingString = pad('abc', 8, '_-');
          // => '_-abc_-_'
          console.log('如果字符串长度小于length则从左侧和右侧填充字符为:' + JSON.stringify(paddingString));
        }).margin(10)

      Button('点击转换字符串为指定基数的整数')
        .onClick(() => {
          let array = map(['6', '08', '10'], parseInt);
          // => [6, 8, 10]
          console.log('转换字符串为指定基数的整为:' + JSON.stringify(array));
        }).margin(10)
    }
    .width('100%')
    .height('100%')
  }
}
