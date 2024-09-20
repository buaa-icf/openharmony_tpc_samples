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
import {  Key } from 'path-to-regexp';

@Entry
@Component
struct PathToRegexpPage {
  @State message0: string = this.getResourceString($r('app.string.Raw_data')) + '：const keys = [];'
  @State message1: string = this.getResourceString($r('app.string.Raw_data')) + '：const regexp = pathToRegexp("/foo/:bar", keys);'

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

        Button($r('app.string.Start_convert'))
          .backgroundColor(Color.Blue)
          .fontColor(Color.White)
          .width('80%')
          .height(100)
          .onClick((event) => {
            const keys:Key[] = [];
            let api = new TestApi()
            let result = api.pathToRegexpTest("/foo/:bar", keys)
            if (!result) {
              promptAction.showToast({
                message: $r('app.string.The_data_processing_results_do_not_match_expectations'),
                duration: 6000
              })
              return;
            }
            let bean = new CommonResultBean();
            let arrBefore = new Array<string>();
            arrBefore.push(`regexp  ${this.getResourceString($r('app.string.Expected_results'))}: ${'\r\n'} ${`/^\/foo(?:\/([^\/#\?]+?))[\/#\?]?$/i`}`);
            arrBefore.push(`keys   ${this.getResourceString($r('app.string.Expected_results'))}: ${'\r\n'}  ${`[{ name: 'bar', prefix: '/', suffix: '', pattern: '[^\\/#\\?]+?', modifier: '' }]`}`);
            bean.setBefore(arrBefore);
            let arrAfter = new Array<string>();
            arrAfter.push(result.toString());
            arrAfter.push(JSON.stringify(keys));
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