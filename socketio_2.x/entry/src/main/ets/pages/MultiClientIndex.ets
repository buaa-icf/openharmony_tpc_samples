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
import router from '@ohos.router';

@Entry
@Component
struct MultiClientIndex {
  @State uriA: string = multiSocketManager.getUri('A')
  @State uriB: string = multiSocketManager.getUri('B')
  @State nspA: string = multiSocketManager.getNsp('A')
  @State nspB: string = multiSocketManager.getNsp('B')
  @State usernameA: string = multiSocketManager.getUsername('A');
  @State usernameB: string = multiSocketManager.getUsername('B');
  @State connectFinishA: boolean = multiSocketManager.getConnectFinish('A');
  @State connectFinishB: boolean = multiSocketManager.getConnectFinish('B');
  @State loginFinishA: boolean = multiSocketManager.getLoginFinish('A');
  @State loginFinishB: boolean = multiSocketManager.getLoginFinish('B');
  // 定时器句柄：用于定时刷新状态，进入页面时创建，离开页面时清理
  private statusRefreshTimer?: number;

  build() {
    Scroll() {
      Column({ space: 20 }) {
        // 标题
        Text('多客户端Socket.IO聊天演示')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 20, bottom: 10 })

        // 服务器连接区域
        Column({ space: 15 }) {
          Text('服务器连接设置')
            .fontSize(18)
            .fontWeight(FontWeight.Medium)

          // 客户端A连接
          Column({ space: 10 }) {
            Text('客户端A')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .alignSelf(ItemAlign.Start)
            Text('链接：')
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
              .alignSelf(ItemAlign.Start)
            TextInput({ 
              placeholder: "请输入客户端A的Socket.io服务端地址", 
              text: this.uriA 
            })
              .onChange((uri) => {
                this.uriA = uri;
                multiSocketManager.setUri('A', uri);
              })
            Text('命名空间：')
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
              .alignSelf(ItemAlign.Start)
            TextInput({
              placeholder: "请输入客户端A的nsp",
              text: this.nspA
            })
              .onChange((nsp) => {
                this.nspA = nsp;
                multiSocketManager.setNsp('A', nsp);
              })

            Row({ space: 10 }) {
              Button('连接A')
                .fontSize(14)
                .backgroundColor(this.connectFinishA ? Color.Green : Color.Blue)
                .onClick(() => {
                  if (multiSocketManager.checkUrl(this.uriA)) {
                    multiSocketManager.connect('A')
                    setTimeout(() => {
                      this.connectFinishA = multiSocketManager.getConnectFinish('A');
                    }, 1000);
                  } else {
                    prompt.showToast({ message: "客户端A服务器地址异常，请检查url信息。" });
                  }
                })
                .enabled(!this.connectFinishA)

              if (this.connectFinishA) {
                Text('√ 已连接')
                  .fontColor(Color.Green)
                  .fontSize(14)
              }

              Button('断开A')
                .fontSize(14)
                .backgroundColor(Color.Red)
                .onClick(() => {
                  multiSocketManager.close('A');
                  setTimeout(() => {
                    this.connectFinishA = multiSocketManager.getConnectFinish('A');
                    this.loginFinishA = multiSocketManager.getLoginFinish('A');
                  }, 500);
                })
                .enabled(this.connectFinishA)

              if (! this.connectFinishA) {
                Text('× 未连接')
                  .fontColor(Color.Red)
                  .fontSize(14)
              }
            }
            .width('100%')
            .justifyContent(FlexAlign.Start)

            // 命名空间提示（A）：未设置时仅“/”；设置后显示“/, <nsp>”
            Text(`命名空间: ${this.nspA && this.nspA.trim() !== '' ? '/, ' + (this.nspA.startsWith('/') ? this.nspA : '/' + this.nspA) : '/'}`)
              .fontSize(12)
              .fontColor('#666666')
          }
          .alignItems(HorizontalAlign.Start)
          .padding(15)
          .backgroundColor('#f5f5f5')
          .borderRadius(10)

          // 客户端B连接
          Column({ space: 10 }) {
            Text('客户端B')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .alignSelf(ItemAlign.Start)

            Text('链接：')
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
              .alignSelf(ItemAlign.Start)

            TextInput({ 
              placeholder: "请输入客户端B的Socket.io服务端地址", 
              text: this.uriB 
            })
              .onChange((uri) => {
                this.uriB = uri;
                multiSocketManager.setUri('B', uri);
              })
            Text('命名空间：')
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
              .alignSelf(ItemAlign.Start)
            TextInput({
              placeholder: "请输入客户端B的nsp",
              text: this.nspB
            })
              .onChange((nsp) => {
                this.nspB = nsp;
                multiSocketManager.setNsp('B', nsp);
              })
            Row({ space: 10 }) {
              Button('连接B')
                .fontSize(14)
                .backgroundColor(this.connectFinishB ? Color.Green : Color.Blue)
                .onClick(() => {
                  if (multiSocketManager.checkUrl(this.uriB)) {
                    // 先设置好参数，再连接B
                    multiSocketManager.connect('B')
                    setTimeout(() => {
                      this.connectFinishB = multiSocketManager.getConnectFinish('B');
                    }, 1000);
                  } else {
                    prompt.showToast({ message: "客户端B服务器地址异常，请检查url信息。" });
                  }
                })
                .enabled(!this.connectFinishB)

              if (this.connectFinishB) {
                Text('√ 已连接')
                  .fontColor(Color.Green)
                  .fontSize(14)
              }

              Button('断开B')
                .fontSize(14)
                .backgroundColor(Color.Red)
                .onClick(() => {
                  multiSocketManager.close('B');
                  setTimeout(() => {
                    this.connectFinishB = multiSocketManager.getConnectFinish('B');
                    this.loginFinishB = multiSocketManager.getLoginFinish('B');
                  }, 500);
                })
                .enabled(this.connectFinishB)

              if (! this.connectFinishB) {
                Text('× 未连接')
                  .fontColor(Color.Red)
                  .fontSize(14)
              }
            }
            .width('100%')
            .justifyContent(FlexAlign.Start)

            // 命名空间提示（B）：未设置时仅“/”；设置后显示“/, <nsp>”
            Text(`命名空间: ${this.nspB && this.nspB.trim() !== '' ? '/, ' + (this.nspB.startsWith('/') ? this.nspB : '/' + this.nspB) : '/'}`)
              .fontSize(12)
              .fontColor('#666666')
          }
          .alignItems(HorizontalAlign.Start)
          .padding(15)
          .backgroundColor('#f5f5f5')
          .borderRadius(10)

          // 同时连接按钮
          Button('同时连接A和B')
            .width('100%')
            .fontSize(16)
            .backgroundColor(Color.Blue)
            .onClick(() => {
              // 先分别设置 A/B 的参数，再同时连接
              multiSocketManager.connectBoth();
              setTimeout(() => {
                this.connectFinishA = multiSocketManager.getConnectFinish('A');
                this.connectFinishB = multiSocketManager.getConnectFinish('B');
              }, 1000);
            })
            // 两端均未登录时可点击
            .enabled(!this.connectFinishA && !this.connectFinishB)

          // 同时断开按钮
          Button('同时断开A和B')
            .width('100%')
            .fontSize(16)
            .backgroundColor(Color.Red)
            .onClick(() => {
              multiSocketManager.close('A');
              multiSocketManager.close('B');
              setTimeout(() => {
                this.connectFinishA = multiSocketManager.getConnectFinish('A');
                this.connectFinishB = multiSocketManager.getConnectFinish('B');
                this.loginFinishA = multiSocketManager.getLoginFinish('A');
                this.loginFinishB = multiSocketManager.getLoginFinish('B');
              }, 500);
            })
            // 两端均已登录时可点击
            .enabled(this.connectFinishA && this.connectFinishB)
        }

        // 用户登录区域
        Column({ space: 15 }) {
          Text('用户登录设置')
            .fontSize(18)
            .fontWeight(FontWeight.Medium)

          // 客户端A登录
          Column({ space: 10 }) {
            Text('客户端A用户')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .alignSelf(ItemAlign.Start)

            TextInput({ placeholder: "请输入客户端A的用户名，不输入默认'A'" })
              .onChange((username) => {
                this.usernameA = username;
                multiSocketManager.setUsername('A', username);
              })

            Row({ space: 10 }) {
              Button('登录A')
                .fontSize(14)
                .backgroundColor(this.loginFinishA ? Color.Green : Color.Blue)
                .onClick(() => {
                  // if (this.usernameA.trim() === '') {
                  //   prompt.showToast({ message: "请输入客户端A的用户名" });
                  //   return;
                  // }
                  multiSocketManager.login('A', this.usernameA);
                  setTimeout(() => {
                    this.loginFinishA = multiSocketManager.getLoginFinish('A');
                  }, 500);
                })
                .enabled(this.connectFinishA && !this.loginFinishA)

              if (this.loginFinishA) {
                Text('√ 已登录')
                  .fontColor(Color.Green)
                  .fontSize(14)
              }else {
                Text('× 未登录')
                  .fontColor(Color.Red)
                  .fontSize(14)
              }
            }
            .width('100%')
            .justifyContent(FlexAlign.Start)
          }
          .alignItems(HorizontalAlign.Start)
          .padding(15)
          .backgroundColor('#e8f5e8')
          .borderRadius(10)

          // 客户端B登录
          Column({ space: 10 }) {
            Text('客户端B用户')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .alignSelf(ItemAlign.Start)

            TextInput({ placeholder: "请输入客户端B的用户名，不输入默认'B'" })
              .onChange((username) => {
                this.usernameB = username;
                multiSocketManager.setUsername('B', username);
              })

            Row({ space: 10 }) {
              Button('登录B')
                .fontSize(14)
                .backgroundColor(this.loginFinishB ? Color.Green : Color.Blue)
                .onClick(() => {
                  // if (this.usernameB.trim() === '') {
                  //   prompt.showToast({ message: "请输入客户端B的用户名" });
                  //   return;
                  // }
                  multiSocketManager.login('B', this.usernameB);
                  setTimeout(() => {
                    this.loginFinishB = multiSocketManager.getLoginFinish('B');
                  }, 500);
                })
                .enabled(this.connectFinishB && !this.loginFinishB)

              if (this.loginFinishB) {
                Text('√ 已登录')
                  .fontColor(Color.Green)
                  .fontSize(14)
              } else {
                Text('× 未登录')
                  .fontColor(Color.Red)
                  .fontSize(14)
              }
            }
            .width('100%')
            .justifyContent(FlexAlign.Start)
          }
          .alignItems(HorizontalAlign.Start)
          .padding(15)
          .backgroundColor('#e8f5e8')
          .borderRadius(10)
          
          // 同时登录按钮
          Button('同时登录A和B')
            .width('100%')
            .fontSize(16)
            .backgroundColor(Color.Blue)
            .onClick(() => {
              // 并行登录
              multiSocketManager.login('A', this.usernameA);
              multiSocketManager.login('B', this.usernameB);
              // 稍后刷新登录状态
              setTimeout(() => {
                this.loginFinishA = multiSocketManager.getLoginFinish('A');
                this.loginFinishB = multiSocketManager.getLoginFinish('B');
              }, 500);
            })
            // 两端均已连接且两端均未登录时可点击
            .enabled(this.connectFinishA && this.connectFinishB && (!this.loginFinishA && !this.loginFinishB))
        }

        // 进入聊天按钮
        Button('进入多客户端聊天')
          .width('100%')
          .height(50)
          .fontSize(18)
          .backgroundColor(Color.Red)
          .onClick(() => {
            // if (!this.loginFinishA && !this.loginFinishB) {
            //   prompt.showToast({ message: "请至少登录一个客户端" });
            //   return;
            // }
            router.pushUrl({
              url: 'pages/MultiClientChat'
            });
          })
          .enabled(this.loginFinishA || this.loginFinishB)

        // 返回单客户端按钮
        Button('返回单客户端模式')
          .width('100%')
          .height(40)
          .fontSize(16)
          .backgroundColor(Color.Grey)
          .onClick(() => {
            router.back();
          })

        // 连接状态显示
        Row() {
          Column() {
            Text('客户端A状态')
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
            Text(this.connectFinishA ? '已连接' : '未连接')
              .fontSize(12)
              .fontColor(this.connectFinishA ? Color.Green : Color.Red)
            Text(this.loginFinishA ? '已登录' : '未登录')
              .fontSize(12)
              .fontColor(this.loginFinishA ? Color.Green : Color.Red)
            Text(`命名空间: ${this.nspA && this.nspA.trim() !== '' ? '/, ' + (this.nspA.startsWith('/') ? this.nspA : '/' + this.nspA) : '/'}`)
              .fontSize(12)
              .fontColor('#666666')
          }
          .layoutWeight(1)

          Column() {
            Text('客户端B状态')
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
            Text(this.connectFinishB ? '已连接' : '未连接')
              .fontSize(12)
              .fontColor(this.connectFinishB ? Color.Green : Color.Red)
            Text(this.loginFinishB ? '已登录' : '未登录')
              .fontSize(12)
              .fontColor(this.loginFinishB ? Color.Green : Color.Red)
            Text(`命名空间: ${this.nspB && this.nspB.trim() !== '' ? '/, ' + (this.nspB.startsWith('/') ? this.nspB : '/' + this.nspB) : '/'}`)
              .fontSize(12)
              .fontColor('#666666')
          }
          .layoutWeight(1)
        }
        .width('100%')
        .padding(15)
        .backgroundColor('#f0f0f0')
        .borderRadius(10)
        .margin({ bottom: 20 })
      }
      .width('100%')
      .padding(20)
    }
  }

  onPageShow() {
    // 500ms 更新一次状态（避免多次进入页面创建多个定时器）
    if (this.statusRefreshTimer !== undefined) {
      return;
    }
    this.statusRefreshTimer = setInterval(() => {
      this.connectFinishA = multiSocketManager.getConnectFinish('A');
      this.connectFinishB = multiSocketManager.getConnectFinish('B');
      this.loginFinishA = multiSocketManager.getLoginFinish('A');
      this.loginFinishB = multiSocketManager.getLoginFinish('B');
    }, 500);
  }

  onPageHide() {
    // 清理定时器，防止页面隐藏后仍然触发回调导致不必要的开销或潜在异常
    if (this.statusRefreshTimer !== undefined) {
      clearInterval(this.statusRefreshTimer);
      this.statusRefreshTimer = undefined;
    }
  }
}