/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
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

import protobuf from 'protobufjs'

/**
 * 如果需要使用loadProtoFile或loadJsonFile这两个接口，则需要在protobuf引入之后，
 * 需要执行一次protobuf.Util.fetch = function (path, callback) {……}方法以此来适配fs的系统方案
 */
import { MyFs } from './MyFs'
protobuf.Util.fetch = function (path, callback) {
  if (callback && typeof callback != 'function')
  callback = null;
  if (callback) {
    MyFs.readFile(path, function (err, data) {
      if (err)
      callback(null);
      else
      callback("" + data);
    });
  } else
  try {
    return MyFs.readFileSync(path);
  } catch (e) {
    return null;
  }
}

import { FileUtils } from './FileUtils'
import util from '@ohos.util';




const protoStr = 'syntax = "proto3"; package com.user;message UserLoginResponse{string sessionId = 1;string userPrivilege = 2;bool isTokenType = 3;string formatTimestamp = 4;}';

const protoJson = JSON.stringify({
  "package": "com.user",
  "syntax": "proto3",
  "messages": [
    {
      "name": "UserLoginResponse",
      "fields": [
        {
          "rule": "optional",
          "type": "string",
          "name": "sessionId",
          "id": 1,
        },
        {
          "rule": "optional",
          "type": "string",
          "name": "userPrivilege",
          "id": 2,
        },
        {
          "rule": "optional",
          "type": "bool",
          "name": "isTokenType",
          "id": 3
        },
        {
          "rule": "optional",
          "type": "string",
          "name": "formatTimestamp",
          "id": 4,
        }
      ]
    }
  ]
});

@Entry
@Component
struct Serialized {
  @State bufferData: string = "";
  @State decodeData: string = "";
  private content: string = "Second Page"
  str: string = '';
  array: Array<string>;
  fileName: string = "userproto.proto"
  scroller: Scroller = new Scroller()


  /**
   * test loadProtoFile interface 测试 同步 加载proto文件解析的方法
   * @param path proto file path，当前不能直接读取项目目录路径，path只能先将文件存入内存后的路径
   */
  testSynchronouslyLoadProtoFile(path: string): void{
    var root = protobuf.loadProtoFile(path);
    //读取完文件的数据后清理掉，避免二次进入页面数据重复存储导致错误
    FileUtils.getInstance().clearFile(path);

    var UserLoginResponse = root.build("com.user.UserLoginResponse");

    const userLogin = {
      sessionId: "testSynchronouslyLoadProtoFile",
      userPrivilege: "John123",
      isTokenType: false,
      formatTimestamp: "12342222"
    };

    var msg = new UserLoginResponse(userLogin);
    console.log("msg:" + msg);

    var arrayBuffer = msg.toArrayBuffer();
    console.log("arrayBuffer:" + new Uint8Array(arrayBuffer));
    this.bufferData = Array.prototype.toString.call(new Uint8Array(arrayBuffer));

    var decodeMsg = UserLoginResponse.decode(arrayBuffer);
    console.log("decode:" + JSON.stringify(decodeMsg));
    this.decodeData = JSON.stringify(decodeMsg);
  }

  /**
   * test loadProtoFile interface 测试 异步 加载proto文件解析的方法
   * @param path proto file path，当前不能直接读取项目目录路径，path只能先将文件存入内存后的路径
   */
  testAsynchronouslyLoadProtoFile(path: string): void{
    var builder = protobuf.newBuilder();
    protobuf.loadProtoFile(path, (err, root) => {
      //读取完文件的数据后清理掉，避免二次进入页面数据重复存储导致错误
      FileUtils.getInstance().clearFile(path);

      var UserLoginResponse = root.build("com.user.UserLoginResponse");

      const userLogin = {
        sessionId: "testAsynchronouslyLoadProtoFile",
        userPrivilege: "John123",
        isTokenType: false,
        formatTimestamp: "12342222"
      };

      var msg = new UserLoginResponse(userLogin);
      console.log("msg:" + msg);

      var arrayBuffer = msg.toArrayBuffer();
      console.log("arrayBuffer:" + new Uint8Array(arrayBuffer));
      this.bufferData = Array.prototype.toString.call(new Uint8Array(arrayBuffer));

      var decodeMsg = UserLoginResponse.decode(arrayBuffer);
      console.log("decode:" + JSON.stringify(decodeMsg));
      this.decodeData = JSON.stringify(decodeMsg);
    }, builder);

  }

