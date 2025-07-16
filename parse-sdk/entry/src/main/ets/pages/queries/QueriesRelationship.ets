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
  * distributed under the License is distributed on an "AS" IS' BASIS,
  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  * See the License for the specific language governing permissions and
  * limitations under the License.
  */

import { ParseObject, ParseQuery } from '@ohos/parser-sdk';

@Entry
@Component
struct Index {
  @State posts: Array<ESObject> = [];
  @State comments: Array<ESObject> = [];
  @State showRelation: boolean = false;
  @State status: string = '准备就绪';

  aboutToAppear() {
    this.createTestData();
  }


  // 创建默认数据
  async createTestData() {
    const SkillsData: ESObject = ParseObject.extend('CommentForIndex');
    const query = new ParseQuery(SkillsData);

    try {
      // 检查是否已存在数据
      const count = await query.count();
      if (count === 0) {
        // 创建测试帖子
        const Post: ESObject = ParseObject.extend('PostForIndex');
        const post: ESObject = new Post();
        post.set('title', 'HarmonyOS开发技巧');
        post.set('content', '分享一些开发技巧');
        await post.save();

        // 创建两条关联评论
        const Comment: ESObject = ParseObject.extend('CommentForIndex');

        const comment1: ESObject = new Comment();
        comment1.set('content', '很有用的分享');
        comment1.set('post', post); // 关联帖子
        await comment1.save();

        const comment2: ESObject = new Comment();
        comment2.set('content', '期待更多内容');
        comment2.set('post', post); // 关联帖子
        await comment2.save();
      }

      // 初始加载普通数据
      this.loadNormalData();
    } catch (error) {
      console.error('创建默认数据失败:', error);
    }
  }

  // 加载普通数据
  async loadNormalData() {
    const Comment:ESObject = ParseObject.extend('CommentForIndex');
    const query = new ParseQuery(Comment);
    this.comments = await query.find();
    this.status = `加载了 ${this.comments.length} 条普通评论`;
  }

  // 加载关联数据
  async loadRelationData() {
    const Comment:ESObject = ParseObject.extend('CommentForIndex');
    const query = new ParseQuery(Comment);

    // 关联的post数据
    query.include('post');

    this.comments = await query.find();
    this.status = `加载了 ${this.comments.length} 条关联评论`;
    this.showRelation = true;
  }

  build() {
    Column({ space: 10 }) {
      // 状态显示
      Text(this.status)
        .fontSize(14)
        .margin({ bottom: 20 })

      // 切换按钮
      Button(this.showRelation ? '显示普通数据' : '显示关联数据')
        .onClick(() => {
          this.showRelation = !this.showRelation;
          this.showRelation ? this.loadRelationData() : this.loadNormalData();
        })
        .margin({ bottom: 20 })

      // 评论列表
      ForEach(this.comments, (comment:ESObject) => {
        Column() {
          Text(`评论内容: ${comment.get('content')}`)

          // 只有关联查询时才显示帖子信息
          if (this.showRelation && comment.get('post')) {
            Text(`关联帖子: ${comment.get('post').get('title')}`)
              .fontColor(Color.Blue)
              .margin({ top: 5 })
          }

          Divider()
        }
        .width('100%')
        .margin({ top: 10 })
      })

    }
    .width('100%')
    .padding(20)
  }
}