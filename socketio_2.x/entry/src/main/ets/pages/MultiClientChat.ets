/**
 * Copyright (C) 2025 Huawei Device Co., Ltd.
 *
 * This software is distributed under a license. The full license
 * agreement can be found in the file LICENSE in this distribution.
 * This software may not be copied, modified, sold or distributed
 * other than expressed in the named license agreement.
 *
 * This software is distributed without any warranty.
 */

import prompt from '@ohos.promptAction';
import { multiSocketManager } from '../common/MultiSocketManager';
import { multiChatDetailDataA, multiChatDetailDataB } from '../common/MultiChatDetailData';
import router from '@ohos.router';

interface clientMessageInfo {
  username: string;
  message: string;
  id: number;
  nsp: string;
}

@Entry
@Component
struct MultiClientChat {
  @State messageA: string = "";
  @State messageB: string = "";
  @State connectFinishA: boolean = multiSocketManager.getConnectFinish('A');
  @State connectFinishB: boolean = multiSocketManager.getConnectFinish('B');
  @State loginFinishA: boolean = multiSocketManager.getLoginFinish('A');
  @State loginFinishB: boolean = multiSocketManager.getLoginFinish('B');
  @State usernameA: string = multiSocketManager.getUsername('A');
  @State usernameB: string = multiSocketManager.getUsername('B');
  @State nspA: string = multiSocketManager.getNsp('A');
  @State nspB: string = multiSocketManager.getNsp('B');
  @State selectedNspA: string = '/';
  @State selectedNspB: string = '/';
  
  private scrollerA: Scroller = new Scroller();
  private scrollerB: Scroller = new Scroller();
  private nspsInited: boolean = false;
  // 聊天页状态刷新定时器
  private chatStatusTimer?: number;

