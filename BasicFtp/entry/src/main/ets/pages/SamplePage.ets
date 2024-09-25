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

import NoTlsUtil from '../utils/FtpApiUtil'
import { AccessOptions, FileInfo, FileType, FTPResponse, UnixPermissions } from '@ohos/basic-ftp'
import fs from '@ohos.file.fs'
import buffer from '@ohos.buffer'
import socket from '@ohos.net.socket';
import promptAction from '@ohos.promptAction'
import { ToolType } from '@ohos.multimodalInput.touchEvent'
import GlobalObj from '../GlobalObj'

/**
 * tips:一旦调用setWorkingDirectory 设置了当前工作目录 远程地址remotePath只需要写文件名，否则会报错，仅限于操作本文件夹内的文件
 * 设置工作目录之前，remotePath = 'Users\\Administrator\\Desktop\\commonsNet\\ftp\\serverReceived.txt'
 * 设置工作目录之后 remotePath = 'serverReceived.txt'
 */
const TAG = 'zdy'

function getResourceString(res:Resource){
  return getContext().resourceManager.getStringSync(res.id)
}

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
      Text($r('app.string.enter_folder_name')).fontSize(20).margin({ top: 10, bottom: 10 }).width('90%')
      TextInput({ placeholder: '', text: this.textValue }).height(60).width('90%')
        .onChange((value: string) => {
          this.textValue = value;
        })
      Text($r('app.string.Tips'))
        .margin({ top: 10, bottom: 10 })
        .width('90%')
        .fontSize(8)
        .fontColor(Color.Red)
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button($r('app.string.cancel'))
          .onClick(() => {
            this.controller.close()
            this.cancel()
          })
        Button($r('app.string.ok'))
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
struct SamplePage {
  @State message: string = 'Hello World'
  @State secure: boolean = false;
  @State user: string = 'xxx';
  @State password: string = 'xxx';
  @State host: string = 'xxx';
  @State port: number = 21;
  @State secureOptions: socket.TLSConnectOptions | null = null;
  @State remoteRoot: string | null = null;
  @State currentFileList: FileInfo[] = [];
  @State localUploadFilePath: string | null = null;
  @State localUploadFileDir: string | null = null;
  @State localDownloadFilePath: string | null = null;
  @State localDownloadFileDir: string | null = null;
  @State selectFilePath: string | null = null;
  @State selectDirPath: string | null = null;
  @State isShowLog: boolean = false;
  @State isLogin: boolean = false;
  @State textValue: string = ''
  @State inputValue: string = 'click me'
  @State operationType: string = ''
  private ftpUtil: NoTlsUtil | null = null;
  private option: socket.TLSConnectOptions = {
    ALPNProtocols: ["spdy/1", "http/1.1"],
    address: {
      address: '',
      port: 50000,
      family: 1
    },
    secureOptions: {
      key: '',
      cert: '',
      ca: [''],
      password: '',
      protocols: [socket.Protocol.TLSv12, socket.Protocol.TLSv13],
      useRemoteCipherPrefer: true,
      signatureAlgorithms: "rsa_pss_rsae_sha256:ECDSA+SHA256",
      cipherSuite: "AES256-SHA256"
    }
  }
  dialogController: CustomDialogController | null = new CustomDialogController({
    builder: CustomDialogDiy({
      cancel: () => {
        this.showToast(getResourceString($r('app.string.Cancel_create_folder_on_server')), 'CustomDialogDiy-cancel')
      },
      confirm: () => {
        if (this.operationType === 'dir') {
          this.showToast(getResourceString($r('app.string.Create_folder_on_server')), 'CustomDialogDiy-cancel')
          this.ensureRemotePath()
        } else if (this.operationType === 'rename') {
          this.showToast(getResourceString($r('app.string.Create_folder_on_server')), 'CustomDialogDiy-cancel')
          this.renameFile()
        } else if (this.operationType === 'uploadSingleFile') {
          this.uploadSingleFile()
        } else if (this.operationType === 'uploadDir') {
          this.uploadDir()
        } else {
          this.showToast(getResourceString($r('app.string.Unknown_operation')), 'CustomDialogDiy-unknow')
        }

      },
      textValue: $textValue,
      inputValue: $inputValue
    }),
    autoCancel: true,
    customStyle: false
  })

  @Builder
  SubMenu() {
    Menu() {
      MenuItem({ content: $r('app.string.Get_working_directory'), labelInfo: 'getCurrentDirectory' })
        .onChange((selected) => {
          if (selected) {
            this.getCurrentDirectory()
          }
        })

      MenuItem({ content: $r('app.string.Go_Back'), labelInfo: 'back' })
        .onChange((selected) => {
          if (selected) {
            this.backToParent()
          }
        })

      MenuItem({ content: $r('app.string.Get_File_Size'), labelInfo: 'getFileSize' })
        .onChange((selected) => {
          if (selected) {
            this.getFileSize()
          }
        })


      MenuItem({ content: $r('app.string.Get_last_modification_time'), labelInfo: 'getLastModifyTime' })
        .onChange((selected) => {
          if (selected) {
            this.getLastModifyTime()
          }
        })

      MenuItem({ content: $r('app.string.Ability_to_obtain_server_support'), labelInfo: 'getServerFeatures' })
        .onChange((selected) => {
          if (selected) {
            this.getServerFeatures()
          }
        })

      MenuItem({ content: $r('app.string.Delete_individual_files'), labelInfo: 'deleteSingleFile' })
        .onChange((selected) => {
          if (selected) {
            this.deleteSingleFile()
          }
        })
      MenuItem({ content: $r('app.string.ensureRemotePath'), labelInfo: 'ensureRemotePath' })
        .onChange((selected) => {
          if (selected) {
            this.operationType = 'dir'
            if (this.dialogController) {
              this.dialogController.open()
            }
          } else {
            this.operationType = ''
          }
        })
      MenuItem({ content: $r('app.string.remove_empty_directories'), labelInfo: 'deleteEmptyDirectory' })
        .onChange((selected) => {
          if (selected) {
            this.deleteEmptyDirectory()
          }
        })
      MenuItem({ content: $r('app.string.remove_folders'), labelInfo: 'deleteAll' })
        .onChange((selected) => {
          if (selected) {
            this.deleteAll()
          }
        })
      MenuItem({ content: $r('app.string.Clear_current_working_directory'), labelInfo: 'deleteAllButSelf' })
        .onChange((selected) => {
          if (selected) {
            this.deleteAllButSelf()
          }
        })
      MenuItem({ content: $r('app.string.rename_file'), labelInfo: 'renameFile' })
        .onChange((selected) => {
          if (selected) {
            this.operationType = 'rename'
            if (this.dialogController) {
              this.dialogController.open()
            }
          } else {
            this.operationType = ''
          }
        })
    }
  }

