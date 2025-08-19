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
struct SendMailPage {
  @State message: string = 'Hello World'
  @State from: string = ''
  @State accountName: string = this.getResourceString('OH_email_client')
  @State to: string = 'xxx@qq.com'
  @State cc: string = 'xxx@163.com'
  @State bcc: string = 'xxx@139.com'
  @State subject: string = this.getResourceString('This_is_the_OH_testing_topic')
  @State content: string = this.getResourceString('This_is_the_text_of_the_OpenHarmony_email_for_testing')
  @State attachment: Array<MessageAttachment> = []
  @State mailType: string = '@qq.com'
  @State textValue: string = ''
  @State inputValue: string = 'click me'

  aboutToDisappear() {
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

  aboutToAppear() {
    let params = this.getUIContext().getRouter().getParams()
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
            Text($r('app.string.Add_information_send_email'))
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

              TextInput({ placeholder: $r('app.string.Please_enter_sender_nickname'), text: this.accountName })
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
              Text($r('app.string.Recipient'))
                .fontSize(20)
                .height(50)
                .textAlign(TextAlign.Center)
                .margin({ right: 5 })

              TextInput({
                placeholder: $r('app.string.Format'),
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
              Text($r('app.string.Email_CC'))
                .fontSize(20)
                .height(50)
                .textAlign(TextAlign.Center)
                .margin({ right: 5 })

              TextInput({
                placeholder: $r('app.string.Format'),
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
              Text($r('app.string.BCC_Blind_Carbon_Copy'))
                .fontSize(20)
                .height(50)
                .textAlign(TextAlign.Center)
                .margin({ right: 5 })

              TextInput({
                placeholder: $r('app.string.Format'),
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
              Text($r('app.string.Theme'))
                .fontSize(20)
                .height(50)
                .textAlign(TextAlign.Center)
                .margin({ right: 5 })

              TextInput({ placeholder: $r('app.string.Please_enter_the_email_subject'), text: this.subject })
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
              Text($r('app.string.Body'))
                .fontSize(20)
                .height(50)
                .textAlign(TextAlign.Center)
                .margin({ right: 5 })

              TextInput({
                placeholder: $r('app.string.Please_enter_the_email_body'),
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

            Flex({
              alignItems: ItemAlign.Center,
              justifyContent: FlexAlign.Start,
              alignContent: FlexAlign.Start,
              direction: FlexDirection.Row
            }) {
              Button($r('app.string.Add_attachment'))
                .fontSize(20)
                .height(50)
                .backgroundColor(Color.Blue)
                .margin({ right: 5 })
                .onClick((event) => {
                  this.createAttachment()
                })

              List({ space: 10, initialIndex: 0 }) {
                ForEach(this.attachment, (item: MessageAttachment, index: number) => {
                  ListItem() {
                    Flex({
                      alignItems: ItemAlign.Center,
                      justifyContent: FlexAlign.Center,
                      alignContent: FlexAlign.Center,
                      direction: FlexDirection.Row
                    }) {
                      if (item.type && item.type == 'txt') {
                        Image($r('app.media.txt'))
                          .width(40)
                          .height(40)
                          .margin({ left: 5, right: 5 })
                      } else if (item.type && this.isImage(item.type)) {
                        Image($r('app.media.image'))
                          .width(40)
                          .height(40)
                          .margin({ left: 5, right: 5 })
                      } else if (item.type && this.isDOC(item.type)) {
                        Image($r('app.media.word'))
                          .width(40)
                          .height(40)
                          .margin({ left: 5, right: 5 })
                      } else if (item.type && this.isExcel(item.type)) {
                        Image($r('app.media.excel'))
                          .width(40)
                          .height(40)
                          .margin({ left: 5, right: 5 })
                      } else {
                        Image($r('app.media.app_icon'))
                          .width(40)
                          .height(40)
                          .margin({ left: 5, right: 5 })
                      }

                      Flex({
                        alignItems: ItemAlign.Start,
                        justifyContent: FlexAlign.Center,
                        alignContent: FlexAlign.Start,
                        direction: FlexDirection.Column
                      }) {
                        Text(item.name)
                          .fontSize(14)
                          .textOverflow({ overflow: TextOverflow.Ellipsis })
                          .maxLines(1)
                          .width(100)
                          .padding({ left: 5, right: 5, top: 5 })
                          .maxLines(1)
                          .textAlign(TextAlign.Center)

                        Text(item.size + this.getResourceString('byte'))
                          .fontSize(14)
                          .width(100)
                          .textOverflow({ overflow: TextOverflow.Ellipsis })
                          .maxLines(1)
                          .padding({ left: 5, right: 5, top: 5, bottom: 5 })
                          .maxLines(1)
                          .textAlign(TextAlign.Center)
                      }
                    }
                  }
                  .borderWidth(2)
                  .borderColor(Color.Gray)
                }, (item: MessageAttachment, index: number) => item.name)
              }
              .edgeEffect(EdgeEffect.None)
              .chainAnimation(false)
              .layoutWeight(1)
              .height(100)
              .listDirection(Axis.Horizontal)
            }
            .margin({ top: 10 })


            Button(this.getResourceString('Send_mail'))
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
          this.showToast(this.getResourceString('Email_sent_successfully'), 'sendmail-smtp')
          if (GlobalObj?.getInstance()?.getClient()?.isQuitAfterSendDone()) {
            GlobalObj?.getInstance()?.getClient()?.close(true);
            GlobalObj?.getInstance()?.setClient(null);
          }
        } else {
          this.showToast(this.getResourceString('Account_not_logged_in_please_login_again'), 'sendmail-smtp')
        }

      } else {
        this.showToast(this.getResourceString('Account_not_logged_in_please_login_again'), 'sendmail-smtp')
      }

    } catch (err) {
      this.showToast(this.getResourceString('Email_sending_error') + `：${err.message}`, 'sendmail-smtp')
    }
  }

  createAttachment() {
    const ctx = this
    try {
      if (ctx.attachment && ctx.attachment.length == 0) {
        ctx.showToast(this.getResourceString('Start_generating_a_single_local_file'), 'createSingleFile')
        let context = GlobalObj?.getInstance()?.getContext() ? GlobalObj?.getInstance()?.getContext() : this.getUIContext().getHostContext()!
        let randomNum = Math.round(Math.random() * 1024 + 1);
        let filePath = context?.cacheDir + '/' + 'attachment-' + randomNum + '.txt'
        let file = fs.openSync(filePath, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE)
        let str = this.getResourceString('Please_check_the_information_sent_from_the_client_to_the_server') + "\r\n"
        fs.writeSync(file.fd, str)
        fs.fsyncSync(file.fd)
        fs.closeSync(file)
        let attach: MessageAttachment = {
          name: 'attachment-' + randomNum + '.txt',
          path: filePath,
          type: '.txt',
          size: str.length
        }
        this.attachment.push(attach)
        ctx.showToast(this.getResourceString('Successfully_generated_local_single_file') + filePath, 'createSingleFile')
      } else if (ctx.attachment && ctx.attachment.length == 1) {
        ctx.showToast(this.getResourceString('Start_generating_a_single_local_file'), 'createSingleFile')
        let context: Context | null = GlobalObj?.getInstance()?.getContext() ? GlobalObj?.getInstance()?.getContext() : this.getUIContext().getHostContext()!
        let filePath = context?.cacheDir + '/icon.png'
        context?.resourceManager?.getRawFileContent('icon.png')?.then((imageData) => {
          if (imageData) {
            let file = fs.openSync(filePath, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE)
            fs.writeSync(file.fd, imageData.buffer)
            fs.fsyncSync(file.fd)
            fs.closeSync(file)
            let attach: MessageAttachment = {
              name: 'icon.png',
              path: filePath,
              type: 'jpg',
              size: imageData.buffer.byteLength
            }
            this.attachment.push(attach)
          } else {
            ctx.showToast(this.getResourceString('Failed_to_generate_local_single_file') + ` ${'icon.png'} ` + filePath, 'createSingleFile')
          }
        })?.catch((err: Error) => {
          ctx.showToast(this.getResourceString('Failed_to_generate_local_single_file') + ` ${'icon.png'}`+ this.getResourceString('due_to') + `：${err.message}` + filePath, 'createSingleFile')
        })
        ctx.showToast(this.getResourceString('Successfully_generated_local_single_file') + filePath, 'createSingleFile')
      } else if (ctx.attachment && ctx.attachment.length == 2) {
        ctx.showToast(this.getResourceString('Start_generating_a_single_local_file'), 'createSingleFile')
        let context: Context | null = GlobalObj?.getInstance()?.getContext() ? GlobalObj?.getInstance()?.getContext() : this.getUIContext().getHostContext()!
        let filePath = context?.cacheDir + '/test.docx'
        context?.resourceManager?.getRawFileContent('test.docx')?.then((wordData) => {
          if (wordData) {
            let file = fs.openSync(filePath, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE)
            fs.writeSync(file.fd, wordData.buffer)
            fs.fsyncSync(file.fd)
            fs.closeSync(file)
            let attach: MessageAttachment = {
              name: 'test.docx',
              path: filePath,
              type: 'docx',
              size: wordData.buffer.byteLength
            }
            this.attachment.push(attach)
          } else {
            ctx.showToast(this.getResourceString('Failed_to_generate_local_single_file') + ` ${'test.docx'} ` + filePath, 'createSingleFile')
          }
        })?.catch((err: Error) => {
          ctx.showToast(this.getResourceString('Failed_to_generate_local_single_file') + ` ${'test.docx'}` + this.getResourceString('due_to') + `：${err.message}` + filePath, 'createSingleFile')
        })
        ctx.showToast(this.getResourceString('Successfully_generated_local_single_file') + filePath, 'createSingleFile')
      } else if (ctx.attachment && ctx.attachment.length == 3) {
        ctx.showToast(this.getResourceString('Start_generating_a_single_local_file'), 'createSingleFile')
        let context: Context | null = GlobalObj?.getInstance()?.getContext() ? GlobalObj?.getInstance()?.getContext() : this.getUIContext().getHostContext()!
        if (!context) {
          return
        }
        let filePath = context.cacheDir + '/test.xlsx'
        context.resourceManager.getRawFileContent('test.xlsx').then((excelData) => {
          if (excelData) {
            let file = fs.openSync(filePath, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE)
            fs.writeSync(file.fd, excelData.buffer)
            fs.fsyncSync(file.fd)
            fs.closeSync(file)
            let attach: MessageAttachment = {
              name: 'test.xlsx',
              path: filePath,
              type: 'xlsx',
              size: excelData.buffer.byteLength
            }
            this.attachment.push(attach)
          } else {
            ctx.showToast(this.getResourceString('Failed_to_generate_local_single_file') + ` ${'test.xlsx'} ` + filePath, 'createSingleFile')
          }
        }).catch((err: Error) => {
          ctx.showToast(this.getResourceString('Failed_to_generate_local_single_file') + ` ${'test. xlsx'}` + this.getResourceString('due_to') + `：${err.message}` + filePath, 'createSingleFile')
        })
        ctx.showToast(this.getResourceString('Successfully_generated_local_single_file') + filePath, 'createSingleFile')
      } else {
        ctx.showToast(this.getResourceString('Currently_only_supports_testing_text'), 'createSingleFile')

      }

    } catch (err) {
      ctx.showToast(this.getResourceString('Failed_to_generate_a_single_local_file') + JSON.stringify(err), 'createSingleFile')
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

  getResourceString(resourceName:string) {
    return this.getUIContext().getHostContext()!.resourceManager.getStringByNameSync(resourceName)
  }
}