  build() {
    Column() {
      // 标题栏
      Row() {
        Button('返回')
          .fontSize(16)
          .onClick(() => {
            router.back();
          })
        
        Text('多客户端聊天')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
        
        Button('断开所有')
          .fontSize(14)
          .backgroundColor(Color.Red)
          .onClick(() => {
            multiSocketManager.closeAll();
            this.connectFinishA = false;
            this.connectFinishB = false;
            this.loginFinishA = false;
            this.loginFinishB = false;
          })
      }
      .width('100%')
      .height(60)
      .padding({ left: 15, right: 15 })
      .backgroundColor('#f8f8f8')
      .justifyContent(FlexAlign.SpaceBetween)

      // 聊天区域
      Row() {
        // 客户端A聊天区域
        Column() {
          // 客户端A标题
          Row() {
            Text(`客户端A ${this.usernameA ? '(' + this.usernameA + ')' : ''}`)
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
            
            Blank()
            
            Text(this.connectFinishA && this.loginFinishA ? '在线' : '离线')
              .fontSize(12)
              .fontColor(this.connectFinishA && this.loginFinishA ? Color.Green : Color.Red)
              .padding({ left: 5, right: 5, top: 2, bottom: 2 })
              .backgroundColor(this.connectFinishA && this.loginFinishA ? '#e8f5e8' : '#ffe8e8')
              .borderRadius(10)
          }
          .width('100%')
          .padding(10)
          .backgroundColor('#e3f2fd')

          // 客户端A 目标命名空间切换
          if ((this.nspA && this.nspA.trim() !== '')) {
            Row() {
              Text('nsp: ')
                .fontSize(12)
                .fontColor('#666666')
                .margin({ right: 6 })

              // 默认 '/'
              Button('/')
                .fontSize(12)
                .backgroundColor(this.selectedNspA === '/' ? Color.Green : '#e0e0e0')
                .fontColor(this.selectedNspA === '/' ? Color.White : '#333333')
                .onClick(() => {
                  this.selectedNspA = '/';
                })

              // 配置的 nsp（规范化后）
              Button(this.nspA.startsWith('/') ? this.nspA : '/' + this.nspA)
                .fontSize(12)
                .backgroundColor(this.selectedNspA === (this.nspA.startsWith('/') ? this.nspA : '/' + this.nspA) ? Color.Green : '#e0e0e0')
                .fontColor(this.selectedNspA === (this.nspA.startsWith('/') ? this.nspA : '/' + this.nspA) ? Color.White : '#333333')
                .margin({ left: 8 })
                .onClick(() => {
                  this.selectedNspA = (this.nspA.startsWith('/') ? this.nspA : '/' + this.nspA);
                })
            }
            .width('100%')
            .padding({ left: 10, right: 10, top: 6, bottom: 6 })
            .backgroundColor('#f0faf0')
          }

          // 客户端A消息列表
          List({ scroller: this.scrollerA }) {
            LazyForEach(multiChatDetailDataA, (message: ESObject) => {
              ListItem() {
                if (((message['nsp'] ? message['nsp'] : '/')) === this.selectedNspA) {
                  ChatItemView({ message: message, clientType: 'A' })
                }
              }
            })
          }
          .listDirection(Axis.Vertical)
          .divider({ strokeWidth: 1, color: "#f3f3f3" })
          .layoutWeight(1)
          .width('100%')
          .backgroundColor(Color.White)

          // 客户端A输入区域
          Row() {
            TextInput({ 
              placeholder: 'A发送消息...', 
              text: this.messageA 
            })
              .fontSize(15)
              .layoutWeight(1)
              .height('80%')
              .enabled(this.connectFinishA && this.loginFinishA)
              .onChange((message) => {
                this.messageA = message;
              })
            
            Button('SendA')
              .fontSize(14)
              .backgroundColor(Color.Blue)
              .height('80%')
              .onClick(() => {
                if (this.messageA.trim() === "") {
                  prompt.showToast({ message: "请输入消息内容" });
                  return;
                }
                
                if (this.messageA === "exit") {
                  multiSocketManager.close('A');
                  this.connectFinishA = false;
                  this.loginFinishA = false;
                } else {
                  multiSocketManager.sendMessageInNsp('A', this.messageA, this.selectedNspA);
                  let clientMessage: clientMessageInfo = {
                    username: this.usernameA, 
                    message: this.messageA, 
                    id: 2,
                    nsp: this.selectedNspA 
                  };
                  multiChatDetailDataA.pushData(clientMessage);
                  this.messageA = "";
                }
              })
              .enabled(this.connectFinishA && this.loginFinishA)
              .margin({ left: 5 })
          }
          .height(64)
          .width('100%')
          .padding({ left: 10, right: 10, top: 6, bottom: 6 })
          .backgroundColor('#f5f5f5')
        }
        .layoutWeight(1)
        .height('100%')
        .border({ width: 1, color: '#e0e0e0' })

        // 分隔线
        Line()
          .width(2)
          .height('100%')
          .backgroundColor('#e0e0e0')

        // 客户端B聊天区域
        Column() {
          // 客户端B标题
          Row() {
            Text(`客户端B ${this.usernameB ? '(' + this.usernameB + ')' : ''}`)
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
            
            Blank()
            
            Text(this.connectFinishB && this.loginFinishB ? '在线' : '离线')
              .fontSize(12)
              .fontColor(this.connectFinishB && this.loginFinishB ? Color.Green : Color.Red)
              .padding({ left: 5, right: 5, top: 2, bottom: 2 })
              .backgroundColor(this.connectFinishB && this.loginFinishB ? '#e8f5e8' : '#ffe8e8')
              .borderRadius(10)
          }
          .width('100%')
          .padding(10)
          .backgroundColor('#fff3e0')

          // 客户端B 目标命名空间切换
          if ((this.nspB && this.nspB.trim() !== '')) {
            Row() {
              Text('nsp: ')
                .fontSize(12)
                .fontColor('#666666')
                .margin({ right: 6 })

              // 默认 '/'
              Button('/')
                .fontSize(12)
                .backgroundColor(this.selectedNspB === '/' ? Color.Green : '#e0e0e0')
                .fontColor(this.selectedNspB === '/' ? Color.White : '#333333')
                .onClick(() => {
                  this.selectedNspB = '/';
                })

              // 配置的 nsp（规范化后）
              Button(this.nspB.startsWith('/') ? this.nspB : '/' + this.nspB)
                .fontSize(12)
                .backgroundColor(this.selectedNspB === (this.nspB.startsWith('/') ? this.nspB : '/' + this.nspB) ? Color.Green : '#e0e0e0')
                .fontColor(this.selectedNspB === (this.nspB.startsWith('/') ? this.nspB : '/' + this.nspB) ? Color.White : '#333333')
                .margin({ left: 8 })
                .onClick(() => {
                  this.selectedNspB = (this.nspB.startsWith('/') ? this.nspB : '/' + this.nspB);
                })
            }
            .width('100%')
            .padding({ left: 10, right: 10, top: 6, bottom: 6 })
            .backgroundColor('#f0faf0')
          }

          // 客户端B消息列表
          List({ scroller: this.scrollerB }) {
            LazyForEach(multiChatDetailDataB, (message: ESObject) => {
              ListItem() {
                if (((message['nsp'] ? message['nsp'] : '/')) === this.selectedNspB) {
                  ChatItemView({ message: message, clientType: 'B' })
                }
              }
            })
          }
          .listDirection(Axis.Vertical)
          .divider({ strokeWidth: 1, color: "#f3f3f3" })
          .layoutWeight(1)
          .width('100%')
          .backgroundColor(Color.White)

          // 客户端B输入区域
          Row() {
            TextInput({ 
              placeholder: 'B发送消息...', 
              text: this.messageB 
            })
              .fontSize(15)
              .layoutWeight(1)
              .height('80%')
              .enabled(this.connectFinishB && this.loginFinishB)
              .onChange((message) => {
                this.messageB = message;
              })
            
            Button('SendB')
              .fontSize(14)
              .backgroundColor(Color.Orange)
              .height('80%')
              .onClick(() => {
                if (this.messageB.trim() === "") {
                  prompt.showToast({ message: "请输入消息内容" });
                  return;
                }
                
                if (this.messageB === "exit") {
                  multiSocketManager.close('B');
                  this.connectFinishB = false;
                  this.loginFinishB = false;
                } else {
                  multiSocketManager.sendMessageInNsp('B', this.messageB, this.selectedNspB);
                  let clientMessage: clientMessageInfo = {
                    username: this.usernameB, 
                    message: this.messageB,
                    id: 2,
                    nsp: this.selectedNspB 
                  };
                  multiChatDetailDataB.pushData(clientMessage);
                  this.messageB = "";
                }
              })
              .enabled(this.connectFinishB && this.loginFinishB)
              .margin({ left: 5 })
          }
          .height(64)
          .width('100%')
          .padding({ left: 10, right: 10, top: 6, bottom: 6 })
          .backgroundColor('#f5f5f5')
        }
        .layoutWeight(1)
        .height('100%')
        .border({ width: 1, color: '#e0e0e0' })
      }
      .layoutWeight(1)
      .width('100%')

      // 底部状态栏
      Row() {
        Column() {
          Text('A状态')
            .fontSize(12)
            .fontWeight(FontWeight.Bold)
          Text(`${this.connectFinishA ? '已连接' : '未连接'} | ${this.loginFinishA ? '已登录' : '未登录'}`)
            .fontSize(10)
            .fontColor(this.connectFinishA && this.loginFinishA ? Color.Green : Color.Red)
        }
        .layoutWeight(1)

        Column() {
          Text('B状态')
            .fontSize(12)
            .fontWeight(FontWeight.Bold)
          Text(`${this.connectFinishB ? '已连接' : '未连接'} | ${this.loginFinishB ? '已登录' : '未登录'}`)
            .fontSize(10)
            .fontColor(this.connectFinishB && this.loginFinishB ? Color.Green : Color.Red)
        }
        .layoutWeight(1)
      }
      .width('100%')
      .height(40)
      .padding(10)
      .backgroundColor('#f0f0f0')
      .justifyContent(FlexAlign.SpaceAround)
    }
    .height('100%')
    .width('100%')
  }

