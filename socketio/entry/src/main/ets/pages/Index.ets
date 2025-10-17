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

import { socketManager } from '../common/SocketManager';
import { chatDetailData } from '../common/ChatDetailData';
import prompt from '@ohos.promptAction';

@Entry
@Component
struct Index {
  @State uri: string = socketManager.uri;
  @State message: string = "";
  @State connect_finish: boolean = socketManager.connect_finish;
  @State login_finish: boolean = socketManager.login_finish;
  @State currentState: number = socketManager.currentState;

  private scroller: Scroller = new Scroller();
  // 组件卸载 → 必须清理！
  aboutToDisappear() {
    socketManager.close()
    this.login_finish = socketManager.login_finish
    chatDetailData.delData()
  }
  onDestroy() {
    socketManager.close(); // 彻底释放
  }
  build() {
    Row() {
      Column() {
        if (this.login_finish) {
          List({ scroller: this.scroller }) {
            LazyForEach(chatDetailData, (message: ESObject) => {
              ListItem() {
                ChatItemView({ username: message.username,
                  message: message.message?.toString() || "null",
                  type: message.id?.toString() })
              }
            })
          }
          .listDirection(Axis.Vertical)
          .divider({ strokeWidth: 2, color: "#f3f3f3" })
          .height('80%')
          .width('100%')
          Row() {
            Button('exit')
              .onClick(() => {
                socketManager.close()
                this.login_finish = socketManager.login_finish
                chatDetailData.delData()
              })
              .width('20%')
            Button('null')
              .onClick(() => {
                socketManager.sendNullMessage(null)
                let clientMessage: ESObject = { username: socketManager.username, message: null, id: 2 }
                chatDetailData.pushData(clientMessage)
              })
              .width('20%')
            Button('string')
              .onClick(() => {
                if (this.message == "") {
                  prompt.showToast({ message: $r('app.string.Enter_messages') });
                  return
                }
                socketManager.sendStringMessage(this.message)
                let clientMessage: ESObject = { username: socketManager.username, message:this.message, id: 2 }
                chatDetailData.pushData(clientMessage)
              })
              .width('20%')
            Button('number')
              .onClick(() => {
                if (this.message == "") {
                  prompt.showToast({ message: $r('app.string.Enter_messages') });
                  return
                }
                socketManager.sendNumberMessage(this.message)
                let clientMessage: ESObject = { username: socketManager.username, message:this.message, id: 2 }
                chatDetailData.pushData(clientMessage)
              })
              .width('20%')
            Button('object')
              .onClick(() => {
                if (this.message == "") {
                  prompt.showToast({ message: $r('app.string.Enter_messages') });
                  return
                }
                socketManager.sendObjectMessage(this.message)
                let clientMessage: ESObject = { username: socketManager.username, message:this.message, id: 2 }
                chatDetailData.pushData(clientMessage)
              })
              .width('20%')
          }
          .width('100%')
          Row() {
            Button('float')
              .onClick(() => {
                if (this.message == "") {
                  prompt.showToast({ message: $r('app.string.Enter_messages') });
                  return
                }
                socketManager.sendNumberMessage(this.message)
                let clientMessage: ESObject = { username: socketManager.username, message:this.message, id: 2 }
                chatDetailData.pushData(clientMessage)
              })
              .width('20%')
            Button('array')
              .onClick(() => {
                if (this.message == "") {
                  prompt.showToast({ message: $r('app.string.Enter_messages') });
                  return
                }
                socketManager.sendArrayMessage(this.message)
                let clientMessage: ESObject = { username: socketManager.username, message:this.message, id: 2 }
                chatDetailData.pushData(clientMessage)
              })
              .width('20%')
            Button('boolean')
              .onClick(() => {
                socketManager.sendBooleanMessage(true)
                let clientMessage: ESObject = { username: socketManager.username, message:true, id: 2 }
                chatDetailData.pushData(clientMessage)
              })
              .width('20%')
            Button('buff')
              .onClick(() => {
                if (this.message == "") {
                  prompt.showToast({ message: $r('app.string.Enter_messages') });
                  return
                }
                socketManager.sendBufferMessage(this.message)
                let clientMessage: ESObject = { username: socketManager.username, message:this.message, id: 2 }
                chatDetailData.pushData(clientMessage)
              })
              .width('20%')
            Button('multi')
              .onClick(() => {
                if (this.message == "") {
                  prompt.showToast({ message: $r('app.string.Enter_messages') });
                  return
                }
                socketManager.sendMultiParameterCallbackMessage(this.message)
                let clientMessage: ESObject = { username: socketManager.username, message:this.message, id: 2 }
                chatDetailData.pushData(clientMessage)
              })
              .width('20%')
          }
          .width('100%')
          Row() {
            Button('setNsp')
              .onClick(() => {
                if (this.message == "") {
                  prompt.showToast({ message: $r('app.string.Enter_messages') });
                  return
                }
                socketManager.setNsp(this.message)
              })
              .width('20%')
            Button('setHeaders')
              .onClick(() => {
                if (this.message == "") {
                  prompt.showToast({ message: $r('app.string.Enter_messages') });
                  return
                }
                socketManager.setHeaders(this.message)
              })
              .width('20%')
            Button('socketClose')
              .onClick(() => {
                socketManager.socketClose()
                socketManager.close()
                this.login_finish = socketManager.login_finish
                chatDetailData.delData()
              })
              .width('20%')
            Button('emitAckBinary')
              .onClick(() => {
                if (this.message == "") {
                  prompt.showToast({ message: $r('app.string.Enter_messages') });
                  return
                }
                socketManager.sendEmitAckBinaryMessage(this.message)
              })
              .width('20%')
          }
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
                  prompt.showToast({ message: $r('app.string.Enter_messages') });
                } else {
                  socketManager.sendMessage(this.message)
                  let clientMessage: ESObject = { username: socketManager.username, message: this.message, id: 2 }
                  chatDetailData.pushData(clientMessage)
                  this.message = ""
                }
              })
              .width('20%')
          }
          .height('10%')
          .width('100%')

        } else {
          TextInput({ placeholder: $r('app.string.Server_address'), text: this.uri })
            .onChange((uri) => {
              this.uri = uri
              socketManager.setUri(uri)
            })
          Button('Connect')
            .margin(20)
            .onClick(() => {
              socketManager.commonInit()
            })
          TextInput({ placeholder: $r('app.string.User_name') })
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
  // @Prop message: ESObject
  @Prop username: string
  @Prop message: string
  @Prop type: string  // 0: 系统, 1: 对方, 2: 自己

  build() {
    Column() {
      if (this.type === '0') {
        Row() {
          Text(this.message)
        }
        .width("100%")
        .justifyContent(FlexAlign.Center)
        .margin({ top: 15 })
      }
      else if (this.type === '1') {
        // 聊天页面对方的消息
        Row() {
          Text(this.username + ":" + this.message)
        }
        .width("100%")
        .alignItems(VerticalAlign.Top)
        .margin({ top: 15 })
        .padding({ right: 50 })
      } else {
        // 聊天页面本人消息
        Row() {
          Text(this.username + ":" + this.message)
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