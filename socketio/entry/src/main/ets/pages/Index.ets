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
import { client_socket } from '@ohos/socketio';
import router from '@ohos.router';

@Entry
@Component
struct Index {
  @State uri: string = "http://10.50.40.37:3000";
  @State username: string = "";
  @State message: string = "";
  @State connect_finish: boolean = false;
  @State login_finish: boolean = false;
  private chatDetailData = new ChatDetailData();
  private client: client_socket = new client_socket();
  private scroller: Scroller = new Scroller();

  on_open(): void {
    console.log("SOCKET_IO_INDEX on_open");
    this.connect_finish = true;
    prompt.showToast({ message: "连接服务器成功" });
  }

  on_fail(): void {
    console.log("SOCKET_IO_INDEX on_fail");
  }

  on_reconnecting(): void {
    console.log("SOCKET_IO_INDEX on_reconnecting");
  }

  on_reconnect(): void {
    console.log("SOCKET_IO_INDEX on_reconnect");
  }

  on_close(reason: string): void {
    this.connect_finish = false;
    console.log("SOCKET_IO_INDEX on_close: " + reason);
  }

  on_socket_open(nsp: string): void {
    console.log("SOCKET_IO_INDEX on_socket_open: " + nsp);
  }

  on_socket_close(nsp: string): void {
    console.log("SOCKET_IO_INDEX on_socket_close: " + nsp);
  }

  on_login_listener(event_json: string): void {
    console.log("SOCKET_IO_INDEX on_login_listener: " + event_json);
    let loginCall = JSON.parse(event_json);
    let notice = "Welcome to Socket.IO Chat,there " + (loginCall.numUsers != 1 ? " are " : "\'s ") + loginCall.numUsers + (loginCall.numUsers != 1 ? " participants" : " participant");
    let serviceMessage = { message: notice, id: 0 };
    this.pushData(serviceMessage);
  }

  on_new_message_listener(event_json: string): void {
    console.log("SOCKET_IO_INDEX on_new_message_listener: " + event_json);
    let messageCall = JSON.parse(event_json);
    let serviceMessage = { username: messageCall.username, message: messageCall.message, id: 1 };
    this.pushData(serviceMessage);
  }

  on_user_joined_listener(event_json: string): void {
    console.log("SOCKET_IO_INDEX on_user_joined_listener: " + event_json);
    let userJoinCall = JSON.parse(event_json);
    let notice = userJoinCall.username + " joined" + ",there" + (userJoinCall.numUsers != 1 ? " are " : "\'s ") + userJoinCall.numUsers + (userJoinCall.numUsers != 1 ? " participants" : " participant");
    let serviceMessage = { message: notice, id: 0 };
    this.pushData(serviceMessage);
  }

  on_user_left_listener(event_json: string): void {
    console.log("SOCKET_IO_INDEX on_user_left_listener: " + event_json);
    let userLeftCall = JSON.parse(event_json);
    let notice = userLeftCall.username + " left" + ",there" + (userLeftCall.numUsers != 1 ? "are " : "\'s ") + userLeftCall.numUsers + (userLeftCall.numUsers != 1 ? " participants" : " participant");
    let serviceMessage = { message: notice, id: 0 };
    this.pushData(serviceMessage);
  }

  on_emit_callback(emit_callback_json: string): void {
    console.log("SOCKET_IO_INDEX on_emit_callback： " + emit_callback_json);
  }

  pushData(any) {
    setTimeout(() => {
      this.chatDetailData.pushData(any);
    }, 300);
  }

  //配置client
  initClient(uri: string) {
    console.log("SOCKET_IO_INDEX initClient");
    this.client.set_open_listener(this.on_open.bind(this));
    this.client.set_fail_listener(this.on_fail.bind(this));
    this.client.set_reconnecting_listener(this.on_reconnecting.bind(this));
    this.client.set_reconnect_listener(this.on_reconnect.bind(this));
    this.client.set_close_listener(this.on_close.bind(this));
    this.client.set_socket_open_listener(this.on_socket_open.bind(this));
    this.client.set_socket_close_listener(this.on_socket_close.bind(this));
    this.client.connect(uri);
  }

