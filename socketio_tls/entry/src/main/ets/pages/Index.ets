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
import { chatDetailData } from '../common/ChatDetailData';

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
            LazyForEach(chatDetailData, (message: ESObject) => {
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
            TextInput({ placeholder: $r('app.string.Enter_message'), text: this.message })
              .width('80%')
              .onChange((message) => {
                this.message = message
              })
            Button('Send')
              .onClick(() => {
                if (this.message == "exit") {
                  socketManager.close()
                  this.login_finish = socketManager.login_finish
                } else if (this.message == "") {
                  prompt.showToast({ message: getContext().resourceManager.getStringSync($r('app.string.Enter_messages')) });
                } else {
                  socketManager.sendMessage(this.message)
                  let clientMessage: ESObject = { username: this.username, message: this.message, id: 2 }
                  chatDetailData.pushData(clientMessage)
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
              socketManager.setUri(uri)
            })
          Button('Connect')
            .margin(20)
            .onClick(() => {
              if(socketManager.checkUrl(socketManager.uri)){
                socketManager.commonInit()
              } else {
                console.error("服务器地址异常，请检查url信息。");
                prompt.showToast({ message: getContext().resourceManager.getStringSync($r('app.string.url_error')) });
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

        }
      }
      .width('100%')
    }
    .height('100%')
  }
}

@Component
struct ChatItemView {
  private message: ESObject

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