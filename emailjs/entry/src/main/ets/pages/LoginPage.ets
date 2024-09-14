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
      Text('Please enter email type').fontSize(20).margin({ top: 10, bottom: 10 }).width('90%')
      TextInput({ placeholder: '', text: this.textValue }).height(60).width('90%')
        .onChange((value: string) => {
          this.textValue = value;
        })
      Text('Tips:Please enter the email type in the correct format, such as @qq.com or @163.com')
        .margin({ top: 10, bottom: 10 })
        .width('90%')
        .fontSize(8)
        .fontColor(Color.Red)
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('Cancel')
          .onClick(() => {
            this.controller.close()
            this.cancel()
          })
        Button('Confirm')
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
        this.showToast(`The dialog box has been closed, and the option to enter a different type of email has been unselected`, 'mailType-cancel')
      },
      confirm: () => {
        if (!this.inputValue || this.inputValue.length < 1) {
          this.showToast(`Email type cannot be empty`, 'mailType-confirm')
          return
        }
        if (this.inputValue.indexOf('@') == -1 && this.inputValue.indexOf('@') != this.inputValue.lastIndexOf('@')) {
          this.showToast(`Email type must contain one @ and can only contain one @`, 'mailType-confirm')
          return
        }
        if (this.inputValue.indexOf('.') == -1 && this.inputValue.indexOf('.') != this.inputValue.lastIndexOf('.')) {
          this.showToast(`The email type must contain a, And it can only contain one.`, 'mailType-confirm')
          return
        }
        if (this.inputValue.indexOf('@') != -1 && this.inputValue.indexOf('.') != -1 && this.inputValue.indexOf('@') > this.inputValue.indexOf('.')) {
          this.showToast(`In email types, @ needs to be before., such as @qq.com, @163.com, etc`, 'mailType-confirm')
          return
        }
        if (this.inputValue.indexOf('@') - this.inputValue.indexOf('.') == 1) {
          this.showToast(`Except for @ and. in email types, Must contain other characters`, 'mailType-confirm')
          return
        }
        if (this.inputValue.indexOf('@') != 0) {
          this.showToast(`@ must be first in the email type`, 'mailType-confirm')
          return
        }
        this.mailType = this.inputValue
        this.showToast(`Enter other types of email addresses：${this.mailType}`, 'mailType-confirm')
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
        Text('Click on the email after the account to switch email types')
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
          Text('Account：')
            .fontSize(20)
            .height(50)
            .textAlign(TextAlign.Center)
            .margin({ right: 5 })

          TextInput({ placeholder: 'Please enter your account', text: 'xxx' })
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
          Text('Password/Authorization Code：')
            .fontSize(20)
            .height(50)
            .textAlign(TextAlign.Center)
            .margin({ right: 5 })

          TextInput({ placeholder: 'Please enter password/Authorization code', text: 'xxx' })
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
          Text('Do you want to enable SSL/TLS (currently only supporting SMTP, not SMTPS, this button is temporarily unavailable)')
            .fontSize(20)
            .height(50)
            .margin({})
            .textAlign(TextAlign.Center)
            .fontWeight(FontWeight.Bold)


          Checkbox({ name: 'Do you want to enable SSL/TLS', group: 'ssl' })
            .height(40)
            .select(false)
            .onClick((event) => {
              this.showToast('Currently, only SMTP support is required, no SMTPS support is needed')
            })
            .enabled(false)
            .margin({ left: 10 })
            .selectedColor(Color.Blue)
            .onChange((value) => {
              this.secure = value
            })
        }
        .margin({ left: 15, top: 20 })

        Button('Skip ordinary attachments')
          .margin(20)
          .width('80%')
          .height(50)
          .backgroundColor(Color.Blue)
          .fontColor(Color.White)
          .onClick(() => {
            this.login()
          })
        Button('Jump to large attachments')
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
          let context: Context | null = GlobalObj?.getInstance()?.getContext() ? GlobalObj?.getInstance()?.getContext() : getContext(this)
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
              this.showToast('Account login successful', 'login-smtp')
              router.pushUrl({
                url: 'pages/SendMailPage',
                params: {
                  sendCount: ctx.account + ctx.mailType
                }
              })
            } else {
              this.showToast('Account login failed', 'login-smtp')
            }
          })
        } else {
          this.showToast('Account already logged in, no need to login again', 'login-smtp')
        }

      }
    } catch (err) {
      this.showToast(`Account login error：${err.message}`, 'login-smtp')
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
          let context: Context | null = GlobalObj?.getInstance()?.getContext() ? GlobalObj?.getInstance()?.getContext() : getContext(this)
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
              this.showToast('Account login successful', 'login-smtp')
              router.pushUrl({
                url: 'pages/SendBigAttachmentPage',
                params: {
                  sendCount: ctx.account + ctx.mailType
                }
              })
            } else {
              this.showToast('Account login failed', 'login-smtp')
            }
          })
        } else {
          this.showToast('Account already logged in, no need to login again', 'login-smtp')
        }

      }
    } catch (err) {
      this.showToast(`Account login error：${err.message}`, 'login-smtp')
    }
  }
}