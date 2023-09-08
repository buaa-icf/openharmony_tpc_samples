/*
 * Copyright (C) 2023 Huawei Device Co., Ltd.
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

import promptAction from '@ohos.promptAction'
import Imap, { inspect } from '@ohos/node_imap'
import socket from '@ohos.net.socket'
import StatusBean from '../bean/StatusBean'
import MsgListBean, { MsgListFootBean, MsgListHeadBean } from '../bean/MsgListBean'


const BASE_COUNT = 1

@Entry
@Component
struct TestInterfacePage {
  @State isLogin: boolean = false
  @State isBoxOpen: boolean = false
  @State message: string = 'Hello World'
  @State secure: boolean = false
  @State startIndex: number = 1 //当前页
  @State endIndex: number = 10 //当前页
  @State bean: StatusBean = undefined //获取邮件列表之前先获取该文件夹里面的邮件总数和状态
  @State uidList: Array<string> = [] //邮件uid列表
  @State subFolderList: Array<string> = [] //邮件列表数据集合
  @State folderList: Array<string> = [] //邮件列表数据集合
  @State listData: Array<MsgListBean> = [] //邮件列表数据集合
  @State account: string = ''
  @State password: string = ''
  pageSize: number = 10 //请求时的每页多少条信息，用于分页请求
  folderName: string = 'INBOX'
  private option: socket.TLSConnectOptions = {
    ALPNProtocols: ["spdy/1", "http/1.1"],
    address: {
      address: 'imap.xxx.com',
      port: 993,
      family: 1
    },
    secureOptions: {
      key: '',
      cert: '',
      ca: [''],
      useRemoteCipherPrefer: true,

    }
  }

  showToast(text: string, name = '测试') {
    console.log(`IMAPTest---${name}--->${text}`)
    promptAction.showToast({
      message: text,
      duration: 2000,
      bottom: 50
    })
    this.message = this.message + "\r\n" + text
  }

  build() {

    Flex({
      alignItems: ItemAlign.Start,
      justifyContent: FlexAlign.Start,
      alignContent: FlexAlign.Start,
      direction: FlexDirection.Column
    }) {
      Flex({
        alignItems: ItemAlign.Start,
        justifyContent: FlexAlign.Start,
        alignContent: FlexAlign.Start,
        direction: FlexDirection.Row
      }) {
        Text('账号：')
          .fontSize(20)
          .height(50)
          .textAlign(TextAlign.Center)
          .margin({ right: 5 })

        TextInput({ placeholder: '请输入账号', text: this.account })
          .layoutWeight(1)
          .fontSize(20)
          .height(50)
          .borderWidth(2)
          .textAlign(TextAlign.Center)
          .borderColor(Color.Gray)
          .type(InputType.Normal)
          .margin({ left: 15 })
          .onChange((data) => {
            this.account = data
          })


      }.margin({ left: 15, top: 20 })

      Flex({
        alignItems: ItemAlign.Start,
        justifyContent: FlexAlign.Start,
        alignContent: FlexAlign.Start,
        direction: FlexDirection.Row
      }) {
        Text('密码/授权码：')
          .fontSize(20)
          .height(50)
          .textAlign(TextAlign.Center)
          .margin({ right: 5 })

        TextInput({ placeholder: '请输入密码/授权码', text: this.password })
          .layoutWeight(1)
          .fontSize(20)
          .height(50)
          .borderWidth(2)
          .textAlign(TextAlign.Center)
          .borderColor(Color.Gray)
          .type(InputType.Normal)
          .margin({ right: 15 })
          .onChange((data) => {
            this.password = data
          })
      }
      .margin({ left: 15, top: 20 })

      Flex({ direction: FlexDirection.Row }) {
        Scroll() {
          Column() {
            Button('登录')
              .fontSize(14)
              .height(50)
              .visibility(this.isLogin ? Visibility.None : Visibility.Visible)
              .width("100%")
              .margin({ top: 100, left: 10, right: 10 })
              .onClick(() => {
                this.login()
              })
            Button('退出登录')
              .fontSize(14)
              .height(50)
              .visibility(this.isLogin ? Visibility.Visible : Visibility.None)
              .width("100%")
              .margin(10)
              .onClick(() => {
                this.loginOut()
              })
            Button('检查服务器支持的能力')
              .fontSize(14)
              .height(50)
              .margin(10)
              .visibility(this.isLogin ? Visibility.Visible : Visibility.None)
              .width("100%")
              .onClick(() => {
                this.checkServerCapability()
              })
            Button('获取邮箱里的文件夹列表')
              .fontSize(14)
              .height(50)
              .margin(10)
              .visibility(this.isLogin ? Visibility.Visible : Visibility.None)
              .width("100%")
              .onClick(() => {
                this.getFolderList()
              })
            Button('添加新文件夹(名字暂定test)')
              .fontSize(14)
              .height(50)
              .margin(10)
              .visibility(this.isLogin ? Visibility.Visible : Visibility.None)
              .width("100%")
              .onClick(() => {
                this.createFolder()
              })

            Button('删除新文件夹')
              .fontSize(14)
              .height(50)
              .margin(10)
              .visibility(this.isLogin ? Visibility.Visible : Visibility.None)
              .width("100%")
              .onClick(() => {
                this.delFolder()
              })
            Button('重命名新文件夹')
              .fontSize(14)
              .height(50)
              .margin(10)
              .visibility(this.isLogin ? Visibility.Visible : Visibility.None)
              .width("100%")
              .onClick(() => {
                this.renameFolder()
              })

            Button('获取订阅邮箱文件夹列表')
              .fontSize(14)
              .height(50)
              .margin(10)
              .visibility(this.isLogin ? Visibility.Visible : Visibility.None)
              .width("100%")
              .onClick(() => {
                this.getSubFolderList()
              })
            Button('订阅邮箱文件夹')
              .fontSize(14)
              .height(50)
              .margin(10)
              .visibility(this.isLogin ? Visibility.Visible : Visibility.None)
              .width("100%")
              .onClick(() => {
                this.subBox()
              })
            Button('取消订阅邮箱文件夹')
              .fontSize(14)
              .height(50)
              .margin(10)
              .visibility(this.isLogin ? Visibility.Visible : Visibility.None)
              .width("100%")
              .onClick(() => {
                this.unSubBox()
              })
            Button('获取主邮箱列表')
              .fontSize(14)
              .height(50)
              .margin(10)
              .visibility(this.isLogin && !this.isBoxOpen ? Visibility.Visible : Visibility.None)
              .width("100%")
              .onClick(() => {
                this.openBoxAndGetStatu()
              })
            Button('获取某个邮件详情')
              .fontSize(14)
              .height(50)
              .margin(10)
              .visibility(this.isLogin && this.isBoxOpen ? Visibility.Visible : Visibility.None)
              .width("100%")
              .onClick(() => {
                this.getMsgDetail()
              })
            Button('上传本地邮件到邮箱')
              .fontSize(14)
              .height(50)
              .margin(10)
              .visibility(this.isLogin && this.isBoxOpen ? Visibility.Visible : Visibility.None)
              .width("100%")
              .onClick(() => {
                this.appendMail()
              })
            Button('关闭邮箱主文件夹')
              .fontSize(14)
              .height(50)
              .margin(10)
              .visibility(this.isLogin && this.isBoxOpen ? Visibility.Visible : Visibility.None)
              .width("100%")
              .onClick(() => {
                this.closeBox()
              })
            Button('邮件排序')
              .fontSize(14)
              .height(50)
              .margin(10)
              .visibility(this.isLogin && this.isBoxOpen ? Visibility.Visible : Visibility.None)
              .width("100%")
              .onClick(() => {
                this.sortMail()
              })
            Button('搜索邮件')
              .fontSize(14)
              .height(50)
              .margin(10)
              .visibility(this.isLogin && this.isBoxOpen ? Visibility.Visible : Visibility.None)
              .width("100%")
              .onClick(() => {
                this.search()
              })
            Button('给邮件添加删除标记')
              .fontSize(14)
              .height(50)
              .margin(10)
              .visibility(this.isLogin && this.isBoxOpen ? Visibility.Visible : Visibility.None)
              .width("100%")
              .onClick(() => {
                this.storeMail()
              })


            Button('复制邮件到其他文件夹')
              .fontSize(14)
              .height(50)
              .margin(10)
              .visibility(this.isLogin && this.isBoxOpen ? Visibility.Visible : Visibility.None)
              .width("100%")
              .onClick(() => {
                this.copyMail()
              })
            Button('给邮件添加flag')
              .fontSize(14)
              .height(50)
              .margin(10)
              .visibility(this.isLogin && this.isBoxOpen ? Visibility.Visible : Visibility.None)
              .width("100%")
              .onClick(() => {
                this.addFlag()
              })
            Button('给邮件设置flag')
              .fontSize(14)
              .height(50)
              .margin(10)
              .visibility(this.isLogin && this.isBoxOpen ? Visibility.Visible : Visibility.None)
              .width("100%")
              .onClick(() => {
                this.setFlag()
              })
            Button('给邮件删除flag')
              .fontSize(14)
              .height(50)
              .margin(10)
              .visibility(this.isLogin && this.isBoxOpen ? Visibility.Visible : Visibility.None)
              .width("100%")
              .onClick(() => {
                this.deleteFlag()
              })
            Button('给邮件添加keyword')
              .fontSize(14)
              .height(50)
              .margin(10)
              .visibility(this.isLogin && this.isBoxOpen ? Visibility.Visible : Visibility.None)
              .width("100%")
              .onClick(() => {
                this.addKeywords()
              })
            Button('给邮件设置keyword')
              .fontSize(14)
              .height(50)
              .margin(10)
              .visibility(this.isLogin && this.isBoxOpen ? Visibility.Visible : Visibility.None)
              .width("100%")
              .onClick(() => {
                this.setKeywords()
              })
            Button('给邮件删除keyword')
              .fontSize(14)
              .height(50)
              .margin(10)
              .visibility(this.isLogin && this.isBoxOpen ? Visibility.Visible : Visibility.None)
              .width("100%")
              .onClick(() => {
                this.delKeywords()
              })

            Button('移动邮件到其他文件夹')
              .fontSize(14)
              .height(50)
              .margin(10)
              .visibility(this.isLogin && this.isBoxOpen ? Visibility.Visible : Visibility.None)
              .width("100%")
              .onClick(() => {
                this.moveMail()
              })
          }
          .width('100%')
          .height(2200)
        }
        .layoutWeight(1)


        Scroll() {
          Flex({ alignItems: ItemAlign.Start, justifyContent: FlexAlign.Start }) {
            Text(this.message)
              .fontSize(14)
              .textAlign(TextAlign.Start)
              .padding(20)
              .backgroundColor('#22CCCCCC')
              .fontColor(Color.Black)
              .width('100%')
          }
        }.layoutWeight(1)
        .height('100%')
      }
    }

  }


  async login() {
    const ctx = this;
    ctx.message = ''
    try {
      ctx.showToast('开始登录账号', 'login-imap')
      let hostParam = ctx.account.substring(ctx.account.indexOf('@') + 1, ctx.account.indexOf('.'))
      if (!globalThis.client) {
        if (ctx.secure) {
          let context: Context = globalThis.context ? globalThis.context : getContext(ctx)
          let ca0Data = await context.resourceManager.getRawFileContent('QQMailMiddle.pem')
          let ca0 = '';
          for (let i = 0; i < ca0Data.length; i++) {
            let todo = ca0Data[i]
            let item = String.fromCharCode(todo);
            ca0 += item;
          }
          // @ts-ignore
          ctx.option.secureOptions.ca[0] = ca0;

          let ca1Data = await context.resourceManager.getRawFileContent('QQMailRoot.pem')
          let ca1 = '';
          for (let i = 0; i < ca1Data.length; i++) {
            let todo = ca1Data[i]
            let item = String.fromCharCode(todo);
            ca1 += item;
          }
          // @ts-ignore
          ctx.option.secureOptions.ca[1] = ca1;
          ctx.option.address.address = `imap.${hostParam}.com`;
          ctx.option.address.port = 993;
          globalThis.client = new Imap({
            user: ctx.account,
            password: ctx.password,
            host: `imap.${hostParam}.com`,
            port: 993,
            tls: true,
            tlsOptions: ctx.option,
            socketTimeout: 60000,
            connTimeout: 60000,
            authTimeout: 60000,
            keepalive: true,

          });
        } else {
          globalThis.client = new Imap({
            user: ctx.account,
            password: ctx.password,
            host: `imap.${hostParam}.com`,
            port: 143,
            tls: false,
            tlsOptions: undefined,
            socketTimeout: 60000,
            connTimeout: 60000,
            authTimeout: 60000,
            keepalive: true,

          });
        }
      }
      ctx.showToast(`客户端初始化成功，参数：${JSON.stringify(globalThis.client._config)}`, 'login-imap')
      if (globalThis.client) {
        globalThis.client.once('ready', function () {
          ctx.isLogin = true;
          ctx.showToast('登录成功，准备跳转邮件文件夹列表', 'login-imap')
          // globalThis.client._doKeepaliveTimer(true) //登陆成功之后通过noop命令不断的轮训服务器 防止断开连接 原库已封装了该命令不断调用 无需用户手动调用
        });

        globalThis.client.once('error', function (err) {
          console.log(err);
        });

        globalThis.client.once('end', function () {
          console.log('Connection ended');
        });
        ctx.showToast('开始连接服务器', 'login-imap')
        let startTime1 = new Date().getTime();
        await globalThis.client.connect();
        let endTime1 = new Date().getTime();
        let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
        console.log("IMAPClientTest : connect averageTime : " + averageTime1 + "us")
        ctx.showToast('服务器连接成功', 'login-imap')
      }
    } catch (err) {
      ctx.showToast(`账号登录出错：${err.message}`, 'login-smtp')
    }
  }

  loginOut() {
    const ctx = this;
    ctx.message = ''
    try {
      ctx.showToast('开始退出登录,请稍等', 'loginOut-imap')
      if (globalThis.client) {
        let startTime1 = new Date().getTime();
        globalThis.client.end(() => {
          let endTime1 = new Date().getTime();
          let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
          console.log("IMAPClientTest : end averageTime : " + averageTime1 + "us")
          ctx.showToast('退出登录成功', 'loginOut-imap')
          let startTime2 = new Date().getTime();
          globalThis.client.destroy()
          let endTime2 = new Date().getTime();
          let averageTime2 = ((endTime2 - startTime2) * 1000) / BASE_COUNT;
          console.log("IMAPClientTest : destroy averageTime : " + averageTime2 + "us")
          globalThis.client = undefined;
          ctx.isLogin = false;
        });

      } else {
        ctx.showToast('退出登录失败，客户端对象为空', 'loginOut-imap')
        ctx.isLogin = false;
      }
    } catch (err) {
      ctx.showToast(`退出登录出错：${err.message}`, 'loginOut-smtp')
    }
  }

  checkServerCapability() {
    this.message = ''
    if (!globalThis.client || !this.isLogin) {
      this.showToast(`检查服务端能力出错：客户端未登录`, 'checkServerCapability-smtp')
      return
    }
    let supportList = globalThis.client.getSupportList();
    if (supportList) {
      this.showToast(`服务端能力列表： ${JSON.stringify(supportList)}`, 'checkServerCapability-smtp')
    }
    let startTime1 = new Date().getTime();
    let checkResult = globalThis.client.serverSupports('IMAP4');
    let endTime1 = new Date().getTime();
    let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
    console.log("IMAPClientTest : serverSupports averageTime : " + averageTime1 + "us")
    this.showToast(`服务端能力是否支持-${'IMAP4'},结果是：${checkResult}`, 'checkServerCapability-smtp')
  }

  getFolderList() {
    const ctx = this;
    ctx.message = ''
    if (!globalThis.client || !ctx.isLogin) {
      ctx.showToast('账号未登录，请登录后再试', 'getFolderList-imap')
      return
    }
    ctx.showToast(`获取邮箱里的文件夹列表开始`, 'getFolderList-imap')
    let startTime1 = new Date().getTime();
    globalThis.client.getBoxes(function (err, data) {
      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
      console.log("IMAPClientTest : getBoxes averageTime : " + averageTime1 + "us")
      if (err) {
        ctx.showToast(`获取邮箱里的文件夹列表出错，数据是：${err.message}`, 'getFolderList-imap')
        return
      }
      if (!data || typeof data != 'object') {
        ctx.showToast(`获取邮箱里的文件夹列表出错，get box status fail`, 'getFolderList-imap')
        return
      }
      ctx.folderList = [];
      for (let key in data) {
        ctx.folderList.push(key.toString())
      }
      ctx.showToast(`获取邮箱里的文件夹列表成功，数据是：${JSON.stringify(ctx.folderList)}`, 'getFolderList-imap')
    })
  }

  createFolder() {
    const ctx = this;
    try {
      ctx.message = ''
      if (!globalThis.client || !ctx.isLogin) {
        ctx.showToast('账号未登录，请登录后再试', 'createFolder-imap')
        return
      }
      ctx.showToast('开始创建文件夹', 'createFolder-imap')
      let startTime1 = new Date().getTime();
      let addName = 'addFolder' + new Date().getTime();
      globalThis.client.addBox(addName, (err, result) => {
        let endTime1 = new Date().getTime();
        let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
        console.log("IMAPClientTest : addBox averageTime : " + averageTime1 + "us")
        if (err) {
          ctx.showToast(`创建文件夹失败,原因：${err.message}`, 'createFolder-imap')
        } else {
          ctx.showToast('创建文件夹成功', 'createFolder-imap')
          ctx.showToast(`获取邮箱里的文件夹列表开始`, 'getFolderList-imap')
          globalThis.client.getBoxes(function (err, data) {
            if (err) {
              ctx.showToast(`获取邮箱里的文件夹列表出错，数据是：${err.message}`, 'getFolderList-imap')
              return
            }
            ;
            if (!data || typeof data != 'object') {
              ctx.showToast(`获取邮箱里的文件夹列表出错，get box status fail`, 'getFolderList-imap')
              return
            }
            ctx.folderList = [];
            for (let key in data) {
              ctx.folderList.push(key.toString())
            }
            ctx.showToast(`获取邮箱里的文件夹列表成功，数据是：${JSON.stringify(ctx.folderList)}`, 'getFolderList-imap')
          })
        }
      }
      );
    }
    catch (err) {
      ctx.showToast(`账号登录出错：${err.message}`, 'createFolder-smtp')
    }
  }

  delFolder() {
    const ctx = this;
    try {
      ctx.message = ''
      if (!globalThis.client || !ctx.isLogin) {
        ctx.showToast('账号未登录，请登录后再试', 'delFolder-imap')
        return
      }
      let folderName = 'delFolder' + new Date().getTime();
      globalThis.client.addBox(folderName, (err, result) => {
        if (err) {
          ctx.showToast(`创建用于删除的文件夹失败,原因：${err.message}`, 'delFolder-imap')
        } else {
          ctx.showToast('创建用于删除的文件夹成功', 'delFolder-imap')
          ctx.showToast(`获取邮箱里的文件夹列表开始`, 'delFolder-imap')
          globalThis.client.getBoxes(function (err, data) {
            if (err) {
              ctx.showToast(`获取邮箱里的文件夹列表出错，数据是：${err.message}`, 'delFolder-imap')
              return
            }
            ;
            if (!data || typeof data != 'object') {
              ctx.showToast(`获取邮箱里的文件夹列表出错，get box status fail`, 'delFolder-imap')
              return
            }
            ctx.folderList = [];
            for (let key in data) {
              ctx.folderList.push(key.toString())
            }
            ctx.showToast(`获取邮箱里的文件夹列表成功，数据是：${JSON.stringify(ctx.folderList)}`, 'delFolder-imap')
            ctx.showToast('开始删除文件夹：delFolder', 'deleteFolder-imap')
            let startTime1 = new Date().getTime();
            globalThis.client.delBox(folderName, (err, result) => {
              let endTime1 = new Date().getTime();
              let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
              console.log("IMAPClientTest : delBox averageTime : " + averageTime1 + "us")
              if (err) {
                ctx.showToast('删除文件夹失败', 'delFolder-imap')
              } else {
                ctx.showToast('删除文件夹成功', 'delFolder-imap')
                ctx.showToast(`获取邮箱里的文件夹列表开始`, 'getFolderList-imap')
                globalThis.client.getBoxes(function (err, data) {
                  if (err) {
                    ctx.showToast(`获取邮箱里的文件夹列表出错，数据是：${err.message}`, 'getFolderList-imap')
                    return
                  }
                  ;
                  if (!data || typeof data != 'object') {
                    ctx.showToast(`获取邮箱里的文件夹列表出错，get box status fail`, 'getFolderList-imap')
                    return
                  }
                  ctx.folderList = [];
                  for (let key in data) {
                    ctx.folderList.push(key.toString())
                  }
                  ctx.showToast(`获取邮箱里的文件夹列表成功，数据是：${JSON.stringify(ctx.folderList)}`, 'getFolderList-imap')
                })
              }
            });
          })
        }
      });

    } catch (err) {
      ctx.showToast(`账号登录出错：${err.message}`, 'createFolder-smtp')
    }
  }

  renameFolder() {
    const ctx = this;
    try {
      ctx.message = ''
      if (!globalThis.client || !ctx.isLogin) {
        ctx.showToast('账号未登录，请登录后再试', 'renameFolder-imap')
        return
      }
      let renameName = 'renameFolder' + new Date().getTime();
      globalThis.client.addBox(renameName, (err, result) => {
        if (err) {
          ctx.showToast(`创建用于删除的文件夹失败,原因：${err.message}`, 'renameFolder-imap')
        } else {
          ctx.showToast('创建用于删除的文件夹成功', 'renameFolder-imap')
          ctx.showToast(`获取邮箱里的文件夹列表开始`, 'renameFolder-imap')
          globalThis.client.getBoxes(function (err, data) {
            if (err) {
              ctx.showToast(`获取邮箱里的文件夹列表出错，数据是：${err.message}`, 'renameFolder-imap')
              return
            }
            ;
            if (!data || typeof data != 'object') {
              ctx.showToast(`获取邮箱里的文件夹列表出错，get box status fail`, 'renameFolder-imap')
              return
            }
            ctx.folderList = [];
            for (let key in data) {
              ctx.folderList.push(key.toString())
            }
            ctx.showToast(`获取邮箱里的文件夹列表成功，数据是：${JSON.stringify(ctx.folderList)}`, 'renameFolder-imap')
            ctx.showToast('开始重命名文件夹', 'renameFolder-imap')
            let startTime1 = new Date().getTime();
            globalThis.client.renameBox(renameName, 'newFolder', (err, result) => {
              let endTime1 = new Date().getTime();
              let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
              console.log("IMAPClientTest : renameBox averageTime : " + averageTime1 + "us")
              if (err) {
                ctx.showToast(`重命名文件夹失败,原因：${err.message}`, 'renameFolder-imap')
              } else {
                ctx.showToast('重命名文件夹成功', 'renameFolder-imap')
                ctx.showToast(`获取邮箱里的文件夹列表开始`, 'getFolderList-imap')
                globalThis.client.getBoxes(function (err, data) {
                  if (err) {
                    ctx.showToast(`获取邮箱里的文件夹列表出错，数据是：${err.message}`, 'getFolderList-imap')
                    return
                  }
                  ;
                  if (!data || typeof data != 'object') {
                    ctx.showToast(`获取邮箱里的文件夹列表出错，get box status fail`, 'getFolderList-imap')
                    return
                  }
                  ctx.folderList = [];
                  for (let key in data) {
                    ctx.folderList.push(key.toString())
                  }
                  ctx.showToast(`获取邮箱里的文件夹列表成功，数据是：${JSON.stringify(ctx.folderList)}`, 'getFolderList-imap')
                })
              }
            });
          })
        }
      });

    } catch (err) {
      ctx.showToast(`账号登录出错：${err.message}`, 'renameFolder-smtp')
    }
  }

  subBox() {
    const ctx = this;
    try {
      ctx.message = ''
      if (!globalThis.client || !ctx.isLogin) {
        ctx.showToast('账号未登录，请登录后再试', 'subBox-imap')
        return
      }
      ctx.showToast('开始获取订阅的文件夹。', 'subBox-imap')
      globalThis.client.getSubscribedBoxes((err, result) => {
        if (err) {
          ctx.showToast(`获取订阅的文件夹失败,原因：${err.message}`, 'subBox-imap')
        } else {
          ctx.subFolderList = [];
          for (let key in result) {
            ctx.subFolderList.push(key.toString())
          }
          ctx.showToast(`获取订阅的文件夹成功，数据是：${JSON.stringify(ctx.subFolderList)}`, 'subBox-imap')
          ctx.showToast('开始创建文件夹', 'subBox-imap')
          let subName = 'subFolder' + new Date().getTime();
          globalThis.client.addBox(subName, (err, result) => {
            if (err) {
              ctx.showToast(`创建文件夹失败,原因：${err.message}`, 'subBox-imap')
            } else {
              ctx.showToast('创建文件夹成功', 'subBox-imap')
              ctx.showToast('订阅addFolder文件夹', 'subBox-imap')
              let startTime1 = new Date().getTime();
              globalThis.client.subscribeBox(subName, (err, result) => {
                let endTime1 = new Date().getTime();
                let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
                console.log("IMAPClientTest : subscribeBox averageTime : " + averageTime1 + "us")

                if (err) {
                  ctx.showToast(`订阅邮箱失败,原因：${err.message}`, 'subBox-imap')
                } else {
                  ctx.showToast('订阅邮箱成功', 'subBox-imap')
                  ctx.showToast('开始获取订阅的文件夹。', 'subBox-imap')
                  globalThis.client.getSubscribedBoxes((err, result) => {
                    if (err) {
                      ctx.showToast(`获取订阅的文件夹失败,原因：${err.message}`, 'subBox-imap')
                    } else {
                      ctx.subFolderList = [];
                      for (let key in result) {
                        ctx.subFolderList.push(key.toString())
                      }
                      ctx.showToast(`获取订阅的文件夹成功，数据是：${JSON.stringify(ctx.subFolderList)}`, 'subBox-imap')
                    }
                  });
                }
              });
            }
          });
        }
      });
    } catch (err) {
      ctx.showToast(`订阅邮箱出错：${err.message}`, 'subBox-smtp')
    }
  }

  unSubBox() {
    const ctx = this;
    try {
      ctx.message = ''
      if (!globalThis.client || !ctx.isLogin) {
        ctx.showToast('账号未登录，请登录后再试', 'unSubBox-imap')
        return
      }
      ctx.showToast('开始获取订阅的文件夹。', 'unSubBox-imap')
      globalThis.client.getSubscribedBoxes((err, result) => {
        if (err) {
          ctx.showToast(`获取订阅的文件夹失败,原因：${err.message}`, 'unSubBox-imap')
        } else {
          ctx.subFolderList = [];
          for (let key in result) {
            ctx.subFolderList.push(key.toString())
          }
          ctx.showToast(`获取订阅的文件夹成功，数据是：${JSON.stringify(ctx.subFolderList)}`, 'unSubBox-imap')
          ctx.showToast('开始创建文件夹', 'subBox-imap')
          let unSubName = 'unSubFolder' + new Date().getTime();
          globalThis.client.addBox(unSubName, (err, result) => {
            if (err) {
              ctx.showToast(`创建文件夹失败,原因：${err.message}`, 'unSubBox-imap')
            } else {
              ctx.showToast('创建文件夹成功', 'subBox-imap')
              ctx.showToast('订阅addFolder文件夹', 'subBox-imap')
              globalThis.client.subscribeBox(unSubName, (err, result) => {
                if (err) {
                  ctx.showToast(`订阅邮箱失败,原因：${err.message}`, 'unSubBox-imap')
                } else {
                  ctx.showToast('订阅邮箱成功', 'subBox-imap')
                  ctx.showToast('开始获取订阅的文件夹。', 'subBox-imap')
                  globalThis.client.getSubscribedBoxes((err, result) => {
                    if (err) {
                      ctx.showToast(`获取订阅的文件夹失败,原因：${err.message}`, 'unSubBox-imap')
                    } else {
                      ctx.subFolderList = [];
                      for (let key in result) {
                        ctx.subFolderList.push(key.toString())
                      }
                      ctx.showToast(`获取订阅的文件夹成功，数据是：${JSON.stringify(ctx.subFolderList)}`, 'unSubBox-imap')
                      let startTime1 = new Date().getTime();
                      globalThis.client.unsubscribeBox(unSubName, (err, result) => {
                        let endTime1 = new Date().getTime();
                        let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
                        console.log("IMAPClientTest : unsubscribeBox averageTime : " + averageTime1 + "us")
                        if (err) {
                          ctx.showToast(`取消订阅邮箱失败,原因：${err.message}`, 'unSubBox-imap')
                        } else {
                          ctx.showToast('取消订阅邮箱成功', 'unSubBox-imap')
                          ctx.showToast('开始获取订阅的文件夹。', 'getSubFolderList-imap')
                          globalThis.client.getSubscribedBoxes((err, result) => {
                            if (err) {
                              ctx.showToast(`获取订阅的文件夹失败,原因：${err.message}`, 'getSubFolderList-imap')
                            } else {
                              ctx.subFolderList = [];
                              for (let key in result) {
                                ctx.subFolderList.push(key.toString())
                              }
                              ctx.showToast(`获取订阅的文件夹成功，数据是：${JSON.stringify(ctx.subFolderList)}`, 'getFolderList-imap')
                            }
                          });
                        }
                      });
                    }
                  });
                }
              });
            }
          });
        }
      });
    } catch (err) {
      ctx.showToast(`订阅邮箱出错：${err.message}`, 'subBox-smtp')
    }
  }

  getSubFolderList() {
    const ctx = this;
    try {
      ctx.message = ''
      if (!globalThis.client || !ctx.isLogin) {
        ctx.showToast('账号未登录，请登录后再试', 'getSubFolderList-imap')
        return
      }
      ctx.showToast('开始获取订阅的文件夹。', 'getSubFolderList-imap')
      let startTime1 = new Date().getTime();
      globalThis.client.getSubscribedBoxes((err, result) => {
        let endTime1 = new Date().getTime();
        let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
        console.log("IMAPClientTest : getSubscribedBoxes averageTime : " + averageTime1 + "us")
        if (err) {
          ctx.showToast(`获取订阅的文件夹失败,原因：${err.message}`, 'getSubFolderList-imap')
        } else {
          ctx.subFolderList = [];
          for (let key in result) {
            ctx.subFolderList.push(key.toString())
          }
          ctx.showToast(`获取订阅的文件夹成功，数据是：${JSON.stringify(ctx.subFolderList)}`, 'getFolderList-imap')
        }
      });
    } catch (err) {
      ctx.showToast(`获取订阅的文件夹出错：${err.message}`, 'getSubFolderList-smtp')
    }
  }

  refreshPageSize() {
    const ctx = this;
    if (ctx.bean && ctx.bean.messages && ctx.startIndex >= ctx.bean.messages.total) {
      return;
    }
    ctx.endIndex = ctx.startIndex + ctx.pageSize - 1;
    if (ctx.bean && ctx.bean.messages && ctx.endIndex > ctx.bean.messages.total) {
      ctx.endIndex = ctx.bean.messages.total;
    }
  }

  openBoxAndGetStatu() {
    const ctx = this;
    try {
      ctx.message = ''
      if (!globalThis.client || !ctx.isLogin) {
        ctx.showToast('账号未登录，请登录后再试', 'openBoxAndGetStatu-imap')
        return
      }
      ctx.showToast(`获取主邮箱主文件夹状态开始，${ctx.folderName}`, 'openBoxAndGetStatu-imap')
      let startTime1 = new Date().getTime();
      globalThis.client.status(ctx.folderName, function (err, data) {
        let endTime1 = new Date().getTime();
        let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
        console.log("IMAPClientTest : status averageTime : " + averageTime1 + "us")

        if (err) {
          ctx.isBoxOpen = false;
          ctx.showToast(`获取邮箱主文件夹状态失败，${err.message}`, 'openBoxAndGetStatu-imap')
          return
        }
        if (!data || data.length < 1) {
          ctx.isBoxOpen = false;
          ctx.showToast('获取邮箱主文件夹状态失败，无数据', 'openBoxAndGetStatu-imap')
          return
        }
        try {
          ctx.bean = JSON.parse(JSON.stringify(data))
          if (ctx.bean && ctx.bean.messages.total > 0) {
            let startTime1 = new Date().getTime();
            globalThis.client.openBox(ctx.folderName, true, function (err, box) {
              let endTime1 = new Date().getTime();
              let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
              console.log("IMAPClientTest : openBox averageTime : " + averageTime1 + "us")
              if (err) {
                ctx.isBoxOpen = true;
                ctx.showToast(`打开邮箱主文件夹失败，${err.message}`, 'openBoxAndGetStatu-imap')
                return
              }
              ctx.showToast(`打开邮箱主文件夹成功`, 'openBoxAndGetStatu-imap')
              ctx.isBoxOpen = true;
              ctx.getListData()
            });
          } else {
            ctx.isBoxOpen = false;
            ctx.showToast(`文件夹：${ctx.folderName}中，有信息总共：${ctx.bean.messages.total},新消息:${ctx.bean.messages.new},未读消息:${ctx.bean.messages.unseen},未打开邮箱`, 'openBoxAndGetStatu-imap')
          }

        } catch (err) {
          ctx.showToast(`打开邮箱主文件夹失败，${err.message}`, 'openBoxAndGetStatu-imap')
        }
      })
    } catch (err) {
      ctx.showToast(`获取主邮箱邮件列表失败，信息是：${err.message}`, 'getListData-imap')
      throw err
    }
  }

  getListData() {
    const ctx = this;
    try {
      ctx.listData = []
      ctx.refreshPageSize();
      let buffer = '';
      ctx.message = ''
      if (!globalThis.client || !ctx.isLogin) {
        ctx.showToast('账号未登录，请登录后再试', 'getListData-imap')
        return
      }
      if (!ctx.isBoxOpen) {
        ctx.showToast('邮箱未打开，无法获取邮件列表', 'getListData-imap')
        return
      }
      if (!globalThis.client.seq) {
        ctx.showToast('客户端seq对象为空', 'getListData-imap')
        return
      }
      ctx.showToast(`开始获取主邮箱邮件列表`, 'getListData-imap')
      // fetch里面可以是fetch(`1:3`）这种取序号为1-3的信息的  也可以是可以是fetch(`1`）这种取序号为1的信息
      let startTime1 = new Date().getTime();
      var f = globalThis.client.seq.fetch(`${ctx.startIndex}:${ctx.endIndex}`, {
        bodies: 'HEADER.FIELDS (FROM TO SUBJECT DATE)',
        struct: true
      });
      f.on('message', function (msg, seqno) {
        var prefix = '(#' + seqno + ') ';
        msg.on('body', function (stream, info) {

          stream.on('data', function (chunk) {
            buffer += chunk.toString('utf8');
          });
          stream.once('end', function () {

          });
        });
        msg.once('attributes', function (attrs) {
          if (attrs && typeof attrs === 'object') {
            let uid = attrs['uid'] ? attrs['uid'] : ''
            ctx.uidList.push(uid);
          }
        });
        msg.once('end', function () {
          console.log(prefix + 'Finished');
        });
      });
      f.once('error', function (err) {
        console.log('Fetch error: ' + err);
        ctx.showToast(`获取主邮箱邮件列表失败，信息是：${err.message}`, 'getListData-imap')
      });
      f.once('end', function () {
        let endTime1 = new Date().getTime();
        let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
        console.log("IMAPClientTest : fetch averageTime : " + averageTime1 + "us")
        console.log('Done fetching all messages!');

        let jsonObj = buffer.split('\r\n\r\n')
        if (!jsonObj) {
          throw new Error('get message list fail')
        }
        for (let i = 0; i < jsonObj.length; i++) {
          let childArr = jsonObj[i].split('\r\n')
          let bean = new MsgListBean();
          if (i < ctx.uidList.length) {
            bean.uid = ctx.uidList[i];
          }
          for (let j = 0; j < childArr.length; j++) {
            let child = childArr[j];
            if (child && child.indexOf('Date') != -1) {
              bean.Date = child;
            } else if (child && child.indexOf('From') != -1) {
              bean.From = child;
            } else if (child && child.indexOf('To') != -1) {
              bean.To = child;
            } else if (child && child.indexOf('Subject') != -1) {
              bean.Subject = child;
            } else {
              continue;
            }
          }
          ctx.listData.push(bean)
        }
        ctx.showToast(`获取主邮箱邮件列表成功，数据是：${JSON.stringify(ctx.listData)}`, 'getListData-imap')
        // globalThis.client.end();
      });
    } catch (err) {
      ctx.showToast(`获取主邮箱邮件列表失败，信息是：${err.message}`, 'getListData-imap')
      throw err
    }

  }

  createMailData() {
    let msg = {
      text: 'IMAP协议测试上传的邮件',
      from: `${'鸿蒙搬砖工'} <${'xx@qq.com'}>`,
      to: 'xx@qq.com',
      cc: 'xx@163.com',
      bcc: 'xx@139.com',
      subject: '鸿蒙客户端IMAP协议的主题'
    }
    return JSON.stringify(msg);
  }

  appendMail() {
    const ctx = this;
    try {
      ctx.message = ''
      if (!globalThis.client || !ctx.isLogin) {
        ctx.showToast('账号未登录，请登录后再试', 'appendMail-imap')
        return
      }
      if (!ctx.isBoxOpen) {
        ctx.showToast('邮箱未打开，无法获取邮件列表', 'appendMail-imap')
        return
      }
      let data = ctx.createMailData();
      if (!data || data.length < 1) {
        ctx.showToast('上传的邮件数据不可以为空', 'appendMail-imap')
        return
      }
      ctx.showToast('开始上传邮件', 'appendMail-imap')
      let option = {
        mailbox: 'INBOX',
        flag: ['Seen'], //取值 Seen flagged等
        date: new Date(), //取值 Seen flagged等

      }
      let startTime1 = new Date().getTime();
      globalThis.client.append(data, option, (err, result) => {
        let endTime1 = new Date().getTime();
        let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
        console.log("IMAPClientTest : append averageTime : " + averageTime1 + "us")
        if (err) {
          ctx.showToast(`上传邮件失败,原因：${err.message}`, 'appendMail-imap')
        } else {
          ctx.showToast('上传邮件成功', 'appendMail-imap')
        }
      });
    } catch (err) {
      ctx.showToast(`上传邮件出错：${err.message}`, 'appendMail-smtp')
    }
  }

  closeBox() {
    const ctx = this;
    try {
      ctx.message = ''
      ctx.showToast('开始关闭本文件夹', 'closeBox-imap')
      if (!globalThis.client || !ctx.isLogin) {
        ctx.showToast('账号未登录，请登录后再试', 'closeBox-imap')
        return
      }
      if (!ctx.isBoxOpen) {
        ctx.showToast('邮箱未打开，无法获取邮件列表', 'closeBox-imap')
        return
      }
      let startTime1 = new Date().getTime();
      globalThis.client.closeBox((err, result) => {
        let endTime1 = new Date().getTime();
        let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
        console.log("IMAPClientTest : closeBox averageTime : " + averageTime1 + "us")
        if (err) {
          ctx.showToast(`关闭本文件夹失败,原因：${err.message}`, 'closeBox-imap')
        } else {
          ctx.isBoxOpen = false;
          ctx.showToast('关闭本文件夹成功', 'appendMail-imap')
        }
      });
    } catch (err) {
      ctx.showToast(`关闭本文件夹出错：${err.message}`, 'closeBox-smtp')
    }
  }

  sortMail() {
    const ctx = this;
    try {
      ctx.message = ''
      ctx.showToast('开始设置排序', 'sortMail-imap')
      if (!globalThis.client || !ctx.isLogin) {
        ctx.showToast('账号未登录，请登录后再试', 'sortMail-imap')
        return
      }
      if (!ctx.isBoxOpen) {
        ctx.showToast('邮箱未打开，无法获取邮件列表', 'sortMail-imap')
        return
      }
      ctx.showToast('开始对邮件按照日期排序', 'sortMail-imap')
      let startTime1 = new Date().getTime();
      globalThis.client.sort(['DATE'], ['ALL'], (err, result) => {
        let endTime1 = new Date().getTime();
        let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
        console.log("IMAPClientTest : sort averageTime : " + averageTime1 + "us")
        if (err) {
          ctx.showToast(`对邮件按照日期排序失败,原因：${err.message}`, 'sortMail-imap')
        } else {
          ctx.showToast('对邮件按照日期排序成功', 'sortMail-imap')
        }
      });

    } catch (err) {
      ctx.showToast(`设置排序出错：${err.message}`, 'sortMail-smtp')
    }
  }

  search() {
    const ctx = this;
    try {
      ctx.message = ''
      ctx.showToast('开始搜索邮件', 'search-imap')
      if (!globalThis.client || !ctx.isLogin) {
        ctx.showToast('账号未登录，请登录后再试', 'search-imap')
        return
      }
      if (!ctx.isBoxOpen) {
        ctx.showToast('邮箱未打开，无法获取邮件列表', 'search-imap')
        return
      }
      let startTime1 = new Date().getTime();
      globalThis.client.search(['RECENT'], (err, result) => {
        let endTime1 = new Date().getTime();
        let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
        console.log("IMAPClientTest : search averageTime : " + averageTime1 + "us")
        if (err) {
          ctx.showToast(`搜索邮件失败,原因：${err.message}`, 'search-imap')
        } else {
          ctx.showToast('搜索邮件成功 ' + JSON.stringify(result), 'search-imap')
        }
      });
    } catch (err) {
      ctx.showToast(`搜索邮件出错：${err.message}`, 'search-smtp')
    }
  }


  /**
   * 给邮件打标记 比如删除 已读
   * Deleted \Flagged \Seen
   *
   */
  storeMail() {
    const ctx = this;
    ctx.message = ''
    if (!globalThis.client || !ctx.isLogin) {
      ctx.showToast('账号未登录，请登录后再试', 'search-imap')
      return
    }
    if (!ctx.isBoxOpen) {
      ctx.showToast('邮箱未打开，无法获取邮件列表', 'search-imap')
      return
    }

    if (!ctx.listData || ctx.listData.length < 1) {
      ctx.showToast('当前邮箱中暂无可用的消息', 'storeMail---IMAP')
      return
    }
    let uid = '';
    for (let i = 0; i < ctx.listData.length; i++) {
      if (ctx.listData[i] && ctx.listData[i].uid && ctx.listData[i].uid.toString().length > 0) {
        uid = ctx.listData[1].uid
        break;
      }
    }
    if (uid && uid.length > 0) {
      ctx.addDeleteFlag(uid)
    }else{
      ctx.showToast('暂无可以操作的邮件', 'storeMail---IMAP')
    }
  }

  addDeleteFlag(uid: string) {
    const ctx = this;
    try {
      ctx.showToast('开始给邮件打删除标记', 'addDeleteFlag-imap')
      globalThis.client.addFlags(uid, '\\Deleted', (err, result) => {
        if (err) {
          ctx.showToast(`给邮件打删除标记失败,原因：${err.message}`, 'addDeleteFlag-imap')
        } else {
          ctx.showToast('给邮件打删除标记成功', 'storeMail-imap')
          ctx.expungeMail(uid)
        }
      });

    } catch (err) {
      ctx.showToast(`给邮件打删除标记出错：${err.message}`, 'storeMail-smtp')
    }
  }

  expungeMail(uid: string) {
    const ctx = this;
    try {
      ctx.showToast('开始删除所有的标志为DELETED的邮件，EXPUNGE删除的邮件将不可以恢复', 'expungeMail-imap')
      let startTime1 = new Date().getTime();
      globalThis.client.expunge(uid, (err, result) => {
        let endTime1 = new Date().getTime();
        let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
        console.log("IMAPClientTest : expunge averageTime : " + averageTime1 + "us")
        if (err) {
          ctx.showToast(`永久删除失败,原因：${err.message}`, 'expungeMail-imap')
        } else {
          ctx.showToast(`永久删除成功 ${result}`, 'expungeMail-imap')
        }
      });
    } catch (err) {
      ctx.showToast(`永久删除出错：${err.message}`, 'expungeMail-smtp')
    }
  }

  copyMail() {
    const ctx = this;
    try {
      ctx.message = ''
      if (!globalThis.client || !ctx.isLogin) {
        ctx.showToast('账号未登录，请登录后再试', 'copyMail-imap')
        return
      }
      if (!ctx.isBoxOpen) {
        ctx.showToast('邮箱未打开，无法获取邮件列表', 'copyMail-imap')
        return
      }
      if (!ctx.listData || ctx.listData.length < 1) {
        ctx.showToast('当前邮箱中暂无可用的消息', 'copyMail---IMAP')
        return
      }
      let uid = ctx.listData[0].uid
      if (!uid || uid.length < 1) {
        ctx.showToast('当前邮箱中暂无可用的消息', 'copyMail---IMAP')
        return
      }
      if (!ctx.folderList || ctx.folderList.length < 1) {
        ctx.showToast('无可用的邮箱', 'copyMail---IMAP')
        return
      }
      let selectFoler = ''
      if (ctx.folderList) {
        let count = 0;
        for (let i = 0; i < ctx.folderList.length; i++) {
          if (ctx.folderList[i] && ctx.folderList[i].length > 0 && ctx.folderList[i] != ctx.folderName) {
            count++;
            selectFoler = ctx.folderList[i];
          }
        }
        if (count === 0) {
          ctx.showToast('无可用的邮箱', 'copyMail---IMAP')
          return
        }
      }
      ctx.showToast(`复制邮件开始`, 'copyMail-imap')
      let startTime1 = new Date().getTime();
      globalThis.client.copy(uid, selectFoler, (err, result) => {
        let endTime1 = new Date().getTime();
        let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
        console.log("IMAPClientTest : copy averageTime : " + averageTime1 + "us")
        if (err) {
          ctx.showToast(`复制邮件失败,原因：${err.message}`, 'copyMail-imap')
        } else {
          ctx.showToast('复制邮件成功，请去测试的邮箱查看是否复制成功，这里不通过日志展示 ' + JSON.stringify(result), 'copyMail-imap')

        }
      });

    } catch (err) {
      ctx.showToast(`复制邮件出错：${err.message}`, 'copyMail-smtp')
    }
  }

  moveMail() {
    const ctx = this;
    try {
      ctx.message = ''
      if (!globalThis.client || !ctx.isLogin) {
        ctx.showToast('账号未登录，请登录后再试', 'moveMail-imap')
        return
      }
      if (!ctx.isBoxOpen) {
        ctx.showToast('邮箱未打开，无法获取邮件列表', 'moveMail-imap')
        return
      }
      if (!ctx.listData || ctx.listData.length < 1) {
        ctx.showToast('当前邮箱中暂无可用的消息', 'moveMail---IMAP')
        return
      }
      let uid = ctx.listData[0].uid
      if (!uid || uid.length < 1) {
        ctx.showToast('当前邮箱中暂无可用的消息', 'moveMail---IMAP')
        return
      }
      if (!ctx.folderList || ctx.folderList.length < 1) {
        ctx.showToast('无可用的邮箱', 'moveMail---IMAP')
        return
      }
      let selectFoler = ''
      if (ctx.folderList) {
        let count = 0;
        for (let i = 0; i < ctx.folderList.length; i++) {
          if (ctx.folderList[i] && ctx.folderList[i].length > 0 && ctx.folderList[i] != ctx.folderName) {
            count++;
            selectFoler = ctx.folderList[i];
          }
        }
        if (count === 0) {
          ctx.showToast('无可用的邮箱', 'moveMail---IMAP')
          return
        }
      }
      ctx.showToast(`移动邮件开始，从主邮箱移动到 ${selectFoler}`, 'moveMail-imap')
      let startTime1 = new Date().getTime();
      globalThis.client.move(uid, selectFoler, (err, result) => {
        let endTime1 = new Date().getTime();
        let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
        console.log("IMAPClientTest : move averageTime : " + averageTime1 + "us")
        if (err) {
          ctx.showToast(`移动邮件失败,原因：${err.message}`, 'moveMail-imap')
        } else {
          ctx.showToast('移动邮件成功 ' + JSON.stringify(result), 'moveMail-imap')

          ctx.showToast(`移动邮件成功之后，请到主邮箱查看是否少了一封邮件，请到${selectFoler} 查看是否新增了一封邮件，然后点击 关闭邮箱 以及获取邮箱列表刷新数据以便进行其他操作 `, 'moveMail-imap')
        }
      });
    } catch (err) {
      ctx.showToast(`移动邮件出错：${err.message}`, 'moveMail-smtp')
    }
  }

  addFlag() {
    const ctx = this;
    try {
      ctx.message = ''
      if (!globalThis.client || !ctx.isLogin) {
        ctx.showToast('账号未登录，请登录后再试', 'addFlag-imap')
        return
      }
      if (!ctx.isBoxOpen) {
        ctx.showToast('邮箱未打开，无法获取邮件列表', 'addFlag-imap')
        return
      }
      if (!ctx.listData || ctx.listData.length < 1) {
        ctx.showToast('当前邮箱中暂无可用的消息', 'addFlag---IMAP')
        return
      }
      let uid = ctx.listData[0].uid
      if (!uid || uid.length < 1) {
        ctx.showToast('当前邮箱中暂无可用的消息', 'addFlag---IMAP')
        return
      }
      ctx.showToast('开始给邮件添加已读标记', 'addFlag-imap')
      let startTime1 = new Date().getTime();
      globalThis.client.addFlags(uid, '\\Seen', (err, result) => {
        let endTime1 = new Date().getTime();
        let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
        console.log("IMAPClientTest : addFlags averageTime : " + averageTime1 + "us")
        if (err) {
          ctx.showToast(`给邮件添加已读标记失败,原因：${err.message}`, 'addFlag-imap')
        } else {
          ctx.showToast('给邮件添加已读标记成功', 'addFlag-imap')
        }
      });

    } catch (err) {
      ctx.showToast(`给邮件添加已读标记出错：${err.message}`, 'storeMail-smtp')
    }
  }

  setFlag() {
    const ctx = this;
    try {
      ctx.message = ''
      if (!globalThis.client || !ctx.isLogin) {
        ctx.showToast('账号未登录，请登录后再试', 'setFlag-imap')
        return
      }
      if (!ctx.isBoxOpen) {
        ctx.showToast('邮箱未打开，无法获取邮件列表', 'setFlag-imap')
        return
      }
      if (!ctx.listData || ctx.listData.length < 1) {
        ctx.showToast('当前邮箱中暂无可用的消息', 'setFlag---IMAP')
        return
      }
      let uid = ctx.listData[0].uid
      if (!uid || uid.length < 1) {
        ctx.showToast('当前邮箱中暂无可用的消息', 'setFlag---IMAP')
        return
      }

      ctx.showToast('开始给邮件设置已读标记', 'setFlag-imap')
      let startTime1 = new Date().getTime();
      globalThis.client.setFlags(uid, '\\Seen', (err, result) => {
        let endTime1 = new Date().getTime();
        let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
        console.log("IMAPClientTest : setFlags averageTime : " + averageTime1 + "us")
        if (err) {
          ctx.showToast(`给邮件设置已读标记失败,原因：${err.message}`, 'setFlag-imap')
        } else {
          ctx.showToast('给邮件设置已读标记成功', 'setFlag-imap')
        }
      });
    } catch (err) {
      ctx.showToast(`给邮件设置已读标记出错：${err.message}`, 'setFlag-smtp')
    }
  }

  deleteFlag() {
    const ctx = this;
    try {
      ctx.message = ''
      if (!globalThis.client || !ctx.isLogin) {
        ctx.showToast('账号未登录，请登录后再试', 'deleteFlag-imap')
        return
      }
      if (!ctx.isBoxOpen) {
        ctx.showToast('邮箱未打开，无法获取邮件列表', 'deleteFlag-imap')
        return
      }
      if (!ctx.listData || ctx.listData.length < 1) {
        ctx.showToast('当前邮箱中暂无可用的消息', 'deleteFlag---IMAP')
        return
      }
      let uid = ctx.listData[0].uid
      if (!uid || uid.length < 1) {
        ctx.showToast('当前邮箱中暂无可用的消息', 'deleteFlag---IMAP')
        return
      }
      ctx.showToast('开始给邮件取消已读标记', 'deleteFlag-imap')
      let startTime1 = new Date().getTime();
      globalThis.client.delFlags(uid, '\\Seen', (err, result) => {
        let endTime1 = new Date().getTime();
        let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
        console.log("IMAPClientTest : delFlags averageTime : " + averageTime1 + "us")
        if (err) {
          ctx.showToast(`给邮件取消已读标记失败,原因：${err.message}`, 'deleteFlag-imap')
        } else {
          ctx.showToast('给邮件取消已读标记成功', 'deleteFlag-imap')
        }
      });

    } catch (err) {
      ctx.showToast(`给邮件取消已读标记出错：${err.message}`, 'deleteFlag-smtp')
    }
  }

  addKeywords() {
    const ctx = this;
    try {
      ctx.message = ''
      if (!globalThis.client || !ctx.isLogin) {
        ctx.showToast('账号未登录，请登录后再试', 'addKeywords-imap')
        return
      }
      if (!ctx.isBoxOpen) {
        ctx.showToast('邮箱未打开，无法获取邮件列表', 'addKeywords-imap')
        return
      }
      if (!ctx.listData || ctx.listData.length < 1) {
        ctx.showToast('当前邮箱中暂无可用的消息', 'addKeywords---IMAP')
        return
      }
      let uid = ctx.listData[0].uid
      if (!uid || uid.length < 1) {
        ctx.showToast('当前邮箱中暂无可用的消息', 'addKeywords---IMAP')
        return
      }
      ctx.showToast('开始给邮件添加关键字', 'addKeywords-imap')
      let startTime1 = new Date().getTime();
      globalThis.client.addKeywords(uid, '鸿蒙关键字', (err, result) => {
        let endTime1 = new Date().getTime();
        let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
        console.log("IMAPClientTest : addKeywords averageTime : " + averageTime1 + "us")
        if (err) {
          ctx.showToast(`给邮件添加关键字失败,原因：${err.message}`, 'addKeywords-imap')
        } else {
          ctx.showToast('给邮件添加关键字成功', 'addKeywords-imap')
        }
      });
    } catch (err) {
      ctx.showToast(`给邮件添加关键字出错：${err.message}`, 'addKeywords-smtp')
    }
  }

  setKeywords() {
    const ctx = this;
    try {
      ctx.message = ''
      if (!globalThis.client || !ctx.isLogin) {
        ctx.showToast('账号未登录，请登录后再试', 'setKeywords-imap')
        return
      }
      if (!ctx.isBoxOpen) {
        ctx.showToast('邮箱未打开，无法获取邮件列表', 'setKeywords-imap')
        return
      }
      if (!ctx.listData || ctx.listData.length < 1) {
        ctx.showToast('当前邮箱中暂无可用的消息', 'setKeywords---IMAP')
        return
      }
      let uid = ctx.listData[0].uid
      if (!uid || uid.length < 1) {
        ctx.showToast('当前邮箱中暂无可用的消息', 'setKeywords---IMAP')
        return
      }
      ctx.showToast('开始给邮件设置关键字', 'setKeywords-imap')
      let startTime1 = new Date().getTime();
      globalThis.client.setKeywords(uid, '鸿蒙关键字', (err, result) => {
        let endTime1 = new Date().getTime();
        let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
        console.log("IMAPClientTest : setKeywords averageTime : " + averageTime1 + "us")
        if (err) {
          ctx.showToast(`给邮件设置关键字失败,原因：${err.message}`, 'setKeywords-imap')
        } else {
          ctx.showToast('给邮件设置关键字成功', 'setKeywords-imap')
        }
      });
    } catch (err) {
      ctx.showToast(`给邮件设置关键字出错：${err.message}`, 'setKeywords-smtp')
    }
  }

  delKeywords() {
    const ctx = this;
    try {
      ctx.message = ''
      if (!globalThis.client || !ctx.isLogin) {
        ctx.showToast('账号未登录，请登录后再试', 'delKeywords-imap')
        return
      }
      if (!ctx.isBoxOpen) {
        ctx.showToast('邮箱未打开，无法获取邮件列表', 'delKeywords-imap')
        return
      }
      if (!ctx.listData || ctx.listData.length < 1) {
        ctx.showToast('当前邮箱中暂无可用的消息', 'delKeywords---IMAP')
        return
      }
      let uid = ctx.listData[0].uid
      if (!uid || uid.length < 1) {
        ctx.showToast('当前邮箱中暂无可用的消息', 'delKeywords---IMAP')
        return
      }
      ctx.showToast('开始给邮件删除关键字', 'delKeywords-imap')
      let startTime1 = new Date().getTime();
      globalThis.client.delKeywords(uid, '鸿蒙关键字', (err, result) => {
        let endTime1 = new Date().getTime();
        let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
        console.log("IMAPClientTest : delKeywords averageTime : " + averageTime1 + "us")
        if (err) {
          ctx.showToast(`给邮件删除关键字失败,原因：${err.message}`, 'delKeywords-imap')
        } else {
          ctx.showToast('给邮件删除关键字成功', 'delKeywords-imap')
        }
      });
    } catch (err) {
      ctx.showToast(`给邮件删除关键字出错：${err.message}`, 'delKeywords-smtp')
    }
  }

  getMsgDetail() {
    const ctx = this;
    try {
      ctx.message = ''
      if (!globalThis.client || !ctx.isLogin) {
        ctx.showToast('账号未登录，请登录后再试', 'getMsgDetail-imap')
        return
      }
      if (!ctx.isBoxOpen) {
        ctx.showToast('邮箱未打开，无法获取邮件列表', 'getMsgDetail-imap')
        return
      }
      if (!ctx.listData || ctx.listData.length < 1) {
        ctx.showToast('当前邮箱中暂无可用的消息', 'getMsgDetail---IMAP')
        return
      }
      ctx.showToast('开始获取整个邮件体', 'getMsgDetail-imap')
      let startTime1 = new Date().getTime();
      var f = globalThis.client.seq.fetch(`${1}`, {
        bodies: 'TEXT',
        struct: true
      });
      f.on('message', function (msg, seqno) {
        console.log('Message #%d', seqno);
        var prefix = '(#' + seqno + ') ';

        msg.on('body', function (stream, info) {
          var buffer = '';
          stream.on('data', function (chunk) {
            if (buffer.length <= 1000) {
              buffer += chunk.toString('utf8');
            }

          });
          stream.once('end', function () {
            let endTime1 = new Date().getTime();
            let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
            console.log("IMAPClientTest : fetch detail averageTime : " + averageTime1 + "us")
            try {
              ctx.showToast(`获取整个邮件体成功,为防止内容过多造成的卡死，只取前1000字符长度显示：${'\r\n'}${buffer}`, 'getMsgDetail-imap');

            } catch (err) {
              ctx.showToast(`获取整个邮件体失败：${err.message}`, 'getMsgDetail-smtp')
            }
          });
        });
        msg.once('attributes', function (attrs) {
          // console.log(prefix + 'Attributes: %s', inspect(attrs, false, 8));
        });
        msg.once('end', function () {
        });
      });
      f.once('error', function (err) {
        ctx.showToast(`获取整个邮件体失败：${err.message}`, 'getMsgDetail-smtp')
      });
      f.once('end', function () {
      });

    } catch (err) {
      ctx.showToast(`获取整个邮件体出错：${err.message}`, 'getMsgDetail-smtp')
    }
  }
}