  onPageShow() {
    // 500ms 更新一次状态
    if (this.chatStatusTimer !== undefined) {
      return;
    }
    this.chatStatusTimer = setInterval(() => {
      this.connectFinishA = multiSocketManager.getConnectFinish('A');
      this.connectFinishB = multiSocketManager.getConnectFinish('B');
      this.loginFinishA = multiSocketManager.getLoginFinish('A');
      this.loginFinishB = multiSocketManager.getLoginFinish('B');
      this.usernameA = multiSocketManager.getUsername('A');
      this.usernameB = multiSocketManager.getUsername('B');
      this.nspA = multiSocketManager.getNsp('A');
      this.nspB = multiSocketManager.getNsp('B');

      // 首次进入时，根据配置初始化默认选择
      if (!this.nspsInited) {
        const nA = (this.nspA && this.nspA.trim() !== '') ? (this.nspA.startsWith('/') ? this.nspA : '/' + this.nspA) : '/';
        const nB = (this.nspB && this.nspB.trim() !== '') ? (this.nspB.startsWith('/') ? this.nspB : '/' + this.nspB) : '/';
        this.selectedNspA = nA;
        this.selectedNspB = nB;
        this.nspsInited = true;
      }
    }, 500);
  }

  onPageHide() {
    // 清理聊天页定时器
    if (this.chatStatusTimer !== undefined) {
      clearInterval(this.chatStatusTimer);
      this.chatStatusTimer = undefined;
    }
  }
}

