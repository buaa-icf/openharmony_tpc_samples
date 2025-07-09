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

import { Parse, ParseObject, ParseQuery } from '@ohos/parser-sdk';

@Entry
@Component
struct Index {
  @State age: number = 0;
  @State name: string = '';
  @State limit: string = '10';
  @State pageSize: string = '3';
  @State totalCount: number = 0;
  @State occupation: string = '';
  @State nameList: string = '';
  @State onNameList: string = '';
  @State currentPage: number = 0;
  @State resultsData: Array<ESObject> = [];
  @State containMode: boolean = true;
  @State existsMode: boolean = true;
  @State compareType: string = 'greaterThan';
  @State searchType: string = 'startsWith';
  @State searchText: string = '';
  @State countResult: number = 0;
  @State ageSum: number = 0;
  @State distinctAges: number[] = [];

  aboutToAppear() {
  console.info('Page is about to appear');
  // 初始化数据或订阅事件
  this.queryData();
}

  // 查询方法
  queryData() {
    const Personnel: ESObject = ParseObject.extend("PersonnelObject");
    const query = new ParseQuery(Personnel);

    if (this.name !== '') {
      query.equalTo("name", this.name);
    }
    if (this.age !== 0) {
      query.equalTo("age", this.age);
    }
    if (this.occupation !== '') {
      query.equalTo("occupation", this.occupation);
    }

    // 分页控制
    const size = parseInt(this.pageSize);
    query.limit(size);
    query.skip(size * this.currentPage);
    query.withCount();

    query.find()
      .then((response: ESObject) => {
        if (typeof response.count === 'number') {
          // 带计数的响应
          this.resultsData = response.results || [];
          this.totalCount = response.count;
        } else {
          // 普通查询响应
          this.resultsData = response as ESObject[];
          this.totalCount = this.resultsData.length;
        }
        console.log('查询成功', `返回${this.resultsData.length}条，总计${this.totalCount}条`);
      })
      .catch((error: ESObject) => {
        console.error('查询失败:', error);
      });
  }

  queryDataWithSort(sortType: string) {
    const Personnel: ESObject = ParseObject.extend("PersonnelObject");
    const query = new ParseQuery(Personnel);

    // 基本查询条件保持不变
    if (this.name !== '') query.equalTo("name", this.name);
    if (this.age !== 0) query.equalTo("age", this.age);
    if (this.occupation !== '') query.equalTo("occupation", this.occupation);

    // 添加排序
    if (sortType === "ascending") {
      query.ascending("age");
    } else {
      query.descending("age");
    }

    // 分页控制
    const size = parseInt(this.pageSize);
    query.limit(size);
    query.skip(size * this.currentPage);
    query.withCount();

    query.find()
      .then((response: ESObject) => {
        if (typeof response.count === 'number') {
          this.resultsData = response.results || [];
          this.totalCount = response.count;
        } else {
          this.resultsData = response as ESObject[];
          this.totalCount = this.resultsData.length;
        }
      })
      .catch(console.error);
  }

  queryComparison() {
    const GameScore: ESObject = ParseObject.extend("PersonnelObject");
    const query = new ParseQuery(GameScore);

    // 根据选择的比较类型应用不同的查询
    switch(this.compareType) {
      case 'lessThan':
        query.lessThan("age", 18);
        break;
      case 'lessThanOrEqualTo':
        query.lessThanOrEqualTo("age", 19);
        break;
      case 'greaterThan':
        query.greaterThan("age", 20);
        break;
      case 'greaterThanOrEqualTo':
        query.greaterThanOrEqualTo("age", 21);
        break;
    }

    query.find()
      .then((results) => {
        this.resultsData = results;
      })
      .catch((error: ESObject) => {
        console.error('查询失败:', error);
      });
  }

  queryByNameList() {
    const Personnel: ESObject = ParseObject.extend("PersonnelObject");
    const query = new ParseQuery(Personnel);

    // 处理输入的姓名列表
    const names = this.nameList.split('，')
      .map(name => name.trim())
      .filter(name => name.length > 0);

    if (names.length > 0) {
      if (this.containMode) {
        query.containedIn("name", names);
      } else {
        query.notContainedIn("name", names);
      }
    }

    // 分页控制
    const size = parseInt(this.pageSize);
    query.limit(size);
    query.skip(size * this.currentPage);
    query.withCount();

    query.find()
      .then((response: ESObject) => {
        if (typeof response.count === 'number') {
          this.resultsData = response.results || [];
          this.totalCount = response.count;
        } else {
          this.resultsData = response as ESObject[];
          this.totalCount = this.resultsData.length;
        }
      })
      .catch(console.error);
  }

