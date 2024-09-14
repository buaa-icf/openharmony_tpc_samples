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
import router from '@ohos.router'
import { Message, MessageAttachment, MessageHeaders } from '@ohos/emailjs'
import fs from '@ohos.file.fs';
import GlobalObj from '../GlobalObj'

const BASE_COUNT = 1

@Entry
@Component
struct SendBigAttachmentPage {
  @State message: string = 'Hello World'
  @State from: string = ''
  @State accountName: string = 'OH email client'
  @State to: string = 'xxx@qq.com'
  @State cc: string = 'xxx@163.com'
  @State bcc: string = 'xxx@139.com'
  @State subject: string = 'This is the OH testing topic'
  @State content: string = 'This is the text of the OpenHarmony email for testing. The format for the recipient, cc, and confidential cc of the email is: someone<someone@your-email.com>, another<another@your-email.com> Multiple accounts are connected by commas in English.'
  @State bigFileInfo: string = 'No attachments available at the moment'
  @State bigFileName: string = ''
  @State attachment: Array<MessageAttachment> = []
  @State mailType: string = '@qq.com'
  @State textValue: string = ''
  @State inputValue: string = 'click me'

  aboutToDisappear() {
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

  aboutToAppear() {
    let params = router.getParams()
    let temp = params as Record<string, Object>
    if (temp && temp['sendCount'] && typeof temp['sendCount'] === 'string') {
      this.from = temp['sendCount'];
    }
  }

  build() {
    Row() {
      Column() {
        Scroll() {
          Flex({
            alignItems: ItemAlign.Center,
            justifyContent: FlexAlign.Center,
            alignContent: FlexAlign.Center,
            direction: FlexDirection.Column
          }) {
            Text('Add information, send email')
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
              Text(`From (${this.from}) nickname：`)
                .fontSize(20)
                .height(50)
                .textAlign(TextAlign.Center)
                .margin({ right: 5 })

              TextInput({ placeholder: 'Please enter sender nickname', text: this.accountName })
                .layoutWeight(1)
                .fontSize(20)
                .height(50)
                .borderWidth(2)
                .textAlign(TextAlign.Start)
                .borderColor(Color.Gray)
                .type(InputType.Normal)
                .onChange((data) => {
                  this.accountName = data
                })
            }
            .height(100)
            .margin({ top: 10, right: 10 })

            Flex({
              alignItems: ItemAlign.Start,
              justifyContent: FlexAlign.Start,
              alignContent: FlexAlign.Start,
              direction: FlexDirection.Row
            }) {
              Text('Recipient：')
                .fontSize(20)
                .height(50)
                .textAlign(TextAlign.Center)
                .margin({ right: 5 })

              TextInput({
                placeholder: 'Format: xx<xx@yxx.com>, xx<xx@yxx.com> Multiple accounts are connected by commas in English.',
                text: this.to
              })
                .layoutWeight(1)
                .fontSize(20)
                .height(50)
                .borderWidth(2)
                .textAlign(TextAlign.Start)
                .borderColor(Color.Gray)
                .type(InputType.Normal)
                .onChange((data) => {
                  this.to = data
                })

            }.margin({ right: 10 })

            Flex({
              alignItems: ItemAlign.Start,
              justifyContent: FlexAlign.Start,
              alignContent: FlexAlign.Start,
              direction: FlexDirection.Row
            }) {
              Text('Email CC：')
                .fontSize(20)
                .height(50)
                .textAlign(TextAlign.Center)
                .margin({ right: 5 })

              TextInput({
                placeholder: 'Format: xx<xx@yxx.com>, xx<xx@yxx.com> Multiple accounts are connected by commas in English.',
                text: this.cc
              })
                .layoutWeight(1)
                .fontSize(20)
                .height(50)
                .borderWidth(2)
                .textAlign(TextAlign.Start)
                .borderColor(Color.Gray)
                .type(InputType.Normal)
                .onChange((data) => {
                  this.cc = data
                })
            }.margin({ top: 10, right: 10 })

            Flex({
              alignItems: ItemAlign.Start,
              justifyContent: FlexAlign.Start,
              alignContent: FlexAlign.Start,
              direction: FlexDirection.Row
            }) {
              Text('BCC Blind Carbon Copy：')
                .fontSize(20)
                .height(50)
                .textAlign(TextAlign.Center)
                .margin({ right: 5 })

              TextInput({
                placeholder: 'Format: xx<xx@yxx.com>, xx<xx@yxx.com> Multiple accounts are connected by commas in English.',
                text: this.bcc
              })
                .layoutWeight(1)
                .fontSize(20)
                .height(50)
                .borderWidth(2)
                .textAlign(TextAlign.Center)
                .borderColor(Color.Gray)
                .type(InputType.Normal)
                .onChange((data) => {
                  this.bcc = data
                })

            }.margin({ top: 10, right: 10 })


            Flex({
              alignItems: ItemAlign.Start,
              justifyContent: FlexAlign.Start,
              alignContent: FlexAlign.Start,
              direction: FlexDirection.Row
            }) {
              Text('Theme：')
                .fontSize(20)
                .height(50)
                .textAlign(TextAlign.Center)
                .margin({ right: 5 })

              TextInput({ placeholder: 'Please enter the email subject', text: this.subject })
                .layoutWeight(1)
                .fontSize(20)
                .height(50)
                .borderWidth(2)
                .textAlign(TextAlign.Start)
                .borderColor(Color.Gray)
                .type(InputType.Normal)
                .onChange((data) => {
                  this.subject = data
                })
            }
            .margin({ top: 10, right: 10 })

            Flex({
              alignItems: ItemAlign.Start,
              justifyContent: FlexAlign.Start,
              alignContent: FlexAlign.Start,
              direction: FlexDirection.Column
            }) {
              Text('Body：')
                .fontSize(20)
                .height(50)
                .textAlign(TextAlign.Center)
                .margin({ right: 5 })

              TextInput({
                placeholder: 'Please enter the email body',
                text: this.content
              })
                .layoutWeight(1)
                .fontSize(20)
                .height(100)
                .margin({ left: 5, right: 5 })
                .borderWidth(2)
                .textAlign(TextAlign.Start)
                .borderColor(Color.Gray)
                .type(InputType.Normal)
                .onChange((data) => {
                  this.content = data
                })
            }
            .height(160)
            .margin({ top: 10, right: 10 })

            Text('Large attachments need to be manually pushed into the device sandbox, and only the first one should be selected from multiple large attachments')
              .fontSize(20)
              .height(50)
              .textAlign(TextAlign.Center)
              .margin({ right: 5 })

            Flex({
              alignItems: ItemAlign.Start,
              justifyContent: FlexAlign.Start,
              alignContent: FlexAlign.Start,
              direction: FlexDirection.Row
            }) {
              Button('Add large attachment')
                .fontSize(20)
                .height(50)
                .onClick(() => {
                  this.addBigFile()
                })
                .margin({ right: 5 })

              Text(this.bigFileInfo)
                .fontSize(20)
                .height(50)
                .visibility(this.bigFileName && this.bigFileName.length > 0 ? Visibility.Visible : Visibility.None)
                .textAlign(TextAlign.Center)
                .margin({ right: 5 })

            }.margin({ right: 10 })

            Button('Send mail')
              .margin(20)
              .width('80%')
              .height(50)
              .backgroundColor(Color.Blue)
              .fontColor(Color.White)
              .onClick(() => {
                this.sendMail()
              })
              .margin({ top: 10 })
          }
        }.width('100%')
        .height('100%')
      }
      .width('100%')
    }
    .height('100%')
  }

