/*
 * Copyright (C) 2023 Huawei Device Co., Ltd.
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

import promptAction from '@ohos.promptAction'
import router from '@ohos.router'
import fs from '@ohos.file.fs';
import GlobalObj from '../GlobalObj'
import { getResourceStr } from './GetResourceStr';

@Entry
@Component
struct CommandPage {
  @State message: string = 'Hello World'
  @State from: string = ''
  @State to: string = ''
  @State cc: string = ''
  @State bcc: string = ''
  @State subject: string = ''
  @State listData: Array<string> = []
  @State mailType: string = '@qq.com'
  @State textValue: string = ''
  @State inputValue: string = 'click me'

  async aboutToDisappear() {
    await GlobalObj?.getInstance()?.getClient()?.QUIT()
  }

  showToast(text: string, name = getResourceStr($r("app.string.Test"))) {
    console.log(`zdy---${name}--->${text}`)
    promptAction.showToast({
      message: text,
      duration: 2000,
      bottom: 50
    })
  }

  aboutToAppear() {
    let params = router.getParams()
    let testParam = params as Record<string,Object>
    if (testParam && testParam['sendCount'] && typeof testParam['sendCount'] === 'string') {
      this.from = testParam['sendCount'];
    }
  }

  build() {
    Row() {
      Column() {
        Scroll() {
          Flex({
            alignItems: ItemAlign.Center,
            justifyContent: FlexAlign.Center,
            alignContent: FlexAlign.Center,
            direction: FlexDirection.Row
          }) {
            Flex({
              alignItems: ItemAlign.Start,
              justifyContent: FlexAlign.Start,
              alignContent: FlexAlign.Start,
              direction: FlexDirection.Row
            }) {
              Button($r("app.string.STAT_command"))
                .margin(20)
                .height(50)
                .backgroundColor(Color.Blue)
                .fontColor(Color.White)
                .onClick(() => {
                  this.sendMail()
                })
                .margin({ top: 10 })

              Button($r("app.string.LIST_command"))
                .margin(20)
                .height(50)
                .backgroundColor(Color.Blue)
                .fontColor(Color.White)
                .onClick(() => {
                  this.sendMail()
                })
                .margin({ top: 10 })
              Button($r("app.string.TOP_command"))
                .margin(20)
                .height(50)
                .backgroundColor(Color.Blue)
                .fontColor(Color.White)
                .onClick(() => {
                  this.sendMail()
                })
                .margin({ top: 10 })
              Button($r("app.string.UIDL_command"))
                .margin(20)
                .height(50)
                .backgroundColor(Color.Blue)
                .fontColor(Color.White)
                .onClick(() => {
                  this.sendMail()
                })
                .margin({ top: 10 })
              Button($r("app.string.LAST_Command"))
                .margin(20)
                .height(50)
                .backgroundColor(Color.Blue)
                .fontColor(Color.White)
                .onClick(() => {
                  this.sendMail()
                })
                .margin({ top: 10 })

              Button($r("app.string.NOOP_command"))
                .margin(20)
                .height(50)
                .backgroundColor(Color.Blue)
                .fontColor(Color.White)
                .onClick(() => {
                  this.sendMail()
                })
                .margin({ top: 10 })

              Button($r("app.string.DELE_command"))
                .margin(20)
                .height(50)
                .backgroundColor(Color.Blue)
                .fontColor(Color.White)
                .onClick(() => {
                  this.sendMail()
                })
                .margin({ top: 10 })

              Button($r("app.string.RSET_command"))
                .margin(20)
                .height(50)
                .backgroundColor(Color.Blue)
                .fontColor(Color.White)
                .onClick(() => {
                  this.sendMail()
                })
                .margin({ top: 10 })

              Button($r("app.string.RETR_command"))
                .margin(20)
                .height(50)
                .backgroundColor(Color.Blue)
                .fontColor(Color.White)
                .onClick(() => {
                  this.sendMail()
                })
                .margin({ top: 10 })

              Button($r("app.string.QUIT_command"))
                .margin(20)
                .height(50)
                .backgroundColor(Color.Blue)
                .fontColor(Color.White)
                .onClick(() => {
                  this.sendMail()
                })
                .margin({ top: 10 })
            }.layoutWeight(1).height('100%')


            List({ space: 10, initialIndex: 0 }) {
              ForEach(this.listData, (item: string, index: number) => {
                ListItem() {
                  Text(item)
                    .fontSize(14)
                    .padding(5)
                    .textAlign(TextAlign.Center)
                }
                .borderWidth(2)
                .borderColor(Color.Gray)
              }, (item: string, index: number) => item)
            }
            .edgeEffect(EdgeEffect.None)
            .chainAnimation(false)
            .layoutWeight(2)
            .height('100%')
            .listDirection(Axis.Horizontal)

          }
        }.width('100%')
        .height('100%')
      }
      .width('100%')
    }
    .height('100%')
  }

  async sendMail() {
    try {
      if (GlobalObj?.getInstance()?.getClient()) {

      } else {
        this.showToast(getResourceStr($r("app.string.Please_login_again")), 'sendmail-smtp')
      }

    } catch (err) {
      this.showToast(`${getResourceStr($r("app.string.Email_sening_error"))}${err.message}`, 'sendmail-smtp')
    }
  }
}