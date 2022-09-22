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
/**
 * 该simple仅仅是提供protobuf如何配合webSocket使用案例
 */
import webSocket from '@ohos.net.webSocket';
import protobuf from 'protobufjs'

@Entry
@Component
struct WebSocket {
  @State responseData: string = "";
  @State requestData: string = "";

   aboutToAppear() {

    const protoStr = 'syntax = "proto3";message Message {required string text = 1;}';

    var newBuild = protobuf.newBuilder();
    var root = protobuf.loadProto(protoStr, newBuild, "websocket.proto");
    var Message = root.build("Message");

    var defaultIpAddr = "https://localhost:8080/"
    var ws = webSocket.createWebSocket();
    ws.connect(defaultIpAddr, (err, value) => {
      if (!err) {
        console.log("connect success")
      } else {
        console.log("connect fail")
      }
    });
    ws.on('open', (err, value) => {
      const data = { text: "hello websoket" };
      var msg = new Message(data);
      var arrayBuffer = msg.toArrayBuffer();
      //当首都奥on('open')事件时，可以通过send()方法与服务器进行通信
      ws.send(arrayBuffer, (err, value) => {
        if (!err) {
          console.log("send success")
        } else {
          console.log("send fail")
        }
      });
    });
    ws.on('message', (err, value) => {
      //当收到服务器的消息"close"时，主动断开连接
      if (value === "close") {
        ws.close((err, value) => {
          if (!err) {
            console.log("close success")
          } else {
            console.log("close fail")
          }
        });
      }

    });
    ws.on('close', (err, value) => {
      console.log("on close,code is" + value.code)
    });

    ws.on('error', (err) => {
      console.log("on error")
    });
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Text("该simple仅仅是protobuf如何配合webSocket使用案例，无需测验服务器地址")
        .fontSize(20)
        .margin({ top: 10 })
        .fontWeight(FontWeight.Bold);
      Text("链接能够通信的服务器地址，查看链接结果请看log，如果没有有效的服务器地址，会打印出connect fail,err:{'code':202,'data':WebSocketPlugin#:url is invalid} 否则会打印：connect success")
        .fontSize(20)
        .margin({ top: 10 })
        .fontWeight(FontWeight.Bold);
    }
    .width('100%')
    .height('100%')
  }
}