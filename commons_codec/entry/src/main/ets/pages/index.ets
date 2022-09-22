/*
 * Copyright (C) 2021 Huawei Device Co., Ltd.
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
import router from '@system.router'

@Entry
@Component
struct Index {
  build() {
    Column() {
      Button() {
        Text('二进制编码器')
          .fontSize(15)
          .fontColor('#ffffff')
      }
      .type(ButtonType.Capsule)
      .width(100)
      .height(50)
      .margin(5)
      .align(Alignment.Center)
      .onClick(() => {

        router.push({ uri: 'pages/binary' })
      })

      Button() {
        Text('摘要编码器')
          .fontSize(15)
          .fontColor('#ffffff')
      }
      .type(ButtonType.Capsule)
      .width(100)
      .height(50)
      .margin(5)
      .align(Alignment.Center)
      .onClick(() => {
        router.push({ uri: 'pages/digest' })
      })

      Button() {
        Text('语言编码器')
          .fontSize(15)
          .fontColor('#ffffff')
      }
      .type(ButtonType.Capsule)
      .width(100)
      .height(50)
      .margin(5)
      .align(Alignment.Center)
      .onClick(() => {
        router.push({ uri: 'pages/language' })
      })


      // URL编码
      Button() {
        Text('Url编码器')
          .fontSize(15)
          .fontColor('#ffffff')
      }
      .type(ButtonType.Capsule)
      .width(100)
      .height(50)
      .margin(5)
      .align(Alignment.Center)
      .onClick(() => {
        router.push({ uri: 'pages/urlEncoding' })
      })

//      Image($r('app.media.sm'))
//        .objectFit(ImageFit.Contain)
//        .width(350)
//        .height(250)
//        .onComplete((event: {
//          width: number,
//          height: number
//        }) => {
//          console.log('load image, width:' + event.width)
//          console.log('load image, height:' + event.height)
//        })
//        .onError(() => {
//          console.log('load image fail')
//        })




    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)

  }
}