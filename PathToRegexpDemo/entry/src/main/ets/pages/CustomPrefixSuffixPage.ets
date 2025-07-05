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

import TestApi from '../TestApi';
import CommonResultBean from '../CommonResultBean';
import promptAction from '@ohos.promptAction';
import router from '@ohos.router';

@Entry
@Component
struct CustomPrefixSuffixPage {
  @State message0: string = this.getResourceString($r('app.string.Raw_data')) + '：const res = pathToRegexp("/:attr1?{-:attr2}?{-:attr3}?");'
  @State message1: string = this.getResourceString($r('app.string.Raw_data')) + '：res.regexp.exec("/test");'
  @State message2: string = this.getResourceString($r('app.string.Raw_data')) + '：res.regexp.exec("/test-test");'

  getResourceString(res:Resource){
    return this.getUIContext().getHostContext()?.resourceManager.getStringSync(res.id) ?? ''
  }

  build() {
    Row() {
      Column() {
        Text(this.message0)
          .fontSize(16)
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
          .backgroundColor('#22E1E1E1')
          .fontColor(Color.Black)
        Text(this.message1)
          .fontSize(16)
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
          .backgroundColor(Color.Grey)
          .backgroundColor('#66E1E1E1')
          .fontColor(Color.Black)
        Text(this.message2)
          .fontSize(16)
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
          .backgroundColor(Color.Grey)
          .backgroundColor('#66E1E1E1')
          .fontColor(Color.Black)


        Button($r('app.string.Start_convert'))
          .backgroundColor(Color.Blue)
          .fontColor(Color.White)
          .width('80%')
          .height(100)
          .onClick((event) => {
            let api = new TestApi()
            let result = api.customPrefixSuffixTest()
            if (!result || result.length < 2) {
              this.getUIContext().getPromptAction().showToast({
                message: $r('app.string.The_data_processing_results_do_not_match_expectations'),
                duration: 6000
              })
              return;
            }
            let bean = new CommonResultBean();
            let arrBefore = new Array<string>();
            arrBefore.push('res.regexp.exec("/test")  ' + this.getResourceString($r('app.string.Expected_results')) + ': \r\n ' + `['/test', 'test', null, null]`);
            arrBefore.push('res.regexp.exec("/test-test")  ' + this.getResourceString($r('app.string.Expected_results')) + ': \r\n ' + `['/test-test', 'test', 'test', null]`); // TODO 源库 readme注释错误 显示结果为`['/test', 'test', 'test', null]` 实际结果是 `['/test-test', 'test', 'test', null]`
            bean.setBefore(arrBefore);
            let arrAfter = new Array<string>();
            arrAfter.push(JSON.stringify(result[0]));
            arrAfter.push(JSON.stringify(result[1]));
            bean.setAfter(arrAfter);
            this.getUIContext().getRouter().pushUrl({
              url: 'pages/CommonResultPage',
              params: {
                dataObj: bean
              }
            })
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}