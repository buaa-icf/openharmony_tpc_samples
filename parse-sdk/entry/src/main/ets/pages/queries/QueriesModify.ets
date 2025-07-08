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
import { promptAction, router } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  @State searchName: string = '';
  @State name: string = '';
  @State occupation: string = '';
  @State resultsData: Array<ESObject> = [];

  aboutToAppear() {
    console.info('Page is about to appear');
    // 初始化数据或订阅事件

    const Personnel:ESObject = ParseObject.extend("PersonnelObject");
    const query = new ParseQuery(Personnel);
    query.find()
      .then((results) => {
        console.log('####',"查询成功:", `${JSON.stringify(results)}`);
        results.forEach((score) => {
          console.log('####',score.id, score.get("name"), score.get("occupation"));
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
        TextInput({ placeholder: '名字',text: this.searchName })
          .borderRadius(4)
          .onChange((val) => {
            this.searchName = val
          })
          .width('70%')
          .margin({ right: 20, bottom: 20})
        Button('查询')
          .margin({ bottom: 20})
          .borderRadius(4)
          .type(ButtonType.Normal)
          .onClick(() => {
            const Personnel:ESObject = ParseObject.extend("PersonnelObject");
            const query = new ParseQuery(Personnel);

            if (this.searchName !== '') {
              query.equalTo("name", this.searchName);
            }
            // 查询所有对象
            query.find()
              .then((results) => {
                console.log('####',"查询成功:", `${JSON.stringify(results)}`);
                this.resultsData = results;
              })
              .catch((error:ESObject) => {
                console.error('####',"查询失败:", error);
              });
          })
      }
      Row(){
        TextInput({ placeholder: '名字' ,text: this.name})
          .borderRadius(4)
          .onChange((val) => {
            this.name = val
          })
          .width('35%')

        TextInput({ placeholder: '职业' ,text: this.occupation})
          .borderRadius(4)
          .onChange((val) => {
            this.occupation = val
          })
          .width('35%')
          .margin({ left: 10, right: 10})
        Button('修改')
          .borderRadius(4)
          .type(ButtonType.Normal)
          .onClick(() => {
            if (this.searchName === '') {
              promptAction.showToast({
                message: '请先查询名字',
                duration: 2000, // 提示持续时间，单位为毫秒
              });
              return;
            }
            const Personnel:ESObject = ParseObject.extend("PersonnelObject");
            const query = new ParseQuery(Personnel);
            const updatePromises = (this.resultsData as ParseObject[]).map(score => {
              if (this.name !== '') {
                score.set("name", this.name);
              }
              if (this.occupation !== '') {
                score.set("occupation", this.occupation);
              }
              return score.save();
            });
            Promise.all(updatePromises).then( () => {
              console.log('####',"更新成功:", `${JSON.stringify(this.resultsData)}`);
              console.log('####',`成功更新了${this.resultsData.length}条记录`);
              const queryNew = new ParseQuery(Personnel);
              if (this.searchName !== '') {
                queryNew.equalTo("name", this.searchName);
              }
              queryNew.find()
                .then((results) => {
                  this.name = '';
                  this.occupation = '';
                  this.resultsData = results;
                })
            })

            // const Personnel:ESObject = ParseObject.extend("PersonnelObject");
            // const query = new ParseQuery(Personnel);
            //
            // if (this.name !== '') {
            //   query.equalTo("name", this.name);
            // }
            // if (this.occupation !== '') {
            //   query.equalTo("occupation", this.occupation);
            // }
            // // 查询所有对象
            // query.find()
            //   .then((results) => {
            //     console.log('####',"查询成功:", `${JSON.stringify(results)}`);
            //     const updatePromises = results.map(score => {
            //       if (this.name !== '') {
            //         score.set("name", this.name);
            //       }
            //       if (this.occupation !== '') {
            //         score.set("occupation", this.occupation);
            //       }
            //       return score.save();
            //     });
            //     Promise.all(updatePromises).then( () => {
            //       console.log('####',"更新成功:", `${JSON.stringify(results)}`);
            //       console.log('####',`成功更新了${results.length}条记录`);
            //       const queryNew = new ParseQuery(Personnel);
            //       queryNew.find()
            //         .then((results) => {
            //           this.name = '';
            //           this.occupation = '';
            //           this.resultsData = results;
            //         })
            //     })
            //   })
            //   .catch((error:ESObject) => {
            //     console.error('####',"查询失败:", error);
            //   });
          })
      }
      // Button('跳转')
      //   .onClick(() =>{
      //     router.replaceUrl({ url: 'pages/QueriesAdd' })
      //   })
      ForEach(this.resultsData, (item:ESObject) => {
        Row(){
          Text(item.get("name"))
            .width('45%')
            .fontSize(15)
            .textAlign(TextAlign.Start)
          Text(item.get("occupation"))
            .width('45%')
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