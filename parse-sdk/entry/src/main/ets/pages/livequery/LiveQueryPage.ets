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

import { LiveQueryClient, Parse, ParseObject, ParseQuery } from '@ohos/parser-sdk'

@Entry
@Component
struct Index {
  account: string = ''
  password: string = ''
  @State statusText: string = '';
  query: ParseQuery | undefined = undefined;
  subscribe: ESObject = null;
  client: LiveQueryClient | undefined | null = null;

  async aboutToAppear(): Promise<void> {
    this.query = new ParseQuery("GameScore");
    this.subscribe = await this.query.subscribe();
    console.log("livequery", "test-->")
  }

  async subscribeHandler() {
    console.log("livequery", `subscribeHandler`)
    this.subscribe.on('open', (object: ESObject) => {
      this.statusText = `subscribe open ${object}`;
      console.log("livequery", `subscribe open ${object}`)
    });
    this.subscribe.on('create', (object: ESObject) => {
      this.statusText = `subscribe create ${object}`;
      console.log("livequery", `subscribe create ${object}`)
    });
    this.subscribe.on('update', (object: ESObject) => {
      this.statusText = `subscribe update ${object}`;
      console.log("livequery", `subscribe update ${object}`)
    });
    this.subscribe.on('enter', (object: ESObject) => {
      this.statusText = `subscribe enter ${object}`;
      console.log("livequery", `subscribe enter ${object}`)
    });
    this.subscribe.on('leave', (object: ESObject) => {
      this.statusText = `subscribe leave ${object}`;
      console.log("livequery", `subscribe leave ${object}`)
    });
    this.subscribe.on('delete', (object: ESObject) => {
      this.statusText = `subscribe delete ${object}`;
      console.log("livequery", `subscribe delete ${object}`)
    });
    this.subscribe.on('close', (object: ESObject) => {
      this.statusText = `subscribe close ${object}`;
      console.log("livequery", `subscribe close ${object}`)
    });
  }

  async unsubscribeHandler() {
    this.statusText = '取消订阅...';
    await this.subscribe.unsubscribe();
    this.statusText = '已取消订阅';
  }

  async connectHandler() {
    this.statusText = '连接中...' + "connectHandler";
    console.log("livequery", "connectHandler")
    let config: ESObject = {
      applicationId: '123456',
      serverURL: 'ws://8.210.151.59:1337',
    }
    this.client = new LiveQueryClient(config);
    this.client.on('open', () => {
      this.statusText = '已连接' + "connectHandler";
      console.log("livequery", "client open")
    });
    this.client.on('close', () => {
      this.statusText = '连接关闭' + "connectHandler";
      console.log("livequery", `client close`)
    });
    this.client.on('error', (error: ESObject) => {
      this.statusText = '连接失败 ' + `client error ${JSON.stringify(error)}`;
      console.log("livequery", `client error ${JSON.stringify(error)}`)
    });
    this.client.open();
  }

  closeHandler() {
    this.statusText = '关闭连接...';
    this.client?.close().then(() => {
      this.statusText = '连接已关闭';
    }).catch((err: ESObject) => {
      console.log('livequery', JSON.stringify(err));
    })
  }

  async saveHandler() {
    this.statusText = '保存中...';
    let GameScore: ESObject = ParseObject.extend("GameScore");
    const gameScore: ESObject = new GameScore();
    gameScore.set("score", 2000);
    gameScore.set("playerName", "Sean Plott");
    gameScore.set("cheatMode", false);
    const acl = new Parse.ACL();
    acl.setPublicReadAccess(true);
    acl.setPublicWriteAccess(true);
    gameScore.setACL(acl);
    gameScore.save()
      .then((gameScore: ESObject) => {
        this.statusText = '创建成功: ' + 'New object created with objectId: ' + gameScore.id;
        console.log("livequery", 'New object created with objectId: ' + gameScore.id);
      }, (error: ESObject) => {
        this.statusText = '失败: ' + 'Failed to create new object, with error code: ' + error.message;
        console.log("livequery", 'Failed to create new object, with error code: ' + error.message);
      });
  }

  build() {
    Column({ space: 20 }) {
      // 添加状态文本显示
      Text('message: ' + this.statusText)
        .fontSize(16)

      Button('Save Object')
        .borderRadius(4)
        .type(ButtonType.Normal)
        .width('100%')
        .onClick(async () => {
          await this.saveHandler();
        })
      Button('Subscribe')
        .borderRadius(4)
        .type(ButtonType.Normal)
        .width('100%')
        .onClick(async () => {
          await this.subscribeHandler();
        })
      Button('Unsubscribe')
        .borderRadius(4)
        .type(ButtonType.Normal)
        .width('100%')
        .onClick(async () => {
          await this.unsubscribeHandler();
        })
      Button('Connect')
        .borderRadius(4)
        .type(ButtonType.Normal)
        .width('100%')
        .onClick(async () => {
          await this.connectHandler();
        })
      Button('Close')
        .borderRadius(4)
        .type(ButtonType.Normal)
        .width('100%')
        .onClick(async () => {
          await this.closeHandler();
        })
    }
    .width('100%')
    .height('100%')
    .padding(20)
  }
}