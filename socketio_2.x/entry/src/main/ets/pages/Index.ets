/**
 * Copyright (C) 2023 Huawei Device Co., Ltd.
 *
 * This software is distributed under a license. The full license
 * agreement can be found in the file LICENSE in this distribution.
 * This software may not be copied, modified, sold or distributed
 * other than expressed in the named license agreement.
 *
 * This software is distributed without any warranty.
 */

import prompt from '@ohos.promptAction';
import { socketManager } from '../common/SocketManager';
import { chatDetailData, Message, MessageType } from '../common/ChatDetailData';
import router from '@ohos.router';
@Entry
@Component
struct Index {
  @State uri: string = socketManager.uri;
  @State username: string = socketManager.username;
  @State message: string = "";
  @State connect_finish: boolean = socketManager.connect_finish;
  @State login_finish: boolean = socketManager.login_finish;
  private scroller: Scroller = new Scroller();


  build() {
    Row() {
      Column() {
        if (this.login_finish) {
          List({ scroller: this.scroller }) {
            LazyForEach(chatDetailData, (message: Message) => {
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
              .width('60%')
              .onChange((message) => {
                this.message = message
              })
            Button('Send')
              .onClick(() => {
                if (this.message == "exit") {
                  socketManager.close()
                  this.login_finish = socketManager.login_finish
                } else if (this.message == "") {
                  prompt.showToast({ message: "请输入消息" });
                } else {
                  socketManager.sendMessage(this.message)
                  let clientMessage: Message = { username: socketManager.username, message: this.message, id: MessageType.SELF }
                  chatDetailData.pushData(clientMessage)
                  this.message = ""
                }
              })
              .width('20%')
            Button('Send Multi')
              .onClick(() => {
                if (this.message == "exit") {
                  socketManager.close()
                  this.login_finish = socketManager.login_finish
                } else if (this.message == "") {
                  prompt.showToast({ message: "请输入消息" });
                } else {
                  socketManager.sendMultiMessage(this.message)
                  let clientMessage: Message = { username: socketManager.username, message: this.message, id: MessageType.SELF }
                  chatDetailData.pushData(clientMessage)
                  this.message = ""
                }
              })
              .width('20%')
          }
          .height('10%')
          .width('100%')
        } else {
          Column({ space: 15 }) {
            Text('单客户端Socket.IO聊天')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .margin({ top: 20, bottom: 10 })

            TextInput({ placeholder: "请输入socket.io服务端地址", text: this.uri })
              .onChange((uri) => {
                this.uri = uri
                socketManager.setUri(uri)
              })
            Button('Connect')
              .margin(20)
              .onClick(() => {
                if(socketManager.checkUrl(socketManager.uri)){
                  socketManager.commonInit()
                } else {
                  console.error("服务器地址异常，请检查url信息。");
                  prompt.showToast({ message: "服务器地址异常，请检查url信息" });
                }
              })
            TextInput({ placeholder: "请输入用户名" })
              .onChange((username) => {
                socketManager.username = username
              })
            Button('Login')
              .margin(20)
              .onClick(() => {
                socketManager.login(socketManager.username)
                // 更新状态
                this.login_finish = socketManager.login_finish;
              })

            // 多客户端功能入口
            Button('多客户端聊天演示')
              .width('80%')
              .height(50)
              .fontSize(16)
              .backgroundColor(Color.Orange)
              .margin({ top: 30, bottom: 20 })
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/MultiClientIndex'
                });
              })

          }
          .width('100%')
        }
      }
      .width('100%')
    }
    .height('100%')
  }
}

@Component
struct ChatItemView {
  public message: Message = {
    id: MessageType.SYSTEM,
    message: '',
  }

  build() {
    Column() {
      if (this.message.id == MessageType.SYSTEM) {
        Row() {
          Text(this.message.message)
        }
        .width("100%")
        .justifyContent(FlexAlign.Center)
        .margin({ top: 15 })
      }
      else if (this.message.id == MessageType.OTHER) {
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
