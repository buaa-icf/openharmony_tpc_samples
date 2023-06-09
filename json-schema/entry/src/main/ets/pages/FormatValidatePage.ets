/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { SchemaError, validate, ValidationError, Validator, ValidatorResult } from '@ohos/jsonschema'

Validator.prototype.customFormats.myFormat = function (input) {
  return input === 'myFormat';
};

@Entry
@Component
struct FormatValidatePage {
  @State message0: string = `Validator.prototype.customFormats.myFormat = function(input) {
  return input === 'myFormat';
};

var validator = new Validator();
validator.validate('myFormat', {type: 'string', format: 'myFormat'}).valid; // true
validator.validate('foo', {type: 'string', format: 'myFormat'}).valid; // false`
  @State message1: string = `验证对象：--`
  @State message2: string = `期待结果：暂无`
  @State message3: string = `实际结果：--`

  build() {
    Row() {
      Column() {
        Text(this.message0)
          .fontSize(16)
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
          .backgroundColor('#22E1E1E1')
          .maxLines(10)
          .fontColor(Color.Black)

        Text(this.message1)
          .fontSize(16)
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
          .backgroundColor('#66E1E1E1')
          .maxLines(10)
          .fontColor(Color.Black)
          .margin({
            top: 20
          })

        Text(this.message2)
          .fontSize(16)
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
          .backgroundColor('#66E1E1E1')
          .maxLines(10)
          .fontColor(Color.Black)
          .margin({
            top: 20
          })

        Text(this.message3)
          .fontSize(16)
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
          .backgroundColor('#66E1E1E1')
          .maxLines(10)
          .fontColor(Color.Black)
          .margin({
            top: 20
          })

        Button('验证')
          .backgroundColor(Color.Blue)
          .fontColor(Color.White)
          .width("80%")
          .height(100)
          .margin({
            top: 20
          })
          .onClick((event) => {
            this.validate();
          })

      }
      .width('100%')
    }
    .height('100%')
  }

  validate() {
    const ctx = this;
    ctx.message2 = `myFormat期待结果：${true}，foo期待结果：${false}`
    try {

      var v1 = new Validator();
      var v2 = new Validator();

      let result1 = v1.validate('myFormat', { type: 'string', format: 'myFormat' });
      let result2 = v2.validate('foo', { type: 'string', format: 'myFormat' });
      let str1 = JSON.stringify(result1);
      let str2 = JSON.stringify(result2);
      console.log(`jsonschema ------> myFormat 测试结果是：${str1}，foo 测试结果是：${str2}`);
      ctx.message1 = `myFormat 验证对象： ${str1}，foo 验证对象： ${str2}`;
      ctx.message3 = `myFormat 实际结果：${result1.valid}，foo 实际结果：${result2.valid}`
    } catch (err) {
      let str = JSON.stringify(err);
      console.log(`jsonschema ------> 验证出错：${str}`);
      ctx.message3 = `验证出错：${str}`
    }
  }
}