  queryByExistence() {
    const Personnel: ESObject = ParseObject.extend("PersonnelObject");
    const query = new ParseQuery(Personnel);

    if (this.existsMode) {
      query.exists('occupation');
    } else {
      query.doesNotExist('occupation');
    }

    // 分页控制
    const size = parseInt(this.pageSize);
    query.limit(size);
    query.skip(size * this.currentPage);
    query.withCount();

    query.find()
      .then((response: ESObject) => {
        if (typeof response.count === 'number') {
          this.resultsData = response.results || [];
          this.totalCount = response.count;
        } else {
          this.resultsData = response as ESObject[];
          this.totalCount = this.resultsData.length;
        }
      })
      .catch(console.error);
  }

  queryByString() {
    const Personnel: ESObject = ParseObject.extend("PersonnelObject");
    const query = new ParseQuery(Personnel);

    if (this.searchText !== '') {
      if (this.searchType === 'startsWith') {
        query.startsWith("name", this.searchText);
      } else {
        query.fullText("name", this.searchText);
      }
    }

    const size = parseInt(this.pageSize);
    query.limit(size);
    query.skip(size * this.currentPage);
    query.withCount();

    query.find()
      .then((response: ESObject) => {
        if (typeof response.count === 'number') {
          this.resultsData = response.results || [];
          this.totalCount = response.count;
        } else {
          this.resultsData = response as ESObject[];
          this.totalCount = this.resultsData.length;
        }
      })
      .catch(console.error);
  }

  // 查询总计数
  queryCount() {
    const Personnel: ESObject = ParseObject.extend("PersonnelObject");
    const query = new ParseQuery(Personnel);

    // 应用现有的查询条件
    if (this.name !== '') query.equalTo("name", this.name);
    if (this.age !== 0) query.equalTo("age", this.age);
    if (this.occupation !== '') query.equalTo("occupation", this.occupation);

    // 执行计数查询
    query.count()
      .then((count: number) => {
        this.countResult = count;
        console.log('计数成功', `总计${count}条`);
      })
      .catch((error: ESObject) => {
        console.error('计数失败:', error);
        this.countResult = 0;
      });
  }

  // 复合查询
  queryCompound() {
    const Personnel: ESObject = ParseObject.extend("PersonnelObject");
    // 年龄大于20岁
    const ageQuery = new ParseQuery(Personnel);
    ageQuery.greaterThan("age", 20);

    // 职业为老师
    const occupationQuery = new ParseQuery(Personnel);
    occupationQuery.equalTo("occupation", "老师");

    // 创建复合查询
    const compoundQuery:ESObject = Parse.Query.and(ageQuery, occupationQuery);

    // 添加分页控制
    const size = parseInt(this.pageSize);
    compoundQuery.limit(size);
    compoundQuery.skip(size * this.currentPage);
    compoundQuery.withCount();

    compoundQuery.find()
      .then((response: ESObject) => {
        if (typeof response.count === 'number') {
          this.resultsData = response.results || [];
          this.totalCount = response.count;
        } else {
          this.resultsData = response as ESObject[];
          this.totalCount = this.resultsData.length;
        }
        console.log('复合查询成功', `返回${this.resultsData.length}条`);
      })
      .catch(console.error);
  }

