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

import Imap, { inspect } from '@ohos/node-imap'
import promptAction from '@ohos.promptAction'
import router from '@ohos.router'
import socket from '@ohos.net.socket'
import LoginUtil from '../LoginUtil'
import GlobalObj from '../GlobalObj'
import LoginOption from '../bean/LoginOption'

@CustomDialog
struct CustomDialogDiy {
  @Link textValue: string
  @Link inputValue: string
  controller: CustomDialogController
  cancel: Function = () => {
  };
  confirm: Function = () => {
  };

  build() {
    Column() {
      Text($r('app.string.Please_enter_the_folder_name')).fontSize(20).margin({ top: 10, bottom: 10 }).width('90%')
      TextInput({ placeholder: '', text: this.textValue }).height(60).width('90%')
        .onChange((value: string) => {
          this.textValue = value;
        })
      Text($r('app.string.Please_enter_the_folder_name_in_the_correct_format'))
        .margin({ top: 10, bottom: 10 })
        .width('90%')
        .fontSize(8)
        .fontColor(Color.Red)
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button($r('app.string.Cancel'))
          .onClick(() => {
            this.controller.close()
            this.cancel()
          })
        Button($r('app.string.Confirm'))
          .onClick(() => {
            this.inputValue = this.textValue
            this.controller.close()
            this.confirm()
          })

      }

    }
  }
}


