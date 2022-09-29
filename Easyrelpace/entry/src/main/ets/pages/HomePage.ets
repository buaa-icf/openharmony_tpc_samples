/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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
import router from '@system.router';

@Entry
@Component
struct Index {
  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Flex({ direction: FlexDirection.Column }) {
        Button('index', { type: ButtonType.Normal, stateEffect: true })
          .onClick(() => {
            router.push({ uri: "pages/index", })
          })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .width(90)
          .margin({ top: "10" })
        Button('third', { type: ButtonType.Normal, stateEffect: true })
          .onClick(() => {
            router.push({ uri: "pages/third", })
          })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .width(90)
          .margin({ top: "10" })
        Button('space', { type: ButtonType.Normal, stateEffect: true })
          .onClick(() => {
            router.push({ uri: "pages/space", })
          })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .width(90)
          .margin({ top: "10" })
        Button('Complicated', { type: ButtonType.Normal, stateEffect: true })
          .onClick(() => {
            router.push({ uri: "pages/Complicated", })
          })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .width(90)
          .margin({ top: "10" })
        Button('completes', { type: ButtonType.Normal, stateEffect: true })
          .onClick(() => {
            router.push({ uri: "pages/completes", })
          })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .width(90)
          .margin({ top: "10" })
      }
    }
    .width('100%')
    .height('100%')
  }
}
