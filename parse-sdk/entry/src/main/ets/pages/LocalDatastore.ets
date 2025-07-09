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
import { IndexedDBStorageController, Parse } from '@ohos/parser-sdk'

@Entry
@Component
struct LocalDatastore {
  account: string = ''
  password: string = ''
  ip: string = ''
  email: string = ''
  dbStorageController = new IndexedDBStorageController()
  @State message: string = ''
  userId: string | undefined = ''

  aboutToAppear(): void {
    Parse.enableLocalDatastore()
  }

  build() {
    Scroll() {
      Column({ space: 20 }) {
        Button('创建类')
          .borderRadius(4)
          .type(ButtonType.Normal)
          .width('100%')
          .onClick(async () => {
            this.message = ''
            try {
              const GameScore: ESObject = Parse.Object.extend("GameScore");
              const gameScore: ESObject = new GameScore();
              await gameScore.save();
              await gameScore.pin();

              await Parse.Object.pinAll([gameScore]);
              this.message = '创建本地对象成功'
            } catch (e) {
              console.info('test-->' + JSON.stringify(e))
              this.message = '创建本地对象失败:' + JSON.stringify(e)
            }
          })

        Button('Retrieving')
          .borderRadius(4)
          .type(ButtonType.Normal)
          .width('100%')
          .onClick(async () => {
            this.message = ''
            try {
              const GameScore: ESObject = Parse.Object.extend("GameScore");
              const gameScore: ESObject = new GameScore();
              gameScore.set("score", 100);
              gameScore.set("playerName", "Test Player");

              // 保存到服务器
              await gameScore.save();
              console.log("对象已保存到服务器，objectId:", gameScore.id);

              // 2. 将对象固定(pin)到本地存储（关键步骤）
              await gameScore.pin();
              console.log("对象已固定到本地存储");

              // 3. 从本地存储查询对象（使用正确的 objectId）
              const query = new Parse.Query(GameScore);

              // 指定从本地存储查询
              query.fromLocalDatastore();

              // 使用刚创建对象的实际 ID
              const result = await query.get(gameScore.id);

              this.message = '检索本地对象成功: ' + JSON.stringify(result.attributes);
            } catch (e) {
              console.error('test-->' + JSON.stringify(e));
              this.message = '检索本地对象失败: ' + JSON.stringify(e);
            }
          })


        Button('Querying')
          .borderRadius(4)
          .type(ButtonType.Normal)
          .width('100%')
          .onClick(async () => {
            this.message = ''
            try {
              const GameScore: ESObject = Parse.Object.extend("GameScore");
              const gameScore: ESObject = new GameScore();
              gameScore.set("score", 100);
              gameScore.set("playerName", "Joe Bob");

              await gameScore.save();
              console.log("对象已保存到服务器，objectId:", gameScore.id);

              await gameScore.pin();
              console.log("对象已固定到本地存储");
              const query = new Parse.Query(GameScore);
              query.equalTo('playerName', 'Joe Bob');
              query.fromLocalDatastore();
              const results = await query.find();
              this.message = 'Querying success: ' + JSON.stringify(results);
            } catch (e) {
              console.error('test-->' + JSON.stringify(e));
              this.message = 'Querying failed: ' + JSON.stringify(e);
            }
          })


        Button('Unpinning')
          .borderRadius(4)
          .type(ButtonType.Normal)
          .width('100%')
          .onClick(async () => {
            this.message = ''
            try {
              const GameScore: ESObject = Parse.Object.extend("GameScore");
              const gameScore: ESObject = new GameScore();
              const gameScore1: ESObject = new GameScore();
              await Parse.Object.pinAll([gameScore, gameScore1]);
              let localDatastore: ESObject = await Parse.LocalDatastore._getAllContents();
              this.message += ' pinAll  成功: ' + JSON.stringify(localDatastore) + '\r\n\r\n'
              await Parse.Object.saveAll([gameScore, gameScore1]);
              await gameScore1.unPin();
              let localDatastore1: ESObject = await Parse.LocalDatastore._getAllContents()
              this.message += ' unPin  成功: ' + JSON.stringify(localDatastore1) + '\r\n\r\n'
              await Parse.Object.unPinAllObjects();
              let localDatastore2: ESObject = await Parse.LocalDatastore._getAllContents();
              this.message += ' unPinAllObjects  成功: ' + JSON.stringify(localDatastore2);
            } catch (e) {
              console.error('test-->' + JSON.stringify(e));
              this.message = '创建本地对象失败: ' + JSON.stringify(e);
            }
          })


        Button('dumpLocalDatastore')
          .borderRadius(4)
          .type(ButtonType.Normal)
          .width('100%')
          .onClick(async () => {
            this.message = ''
            try {
              const GameScore: ESObject = Parse.Object.extend("GameScore");
              const gameScore: ESObject = new GameScore();
              const gameScore1: ESObject = new GameScore();
              await Parse.Object.pinAll([gameScore, gameScore1]);
              let localDatastore: ESObject = await Parse.dumpLocalDatastore();
              this.message += ' dumpLocalDatastore  success : ' + JSON.stringify(localDatastore) + '\r\n\r\n'
            } catch (e) {
              console.error('test-->' + JSON.stringify(e));
              this.message = 'dumpLocalDatastore failed: ' + JSON.stringify(e);
            }
          })

        Button('Caching Query Results')
          .borderRadius(4)
          .type(ButtonType.Normal)
          .width('100%')
          .onClick(async () => {
            this.message = ''
            try {
              const GameScore: ESObject = Parse.Object.extend("GameScore");
              const query = new Parse.Query(GameScore);
              query.equalTo("playerName", "foo");
              const results = await query.find();
              await Parse.Object.unPinAllObjectsWithName('HighScores');
              await Parse.Object.pinAllWithName('HighScores', results);
              let localDatastore: ESObject = await Parse.LocalDatastore._getAllContents()
              this.message += ' Caching Query Results : ' + JSON.stringify(localDatastore) + '\r\n\r\n'
            } catch (e) {
              console.error('test-->' + JSON.stringify(e));
              this.message = 'Caching Query failed: ' + JSON.stringify(e);
            }
          })

        Button('pinAllWithName')
          .borderRadius(4)
          .type(ButtonType.Normal)
          .width('100%')
          .onClick(async () => {
            this.message = ''
            try {
              const GameScore: ESObject = Parse.Object.extend("GameScore");
              const gameScore: ESObject = new GameScore();
              gameScore.set("score", 100);
              gameScore.set("playerName", "Joe Bob");

              await gameScore.save();
              await Parse.Object.pinAllWithName('MyScores', [gameScore]);

              await gameScore.pinWithName('MyScores');
              let localDatastore: ESObject = await Parse.LocalDatastore._getAllContents()
              this.message += 'pinAllWithNames Results : ' + JSON.stringify(localDatastore) + '\r\n\r\n'
            } catch (e) {
              console.error('test-->' + JSON.stringify(e));
              this.message = 'pinAllWithName failed: ' + JSON.stringify(e);
            }
          })

        Button('pinWithName')
          .borderRadius(4)
          .type(ButtonType.Normal)
          .width('100%')
          .onClick(async () => {
            this.message = ''
            try {
              const GameScore: ESObject = Parse.Object.extend("GameScore");
              const gameScore: ESObject = new GameScore();
              gameScore.set("score", 100);
              gameScore.set("playerName", "Joe Bob");

              await gameScore.save();

              await gameScore.pinWithName('MyScores');
              let localDatastore: ESObject = await Parse.LocalDatastore._getAllContents()
              this.message += ' pinWithName success : ' + JSON.stringify(localDatastore) + '\r\n\r\n'
            } catch (e) {
              console.error('test-->' + JSON.stringify(e));
              this.message = 'pinWithName failed: ' + JSON.stringify(e);
            }
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