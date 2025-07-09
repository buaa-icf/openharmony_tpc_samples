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

import { ParseObject, ParseQuery } from '@ohos/parser-sdk';
import { promptAction } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  @State name: string = '';
  @State age: number = 0;
  @State occupation: string = '';
  @State resultsData: Array<ESObject> = [];

  aboutToAppear() {
    console.info('Page is about to appear');
    // 初始化数据或订阅事件

    const Personnel:ESObject = ParseObject.extend('PersonnelObject');
    const query = new ParseQuery(Personnel);
    query.find()
      .then((results) => {
        console.log('####','查询成功:', `${JSON.stringify(results)}`);
        results.forEach((score) => {
          console.log('####',score.id, score.get('name'), score.get('occupation'));
        });
        this.resultsData = results;
      })
  }

  build() {
    Column() {
      Text('人员信息')
        .fontSize(15)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 10})
      Row(){
        TextInput({ placeholder: '名字' ,text: this.name})
          .borderRadius(4)
          .onChange((val) => {
            this.name = val
          })
          .width('25%')

        TextInput({ placeholder: '年龄' })
          .borderRadius(4)
          .onChange((val) => {
            this.age = parseInt(val)
          })
          .width('25%')
          .margin({ left: 10 })

        TextInput({ placeholder: '职业' ,text: this.occupation})
          .borderRadius(4)
          .onChange((val) => {
            this.occupation = val
          })
          .width('25%')
          .margin({ left: 10, right: 10})
        Button('Add')
          .borderRadius(4)
          .type(ButtonType.Normal)
          .onClick(() => {
            if (this.name === '' && this.occupation === '') {
              promptAction.showToast({
                message: '请先输入添加的名字和职业',
                duration: 2000, // 提示持续时间，单位为毫秒
              });
              return;
            }
            const Personnel:ESObject = ParseObject.extend('PersonnelObject');
            const personnel:ESObject = new Personnel();
            const query = new ParseQuery(Personnel);
            personnel.set('name', this.name);
            personnel.set('age', this.age)
            personnel.set('occupation', this.occupation);
            personnel.save()
              .then((personnel:ESObject) => {
                // Execute any logic that should take place after the object is saved.
                console.log('####','New object created with objectId: ' + personnel.id);

                query.find()
                  .then((results) => {
                    this.name = '';
                    this.age = 0;
                    this.occupation = '';

                    console.log('####','查询成功:', `${JSON.stringify(results)}`);
                    results.forEach((score) => {
                      console.log('####',score.id, score.get('name'), score.get('age'), score.get('occupation'));
                    });
                    this.resultsData = results;
                  })
              }, (error:ESObject) => {
                console.log('####',`${error}`);
                console.log('####',JSON.stringify(error));
                // Execute any logic that should take place if the save fails.
                // error is a Parse.Error with an error code and message.
                console.log('####','Failed to create new object, with error code: ' + error.message);
              });
          })
      }
      ForEach(this.resultsData, (item:ESObject) => {
        Row(){
          Text(item.get('name'))
            .width('30%')
            .fontSize(15)
            .textAlign(TextAlign.Start)

          Text(String(item.get('age') ))
            .width('30%')
            .fontSize(15)
            .textAlign(TextAlign.Start)

          Text(item.get('occupation'))
            .width('30%')
            .fontSize(15)
            .textAlign(TextAlign.Start)
        }
        .margin({ top: 10})
      })
      if (this.resultsData.length === 0) {
        Text('未找到人员')
      }
    }

    .width('100%')
    .height('100%')
    .padding(20)
  }
}