import { IndexedDBStorageController, Parse } from '@ohos/parser-sdk'

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

@Entry
@Component
struct User {
  account: string = ''
  password: string = ''
  ip: string = ''
  email: string = ''
  dbStorageController = new IndexedDBStorageController()
  @State message: string = ''
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

        Button('注册')
          .borderRadius(4)
          .type(ButtonType.Normal)
          .width('100%')
          .onClick(async () => {
            this.message = ''
            const user = new Parse.User();
            user.set('username', this.account);
            user.set('password', this.password);
            user.set('email', this.email);
            try {
              await user.signUp();
              this.message = '注册成功:' + JSON.stringify(user)
            } catch (e) {
              this.message = '注册失败:' + JSON.stringify(e)
            }
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

        Button('获取当前用户')
          .borderRadius(4)
          .type(ButtonType.Normal)
          .width('100%')
          .onClick(async () => {
            this.message = ''
            let currentUser: ESObject = null
            try {
              currentUser = Parse.User.current();
              this.message = '获取当前用户成功:' + currentUser?.id + '\r\n\r\n'
            } catch (e) {
              this.message = '获取当前用户失败:' + JSON.stringify(e) + '\r\n\r\n'
            }

            currentUser.set('email', 'updated@example.com');
            try {
              await currentUser.save();
              this.message += '用户更新成功 : ' + JSON.stringify(currentUser) + '\r\n\r\n'
            } catch (e) {
              this.message += '用户更新失败 : ' + JSON.stringify(e) + '\r\n\r\n'
            }
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

        Button('Encrypting Current User')
          .borderRadius(4)
          .type(ButtonType.Normal)
          .width('100%')
          .onClick(async () => {
            this.message = ''
            //仅在浏览器环境下生效
            Parse.enableEncryptedUser();
            Parse.secret = '123123';
            this.message = '加密当前用户成功' + JSON.stringify(Parse.isEncryptedUserEnabled())
          })


        Button('Security For Other Objects')
          .borderRadius(4)
          .type(ButtonType.Normal)
          .width('100%')
          .onClick(async () => {
            this.message = ''

            try {
              const Note: ESObject = Parse.Object.extend("Note");
              const privateNote: ESObject = new Note();
              privateNote.set("content", "This note is private!");
              privateNote.setACL(new Parse.ACL(Parse.User.current()));
              privateNote.save();
              const query = new Parse.Query(Note);
              query.equalTo("objectId", privateNote.id);
              await query.first();
              this.message = '加密对象成功'
            } catch (e) {
              this.message = '加密对象失败：'+JSON.stringify(e)
            }
          })

        Text(this.message)
          .fontSize(16)
      }
      .margin(10)
    }
    .width('100%')
    .height('100%')
  }
}