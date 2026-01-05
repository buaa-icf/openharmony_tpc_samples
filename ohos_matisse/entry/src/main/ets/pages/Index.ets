/*
 * Copyright (C) 2025 Huawei Device Co., Ltd.
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

import router from '@ohos.router';
import { ImageSelectionManager } from '../utils/ImageSelectionManager';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  @State imageUrls: string[] = [];
  @State imagePaths: string[] = [];

  onPageShow() {
    const imageManager: ImageSelectionManager = ImageSelectionManager.getInstance();
    const savedUrls: string[] = imageManager.getImageUrls();
    const savedPaths: string[] = imageManager.getImagePaths();
    if (savedUrls.length > 0 && savedPaths.length > 0) {
      this.imageUrls = savedUrls;
      this.imagePaths = savedPaths;
      imageManager.clearAll();
    }
  }

  build() {
    Column() {
      Column() {
        Button('Zhihu')
          .id('zhihu')
          .width('100%')
          .height(56)
          .margin({
            left: $r('app.float.item_margin_horizontal'),
            right: $r('app.float.item_margin_horizontal'),
            top: 8
          })
          .fontColor(Color.White)
          .onClick((event: ClickEvent) => {
            this.startAction('zhihu');
          })

        Button('Dracula')
          .id('dracula')
          .width('100%')
          .height(56)
          .margin({
            left: $r('app.float.item_margin_horizontal'),
            right: $r('app.float.item_margin_horizontal'),
            top: 16
          })
          .fontColor(Color.White)
          .onClick((event: ClickEvent) => {
            this.startAction('dracula');
          })

        Button('OnlyGif')
          .id('only_gif')
          .width('100%')
          .height(56)
          .margin({
            left: $r('app.float.item_margin_horizontal'),
            right: $r('app.float.item_margin_horizontal'),
            top: 16,
            bottom: 32
          })
          .fontColor(Color.White)
          .onClick((event: ClickEvent) => {
            this.startAction('only_gif');
          })

        Text($r('app.string.app_name'))
          .width('100%')
          .height(56)
          .padding({ left: $r('app.float.item_margin_horizontal') })
          .fontSize(22)
          .fontColor(Color.Black)
          .textAlign(TextAlign.Start)
      }
      .width('100%')
      .padding(0)
      .backgroundColor(Color.White)
      .shadow({ radius: 4 })

      List() {
        ForEach(this.imageUrls, (url: string, index: number) => {
          ListItem() {
            Column() {
              Text(url)
                .fontSize(16)
                .fontColor(Color.Black)
                .textAlign(TextAlign.Start)
                .width('100%')
                .margin({ bottom: 8 })
              Text(this.imagePaths[index])
                .fontSize(16)
                .fontColor(Color.Black)
                .textAlign(TextAlign.Start)
                .width('100%')
                .margin({ bottom: 8 })
            }
            .padding(16)
            .backgroundColor(Color.White)
            .borderRadius(8)
            .margin({ bottom: 12 })
          }
        })
      }
      .id('recyclerview')
      .width('100%')
      .layoutWeight(1)
      .backgroundColor($r('app.color.list_bg'))
      .clip(false)
      .padding({ top: 16, bottom: 16 })
    }
    .width('100%')
    .height('100%')
  }

  startAction(index: string) {
    // 正确写法：将字符串作为对象属性传递
    router.pushUrl({
      url: 'pages/SampleActivity',
      params: { message: index } // 字符串包装在对象中
    })

  }
}