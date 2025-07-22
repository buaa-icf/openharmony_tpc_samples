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

import { IndexedDBStorageController, Parse, ParseSession } from '@ohos/parser-sdk'

@Entry
@Component
struct Session {
  account: string = ''
  password: string = ''
  ip: string = ''
  email: string = ''
  dbStorageController = new IndexedDBStorageController()
  @State message: string = ''
  @State sessionList: Array<ESObject> = [];
  userId: string | undefined = ''

  handleParseError(err: ESObject) {
    switch (err.code) {
      case Parse.Error.INVALID_SESSION_TOKEN:
        Parse.User.logOut()
        break;
    }
  }

  build() {
    Scroll() {
      Column({ space: 20 }) {
        Text(this.message)
          .fontSize(16)

        TextInput({ placeholder: '请输入账号', text: 'admin' })
          .borderRadius(4)
          .onChange((val) => {
            this.account = val
          })

        TextInput({ placeholder: '请输入密码', text: '123123' })
          .borderRadius(4)
          .onChange((val) => {
            this.password = val
          })

        TextInput({ placeholder: '请输入邮箱', text: 'email@example.com' })
          .borderRadius(4)
          .onChange((val) => {
            this.email = val
          })

        TextInput({ placeholder: '请输入IP', text: '192.168.0.2' })
          .borderRadius(4)
          .onChange((val) => {
            this.ip = val
          })

        Button('登录')
          .borderRadius(4)
          .type(ButtonType.Normal)
          .width('100%')
          .onClick(async () => {
            this.message = ''
            try {
              const loggedInUser = await Parse.User.logIn(this.account, this.password, { usePost: false });
              this.userId = loggedInUser.id
              this.message = '登录成功:' + loggedInUser.id
            } catch (e) {
              this.message = '登录失败:' + JSON.stringify(e)
            }
          })


        Button('获取当前用户 Session')
          .borderRadius(4)
          .type(ButtonType.Normal)
          .width('100%')
          .onClick(async () => {
            this.message = ''
            try {
              const currentUser = Parse.User.current();
              if (currentUser) {
                const sessionToken = currentUser.getSessionToken(); // 获取 Session Token
                this.message = `当前用户 ID: ${currentUser.id}, Session Token: ${sessionToken}`;

                // 检查 Session 是否可撤销
                const isRevocable = ParseSession.isCurrentSessionRevocable();
                this.message += `\nSession 是否可撤销: ${isRevocable}`;
              } else {
                this.message = '当前无登录用户';
              }
            } catch (e) {
              this.message = '获取当前用户 Session 失败:' + JSON.stringify(e) + '\r\n\r\n'
              this.handleParseError(e);
            }
          })

        Button('使用 Session Token 登录')
          .borderRadius(4)
          .type(ButtonType.Normal)
          .width('100%')
          .onClick(async () => {
            this.message = ''
            try {
              const currentUser = Parse.User.current();
              if (currentUser) {
                const sessionToken = currentUser.getSessionToken(); // 获取 Session Token
                this.message = `当前用户 ID: ${currentUser.id}, Session Token: ${sessionToken}`;

                // Parse.User.logOut()

                const user = await Parse.User.become(sessionToken);
                this.message = `使用Session Token 登录成功，当前用户ID: ${user.id}`
              } else {
                this.message = '当前无登录用户';
              }
            } catch (e) {
              this.message = '使用 Session Token 登录 失败:' + JSON.stringify(e) + '\r\n\r\n'
              this.handleParseError(e);
            }
          })

        Button('查看我的设备')
          .borderRadius(4)
          .type(ButtonType.Normal)
          .width('100%')
          .onClick(async () => {
            try {
              this.sessionList = await new Parse.Query(Parse.Session).find();
              this.message = `找到 ${this.sessionList.length} 个活跃设备`;
            } catch (e) {
              this.message = '查询失败: ' + e.message;
            }
          })

        Button('踢出其他设备')
          .borderRadius(4)
          .type(ButtonType.Normal)
          .width('100%')
          .onClick(async () => {
            try {
              const current = await Parse.Session.current();
              const others = await new Parse.Query(Parse.Session)
                .notEqualTo('objectId', current.id)
                .find();
              await Parse.Object.destroyAll(others);
              this.message = `已踢出 ${others.length} 个设备`;
            } catch (e) {
              this.message = '操作失败: ' + e.message;
            }
          })

        Button('检查会话有效期')
          .borderRadius(4)
          .type(ButtonType.Normal)
          .width('100%')
          .onClick(async () => {
            const session = await Parse.Session.current();
            this.message = `会话到期时间: ${session.get('expiresAt')}`;
          })

        Button('退出登陆')
          .borderRadius(4)
          .type(ButtonType.Normal)
          .width('100%')
          .onClick(async () => {
            this.message = ''
            try {
              await Parse.User.logOut();
              this.message = '退出登陆成功'
            } catch (e) {
              this.message = '退出登陆失败:' + JSON.stringify(e)
            }
          })
      }
      .margin(10)
    }
    .width('100%')
    .height('100%')
  }
}