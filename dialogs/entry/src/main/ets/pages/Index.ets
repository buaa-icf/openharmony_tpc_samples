/*
 * Copyright (C) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
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

  private pageList: string[] = [
    'SideBarContainerExample',
    'Confirm',
    'InputContent',
    'ListSelect',
    'Loading',
    'PositionContent',
    'FullScreen',
    'RealtimeInput',
    'Message',
    'PopupButtonExample',
    'TopContent',
    'BottomScrollDialogExample',
    'BottomTextDialogExample',
    'BottomListDialogExample',
    'ImageBrowser',
    'RepeatContent',
    'AnimateInputContent',
    'AnimateContent'
  ]


  @Builder buildPage(page: string) {
    Text(page)
      .width('100%')
      .height(60)
      .fontColor(Color.White)
      .fontSize(30)
      .textAlign(TextAlign.Center)
      .margin({ top: 10 })
      .onClick(() => {
        let path = 'pages/' + page
        console.log("jump:" + path);
        router.pushUrl({
          url: path,
        })
      })
  }

  build() {
    Flex({ direction: FlexDirection.Column }) {
      ForEach(this.pageList, (page) => {
        this.buildPage(page)
      })
    }
    .backgroundColor(Color.Black)
  }
}