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
import { AUTH_METHODS, SMTPClient } from '@ohos/emailjs'
import promptAction from '@ohos.promptAction'
import router from '@ohos.router'
import socket from '@ohos.net.socket'
import GlobalObj from '../GlobalObj'

const BASE_COUNT = 1

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
      Text($r('app.string.Please_enter_email_type')).fontSize(20).margin({ top: 10, bottom: 10 }).width('90%')
      TextInput({ placeholder: '', text: this.textValue }).height(60).width('90%')
        .onChange((value: string) => {
          this.textValue = value;
        })
      Text($r('app.string.Tips_Please_enter_the_email_type_in_the_correct_format_such_as_email'))
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
  @State account: string = 'xxx'
  @State pwd: string = 'xxx'
  @State mailType: string = '@qq.com'
  @State textValue: string = ''
  @State inputValue: string = 'click me'
  @State secure: boolean = false
  dialogController: CustomDialogController | null = new CustomDialogController({
    builder: CustomDialogDiy({
      cancel: () => {
        this.showToast(this.getResourceString('The_dialog_box_has_been_closed_and_the_option_to_enter_a_different_type_of_email_has_been_unselected'), 'mailType-cancel')
      },
      confirm: () => {
        if (!this.inputValue || this.inputValue.length < 1) {
          this.showToast(this.getResourceString('Email_type_cannot_be_empty'), 'mailType-confirm')
          return
        }
        if (this.inputValue.indexOf('@') == -1 && this.inputValue.indexOf('@') != this.inputValue.lastIndexOf('@')) {
          this.showToast(this.getResourceString('Email_type_must_contain_one_and_can_only_contain_one'), 'mailType-confirm')
          return
        }
        if (this.inputValue.indexOf('.') == -1 && this.inputValue.indexOf('.') != this.inputValue.lastIndexOf('.')) {
          this.showToast(this.getResourceString('The_email_type_must_contain_a_And_it_can_only_contain_one'), 'mailType-confirm')
          return
        }
        if (this.inputValue.indexOf('@') != -1 && this.inputValue.indexOf('.') != -1 && this.inputValue.indexOf('@') > this.inputValue.indexOf('.')) {
          this.showToast(this.getResourceString('In_email_types_needs_to_be_before_such_as_mail'), 'mailType-confirm')
          return
        }
        if (this.inputValue.indexOf('@') - this.inputValue.indexOf('.') == 1) {
          this.showToast(this.getResourceString('Except_for_and_in_email_types_Must_contain_other_characters'), 'mailType-confirm')
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
    GlobalObj?.getInstance()?.getClient()?.close(true);
  }

  showToast(text: string, name = 'test') {
    console.log(`zdy---${name}--->${text}`)
    this.getUIContext().getPromptAction().showToast({
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
      MenuItem({ content: 'other', labelInfo: 'other' })
        .onChange((selected) => {
          if (selected) {
            if (this.dialogController) {
              this.dialogController.open()
            }
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
          Text($r('app.string.Account'))
            .fontSize(20)
            .height(50)
            .textAlign(TextAlign.Center)
            .margin({ right: 5 })

          TextInput({ placeholder: $r('app.string.Please_enter_your_account'), text: 'xxx' })
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

          TextInput({ placeholder: $r('app.string.Please_enter_password_Authorization_code'), text: 'xxx' })
            .layoutWeight(1)
            .fontSize(20)
            .height(50)
            .borderWidth(2)
            .textAlign(TextAlign.Center)
            .borderColor(Color.Gray)
            .type(InputType.Normal)
            .margin({ right: 15 })
            .onChange((data) => {
              this.pwd = data
            })
        }
        .margin({ left: 15, top: 20 })

        Flex({ justifyContent: FlexAlign.Start, direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
          Text($r('app.string.Do_you_want_to_enable_SSL_TLS_tip'))
            .fontSize(20)
            .height(50)
            .margin({})
            .textAlign(TextAlign.Center)
            .fontWeight(FontWeight.Bold)

          Checkbox({ name: this.getResourceString('Do_you_want_to_enable_SSL_TLS'), group: 'ssl' })
            .height(40)
            .select(false)
            .onClick((event) => {
              this.showToast(this.getResourceString('Currently_only_SMTP_support_is_required_no_SMTPS_support_is_needed'))
            })
            .enabled(false)
            .margin({ left: 10 })
            .selectedColor(Color.Blue)
            .onChange((value) => {
              this.secure = value
            })
        }
        .margin({ left: 15, top: 20 })

        Button($r('app.string.Skip_ordinary_attachments'))
          .margin(20)
          .width('80%')
          .height(50)
          .backgroundColor(Color.Blue)
          .fontColor(Color.White)
          .onClick(() => {
            this.login()
          })
        Button($r('app.string.Jump_to_large_attachments'))
          .margin(20)
          .width('80%')
          .height(50)
          .backgroundColor(Color.Blue)
          .fontColor(Color.White)
          .onClick(() => {
            this.loginBigAttachment()
          })
      }
    }
    .width('100%')

  }

  async login() {
    const ctx = this;
    try {
      let hostParam = this.mailType.substring(this.mailType.indexOf('@') + 1, this.mailType.indexOf('.'))
      if (!GlobalObj?.getInstance()?.getClient()) {
        let client: SMTPClient | null = new SMTPClient({});
        if (this.secure) {
          let option: socket.TLSConnectOptions = {
            ALPNProtocols: ["spdy/1", "http/1.1"],
            address: {
              address: `smtp.${hostParam}.com`,
              port: 465,
              family: 1
            },
            secureOptions: {
              key: '',
              cert: '',
              ca: [''],
              useRemoteCipherPrefer: true,
            }
          }
          let context: Context | null = GlobalObj?.getInstance()?.getContext() ? GlobalObj?.getInstance()?.getContext() : this.getUIContext().getHostContext()!
          if (!context) {
            return
          }

          let ca0Data = await context?.resourceManager?.getRawFileContent('QQMailMiddle.pem')
          if (!ca0Data) {
            return
          }
          let ca0: string = '';
          for (let i = 0; i < ca0Data.length; i++) {
            let todo = ca0Data[i]
            let item = String.fromCharCode(todo);
            ca0 += item;
          }
          if (option.secureOptions.ca instanceof Array) {
            option.secureOptions.ca[0] = ca0;
          } else {
            option.secureOptions.ca = ca0;
          }

          let ca1Data = await context.resourceManager.getRawFileContent('QQMailRoot.pem')
          let ca1 = '';
          for (let i = 0; i < ca1Data.length; i++) {
            let todo = ca1Data[i]
            let item = String.fromCharCode(todo);
            ca1 += item;
          }
          if (option.secureOptions.ca instanceof Array) {
            option.secureOptions.ca[1] = ca1;
          } else {
            option.secureOptions.ca = ca1;
          }
          let startTime1 = new Date().getTime();
          client = new SMTPClient({
            user: this.account + this.mailType,
            password: this.pwd,
            host: `smtp.${hostParam}.com`,
            port: 465,
            timeout: 30000,
            authentication: [AUTH_METHODS.LOGIN],
            ssl: option,
            tls: undefined
          });
          let endTime1 = new Date().getTime();
          let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
          console.log("new SMTPClient averageTime : " + averageTime1 + "us")
        } else {
          let startTime1 = new Date().getTime();
          client = new SMTPClient({
            user: this.account + this.mailType,
            password: this.pwd,
            host: `smtp.${hostParam}.com`,
            port: 25,
            timeout: 30000,
            authentication: [AUTH_METHODS.LOGIN],
            ssl: false,
            tls: undefined
          });
          let endTime1 = new Date().getTime();
          let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
          console.log("new SMTPClient averageTime : " + averageTime1 + "us")
        }
        GlobalObj?.getInstance()?.setClient(client)
      }
      if (GlobalObj?.getInstance()?.getClient()) {
        if (GlobalObj?.getInstance()?.getClient()?.isLogin() === false) {
          GlobalObj?.getInstance()?.getClient()?.login((err, result) => {
            if (!err && result == true) {
              this.showToast(this.getResourceString('Account_login_successful'), 'login-smtp')
              this.getUIContext().getRouter().pushUrl({
                url: 'pages/SendMailPage',
                params: {
                  sendCount: ctx.account + ctx.mailType
                }
              })
            } else {
              this.showToast(this.getResourceString('Account_login_failed'), 'login-smtp')
            }
          })
        } else {
          this.showToast(this.getResourceString('Account_already_logged_in_no_need_to_login_again'), 'login-smtp')
        }

      }
    } catch (err) {
      this.showToast(this.getResourceString('Account_login_error') + `：${err.message}`, 'login-smtp')
    }
  }

  async loginBigAttachment() {
    const ctx = this;
    try {
      let hostParam = this.mailType.substring(this.mailType.indexOf('@') + 1, this.mailType.indexOf('.'))
      if (!GlobalObj?.getInstance()?.getClient()) {
        let client: SMTPClient | null = null;
        if (this.secure) {
          let option: socket.TLSConnectOptions = {
            ALPNProtocols: ["spdy/1", "http/1.1"],
            address: {
              address: `smtp.${hostParam}.com`,
              port: 465,
              family: 1
            },
            secureOptions: {
              key: '',
              cert: '',
              ca: [''],
              useRemoteCipherPrefer: true,
            }
          }
          let context: Context | null = GlobalObj?.getInstance()?.getContext() ? GlobalObj?.getInstance()?.getContext() : this.getUIContext().getHostContext()!
          if (!context) {
            return
          }
          let ca0Data = await context?.resourceManager.getRawFileContent('QQMailMiddle.pem')
          if (!ca0Data) {
            return
          }
          let ca0 = '';
          for (let i = 0; i < ca0Data.length; i++) {
            let todo = ca0Data[i]
            let item = String.fromCharCode(todo);
            ca0 += item;
          }
          if (option.secureOptions.ca instanceof Array) {
            option.secureOptions.ca[0] = ca0;
          } else {
            option.secureOptions.ca = ca0;
          }

          let ca1Data = await context.resourceManager.getRawFileContent('QQMailRoot.pem')
          let ca1 = '';
          for (let i = 0; i < ca1Data.length; i++) {
            let todo = ca1Data[i]
            let item = String.fromCharCode(todo);
            ca1 += item;
          }
          if (option.secureOptions.ca instanceof Array) {
            option.secureOptions.ca[1] = ca1;
          } else {
            option.secureOptions.ca = ca1;
          }
          let startTime1 = new Date().getTime();
          client = new SMTPClient({
            user: this.account + this.mailType,
            password: this.pwd,
            host: `smtp.${hostParam}.com`,
            port: 465,
            timeout: 30000,
            authentication: [AUTH_METHODS.LOGIN],
            ssl: option,
            tls: undefined
          });
          let endTime1 = new Date().getTime();
          let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
          console.log("new SMTPClient averageTime : " + averageTime1 + "us")
        } else {
          let startTime1 = new Date().getTime();
          client = new SMTPClient({
            user: this.account + this.mailType,
            password: this.pwd,
            host: `smtp.${hostParam}.com`,
            port: 25,
            timeout: 30000,
            authentication: [AUTH_METHODS.LOGIN],
            ssl: false,
            tls: undefined
          });
          let endTime1 = new Date().getTime();
          let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
          console.log("new SMTPClient averageTime : " + averageTime1 + "us")
        }
        GlobalObj?.getInstance()?.setClient(client)
      }
      if (GlobalObj?.getInstance()?.getClient()) {
        if (GlobalObj?.getInstance()?.getClient()?.isLogin() === false) {
          GlobalObj?.getInstance()?.getClient()?.login((err, result) => {
            if (!err && result == true) {
              this.showToast(this.getResourceString('Account_login_successful'), 'login-smtp')
              this.getUIContext().getRouter().pushUrl({
                url: 'pages/SendBigAttachmentPage',
                params: {
                  sendCount: ctx.account + ctx.mailType
                }
              })
            } else {
              this.showToast(this.getResourceString('Account_login_failed'), 'login-smtp')
            }
          })
        } else {
          this.showToast(this.getResourceString('Account_already_logged_in_no_need_to_login_again'), 'login-smtp')
        }

      }
    } catch (err) {
      this.showToast(this.getResourceString('Account_login_error') + `：${err.message}`, 'login-smtp')
    }
  }

  getResourceString(resourceName:string) {
    return this.getUIContext().getHostContext()!.resourceManager.getStringByNameSync(resourceName)
  }
}