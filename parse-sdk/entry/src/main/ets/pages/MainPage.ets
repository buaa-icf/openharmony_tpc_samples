/*
  * Copyright (c) 2025 Huawei Device Co., Ltd.
  *
  * Licensed under the Apache License, Version 2.0 (the "License");
  * you may not use this file except in compliance with the License.
  * You may obtain a copy of the License at
    *
  * http://www.apache.org/licenses/LICENSE-2.0
    *
  * Unless required by applicable law or agreed to in writing, software
  * distributed under the License is distributed on an "AS IS" BASIS,
  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  * See the License for the specific language governing permissions and
  * limitations under the License.
  */
import { Parse } from '@ohos/parser-sdk'
import { router } from '@kit.ArkUI'

@Entry
@Component
struct MainPage {
  @State appId: string = 'wahaha'
  @State jsKey: string = '123123'
  @State ip: string = '192.168.0.2'

  build() {
    Column({ space: 20 }) {
      Text('配置ApplicationId, JavaScriptKey 非必须, IP地址')

      TextInput({ placeholder: '请输入applicationId', text: this.appId })
        .borderRadius(6)
        .onChange((val) => {
          this.appId = val;
        })

      TextInput({ placeholder: '请输入JavaScriptKey', text: this.jsKey })
        .borderRadius(6)
        .onChange((val) => {
          this.jsKey = val;
        })

      TextInput({ placeholder: '请输入IP地址', text: this.ip })
        .borderRadius(6)
        .onChange((val) => {
          this.ip = val;
        })

      Button('确定')
        .type(ButtonType.Normal)
        .width('100%')
        .onClick(() => {
          Parse.initialize(this.appId, this.jsKey); // 使用你的 JavaScript Key
          Parse.serverURL = `http://${this.ip}:1337/parse`;
          router.replaceUrl({ url: 'pages/Index' })
        })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .padding(20)
  }
}