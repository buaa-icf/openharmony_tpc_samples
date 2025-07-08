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

@Entry
@Component
struct Role {
  account: string = ''
  password: string = ''
  ip: string = ''
  email: string = ''
  @State message: string = ''
  userId: string | undefined = ''

  build() {
    Scroll() {
      Column({ space: 20 }) {
        Button('Security for Role Objects')
          .borderRadius(4)
          .type(ButtonType.Normal)
          .width('100%')
          .onClick(async () => {
            this.message = ''

            try {
              const roleACL = new Parse.ACL();
              roleACL.setPublicReadAccess(true);
              const role = new Parse.Role("Administrator", roleACL);
              role.save();
              this.message = 'role 保存成功'
            } catch (e) {
              this.message = 'role 保存失败' + JSON.stringify(e)
            }
          })

        Button('normal for Role Objects')
          .borderRadius(4)
          .type(ButtonType.Normal)
          .width('100%')
          .onClick(async () => {
            this.message = ''
            try {
              const role = new Parse.Role('TestRole', new Parse.ACL());
              await role.save();
              this.message = 'role 角色创建成功' + role.id
            } catch (e) {
              this.message = 'role 角色创建失败' + JSON.stringify(e)
            }
          })

        Button('Role Based Security for Other Objects')
          .borderRadius(4)
          .type(ButtonType.Normal)
          .width('100%')
          .onClick(async () => {
            this.message = ''
            try {
              const wallPost = new Parse.Object("WallPost");
              const postACL = new Parse.ACL();
              postACL.setRoleWriteAccess("Moderators", true);
              wallPost.setACL(postACL);
              wallPost.save();
              this.message = 'role 角色创建成功'
            } catch (e) {
              this.message = 'role 角色创建失败' + JSON.stringify(e)
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