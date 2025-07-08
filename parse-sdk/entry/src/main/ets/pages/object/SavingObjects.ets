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

import { promptAction } from '@kit.ArkUI'
import { ParseObject } from '@ohos/parser-sdk'

@Entry
@Component
struct SavingObjects {
  @State userName: string = ''
  @State userPassword: string = ''
  @State userEmail: string = ''

  build() {
    Column({ space: 20 }) {
      Text('Let’s say you want to save the Users described above to the Parse Cloud.')

      TextInput({ placeholder: '请输入用户名', text: this.userName })
        .borderRadius(4)
        .onChange((val) => {
          this.userName = val
        })

      TextInput({ placeholder: '请输入密码', text: this.userPassword })
        .type(InputType.Password)
        .borderRadius(4)
        .onChange((val) => {
          this.userPassword = val
        })

      TextInput({ placeholder: '请输入邮箱', text: this.userEmail })
        .type(InputType.Email)
        .borderRadius(4)
        .onChange((val) => {
          this.userEmail = val
        })

      Button('保存')
        .width('100%')
        .borderRadius(4)
        .onClick(() => {
          if (this.userName !== '' && this.userPassword !== '') {
            const UserInfo: ESObject = ParseObject.extend("UserInfo");
            const info: ESObject = new UserInfo();
            info.save({
              userName: this.userName,
              userPassword: this.userPassword,
              userEmail: this.userEmail
            }).then((info: ESObject) => {
              console.log('HMLog-->', JSON.stringify(info))
              this.userName = ''
              this.userPassword = ''
              this.userEmail = ''
              promptAction.showToast({ message: '保存成功' })
            }).catch((err: ESObject) => {
              promptAction.showToast({ message: '保存失败' })
              console.log('HMLog-->', JSON.stringify(err))
            })
          } else {
            promptAction.showToast({ message: '请填写用户名和密码' })
          }
        })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .padding(20)
  }
}