  async sendMail() {
    try {
      this.mailType = this.to.substring(this.to.lastIndexOf('@' + 1), this.to.lastIndexOf('.'))
      if (GlobalObj?.getInstance()?.getClient()) {
        if (GlobalObj?.getInstance()?.getClient()?.isLogin()) {
          GlobalObj?.getInstance()?.getClient()?.setQuitAfterSendDone(true) // 设置发送完毕之后客户端是否退出 源库逻辑默认退出
          let msg: Message | MessageHeaders = {
            text: this.content,
            from: `${this.accountName} <${this.from}>`,
            to: this.to,
            cc: this.cc,
            bcc: this.bcc,
            subject: this.subject,
            attachment: this.attachment
          }
          let startTime1 = new Date().getTime();
          const message = await GlobalObj?.getInstance()?.getClient()?.sendAsync(msg)
          let endTime1 = new Date().getTime();
          let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
          console.log("sendAsync averageTime : " + averageTime1 + "us")
          this.showToast('Email sent successfully', 'sendmail-smtp')
          if (GlobalObj?.getInstance()?.getClient()?.isQuitAfterSendDone()) {
            GlobalObj?.getInstance()?.getClient()?.close(true);
            GlobalObj?.getInstance()?.setClient(null);
          }
        } else {
          this.showToast('Account not logged in, please login again', 'sendmail-smtp')
        }

      } else {
        this.showToast('Account not logged in, please login again', 'sendmail-smtp')
      }

    } catch (err) {
      this.showToast(`Email sending error：${err.message}`, 'sendmail-smtp')
    }
  }

