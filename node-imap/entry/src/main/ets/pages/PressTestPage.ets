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

@Entry
@Component
struct PressTestPage {
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

  build() {

    Flex({
      alignItems: ItemAlign.Start,
      justifyContent: FlexAlign.Start,
      alignContent: FlexAlign.Start,
      direction: FlexDirection.Column
    }) {

      Flex({ direction: FlexDirection.Row }) {
        Scroll() {
          Column() {
            Button('登录')
              .fontSize(14)
              .height(50)
              .width("100%")
              .margin(10)
              .onClick(() => {
                this.login()
              })
            Button('退出登录')
              .fontSize(14)
              .height(50)
              .width("100%")
              .margin(10)
              .onClick(() => {
                this.loginOut()
              })
            Button('检查服务器支持的能力')
              .fontSize(14)
              .height(50)
              .margin(10)
              .width("100%")
              .onClick(() => {
                this.checkServerCapability()
              })
            Button('获取邮箱里的文件夹列表')
              .fontSize(14)
              .height(50)
              .margin(10)
              .width("100%")
              .onClick(() => {
                this.getFolderList()
              })
            Button('添加新文件夹(名字暂定test)')
              .fontSize(14)
              .height(50)
              .margin(10)
              .width("100%")
              .onClick(() => {
                this.createFolder()
              })

            Button('删除新文件夹')
              .fontSize(14)
              .height(50)
              .margin(10)
              .width("100%")
              .onClick(() => {
                this.delFolder()
              })
            Button('重命名新文件夹')
              .fontSize(14)
              .height(50)
              .margin(10)
              .width("100%")
              .onClick(() => {
                this.renameFolder()
              })

            Button('获取订阅邮箱文件夹列表')
              .fontSize(14)
              .height(50)
              .margin(10)
              .width("100%")
              .onClick(() => {
                this.getSubFolderList()
              })
            Button('订阅邮箱文件夹')
              .fontSize(14)
              .height(50)
              .margin(10)
              .width("100%")
              .onClick(() => {
                this.subBox()
              })
            Button('取消订阅邮箱文件夹')
              .fontSize(14)
              .height(50)
              .margin(10)
              .width("100%")
              .onClick(() => {
                this.unSubBox()
              })
          }
          .width('100%')
          .height(2200)
        }
        .layoutWeight(1)

        Scroll() {
          Column() {

            Button('获取主邮箱列表')
              .fontSize(14)
              .height(50)
              .margin(10)
              .width("100%")
              .onClick(() => {
                this.openBoxAndGetStatu()
              })
            Button('获取某个邮件详情')
              .fontSize(14)
              .height(50)
              .margin(10)
              .width("100%")
              .onClick(() => {
                this.getMsgDetail()
              })
            Button('上传本地邮件到邮箱')
              .fontSize(14)
              .height(50)
              .margin(10)
              .width("100%")
              .onClick(() => {
                this.appendMail()
              })
            Button('关闭邮箱主文件夹')
              .fontSize(14)
              .height(50)
              .margin(10)
              .width("100%")
              .onClick(() => {
                this.closeBox()
              })
            Button('邮件排序')
              .fontSize(14)
              .height(50)
              .margin(10)
              .width("100%")
              .onClick(() => {
                this.sortMail()
              })
            Button('搜索邮件')
              .fontSize(14)
              .height(50)
              .margin(10)
              .width("100%")
              .onClick(() => {
                this.search()
              })
            Button('给邮件添加删除标记')
              .fontSize(14)
              .height(50)
              .margin(10)
              .width("100%")
              .onClick(() => {
                this.storeMail()
              })

            Button('复制邮件到其他文件夹')
              .fontSize(14)
              .height(50)
              .margin(10)
              .width("100%")
              .onClick(() => {
                this.copyMail()
              })
            Button('给邮件添加flag')
              .fontSize(14)
              .height(50)
              .margin(10)
              .width("100%")
              .onClick(() => {
                this.addFlag()
              })
            Button('给邮件设置flag')
              .fontSize(14)
              .height(50)
              .margin(10)
              .width("100%")
              .onClick(() => {
                this.setFlag()
              })
            Button('给邮件删除flag')
              .fontSize(14)
              .height(50)
              .margin(10)
              .width("100%")
              .onClick(() => {
                this.deleteFlag()
              })
            Button('给邮件添加keyword')
              .fontSize(14)
              .height(50)
              .margin(10)
              .width("100%")
              .onClick(() => {
                this.addKeywords()
              })
            Button('给邮件设置keyword')
              .fontSize(14)
              .height(50)
              .margin(10)
              .width("100%")
              .onClick(() => {
                this.setKeywords()
              })
            Button('给邮件删除keyword')
              .fontSize(14)
              .height(50)
              .margin(10)
              .width("100%")
              .onClick(() => {
                this.delKeywords()
              })

            Button('移动邮件到其他文件夹')
              .fontSize(14)
              .height(50)
              .margin(10)
              .width("100%")
              .onClick(() => {
                this.moveMail()
              })
          }
          .width('100%')
          .height(2200)
        }
        .layoutWeight(1)
      }
    }

  }

