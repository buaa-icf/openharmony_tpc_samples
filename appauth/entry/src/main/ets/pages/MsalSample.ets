/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
 *
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

@Entry
@Component
struct MsalSample {
  controller: WebController = new WebController();
  @State mode:MixedMode = MixedMode.All
  build() {
    Row() {
      Column() {
        Web({ src: 'https://test.chenyu520.cn', controller: this.controller })
          .javaScriptAccess(true)
          .imageAccess(true)
          .mixedMode(this.mode)
          .onConsole((event) => {
            console.log('getMessage:' + event.message.getMessage());
            console.log('getSourceId:' + event.message.getSourceId());
            console.log('getLineNumber:' + event.message.getLineNumber());
            console.log('getMessageLevel:' + event.message.getMessageLevel());
            return false;
          })
          .onAlert((event) => {
            AlertDialog.show({
              title: 'ArkTs-Msal',
              message: event.message,
              primaryButton: {
                value: 'cancel',
                action: () => {
                  event.result.handleCancel()
                }
              },
              secondaryButton: {
                value: 'ok',
                action: () => {
                  event.result.handleConfirm()
                }
              },
              cancel: () => {
                event.result.handleCancel()
              }
            })
            return true
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}

