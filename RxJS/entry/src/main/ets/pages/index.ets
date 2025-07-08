/*
 * Copyright (C) 2024 Huawei Device Co., Ltd.
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

import router from '@ohos.router'

@Entry
@Component
struct Index {
  @Builder
  MyButton(content: string | Resource, eventType: number) {
    Button(content, { type: ButtonType.Normal })
      .borderRadius(5)
      .width(300)
      .fontColor('#ffffff')
      .fontSize(15)
      .padding({ top: 12, right: 6, bottom: 12, left: 6 })
      .margin({ top: 10, left: 10, right: 10 })
      .alignSelf(ItemAlign.Center)
      .onClick((event: ClickEvent) => {
        this.click(eventType);
      })
  }

  build() {
    Scroll() {
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
        this.MyButton($r("app.string.Create_operation"), 1)
        this.MyButton($r("app.string.Filtering_content"), 2)
        this.MyButton($r("app.string.Multicast_content"), 3)
        this.MyButton($r("app.string.Combined_content"), 4)
        this.MyButton($r("app.string.Incorrect_content"), 5)
        this.MyButton($r("app.string.Conditional_content"), 6)
        this.MyButton($r("app.string.Conversion_content"), 7)
        this.MyButton($r("app.string.Tool_content"), 8)
        this.MyButton($r("app.string.Scheduler_content"), 9)
      }
    }
    .width('100%')
    .height('100%')
  }

  click(eventType: number) {
    switch (eventType) {
      case 1:
        this.getUIContext()?.getRouter()?.pushUrl({ url: 'pages/create' })
        break;
      case 2:
        this.getUIContext()?.getRouter()?.pushUrl({ url: 'pages/filter' })
        break;
      case 3:
        this.getUIContext()?.getRouter()?.pushUrl({ url: 'pages/multicast' })
        break;
      case 4:
        this.getUIContext()?.getRouter()?.pushUrl({ url: 'pages/combine' })
        break;
      case 5:
        this.getUIContext()?.getRouter()?.pushUrl({ url: 'pages/error' })
        break;
      case 6:
        this.getUIContext()?.getRouter()?.pushUrl({ url: 'pages/condition' })
        break;
      case 7:
        this.getUIContext()?.getRouter()?.pushUrl({ url: 'pages/convert' })
        break;
      case 8:
        this.getUIContext()?.getRouter()?.pushUrl({ url: 'pages/tool' })
        break;
      case 9:
        this.getUIContext()?.getRouter()?.pushUrl({ url: 'pages/scheduler' })
        break;
    }
  }
}