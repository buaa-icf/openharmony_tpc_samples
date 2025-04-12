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
import Imap, { inspect } from '@ohos/node-imap'
import socket from '@ohos.net.socket'
import StatusBean from '../bean/StatusBean'
import MsgListBean, { MsgListFootBean, MsgListHeadBean } from '../bean/MsgListBean'
import Box from '../bean/Box'
import TestInterfaceUtil from '../TestInterfaceUtil'
import GlobalObj from '../GlobalObj'
import LoginOption from '../bean/LoginOption'
import MailBoxes from '../bean/MailBoxes'
import DetailCallback from '../bean/DetailCallback'
import MsgSendBean from '../bean/MsgSendBean'
import AppendOptions from '../bean/AppendOptions'
import { ImapMessageAttributes } from '../bean/ImapMessage'
import { DEMO_CONFIG } from '../common/Common'

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
  @State bean: Box | null = null //获取邮件列表之前先获取该文件夹里面的邮件总数和状态
  @State uidList: Array<string> = [] //邮件uid列表
  @State subFolderList: Array<string> = [] //邮件列表数据集合
  @State folderList: Array<string> = [] //邮件列表数据集合
  @State listData: Array<MsgListBean> = [] //邮件列表数据集合
  @State account: string = DEMO_CONFIG.user;
  @State password: string = DEMO_CONFIG.password;
  private util: TestInterfaceUtil = new TestInterfaceUtil();
  pageSize: number = 10 //请求时的每页多少条信息，用于分页请求
  folderName: string = 'INBOX'
  private option: socket.TLSConnectOptions = {
    ALPNProtocols: ["spdy/1", "http/1.1"],
    address: {
      address: 'imap.139.com',
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
        Text($r('app.string.account_number'))
          .fontSize(20)
          .height(50)
          .textAlign(TextAlign.Center)
          .margin({ right: 5 })

        TextInput({ placeholder: $r('app.string.Please_enter_your_account'), text: this.account })
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
        Text($r('app.string.Password_Authorization_Code'))
          .fontSize(20)
          .height(50)
          .textAlign(TextAlign.Center)
          .margin({ right: 5 })

        TextInput({ placeholder: $r('app.string.Please_enter_password_authorization_code'), text: this.password })
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
            Button($r('app.string.login'))
              .fontSize(14)
              .height(50)
              .visibility(this.isLogin ? Visibility.None : Visibility.Visible)
              .width("100%")
              .margin({ top: 100, left: 10, right: 10 })
              .onClick(() => {
                this.login()
              })
            Button($r('app.string.Log_out'))
              .fontSize(14)
              .height(50)
              .visibility(this.isLogin ? Visibility.Visible : Visibility.None)
              .width("100%")
              .margin(10)
              .onClick(() => {
                this.loginOut()
              })
            Button($r('app.string.Check_the_capability_of_the_server'))
              .fontSize(14)
              .height(50)
              .margin(10)
              .visibility(this.isLogin ? Visibility.Visible : Visibility.None)
              .width("100%")
              .onClick(() => {
                this.checkServerCapability()
              })
            Button($r('app.string.Retrieve_the_folder_list_from_the_email'))
              .fontSize(14)
              .height(50)
              .margin(10)
              .visibility(this.isLogin ? Visibility.Visible : Visibility.None)
              .width("100%")
              .onClick(() => {
                this.getFolderList()
              })
            Button($r('app.string.Add_a_new_folder_tentatively_named_test'))
              .fontSize(14)
              .height(50)
              .margin(10)
              .visibility(this.isLogin ? Visibility.Visible : Visibility.None)
              .width("100%")
              .onClick(() => {
                this.createFolder()
              })

            Button($r('app.string.Delete_new_folder'))
              .fontSize(14)
              .height(50)
              .margin(10)
              .visibility(this.isLogin ? Visibility.Visible : Visibility.None)
              .width("100%")
              .onClick(() => {
                this.delFolder()
              })
            Button($r('app.string.Rename_new_folder'))
              .fontSize(14)
              .height(50)
              .margin(10)
              .visibility(this.isLogin ? Visibility.Visible : Visibility.None)
              .width("100%")
              .onClick(() => {
                this.renameFolder()
              })
            Button($r('app.string.Get_the_list_of_subscribed_email_folders'))
              .fontSize(14)
              .height(50)
              .margin(10)
              .visibility(this.isLogin ? Visibility.Visible : Visibility.None)
              .width("100%")
              .onClick(() => {
                this.getSubFolderList()
              })
            Button($r('app.string.Subscription_email_folder'))
              .fontSize(14)
              .height(50)
              .margin(10)
              .visibility(this.isLogin ? Visibility.Visible : Visibility.None)
              .width("100%")
              .onClick(() => {
                this.subBox()
              })
            Button($r('app.string.Unsubscribe_from_email_folder'))
              .fontSize(14)
              .height(50)
              .margin(10)
              .visibility(this.isLogin ? Visibility.Visible : Visibility.None)
              .width("100%")
              .onClick(() => {
                this.unSubBox()
              })
            Button($r('app.string.Get_the_main_email_list'))
              .fontSize(14)
              .height(50)
              .margin(10)
              .visibility(this.isLogin && !this.isBoxOpen ? Visibility.Visible : Visibility.None)
              .width("100%")
              .onClick(() => {
                this.openBoxAndGetStatu()
              })
            Button($r('app.string.Get_the_details_of_a_certain_email'))
              .fontSize(14)
              .height(50)
              .margin(10)
              .visibility(this.isLogin && this.isBoxOpen ? Visibility.Visible : Visibility.None)
              .width("100%")
              .onClick(() => {
                this.getMsgDetail()
              })
            Button($r('app.string.Upload_local_email_to_mailbox'))
              .fontSize(14)
              .height(50)
              .margin(10)
              .visibility(this.isLogin && this.isBoxOpen ? Visibility.Visible : Visibility.None)
              .width("100%")
              .onClick(() => {
                this.appendMail()
              })
            Button($r('app.string.Close_the_email_home_folder'))
              .fontSize(14)
              .height(50)
              .margin(10)
              .visibility(this.isLogin && this.isBoxOpen ? Visibility.Visible : Visibility.None)
              .width("100%")
              .onClick(() => {
                this.closeBox()
              })
            Button($r('app.string.Email_sorting'))
              .fontSize(14)
              .height(50)
              .margin(10)
              .visibility(this.isLogin && this.isBoxOpen ? Visibility.Visible : Visibility.None)
              .width("100%")
              .onClick(() => {
                this.sortMail()
              })
            Button($r('app.string.search_mail'))
              .fontSize(14)
              .height(50)
              .margin(10)
              .visibility(this.isLogin && this.isBoxOpen ? Visibility.Visible : Visibility.None)
              .width("100%")
              .onClick(() => {
                this.search()
              })
            Button($r('app.string.Add_a_delete_mark_to_the_email'))
              .fontSize(14)
              .height(50)
              .margin(10)
              .visibility(this.isLogin && this.isBoxOpen ? Visibility.Visible : Visibility.None)
              .width("100%")
              .onClick(() => {
                this.storeMail()
              })

            Button($r('app.string.Copy_emails_to_other_folders'))
              .fontSize(14)
              .height(50)
              .margin(10)
              .visibility(this.isLogin && this.isBoxOpen ? Visibility.Visible : Visibility.None)
              .width("100%")
              .onClick(() => {
                this.copyMail()
              })
            Button($r('app.string.Add_a_flag_to_the_email'))
              .fontSize(14)
              .height(50)
              .margin(10)
              .visibility(this.isLogin && this.isBoxOpen ? Visibility.Visible : Visibility.None)
              .width("100%")
              .onClick(() => {
                this.addFlag()
              })
            Button($r('app.string.Set_flag_for_email'))
              .fontSize(14)
              .height(50)
              .margin(10)
              .visibility(this.isLogin && this.isBoxOpen ? Visibility.Visible : Visibility.None)
              .width("100%")
              .onClick(() => {
                this.setFlag()
              })
            Button($r('app.string.Remove_flag_from_email'))
              .fontSize(14)
              .height(50)
              .margin(10)
              .visibility(this.isLogin && this.isBoxOpen ? Visibility.Visible : Visibility.None)
              .width("100%")
              .onClick(() => {
                this.deleteFlag()
              })
            Button($r('app.string.Add_a_keyword_to_the_email'))
              .fontSize(14)
              .height(50)
              .margin(10)
              .visibility(this.isLogin && this.isBoxOpen ? Visibility.Visible : Visibility.None)
              .width("100%")
              .onClick(() => {
                this.addKeywords()
              })
            Button($r('app.string.Set_the_keyword_for_the_email'))
              .fontSize(14)
              .height(50)
              .margin(10)
              .visibility(this.isLogin && this.isBoxOpen ? Visibility.Visible : Visibility.None)
              .width("100%")
              .onClick(() => {
                this.setKeywords()
              })
            Button($r('app.string.Delete_the_keyword_from_the_email'))
              .fontSize(14)
              .height(50)
              .margin(10)
              .visibility(this.isLogin && this.isBoxOpen ? Visibility.Visible : Visibility.None)
              .width("100%")
              .onClick(() => {
                this.delKeywords()
              })
            Button($r('app.string.Move_emails_to_other_folders'))
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
      ctx.showToast(this.getResourceString('Start_logging_in_to_your_account'), 'login-imap')
      let hostParam = ctx.account.substring(ctx.account.indexOf('@') + 1, ctx.account.indexOf('.'))
      let mailType = ctx.account.substring(ctx.account.indexOf('@') + 1, ctx.account.length)
      let loginOption: LoginOption = new LoginOption();
      if (!GlobalObj?.getInstance()?.getClient()) {
        if (ctx.secure) {
          let context: Context | null = GlobalObj?.getInstance()?.getContext() ? GlobalObj?.getInstance()?.getContext() : getContext()
          if (!context) {
            return;
          }
          let ca0Data = await context?.resourceManager?.getRawFileContent('QQMailMiddle.pem')
          if (!ca0Data) {
            return;
          }
          let ca0 = '';
          for (let i = 0; i < ca0Data.length; i++) {
            let todo = ca0Data[i]
            let item = String.fromCharCode(todo);
            ca0 += item;
          }
          if (ctx.option.secureOptions.ca instanceof Array) {
            ctx.option.secureOptions.ca[0] = ca0;
          } else {
            ctx.option.secureOptions.ca = ca0;
          }
          let ca1Data = await context.resourceManager.getRawFileContent('QQMailRoot.pem')
          let ca1 = '';
          for (let i = 0; i < ca1Data.length; i++) {
            let todo = ca1Data[i]
            let item = String.fromCharCode(todo);
            ca1 += item;
          }
          if (ctx.option.secureOptions.ca instanceof Array) {
            ctx.option.secureOptions.ca[1] = ca1;
          } else {
            ctx.option.secureOptions.ca = ca1;
          }

          ctx.option.address.address = `imap.${hostParam}.com`;
          ctx.option.address.port = 993;

          loginOption.account = ctx.account;
          loginOption.password = ctx.password;
          loginOption.mailType = mailType;
          loginOption.hostParam = hostParam;
          loginOption.tlsOption = ctx.option;
          loginOption.secure = ctx.secure;
        } else {
          loginOption.account = ctx.account;
          loginOption.password = ctx.password;
          loginOption.mailType = mailType;
          loginOption.hostParam = hostParam;
          loginOption.tlsOption = null;
          loginOption.secure = ctx.secure;
        }
      }
      this?.util?.login(loginOption, () => {
        ctx.isLogin = true;
        ctx.showToast(this.getResourceString('ready_to_jump_to_the_email_folder_list'), 'login-imap')
        // GlobalObj?.getInstance()?.getClient()?._doKeepaliveTimer(true) //登陆成功之后通过noop命令不断的轮训服务器 防止断开连接 原库已封装了该命令不断调用 无需用户手动调用
      }, (err: Error) => {
        console.log(err.message);
      }, () => {
        console.log('Connection ended');
      })
    } catch (err) {
      ctx.showToast(this.getResourceString('Account_login_error') + `：${err.message}`, 'login-smtp')
    }
  }

  loginOut() {
    const ctx = this;
    ctx.message = ''
    try {
      ctx.showToast(this.getResourceString('Starting_to_log_out'), 'loginOut-imap')
      if (GlobalObj?.getInstance()?.getClient()) {
        let startTime1 = new Date().getTime();
        GlobalObj?.getInstance()?.getClient()?.end();
        let endTime1 = new Date().getTime();
        let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
        console.log("IMAPClientTest : end averageTime : " + averageTime1 + "us")
        ctx.showToast(this.getResourceString('Login_successfully_logged_out'), 'loginOut-imap')
        let startTime2 = new Date().getTime();
        GlobalObj?.getInstance()?.getClient()?.destroy()
        let endTime2 = new Date().getTime();
        let averageTime2 = ((endTime2 - startTime2) * 1000) / BASE_COUNT;
        console.log("IMAPClientTest : destroy averageTime : " + averageTime2 + "us")
        GlobalObj?.getInstance()?.setClient(null);
        ctx.isLogin = false;
      } else {
        ctx.showToast(this.getResourceString('Login_failed_client_object_is_empty'), 'loginOut-imap')
        ctx.isLogin = false;
      }
    } catch (err) {
      ctx.showToast(this.getResourceString('Login_error_occurred_while_logging_out') + `：${err.message}`, 'loginOut-smtp')
    }
  }

  checkServerCapability() {
    this.message = ''
    if (!GlobalObj?.getInstance()?.getClient() || !this.isLogin) {
      this.showToast(this.getResourceString('Error_checking_server_capability'), 'checkServerCapability-smtp')
      return
    }

    let startTime1 = new Date().getTime();
    let checkResult: boolean = GlobalObj?.getInstance()?.getClient()?.serverSupports('IMAP4REV1') ? GlobalObj?.getInstance()?.getClient()?.serverSupports('IMAP4REV1') : false;
    let endTime1 = new Date().getTime();
    let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
    console.log("IMAPClientTest : serverSupports averageTime : " + averageTime1 + "us")
    this.showToast(`服务端能力是否支持-${'IMAP4'},结果是：${checkResult}`, 'checkServerCapability-smtp')
  }

  getFolderList() {
    const ctx = this;
    ctx.message = ''
    if (!GlobalObj?.getInstance()?.getClient() || !ctx.isLogin) {
      ctx.showToast(this.getResourceString('Account_not_logged_in_please_login_and_try_again'), 'getFolderList-imap')
      return
    }
    ctx.showToast(this.getResourceString('Starting_from_obtaining_the_folder_list_in_the_email'), 'getFolderList-imap')
    let startTime1 = new Date().getTime();
    GlobalObj?.getInstance()?.getClient()?.getBoxes((err: Error, data: MailBoxes) => {
      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
      console.log("IMAPClientTest : getBoxes averageTime : " + averageTime1 + "us")
      if (err) {
        ctx.showToast(this.getResourceString('Error_retrieving_folder_list_from_email_data_is') + `：${err.message}`, 'getFolderList-imap')
        return
      }
      if (!data || typeof data != 'object') {
        ctx.showToast(this.getResourceString('Error_retrieving_folder_list_from_email') + `, get box status fail`, 'getFolderList-imap')
        return
      }
      ctx.folderList = [];
      let keyArr = Object.getOwnPropertyNames(data);
      for (let i = 0; i < keyArr.length; i++) {
        ctx.folderList.push(keyArr[i])
      }
      ctx.showToast(this.getResourceString('Successfully_obtained_the_folder_list_from_the_email') + `：${JSON.stringify(ctx.folderList)}`, 'getFolderList-imap')
    })
  }

  createFolder() {
    const ctx = this;
    try {
      ctx.message = ''
      if (!GlobalObj?.getInstance()?.getClient() || !ctx.isLogin) {
        ctx.showToast(this.getResourceString('Account_not_logged_in_please_login_and_try_again'), 'createFolder-imap')
        return
      }
      ctx.showToast(this.getResourceString('Start_creating_folder'), 'createFolder-imap')
      let startTime1 = new Date().getTime();
      let addName = 'addFolder' + new Date().getTime();
      GlobalObj?.getInstance()?.getClient()?.addBox(addName, (err: Error) => {
        let endTime1 = new Date().getTime();
        let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
        console.log("IMAPClientTest : addBox averageTime : " + averageTime1 + "us")
        if (err) {
          ctx.showToast(this.getResourceString('Failed_to_create_folder_reason') + `：${err.message}`, 'createFolder-imap')
        } else {
          ctx.showToast(this.getResourceString('Folder_created_successfully'), 'createFolder-imap')
          ctx.showToast(this.getResourceString('Starting_from_obtaining_the_folder_list_in_the_email'), 'getFolderList-imap')
          GlobalObj?.getInstance()?.getClient()?.getBoxes((err: Error, data: MailBoxes) => {
            if (err) {
              ctx.showToast(this.getResourceString('Error_retrieving_folder_list_from_email_data_is') + `：${err.message}`, 'getFolderList-imap')
              return
            }
            ;
            if (!data || typeof data != 'object') {
              ctx.showToast(this.getResourceString('Error_retrieving_folder_list_from_email') + `，get box status fail`, 'getFolderList-imap')
              return
            }
            ctx.folderList = [];
            let keyArr = Object.getOwnPropertyNames(data);
            for (let i = 0; i < keyArr.length; i++) {
              ctx.folderList.push(keyArr[i])
            }
            ctx.showToast(this.getResourceString('Successfully_obtained_the_folder_list_from_the_email') + `：${JSON.stringify(ctx.folderList)}`, 'getFolderList-imap')
          })
        }
      }
      );
    }
    catch (err) {
      ctx.showToast(this.getResourceString('Account_login_error') + `：${err.message}`, 'createFolder-smtp')
    }
  }

  delFolder() {
    const ctx = this;
    try {
      ctx.message = ''
      if (!GlobalObj?.getInstance()?.getClient() || !ctx.isLogin) {
        ctx.showToast(this.getResourceString('Account_not_logged_in_please_login_and_try_again'), 'delFolder-imap')
        return
      }
      let folderName = 'delFolder' + new Date().getTime();
      GlobalObj?.getInstance()?.getClient()?.addBox(folderName, (err: Error) => {
        if (err) {
          ctx.showToast(this.getResourceString('Failed_to_create_folder_for_deletion_reason') + `：${err.message}`, 'delFolder-imap')
        } else {
          ctx.showToast(this.getResourceString('Successfully_created_folder_for_deletion'), 'delFolder-imap')
          ctx.showToast(this.getResourceString('Starting_from_obtaining_the_folder_list_in_the_email'), 'delFolder-imap')
          GlobalObj?.getInstance()?.getClient()?.getBoxes((err: Error, data: MailBoxes) => {
            if (err) {
              ctx.showToast(this.getResourceString('Error_retrieving_folder_list_from_email_data_is') + `：${err.message}`, 'delFolder-imap')
              return
            }
            ;
            if (!data || typeof data != 'object') {
              ctx.showToast(this.getResourceString('Error_retrieving_folder_list_from_email') + `, get box status fail`, 'delFolder-imap')
              return
            }
            ctx.folderList = [];
            let keyArr = Object.getOwnPropertyNames(data);
            for (let i = 0; i < keyArr.length; i++) {
              ctx.folderList.push(keyArr[i])
            }
            ctx.showToast(this.getResourceString('Successfully_obtained_the_folder_list_from_the_email') + `：${JSON.stringify(ctx.folderList)}`, 'delFolder-imap')
            ctx.showToast(this.getResourceString('Start_deleting_folder') + '：delFolder', 'deleteFolder-imap')
            let startTime1 = new Date().getTime();
            GlobalObj?.getInstance()?.getClient()?.delBox(folderName, (err: Error) => {
              let endTime1 = new Date().getTime();
              let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
              console.log("IMAPClientTest : delBox averageTime : " + averageTime1 + "us")
              if (err) {
                ctx.showToast(this.getResourceString('Failed_to_delete_folder'), 'delFolder-imap')
              } else {
                ctx.showToast(this.getResourceString('Folder_deleted_successfully'), 'delFolder-imap')
                ctx.showToast(this.getResourceString('Starting_from_obtaining_the_folder_list_in_the_email'), 'getFolderList-imap')
                GlobalObj?.getInstance()?.getClient()?.getBoxes((err: Error, data: MailBoxes) => {
                  if (err) {
                    ctx.showToast(this.getResourceString('Error_retrieving_folder_list_from_email_data_is') + `：${err.message}`, 'getFolderList-imap')
                    return
                  }
                  if (!data || typeof data != 'object') {
                    ctx.showToast(this.getResourceString('Error_retrieving_folder_list_from_email') + `, get box status fail`, 'getFolderList-imap')
                    return
                  }
                  ctx.folderList = [];
                  let keyArr = Object.getOwnPropertyNames(data);
                  for (let i = 0; i < keyArr.length; i++) {
                    ctx.folderList.push(keyArr[i])
                  }
                  ctx.showToast(this.getResourceString('Successfully_obtained_the_folder_list_from_the_email') + `：${JSON.stringify(ctx.folderList)}`, 'getFolderList-imap')
                })
              }
            });
          })
        }
      });

    } catch (err) {
      ctx.showToast(this.getResourceString('Account_login_error') + `：${err.message}`, 'createFolder-smtp')
    }
  }

  renameFolder() {
    const ctx = this;
    try {
      ctx.message = ''
      if (!GlobalObj?.getInstance()?.getClient() || !ctx.isLogin) {
        ctx.showToast(this.getResourceString('Account_not_logged_in_please_login_and_try_again'), 'renameFolder-imap')
        return
      }
      let renameName = 'renameFolder' + new Date().getTime();
      GlobalObj?.getInstance()?.getClient()?.addBox(renameName, (err: Error) => {
        if (err) {
          ctx.showToast(this.getResourceString('Failed_to_create_folder_for_deletion_reason') + `：${err.message}`, 'renameFolder-imap')
        } else {
          ctx.showToast(this.getResourceString('Successfully_created_folder_for_deletion'), 'renameFolder-imap')
          ctx.showToast(this.getResourceString('Starting_from_obtaining_the_folder_list_in_the_email'), 'renameFolder-imap')
          GlobalObj?.getInstance()?.getClient()?.getBoxes((err: Error, data: MailBoxes) => {
            if (err) {
              ctx.showToast(this.getResourceString('Error_retrieving_folder_list_from_email_data_is') + `：${err.message}`, 'renameFolder-imap')
              return
            }
            if (!data || typeof data != 'object') {
              ctx.showToast(this.getResourceString('Error_retrieving_folder_list_from_email') + `, get box status fail`, 'renameFolder-imap')
              return
            }
            ctx.folderList = [];
            let keyArr = Object.getOwnPropertyNames(data);
            for (let i = 0; i < keyArr.length; i++) {
              ctx.folderList.push(keyArr[i])
            }
            ctx.showToast(this.getResourceString('Successfully_obtained_the_folder_list_from_the_email') + `：${JSON.stringify(ctx.folderList)}`, 'renameFolder-imap')
            ctx.showToast(this.getResourceString('Start_renaming_folder'), 'renameFolder-imap')
            let startTime1 = new Date().getTime();
            GlobalObj?.getInstance()?.getClient()?.renameBox(renameName, 'newFolder', (err: Error, result: MailBoxes) => {
              let endTime1 = new Date().getTime();
              let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
              console.log("IMAPClientTest : renameBox averageTime : " + averageTime1 + "us")
              if (err) {
                ctx.showToast(this.getResourceString('Renaming_folder_failed_reason') + `：${err.message}`, 'renameFolder-imap')
              } else {
                ctx.showToast(this.getResourceString('Renaming_folder_successfully'), 'renameFolder-imap')
                ctx.showToast(this.getResourceString('Starting_from_obtaining_the_folder_list_in_the_email'), 'getFolderList-imap')
                GlobalObj?.getInstance()?.getClient()?.getBoxes((err: Error, data: MailBoxes) => {
                  if (err) {
                    ctx.showToast(this.getResourceString('Error_retrieving_folder_list_from_email_data_is') + `：${err.message}`, 'getFolderList-imap')
                    return
                  }
                  ;
                  if (!data || typeof data != 'object') {
                    ctx.showToast(this.getResourceString('Error_retrieving_folder_list_from_email') + `, get box status fail`, 'getFolderList-imap')
                    return
                  }
                  ctx.folderList = [];
                  let keyArr = Object.getOwnPropertyNames(data);
                  for (let i = 0; i < keyArr.length; i++) {
                    ctx.folderList.push(keyArr[i])
                  }
                  ctx.showToast(this.getResourceString('Successfully_obtained_the_folder_list_from_the_email') + `：${JSON.stringify(ctx.folderList)}`, 'getFolderList-imap')
                })
              }
            });
          })
        }
      });

    } catch (err) {
      ctx.showToast(this.getResourceString('Account_login_error') + `：${err.message}`, 'renameFolder-smtp')
    }
  }

  subBox() {
    const ctx = this;
    try {
      ctx.message = ''
      if (!GlobalObj?.getInstance()?.getClient() || !ctx.isLogin) {
        ctx.showToast(this.getResourceString('Account_not_logged_in_please_login_and_try_again'), 'subBox-imap')
        return
      }
      ctx.showToast(this.getResourceString('Start_obtaining_the_subscribed_folder'), 'subBox-imap')
      GlobalObj?.getInstance()?.getClient()?.getSubscribedBoxes((err: Error, data: MailBoxes) => {
        if (err) {
          ctx.showToast(this.getResourceString('Failed_to_retrieve_the_subscribed_folder_reason') + `：${err.message}`, 'subBox-imap')
        } else {

          if (!data || typeof data != 'object') {
            ctx.showToast(this.getResourceString('Error_retrieving_folder_list_from_email') + `, get box status fail`, 'subBox-imap')
            return
          }
          ctx.subFolderList = [];
          let keyArr = Object.getOwnPropertyNames(data);
          for (let i = 0; i < keyArr.length; i++) {
            ctx.subFolderList.push(keyArr[i])
          }
          ctx.showToast(this.getResourceString('Successfully_obtained_the_subscribed_folder_the_data_is') + `：${JSON.stringify(ctx.subFolderList)}`, 'subBox-imap')
          ctx.showToast(this.getResourceString('Start_creating_folder'), 'subBox-imap')
          let subName = 'subFolder' + new Date().getTime();
          GlobalObj?.getInstance()?.getClient()?.addBox(subName, (err: Error) => {
            if (err) {
              ctx.showToast(this.getResourceString('Failed_to_create_folder_reason') + `：${err.message}`, 'subBox-imap')
            } else {
              ctx.showToast(this.getResourceString('Folder_created_successfully'), 'subBox-imap')
              ctx.showToast(this.getResourceString('Subscribe_to_addFolder_folder'), 'subBox-imap')
              let startTime1 = new Date().getTime();
              GlobalObj?.getInstance()?.getClient()?.subscribeBox(subName, (err: Error) => {
                let endTime1 = new Date().getTime();
                let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
                console.log("IMAPClientTest : subscribeBox averageTime : " + averageTime1 + "us")

                if (err) {
                  ctx.showToast(this.getResourceString('Subscription_email_failed_reason') + `：${err.message}`, 'subBox-imap')
                } else {
                  ctx.showToast(this.getResourceString('Subscription_email_successful'), 'subBox-imap')
                  ctx.showToast(this.getResourceString('Start_obtaining_the_subscribed_folder'), 'subBox-imap')
                  GlobalObj?.getInstance()?.getClient()?.getSubscribedBoxes((err: Error, data: MailBoxes) => {
                    if (err) {
                      ctx.showToast(this.getResourceString('Failed_to_retrieve_the_subscribed_folder_reason') + `：${err.message}`, 'subBox-imap')
                    } else {
                      if (!data || typeof data != 'object') {
                        ctx.showToast(this.getResourceString('Error_retrieving_folder_list_from_email') + `, get box status fail`, 'subBox-imap')
                        return
                      }
                      ctx.subFolderList = [];
                      let keyArr = Object.getOwnPropertyNames(data);
                      for (let i = 0; i < keyArr.length; i++) {
                        ctx.subFolderList.push(keyArr[i])
                      }
                      ctx.showToast(this.getResourceString('Successfully_obtained_the_subscribed_folder_the_data_is') + `：${JSON.stringify(ctx.subFolderList)}`, 'subBox-imap')
                    }
                  });
                }
              });
            }
          });
        }
      });
    } catch (err) {
      ctx.showToast(this.getResourceString('Subscription_email_error') + `：${err.message}`, 'subBox-smtp')
    }
  }

  unSubBox() {
    const ctx = this;
    try {
      ctx.message = ''
      if (!GlobalObj?.getInstance()?.getClient() || !ctx.isLogin) {
        ctx.showToast(this.getResourceString('Account_not_logged_in_please_login_and_try_again'), 'unSubBox-imap')
        return
      }
      ctx.showToast(this.getResourceString('Start_obtaining_the_subscribed_folder'), 'unSubBox-imap')
      GlobalObj?.getInstance()?.getClient()?.getSubscribedBoxes((err: Error, data: MailBoxes) => {
        if (err) {
          ctx.showToast(this.getResourceString('Failed_to_retrieve_the_subscribed_folder_reason') + `：${err.message}`, 'unSubBox-imap')
        } else {
          if (!data || typeof data != 'object') {
            ctx.showToast(this.getResourceString('Error_retrieving_folder_list_from_email') + `, get box status fail`, 'subBox-imap')
            return
          }
          ctx.subFolderList = [];
          let keyArr = Object.getOwnPropertyNames(data);
          for (let i = 0; i < keyArr.length; i++) {
            ctx.subFolderList.push(keyArr[i])
          }
          ctx.showToast(this.getResourceString('Successfully_obtained_the_subscribed_folder_the_data_is') + `：${JSON.stringify(ctx.subFolderList)}`, 'unSubBox-imap')
          ctx.showToast(this.getResourceString('Start_creating_folder'), 'subBox-imap')
          let unSubName = 'unSubFolder' + new Date().getTime();
          GlobalObj?.getInstance()?.getClient()?.addBox(unSubName, (err: Error) => {
            if (err) {
              ctx.showToast(this.getResourceString('Failed_to_create_folder_reason') + `：${err.message}`, 'unSubBox-imap')
            } else {
              ctx.showToast(this.getResourceString('Folder_created_successfully'), 'subBox-imap')
              ctx.showToast(this.getResourceString('Subscribe_to_addFolder_folder'), 'subBox-imap')
              GlobalObj?.getInstance()?.getClient()?.subscribeBox(unSubName, (err: Error) => {
                if (err) {
                  ctx.showToast(this.getResourceString('Subscription_email_failed_reason') + `：${err.message}`, 'unSubBox-imap')
                } else {
                  ctx.showToast(this.getResourceString('Subscription_email_successful'), 'subBox-imap')
                  ctx.showToast(this.getResourceString('Start_obtaining_the_subscribed_folder'), 'subBox-imap')
                  GlobalObj?.getInstance()?.getClient()?.getSubscribedBoxes((err: Error, data: MailBoxes) => {
                    if (err) {
                      ctx.showToast(this.getResourceString('Failed_to_retrieve_the_subscribed_folder_reason') + `：${err.message}`, 'unSubBox-imap')
                    } else {
                      if (!data || typeof data != 'object') {
                        ctx.showToast(this.getResourceString('Error_retrieving_folder_list_from_email') + `, get box status fail`, 'subBox-imap')
                        return
                      }
                      ctx.subFolderList = [];
                      let keyArr = Object.getOwnPropertyNames(data);
                      for (let i = 0; i < keyArr.length; i++) {
                        ctx.subFolderList.push(keyArr[i])
                      }
                      ctx.showToast(this.getResourceString('Successfully_obtained_the_subscribed_folder_the_data_is') + `：${JSON.stringify(ctx.subFolderList)}`, 'unSubBox-imap')
                      let startTime1 = new Date().getTime();
                      GlobalObj?.getInstance()?.getClient()?.unsubscribeBox(unSubName, (err: Error) => {
                        let endTime1 = new Date().getTime();
                        let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
                        console.log("IMAPClientTest : unsubscribeBox averageTime : " + averageTime1 + "us")
                        if (err) {
                          ctx.showToast(this.getResourceString('Unsubscribe_email_failed_reason') + `：${err.message}`, 'unSubBox-imap')
                        } else {
                          ctx.showToast(this.getResourceString('Unsubscribed_email_successfully'), 'unSubBox-imap')
                          ctx.showToast(this.getResourceString('Start_obtaining_the_subscribed_folder'), 'getSubFolderList-imap')
                          GlobalObj?.getInstance()?.getClient()?.getSubscribedBoxes((err: Error, data: MailBoxes) => {
                            if (err) {
                              ctx.showToast(this.getResourceString('Failed_to_retrieve_the_subscribed_folder_reason') + `：${err.message}`, 'getSubFolderList-imap')
                            } else {
                              if (!data || typeof data != 'object') {
                                ctx.showToast(this.getResourceString('Error_retrieving_folder_list_from_email') + `, get box status fail`, 'subBox-imap')
                                return
                              }
                              ctx.subFolderList = [];
                              let keyArr = Object.getOwnPropertyNames(data);
                              for (let i = 0; i < keyArr.length; i++) {
                                ctx.subFolderList.push(keyArr[i])
                              }
                              ctx.showToast(this.getResourceString('Successfully_obtained_the_subscribed_folder_the_data_is') + `：${JSON.stringify(ctx.subFolderList)}`, 'getFolderList-imap')
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
      ctx.showToast(this.getResourceString('Subscription_email_error') + `：${err.message}`, 'subBox-smtp')
    }
  }

  getSubFolderList() {
    const ctx = this;
    try {
      ctx.message = ''
      if (!GlobalObj?.getInstance()?.getClient() || !ctx.isLogin) {
        ctx.showToast(this.getResourceString('Account_not_logged_in_please_login_and_try_again'), 'getSubFolderList-imap')
        return
      }
      ctx.showToast(this.getResourceString('Start_obtaining_the_subscribed_folder'), 'getSubFolderList-imap')
      let startTime1 = new Date().getTime();
      GlobalObj?.getInstance()?.getClient()?.getSubscribedBoxes((err: Error, data: MailBoxes) => {
        let endTime1 = new Date().getTime();
        let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
        console.log("IMAPClientTest : getSubscribedBoxes averageTime : " + averageTime1 + "us")
        if (err) {
          ctx.showToast(this.getResourceString('Failed_to_retrieve_the_subscribed_folder_reason') + `：${err.message}`, 'getSubFolderList-imap')
        } else {
          if (!data || typeof data != 'object') {
            ctx.showToast(this.getResourceString('Error_retrieving_folder_list_from_email') + `, get box status fail`, 'getSubFolderList-imap')
            return
          }
          ctx.subFolderList = [];
          let keyArr = Object.getOwnPropertyNames(data);
          for (let i = 0; i < keyArr.length; i++) {
            ctx.subFolderList.push(keyArr[i])
          }
          ctx.showToast(this.getResourceString('Successfully_obtained_the_subscribed_folder_the_data_is') + `：${JSON.stringify(ctx.subFolderList)}`, 'getFolderList-imap')
        }
      });
    } catch (err) {
      ctx.showToast(this.getResourceString('Error_obtaining_subscription_folder') + `：${err.message}`, 'getSubFolderList-smtp')
    }
  }

  refreshPageSize() {
    const ctx = this;
    if (ctx.startIndex >= (ctx?.bean?.messages?.total ? ctx?.bean?.messages?.total : 0)) {
      return;
    }
    ctx.endIndex = ctx.startIndex + ctx.pageSize - 1;
    if (ctx.endIndex > (ctx?.bean?.messages?.total ? ctx?.bean?.messages?.total : 0)) {
      ctx.endIndex = (ctx?.bean?.messages?.total ? ctx?.bean?.messages?.total : 0);
    }
  }

  openBoxAndGetStatu() {
    const ctx = this;
    try {
      ctx.message = ''
      if (!GlobalObj?.getInstance()?.getClient() || !ctx.isLogin) {
        ctx.showToast(this.getResourceString('Account_not_logged_in_please_login_and_try_again'), 'openBoxAndGetStatu-imap')
        return
      }
      ctx.showToast(this.getResourceString('Starting_to_obtain_the_status_of_the_main_email_and_main_folder') + `${ctx.folderName}`, 'openBoxAndGetStatu-imap')
      let startTime1 = new Date().getTime();
      GlobalObj?.getInstance()?.getClient()?.status(ctx.folderName, (err: Error, data: Box) => {
        let endTime1 = new Date().getTime();
        let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
        console.log("IMAPClientTest : status averageTime : " + averageTime1 + "us")

        if (err) {
          ctx.isBoxOpen = false;
          ctx.showToast(this.getResourceString('Failed_to_retrieve_the_status_of_the_email_home_folder') + `${err.message}`, 'openBoxAndGetStatu-imap')
          return
        }
        if (!data || (data?.messages?.total ? data?.messages?.total : 0) < 1) {
          ctx.isBoxOpen = false;
          ctx.showToast(this.getResourceString('Failed_to_retrieve_the_status_of_the_email_home_folder_no_data_available'), 'openBoxAndGetStatu-imap')
          return
        }
        try {
          ctx.bean = data;
          if ((ctx?.bean?.messages?.total ? ctx?.bean?.messages?.total : 0) > 0) {
            let startTime1 = new Date().getTime();
            GlobalObj?.getInstance()?.getClient()?.openBox(ctx.folderName, true, (err: Error, data: Box) => {
              let endTime1 = new Date().getTime();
              let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
              console.log("IMAPClientTest : openBox averageTime : " + averageTime1 + "us")
              if (err) {
                ctx.isBoxOpen = true;
                ctx.showToast(this.getResourceString('Failed_to_open_mailbox_main_folder') + `${err.message}`, 'openBoxAndGetStatu-imap')
                return
              }
              ctx.showToast(this.getResourceString('Successfully_opened_the_email_home_folder'), 'openBoxAndGetStatu-imap')
              ctx.isBoxOpen = true;
              ctx.getListData()
            });
          } else {
            ctx.isBoxOpen = false;
            ctx.showToast(`文件夹：${ctx.folderName}中，有信息总共：${ctx?.bean?.messages?.total},新消息:${ctx?.bean?.messages?.new},未读消息:${ctx?.bean?.messages?.unseen},未打开邮箱`, 'openBoxAndGetStatu-imap')
          }

        } catch (err) {
          ctx.showToast(this.getResourceString('Failed_to_open_mailbox_main_folder') + `${err.message}`, 'openBoxAndGetStatu-imap')
        }
      })
    } catch (err) {
      ctx.showToast(this.getResourceString('Failed_to_retrieve_the_main_email_mailing_list_message_is') + `：${err.message}`, 'getListData-imap')
      throw err as Error
    }
  }

  getListData() {
    const ctx = this;
    try {
      ctx.listData = []
      ctx.refreshPageSize();
      ctx.message = ''
      if (!GlobalObj?.getInstance()?.getClient() || !ctx.isLogin) {
        ctx.showToast(this.getResourceString('Account_not_logged_in_please_login_and_try_again'), 'getListData-imap')
        return
      }
      if (!ctx.isBoxOpen) {
        ctx.showToast(this.getResourceString('Email_not_opened_unable_to_retrieve_mailing_list'), 'getListData-imap')
        return
      }
      if (!GlobalObj?.getInstance()?.getClient()?.seq) {
        ctx.showToast(this.getResourceString('The_client_seq_object_is_empty'), 'getListData-imap')
        return
      }
      ctx.showToast(this.getResourceString('Start_obtaining_the_main_email_mailing_list'), 'getListData-imap')
      // fetch里面可以是fetch(`1:3`）这种取序号为1-3的信息的  也可以是可以是fetch(`1`）这种取序号为1的信息
      let startTime1 = new Date().getTime();
      let prefix: string = ''
      let buffer: string = '';
      let callback: DetailCallback = {
        messageStartCallback: (seqno: number) => {
          console.log('Message #%d', seqno);
          prefix = '(#' + seqno + ') ';
        },
        bodyStartCallback: () => {
        },
        bodyDataCallback: (data: string) => {
          buffer += data;
        },
        bodyEndCallback: () => {
        },
        attributesCallback: (attrs: ImapMessageAttributes) => {
          if (attrs && attrs.uid) {
            ctx.uidList.push(attrs.uid + "");
          }
        },
        messageEndCallback: () => {
          console.log(prefix + 'Finished');
        },
        fetchErrorCallback: (err: Error) => {
          console.log('Fetch error: ' + err);
          ctx.showToast(this.getResourceString('Failed_to_retrieve_the_main_email_mailing_list_message_is') + `：${err.message}`, 'getListData-imap')
        },
        fetchEndCallback: () => {
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
          ctx.showToast(this.getResourceString('Successfully_obtained_the_main_email_mailing_list_the_data_is') + `：${JSON.stringify(ctx.listData)}`, 'getListData-imap')
          // GlobalObj?.getInstance()?.getClient()?.end();
        }
      }
      this.util?.getListData(ctx.startIndex, ctx.endIndex, callback)
    } catch (err) {
      ctx.showToast(this.getResourceString('Failed_to_retrieve_the_main_email_mailing_list_message_is') + `：${err.message}`, 'getListData-imap')
      throw err as Error
    }

  }

  createMailData() {
    let msg: MsgSendBean = {
      text: this.getResourceString('Email_uploaded_during_IMAP_protocol_testing'),
      from: `${'鸿蒙搬砖工'} <${'xx@qq.com'}>`,
      to: 'xx@qq.com',
      cc: 'xx@163.com',
      bcc: 'xx@139.com',
      subject: this.getResourceString('Topic_of_IMAP_Protocol_for_Client')
    }
    return JSON.stringify(msg);
  }

  appendMail() {
    const ctx = this;
    try {
      ctx.message = ''
      if (!GlobalObj?.getInstance()?.getClient() || !ctx.isLogin) {
        ctx.showToast(this.getResourceString('Account_not_logged_in_please_login_and_try_again'), 'appendMail-imap')
        return
      }
      if (!ctx.isBoxOpen) {
        ctx.showToast(this.getResourceString('Email_not_opened_unable_to_retrieve_mailing_list'), 'appendMail-imap')
        return
      }
      let data = ctx.createMailData();
      if (!data || data.length < 1) {
        ctx.showToast(this.getResourceString('The_uploaded_email_data_cannot_be_empty'), 'appendMail-imap')
        return
      }
      ctx.showToast(this.getResourceString('Start_uploading_emails'), 'appendMail-imap')
      let option: AppendOptions = {
        mailbox: 'INBOX',
        flags: ['Seen'], //取值 Seen flagged等
        date: new Date(), //取值 Seen flagged等

      }
      let startTime1 = new Date().getTime();
      GlobalObj?.getInstance()?.getClient()?.append(data, option, (err: Error) => {
        let endTime1 = new Date().getTime();
        let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
        console.log("IMAPClientTest : append averageTime : " + averageTime1 + "us")
        if (err) {
          ctx.showToast(this.getResourceString('Failed_to_upload_email') + `：${err.message}`, 'appendMail-imap')
        } else {
          ctx.showToast(this.getResourceString('Email_uploaded_successfully'), 'appendMail-imap')
        }
      });
    } catch (err) {
      ctx.showToast(this.getResourceString('Error_uploading_email') + `：${err.message}`, 'appendMail-smtp')
    }
  }

  closeBox() {
    const ctx = this;
    try {
      ctx.message = ''
      ctx.showToast(this.getResourceString('Start_closing_this_folder'), 'closeBox-imap')
      if (!GlobalObj?.getInstance()?.getClient() || !ctx.isLogin) {
        ctx.showToast(this.getResourceString('Account_not_logged_in_please_login_and_try_again'), 'closeBox-imap')
        return
      }
      if (!ctx.isBoxOpen) {
        ctx.showToast(this.getResourceString('Email_not_opened_unable_to_retrieve_mailing_list'), 'closeBox-imap')
        return
      }
      let startTime1 = new Date().getTime();
      GlobalObj?.getInstance()?.getClient()?.closeBox((err: Error) => {
        let endTime1 = new Date().getTime();
        let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
        console.log("IMAPClientTest : closeBox averageTime : " + averageTime1 + "us")
        if (err) {
          ctx.showToast(this.getResourceString('Failed_to_close_this_folder_reason') + `：${err.message}`, 'closeBox-imap')
        } else {
          ctx.isBoxOpen = false;
          ctx.showToast(this.getResourceString('Successfully_closed_this_folder'), 'appendMail-imap')
        }
      });
    } catch (err) {
      ctx.showToast(this.getResourceString('Error_closing_this_folder') + `：${err.message}`, 'closeBox-smtp')
    }
  }

  sortMail() {
    const ctx = this;
    try {
      ctx.message = ''
      ctx.showToast(this.getResourceString('Start_setting_sorting'), 'sortMail-imap')
      if (!GlobalObj?.getInstance()?.getClient() || !ctx.isLogin) {
        ctx.showToast(this.getResourceString('Account_not_logged_in_please_login_and_try_again'), 'sortMail-imap')
        return
      }
      if (!ctx.isBoxOpen) {
        ctx.showToast(this.getResourceString('Email_not_opened_unable_to_retrieve_mailing_list'), 'sortMail-imap')
        return
      }
      ctx.showToast(this.getResourceString('Start_sorting_emails_by_date'), 'sortMail-imap')
      let startTime1 = new Date().getTime();
      GlobalObj?.getInstance()?.getClient()?.sort(['DATE'], ['ALL'], (err:Error, uids:number[]) => {
        let endTime1 = new Date().getTime();
        let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
        console.log("IMAPClientTest : sort averageTime : " + averageTime1 + "us")
        if (err) {
          ctx.showToast(this.getResourceString('Failed_to_sort_emails_by_date_reason') + `：${err.message}`, 'sortMail-imap')
        } else {
          ctx.showToast(this.getResourceString('Successfully_sorted_emails_by_date'), 'sortMail-imap')
        }
      });

    } catch (err) {
      ctx.showToast(this.getResourceString('Setting_sorting_error') + `：${err.message}`, 'sortMail-smtp')
    }
  }

  search() {
    const ctx = this;
    try {
      ctx.message = ''
      ctx.showToast(this.getResourceString('Start_searching_for_emails'), 'search-imap')
      if (!GlobalObj?.getInstance()?.getClient() || !ctx.isLogin) {
        ctx.showToast(this.getResourceString('Account_not_logged_in_please_login_and_try_again'), 'search-imap')
        return
      }
      if (!ctx.isBoxOpen) {
        ctx.showToast(this.getResourceString('Email_not_opened_unable_to_retrieve_mailing_list'), 'search-imap')
        return
      }
      let startTime1 = new Date().getTime();
      GlobalObj?.getInstance()?.getClient()?.search(['RECENT'], (err:Error, uids:number[]) => {
        let endTime1 = new Date().getTime();
        let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
        console.log("IMAPClientTest : search averageTime : " + averageTime1 + "us")
        if (err) {
          ctx.showToast(this.getResourceString('Search_email_failed_reason') + `：${err.message}`, 'search-imap')
        } else {
          ctx.showToast(this.getResourceString('Search_email_successful') + JSON.stringify(uids), 'search-imap')
        }
      });
    } catch (err) {
      ctx.showToast(this.getResourceString('Search_email_error') + `：${err.message}`, 'search-smtp')
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
    if (!GlobalObj?.getInstance()?.getClient() || !ctx.isLogin) {
      ctx.showToast(this.getResourceString('Account_not_logged_in_please_login_and_try_again'), 'search-imap')
      return
    }
    if (!ctx.isBoxOpen) {
      ctx.showToast(this.getResourceString('Email_not_opened_unable_to_retrieve_mailing_list'), 'search-imap')
      return
    }

    if (!ctx.listData || ctx.listData.length < 1) {
      ctx.showToast(this.getResourceString('There_are_currently_no_available_messages_in_the_email'), 'storeMail---IMAP')
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
    } else {
      ctx.showToast(this.getResourceString('There_are_currently_no_emails_available_for_operation'), 'storeMail---IMAP')
    }
  }

  addDeleteFlag(uid: string) {
    const ctx = this;
    try {
      ctx.showToast(this.getResourceString('Start_marking_emails_for_deletion'), 'addDeleteFlag-imap')
      GlobalObj?.getInstance()?.getClient()?.addFlags(uid, '\\Deleted', (err:Error) => {
        if (err) {
          ctx.showToast(this.getResourceString('Failed_to_mark_the_email_for_deletion_reason') + `：${err.message}`, 'addDeleteFlag-imap')
        } else {
          ctx.showToast(this.getResourceString('Successfully_marked_the_email_for_deletion'), 'storeMail-imap')
          ctx.expungeMail(uid)
        }
      });

    } catch (err) {
      ctx.showToast(this.getResourceString('Error_in_marking_email_for_deletion') + `：${err.message}`, 'storeMail-smtp')
    }
  }

  expungeMail(uid: string) {
    const ctx = this;
    try {
      ctx.showToast(this.getResourceString('Start_deleting_all_emails_marked_as_DELETED_Emails_deleted_by_EXPUNGE_cannot_be_recovered'), 'expungeMail-imap')
      let startTime1 = new Date().getTime();
      GlobalObj?.getInstance()?.getClient()?.expunge(uid, (err:Error) => {
        let endTime1 = new Date().getTime();
        let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
        console.log("IMAPClientTest : expunge averageTime : " + averageTime1 + "us")
        if (err) {
          ctx.showToast(this.getResourceString('Permanent_deletion_failed_reason') + `：${err.message}`, 'expungeMail-imap')
        } else {
          ctx.showToast(this.getResourceString('Permanently_deleted_successfully'), 'expungeMail-imap')
        }
      });
    } catch (err) {
      ctx.showToast(this.getResourceString('Permanent_deletion_error') + `：${err.message}`, 'expungeMail-smtp')
    }
  }

  copyMail() {
    const ctx = this;
    try {
      ctx.message = ''
      if (!GlobalObj?.getInstance()?.getClient() || !ctx.isLogin) {
        ctx.showToast(this.getResourceString('Account_not_logged_in_please_login_and_try_again'), 'copyMail-imap')
        return
      }
      if (!ctx.isBoxOpen) {
        ctx.showToast(this.getResourceString('Email_not_opened_unable_to_retrieve_mailing_list'), 'copyMail-imap')
        return
      }
      if (!ctx.listData || ctx.listData.length < 1) {
        ctx.showToast(this.getResourceString('There_are_currently_no_available_messages_in_the_email'), 'copyMail---IMAP')
        return
      }
      let uid = ctx.listData[0].uid
      if (!uid || uid.length < 1) {
        ctx.showToast(this.getResourceString('There_are_currently_no_available_messages_in_the_email'), 'copyMail---IMAP')
        return
      }
      if (!ctx.folderList || ctx.folderList.length < 1) {
        ctx.showToast(this.getResourceString('No_available_email_address'), 'copyMail---IMAP')
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
          ctx.showToast(this.getResourceString('No_available_email_address'), 'copyMail---IMAP')
          return
        }
      }
      ctx.showToast(this.getResourceString('Copy_email_started'), 'copyMail-imap')
      let startTime1 = new Date().getTime();
      GlobalObj?.getInstance()?.getClient()?.copy(uid, selectFoler, (err:Error) => {
        let endTime1 = new Date().getTime();
        let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
        console.log("IMAPClientTest : copy averageTime : " + averageTime1 + "us")
        if (err) {
          ctx.showToast(this.getResourceString('Copy_email_failed_reason') + `：${err.message}`, 'copyMail-imap')
        } else {
          ctx.showToast(this.getResourceString('The_email_was_successfully_copied'), 'copyMail-imap')

        }
      });

    } catch (err) {
      ctx.showToast(this.getResourceString('Error_copying_email') + `：${err.message}`, 'copyMail-smtp')
    }
  }

  moveMail() {
    const ctx = this;
    try {
      ctx.message = ''
      if (!GlobalObj?.getInstance()?.getClient() || !ctx.isLogin) {
        ctx.showToast(this.getResourceString('Account_not_logged_in_please_login_and_try_again'), 'moveMail-imap')
        return
      }
      if (!ctx.isBoxOpen) {
        ctx.showToast(this.getResourceString('Email_not_opened_unable_to_retrieve_mailing_list'), 'moveMail-imap')
        return
      }
      if (!ctx.listData || ctx.listData.length < 1) {
        ctx.showToast(this.getResourceString('There_are_currently_no_available_messages_in_the_email'), 'moveMail---IMAP')
        return
      }
      let uid = ctx.listData[0].uid
      if (!uid || uid.length < 1) {
        ctx.showToast(this.getResourceString('There_are_currently_no_available_messages_in_the_email'), 'moveMail---IMAP')
        return
      }
      if (!ctx.folderList || ctx.folderList.length < 1) {
        ctx.showToast(this.getResourceString('No_available_email_address'), 'moveMail---IMAP')
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
          ctx.showToast(this.getResourceString('No_available_email_address'), 'moveMail---IMAP')
          return
        }
      }
      ctx.showToast(this.getResourceString('Start_moving_emails_from_the_primary_mailbox_to') + ` ${selectFoler}`, 'moveMail-imap')
      let startTime1 = new Date().getTime();
      GlobalObj?.getInstance()?.getClient()?.move(uid, selectFoler, (err:Error) => {
        let endTime1 = new Date().getTime();
        let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
        console.log("IMAPClientTest : move averageTime : " + averageTime1 + "us")
        if (err) {
          ctx.showToast(this.getResourceString('Mobile_email_failed_reason') + `：${err.message}`, 'moveMail-imap')
        } else {
          ctx.showToast(this.getResourceString('Mobile_email_successfully_sent'), 'moveMail-imap')

          ctx.showToast(`移动邮件成功之后，请到主邮箱查看是否少了一封邮件，请到${selectFoler} 查看是否新增了一封邮件，然后点击 关闭邮箱 以及获取邮箱列表刷新数据以便进行其他操作 `, 'moveMail-imap')
        }
      });
    } catch (err) {
      ctx.showToast(this.getResourceString('Mobile_email_error') + `：${err.message}`, 'moveMail-smtp')
    }
  }

  addFlag() {
    const ctx = this;
    try {
      ctx.message = ''
      if (!GlobalObj?.getInstance()?.getClient() || !ctx.isLogin) {
        ctx.showToast(this.getResourceString('Account_not_logged_in_please_login_and_try_again'), 'addFlag-imap')
        return
      }
      if (!ctx.isBoxOpen) {
        ctx.showToast(this.getResourceString('Email_not_opened_unable_to_retrieve_mailing_list'), 'addFlag-imap')
        return
      }
      if (!ctx.listData || ctx.listData.length < 1) {
        ctx.showToast(this.getResourceString('There_are_currently_no_available_messages_in_the_email'), 'addFlag---IMAP')
        return
      }
      let uid = ctx.listData[0].uid
      if (!uid || uid.length < 1) {
        ctx.showToast(this.getResourceString('There_are_currently_no_available_messages_in_the_email'), 'addFlag---IMAP')
        return
      }
      ctx.showToast(this.getResourceString('Start_adding_read_tags_to_emails'), 'addFlag-imap')
      let startTime1 = new Date().getTime();
      GlobalObj?.getInstance()?.getClient()?.addFlags(uid, '\\Seen', (err:Error) => {
        let endTime1 = new Date().getTime();
        let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
        console.log("IMAPClientTest : addFlags averageTime : " + averageTime1 + "us")
        if (err) {
          ctx.showToast(this.getResourceString('Adding_read_mark_to_email_failed_reason') + `：${err.message}`, 'addFlag-imap')
        } else {
          ctx.showToast(this.getResourceString('Successfully_marked_the_email_as_read'), 'addFlag-imap')
        }
      });

    } catch (err) {
      ctx.showToast(this.getResourceString('Error_adding_read_mark_to_email') + `：${err.message}`, 'storeMail-smtp')
    }
  }

  setFlag() {
    const ctx = this;
    try {
      ctx.message = ''
      if (!GlobalObj?.getInstance()?.getClient() || !ctx.isLogin) {
        ctx.showToast(this.getResourceString('Account_not_logged_in_please_login_and_try_again'), 'setFlag-imap')
        return
      }
      if (!ctx.isBoxOpen) {
        ctx.showToast(this.getResourceString('Email_not_opened_unable_to_retrieve_mailing_list'), 'setFlag-imap')
        return
      }
      if (!ctx.listData || ctx.listData.length < 1) {
        ctx.showToast(this.getResourceString('There_are_currently_no_available_messages_in_the_email'), 'setFlag---IMAP')
        return
      }
      let uid = ctx.listData[0].uid
      if (!uid || uid.length < 1) {
        ctx.showToast(this.getResourceString('There_are_currently_no_available_messages_in_the_email'), 'setFlag---IMAP')
        return
      }

      ctx.showToast(this.getResourceString('Start_marking_emails_as_read'), 'setFlag-imap')
      let startTime1 = new Date().getTime();
      GlobalObj?.getInstance()?.getClient()?.setFlags(uid, '\\Seen', (err:Error) => {
        let endTime1 = new Date().getTime();
        let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
        console.log("IMAPClientTest : setFlags averageTime : " + averageTime1 + "us")
        if (err) {
          ctx.showToast(this.getResourceString('Failed_to_set_read_flag_for_email_reason') + `：${err.message}`, 'setFlag-imap')
        } else {
          ctx.showToast(this.getResourceString('Successfully_marked_the_email_as_read'), 'setFlag-imap')
        }
      });
    } catch (err) {
      ctx.showToast(this.getResourceString('Error_setting_read_flag_for_email') + `：${err.message}`, 'setFlag-smtp')
    }
  }

  deleteFlag() {
    const ctx = this;
    try {
      ctx.message = ''
      if (!GlobalObj?.getInstance()?.getClient() || !ctx.isLogin) {
        ctx.showToast(this.getResourceString('Account_not_logged_in_please_login_and_try_again'), 'deleteFlag-imap')
        return
      }
      if (!ctx.isBoxOpen) {
        ctx.showToast(this.getResourceString('Email_not_opened_unable_to_retrieve_mailing_list'), 'deleteFlag-imap')
        return
      }
      if (!ctx.listData || ctx.listData.length < 1) {
        ctx.showToast(this.getResourceString('There_are_currently_no_available_messages_in_the_email'), 'deleteFlag---IMAP')
        return
      }
      let uid = ctx.listData[0].uid
      if (!uid || uid.length < 1) {
        ctx.showToast(this.getResourceString('There_are_currently_no_available_messages_in_the_email'), 'deleteFlag---IMAP')
        return
      }
      ctx.showToast(this.getResourceString('Start_unmarking_emails_as_read'), 'deleteFlag-imap')
      let startTime1 = new Date().getTime();
      GlobalObj?.getInstance()?.getClient()?.delFlags(uid, '\\Seen', (err:Error) => {
        let endTime1 = new Date().getTime();
        let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
        console.log("IMAPClientTest : delFlags averageTime : " + averageTime1 + "us")
        if (err) {
          ctx.showToast(this.getResourceString('Failed_to_unmark_the_email_as_read_reason') + `：${err.message}`, 'deleteFlag-imap')
        } else {
          ctx.showToast(this.getResourceString('Successfully_unmarked_the_email_as_read'), 'deleteFlag-imap')
        }
      });

    } catch (err) {
      ctx.showToast(this.getResourceString('Error_occurred_in_removing_the_read_mark_from_the_email') + `：${err.message}`, 'deleteFlag-smtp')
    }
  }

  addKeywords() {
    const ctx = this;
    try {
      ctx.message = ''
      if (!GlobalObj?.getInstance()?.getClient() || !ctx.isLogin) {
        ctx.showToast(this.getResourceString('Account_not_logged_in_please_login_and_try_again'), 'addKeywords-imap')
        return
      }
      if (!ctx.isBoxOpen) {
        ctx.showToast(this.getResourceString('Email_not_opened_unable_to_retrieve_mailing_list'), 'addKeywords-imap')
        return
      }
      if (!ctx.listData || ctx.listData.length < 1) {
        ctx.showToast(this.getResourceString('There_are_currently_no_available_messages_in_the_email'), 'addKeywords---IMAP')
        return
      }
      let uid = ctx.listData[0].uid
      if (!uid || uid.length < 1) {
        ctx.showToast(this.getResourceString('There_are_currently_no_available_messages_in_the_email'), 'addKeywords---IMAP')
        return
      }
      ctx.showToast(this.getResourceString('Start_adding_keywords_to_emails'), 'addKeywords-imap')
      let startTime1 = new Date().getTime();
      GlobalObj?.getInstance()?.getClient()?.addKeywords(uid, this.getResourceString('OpenHarmony_keywords'), (err:Error) => {
        let endTime1 = new Date().getTime();
        let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
        console.log("IMAPClientTest : addKeywords averageTime : " + averageTime1 + "us")
        if (err) {
          ctx.showToast(this.getResourceString('Adding_keywords_to_email_failed_reason') + `：${err.message}`, 'addKeywords-imap')
        } else {
          ctx.showToast(this.getResourceString('Successfully_added_keywords_to_email'), 'addKeywords-imap')
        }
      });
    } catch (err) {
      ctx.showToast(this.getResourceString('Error_adding_keywords_to_email') + `：${err.message}`, 'addKeywords-smtp')
    }
  }

  setKeywords() {
    const ctx = this;
    try {
      ctx.message = ''
      if (!GlobalObj?.getInstance()?.getClient() || !ctx.isLogin) {
        ctx.showToast(this.getResourceString('Account_not_logged_in_please_login_and_try_again'), 'setKeywords-imap')
        return
      }
      if (!ctx.isBoxOpen) {
        ctx.showToast(this.getResourceString('Email_not_opened_unable_to_retrieve_mailing_list'), 'setKeywords-imap')
        return
      }
      if (!ctx.listData || ctx.listData.length < 1) {
        ctx.showToast(this.getResourceString('There_are_currently_no_available_messages_in_the_email'), 'setKeywords---IMAP')
        return
      }
      let uid = ctx.listData[0].uid
      if (!uid || uid.length < 1) {
        ctx.showToast(this.getResourceString('There_are_currently_no_available_messages_in_the_email'), 'setKeywords---IMAP')
        return
      }
      ctx.showToast(this.getResourceString('Start_setting_keywords_for_emails'), 'setKeywords-imap')
      let startTime1 = new Date().getTime();
      GlobalObj?.getInstance()?.getClient()?.setKeywords(uid, this.getResourceString('OpenHarmony_keywords'), (err:Error) => {
        let endTime1 = new Date().getTime();
        let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
        console.log("IMAPClientTest : setKeywords averageTime : " + averageTime1 + "us")
        if (err) {
          ctx.showToast(this.getResourceString('Failed_to_set_keywords_for_email_reason') + `：${err.message}`, 'setKeywords-imap')
        } else {
          ctx.showToast(this.getResourceString('Successfully_set_keywords_for_email'), 'setKeywords-imap')
        }
      });
    } catch (err) {
      ctx.showToast(this.getResourceString('Error_setting_keywords_for_email') + `：${err.message}`, 'setKeywords-smtp')
    }
  }

  delKeywords() {
    const ctx = this;
    try {
      ctx.message = ''
      if (!GlobalObj?.getInstance()?.getClient() || !ctx.isLogin) {
        ctx.showToast(this.getResourceString('Account_not_logged_in_please_login_and_try_again'), 'delKeywords-imap')
        return
      }
      if (!ctx.isBoxOpen) {
        ctx.showToast(this.getResourceString('Email_not_opened_unable_to_retrieve_mailing_list'), 'delKeywords-imap')
        return
      }
      if (!ctx.listData || ctx.listData.length < 1) {
        ctx.showToast(this.getResourceString('There_are_currently_no_available_messages_in_the_email'), 'delKeywords---IMAP')
        return
      }
      let uid = ctx.listData[0].uid
      if (!uid || uid.length < 1) {
        ctx.showToast(this.getResourceString('There_are_currently_no_available_messages_in_the_email'), 'delKeywords---IMAP')
        return
      }
      ctx.showToast(this.getResourceString('Start_deleting_keywords_from_emails'), 'delKeywords-imap')
      let startTime1 = new Date().getTime();
      GlobalObj?.getInstance()?.getClient()?.delKeywords(uid, this.getResourceString('OpenHarmony_keywords'), (err:Error) => {
        let endTime1 = new Date().getTime();
        let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
        console.log("IMAPClientTest : delKeywords averageTime : " + averageTime1 + "us")
        if (err) {
          ctx.showToast(this.getResourceString('Failed_to_delete_keywords_from_email_reason') + `：${err.message}`, 'delKeywords-imap')
        } else {
          ctx.showToast(this.getResourceString('Successfully_deleted_keywords_from_email'), 'delKeywords-imap')
        }
      });
    } catch (err) {
      ctx.showToast(this.getResourceString('Error_deleting_keywords_from_email') + `：${err.message}`, 'delKeywords-smtp')
    }
  }

  getMsgDetail() {
    const ctx = this;
    try {
      ctx.message = ''
      if (!GlobalObj?.getInstance()?.getClient() || !ctx.isLogin) {
        ctx.showToast(this.getResourceString('Account_not_logged_in_please_login_and_try_again'), 'getMsgDetail-imap')
        return
      }
      if (!ctx.isBoxOpen) {
        ctx.showToast(this.getResourceString('Email_not_opened_unable_to_retrieve_mailing_list'), 'getMsgDetail-imap')
        return
      }
      if (!ctx.listData || ctx.listData.length < 1) {
        ctx.showToast(this.getResourceString('There_are_currently_no_available_messages_in_the_email'), 'getMsgDetail---IMAP')
        return
      }
      ctx.showToast(this.getResourceString('Start_obtaining_the_entire_email_body'), 'getMsgDetail-imap')
      let startTime1 = new Date().getTime();

      let prefix: string = ''
      let buffer: string = '';
      let callback: DetailCallback = {
        messageStartCallback: (seqno: number) => {
          console.log('Message #%d', seqno);
          prefix = '(#' + seqno + ') ';
        },
        bodyStartCallback: () => {
        },
        bodyDataCallback: (data: string) => {
          buffer += data;
        },
        bodyEndCallback: () => {
          let endTime1 = new Date().getTime();
          let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
          console.log("IMAPClientTest : fetch detail averageTime : " + averageTime1 + "us")
          try {
            ctx.showToast(this.getResourceString('Successfully_obtained') + `：${'\r\n'}${buffer}`, 'getMsgDetail-imap');

          } catch (err) {
            ctx.showToast(this.getResourceString('Failed_to_retrieve_the_entire_email_body') + `：${err.message}`, 'getMsgDetail-smtp')
          }
        },
        attributesCallback: (attrs: ImapMessageAttributes) => {
          if (attrs && attrs.uid) {
            ctx.uidList.push(attrs.uid + "");
          }
        },
        messageEndCallback: () => {
        },
        fetchErrorCallback: (err: Error) => {
          ctx.showToast(this.getResourceString('Failed_to_retrieve_the_entire_email_body') + `：${err.message}`, 'getMsgDetail-smtp')
        },
        fetchEndCallback: () => {

        }
      }
      this.util?.getDetail(1, callback)
    } catch (err) {
      ctx.showToast(this.getResourceString('Error_in_obtaining_the_entire_email_body') + `：${err.message}`, 'getMsgDetail-smtp')
    }
  }

  getResourceString(resourceName:string) {
    return getContext().resourceManager.getStringByNameSync(resourceName)
  }
}
