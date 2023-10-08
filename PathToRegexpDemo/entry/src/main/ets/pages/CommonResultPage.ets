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

import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import CommonResultBean from '../CommonResultBean';

@Entry
@Component
struct CommonResultPage {
  @State message: string = 'Hello World'
  @State beforeIndex: Array<number> = new Array<number>();
  @State beforeStr: Array<string> = new Array<string>();
  @State afterIndex: Array<number> = new Array<number>();
  @State afterStr: Array<string> = new Array<string>();

  aboutToAppear() {
    interface RouterParams{
      dataObj:CommonResultBean
    }
    let data: CommonResultBean | null = null;
    // let dataObj:string='dataObj'
    if (router.getParams() &&(router.getParams() as RouterParams).dataObj) {
      data = (router.getParams() as RouterParams).dataObj;
      this.beforeStr = data?.beforeStr ? data?.beforeStr : [];
      this.afterStr = data?.afterStr ? data?.afterStr : [];
      this.beforeIndex = new Array<number>()
      this.afterIndex = new Array<number>()
      for (let index = 0; index < this.beforeStr.length; index++) {
        this.beforeIndex.push(index);
      }
      for (let index = 0; index < this.afterStr.length; index++) {
        this.afterIndex.push(index);
      }
    }

    if (!data || this.beforeIndex.length === 0 || this.afterIndex.length === 0 || this.beforeIndex.length != this.afterIndex.length) {
      promptAction.showDialog({
        title: '是否关闭本页面',
        message: '由于数据不正确，是否关闭本页面',
        buttons: [
          {
            text: '是',
            color: '#4455FF'
          },
          {
            text: '否',
            color: '#4455FF'
          }
        ]
      }, (err, result) => {
        if (err || !result) {
          return
        }
        if (result.index === 0) {
          router.back({
            url: 'pages/Index'
          })
        } else {

        }
      })
    }
  }

  build() {
    Row() {
      Column() {
        Flex({ direction: FlexDirection.Row }) {
          List({ space: 5, initialIndex: 0 }) {
            ForEach(this.beforeIndex, (item:string) => {
              ListItem() {
                Text(this.beforeStr[item])
                  .width('100%')
                  .height(100)
                  .fontSize(16)
                  .textAlign(TextAlign.Center)
              }
            }, (item:string) => item)
          }
          .listDirection(Axis.Vertical)
          .divider({ strokeWidth: 2 })
          .edgeEffect(EdgeEffect.None)
          .chainAnimation(false)
          .width('50%')
          .height('100%')

          List({ space: 5, initialIndex: 0 }) {
            ForEach(this.afterIndex, (item:string) => {
              ListItem() {
                Text('转换后： \r\n' + this.afterStr[item])
                  .width('100%')
                  .height(100)
                  .fontSize(16)
                  .textAlign(TextAlign.Center)
                  .borderRadius(10)
              }
            }, (item:string) => item)
          }
          .listDirection(Axis.Vertical)
          .divider({ strokeWidth: 2 })
          .edgeEffect(EdgeEffect.None)
          .chainAnimation(false)
          .width('50%')
          .height('100%')
        }.width('100%')
        .height('100%')
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
  }
}