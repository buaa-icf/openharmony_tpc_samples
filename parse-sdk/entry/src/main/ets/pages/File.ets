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
import { Parse, ParseFile, ParseObject } from '@ohos/parser-sdk'
import { util } from '@kit.ArkTS'
import { promptAction } from '@kit.ArkUI'

@Entry
@Component
struct File {
  @State message: string = ''
  objectId: string = ''

  build() {
    Scroll() {
      Column({ space: 20 }) {
        Button('Creating a Parse.File')
          .borderRadius(4)
          .type(ButtonType.Normal)
          .width('100%')
          .onClick(async () => {
            const textData = 'Hello Parse';
            const textEncoder = new util.TextEncoder();
            const unit8Arr = textEncoder.encodeInto(textData);
            const base64Data = ParseFile.encodeBase64(unit8Arr);

            const Post: ESObject = ParseObject.extend('Post');
            const post: ESObject = new Post();
            const textFile = new Parse.File('test.txt', { base64: base64Data });

            post.set('txt', textFile);
            post.save().then((post: ParseObject) => {
              this.message = '文本文件创建成功:' + textFile.url();
              this.objectId = post._getId();
            }).catch((err: ESObject) => {
              this.message = '文本文件创建失败:' + textFile.url();
            })
          })

        Button('Retrieving File Contents')
          .borderRadius(4)
          .type(ButtonType.Normal)
          .width('100%')
          .onClick(() => {
            const Post: ESObject = ParseObject.extend('Post');
            const query = new Parse.Query(Post);
            query.get(this.objectId).then((post) => {
              const parseFile: ParseFile = post.get('txt');
              if (parseFile) {
                parseFile.getData().then((val) => {
                  this.message = '获取文件内容成功 ：' + val;
                }).catch((err: ESObject) => {
                  this.message = '获取文件内容失败：' + JSON.stringify(err);
                })
              } else {
                this.message = 'Post中没有关联文件';
              }
            }).catch((err: ESObject) => {
              this.message = '获取Post对象失败'
            })
          })

        Button('Adding Metadata and Tags')
          .borderRadius(4)
          .type(ButtonType.Normal)
          .width('100%')
          .onClick(() => {
            const Post: ESObject = ParseObject.extend('Post');
            const query = new Parse.Query(Post);
            query.get(this.objectId).then((post) => {
              const parseFile: ParseFile = post.get('txt');
              if (parseFile) {
                parseFile.addMetadata('createdById', 'some-user-id');
                parseFile.addTag('groupId', 'some-group-id');
                post.set('txt', parseFile);
                post.save().then((post: ParseObject) => {
                  this.message = '添加元数据成功'
                  this.objectId = post._getId();
                }).catch((err: ESObject) => {
                  this.message = '添加元数据失败' + JSON.stringify(err);
                })
              } else {
                this.message = 'Post中没有关联文件';
              }
            }).catch((err: ESObject) => {
              this.message = '获取Post对象失败';
            })
          })

        Text(this.message)
          .fontSize(16)
      }
      .margin(10)
    }
    .width('100%')
    .height('100%')
  }
}