  /**
   *  test loadProto interface 测试加载proto string的方法
   * @param proto is proto Format, type string
   * @param fileName fileName The corresponding file name if known, mey any Name ,but no same
   */
  testMethodLoadProto(proto: string, fileName: string): void{
    var builder = protobuf.newBuilder();


    var root = protobuf.loadProto(proto, builder, fileName);

    var UserLoginResponse = root.build("com.user.UserLoginResponse");
   console.log("root"+UserLoginResponse)
    const userLogin = {
      sessionId: "testMethodLoadProto",
      userPrivilege: "John123",
      isTokenType: false,
      formatTimestamp: "12342222"
    };

    var msg = new UserLoginResponse(userLogin);
    console.log("msg:" + msg);

    var arrayBuffer = msg.toArrayBuffer();
    console.log("arrayBuffer:" + new Uint8Array(arrayBuffer));
    this.bufferData = Array.prototype.toString.call(new Uint8Array(arrayBuffer));

    var decodeMsg = UserLoginResponse.decode(arrayBuffer);
    console.log("decode:" + JSON.stringify(decodeMsg));
    this.decodeData = JSON.stringify(decodeMsg);
  }

  /**
 *  test loadProto interface 测试加载proto string的方法
 * @param context globalThis.context是通过在MainAbility->MainAbility.ts的onCreate中定义的一个属性{globalThis.context = this.context;}
 * @param id 是资源文件id
 * @param fileName fileName The corresponding file name if known, mey any Name ,but no same
 */
  testMethodLoadProtoFromResourcesFile(context: any, id: Number, fileName: string): void{
    context.resourceManager.getMedia(id)
      .then(data => {
        let resStr = new util.TextDecoder("utf-8", {
          ignoreBOM: true
        });
        let protoStr = resStr.decode(data);
        return this.testMethodLoadProto(protoStr, fileName)
      });

  }

  /**
   * test loadJson interface
   * @param json is proto Format, type string
   * @param fileName filename The corresponding file name if known, mey any Name ,but no same
   */
  testMethodLoadJson(json: string, fileName: string): void{
    var builder = protobuf.newBuilder();
    var root = protobuf.loadJson(json, builder, fileName);

    var UserLoginResponse = root.build("com.user.UserLoginResponse");
    console.log("arrayBuffer:" + protoJson);
    const userLogin = {
      sessionId: "testMethodLoadJson",
      userPrivilege: "John123",
      isTokenType: false,
      formatTimestamp: "12342222"
    };

    var msg = new UserLoginResponse(userLogin);
    console.log("msg:" + msg);

    var arrayBuffer = msg.toArrayBuffer();
    console.log("arrayBuffer:" + new Uint8Array(arrayBuffer));
    this.bufferData = Array.prototype.toString.call(new Uint8Array(arrayBuffer));

    var decodeMsg = UserLoginResponse.decode(arrayBuffer);
    console.log("decode:" + JSON.stringify(decodeMsg));
    this.decodeData = JSON.stringify(decodeMsg);
  }

  /**
   * test loadJson interface
   * @param context globalThis.context是通过在MainAbility->MainAbility.ts的onCreate中定义的一个属性{globalThis.context = this.context;}
   * @param id 是资源文件id
   * @param fileName filename The corresponding file name if known, mey any Name ,but no same
   */
  testMethodLoadJsonFromResourceFile(context: any, id: Number, fileName: string): void{
    context.resourceManager.getMedia(id)
      .then(data => {
        let resStr = new util.TextDecoder("utf-8", {
          ignoreBOM: true
        });
        let jsonStr = resStr.decode(data);
        return this.testMethodLoadJson(jsonStr, fileName)
      });
  }

