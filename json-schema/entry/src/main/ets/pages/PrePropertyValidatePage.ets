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

import { SchemaError, validate, ValidationError, Validator, ValidatorResult } from 'jsonschema'

const v0 = new Validator();
const v1 = new Validator();

@Entry
@Component
struct PrePropertyValidatePage {
  @State message0: string = `// See examples/coercion.js
function preValidateProperty(object, key, schema, options, ctx) {
  var value = object[key];
  if (typeof value === 'undefined') return;

  // Test if the schema declares a type, but the type keyword fails validation
  if (schema.type && validator.attributes.type.call(validator, value, schema, options, ctx.makeChild(schema, key))) {
    // If the type is "number" but the instance is not a number, cast it
    if(schema.type==='number' && typeof value!=='number'){
      object[key] = parseFloat(value);
      return;
    }
    // If the type is "string" but the instance is not a string, cast it
    if(schema.type==='string' && typeof value!=='string'){
      object[key] = String(value).toString();
      return;
    }
  }
};

// And now, to actually perform validation with the coercion hook!
v.validate(instance, schema, { preValidateProperty });`
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
    ctx.message2 = `期待结果：使用预处理 ${true} ${'\r\n'}
        不使用预处理 ${false} ${'\r\n'}`
    try {
      const schema = { 'properties': {
        'name': { 'type': 'string' },
        'quantity': { 'type': 'number' }
      } };
      const instance = {
        name: 123,
        quantity: '2'
      }

      let result0 = v0.validate(instance, schema);

      let result1 = v1.validate(instance, schema, { preValidateProperty: ctx.preValidate });
      let str = JSON.stringify(result1);
      console.log(`jsonschema ------> 测试结果是：${str}`);
      ctx.message1 = `验证对象： ${str}`;
      ctx.message3 = `实际结果：使用预处理 ${result1.valid} ${'\r\n'}
        不使用预处理 ${result0.valid} ${'\r\n'}`
    } catch (err) {
      let str = JSON.stringify(err);
      console.log(`jsonschema ------> 验证出错：${str}`);
      ctx.message3 = `验证出错：${str}`
    }
  }
  // See examples/coercion.js
  preValidate(object, key, schema, options, ctx) {
    var value = object[key];
    if (typeof value === 'undefined') return;

    // Test if the schema declares a type, but the type keyword fails validation
    if (schema.type && v1.attributes.type.call(v1, value, schema, options, ctx.makeChild(schema, key))) {
      // If the type is "number" but the instance is not a number, cast it
      if (schema.type === 'number' && typeof value !== 'number') {
        object[key] = parseFloat(value);
        return;
      }
      // If the type is "string" but the instance is not a string, cast it
      if (schema.type === 'string' && typeof value !== 'string') {
        object[key] = String(value).toString();
        return;
      }
    }
  };
}