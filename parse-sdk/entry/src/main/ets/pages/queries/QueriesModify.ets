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
  @State age: number = 0;
  @State occupation: string = '';
  @State resultsData: Array<ESObject> = [];
  @State selectedIndex: number = -1;

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
            const Personnel:ESObject = ParseObject.extend('PersonnelObject');
            const query = new ParseQuery(Personnel);

            query.readPreference('SECONDARY_PREFERRED');

            if (this.searchName !== '') {
              query.equalTo('name', this.searchName);
            }
            // 查询所有对象
            query.find()
              .then((results) => {
                console.log('####','查询成功:', `${JSON.stringify(results)}`);
                this.resultsData = results;
              })
              .catch((error:ESObject) => {
                console.error('####','查询失败:', error);
              });
          })
      }

      Row(){
        Button('修改')
          .borderRadius(4)
          .width('30%')
          .type(ButtonType.Normal)
          .enabled(this.selectedIndex >= 0) // 只在有选中项时启用
          .onClick(() => {
            if (this.selectedIndex < 0) {
              promptAction.showToast({ message: '请先选择要修改的记录', duration: 2000 });
              return;
            }

            // 获取选中的对象
            const selected:ESObject = this.resultsData[this.selectedIndex];

            // 应用修改
            if (this.name !== '') selected.set('name', this.name);
            if (this.age !== 0) selected.set('age', this.age);
            if (this.occupation !== '') selected.set('occupation', this.occupation);

            // 保存修改
            selected.save()
              .then(() => {
                promptAction.showToast({ message: '修改成功', duration: 2000 });

                // 重置输入框
                this.name = '';
                this.age = 0;
                this.occupation = '';

                // 刷新当前查询
                const Personnel:ESObject = ParseObject.extend('PersonnelObject');
                const query = new ParseQuery(Personnel);
                if (this.searchName) query.equalTo('name', this.searchName);
                return query.find();
              })
              .then((results: ESObject) => {
                this.resultsData = results;
                this.selectedIndex = -1; // 重置选中状态
              })
              .catch((error: ESObject) => {
                console.error('修改失败:', error);
                promptAction.showToast({ message: '修改失败', duration: 2000 });
              });
          })

        Button('未保存修改')
          .borderRadius(4)
          .width('30%')
          .type(ButtonType.Normal)
          .enabled(this.selectedIndex >= 0) // 只在有选中项时启用
          .margin({left: 10})
          .onClick(() => {
            if (this.selectedIndex < 0) return;

            const selected: ESObject = this.resultsData[this.selectedIndex];

            // 应用本地修改但不保存
            if (this.name !== '') selected.set('name', this.name);
            if (this.age !== 0) selected.set('age', this.age);
            if (this.occupation !== '') selected.set('occupation', this.occupation);

            // 只更新UI显示，不重新查询服务器数据
            this.resultsData = [...this.resultsData]; // 触发ArkUI更新
          });
        // 撤销按钮
        Button('撤销修改')
          .borderRadius(4)
          .width('30%')
          .type(ButtonType.Normal)
          .enabled(this.selectedIndex >= 0)
          .onClick(() => {
            const selected:ESObject = this.resultsData[this.selectedIndex];
            selected.revert();
            promptAction.showToast({
              message: '已撤销修改',
              duration: 2000
            });

            // 刷新数据
            const Personnel:ESObject = ParseObject.extend('PersonnelObject');
            const query = new ParseQuery(Personnel);
            query.find().then((results) => {
              this.resultsData = results;
              this.selectedIndex = -1;
            });
          })
          .margin({left: 10})
      }
      .margin({bottom: 20})

      Row(){
        TextInput({ placeholder: '名字' ,text: this.name})
          .borderRadius(4)
          .onChange((val) => {
            this.name = val
          })
          .width('30%')

        TextInput({ placeholder: '年龄' })
          .borderRadius(4)
          .onChange((val) => {
            this.age = parseInt(val)
          })
          .width('30%')
          .margin({ left: 10})

        TextInput({ placeholder: '职业' ,text: this.occupation})
          .borderRadius(4)
          .onChange((val) => {
            this.occupation = val
          })
          .width('30%')
          .margin({ left: 10, right: 10})
      }
      ForEach(this.resultsData, (item:ESObject, index: number) => {
        Row(){
          Text(item.get('name'))
            .width('30%')
            .fontSize(15)
            .textAlign(TextAlign.Start)
          Text(String(item.get('age')))
            .width('30%')
            .fontSize(15)
            .textAlign(TextAlign.Start)
          Text(item.get('occupation'))
            .width('30%')
            .fontSize(15)
            .textAlign(TextAlign.Start)
        }
        .margin({ top: 10})
        .onClick(() => {
          this.selectedIndex = index ?? -1;  // 记录选中索引
          promptAction.showToast({
            message: '已选中: ' + item.get('name'),
            duration: 1000
          });
        })
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