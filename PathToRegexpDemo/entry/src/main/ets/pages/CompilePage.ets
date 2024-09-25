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
struct CompilePage {
  @State message0: string = this.getResourceString($r('app.string.Raw_data')) + '：const toPath = compile("/user/:id", { encode: encodeURIComponent });'
  @State message1: string = this.getResourceString($r('app.string.Raw_data')) + '：toPath({ id: 123 });'
  @State message2: string = this.getResourceString($r('app.string.Raw_data')) + '：toPath({ id: "café" });'
  @State message3: string = this.getResourceString($r('app.string.Raw_data')) + '：toPath({ id: "/" });'
  @State message4: string = this.getResourceString($r('app.string.Raw_data')) + '：toPath({ id: ":/" })'
  @State message5: string = this.getResourceString($r('app.string.Raw_data')) + '：const toPathRaw = compile("/user/:id");'
  @State message6: string = this.getResourceString($r('app.string.Raw_data')) + '：toPathRaw({ id: "%3A%2F" });'
  @State message7: string = this.getResourceString($r('app.string.Raw_data')) + '：toPathRaw({ id: ":/" }, { validate: false });'
  @State message8: string = this.getResourceString($r('app.string.Raw_data')) + '：const toPathRepeated = compile("/:segment+");'
  @State message9: string = this.getResourceString($r('app.string.Raw_data')) + '：toPathRepeated({ segment: "foo" });'
  @State message10: string = this.getResourceString($r('app.string.Raw_data')) + '：toPathRepeated({ segment: ["a", "b", "c"] });'
  @State message11: string = this.getResourceString($r('app.string.Raw_data')) + '：const toPathRegexp = compile("/user/:id(\\d+)");'
  @State message12: string = this.getResourceString($r('app.string.Raw_data')) + '：toPathRegexp({ id: 123 });'
  @State message13: string = this.getResourceString($r('app.string.Raw_data')) + '：toPathRegexp({ id: "123" });'
  @State message14: string = this.getResourceString($r('app.string.Raw_data')) + '：toPathRegexp({ id: "abc" });'
  @State message15: string = this.getResourceString($r('app.string.Raw_data')) + '：toPathRegexp({ id: "abc" }, { validate: false });'

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
          .margin({
            top: 5
          })

        Text(this.message2)
          .fontSize(16)
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
          .backgroundColor(Color.Grey)
          .backgroundColor('#66E1E1E1')
          .fontColor(Color.Black)
          .margin({
            top: 5
          })

        Text(this.message3)
          .fontSize(16)
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
          .backgroundColor(Color.Grey)
          .backgroundColor('#66E1E1E1')
          .fontColor(Color.Black)
          .margin({
            top: 5
          })

        Text(this.message4)
          .fontSize(16)
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
          .backgroundColor(Color.Grey)
          .backgroundColor('#66E1E1E1')
          .fontColor(Color.Black)
          .margin({
            top: 5
          })


        Text(this.message5)
          .fontSize(16)
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
          .backgroundColor(Color.Grey)
          .backgroundColor('#66E1E1E1')
          .fontColor(Color.Black)
          .margin({
            top: 5
          })

        Text(this.message6)
          .fontSize(16)
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
          .backgroundColor(Color.Grey)
          .backgroundColor('#66E1E1E1')
          .fontColor(Color.Black)
          .margin({
            top: 5
          })


        Text(this.message7)
          .fontSize(16)
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
          .backgroundColor(Color.Grey)
          .backgroundColor('#66E1E1E1')
          .fontColor(Color.Black)
          .margin({
            top: 5
          })

        Text(this.message8)
          .fontSize(16)
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
          .backgroundColor(Color.Grey)
          .backgroundColor('#66E1E1E1')
          .fontColor(Color.Black)
          .margin({
            top: 5
          })

        Text(this.message9)
          .fontSize(16)
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
          .backgroundColor(Color.Grey)
          .backgroundColor('#66E1E1E1')
          .fontColor(Color.Black)
          .margin({
            top: 5
          })

        Text(this.message10)
          .fontSize(16)
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
          .backgroundColor(Color.Grey)
          .backgroundColor('#66E1E1E1')
          .fontColor(Color.Black)
          .margin({
            top: 5
          })


        Text(this.message11)
          .fontSize(16)
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
          .backgroundColor(Color.Grey)
          .backgroundColor('#66E1E1E1')
          .fontColor(Color.Black)
          .margin({
            top: 5
          })


