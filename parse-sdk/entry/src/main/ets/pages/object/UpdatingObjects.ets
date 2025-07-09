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

import { Attributes, ParseObject, ParseQuery } from '@ohos/parser-sdk';
import { promptAction } from '@kit.ArkUI';

@Entry
@Component
struct UpdatingObjects {
  objectId: string = ''
  userName: string = ''
  userPassword: string = ''
  userEmail: string = ''
  @State infoArr: ParseObject<Attributes>[] = []

  aboutToAppear(): void {
    this.getData();
  }

  getData() {
    const UserInfo: ESObject = ParseObject.extend("UserInfo");
    const query = new ParseQuery(UserInfo);
    query.find().then((info) => {
      this.infoArr = info;
    }).catch((err: ESObject) => {
      promptAction.showToast({ message: '获取数据失败' });
      console.log('HMLog-->', JSON.stringify(err));
    })
  }

  build() {
    Column({ space: 20 }) {
      List() {
        ForEach(this.infoArr, (info: ParseObject) => {
          ListItem() {
            Row({ space: 10 }) {
              Text(info._getId())
              Text(info.get('userName'))
              Text(info.get('userPassword'))
              Text(info.get('userEmail'))
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
          }
        })
      }
      .width('100%')

      Text('Updating an object is simple. Just set some new data on it and call the save method.')

      TextInput({ placeholder: '请输入objectId' })
        .borderRadius(4)
        .onChange((val) => {
          this.objectId = val;
        })

      TextInput({ placeholder: '请输入用户名' })
        .borderRadius(4)
        .onChange((val) => {
          this.userName = val;
        })

      TextInput({ placeholder: '请输入密码' })
        .borderRadius(4)
        .onChange((val) => {
          this.userPassword = val;
        })

      TextInput({ placeholder: '请输入邮箱' })
        .borderRadius(4)
        .onChange((val) => {
          this.userEmail = val;
        })

      Button('修改')
        .width('100%')
        .onClick(() => {
          if (this.objectId !== '') {
            const UserInfo: ESObject = ParseObject.extend("UserInfo");
            const query = new ParseQuery(UserInfo);
            query.get(this.objectId).then((info) => {
              if (this.userName !== '') {
                info.set('userName', this.userName);
              }
              if (this.userPassword !== '') {
                info.set('userPassword', this.userPassword);
              }
              if (this.userEmail !== '') {
                info.set('userEmail', this.userEmail);
              }
              info.save().then(() => {
                promptAction.showToast({ message: '修改成功' });
                this.getData();
              }).catch((err: ESObject) => {
                promptAction.showToast({ message: '修改失败' });
                console.log('HMLog-->', JSON.stringify(err));
              });
            }).catch((err: ESObject) => {
              promptAction.showToast({ message: '查询失败' });
              console.log('HMLog-->', JSON.stringify(err));
            })
          } else {
            promptAction.showToast({ message: '请输入objectId' })
          }
        })
    }
    .width('100%')
    .height('100%')
    .padding(20)
    .justifyContent(FlexAlign.Center)
  }
}