  addBigFile() {
    const ctx = this
    try {
      ctx.bigFileName = ''
      ctx.bigFileInfo = 'No attachments available at the moment'
      ctx.showToast('Start detecting large attachments in the cache directory', 'createSingleFile')
      let context = GlobalObj?.getInstance()?.getContext() ? GlobalObj?.getInstance()?.getContext() : getContext()
      if (!context) {
        return;
      }
      let fileDir = context?.cacheDir
      let fileList = fs.listFileSync(fileDir)
      if (!fileList || fileList.length < 1) {
        ctx.showToast('Please push in the large attachment first', 'addBigFile-imapclient')
        return
      }
      for (let i = 0; i < fileList.length; i++) {
        if (fileList[i] && fileList[i].length > 0) {
          ctx.bigFileName = fileList[i];
          break;
        }
      }
      let filePath = fileDir + '/' + ctx.bigFileName
      let stat = fs.statSync(filePath)
      ctx.bigFileInfo = `Attachment Name：${ctx.bigFileName}, Attachment size：${stat.size}`
      let index = ctx.bigFileName.indexOf('.')
      let fileType = ctx.bigFileName.substring(index + 1, ctx.bigFileName.length)

      let attach: MessageAttachment = {
        name: ctx.bigFileName,
        path: filePath,
        type: fileType,
        size: stat.size
      }
      this.attachment.push(attach)
      ctx.showToast(`Obtain the large attachment  ${ctx.bigFileName}`, 'addBigFile-imapclient')
    } catch (err) {
      ctx.showToast('Please push in the large attachment first', 'addBigFile-imapclient')
    }
  }

  isImage(type: string): boolean {
    if (!type || type.length < 1) {
      return false;
    }
    let imageTypeArr = ['webp', 'bmp', 'pcx', 'tif', 'jpeg', 'tga', 'exif',
      'fpx', 'svg', 'psd', 'cdr', 'pcd', 'dxf', 'ufo', 'eps', 'jpg',
      'ai', 'png', 'hdri', 'raw', 'wmf', 'flic', 'emf', 'ico']
    if (imageTypeArr.indexOf(type.toLowerCase()) != -1) {
      return true;
    } else {
      return false;
    }
  }

  isDOC(type: string): boolean {
    if (!type || type.length < 1) {
      return false;
    }
    let docTypeArr = ['doc', 'docx']
    if (docTypeArr.indexOf(type.toLowerCase()) != -1) {
      return true;
    } else {
      return false;
    }
  }

  isExcel(type: string): boolean {
    if (!type || type.length < 1) {
      return false;
    }
    let excelTypeArr = ['xlsx', 'xls', 'csv']
    if (excelTypeArr.indexOf(type.toLowerCase()) != -1) {
      return true;
    } else {
      return false;
    }
  }

  onBackPress() {
    GlobalObj?.getInstance()?.getContext()?.terminateSelf()
  }
}