        Text(this.message12)
          .fontSize(16)
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
          .backgroundColor(Color.Grey)
          .backgroundColor('#66E1E1E1')
          .fontColor(Color.Black)
          .margin({
            top: 5
          })

        Text(this.message13)
          .fontSize(16)
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
          .backgroundColor(Color.Grey)
          .backgroundColor('#66E1E1E1')
          .fontColor(Color.Black)
          .margin({
            top: 5
          })


        Text(this.message14)
          .fontSize(16)
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
          .backgroundColor(Color.Grey)
          .backgroundColor('#66E1E1E1')
          .fontColor(Color.Black)
          .margin({
            top: 5
          })

        Text(this.message15)
          .fontSize(16)
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
          .backgroundColor(Color.Grey)
          .backgroundColor('#66E1E1E1')
          .fontColor(Color.Black)
          .margin({
            top: 5
          })

        Button($r('app.string.Start_convert'))
          .backgroundColor(Color.Blue)
          .fontColor(Color.White)
          .width('80%')
          .height(100)
          .margin({
            top: 5
          })
          .onClick((event) => {
            let api = new TestApi()
            let result = api.compileTest()
            if (!result || result.length < 12) {
              promptAction.showToast({
                message: $r('app.string.The_data_processing_results_do_not_match_expectations'),
                duration: 6000
              })
              return;
            }
            let bean = new CommonResultBean();
            let arrBefore = new Array<string>();
            arrBefore.push('toPath({ id: 123 }) ' + this.getResourceString($r('app.string.Expected_results')) + ': \r\n ' + `/user/123`);
            arrBefore.push('toPath({ id: "café" }) ' + this.getResourceString($r('app.string.Expected_results')) + ': \r\n ' + `/user/caf%C3%A9`);
            arrBefore.push('toPath({ id: "/" }) ' + this.getResourceString($r('app.string.Expected_results')) + ': \r\n ' + `/user/%2F`);
            arrBefore.push('toPath({ id: ":/" }) ' + this.getResourceString($r('app.string.Expected_results')) + ': \r\n ' + `/user/%3A%2F`);
            arrBefore.push('toPathRaw({ id: "%3A%2F" }) ' + this.getResourceString($r('app.string.Expected_results')) + ': \r\n ' + `/user/%3A%2F`);
            arrBefore.push('toPathRaw({ id: ":/" }, { validate: false }) ' + this.getResourceString($r('app.string.Expected_results')) + ': \r\n ' + `/user/:/`);
            arrBefore.push('toPathRepeated({ segment: "foo" }) ' + this.getResourceString($r('app.string.Expected_results')) + ': \r\n ' + `/foo`);
            arrBefore.push('toPathRepeated({ segment: ["a", "b", "c"] }) ' + this.getResourceString($r('app.string.Expected_results')) + ': \r\n ' + `/a/b/c`);
            arrBefore.push('toPathRegexp({ id: 123 }) ' + this.getResourceString($r('app.string.Expected_results')) + ': \r\n ' + `/user/123`);
            arrBefore.push('toPathRegexp({ id: "123" }) ' + this.getResourceString($r('app.string.Expected_results')) + ': \r\n ' + `/user/123`);
            arrBefore.push('toPathRegexp({ id: "abc" }, { validate: false }) ' + this.getResourceString($r('app.string.Expected_results')) + ': \r\n ' + `/user/abc`);
            arrBefore.push('toPathRegexp({ id: "abc" }) ' + this.getResourceString($r('app.string.Expected_results')) + ': \r\n ' + `Throws TypeError`);
            bean.setBefore(arrBefore);
            let arrAfter = new Array<string>();
            arrAfter.push(JSON.stringify(result[0]));
            arrAfter.push(JSON.stringify(result[1]));
            arrAfter.push(JSON.stringify(result[2]));
            arrAfter.push(JSON.stringify(result[3]));
            arrAfter.push(JSON.stringify(result[4]));
            arrAfter.push(JSON.stringify(result[5]));
            arrAfter.push(JSON.stringify(result[6]));
            arrAfter.push(JSON.stringify(result[7]));
            arrAfter.push(JSON.stringify(result[8]));
            arrAfter.push(JSON.stringify(result[9]));
            arrAfter.push(JSON.stringify(result[10]));
            arrAfter.push(JSON.stringify(result[11]));
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
      .height('100%')
    }
    .width('100%')
    .height('100%')
  }
}