@Entry
@Component
struct LoginPage {
  @State message: string = 'Hello World'
  @State account: string = ''
  @State password: string = ''
  @State mailType: string = '@qq.com'
  @State textValue: string = ''
  @State inputValue: string = 'click me'
  @State secure: boolean = false
  @State isLogin: boolean = false
  @State capability: string = ''
  private util: LoginUtil = new LoginUtil();
  private option: socket.TLSConnectOptions = {
    ALPNProtocols: ["spdy/1", "http/1.1"],
    address: {
      address: 'imap.xx.com',
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
  dialogController: CustomDialogController | null = new CustomDialogController({
    builder: CustomDialogDiy({
      cancel: () => {
        this.showToast(this.getResourceString('The_dialog_box_has_been_closed'), 'mailType-cancel')
      },
      confirm: () => {
        if (!this.inputValue || this.inputValue.length < 1) {
          this.showToast(this.getResourceString('Email_type_cannot_be_empty'), 'mailType-confirm')
          return
        }
        if (this.inputValue.indexOf('@') == -1 && this.inputValue.indexOf('@') != this.inputValue.lastIndexOf('@')) {
          this.showToast(this.getResourceString('Email_type_must_contain_one'), 'mailType-confirm')
          return
        }
        if (this.inputValue.indexOf('.') == -1 && this.inputValue.indexOf('.') != this.inputValue.lastIndexOf('.')) {
          this.showToast(this.getResourceString('Email_type_must_contain_one_point'), 'mailType-confirm')
          return
        }
        if (this.inputValue.indexOf('@') != -1 && this.inputValue.indexOf('.') != -1 && this.inputValue.indexOf('@') > this.inputValue.indexOf('.')) {
          this.showToast(this.getResourceString('In_email_types'), 'mailType-confirm')
          return
        }
        if (this.inputValue.indexOf('@') - this.inputValue.indexOf('.') == 1) {
          this.showToast(this.getResourceString('Except_for_and'), 'mailType-confirm')
          return
        }
        if (this.inputValue.indexOf('@') != 0) {
          this.showToast(this.getResourceString('must_be_first_in_the_email_type'), 'mailType-confirm')
          return
        }
        this.mailType = this.inputValue
        this.showToast(this.getResourceString('Enter_other_types_of_email_addresses') + `：${this.mailType}`, 'mailType-confirm')
      },
      textValue: $textValue,
      inputValue: $inputValue
    }),
    autoCancel: true,
    customStyle: false
  })

  aboutToDisappear() {
    this.dialogController = null;
    GlobalObj?.getInstance()?.getClient()?.end()
  }

  showToast(text: string, name = '测试') {
    console.log(`zdy---${name}--->${text}`)
    promptAction.showToast({
      message: text,
      duration: 2000,
      bottom: 50
    })
  }

  @Builder
  MailMenu() {
    Menu() {
      MenuItem({ content: 'qq', labelInfo: 'qq' })
        .onChange((selected) => {
          if (selected) {
            this.mailType = '@qq.com'
          }
        })

      MenuItem({ content: '163', labelInfo: '163' })
        .onChange((selected) => {
          if (selected) {
            this.mailType = '@163.com'
          }
        })

      MenuItem({ content: '139', labelInfo: '139' })
        .onChange((selected) => {
          if (selected) {
            this.mailType = '@139.com'
          }
        })

      MenuItem({ content: 'sina', labelInfo: 'sina' })
        .onChange((selected) => {
          if (selected) {
            this.mailType = '@sina.com'
          }
        })
      MenuItem({ content: '其他', labelInfo: 'other' })
        .onChange((selected) => {
          if (selected) {
            if (this.dialogController) {
              this.dialogController.open()
            }
          }
        })
    }
  }

  @Builder
  CapabilityMenu() {
    Menu() {

      MenuItem({ content: 'IMAP4', labelInfo: 'IMAP4' })
        .onChange((selected) => {
          if (selected) {
            this.mailType = 'IMAP4'
            this.checkServerCapability()
          }
        })
      MenuItem({ content: 'IMAP4REV1', labelInfo: 'IMAP4REV1' })
        .onChange((selected) => {
          if (selected) {
            this.mailType = 'IMAP4REV1'
          }
        })
      MenuItem({ content: 'XLIST', labelInfo: 'XLIST' })
        .onChange((selected) => {
          if (selected) {
            this.mailType = 'XLIST'
          }
        })
      MenuItem({ content: 'MOVE', labelInfo: 'MOVE' })
        .onChange((selected) => {
          if (selected) {
            this.mailType = 'MOVE'
          }
        })
      MenuItem({ content: 'IDLE', labelInfo: 'IDLE' })
        .onChange((selected) => {
          if (selected) {
            this.mailType = 'IDLE'
          }
        })
      MenuItem({ content: 'XAPPLEPUSHSERVICE', labelInfo: 'XAPPLEPUSHSERVICE' })
        .onChange((selected) => {
          if (selected) {
            this.mailType = 'XAPPLEPUSHSERVICE'
          }
        })
      MenuItem({ content: 'NAMESPACE', labelInfo: 'NAMESPACE' })
        .onChange((selected) => {
          if (selected) {
            this.mailType = 'NAMESPACE'
          }
        })
      MenuItem({ content: 'CHILDREN', labelInfo: 'CHILDREN' })
        .onChange((selected) => {
          if (selected) {
            this.mailType = 'CHILDREN'
          }
        })
      MenuItem({ content: 'ID', labelInfo: 'ID' })
        .onChange((selected) => {
          if (selected) {
            this.mailType = 'ID'
          }
        })
      MenuItem({ content: 'UIDPLUS', labelInfo: 'UIDPLUS' })
        .onChange((selected) => {
          if (selected) {
            this.mailType = 'UIDPLUS'
          }
        })
      MenuItem({ content: 'COMPRESS-DEFLATE', labelInfo: 'COMPRESS-DEFLATE' })
        .onChange((selected) => {
          if (selected) {
            this.mailType = 'COMPRESS-DEFLATE'
          }
        })

    }
  }

  build() {
    Row() {
      Flex({
        alignItems: ItemAlign.Center,
        justifyContent: FlexAlign.Center,
        alignContent: FlexAlign.Center,
        direction: FlexDirection.Column
      }) {
        Text($r('app.string.Click_on_the_email_after_the_account_to_switch_email_types'))
          .fontSize(20)
          .height(50)
          .textAlign(TextAlign.Center)
          .margin({ bottom: 20 })
          .fontWeight(FontWeight.Bold)
          .width('100%')

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

          TextInput({ placeholder: $r('app.string.Please_enter_your_account'), text: '' })
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

          Text(this.mailType)
            .fontSize(14)
            .height(50)
            .fontColor(Color.Blue)
            .textAlign(TextAlign.Center)
            .margin({ left: 5, right: 15 })
            .bindMenu(this.MailMenu)
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

          TextInput({ placeholder: $r('app.string.Please_enter_password_authorization_code'), text: 'bfxeualuaxambged' })
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

        Flex({ justifyContent: FlexAlign.Start, direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
          Text($r('app.string.Do_you_want_to_enable_SSL_TLS'))
            .fontSize(20)
            .height(50)
            .margin({})
            .textAlign(TextAlign.Center)
            .fontWeight(FontWeight.Bold)


          Checkbox({ name: this.getResourceString('Do_you_want_to_enable'), group: 'ssl' })
            .height(40)
            .select(false)
            .onClick((event) => {
              this.showToast(this.getResourceString('only_SMTP_support_is_required_no_SMTPS_support_is_needed'))
            })
            .enabled(false)
            .margin({ left: 10 })
            .selectedColor(Color.Blue)
            .onChange((value) => {
              this.secure = value
            })
        }
        .margin({ left: 15, top: 20 })

        Flex({ justifyContent: FlexAlign.Start, direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
          Button($r('app.string.login'))
            .margin(20)
            .width('80%')
            .height(50)
            .backgroundColor(Color.Blue)
            .fontColor(Color.White)
            .onClick(() => {
              this.login()
            })

          Button($r('app.string.Log_out'))
            .margin(20)
            .width('80%')
            .height(50)
            .visibility(this.isLogin ? Visibility.Visible : Visibility.Hidden)
            .backgroundColor(Color.Blue)
            .fontColor(Color.White)
            .onClick(() => {
              this.loginOut()
            })
        }
        .margin({ left: 15, top: 20 })

        Flex({ justifyContent: FlexAlign.Start, direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
          Text($r('app.string.Check_the_capability_of_the_server'))
            .margin(20)
            .width('80%')
            .height(50)
            .visibility(this.isLogin ? Visibility.Visible : Visibility.Hidden)
            .backgroundColor(Color.Blue)
            .fontColor(Color.White)
            .bindMenu(this.MailMenu)

          Button($r('app.string.Jump_to_folder_list'))
            .margin(20)
            .width('80%')
            .height(50)
            .visibility(this.isLogin ? Visibility.Visible : Visibility.Hidden)
            .backgroundColor(Color.Blue)
            .fontColor(Color.White)
            .onClick(() => {
              this.jumpIntoFolder()
            })
        }
        .margin({ left: 15, top: 20 })
      }
    }
    .width('100%')

  }

  async login() {
    const ctx = this;
    try {
      ctx.showToast(this.getResourceString('Start_logging_in_to_your_account'), 'login-imap')
      let hostParam = ctx.mailType.substring(ctx.mailType.indexOf('@') + 1, ctx.mailType.indexOf('.'))
      let loginOption: LoginOption = new LoginOption();
      if (!GlobalObj?.getInstance()?.getClient()) {
        if (ctx.secure) {
          let context: Context | null = GlobalObj?.getInstance()?.getContext() ? GlobalObj?.getInstance()?.getContext() : getContext()
          if (!context) {
            return
          }
          let ca0Data = await context?.resourceManager?.getRawFileContent('QQMailMiddle.pem')
          if (!ca0Data) {
            return
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
          loginOption.hostParam = hostParam;
          loginOption.secure = ctx.secure;
          loginOption.tlsOption = ctx.option;
          loginOption.mailType = ctx.mailType;

        } else {
          loginOption.account = ctx.account;
          loginOption.password = ctx.password;
          loginOption.hostParam = hostParam;
          loginOption.secure = ctx.secure;
          loginOption.tlsOption = null;
          loginOption.mailType = ctx.mailType;
        }
      }
      this.util?.login(loginOption, () => {
        ctx.isLogin = true;
        ctx.showToast(this.getResourceString('ready_to_jump_to_the_email_folder_list'), 'login-imap')
      }, (err: Error) => {
        console.log(err.message);
      }, () => {
        console.log('Connection ended');
      })
      ctx.showToast(this.getResourceString('Server_connection_successful'), 'login-imap')
    } catch (err) {
      ctx.showToast(this.getResourceString('Account_login_error') + `：${err.message}`, 'login-smtp')
    }
  }

  loginOut() {
    const ctx = this;
    try {
      ctx.showToast(this.getResourceString('Starting_to_log_out'), 'loginOut-imap')
      if (GlobalObj?.getInstance()?.getClient()) {
        GlobalObj?.getInstance()?.getClient()?.end(() => {
          ctx.showToast(this.getResourceString('Login_successfully_logged_out'), 'loginOut-imap')
          router.clear()
          router.pushUrl({
            url: 'pages/Index"'
          })
        });

      } else {
        ctx.showToast(this.getResourceString('Login_failed_client_object_is_empty'), 'loginOut-imap')
        router.clear()
        router.pushUrl({
          url: 'pages/Index"'
        })
      }
    } catch (err) {
      ctx.showToast(this.getResourceString('Login_error_occurred_while_logging_out') + `：${err.message}`, 'loginOut-smtp')
    }
  }

  checkServerCapability() {
    if (this.isLogin) {
      let checkResult: boolean | undefined = GlobalObj?.getInstance()?.getClient()?.serverSupports(this.capability);
      this.showToast(this.getResourceString('Does_the_server_capability_support_it') + `-${this.capability},`+ this.getResourceString('The_result_is') +`：${checkResult}`, 'checkServerCapability-smtp')
    } else {
      this.showToast(this.getResourceString('Error_checking_server_capability'), 'checkServerCapability-smtp')
    }
  }

  jumpIntoFolder() {
    if (this.isLogin) {
      router.pushUrl({
        url: 'pages/FolderPage'
      })
    } else {
      this.showToast(this.getResourceString('Client_not_logged_in'), 'jumpIntoFolder-smtp')
    }
  }

  getResourceString(resourceName:string) {
    return getContext().resourceManager.getStringByNameSync(resourceName)
  }
}