  aboutToAppear() {
    if (!this.ftpUtil) {
      this.ftpUtil = new NoTlsUtil(GlobalObj?.getInstance()?.getContext() ? GlobalObj?.getInstance()?.getContext() : getContext(this))
      this.ftpUtil.setTag();
    }
  }

  aboutToDisappear() {
    this.dialogController = null;
    if (this.ftpUtil) {
      this.ftpUtil.close();
    }
  }

  showToast(text: string, name = getResourceString($r('app.string.Test'))) {
    const ctx = this
    if (ctx.ftpUtil) {
      ctx.isLogin = ctx.ftpUtil.getLogin();
    }
    let index = ctx.message.lastIndexOf("\r\n")
    let newStr = ctx.message.substring(index, ctx.message.length)
    if (newStr.indexOf(getResourceString($r('app.string.Current_upload_length'))) != -1) {
      let front = ctx.message.substring(0, index)
      ctx.message = front + "\r\n" + text;
    } else if (newStr.indexOf(getResourceString($r('app.string.Current_download_length'))) != -1) {
      let index = ctx.message.lastIndexOf("\r\n")
      let front = ctx.message.substring(0, index)
      ctx.message = front + "\r\n" + text
    }
    else {
      ctx.message = ctx.message + "\r\n" + text
    }
    console.log(`${TAG}---${name}--->${text}`)
    promptAction.showToast({
      message: text,
      duration: 2000,
      bottom: 50
    })
  }

