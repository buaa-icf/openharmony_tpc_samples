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
  @State name: string = '';
  @State age: number = 0;
  @State occupation: string = '';
  @State resultsData: Array<ESObject> = [];
  @State useSelect: boolean = true;
  @State selectedField: string = 'name';
  @State relatedQueryMode: boolean = false;

  aboutToAppear() {
    console.info('Page is about to appear');
    this.initializeDefaultDepartment();
    this.queryData();
  }

  // 基本查询
  queryData() {
    const Personnel: ESObject = ParseObject.extend('PersonnelObject');
    const query = new ParseQuery(Personnel);

    // 基本查询条件
    if (this.name) query.equalTo('name', this.name);
    if (this.age > 0) query.equalTo('age', this.age);
    if (this.occupation) query.equalTo('occupation', this.occupation);

    // 字段选择/排除
    if (this.useSelect) {
      query.select(this.selectedField);
    } else {
      query.exclude(this.selectedField);
    }

    // 跨表查询条件
    if (this.relatedQueryMode) {
      const Department: ESObject = ParseObject.extend('Department');
      const deptQuery = new ParseQuery(Department);
      deptQuery.equalTo('name', 'IT'); // 固定查询IT部门

      // 使用matchesKeyInQuery关联查询
      query.matchesKeyInQuery('department', 'objectId', deptQuery);
    }

    query.find()
      .then((results: ESObject[]) => {
        this.resultsData = results;
      })
      .catch(console.error);
  }

  // 反向关联查询
  queryNotRelated() {
    const Personnel: ESObject = ParseObject.extend('PersonnelObject');
    const Department: ESObject = ParseObject.extend('Department');
    const query = new ParseQuery(Personnel);
    const deptQuery = new ParseQuery(Department);
    deptQuery.equalTo('name', 'IT'); // 固定查询IT部门

    // 反向关联查询
    query.doesNotMatchKeyInQuery('department', 'objectId', deptQuery);

    query.find()
      .then((results: ESObject[]) => {
        this.resultsData = results;
      })
      .catch(console.error);
  }

  async initializeDefaultDepartment() {
    const Department: ESObject = ParseObject.extend('Department');
    const Personnel: ESObject = ParseObject.extend('PersonnelObject');

    try {
      // 检查并创建IT部门
      const deptQuery = new ParseQuery(Department);
      deptQuery.equalTo('name', 'IT');
      let itDept = await deptQuery.first();

      if (!itDept) {
        itDept = new Department();
        itDept?.set('name', 'IT');
        itDept?.set('description', '信息技术部门');
        itDept = await itDept?.save();
        console.log('IT部门创建成功');
      }

      // 检查并创建默认人员
      const personQuery = new ParseQuery(Personnel);
      personQuery.equalTo('name', 'IT管理员');
      personQuery.equalTo('department', itDept?.id);
      const existingAdmin = await personQuery.first();

      if (!existingAdmin) {
        const itAdmin:ESObject = new Personnel();
        itAdmin.set('name', 'IT管理员');
        itAdmin.set('age', 30);
        itAdmin.set('occupation', '系统管理员');
        itAdmin.set('department', itDept?.id);
        await itAdmin.save();
        console.log('IT部门默认人员创建成功');
      }

    } catch (error) {
      console.error('初始化失败:', error);
    }
  }

  async createDefaultItPersonnel(departmentId: string) {
    const Personnel: ESObject = ParseObject.extend('PersonnelObject');

    try {
      const itAdmin:ESObject = new Personnel();
      itAdmin.set('name', 'IT管理员');
      itAdmin.set('age', 30);
      itAdmin.set('occupation', '系统管理员');
      itAdmin.set('department', departmentId);
      await itAdmin.save();
      console.log('IT部门默认人员创建成功');

    } catch (error) {
      console.error('创建IT人员失败:', error);
    }
  }

  build() {
    Column() {
      // 基本信息输入
      Row() {
        TextInput({ placeholder: '姓名', text: this.name })
          .onChange(val => this.name = val)
          .width('30%')
        TextInput({ placeholder: '年龄' })
          .onChange(val => this.age = parseInt(val) || 0)
          .width('20%')
          .margin({ left: 10 })
        TextInput({ placeholder: '职业', text: this.occupation })
          .onChange(val => this.occupation = val)
          .width('30%')
          .margin({ left: 10 })
      }
      .width('100%')
      .margin({ bottom: 10 })

      // 字段选择控制
      Row() {
        Radio({ value: 'name', group: 'fieldGroup' })
          .checked(this.selectedField === 'name')
          .onChange(() => this.selectedField = 'name')
        Text('姓名').margin({ left: 5, right: 10 })

        Radio({ value: 'age', group: 'fieldGroup' })
          .checked(this.selectedField === 'age')
          .onChange(() => this.selectedField = 'age')
        Text('年龄').margin({ left: 5, right: 10 })

        Radio({ value: 'occupation', group: 'fieldGroup' })
          .checked(this.selectedField === 'occupation')
          .onChange(() => this.selectedField = 'occupation')
        Text('职业').margin({ left: 5 })
      }
      .width('100%')
      .margin({ bottom: 10 })

      // 操作按钮
      Row() {
        Button(this.useSelect ? '选择字段' : '排除字段')
          .borderRadius(4)
          .type(ButtonType.Normal)
          .onClick(() => {
            this.useSelect = !this.useSelect;
            this.queryData();
          })
          .margin({ right: 10 })

        Toggle({ type: ToggleType.Switch, isOn: this.relatedQueryMode })
          .onChange(isOn => this.relatedQueryMode = isOn)
        Text('关联IT部门').margin({ left: 5, right: 10 })

        Button('查询非IT部门')
          .borderRadius(4)
          .type(ButtonType.Normal)
          .onClick(() => this.queryNotRelated())
      }
      .width('100%')
      .margin({ bottom: 20 })

      // 查询按钮
      Button('执行查询')
        .borderRadius(4)
        .type(ButtonType.Normal)
        .onClick(() => this.queryData())
        .width('50%')
        .margin({ bottom: 20 })

      // 结果显示
      if (this.resultsData.length > 0) {
        Text(`查询结果 (${this.resultsData.length}条)`).fontSize(16)
        ForEach(this.resultsData, (item: ESObject) => {
          Column() {
            if (item.has('name')) {
              Row() {
                Text('姓名:').width('30%')
                Text(item.get('name')).width('70%')
              }
            }
            if (item.has('age')) {
              Row() {
                Text('年龄:').width('30%')
                Text(item.get('age').toString()).width('70%')
              }
            }
            if (item.has('occupation')) {
              Row() {
                Text('职业:').width('30%')
                Text(item.get('occupation')).width('70%')
              }
            }
            Divider().margin({ top: 10, bottom: 10 })
          }
          .width('100%')
        })
      } else {
        Text('没有查询到数据').margin({ top: 20 })
      }
    }
    .width('100%')
    .height('100%')
    .padding(20)
  }
}