  build() {
    List(){
      ListItem(){
        Column() {
          Text('人员信息')
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 10})
          Row(){
            TextInput({ placeholder: '名字' })
              .borderRadius(4)
              .onChange((val) => {
                this.name = val
              })
              .width('22%')

            TextInput({ placeholder: '年龄' })
              .borderRadius(4)
              .onChange((val) => {
                this.age = parseInt(val)
              })
              .width('22%')
              .margin({ left: 10})

            TextInput({ placeholder: '职业' })
              .borderRadius(4)
              .onChange((val) => {
                this.occupation = val
              })
              .width('22%')
              .margin({ left: 10, right: 10})

            Button('查询')
              .borderRadius(4)
              .type(ButtonType.Normal)
              .onClick(() => {
                this.queryData()
              })
          }

          ForEach(this.resultsData, (item:ESObject) => {
            Row(){
              Text(item.get("name"))
                .width('25%')
                .fontSize(15)
                .textAlign(TextAlign.Start)
              Text(String(item.get("age")))
                .width('25%')
                .fontSize(15)
                .textAlign(TextAlign.Start)
              Text(item.get("occupation"))
                .width('20%')
                .fontSize(15)
                .textAlign(TextAlign.Start)
            }
            .width('100%')
            .margin({ top: 10, left: 36})
          })
          if (this.resultsData.length === 0) {
            Text('未找到人员')
          }

          Text(`总计 ${this.totalCount} 条`)
            .margin({ top: 10 })

          Row(){
            Button('←')
              .borderRadius(4)
              .type(ButtonType.Normal)
              .onClick(() => {
                // 上一页
                this.currentPage = Math.max(0, this.currentPage - 1);
                this.queryData();
              })

            Text(`第 ${this.currentPage + 1} 页`)
              .borderRadius(4)
              .width('15%')
              .margin({ left: 10, right: 10})

            Button('→')
              .borderRadius(4)
              .type(ButtonType.Normal)
              .onClick(() => {
                // 只有当前页有数据时才允许翻页
                if (this.resultsData.length > 0) {
                  this.currentPage++;
                  this.queryData();
                }
              })
          }
          .margin({ top: 10 })

          Row(){
            Text('每页查询数量: ')
            TextInput({ placeholder: '查询数量', text: this.pageSize })
              .borderRadius(4)
              .onChange((val) => {
                this.pageSize = val
              })
              .width('20%')
          }.width('100%')
          .margin({top: 10})
          .justifyContent(FlexAlign.Start)

          Row() {
            Button('年龄升序')
              .borderRadius(4)
              .type(ButtonType.Normal)
              .margin({ right: 10 })
              .onClick(() => {
                this.queryDataWithSort("ascending");
              })

            Button('年龄降序')
              .borderRadius(4)
              .type(ButtonType.Normal)
              .onClick(() => {
                this.queryDataWithSort("descending");
              })
          }
          .width('100%')
          .margin({ top: 10 })

          // 比较类型选择
          Row() {
            Button('小于18')
              .fontSize(12)
              .borderRadius(4)
              .type(ButtonType.Normal)
              .onClick(() => { this.compareType = 'lessThan'; this.queryComparison(); })
            Button('小于等于19')
              .fontSize(12)
              .borderRadius(4)
              .type(ButtonType.Normal)
              .onClick(() => { this.compareType = 'lessThanOrEqualTo'; this.queryComparison(); })
            Button('大于20')
              .fontSize(14)
              .borderRadius(4)
              .type(ButtonType.Normal)
              .onClick(() => { this.compareType = 'greaterThan'; this.queryComparison(); })
            Button('大于等于21')
              .fontSize(14)
              .borderRadius(4)
              .type(ButtonType.Normal)
              .onClick(() => { this.compareType = 'greaterThanOrEqualTo'; this.queryComparison(); })
          }
          .width('100%')
          .margin({top: 10})
          .justifyContent(FlexAlign.SpaceAround)

          Row(){
            Button('查询包含多个姓名:')
              .fontSize(12)
              .borderRadius(4)
              .type(ButtonType.Normal)
              .onClick(()=>{
                this.containMode = true;
                this.queryByNameList();
              })
            TextInput({ placeholder: '用逗号分隔', text: this.nameList })
              .borderRadius(4)
              .onChange((val) => {
                this.nameList = val
              })
              .width('55%')
          }.width('100%')
          .margin({top:10, bottom: 10 })

          Row(){
            Button('查询不包含多个姓名: ')
              .fontSize(12)
              .borderRadius(4)
              .type(ButtonType.Normal)
              .onClick(()=>{
                this.containMode = false;
                this.queryByNameList();
              })
            TextInput({ placeholder: '用逗号分隔', text: this.onNameList })
              .borderRadius(4)
              .onChange((val) => {
                this.onNameList = val
              })
              .width('55%')
          }.width('100%')

          Row(){
            Button('查询包含职业的数据')
              .fontSize(12)
              .borderRadius(4)
              .type(ButtonType.Normal)
              .onClick(()=>{
                this.existsMode = true
                this.queryByExistence()
              })

            Button('查询不包含职业的数据')
              .fontSize(12)
              .borderRadius(4)
              .type(ButtonType.Normal)
              .margin({ left: 10 })
              .onClick(()=>{
                this.existsMode = false
                this.queryByExistence()
              })
          }.width('100%')
          .margin({top:10, bottom: 10 })

          Row(){
            Button('复合查询: 大于20年龄，并且职业为老师')
              .borderRadius(4)
              .type(ButtonType.Normal)
              .onClick(() => this.queryCompound())
          }.width('100%')


          Row() {
            Radio({ value: 'startsWith', group: 'searchType' })
              .checked(this.searchType === 'startsWith')
              .onChange(() => this.searchType = 'startsWith')
            Text('姓名开头匹配').margin({ left: 5, right: 10 })

            Radio({ value: 'fullText', group: 'searchType' })
              .checked(this.searchType === 'fullText')
              .onChange(() => this.searchType = 'fullText')
            Text('姓名全文搜索').margin({ left: 5 })
          }
          .width('100%')
          .margin({ top: 10 })

          Row() {
            TextInput({ placeholder: '输入搜索文本', text: this.searchText })
              .width('70%')
              .onChange(val => this.searchText = val)

            Button('搜索')
              .borderRadius(4)
              .type(ButtonType.Normal)
              .width('30%')
              .onClick(() => this.queryByString())
          }
          .width('100%')

          Text('计数查询')
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .margin({ top: 20, bottom: 10 })

          Row() {
            Button('执行计数')
              .borderRadius(4)
              .type(ButtonType.Normal)
              .width('50%')
              .onClick(() => this.queryCount())

            Text(`结果: ${this.countResult}`)
              .width('50%')
              .textAlign(TextAlign.Center)
          }
          .width('100%')
        }
        .width('100%')
        .padding(20)
      }
    }
  }
}