  build() {
    if (!this.isLogin) {
      Row() {
        Column() {
          Flex({ justifyContent: FlexAlign.Start, direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
            Text($r('app.string.Server_address'))
              .fontSize(20)
              .height(50)
              .width(200)
              .margin({ left: 10 })
              .textAlign(TextAlign.Center)
              .fontWeight(FontWeight.Bold)

            TextInput({ placeholder: 'Please enter the server address', text: this.host })
              .width('100%')
              .height(50)
              .margin({ left: 15 })
              .borderWidth(2)
              .borderColor(Color.Gray)
              .type(InputType.Normal)
              .onChange((data) => {
                this.host = data
              })
          }

          Flex({ justifyContent: FlexAlign.Start, direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
            Text($r('app.string.Port'))
              .fontSize(20)
              .height(50)
              .width(200)
              .margin({ left: 10 })
              .textAlign(TextAlign.Center)
              .fontWeight(FontWeight.Bold)

            TextInput({ placeholder: 'Please enter the port', text: '21' })
              .width('100%')
              .height(50)
              .margin({ left: 15 })
              .borderWidth(2)
              .borderColor(Color.Gray)
              .type(InputType.Normal)
              .onChange((data) => {
                this.port = Number.parseInt(data)
              })
          }

          Flex({ justifyContent: FlexAlign.Start, direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
            Text($r('app.string.Username'))
              .fontSize(20)
              .height(50)
              .width(80)
              .margin({ left: 10 })
              .textAlign(TextAlign.Center)
              .fontWeight(FontWeight.Bold)

            TextInput({ placeholder: 'Please enter the username', text: this.user })
              .width('100%')
              .height(50)
              .margin({ left: 15 })
              .borderWidth(2)
              .borderColor(Color.Gray)
              .type(InputType.Normal)
              .onChange((data) => {
                this.user = data
              })
          }
          .margin({ top: 20 })

          Flex({ justifyContent: FlexAlign.Start, direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
            Text($r('app.string.Password'))
              .fontSize(20)
              .height(50)
              .width(80)
              .margin({ left: 10 })
              .textAlign(TextAlign.Center)
              .fontWeight(FontWeight.Bold)

            TextInput({ placeholder: 'Please enter the password', text: this.password })
              .width('100%')
              .height(50)
              .borderWidth(2)
              .margin({ left: 15 })
              .borderColor(Color.Gray)
              .type(InputType.Normal)
              .onChange((data) => {
                this.password = data
              })
          }
          .margin({ top: 20 })


          Flex({ justifyContent: FlexAlign.Start, direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
            Text($r('app.string.TLS'))
              .fontSize(20)
              .height(50)
              .margin({ left: 15 })
              .textAlign(TextAlign.Center)
              .fontWeight(FontWeight.Bold)


            Checkbox({ name: '是否开启SSL/TLS', group: 'ssl' })
              .height(40)
              .select(false)
              .margin({ left: 10 })
              .selectedColor(Color.Blue)
              .onChange((value) => {
                this.secure = value
              })
          }
          .margin({ top: 20 })

          Button($r('app.string.Login'))
            .margin(20)
            .width('80%')
            .height(50)
            .backgroundColor(Color.Blue)
            .fontColor(Color.White)
            .onClick(() => {
              this.loginServer()
            })
        }
        .justifyContent(FlexAlign.Center)
        .height('100%')
        .width('100%')
      }
      .width('100%')
      .height('100%')
    } else {
      Row() {
        Column() {
          Flex({ justifyContent: FlexAlign.Start, direction: FlexDirection.Row, alignItems: ItemAlign.Start }) {
            MenuItem({
              startIcon: $r('app.media.icon'),
              content: '更多操作',
              endIcon: $r('app.media.more'),
              builder: this.SubMenu
            })
              .bindMenu(this.SubMenu)

            Text(`${getResourceString($r('app.string.current_folder'))}：${this.remoteRoot}`)
              .layoutWeight(1)
              .fontSize(12)
              .textAlign(TextAlign.Start)
              .height(50)
          }
          .padding(20)


          Flex({ justifyContent: FlexAlign.Start, direction: FlexDirection.Row, alignItems: ItemAlign.Start }) {
            List({ space: 10, initialIndex: 0 }) {
              ForEach(this.currentFileList, (item: FileInfo, index: number) => {
                ListItem() {
                  if (item.type == FileType.Directory) {
                    Flex({
                      justifyContent: FlexAlign.Start,
                      direction: FlexDirection.Row,
                      alignItems: ItemAlign.Center
                    }) {
                      Toggle({ type: ToggleType.Checkbox, isOn: true })
                        .size({ width: 30, height: 30 })
                        .selectedColor('#007DFF')
                        .visibility(this.selectDirPath && this.selectDirPath.length > 0 && this.selectDirPath == item.name ? Visibility.Visible : Visibility.None)

                      Image($r('app.media.fileDir'))
                        .height(40)
                        .width(40)
                        .margin({ left: 10 })


                      Text(item.name)
                        .fontSize(20)
                        .height(50)
                        .margin({ left: 10 })
                        .fontWeight(FontWeight.Bold)
                    }
                    .margin({ top: 10 })
                  } else if (item.type == FileType.File) {
                    Flex({
                      justifyContent: FlexAlign.Start,
                      direction: FlexDirection.Row,
                      alignItems: ItemAlign.Center
                    }) {
                      Toggle({ type: ToggleType.Checkbox, isOn: true })
                        .size({ width: 30, height: 30 })
                        .selectedColor('#007DFF')
                        .visibility(this.selectFilePath && this.selectFilePath === item.name ? Visibility.Visible : Visibility.None)

                      Image($r('app.media.file'))
                        .height(40)
                        .width(40)
                        .margin({ left: 10 })


                      Text(item.name)
                        .fontSize(20)
                        .height(50)
                        .margin({ left: 10 })
                        .fontWeight(FontWeight.Bold)
                    }
                    .margin({ top: 10 })
                  } else {
                    Flex({
                      justifyContent: FlexAlign.Start,
                      direction: FlexDirection.Row,
                      alignItems: ItemAlign.Center
                    }) {
                      Toggle({ type: ToggleType.Checkbox, isOn: true })
                        .size({ width: 30, height: 30 })
                        .selectedColor('#007DFF')
                        .visibility(this.selectDirPath && this.selectDirPath.length > 0 && this.selectDirPath == item.name ? Visibility.Visible : Visibility.None)


                      Image($r('app.media.unknow'))
                        .height(40)
                        .width(40)
                        .margin({ left: 10 })


                      Text(item.name)
                        .fontSize(20)
                        .height(50)
                        .margin({ left: 10 })
                        .fontWeight(FontWeight.Bold)
                    }
                    .margin({ top: 10 })
                  }

                }
                .parallelGesture(TapGesture().onAction((event) => {
                  if (this.currentFileList && this.currentFileList.length > 0 && item) {
                    let name = item.name
                    this.showToast(`${name}`, `ListItem---${item}`)
                    if (item.type != FileType.Directory) {
                      if (this.selectFilePath == undefined) {
                        this.selectFilePath = name
                        this.showToast(`selectFilePath ${this.selectFilePath}`, 'selectFilePath')
                      } else {
                        this.selectFilePath = null;
                        this.showToast(`select cancle `, 'selectFilePath')
                      }
                    } else {
                      this.enterChildDir(item.name)
                    }
                  }

                }), GestureMask.Normal)
                .gesture(LongPressGesture().onAction((event) => {
                  if (this.selectDirPath && this.selectDirPath.length > 0) {
                    this.selectDirPath = null
                  } else {
                    this.selectDirPath = item.name
                  }
                }), GestureMask.Normal)

              }, (item: FileInfo, index: number) => item.name)
            }
            .width('100%')
            .listDirection(Axis.Vertical)
            .divider({ strokeWidth: 2, color: 0x888888 })
            .edgeEffect(EdgeEffect.None)
            .chainAnimation(false)
          }
          .border({
            width: 5,
            color: Color.Green,
            style: BorderStyle.Solid
          })
          .visibility(this.isShowLog ? Visibility.None : Visibility.Visible)
          .layoutWeight(1)
          .margin({ left: 20, right: 20 })

          Flex({ justifyContent: FlexAlign.Start, direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
            Scroll() {
              Text(this.message)
                .width('100%')
                .fontSize(20)
                .textAlign(TextAlign.Start)
                .padding(10)
            }
            .width('100%')
          }
          .border({
            width: 5,
            color: Color.Green,
            style: BorderStyle.Solid
          })
          .visibility(this.isShowLog ? Visibility.Visible : Visibility.None)
          .layoutWeight(1)
          .margin(20)

          Flex({ justifyContent: FlexAlign.Start, direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
            Button(this.isShowLog ? getResourceString($r('app.string.View_file_list')) : getResourceString($r('app.string.View_log')))
              .fontSize(14)
              .height(30)
              .margin({ left: 10 })
              .fontWeight(FontWeight.Bold)
              .onClick(() => {
                this.isShowLog = !this.isShowLog;
              })

            Button($r('app.string.Log_out'))
              .fontSize(14)
              .height(30)
              .margin({ left: 10 })
              .fontWeight(FontWeight.Bold)
              .onClick(async () => {
                this.isLogin = false;
                if (this.ftpUtil) {
                  await this.ftpUtil.close();
                }
                if (GlobalObj?.getInstance()?.getContext()) {
                  GlobalObj?.getInstance()?.getContext()?.terminateSelf()
                }
              })
          }
          .margin({ top: 10 })


          Flex({ justifyContent: FlexAlign.Start, direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
            Button($r('app.string.Generate_files'))
              .fontSize(14)
              .height(30)
              .margin({ left: 10 })
              .fontWeight(FontWeight.Bold)
              .onClick(() => {
                this.createSingleFile()
              })
            Button($r('app.string.Upload_a_file'))
              .fontSize(14)
              .height(30)
              .margin({ left: 10 })
              .fontWeight(FontWeight.Bold)
              .onClick(() => {
                this.operationType = 'uploadSingleFile'
                if (this.dialogController) {
                  this.dialogController.open()
                }
              })

          }
          .border({
            width: 5,
            color: Color.Green,
            style: BorderStyle.Solid
          })
          .padding({ top: 5, bottom: 5 })
          .margin({ top: 10 })

          Flex({ justifyContent: FlexAlign.Start, direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
            Button($r('app.string.Generate_files'))
              .fontSize(14)
              .height(30)
              .margin({ left: 10 })
              .fontWeight(FontWeight.Bold)
              .onClick(() => {
                this.createSingleFile()
              })
            Button($r('app.string.Add_upload'))
              .fontSize(14)
              .height(30)
              .margin({ left: 10 })
              .fontWeight(FontWeight.Bold)
              .onClick(() => {
                this.appendFile()
              })

          }
          .border({
            width: 5,
            color: Color.Green,
            style: BorderStyle.Solid
          })
          .padding({ top: 5, bottom: 5 })
          .margin({ top: 10 })


          Flex({ justifyContent: FlexAlign.Start, direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {

            Button($r('app.string.Generate_folder'))
              .fontSize(14)
              .height(30)
              .margin({ left: 10 })
              .fontWeight(FontWeight.Bold)
              .onClick(() => {
                this.createFileDir()
              })
            Button($r('app.string.Upload_folder'))
              .fontSize(14)
              .height(30)
              .margin({ left: 10 })
              .fontWeight(FontWeight.Bold)
              .onClick(() => {
                this.operationType = 'uploadDir'
                if (this.dialogController) {
                  this.dialogController.open()
                }
              })
          }
          .border({
            width: 5,
            color: Color.Green,
            style: BorderStyle.Solid
          })
          .padding({ top: 5, bottom: 5 })
          .margin({ top: 10 })

          Flex({ justifyContent: FlexAlign.Start, direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
            Button($r('app.string.Download_a_file'))
              .fontSize(14)
              .height(30)
              .margin({ left: 10 })
              .fontWeight(FontWeight.Bold)
              .onClick(() => {
                this.downloadSingleFile()
              })

            Button($r('app.string.Download_folder'))
              .fontSize(14)
              .height(30)
              .margin({ left: 10 })
              .fontWeight(FontWeight.Bold)
              .onClick(() => {
                this.downloadDir()
              })
          }
          .margin({ top: 10, bottom: 20 })
        }
        .margin(15)
        .border({
          width: 2,
          color: Color.Red,
          radius: 10,
          style: BorderStyle.Solid
        })
        .width('100%')
        .height('100%')
      }
      .width('100%')
      .height('100%')
    }
  }

  async loginServer() {
    const ctx = this
    ctx.message = getResourceString($r('app.string.Init'))
    let loginInfo: AccessOptions | null = null
    if (ctx.secure) {
      let context = GlobalObj?.getInstance()?.getContext() ? GlobalObj?.getInstance()?.getContext() : getContext(this)
      if (!context) {
        return;
      }
      let keyData = await context?.resourceManager?.getRawFileContent('client_rsa_private.pem.unsecure')
      if (!keyData) {
        return;
      }
      let key = '';
      for (let i = 0; i < keyData.length; i++) {
        let todo = keyData[i]
        let item = String.fromCharCode(todo);
        key += item;
      }
      ctx.option.secureOptions.key = key;

      let certData = await context.resourceManager.getRawFileContent('client.pem')
      let cert = '';
      for (let i = 0; i < certData.length; i++) {
        let todo = certData[i]
        let item = String.fromCharCode(todo);
        cert += item;
      }
      ctx.option.secureOptions.cert = cert;


      let caData = await context.resourceManager.getRawFileContent('ca.pem')
      let ca = '';
      for (let i = 0; i < caData.length; i++) {
        let todo = caData[i]
        let item = String.fromCharCode(todo);
        ca += item;
      }
      if (ctx.option.secureOptions.ca instanceof Array) {
        ctx.option.secureOptions.ca[0] = ca;
      } else {
        ctx.option.secureOptions.ca = ca;
      }


      ctx.option.address = {
        address: ctx.host,
        port: ctx.port,
        family: 1
      }
      loginInfo = {
        host: ctx.host,
        user: ctx.user,
        port: ctx.port,
        password: ctx.password,
        secure: 'implicit',
        secureOptions: ctx.option
      }
    } else {
      loginInfo = {
        host: ctx.host,
        user: ctx.user,
        port: ctx.port,
        password: ctx.password,
        secure: false,
        secureOptions: undefined
      }
    }
    if (ctx.ftpUtil) {
      ctx.ftpUtil.doLogin(loginInfo, {
        onLoginStart(info: string) {
          ctx.showToast(info, 'onLoginStart')
        },
        onLoginSuccess(result: string) {
          ctx.showToast(result, 'onLoginSuccess')
          ctx.refreshScreen()
        },
        onLoginErr(err: Error) {
          ctx.showToast(err.message, 'onLoginErr')
        }
      })
    }
  }

  getCurrentDirectory() {
    const ctx = this
    if (ctx.ftpUtil) {
      if (!ctx.ftpUtil.getLogin()) {
        ctx.showToast(getResourceString($r('app.string.please_login')), 'isLogin')
        return
      }
      ctx.ftpUtil.getCurrentDirectory({
        currentDirectoryErr(err: Error) {
          ctx.showToast(`${getResourceString($r('app.string.get_working_directory_failed'))}：${err.message}`, 'currentDirectoryErr')
        },
        currentDirectoryStart(info: string) {
          ctx.showToast(`${getResourceString($r('app.string.get_working_directory_start'))}：${info}`, 'currentDirectoryStart')
        },
        currentDirectorySuccess(msg: string) {
          ctx.showToast(`${getResourceString($r('app.string.get_working_directory_success'))}：${msg}`, 'currentDirectorySuccess')
          ctx.remoteRoot = msg
        }
      })
    }
  }

  refreshScreen() {
    const ctx = this
    if (ctx.ftpUtil) {
      if (!ctx.ftpUtil?.getLogin()) {
        ctx.showToast(getResourceString($r('app.string.please_login')), 'isLogin')
        return
      }
      ctx.ftpUtil?.getCurrentDirectory({
        currentDirectoryErr(err: Error) {
          ctx.showToast(`${getResourceString($r('app.string.get_working_directory_failed'))}：${err.message}`, 'currentDirectoryErr')
        },
        currentDirectoryStart(info: string) {
          ctx.showToast(`${getResourceString($r('app.string.get_working_directory_start'))}：${info}`, 'currentDirectoryStart')
        },
        currentDirectorySuccess(msg: string) {
          ctx.showToast(`${getResourceString($r('app.string.get_working_directory_success'))}：${msg}`, 'currentDirectorySuccess')
          ctx.remoteRoot = msg
          let listName = '';
          if (ctx.remoteRoot == '' || ctx.remoteRoot == '\\' || ctx.remoteRoot == '/') {
            listName = ''
          } else {
            listName = msg
          }
          ctx.ftpUtil?.getList(listName, {
            getListErr(err: Error) {
              ctx.showToast(`${getResourceString($r('app.string.get_file_list_failed'))}：${err.message}`, 'getListErr')
              ctx.currentFileList = []
            },
            getListStart(info: string) {
              ctx.showToast(`${getResourceString($r('app.string.get_file_list_start'))}：${info}`, 'getListStart')
            },
            getListSuccess(result: FileInfo[]) {
              ctx.showToast(`${getResourceString($r('app.string.get_file_list_success'))}：${JSON.stringify(result)}`, 'getListSuccess')
              if (!result) {
                ctx.currentFileList = []
              } else {
                ctx.currentFileList = result;
              }

            }
          })

        }
      })
    }
  }

  createSingleFile() {
    const ctx = this
    try {
      ctx.showToast('Start generating a single local file', 'createSingleFile')
      let context: Context | null = GlobalObj?.getInstance()?.getContext() ? GlobalObj?.getInstance()?.getContext() : getContext(ctx)
      ctx.localUploadFilePath = context?.cacheDir + '/' + (new Date().getTime()) + '.txt'
      let file = fs.openSync(ctx.localUploadFilePath, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE)
      let str = ''
      for (let i = 0; i < 1024; i++) {
        str += "客户端发送到服务端的信息，请查收\r\n"
      }
      fs.writeSync(file.fd, str)
      fs.fsyncSync(file.fd)
      fs.closeSync(file)
      ctx.showToast('Successfully generated local single file', 'createSingleFile')
    } catch (err) {
      ctx.localUploadFilePath = null
      ctx.showToast('Failed to generate a single local file:' + JSON.stringify(err), 'createSingleFile')
    }
  }

  createFileDir() {
    const ctx = this
    try {
      ctx.showToast('Start generating local folder', 'createFileDir')
      let context: Context | null = GlobalObj?.getInstance()?.getContext() ? GlobalObj?.getInstance()?.getContext() : getContext(ctx)
      ctx.localUploadFileDir = context?.cacheDir + '/' + (new Date().getTime())
      let localPath1 = ctx.localUploadFileDir + '/' + 'test1.txt'
      let localPath2 = ctx.localUploadFileDir + '/' + 'test2.txt'
      let localPath3 = ctx.localUploadFileDir + '/' + 'test3.txt'

      fs.mkdirSync(ctx.localUploadFileDir)
      let file = fs.openSync(localPath1, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE)
      let str = ''
      for (let i = 0; i < 1024; i++) {
        str += "客户端发送到服务端的信息，请查收\r\n"
      }
      fs.writeSync(file.fd, str)
      fs.fsyncSync(file.fd)
      fs.closeSync(file)

      let file1 = fs.openSync(localPath2, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE)
      let str1 = '789456123abcd'
      fs.writeSync(file1.fd, str1)
      fs.fsyncSync(file1.fd)
      fs.closeSync(file1)


      let file3 = fs.openSync(localPath3, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE)
      let str3 = '111111111111111111111111111111111111111111111111111111'
      fs.writeSync(file3.fd, str3)
      fs.fsyncSync(file3.fd)
      fs.closeSync(file3)


      ctx.showToast('Successfully generated local folder', 'createFileDir')
    } catch (err) {
      ctx.localUploadFileDir = null;
      ctx.showToast('Failed to generate local folder:' + JSON.stringify(err), 'createFileDir')
    }
  }

  appendFile() {
    const ctx = this
    if (ctx.ftpUtil) {
      if (!this.ftpUtil?.getLogin()) {
        ctx.operationType = ''
        ctx.showToast(`${getResourceString($r('app.string.please_login'))}`, 'uploadSingleFile')
        return
      }
      if (!ctx.localUploadFilePath || ctx.localUploadFilePath.length < 1) {
        ctx.operationType = ''
        ctx.showToast('Local individual file not generated, please generate file first', 'appendFile')
        return
      }
      if (!ctx.remoteRoot || ctx.remoteRoot.length < 1) {
        ctx.operationType = ''
        ctx.showToast('The current working directory has not been obtained. Please obtain the current working directory first', 'appendFile')
        return
      }
      if (!ctx.selectFilePath || ctx.selectFilePath.length < 1) {
        ctx.operationType = ''
        ctx.showToast('No files to be uploaded have been selected. Please select the files to be uploaded first', 'appendFile')
        return
      }
      ctx.ftpUtil?.getFileSize(ctx.selectFilePath, {
        getSizeErr(err: Error) {
          ctx.showToast(`${err.message}`, 'appendFile')
        },
        getSizeStart(info: string) {
          ctx.showToast(`${info}`, 'appendFile')
        },
        getSizeSuccess(result: number) {
          ctx.showToast(`${ctx.selectFilePath}大小:${result}`, 'appendFile')
          ctx.ftpUtil?.appendFile(ctx.localUploadFilePath, ctx.selectFilePath, {
            appendErr(err: Error) {
              ctx.showToast(`Failed to attach and upload a single file： ${JSON.stringify(err)}`, 'appendFile')
            },
            appendStart(info: string) {
              ctx.showToast(info, 'uploadSingleFile')
            },
            appendSuccess(msg: FTPResponse) {
              ctx.showToast(`Attached upload successful:` + JSON.stringify(msg), 'appendFile')
              ctx.ftpUtil?.getFileSize(ctx.selectFilePath, {
                getSizeErr(err: Error) {
                  ctx.showToast(`Failed to retrieve the original file size after attaching upload，${err.message}`, 'appendFile')
                },
                getSizeStart(info: string) {
                  ctx.showToast(`Starting from obtaining the original file size after attaching the upload，${info}`, 'appendFile')
                },
                getSizeSuccess(result: number) {
                  ctx.showToast(`Obtain the original file after attaching the upload ${ctx.selectFilePath} size:${result}`, 'appendFile')
                  ctx.refreshScreen()
                }
              })

            },
            appendProgress(currentSize: number, totalSize: number) {
              ctx.showToast(`${currentSize}，${totalSize}`, 'appendFile')
            }
          })
        }
      })

    }

  }

  uploadSingleFile() {
    const ctx = this
    if (ctx.ftpUtil) {
      if (!this.ftpUtil?.getLogin()) {
        ctx.operationType = ''
        ctx.showToast(getResourceString($r('app.string.please_login')), 'uploadSingleFile')
        return
      }
      if (!ctx.localUploadFilePath || ctx.localUploadFilePath.length < 1) {
        ctx.operationType = ''
        ctx.showToast('Local individual file not generated, please generate local file first', 'uploadSingleFile')
        return
      }
      if (!ctx.remoteRoot || ctx.remoteRoot.length < 1) {
        ctx.operationType = ''
        ctx.showToast('The current working directory has not been obtained. Please obtain the current working directory first', 'uploadSingleFile')
        return
      }
      if (!ctx.inputValue || ctx.inputValue.length < 1) {
        ctx.operationType = ''
        ctx.showToast('File name not entered, please enter file name first', 'uploadSingleFile')
        return
      }
      ctx.ftpUtil?.uploadSingleFile(ctx.localUploadFilePath, ctx.inputValue, {
        uploadErr(err: Error) {
          ctx.showToast(`Failed to upload a single file： ${JSON.stringify(err)}`, 'uploadSingleFile')
        },
        uploadStart(info: string) {
          ctx.showToast(info, 'uploadSingleFile')
        },
        uploadSuccess(msg: FTPResponse) {
          ctx.showToast(`Upload successful:` + JSON.stringify(msg), 'uploadSingleFile')
          ctx.refreshScreen()
        },
        uploadProgress(currentSize: number, totalSize: number) {
          ctx.showToast(`Current upload length:${currentSize}，The total length of the last file：${totalSize}`, 'uploadSingleFile')
        }
      })
    }

  }

  uploadDir() {
    const ctx = this
    if (ctx.ftpUtil) {
      if (!this.ftpUtil?.getLogin()) {
        ctx.operationType = ''
        ctx.showToast(getResourceString($r('app.string.please_login')), 'uploadDir')
        return
      }
      if (!ctx.localUploadFileDir || ctx.localUploadFileDir.length < 1) {
        ctx.operationType = ''
        ctx.showToast('Local folder not generated, please create a local folder first', 'uploadDir')
        return
      }
      if (!ctx.remoteRoot || ctx.remoteRoot.length < 1) {
        ctx.operationType = ''
        ctx.showToast('The current working directory has not been obtained. Please obtain the current working directory first', 'uploadDir')
        return
      }
      if (!ctx.inputValue || ctx.inputValue.length < 1) {
        ctx.operationType = ''
        ctx.showToast('Please enter the file name first', 'uploadDir')
        return
      }
      ctx.ftpUtil?.uploadDir(ctx.localUploadFileDir, ctx.inputValue, {
        uploadDirErr(err: Error) {
          ctx.showToast(err.message, 'uploadDir')
        },
        uploadDirStart(info: string) {
          ctx.showToast(info, 'uploadDir')
        },
        uploadDirSuccess(msg: string) {
          ctx.showToast(`Upload folder successfully，result is:${'\r\n'}` + JSON.stringify(msg), 'uploadDir')
          ctx.refreshScreen()
        },
        uploadDirProgress(currentSize: number, totalSize: number) {
          ctx.showToast(`currentSize：${currentSize}，totalSize：${totalSize}`, 'uploadDir')
        }
      })
    }
  }

  downloadSingleFile() {
    const ctx = this
    let context = GlobalObj?.getInstance()?.getContext() ? GlobalObj?.getInstance()?.getContext() : getContext(ctx)

    if (this.ftpUtil) {
      if (!this.ftpUtil?.getLogin()) {
        ctx.showToast(getResourceString($r('app.string.please_login')), 'downloadSingleFile')
        return
      }
      if (!ctx.remoteRoot || ctx.remoteRoot.length < 1) {
        ctx.showToast('Please obtain the current working directory first', 'downloadSingleFile')
        return
      }
      if (!ctx.selectFilePath || ctx.selectFilePath.length < 1) {
        ctx.showToast('Please select the file first', 'getFileSize')
        return
      }
      let localPath = context?.cacheDir + '/' + ctx.selectFilePath
      this.ftpUtil?.downloadSingleFile(localPath, ctx.selectFilePath, {
        downloadErr(err: Error) {
          ctx.showToast(`Failed to download a single file，${err.message}`, 'downloadSingleFile')
        },
        downloadStart(info: string) {
          ctx.showToast(`Start downloading a single file，${info}`, 'downloadSingleFile')
        },
        downloadSuccess(msg: FTPResponse) {
          ctx.showToast(`Download successful，result is:` + JSON.stringify(msg), 'downloadSingleFile')
        },
        downloadProgress(currentSize: number, totalSize: number) {
          ctx.showToast(`currentSize：${currentSize}，totalSize：${totalSize}`, 'uploadDir')
        }
      })
    }
  }

  downloadDir() {
    const ctx = this
    let context = GlobalObj?.getInstance()?.getContext() ? GlobalObj?.getInstance()?.getContext() : getContext(ctx)

    if (this.ftpUtil) {
      if (!this.ftpUtil?.getLogin()) {
        ctx.showToast(getResourceString($r('app.string.please_login')), 'downloadDir')
        return
      }
      if (!ctx.remoteRoot || ctx.remoteRoot.length < 1) {
        ctx.showToast('Please obtain the current working directory first', 'downloadDir')
        return
      }
      if (!ctx.selectDirPath || ctx.selectDirPath.length < 1) {
        ctx.showToast('Please long press and select a folder before performing this operation', 'deleteEmptyDirectory')
        return
      }
      let localDir = context?.cacheDir + ctx.selectDirPath

      this.ftpUtil?.downloadDir(localDir, ctx.selectDirPath, {
        downloadDirErr(err: Error) {
          ctx.showToast(`Download folder failed，${err.message}`, 'downloadDir')
        },
        downloadDirStart(info: string) {
          ctx.showToast(`Download folder started，${info}`, 'downloadDir')
        },
        downloadDirSuccess(msg: string) {
          ctx.showToast(`Download folder successfully，result is:${'\r\n'}` + JSON.stringify(msg), 'downloadDir')
        },
        downloadDirProgress(currentSize: number, totalSize: number) {
          ctx.showToast(`Current download length：currentSize：${currentSize}，totalSize：${totalSize}`, 'downloadDir')
        }
      })
    }
  }

  getFileSize() {
    const ctx = this
    if (this.ftpUtil) {
      if (!this.ftpUtil?.getLogin()) {
        ctx.showToast(getResourceString($r('app.string.please_login')), 'getFileSize')
        return
      }
      if (!ctx.remoteRoot || ctx.remoteRoot.length < 1) {
        ctx.showToast('Please obtain the current working directory first', 'getFileSize')
        return
      }
      if (!ctx.selectFilePath || ctx.selectFilePath.length < 1) {
        ctx.showToast('Please select the file first', 'getFileSize')
        return
      }
      this.ftpUtil?.getFileSize(ctx.selectFilePath, {
        getSizeErr(err: Error) {
          ctx.showToast(`Failed to retrieve file size，${err.message}`, 'getFileSize')
        },
        getSizeStart(info: string) {
          ctx.showToast(`Starting from obtaining file size，${info}`, 'getFileSize')
        },
        getSizeSuccess(result: number) {
          ctx.showToast(`Obtained file ${ctx.selectFilePath} size:${result}`, 'getFileSize')
        }
      })
    }
  }

  getServerFeatures() {
    const ctx = this
    if (this.ftpUtil) {
      if (!this.ftpUtil?.getLogin()) {
        ctx.showToast(getResourceString($r('app.string.please_login')), 'getServerFeatures')
        return
      }
      this.ftpUtil.getServerFeatures({
        featuresErr(err: Error) {
          ctx.showToast(`Failed to obtain server capability，${err.message}`, 'getFileSize')
        },
        featuresStart(info: string) {
          ctx.showToast(`Starting to acquire server capabilities，${info}`, 'getFileSize')
        },
        featuresSuccess(msg: Map<string, string>) {
          ctx.showToast(`Server capability acquisition successful，result is:${'\r\n'}${JSON.stringify(msg)}`, 'getFileSize')
        }
      })
    }
  }

  getLastModifyTime() {
    const ctx = this
    if (ctx.ftpUtil) {
      if (!ctx.ftpUtil?.getLogin()) {
        ctx.showToast(getResourceString($r('app.string.please_login')), 'getLastModifyTime')
        return
      }
      if (!ctx.remoteRoot || ctx.remoteRoot.length < 1) {
        ctx.showToast('Please obtain the current working directory first', 'getLastModifyTime')
        return
      }
      if (!ctx.selectFilePath || ctx.selectFilePath.length < 1) {
        ctx.showToast('Please select the file first', 'getLastModifyTime')
        return
      }
      ctx.ftpUtil?.getLastModify(ctx.selectFilePath, {
        lastModifyErr(err: Error) {
          ctx.showToast(`Failed to switch to the parent directory of the working directory，${err.message}`, 'getLastModifyTime')
        },
        lastModifyStart(info: string) {
          ctx.showToast(`Starting from switching to the parent directory of the working directory，${info}`, 'getLastModifyTime')
        },
        lastModifySuccess(msg: Date) {
          ctx.showToast(`Successfully switched to the parent directory of the working directory, the returned result is:${'\r\n'}` + msg.toLocaleString(), 'getLastModifyTime')
        }
      })
    }
  }

  deleteSingleFile() {
    const ctx = this
    if (ctx.ftpUtil) {
      if (!ctx.ftpUtil?.getLogin()) {
        ctx.showToast(getResourceString($r('app.string.please_login')), 'deleteSingleFile')
        return
      }
      if (!ctx.remoteRoot || ctx.remoteRoot.length < 1) {
        ctx.showToast('Please obtain the current working directory first', 'deleteSingleFile')
        return
      }
      if (!ctx.selectFilePath || ctx.selectFilePath.length < 1) {
        ctx.showToast('Please select the file first', 'deleteSingleFile')
        return
      }
      ctx.ftpUtil?.deleteFile(ctx.selectFilePath, {
        deleteFileErr(err: Error) {
          ctx.showToast(`Failed to delete file，${err.message}`, 'deleteSingleFile')
        },
        deleteFileStart(info: string) {
          ctx.showToast(`Starting to delete files，${info}`, 'deleteSingleFile')
        },
        deleteFileSuccess(msg: FTPResponse) {
          ctx.showToast(`The file deletion was successful, and the returned result is:${'\r\n'}` + JSON.stringify(msg), 'deleteSingleFile')
          ctx.refreshScreen()
        }
      })
    }
  }

  backToParent() {
    const ctx = this
    if (ctx.ftpUtil) {
      if (!ctx.ftpUtil?.getLogin()) {
        ctx.showToast(getResourceString($r('app.string.please_login')), 'backToParent')
        return
      }
      if (!ctx.remoteRoot || ctx.remoteRoot.length < 1) {
        ctx.showToast('Please obtain the current working directory first', 'backToParent')
        return
      }
      ctx.ftpUtil?.cdToParentDirectory({
        cdToParentDirectoryErr(err: Error) {
          ctx.showToast(`Failed to switch to the parent directory of the working directory，${err.message}`, 'backToParent')
        },
        cdToParentDirectoryStart(info: string) {
          ctx.showToast(`Starting from switching to the parent directory of the working directory，${info}`, 'backToParent')
        },
        cdToParentDirectorySuccess(res: FTPResponse) {
          ctx.showToast(`Successfully switched to the parent directory of the working directory, the returned result is:${'\r\n'}` + JSON.stringify(res), 'backToParent')
          ctx.refreshScreen()
        }
      })
    }
  }

  ensureRemotePath() {
    const ctx = this
    if (this.ftpUtil) {
      if (!this.ftpUtil?.getLogin()) {
        ctx.operationType = ''
        ctx.showToast(getResourceString($r('app.string.please_login')), 'ensureRemotePath')
        return
      }
      if (!ctx.remoteRoot || ctx.remoteRoot.length < 1) {
        ctx.operationType = ''
        ctx.showToast('Please obtain the current working directory first', 'ensureRemotePath')
        return
      }
      if (!ctx.inputValue || ctx.inputValue.length < 1) {
        ctx.operationType = ''
        ctx.showToast('Please enter the folder name first', 'ensureRemotePath')
        return
      }
      this.ftpUtil?.ensureRemotePath(ctx.inputValue, {
        ensureRemotePathErr(err: Error) {
          ctx.operationType = ''
          ctx.showToast(`Failed to ensure the existence of the given directory on the remote server，${err.message}`, 'ensureRemotePath')
        },
        ensureRemotePathStart(info: string) {
          ctx.operationType = ''
          ctx.showToast(`Ensure that the remote server starts with the given directory，${info}`, 'ensureRemotePath')
        },
        ensureRemotePathSuccess(result: string) {
          ctx.operationType = ''
          ctx.showToast(`Ensure that the given directory exists successfully on the remote server:${result}}`, 'ensureRemotePath')
          ctx.refreshScreen()
        }
      })
    }
  }

  deleteEmptyDirectory() {
    const ctx = this
    if (this.ftpUtil) {
      if (!this.ftpUtil?.getLogin()) {
        ctx.showToast(getResourceString($r('app.string.please_login')), 'deleteEmptyDirectory')
        return
      }
      if (!ctx.remoteRoot || ctx.remoteRoot.length < 1) {
        ctx.showToast('Please obtain the current working directory first', 'deleteEmptyDirectory')
        return
      }
      if (!ctx.selectDirPath || ctx.selectDirPath.length < 1) {
        ctx.showToast('Please long press and select a folder before performing this operation', 'deleteEmptyDirectory')
        return
      }

      this.ftpUtil?.deleteEmptyDirectory(ctx.selectDirPath, {
        deleteEmptyDirectoryErr(err: Error) {
          ctx.showToast(`Failed to delete empty directory，${err.message}`, 'deleteEmptyDirectory')
        },
        deleteEmptyDirectoryStart(info: string) {
          ctx.showToast(`Starting from deleting an empty directory，${info}`, 'deleteEmptyDirectory')
        },
        deleteEmptyDirectorySuccess(result: FTPResponse) {
          ctx.showToast(`Delete empty directory successfully:${JSON.stringify(result)}}`, 'deleteEmptyDirectory')
          ctx.refreshScreen()
        }
      })
    }
  }

  deleteAll() {
    const ctx = this
    if (this.ftpUtil) {
      if (!this.ftpUtil?.getLogin()) {
        ctx.showToast(getResourceString($r('app.string.please_login')), 'deleteEmptyDirectory')
        return
      }
      if (!ctx.remoteRoot || ctx.remoteRoot.length < 1) {
        ctx.showToast('Please obtain the current working directory first', 'deleteEmptyDirectory')
        return
      }
      if (!ctx.selectDirPath || ctx.selectDirPath.length < 1) {
        ctx.showToast('Please long press and select a folder before performing this operation', 'deleteEmptyDirectory')
        return
      }

      this.ftpUtil?.deleteAll(ctx.selectDirPath, {
        deleteAllErr(err: Error) {
          ctx.showToast(`Failed to delete directory and all its contents，${err.message}`, 'deleteEmptyDirectory')
        },
        deleteAllStart(info: string) {
          ctx.showToast(`Start deleting the directory and all its contents，${info}`, 'deleteEmptyDirectory')
        },
        deleteAllSuccess(result: string) {
          ctx.showToast(`Successfully deleted directory and all its contents:${result}}`, 'deleteEmptyDirectory')
          ctx.refreshScreen()
        }
      })
    }
  }

  deleteAllButSelf() {
    const ctx = this
    if (this.ftpUtil) {
      if (!this.ftpUtil?.getLogin()) {
        ctx.showToast(getResourceString($r('app.string.please_login')), 'deleteEmptyDirectory')
        return
      }
      if (!ctx.remoteRoot || ctx.remoteRoot.length < 1) {
        ctx.showToast('Please obtain the current working directory first', 'deleteEmptyDirectory')
        return
      }
      this.ftpUtil?.deleteAllButSelf({
        deleteAllButSelfErr(err: Error) {
          ctx.showToast(`Clearing the current working directory failed，${err.message}`, 'deleteEmptyDirectory')
        },
        deleteAllButSelfStart(info: string) {
          ctx.showToast(`Starting from clearing the current working directory，${info}`, 'deleteEmptyDirectory')
        },
        deleteAllButSelfSuccess(result: string) {
          ctx.showToast(`Clearing the current working directory successfully:${result}}`, 'deleteEmptyDirectory')
          ctx.refreshScreen()
        }
      })
    }
  }

  renameFile() {
    const ctx = this
    if (this.ftpUtil) {
      if (!this.ftpUtil?.getLogin()) {
        ctx.operationType = ''
        ctx.showToast(getResourceString($r('app.string.please_login')), 'renameFile')
        return
      }
      if (!ctx.remoteRoot || ctx.remoteRoot.length < 1) {
        ctx.operationType = ''
        ctx.showToast('Please obtain the current working directory first', 'renameFile')
        return
      }
      if (!ctx.inputValue || ctx.inputValue.length < 1) {
        ctx.operationType = ''
        ctx.showToast('Please enter the input file name first', 'renameFile')
        return
      }
      if (!ctx.selectFilePath || ctx.selectFilePath.length < 1) {
        ctx.showToast('Please select the file first', 'deleteSingleFile')
        return
      }

      this.ftpUtil?.renameFile(ctx.inputValue, ctx.selectFilePath, {
        renameFileErr(err: Error) {
          ctx.operationType = ''
          ctx.showToast(`Renaming file failed，${err.message}`, 'deleteEmptyDirectory')
        },
        renameFileStart(info: string) {
          ctx.operationType = ''
          ctx.showToast(`Rename file starts，${info}`, 'deleteEmptyDirectory')
        },
        renameFileSuccess(result: FTPResponse) {
          ctx.operationType = ''
          ctx.showToast(`Rename file successfully:${result}}`, 'deleteEmptyDirectory')
          ctx.refreshScreen()
        }
      })
    }
  }

  enterChildDir(remoteChildPath: string) {
    const ctx = this
    if (this.ftpUtil) {
      if (!this.ftpUtil?.getLogin()) {
        ctx.showToast(getResourceString($r('app.string.please_login')), 'enterChildDir')
        return
      }
      if (!ctx.remoteRoot || ctx.remoteRoot.length < 1) {
        ctx.showToast('Please obtain the current working directory first', 'enterChildDir')
        return
      }
      if (!remoteChildPath || remoteChildPath.length < 1) {
        ctx.showToast('The folder name cannot be empty', 'enterChildDir')
        return
      }

      this.ftpUtil?.setWorkingDirectory(remoteChildPath, {
        setWorkingDirectoryErr(err: Error) {
          ctx.showToast(`Failed to enter subfolders，${err.message}`, 'ensureRemotePath')
        },
        setWorkingDirectoryStart(info: string) {
          ctx.showToast(`Enter subfolders to start，${info}`, 'ensureRemotePath')
        },
        setWorkingDirectorySuccess(result: FTPResponse) {
          ctx.showToast(`Successfully entered subfolders:${result}}`, 'ensureRemotePath')
          ctx.refreshScreen()
        }
      })
    }
  }
}