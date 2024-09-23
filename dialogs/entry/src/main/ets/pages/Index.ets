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

  @Builder
  buildButton(text1: string, page1: string, text2: string|null, page2: string|null) {
    Row({ space: 10 }) {
      Button(text1)
        .layoutWeight(1)
        .onClick(() => {
          let path = 'pages/' + page1
          console.log("jump:" + path);
          router.pushUrl({
            url: path,
          })
        })

      if (text2) {
        Button(text2)
          .layoutWeight(1)
          .onClick(() => {
            let path = 'pages/' + page2
            console.log("jump:" + path);
            router.pushUrl({
              url: path,
            })
          })
      }
    }.width('100%').justifyContent(FlexAlign.Center).padding({ left: 10, right: 10 })
  }

  build() {
    Column({ space: 20 }) {
      this.buildButton(getContext().resourceManager.getStringByNameSync('Index_Button_String1') , 'Confirm', getContext().resourceManager.getStringByNameSync('Index_Button_String2'), 'InputContent')
      this.buildButton(getContext().resourceManager.getStringByNameSync('Index_Button_String3'), 'ListSelect', getContext().resourceManager.getStringByNameSync('Index_Button_String4'), 'Loading')
      this.buildButton(getContext().resourceManager.getStringByNameSync('Index_Button_String5'), 'BottomListDialogExample', getContext().resourceManager.getStringByNameSync('Index_Button_String6'), 'BottomScrollDialogExample')
      this.buildButton(getContext().resourceManager.getStringByNameSync('Index_Button_String7'), 'BottomTextDialogExample', getContext().resourceManager.getStringByNameSync('Index_Button_String8'), 'PopupButtonExample')
      this.buildButton(getContext().resourceManager.getStringByNameSync('Index_Button_String9'), 'FullScreen', getContext().resourceManager.getStringByNameSync('Index_Button_String10'), 'Message')
      this.buildButton(getContext().resourceManager.getStringByNameSync('Index_Button_String11'), 'TopContent', getContext().resourceManager.getStringByNameSync('Index_Button_String12'), 'RealtimeInput')
      this.buildButton(getContext().resourceManager.getStringByNameSync('Index_Button_String13'), 'SideBarContainerExample', getContext().resourceManager.getStringByNameSync('Index_Button_String14'), 'PositionContent')
      this.buildButton(getContext().resourceManager.getStringByNameSync('Index_Button_String15'), 'ImageBrowser', null, null)
    }
    .backgroundColor(Color.White).margin({ top: 20 })
  }
}