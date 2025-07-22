/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { promptAction } from '@kit.ArkUI';
import { Parse, ParseObject, ParseQuery } from '@ohos/parser-sdk';

@Entry
@Component
struct RelationalDataExample {
  // 数据状态
  @State articles: ParseObject[] = []    // 文章列表
  @State reviews: ParseObject[] = []     // 评论列表
  @State likedArticleIds: string[] = []  // 当前用户点赞过的文章ID
  @State message: string = ''

  aboutToAppear() {
    this.loadInitialData() // 初始化数据加载
  }

  // 加载初始数据
  loadInitialData() {
    this.queryArticles()
    this.queryMyLikes()
  }

  // 查询点赞状态
  async queryMyLikes() {
    const user = Parse.User.current();
    const likedArticles = await user?.relation("likes").query().find();
    this.likedArticleIds = likedArticles?.map(article => article.id as string) || [];
  }

  // 查询点赞数量
  queryUserLikes(){
    const currentUser = Parse.User.current()
    const relation = currentUser?.relation("likes")
    relation?.query().find().then(articles=>{
      this.message = `已添加${articles.length}个喜欢`
    })
  }

  // 创建文章+评论
  async createArticleWithReview() {
    try {
      const Article: ESObject = ParseObject.extend("Article");
      const article: ESObject = new Article();
      article.set("title", "HarmonyOS技巧");
      article.set("content", "如何高效使用Parse SDK");

      const Review: ESObject = ParseObject.extend("Review");
      const defaultReview: ESObject = new Review();
      defaultReview.set("content", "这是系统自动生成的默认评论");
      defaultReview.set("parent", article);

      await Parse.Object.saveAll([article, defaultReview]);
      promptAction.showToast({ message: "创建成功！" });
      this.queryArticles();
    } catch (err) {
      console.error("HMLog-->", JSON.stringify(err));
    }
  }

  // 查询方法
  async queryArticles() {
    const articleQuery = new ParseQuery(ParseObject.extend("Article"));
    this.articles = await articleQuery.find();

    const reviewQuery = new ParseQuery(ParseObject.extend("Review"));
    this.reviews = await reviewQuery.find();
  }

  // 点赞方法
  async toggleLike(article: ParseObject) {
    const user = Parse.User.current();
    const relation = user?.relation("likes");

    if (this.likedArticleIds.includes(article.id ?? '')) {
      relation?.remove(article);
      this.likedArticleIds = this.likedArticleIds.filter(id => id !== article.id);
    } else {
      relation?.add(article);
      this.likedArticleIds = [...this.likedArticleIds, article.id ?? ''];
    }

    await user?.save();
    promptAction.showToast({
      message: this.likedArticleIds.includes(article.id) ? "点赞成功" : "已取消点赞"
    });
  }

  // 数组存储关系
  async addTagsToArticle(){
    const article = this.articles[0];
    if (!article) return;

    article.addUnique("tags", ["tech", "harmonyos"]);
    await article.save();
    this.message = '已添加标签数组到文章';
  }

  // Include查询
  async queryArticlesWithReviews(){
    const query = new Parse.Query("Article");
    query.include("reviews");

    try {
      const results = await query.find();
      this.message = `获取到${results.length}篇文章及评论` + `${JSON.stringify(results)}`;
    } catch (e) {
      this.message = `获取失败: ${e.message || JSON.stringify(e)}`;
    }
  }

  // 连接表
  async createFollowRelationship() {
    try {
      const currentUser = Parse.User.current();
      if (!currentUser) {
        this.message = '请先登录';
        return;
      }

      const userQuery = new Parse.Query(Parse.User);
      userQuery.notEqualTo('objectId', currentUser.id);
      userQuery.limit(1);
      const otherUser = await userQuery.first();

      if (!otherUser) {
        this.message = '未找到其他用户';
        return;
      }

      const Follow: ESObject = Parse.Object.extend('Follow');
      const follow: ESObject = new Follow();

      follow.set('from', currentUser);
      follow.set('to', otherUser);
      follow.set('date', new Date());

      await follow.save();
      this.message = '已创建关注关系连接表';
    } catch (e) {
      this.message = `创建关系连接表失败: ${e.message || JSON.stringify(e)}`;
    }
  }

  // 一对一关系
  async createUserProfile(){
    try {
      const UserProfile: ESObject = Parse.Object.extend('UserProfile');
      const profile: ESObject = new UserProfile();

      profile.set('user', Parse.User.current());
      profile.set('bio', '这是我的个人资料');

      await profile.save()
      this.message = '创建用户个人资料成功'
    } catch (e) {
      this.message = `创建个人资料失败 ${e.message || JSON.stringify(e)}`;
    }
  }

  build() {
    Column({ space: 15 }) {
      Text(this.message)
        .fontSize(16)
        .margin({ top: 16 })

      Button('创建文章+评论(一对多)')
        .borderRadius(4)
        .type(ButtonType.Normal)
        .width('100%')
        .onClick(() => this.createArticleWithReview())

      Button('添加标签数组(Array)')
        .borderRadius(4)
        .type(ButtonType.Normal)
        .width('100%')
        .onClick(() => this.addTagsToArticle())

      Button('Include查询文章+评论')
        .borderRadius(4)
        .type(ButtonType.Normal)
        .width('100%')
        .onClick(() => this.queryArticlesWithReviews())

      Button('创建关注关系表')
        .borderRadius(4)
        .type(ButtonType.Normal)
        .width('100%')
        .onClick(() => this.createFollowRelationship())

      Button('创建个人资料')
        .borderRadius(4)
        .type(ButtonType.Normal)
        .width('100%')
        .onClick(() => this.createUserProfile())

      Button('查询点赞数量(多对多)')
        .borderRadius(4)
        .type(ButtonType.Normal)
        .width('100%')
        .onClick(()=> this.queryUserLikes())

      // 文章列表
      List({ space: 10 }) {
        ForEach(this.articles, (article: ParseObject) => {
          ListItem() {
            Column({ space: 5 }) {
              Text(article.get("title")).fontSize(18)
              Text(article.get("content")).fontColor(Color.Gray)

              Button(this.likedArticleIds.includes(article.id) ? '取消点赞' : '点赞')
                .onClick(() => this.toggleLike(article))
                .width(120)

              if (this.reviews.some(r => r.get("parent")?.id === article.id)) {
                Text('--- 评论 ---').margin({ top: 10 })
                ForEach(this.reviews.filter(
                  r => r.get("parent")?.id === article.id
                ), (review: ParseObject) => {
                  Text(review.get("content"))
                    .fontSize(14)
                    .fontColor('#666')
                })
              }
            }
            .backgroundColor('#ffdedede')
            .borderRadius(8)
            .width('100%')
            .padding(10)
          }
        })
      }
      .padding({bottom: 30})
      .height('60%')
    }
    .padding(20)
  }
}