  async login() {
    const ctx = this;
    ctx.message = ''
    try {
      if (!globalThis.client) {
        if (ctx.secure) {
          globalThis.client = new Imap({
            user: ctx.account,
            password: ctx.password,
            host: 'imap.xxx.com',
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
            host: 'imap.xxx.com',
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
      if (globalThis.client) {
        await globalThis.client.connect();
      }
    } catch (err) {
    }
  }

  loginOut() {
    const ctx = this;
    try {
      if (globalThis.client) {
        globalThis.client.end(() => {
        });
        globalThis.client.destroy()
      }
      globalThis.client = undefined;
    } catch (err) {
    }
  }

  checkServerCapability() {
    this.message = ''
    if (!globalThis.client) {
      return
    }
    globalThis.client.serverSupports('IMAP4');
  }

  getFolderList() {
    const ctx = this;
    ctx.message = ''
    if (!globalThis.client) {
      return
    }
    globalThis.client.getBoxes(function (err, data) {
    })
  }

  createFolder() {
    const ctx = this;
    try {
      if (!globalThis.client) {
        return
      }
      globalThis.client.addBox('test', (err, result) => {
      });

    } catch (err) {
    }
  }

  delFolder() {
    const ctx = this;
    try {
      if (!globalThis.client) {
        return
      }
      globalThis.client.addBox('delFolder', (err, result) => {
      });

    } catch (err) {
    }
  }

  renameFolder() {
    const ctx = this;
    try {
      if (!globalThis.client) {
        return
      }
      globalThis.client.renameBox('renameFolder', 'newFolder', (err, result) => {
      });

    } catch (err) {
    }
  }

  subBox() {
    const ctx = this;
    try {
      ctx.message = ''
      if (!globalThis.client) {
        return
      }
      globalThis.client.subscribeBox('addFolder', (err, result) => {

      });
    } catch (err) {
    }
  }

  unSubBox() {
    const ctx = this;
    try {
      ctx.message = ''
      if (!globalThis.client) {
        return
      }
      globalThis.client.unsubscribeBox('unSubFolder', (err, result) => {
      });
    } catch (err) {
    }
  }

  getSubFolderList() {
    const ctx = this;
    try {
      ctx.message = ''
      if (!globalThis.client) {
        return
      }
      globalThis.client.getSubscribedBoxes((err, result) => {
      });
    } catch (err) {
    }
  }

  openBoxAndGetStatu() {
    const ctx = this;
    try {
      ctx.message = ''
      if (!globalThis.client) {
        return
      }
      globalThis.client.status(ctx.folderName, function (err, data) {
      })
    } catch (err) {
      throw err
    }
  }

  getListData() {
    const ctx = this;
    try {
      if (!globalThis.client) {
        return
      }
      var f = globalThis.client.seq.fetch(`${ctx.startIndex}:${ctx.endIndex}`, {
        bodies: 'HEADER.FIELDS (FROM TO SUBJECT DATE)',
        struct: true
      });
      f.on('message', function (msg, seqno) {
        var prefix = '(#' + seqno + ') ';
        msg.on('body', function (stream, info) {

          stream.on('data', function (chunk) {
          });
          stream.once('end', function () {

          });
        });
        msg.once('attributes', function (attrs) {

        });
        msg.once('end', function () {
          console.log(prefix + 'Finished');
        });
      });
      f.on('error', function (err) {

      });
      f.once('end', function () {
        console.log('Done fetching all messages!');
      });
    } catch (err) {
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
      if (!globalThis.client) {
        return
      }
      let data = ctx.createMailData();
      let option = {
        mailbox: 'INBOX',
        flag: ['Seen'], //取值 Seen flagged等
        date: new Date(), //取值 Seen flagged等

      }
      globalThis.client.append(data, option, (err, result) => {

      });
    } catch (err) {
    }
  }

  closeBox() {
    const ctx = this;
    try {
      ctx.message = ''
      if (!globalThis.client) {
        return
      }

      globalThis.client.closeBox((err, result) => {
      });
    } catch (err) {
    }
  }

  sortMail() {
    const ctx = this;
    try {
      ctx.message = ''
      if (!globalThis.client) {
        return
      }
      globalThis.client.sort(['DATE'], ['ALL'], (err, result) => {
      });

    } catch (err) {
    }
  }

  search() {
    const ctx = this;
    try {
      ctx.message = ''
      if (!globalThis.client) {
        return
      }
      globalThis.client.search(['RECENT'], (err, result) => {

      });
    } catch (err) {
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
    if (!globalThis.client) {
      return
    }
    ctx.addDeleteFlag('1')
  }

  addDeleteFlag(uid: string) {
    const ctx = this;
    try {
      globalThis.client.addFlags(uid, '\\Deleted', (err, result) => {
      });

    } catch (err) {
    }
  }

  expungeMail(uid: string) {
    const ctx = this;
    try {
      globalThis.client.expunge(uid, (err, result) => {
      });
    } catch (err) {
    }
  }

  copyMail() {
    const ctx = this;
    try {
      ctx.message = ''
      if (!globalThis.client) {
        return
      }
      globalThis.client.copy('1', 'selectFoler', (err, result) => {
      });

    } catch (err) {
    }
  }

  moveMail() {
    const ctx = this;
    try {
      ctx.message = ''
      if (!globalThis.client) {
        return
      }
      globalThis.client.move('1', 'selectFoler', (err, result) => {

      });
    } catch (err) {
    }
  }

  addFlag() {
    const ctx = this;
    try {
      ctx.message = ''
      if (!globalThis.client) {
        return
      }
      globalThis.client.addFlags('1', '\\Seen', (err, result) => {
      });

    } catch (err) {
    }
  }

  setFlag() {
    const ctx = this;
    try {
      ctx.message = ''
      if (!globalThis.client) {
        return
      }
      globalThis.client.setFlags('1', '\\Seen', (err, result) => {

      });
    } catch (err) {
    }
  }

  deleteFlag() {
    const ctx = this;
    try {
      ctx.message = ''
      if (!globalThis.client) {
        return

        globalThis.client.delFlags('1', '\\Seen', (err, result) => {

        });
      }
    } catch (err) {
    }
  }

  addKeywords() {
    const ctx = this;
    try {
      ctx.message = ''
      if (!globalThis.client ) {
        return
      }
      globalThis.client.addKeywords('1', '鸿蒙关键字', (err, result) => {

      });
    } catch (err) {
    }
  }

  setKeywords() {
    const ctx = this;
    try {
      ctx.message = ''
      if (!globalThis.client) {
        return
      }
      globalThis.client.setKeywords('1', '鸿蒙关键字', (err, result) => {

      });
    } catch (err) {
    }
  }

  delKeywords() {
    const ctx = this;
    try {
      ctx.message = ''
      if (!globalThis.client ) {
        return
      }
      globalThis.client.delKeywords('1', '鸿蒙关键字', (err, result) => {

      });
    } catch (err) {
    }
  }

  getMsgDetail() {
    const ctx = this;
    try {
      ctx.message = ''
      if (!globalThis.client ) {
        return
      }

      var f = globalThis.client.seq.fetch(`${1}`, {
        bodies: 'TEXT',
        struct: true
      });
      f.on('message', function (msg, seqno) {


        msg.on('body', function (stream, info) {
          var buffer = '';
          stream.on('data', function (chunk) {

          });
          stream.once('end', function () {
          });
        });
        msg.once('attributes', function (attrs) {
          // console.log(prefix + 'Attributes: %s', inspect(attrs, false, 8));
        });
        msg.once('end', function () {
        });
      });
      f.once('error', function (err) {
      });
      f.once('end', function () {
      });

    } catch (err) {
    }
  }
}