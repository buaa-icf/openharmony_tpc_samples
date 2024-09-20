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
struct MatchPage {
  @State message0: string = this.getResourceString($r('app.string.Raw_data')) + '：const fn = match("/user/:id", { decode: decodeURIComponent });'
  @State message1: string = this.getResourceString($r('app.string.Raw_data')) + '：fn("/user/123");'
  @State message2: string = this.getResourceString($r('app.string.Raw_data')) + '：fn("/invalid");'
  @State message3: string = this.getResourceString($r('app.string.Raw_data')) + '：fn("/user/caf%C3%A9");'
  @State message4: string = this.getResourceString($r('app.string.Raw_data')) + '：' + `const urlMatch = match("/users/:id/:tab(home|photos|bio)", {decode: decodeURIComponent,})`
  @State message5: string = this.getResourceString($r('app.string.Raw_data')) + '：urlMatch("/users/1234/photos");'
  @State message6: string = this.getResourceString($r('app.string.Raw_data')) + '：urlMatch("/users/1234/bio");'
  @State message7: string = this.getResourceString($r('app.string.Raw_data')) + '：urlMatch("/users/1234/otherstuff");'

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

        Text(this.message6)
          .fontSize(16)
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
          .backgroundColor(Color.Grey)
          .backgroundColor('#66E1E1E1')
          .fontColor(Color.Black)


        Text(this.message7)
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
            let result = api.matchTest()
            if (!result || result.length < 6) {
              promptAction.showToast({
                message: $r('app.string.The_data_processing_results_do_not_match_expectations'),
                duration: 6000
              })
              return;
            }
            let bean = new CommonResultBean();
            let arrBefore = new Array<string>();
            arrBefore.push('fn("/user/123") ' + this.getResourceString($r('app.string.Expected_results')) + ': \r\n ' + `{ path: '/user/123', index: 0, params: { id: '123' } }`);
            arrBefore.push('fn("/invalid") ' + this.getResourceString($r('app.string.Expected_results')) + ': \r\n ' + `false`);
            arrBefore.push('fn("/user/caf%C3%A9") ' + this.getResourceString($r('app.string.Expected_results')) + ': \r\n ' + `{ path: '/user/caf%C3%A9', index: 0, params: { id: 'café' } }`);
            arrBefore.push('urlMatch("/users/1234/photos") ' + this.getResourceString($r('app.string.Expected_results')) + ': \r\n ' + `{ path: '/users/1234/photos', index: 0, params: { id: '1234', tab: 'photos' } }`);
            arrBefore.push('urlMatch("/users/1234/bio") ' + this.getResourceString($r('app.string.Expected_results')) + ': \r\n ' + `{ path: '/users/1234/bio', index: 0, params: { id: '1234', tab: 'bio' } }`);
            arrBefore.push('urlMatch("/users/1234/otherstuff") ' + this.getResourceString($r('app.string.Expected_results')) + ': \r\n ' + `false`);
            bean.setBefore(arrBefore);
            let arrAfter = new Array<string>();
            arrAfter.push(JSON.stringify(result[0]));
            arrAfter.push(JSON.stringify(result[1]));
            arrAfter.push(JSON.stringify(result[2]));
            arrAfter.push(JSON.stringify(result[3]));
            arrAfter.push(JSON.stringify(result[4]));
            arrAfter.push(JSON.stringify(result[5]));
            bean.setAfter(arrAfter);
            router.pushUrl({
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