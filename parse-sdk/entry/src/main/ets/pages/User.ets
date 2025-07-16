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

import { IndexedDBStorageController, Parse } from '@ohos/parser-sdk'
import { JSON } from '@kit.ArkTS'

@Entry
@Component
struct User {
  userId: string | undefined = '';
  account: string = '';
  password: string = '';
  ip: string = '';
  email: string = '';
  dbStorageController = new IndexedDBStorageController();
  @State message: string = '';
  @State inviteCode: string = '';

  async linkInviter(code: string, newUser: ESObject) {
    const query = new Parse.Query(Parse.User);
    query.equalTo('inviteCode', code);
    const inviterUser = await query.first({ sessionToken: newUser.getSessionToken() });

    if (inviterUser) {
      newUser.set('invitedBy', inviterUser);
      await newUser.save(null, { sessionToken: newUser.getSessionToken() });

      this.message += `\n成功关联邀请人: ${inviterUser.get('username')}`;
    }
  }

  build() {
    Scroll() {
      Column({ space: 15 }) {
        Text(this.message)
          .fontSize(16)

        TextInput({ placeholder: '请输入账号', text: 'admin' })
          .borderRadius(4)
          .onChange((val) => {
            this.account = val;
          })

        TextInput({ placeholder: '请输入密码', text: '123123' })
          .borderRadius(4)
          .onChange((val) => {
            this.password = val;
          })

        TextInput({ placeholder: '请输入邮箱', text: 'email@example.com' })
          .borderRadius(4)
          .onChange((val) => {
            this.email = val;
          })

        TextInput({ placeholder: '请输入IP', text: '192.168.0.2' })
          .borderRadius(4)
          .onChange((val) => {
            this.ip = val;
          })

        TextInput({ placeholder: '邀请码（可选）' })
          .borderRadius(4)
          .onChange((val) => {
            this.inviteCode = val;
          })

        Button('注册')
          .borderRadius(4)
          .type(ButtonType.Normal)
          .width('100%')
          .onClick(async () => {
            this.message = ''
            try {
              const user = new Parse.User();
              user.set('username', this.account);
              user.set('password', this.password);
              user.set('email', this.email);

              // 生成邀请码
              const generatedCode = Math.random().toString(36).slice(2, 8).toUpperCase();
              user.set('inviteCode', generatedCode);

              // 先注册用户
              await user.signUp();
              this.message = '注册成功！' + "请前往邮箱确认，" + '邀请码：' + generatedCode;

              // 处理邀请关系
              if (this.inviteCode) {
                setTimeout(async () => {
                  try {
                    await this.linkInviter(this.inviteCode, user);
                  } catch (e) {
                    console.error("关联邀请人失败:", e);
                  }
                }, 1);
              }
            } catch (e) {
              this.message = '注册失败: ' + e.message;
            }
          })

        Button('登录')
          .borderRadius(4)
          .type(ButtonType.Normal)
          .width('100%')
          .onClick(async () => {
            this.message = '';
            try {
              const loggedInUser = await Parse.User.logIn(this.account, this.password, { usePost: false });
              this.userId = loggedInUser.id;
              this.message = '登录成功:' + loggedInUser.id;
            } catch (e) {
              this.message = '登录失败:' + JSON.stringify(e);
            }
          })

        Button('获取当前用户')
          .borderRadius(4)
          .type(ButtonType.Normal)
          .width('100%')
          .onClick(async () => {
            this.message = '';
            let currentUser: ESObject = null;
            try {
              currentUser = Parse.User.current();
              if (!currentUser) {
                this.message = '请先登录';
                return;
              }

              await currentUser.fetch({ sessionToken: currentUser.getSessionToken() });
              this.message = '获取当前用户成功:' + currentUser?.id + '\r\n\r\n';
            } catch (e) {
              this.message = '获取当前用户失败:' + JSON.stringify(e) + '\r\n\r\n';
            }

            try {
              await currentUser.fetch({ sessionToken: currentUser.getSessionToken() });
              this.message += '用户更新成功 : ' + JSON.stringify(currentUser) + '\r\n\r\n';
            } catch (e) {
              this.message += '用户更新失败 : ' + JSON.stringify(e) + '\r\n\r\n';
            }
          })

        Button('查看我的邀请关系')
          .borderRadius(4)
          .type(ButtonType.Normal)
          .width('100%')
          .onClick(async () => {
            try {
              const user = Parse.User.current();
              if (!user?.id) {
                this.message = '请先登录';
                return;
              }

              // 强制获取最新数据
              await user.fetch({ sessionToken: user.getSessionToken() });

              // 获取邀请人信息
              let inviterName = '无';
              const invitedBy: ESObject = user.get('invitedBy');
              if (invitedBy) {
                if (typeof invitedBy.fetch === 'function') {
                  await invitedBy.fetch({ sessionToken: user.getSessionToken() });
                  inviterName = invitedBy.get('username');
                } else if (invitedBy.className === '_User') {
                  inviterName = invitedBy.get('username');
                }
              }

              // 查询当前用户邀请人数
              const inviteeQuery = new Parse.Query(Parse.User);
              inviteeQuery.equalTo('invitedBy', user);
              const invitees = await inviteeQuery.find({ sessionToken: user.getSessionToken() });
              const inviteeNames: string[] = invitees.map((invitee: ESObject) => {
                return invitee.get('username') as string;
              });

              this.message = `邀请状态：\n` +
                `邀请人: ${inviterName}\n` +
                `已邀请: ${inviteeNames.join(', ') || '无'}`;
            } catch (e) {
              this.message = '查看邀请关系失败: ' + e.message;
            }
          })

        Button('退出登陆')
          .borderRadius(4)
          .type(ButtonType.Normal)
          .width('100%')
          .onClick(async () => {
            this.message = '';
            try {
              await Parse.User.logOut();
              this.message = '退出登陆成功';
            } catch (e) {
              this.message = '退出登陆失败:' + JSON.stringify(e);
            }
          })

        Button('Encrypting Current User')
          .borderRadius(4)
          .type(ButtonType.Normal)
          .width('100%')
          .onClick(async () => {
            this.message = '';
            //仅在浏览器环境下生效
            Parse.enableEncryptedUser();
            Parse.secret = '123123';
            this.message = '加密当前用户成功' + JSON.stringify(Parse.isEncryptedUserEnabled());
          })

        Button('Security For Other Objects')
          .borderRadius(4)
          .type(ButtonType.Normal)
          .width('100%')
          .onClick(async () => {
            this.message = '';
            try {
              const Note: ESObject = Parse.Object.extend("Note");
              const privateNote: ESObject = new Note();
              privateNote.set("content", "This note is private!");
              privateNote.setACL(new Parse.ACL(Parse.User.current()));
              privateNote.save();
              const query = new Parse.Query(Note);
              query.equalTo("objectId", privateNote.id);
              await query.first();
              this.message = '加密对象成功';
            } catch (e) {
              this.message = '加密对象失败：'+JSON.stringify(e)
            }
          })

        Button('Resetting Passwords')
          .borderRadius(4)
          .type(ButtonType.Normal)
          .width('100%')
          .onClick(async () => {
            this.message = '';
            try {
              await Parse.User.requestPasswordReset(this.email);
              this.message = '密码重置邮件已发送，请检查您的邮箱';
            } catch (e) {
              this.message = '重置密码失败: ' + e.message;
            }
          })

        Button('Querying')
          .borderRadius(4)
          .type(ButtonType.Normal)
          .width('100%')
          .onClick(async () => {
            this.message = '查询中...';
            try {
              const query = new Parse.Query(Parse.User);
              const users = await query.find();

              this.message = `共查询到 ${users.length} 个用户:\n`;
              users.forEach((user: ESObject) => {
                this.message += `- 用户名: ${user.get('username')}, ID: ${user.id}\n`;
              });
            } catch (e) {
              this.message = `查询失败: ${e.message}`;
            }
          })
      }
      .margin(10)
    }
    .width('100%')
    .height('100%')
  }
}