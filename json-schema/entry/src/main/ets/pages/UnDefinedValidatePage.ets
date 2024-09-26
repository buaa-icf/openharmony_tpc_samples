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

@Entry
@Component
struct UnDefinedValidatePage {
  @State message0: string = `let res = validate(undefined, {type: 'string'});
res.valid`
  @State message1: string = `${this.getResourceString($r('app.string.Verify_Object'))}`
  @State message2: string = `${this.getResourceString($r('app.string.Expected_results'))}`
  @State message3: string = `${this.getResourceString($r('app.string.Actual_results'))}`

  getResourceString(res:Resource){
    return getContext().resourceManager.getStringSync(res.id)
  }

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

        Button($r('app.string.Verify'))
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
    ctx.message2 = `${this.getResourceString($r('app.string.Do_not_set_required_expected_results'))}${true}，设${this.getResourceString($r('app.string.Set_required_expected_results'))}${false}`
    try {
      let str = JSON.stringify(new Validator().validate(undefined, { type: 'string' }));
      console.log(`jsonschema ------> 不设置required测试结果：${str}`);


      let str1 = JSON.stringify(new Validator().validate(undefined, { type: 'string' }, { required: true }));
      console.log(`jsonschema ------> 设置required测试结果：${str1}`);


      ctx.message1 = `${this.getResourceString($r('app.string.Verify_Object'))} Do not set required ${str},Set required ${str1}`;
      ctx.message3 = `${this.getResourceString($r('app.string.Actual_results'))}不设置required ${new Validator().validate(undefined, { type: 'string' }).valid},设置required ${new Validator().validate(undefined, { type: 'string' }, { required: true }).valid}`
    } catch (err) {
      let str = JSON.stringify(err);
      console.log(`jsonschema ------> 验证出错：${str}`);
      ctx.message3 = `error：${str}`
    }
  }
}