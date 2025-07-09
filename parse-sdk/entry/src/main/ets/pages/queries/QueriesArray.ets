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

@Entry
@Component
struct Index {
  @State arrayKey: string = 'skills'; // 数组字段名
  @State singleValue: string = '2'; // 单个查询值
  @State multipleValues: string = '2,3,4'; // 多个查询值
  @State resultsData: Array<ESObject> = [];

  aboutToAppear() {
    if(!this.resultsData.length){
      this.createDefaultSkillsData();
    }
  }

  // 创建默认数据
  async createDefaultSkillsData() {
    const SkillsData: ESObject = ParseObject.extend('SkillsData');
    const query = new ParseQuery(SkillsData);

    try {
      // 检查是否已存在数据
      const count = await query.count();
      if (count === 0) {
        // 创建默认数据
        const data1: ESObject = new SkillsData();
        data1.set('name', '张三');
        data1.set('skills', [1, 2, 3]);

        const data2: ESObject = new SkillsData();
        data2.set('name', '李四');
        data2.set('skills', [2, 3, 4, 5]);

        const data3: ESObject = new SkillsData();
        data3.set('name', '王五');
        data3.set('skills', [3, 4, 5]);

        await ParseObject.saveAll([data1, data2, data3]);
        console.log('技能默认数据创建成功');
      }

      // 查询最新数据
      this.queryAllData();
    } catch (error) {
      console.error('创建默认数据失败:', error);
    }
  }

  // 查询所有数据
  queryAllData() {
    const SkillsData: ESObject = ParseObject.extend('SkillsData');
    const query = new ParseQuery(SkillsData);

    query.find()
      .then((results) => {
        this.resultsData = results;
      })
      .catch(console.error);
  }

  // 查询包含单个值的数组
  queryBySingleValue() {
    const SkillsData: ESObject = ParseObject.extend('SkillsData');
    const query = new ParseQuery(SkillsData);

    if (this.singleValue !== '') {
      // 使用 equalTo 查询数组包含单个元素
      query.equalTo(this.arrayKey, parseInt(this.singleValue));
    }

    query.find()
      .then((results) => {
        this.resultsData = results;
      })
      .catch(console.error);
  }

  // 查询包含所有指定值的数组
  queryByMultipleValues() {
    const SkillsData: ESObject = ParseObject.extend('SkillsData');
    const query = new ParseQuery(SkillsData);

    if (this.multipleValues !== '') {
      // 处理输入的数组值
      const values = this.multipleValues.split(',')
        .map(val => parseInt(val.trim()))
        .filter(val => !isNaN(val));

      if (values.length > 0) {
        // 使用 containsAll 查询包含所有元素
        query.containsAll(this.arrayKey, values);
      }
    }

    query.find()
      .then((results) => {
        this.resultsData = results;
      })
      .catch(console.error);
  }

  build() {
    Column() {
      Text('数组查询示例')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 20 })

      // 单个值查询
      Row() {
        Text('查询包含值:')
          .width('30%')
        TextInput({ text: this.singleValue })
          .width('50%')
          .onChange(val => this.singleValue = val)
        Button('查询')
          .width('20%')
          .onClick(() => this.queryBySingleValue())
      }
      .margin({ bottom: 15 })

      // 多个值查询
      Row() {
        Text('查询包含所有:')
          .width('30%')
        TextInput({ text: this.multipleValues })
          .width('50%')
          .onChange(val => this.multipleValues = val)
        Button('查询')
          .width('20%')
          .onClick(() => this.queryByMultipleValues())
      }
      .margin({ bottom: 20 })

      // 结果显示
      Text('查询结果:')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 10 })

      ForEach(this.resultsData, (item: ESObject) => {
        Column() {
          Row() {
            Text(item.get('name') + ': ')
              .fontWeight(FontWeight.Bold)
            Text(JSON.stringify(item.get(this.arrayKey)))
          }
          .margin({ bottom: 5 })
          Divider()
        }
      })

      if (this.resultsData.length === 0) {
        Text('没有查询到数据')
          .margin({ top: 20 })
      }

      // 重置按钮
      Button('重置查询')
        .margin({ top: 20 })
        .onClick(() => {
          this.singleValue = '2';
          this.multipleValues = '2,3,4';
          this.queryAllData();
        })
    }
    .width('100%')
    .height('100%')
    .padding(20)
  }
}