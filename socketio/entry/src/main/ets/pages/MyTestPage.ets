/*
 * Copyright (C) 2022 Huawei Device Co., Ltd.
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to all conditions.
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import { BasicDataSource } from '../common/BasicDataSource';
import prompt from '@ohos.promptAction';
import promptAction from '@ohos.promptAction';
import { client_socket } from '@ohos/socketio';

@Entry
@Component
struct MyTestPage {
  @State message: string = 'Hello World';
  private chatDetailData = new ChatDetailData();
  @State uri: string = 'http://10.50.80.27:3000';
  @State connect_finish: boolean = false;
  @State login_finish: boolean = false;
  private client: client_socket = new client_socket();
  private scroller: Scroller = new Scroller();

  aboutToDisappear() {
    this.client.emit("leave", "testroom");
    this.client.close();
    this.client.clear_socket_listeners();
  }

  build() {
    Row() {
      Column() {
        Flex({
          justifyContent: FlexAlign.Start,
          alignItems: ItemAlign.Center,
          alignContent: FlexAlign.Center,
          direction: FlexDirection.Column
        }) {
          TextInput({ placeholder: "请输入消息,退出聊天室请输入exit", text: this.message })
            .width('80%')
            .height(80)
            .onChange((message) => {
              this.message = message
            })
            .margin({
              top: 50,
              bottom: 10
            })

          Button('Send')
            .onClick(() => {
              this.sendMessage(this.message)
            })
            .margin({
              top: 10,
              bottom: 10
            })
            .width('20%')
          Text()
            .width('100%')
            .height(50)
            .backgroundColor(Color.Pink)

          List({ scroller: this.scroller }) {
            LazyForEach(this.chatDetailData, (message: ESObject) => {
              ListItem() {
                Text(message)
                  .width("100%")
                  .fontSize(16)
                  .textAlign(TextAlign.Center)
                  .borderWidth(2)
                  .height(60)
                  .borderColor(Color.Gray)
                  .borderStyle(BorderStyle.Solid)
                  .backgroundColor(0xFFFFFF)
              }
            })
          }
          .listDirection(Axis.Vertical)
          .backgroundColor(Color.Pink)
          .height(500)
          .divider({ strokeWidth: 2, color: "#f3f3f3" })
          .width('100%')
        }
      }
      .width('100%')
    }
  }

  on_open(): void {
    this.connect_finish = true;
    promptAction.showToast({
      message: '连接服务器成功'
    })
  }

  on_fail(): void {
    console.log("on_fail");
  }

  on_reconnecting(): void {
    console.log("on_reconnecting");
  }

  on_reconnect(): void {
    console.log("on_reconnect");
  }
  pushData(any: ESObject) {
    if (!any || (typeof any === 'string' && any.length < 1)) {
      return
    }
    setTimeout(() => {
      this.chatDetailData.pushData(any);
      console.log("pushData  : " + JSON.stringify(this.chatDetailData));
    }, 300);
  }

  on_close(reason: string): void {
    this.connect_finish = false;
    console.log("on_close: " + reason);
  }

  on_socket_open(nsp: string): void {
    console.log("on_socket_open: " + nsp);
  }

  on_socket_close(nsp: string): void {
    console.log("on_socket_close: " + nsp);
  }

  on_login_listener(event_json: string): void {
    console.log("on_login_listener: " + event_json);
    if (event_json) {
      let loginCall = JSON.stringify(event_json);
      this.pushData(loginCall);
    }
    this.client.emit("join test room", "王二麻子")
  }

  on_new_message_listener(event_json: ESObject): void {
    console.log("on_new_message_listener: " + event_json);
    let messageCall = JSON.stringify(event_json);
    this.pushData(messageCall);
  }

  on_user_joined_listener(event_json: string): void {
    console.log("on_user_joined_listener: " + event_json);
    if (event_json) {
      let userJoinCall = JSON.stringify(event_json);
      this.pushData(userJoinCall);
    }

  }

  on_user_left_listener(event_json: string): void {
    console.log("on_user_left_listener: " + event_json);
    if (event_json) {
      let userLeftCall = JSON.stringify(event_json);
      this.pushData(userLeftCall);
    }
  }

  on_emit_callback(data: ESObject): void {
    console.log("on_emit_callback: " + data);
    if (data) {
      let emitCallBack = JSON.stringify(data);
      this.pushData(emitCallBack);
    }
  }

  on_user_joined_callback(data: ESObject): void {
    console.log("on_user_joined_callback: " + data);
    if (data) {
      this.pushData(JSON.stringify(data));
    }
  }

  on_msg_callback(data: ESObject): void {
    console.log("on_msg_callback: " + data);
    if (data) {
      this.pushData(JSON.stringify(data));
    }
  }

  on_leave_callback(data: ESObject): void {
    console.log("on_leave_callback: " + data);
    if (data) {
      this.pushData(JSON.stringify(data));
    }
  }

  on_local_callback(data: ESObject): void {
    console.log("on_local_callback: " + data);
    if (data) {
      this.pushData(JSON.stringify(data));
    }
  }

  onPageShow() {
    const ctx = this;
    ctx.initClient(ctx.uri);
    ctx.initSocket();
    setTimeout(() => {
      ctx.login("测试用户007")
    }, 2000)
  }
  // 配置client
  initClient(uri: string) {
    console.log("initClient: ");
    console.log("this.client: " + this.client);
    this.client.set_open_listener(()=>{
      this.on_open();
    });
    this.client.set_fail_listener(()=>{
      this.on_fail();
    });
    this.client.set_reconnecting_listener(()=>{
      this.on_reconnecting();
    });
    this.client.set_reconnect_listener(()=>{
      this.on_reconnect();
    });
    this.client.set_close_listener((reason: string)=>{
      this.on_close(reason);
    });
    this.client.set_socket_open_listener((nsp: string)=>{
      this.on_socket_open(nsp);
    });
    this.client.set_socket_close_listener((nsp: string)=>{
      this.on_socket_close(nsp);
    });
    this.client.connect(uri);
  }

  // 配置Socket
  initSocket() {
    console.log("initSocket: ");
    this.client.on("new message", (event_json: ESObject)=>{
      this.on_new_message_listener(event_json);
    });
    this.client.on("user joined", (event_json: string)=>{
      this.on_user_joined_listener(event_json);
    });
    this.client.on("user left", (event_json: string)=>{
      this.on_user_left_listener(event_json);
    });
    this.client.on("localmsg", (data: ESObject)=>{
      this.on_local_callback(data);
    });
    // this.client.on("msg",this.on_msg_callback);
    this.client.on("leavecall", (data: ESObject)=>{
      this.on_leave_callback(data);
    });
    this.client.on("login", (event_json: string)=>{
      this.on_login_listener(event_json);
    });

  }

  login(username: string) {
    console.log("login ");
    if (!this.connect_finish) {
      promptAction.showToast({
        message: "暂未连接服务器"
      })
      return;
    }
    this.client.emit("do login", username);
    this.login_finish = !this.login_finish;
  }

  sendMessage(message: string) {
    console.log("sendMessage ");
    if (!this.connect_finish) {
      promptAction.showToast({
        message: "暂未连接服务器"
      })
      return;
    }
    this.client.emit("get message", message, (data: ESObject)=>{
      this.on_emit_callback(data);
    });
    this.client.emit("new message", message);
    this.client.emit("obj callback", {
      name: '张三',
      age: 12
    }, (result) => {
      console.log("obj callback: " + result);
      if (result) {
        this.pushData(JSON.stringify(result));
      }
    });
  }
  // 退出连接
  close() {
    console.log("close ");
    if (!this.connect_finish) {
      promptAction.showToast({
        message: "暂未连接服务器"
      })
      return;
    }
    this.client.socket_close();
    this.client.clear_socket_listeners();
  }
}

class ChatDetailData extends BasicDataSource {
  private msgList: Array<ESObject> = [];

  public totalCount(): number {
    return this.msgList.length;
  }

  public getData(index: number): ESObject {
    return this.msgList[index];
  }

  public addData(index: number, data: ESObject): void {
    this.msgList.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  public pushData(data: ESObject): void {
    this.msgList.push(data);
    this.notifyDataAdd(this.msgList.length - 1);
  }
}