  //配置socket
  initSocket() {
    console.log("SOCKET_IO_INDEX initSocket");
    this.client.on("new message", this.on_new_message_listener.bind(this));
    this.client.on("user joined", this.on_user_joined_listener.bind(this));
    this.client.on("user left", this.on_user_left_listener.bind(this));
    this.client.on("login", this.on_login_listener.bind(this));
  }

  //登录
  login(username: string) {
    console.log("SOCKET_IO_INDEX login");
    if (!this.connect_finish) {
      prompt.showToast({ message: "暂未连接服务器" });
      return;
    }
    this.client.emit("add user", username);
    this.login_finish = !this.login_finish;
    console.log("SOCKET_IO_INDEX login login_finish: " + this.login_finish);
  }

  //发送消息
  sendMessage(message: string) {
    console.log("SOCKET_IO_INDEX sendMessage");
    if (!this.connect_finish) {
      console.log("SOCKET_IO_INDEX 暂未连接服务器");
      return;
    }
    this.client.emit("new message", message, this.on_emit_callback);
  }

  //退出连接
  close() {
    console.log("SOCKET_IO_INDEX close");
    if (!this.connect_finish) {
      console.log("SOCKET_IO_INDEX 暂未连接服务器");
      return;
    }
    this.client.socket_close();
    this.client.close();
  }

  build() {
    Row() {
      Column() {
        if (this.login_finish) {
          List({ scroller: this.scroller }) {
            LazyForEach(this.chatDetailData, (message) => {
              ListItem() {
                ChatItemView({ message: message })
              }
            })
          }
          .listDirection(Axis.Vertical)
          .divider({ strokeWidth: 2, color: "#f3f3f3" })
          .height('80%')
          .width('100%')

          Row() {
            TextInput({ placeholder: "请输入消息,退出聊天室请输入exit", text: this.message })
              .width('80%')
              .onChange((message) => {
                this.message = message
              })
            Button('Send')
              .onClick(() => {
                if (this.message == "exit") {
                  this.close()
                  this.login_finish = false
                } else if (this.message == "") {
                  prompt.showToast({ message: "请输入消息" });
                } else {
                  this.sendMessage(this.message)
                  let clientMessage = { username: this.username, message: this.message, id: 2 }
                  this.pushData(clientMessage)
                  this.message = ""
                }
              })
              .width('20%')
          }
          .height('10%')
          .width('100%')
        } else {
          TextInput({ placeholder: "请输入socket.io服务端地址", text: this.uri })
            .onChange((uri) => {
              this.uri = uri
            })
          Button('Connect')
            .margin(20)
            .onClick(() => {
              this.initClient(this.uri)
              this.initSocket()
            })
          TextInput({ placeholder: "请输入用户名" })
            .onChange((username) => {
              this.username = username
            })
          Button('Login')
            .margin(20)
            .onClick(() => {
              this.login(this.username)
            })
          Button('进入自测界面')
            .margin(20)
            .onClick(() => {
              router.pushUrl({
                url: 'pages/MyTestPage'
              })
            })

        }
      }
      .width('100%')
    }
    .height('100%')
  }
}

@Component
struct ChatItemView {
  private message: any

  build() {
    Column() {
      if (this.message.id == 0) {
        Row() {
          Text(this.message.message)
        }
        .width("100%")
        .justifyContent(FlexAlign.Center)
        .margin({ top: 15 })
      }
      else if (this.message.id == 1) {
        // 聊天页面对方的消息
        Row() {
          Text(this.message.username + ":" + this.message.message)
        }
        .width("100%")
        .alignItems(VerticalAlign.Top)
        .margin({ top: 15 })
        .padding({ right: 50 })
      } else {
        // 聊天页面本人消息
        Row() {
          Text(this.message.username + ":" + this.message.message)
        }
        .alignItems(VerticalAlign.Top)
        .width("100%")
        .direction(Direction.Rtl)
        .padding({ left: 50 })
        .margin({ top: 15 })
      }
    }
  }
}


class ChatDetailData extends BasicDataSource {
  private msgList: Array<any> = [];

  public totalCount(): number {
    return this.msgList.length;
  }

  public getData(index: number): any {
    return this.msgList[index];
  }

  public addData(index: number, data: any): void {
    this.msgList.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  public pushData(data: any): void {
    this.msgList.push(data);
    this.notifyDataAdd(this.msgList.length - 1);
  }
}