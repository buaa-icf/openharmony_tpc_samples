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
import { Attributes, ParseObject, ParseQuery } from '@ohos/parser-sdk'

@Entry
@Component
struct DestroyingObjects {
  objectId: string = ''
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

      Text('To delete an object from the cloud')

      TextInput({ placeholder: '请输入objectId' })
        .borderRadius(4)
        .onChange((val) => {
          this.objectId = val;
        })

      Button('删除')
        .width('100%')
        .onClick(() => {
          if (this.objectId !== '') {
            const UserInfo: ESObject = ParseObject.extend("UserInfo");
            const query = new ParseQuery(UserInfo);
            query.get(this.objectId).then((info) => {
              info.destroy().then(() => {
                promptAction.showToast({ message: '删除成功' });
                this.getData();
              }).catch((err: ESObject) => {
                promptAction.showToast({ message: '删除失败' });
                console.log('HMLog-->', JSON.stringify(err));
              })
            }).catch((err: ESObject) => {
              promptAction.showToast({ message: '查询失败' });
              console.log('HMLog-->', JSON.stringify(err));
            })
          } else {
            promptAction.showToast({ message: '请输入objectId' })
          }
        })

      Button('全部删除')
        .width('100%')
        .onClick(() => {
          const UserInfo: ESObject = ParseObject.extend("UserInfo");
          const query = new ParseQuery(UserInfo);
          query.find().then((info) => {
            ParseObject.destroyAll(info).then(() => {
              promptAction.showToast({ message: '删除成功' });
              this.getData();
            }).catch((err: ESObject) => {
              promptAction.showToast({ message: '删除失败' });
              console.log('HMLog-->', JSON.stringify(err));
            })
          })
        })
        .enabled(this.infoArr.length > 0)
    }
    .width('100%')
    .height('100%')
    .padding(20)
    .justifyContent(FlexAlign.Center)
  }
}