  /**
   * test LoadJsonFile interface 测试 同步 加载Json文件解析的方法
   * @param path filename The corresponding file name if known, mey any Name ,but no same
   */
  testSynchronouslyLoadJsonFile(path: string): void{
    var root = protobuf.loadJsonFile(path);
    //读取完文件的数据后清理掉，避免二次进入页面数据重复存储导致错误
    FileUtils.getInstance().clearFile(path);

    var UserLoginResponse = root.build("com.user.UserLoginResponse");

    const userLogin = {
      sessionId: "testSynchronouslyLoadJsonFile",
      userPrivilege: "John123",
      isTokenType: false,
      formatTimestamp: "12342222"
    };

    var msg = new UserLoginResponse(userLogin);
    console.log("msg:" + msg);

    var arrayBuffer = msg.toArrayBuffer();
    console.log("arrayBuffer:" + new Uint8Array(arrayBuffer));
    this.bufferData = Array.prototype.toString.call(new Uint8Array(arrayBuffer));

    var decodeMsg = UserLoginResponse.decode(arrayBuffer);
    console.log("decode:" + JSON.stringify(decodeMsg));
    this.decodeData = JSON.stringify(decodeMsg);
  }

  /**
  * test LoadJsonFile interface 测试 异步 加载Json文件解析的方法
  * @param path proto file path，当前不能直接读取项目目录路径，path只能先将文件存入内存后的路径
  */
  testAsynchronouslyLoadJsonFile(path: string): void{
    var builder = protobuf.newBuilder();
    protobuf.loadJsonFile(path, (err, root) => {
      //读取完文件的数据后清理掉，避免二次进入页面数据重复存储导致错误
      FileUtils.getInstance().clearFile(path);

      var UserLoginResponse = root.build("com.user.UserLoginResponse");

      const userLogin = {
        sessionId: "testAsynchronouslyLoadJsonFile",
        userPrivilege: "John123",
        isTokenType: false,
        formatTimestamp: "8888888"
      };

      var msg = new UserLoginResponse(userLogin);
      console.log("msg:" + msg);

      var arrayBuffer = msg.toArrayBuffer();
      console.log("arrayBuffer:" + new Uint8Array(arrayBuffer));
      this.bufferData = Array.prototype.toString.call(new Uint8Array(arrayBuffer));

      var decodeMsg = UserLoginResponse.decode(arrayBuffer);
      console.log("decode:" + JSON.stringify(decodeMsg));
      this.decodeData = JSON.stringify(decodeMsg);
    }, builder);
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Scroll(this.scroller) {
        Column() {
          Text("序列化数据：" + this.bufferData)
            .fontSize(13)
            .margin({ top: 10, left: 10 })
          Text("反序列化数据：" + this.decodeData)
            .fontSize(13)
            .margin({ top: 5, left: 10 })
          Text("测试同步加载proto文件")
            .width('90%')
            .height(50)
            .backgroundColor(0xFFFFFF)
            .borderRadius(15)
            .fontSize(16)
            .textAlign(TextAlign.Center)
            .margin({ top: 10 })
            .onClick(event => {
              //创建一个proto文件内存路径,globalThis.context是通过在MainAbility->MainAbility.ts的onCreate中定义的一个属性{globalThis.context = this.context;}
              let protoPath = globalThis.context.filesDir + "/userproto.proto";
              //将proto数据写入内存
              FileUtils.getInstance().writeData(protoPath, protoStr);
              //测试 同步 加载proto文件解析的方法
              this.testSynchronouslyLoadProtoFile(protoPath);
            });
          Text("测试异步加载proto文件")
            .width('90%')
            .height(50)
            .backgroundColor(0xFFFFFF)
            .borderRadius(15)
            .fontSize(16)
            .textAlign(TextAlign.Center)
            .margin({ top: 10 })
            .onClick(event => {
              //创建一个proto文件内存路径,globalThis.context是通过在MainAbility->MainAbility.ts的onCreate中定义的一个属性{globalThis.context = this.context;}
              let protoPath = globalThis.context.filesDir + "/userproto.proto";
              //将proto数据写入内存
              FileUtils.getInstance().writeData(protoPath, protoStr);
              //测试 同步 加载proto文件解析的方法
              this.testAsynchronouslyLoadProtoFile(protoPath);
            });
          Text("测试解析proto字符串")
            .width('90%')
            .height(50)
            .backgroundColor(0xFFFFFF)
            .borderRadius(15)
            .fontSize(16)
            .textAlign(TextAlign.Center)
            .margin({ top: 10 })
            .onClick(event => {
              //测试加载proto string的方法
              this.testMethodLoadProto(protoStr, this.fileName);
            });
          Text("测试resources放置proto文件解析(数据同上)")
            .width('90%')
            .height(50)
            .backgroundColor(0xFFFFFF)
            .borderRadius(15)
            .fontSize(16)
            .textAlign(TextAlign.Center)
            .margin({ top: 10 })
            .onClick(event => {
              //测试resources->media加载资源文件的方式
              this.testMethodLoadProtoFromResourcesFile(globalThis.context, $r('app.media.userproto').id, this.fileName)
            });
          Text("测试同步加载json文件")
            .width('90%')
            .height(50)
            .backgroundColor(0xFFFFFF)
            .borderRadius(15)
            .fontSize(16)
            .textAlign(TextAlign.Center)
            .margin({ top: 10 })
            .onClick(event => {
              //创建一个json文件内存路径
              let jsonPath = globalThis.context.filesDir + "/userproto.json";
              //    //测试加载json文件的方式，将json数据写入内存
              FileUtils.getInstance().writeData(jsonPath, protoJson);
              //同步
              this.testSynchronouslyLoadJsonFile(jsonPath);
            });
          Text("测试异步加载json文件")
            .width('90%')
            .height(50)
            .backgroundColor(0xFFFFFF)
            .borderRadius(15)
            .fontSize(16)
            .textAlign(TextAlign.Center)
            .margin({ top: 10 })
            .onClick(event => {
              //创建一个json文件内存路径
              let jsonPath = globalThis.context.filesDir + "/userproto.json";
              //    //测试加载json文件的方式，将json数据写入内存
              FileUtils.getInstance().writeData(jsonPath, protoJson);
              //异步
              this.testAsynchronouslyLoadJsonFile(jsonPath);
            });
           Text("测试解析json字符串")
            .width('90%')
            .height(50)
            .backgroundColor(0xFFFFFF)
            .borderRadius(15)
            .fontSize(16)
            .textAlign(TextAlign.Center)
            .margin({ top: 10 })
            .onClick(event => {
              //测试普通加载json字符串
              this.testMethodLoadJson(protoJson, this.fileName);
            });
          Text("测试resources放置json文件解析(数据同上)")
            .width('90%')
            .height(50)
            .backgroundColor(0xFFFFFF)
            .borderRadius(15)
            .fontSize(16)
            .textAlign(TextAlign.Center)
            .margin({ top: 10 })
            .onClick(event => {
              //测试resources->media加载资源文件的方式
              this.testMethodLoadJsonFromResourceFile(globalThis.context, $r('app.media.userjson').id, this.fileName)
            });
        }.width('100%');
      }
      .scrollable(ScrollDirection.Vertical).scrollBar(BarState.On)
      .scrollBarColor(Color.Gray).scrollBarWidth(30);
      Button('重置显示', { type: ButtonType.Capsule, stateEffect: true })
        .backgroundColor(0x317aff)
        .margin({ top: 200,left:5 })
        .width(110)
        .onClick(event => {
          this.bufferData = "";
          this.decodeData = "";
        });
    }.width('100%').height('100%').backgroundColor(0xDCDCDC)
  }
}