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

import router from '@ohos.router';
import { emitter } from '@kit.BasicServicesKit';
import { promptAction } from '@kit.ArkUI';

@Entry
@Component
struct Index{
  private multiAnimationClosed = true;

  build() {
    Scroll() {
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
          Button("测试普通动画")
            .onClick(() => {
              router.pushUrl({ url: "pages/GeneralAnimation" });
            }).margin({ top: 15 })
        }.width('100%').height(60)

        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
          Button("测试融合动画")
            .onClick(() => {
              router.pushUrl({ url: "pages/VAPXAnimation" });
            }).margin({ top: 15 })
        }.width('100%').height(60)

        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
          Button("测试新监听")
            .onClick(() => {
              router.pushUrl({ url: "pages/NewOn" });
            }).margin({ top: 15 })
        }.width('100%').height(60)

        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
          Button("测试多动画")
            .onClick(() => {
              emitter.on("multiAnimationClosed", () => {
                this.multiAnimationClosed = true;
              })
              if (!this.multiAnimationClosed) {
                this.getUIContext().getPromptAction().showToast({ message: "Please wait", duration: 300 })
                return;
              }
              this.multiAnimationClosed = false;
              router.pushUrl({ url: "pages/MultiAnimation" });
            }).margin({ top: 15 })
        }.width('100%').height(60)

        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
          Button("测试异步停止")
            .onClick(() => {
              router.pushUrl({ url: "pages/AsyncStopDemo" });
            }).margin({ top: 15 })
        }.width('100%').height(60)

        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
          Button("测试并行停止")
            .onClick(() => {
              router.pushUrl({ url: "pages/ParallelStopDemo" });
            }).margin({ top: 15 })
        }.width('100%').height(60)

        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
          Button("测试播放时创建销毁XComponent")
            .onClick(() => {
              router.pushUrl({ url: "pages/DestroyXComponent" });
            }).margin({ top: 15 })
        }.width('100%').height(60)
      }.backgroundColor(Color.Pink)
      .margin(10)
      .padding(20)
      .borderRadius(10)
    }
    .width('100%')
    .height('100%')
  }
}