@Component
struct ChatItemView {
  private message: ESObject;
  private clientType: string = '';

  build() {
    Column() {
      if (this.message.id == 0) {
        // 系统消息
        Row() {
          Text(this.message.message)
            .fontSize(12)
            .fontColor('#666666')
            .backgroundColor('#f0f0f0')
            .padding(8)
            .borderRadius(5)
        }
        .width("100%")
        .justifyContent(FlexAlign.Center)
        .margin({ top: 10, bottom: 5 })
      }
      else if (this.message.id == 1) {
        // 接收的消息（对方发送的）
        Row() {
          Column() {
            Text(this.message.username)
              .fontSize(10)
              .fontColor('#888888')
              .margin({ bottom: 2 })
            Text(this.message.message)
              .fontSize(14)
              .fontColor('#333333')
              .backgroundColor(this.clientType === 'A' ? '#e3f2fd' : '#fff3e0')
              .padding(10)
              .borderRadius(10)
              .maxLines(10)
          }
          .alignItems(HorizontalAlign.Start)
          
          Blank()
        }
        .width("100%")
        .alignItems(VerticalAlign.Top)
        .margin({ top: 10, bottom: 5 })
        .padding({ right: 50 })
      } else {
        // 发送的消息（本人发送的）
        Row() {
          Blank()
          
          Column() {
            Text(this.message.username)
              .fontSize(10)
              .fontColor('#888888')
              .margin({ bottom: 2 })
              .alignSelf(ItemAlign.End)
            Text(this.message.message)
              .fontSize(14)
              .fontColor(Color.White)
              .backgroundColor(this.clientType === 'A' ? '#2196f3' : '#ff9800')
              .padding(10)
              .borderRadius(10)
              .maxLines(10)
          }
          .alignItems(HorizontalAlign.End)
        }
        .alignItems(VerticalAlign.Top)
        .width("100%")
        .padding({ left: 50 })
        .margin({ top: 10, bottom: 5 })
      }
    }
  }
}