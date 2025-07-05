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
struct CustomMatchingParamtersPage {
  @State message0: string = this.getResourceString($r('app.string.Raw_data')) + '：const regexpNumbers = pathToRegexp("/icon-:foo.png");'
  @State message1: string = this.getResourceString($r('app.string.Raw_data')) + '：regexpNumbers.regexp.exec("/icon-123.png");'
  @State message2: string = this.getResourceString($r('app.string.Raw_data')) + '：regexpNumbers.regexp.exec("/icon-abc.png");'
  @State message3: string = this.getResourceString($r('app.string.Raw_data')) + '：const regexpWord = pathToRegexp("/:foo;'
  @State message4: string = this.getResourceString($r('app.string.Raw_data')) + '：regexpWord.regexp.exec("/u");'
  @State message5: string = this.getResourceString($r('app.string.Raw_data')) + '：regexpWord.regexp.exec("/users");'

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
        Text(this.message3)
          .fontSize(16)
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
          .backgroundColor(Color.Grey)
          .backgroundColor('#66E1E1E1')
          .fontColor(Color.Black)
        Text(this.message4)
          .fontSize(16)
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
          .backgroundColor(Color.Grey)
          .backgroundColor('#66E1E1E1')
          .fontColor(Color.Black)
        Text(this.message5)
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
            let result = api.customMatchingParametersTest()
            if (!result || result.length < 4) {
              this.getUIContext().getPromptAction().showToast({
                message: $r('app.string.The_data_processing_results_do_not_match_expectations'),
                duration: 6000
              })
              return;
            }
            let bean = new CommonResultBean();
            let arrBefore = new Array<string>();
            arrBefore.push('exec("/icon-123.png")  ' + this.getResourceString($r('app.string.Expected_results')) + ': \r\n ' + `['/icon-123.png', '123']`);
            arrBefore.push('exec("/icon-abc.png")  ' + this.getResourceString($r('app.string.Expected_results')) + ': \r\n ' + `null`);
            arrBefore.push('exec("/u")  ' + this.getResourceString($r('app.string.Expected_results')) + ': \r\n ' + ` ['/u', 'u']`);
            arrBefore.push('exec("/users")  ' + this.getResourceString($r('app.string.Expected_results')) + ': \r\n ' + `null`);
            bean.setBefore(arrBefore);
            let arrAfter = new Array<string>();
            arrAfter.push(JSON.stringify(result[0]));
            arrAfter.push(JSON.stringify(result[1]));
            arrAfter.push(JSON.stringify(result[2]));
            arrAfter.push(JSON.stringify(result[3]));
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