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
import { Parse } from '@ohos/parser-sdk';

@Entry
@Component
struct LinkUser {
  @State message: string = '';
  @State providerName: string = 'custom'; // 默认自定义绑定类型
  @State externalId: string = 'external_123'; // 外部账号ID

  build() {
    Scroll() {
      Column({ space: 15 }) {
        Text(this.message)
          .fontSize(16)

        TextInput({ placeholder: '输入绑定类型', text: this.providerName })
          .onChange((val) => { this.providerName = val; })

        TextInput({ placeholder: '输入外部账号ID', text: this.externalId })
          .onChange((val) => { this.externalId = val; })

        Button('绑定第三方账号')
          .borderRadius(4)
          .type(ButtonType.Normal)
          .width('100%')
          .onClick(async () => {
            try {
              const user = Parse.User.current();
              if (!user) throw new Error('请先登录');

              await user.linkWith(this.providerName, {
                authData: { id: this.externalId }
              });
              this.message = `成功绑定 ${this.providerName} 账号`;
            } catch (e) {
              this.message = `绑定失败: ${e.message}`;
            }
          })

        Button('检查账号绑定状态')
          .borderRadius(4)
          .type(ButtonType.Normal)
          .width('100%')
          .onClick(() => {
            const user = Parse.User.current();
            if (!user) {
              this.message = '请先登录';
              return;
            }
            const isLinked = user._isLinked(this.providerName);
            this.message = `${this.providerName}, 绑定状态: ${isLinked ? '已绑定' : '未绑定'}`;
          })

        Button('解绑第三方账号')
          .borderRadius(4)
          .type(ButtonType.Normal)
          .width('100%')
          .onClick(async () => {
            try {
              const user = Parse.User.current();
              if (!user) throw new Error('请先登录');

              await user._unlinkFrom(this.providerName);
              this.message = `已解绑 ${this.providerName} 账号`;
            } catch (e) {
              this.message = `解绑失败: ${e.message}`;
            }
          })
      }.margin(10)
    }
  }
}