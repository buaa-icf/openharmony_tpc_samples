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
import router from '@ohos.router'
import GlobalObj from '../GlobalObj'
import MailBoxes from '../bean/MailBoxes'
import Box from '../bean/Box'

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
struct FolderPage {
  @State message: string = 'Hello World'
  @State startIndex: number = 1 //当前页
  @State endIndex: number = 3 //当前页
  @State listData: Array<string> = [] //邮件列表数据集合
  @State selectFolder: string | null = '' //选择的文件夹
  @State selectType: string = '' //选择的文件夹
  @State textValue: string = ''
  @State inputValue: string = ''
  pageSize: number = 3 //请求时的每页多少条信息，用于分页请求
  dialogController: CustomDialogController | null = new CustomDialogController({
    builder: CustomDialogDiy({
      cancel: () => {
        this.showToast(this.getResourceString('app.string.Closed_the_dialog_box_and_canceled_inputting_the_folder_name'), 'CustomDialogDiy-cancel')
      },
      confirm: () => {
        if (!this.inputValue || this.inputValue.length < 1) {
          this.showToast(this.getResourceString('app.string.Create_a_new_folder_with_an_empty_name_please_re_enter'), 'CustomDialogDiy-confirm')
          return;
        }
        if (this.selectType === 'Create') {
          this.showToast(this.getResourceString('app.string.Create_a_new_folder_named') + `：${this.inputValue}`, 'CustomDialogDiy-confirm')
          this.createFolder()
        } else if (this.selectType === 'Rename') {
          this.showToast(this.getResourceString('app.string.The_renamed_folder_name_is') + `：${this.inputValue}`, 'CustomDialogDiy-confirm')
          this.renameFolder()
        }

      },
      textValue: $textValue,
      inputValue: $inputValue
    }),
    autoCancel: true,
    customStyle: false
  })

  showToast(text: string, name = '测试') {
    console.log(`zdy---${name}--->${text}`)
    promptAction.showToast({
      message: text,
      duration: 2000,
      bottom: 50
    })
  }

  aboutToAppear() {
    this.refreshFolderList()
  }

  aboutToDisappear() {
    this.dialogController = null;
  }

  refreshFolderList() {
    const ctx = this;
    if (GlobalObj?.getInstance()?.getClient()) {
      GlobalObj?.getInstance()?.getClient()?.getBoxes((err: Error, data?: MailBoxes) => {
        if (err) throw err;
        if (!data || typeof data != 'object') {
          throw new Error('get box status fail')
        }
        ctx.listData = [];
        let keyArr = Object.getOwnPropertyNames(data)
        for (let i = 0; i < keyArr.length; i++) {
          console.log(`zdy---getBoxes key--->${keyArr[i]}`);
          ctx.listData.push(keyArr[i])
        }

      })
    } else {
      this.showToast(this.getResourceString('app.string.Account_not_logged_in_please_login_and_try_again'), 'MsgList-imap')
      router.back()
    }
  }

  build() {
    Column() {
      Flex({ justifyContent: FlexAlign.Start, direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
        Button($r('app.string.remove_folders'))
          .margin(10)
          .width('80%')
          .height(50)
          .backgroundColor(Color.Blue)
          .fontColor(Color.White)
          .onClick(() => {
            this.deleteFolder()
          })

        Button($r('app.string.create_folder'))
          .margin(10)
          .width('80%')
          .height(50)
          .backgroundColor(Color.Blue)
          .fontColor(Color.White)
          .onClick(() => {
            this.selectType = 'Create'
            if (this.dialogController) {
              this.dialogController.open()
            }
            this.createFolder()
          })
        Button($r('app.string.Rename_folder'))
          .margin(10)
          .width('80%')
          .height(50)
          .backgroundColor(Color.Blue)
          .fontColor(Color.White)
          .onClick(() => {
            if (!this.selectFolder || this.selectFolder.length < 1) {
              this.showToast(this.getResourceString('app.string.Please_first_select_a_folder_that_needs_to_be_renamed'), 'renameFolder-imap')
              return;
            }
            this.selectType = 'Rename'
            if (this.dialogController) {
              this.dialogController.open()
            }
            this.renameFolder()
          })
      }
      .margin({ left: 15, top: 20 })

      Flex({ justifyContent: FlexAlign.Start, direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
        Button($r('app.string.subscribed'))
          .margin(10)
          .width('80%')
          .height(50)
          .backgroundColor(Color.Blue)
          .fontColor(Color.White)
          .onClick(() => {
            if (!this.selectFolder || this.selectFolder.length < 1) {
              this.showToast(this.getResourceString('app.string.Please_first_select_a_folder_that_needs_to_be_renamed'), 'renameFolder-imap')
              return;
            }
            this.subBox()
          })

        Button($r('app.string.Unsubscribe_email'))
          .margin(10)
          .width('80%')
          .height(50)
          .backgroundColor(Color.Blue)
          .fontColor(Color.White)
          .onClick(() => {
            if (!this.selectFolder || this.selectFolder.length < 1) {
              this.showToast(this.getResourceString('app.string.Please_first_select_a_folder_that_needs_to_be_renamed'), 'renameFolder-imap')
              return;
            }
            this.unSubBox()
          })
        Button($r('app.string.Get_all_subscribed_email_addresses'))
          .margin(10)
          .width('80%')
          .height(50)
          .backgroundColor(Color.Blue)
          .fontColor(Color.White)
          .onClick(() => {
            this.getSubList()
          })
      }
      .margin({ left: 15, top: 20 })

      List({ space: 10, initialIndex: 0 }) {
        ForEach(this.listData, (item: string, index: number) => {
          ListItem() {
            Flex({ alignItems: ItemAlign.Start, justifyContent: FlexAlign.Start, direction: FlexDirection.Row }) {
              Toggle({ type: ToggleType.Checkbox, isOn: true })
                .size({ width: 30, height: 30 })
                .selectedColor('#007DFF')
                .visibility(this.selectFolder && this.selectFolder === item ? Visibility.Visible : Visibility.None)

              Image($r('app.media.fileDir'))
                .height(40)
                .width(40)
                .margin({ left: 10 })

              Text(item)
                .fontSize(20)
                .height(50)
                .margin({ left: 10 })
                .fontWeight(FontWeight.Bold)
            }
          }.onClick(() => {

          })
          .parallelGesture(TapGesture().onAction((event) => {
            this.showToast(this.getResourceString('app.string.Preparing_to_enter_the_folder') + `：${item}`, 'folder-click-imap')
            router.pushUrl({
              url: 'pages/MsgListPage',
              params: {
                folderName: item,
                folderList: this.listData
              }
            })
          }), GestureMask.Normal)
          .gesture(LongPressGesture().onAction((event) => {
            if (this.selectFolder) {
              this.selectFolder = null
            } else {
              this.selectFolder = item
            }
          }), GestureMask.Normal)

        }, (item: string, index: number) => item)
      }
      .width('100%')
      .listDirection(Axis.Vertical)
      .divider({ strokeWidth: 2, color: 0x888888 })
      .edgeEffect(EdgeEffect.None)
      .chainAnimation(false)
    }
    .height('100%')
  }

  deleteFolder() {
    const ctx = this;
    try {
      if (!ctx.selectFolder || ctx.selectFolder.length < 1) {
        ctx.showToast(this.getResourceString('app.string.Please_first_select_a_folder_that_needs_to_be_deleted'), 'renameFolder-imap')
        return
      }
      ctx.showToast(this.getResourceString('app.string.Start_deleting_folder'), 'deleteFolder-imap')
      if (GlobalObj?.getInstance()?.getClient()) {
        GlobalObj?.getInstance()?.getClient()?.delBox(ctx.selectFolder, (err:Error) => {
          if (err) {
            ctx.showToast(this.getResourceString('app.string.Failed_to_delete_folder'), 'deleteFolder-imap')
          } else {
            ctx.selectFolder = null;
            ctx.showToast(this.getResourceString('app.string.Folder_deleted_successfully'), 'deleteFolder-imap')
            ctx.refreshFolderList()
          }
        });
      } else {
        this.showToast(this.getResourceString('app.string.Account_not_logged_in_please_login_and_try_again'), 'MsgList-imap')
        router.back()
      }

    } catch (err) {
      ctx.showToast(this.getResourceString('app.string.Account_login_error') + `：${err.message}`, 'login-smtp')
    }
  }

  createFolder() {
    const ctx = this;
    try {
      if (!ctx.inputValue || ctx.inputValue.length < 1) {
        ctx.showToast(this.getResourceString('app.string.Please_enter_the_name_of_the_new_folder_first'), 'renameFolder-imap')
        return
      }
      ctx.showToast(this.getResourceString('app.string.Start_creating_folder'), 'createFolder-imap')
      if (GlobalObj?.getInstance()?.getClient()) {
        GlobalObj?.getInstance()?.getClient()?.addBox(ctx.inputValue, (err:Error) => {
          if (err) {
            ctx.showToast(this.getResourceString('app.string.Failed_to_create_folder_reason') + `：${err.message}`, 'createFolder-imap')
          } else {
            ctx.inputValue = '';
            ctx.textValue = '';
            ctx.showToast(this.getResourceString('app.string.Folder_created_successfully'), 'createFolder-imap')
            ctx.refreshFolderList()
          }
        });
      } else {
        this.showToast(this.getResourceString('app.string.Account_not_logged_in_please_login_and_try_again'), 'createFolder-imap')
        router.back()
      }

    } catch (err) {
      ctx.showToast(this.getResourceString('app.string.Account_login_error') + `：${err.message}`, 'createFolder-smtp')
    }
  }

  renameFolder() {
    const ctx = this;
    try {
      if (!ctx.selectFolder || ctx.selectFolder.length < 1) {
        ctx.showToast(this.getResourceString('app.string.Please_first_select_a_folder_that_needs_to_be_renamed'), 'renameFolder-imap')
        return
      }
      if (!ctx.inputValue || ctx.inputValue.length < 1) {
        ctx.showToast(this.getResourceString('app.string.Please_enter_the_name_of_the_new_folder_first'), 'renameFolder-imap')
        return
      }
      ctx.showToast(this.getResourceString('app.string.Start_renaming_folder'), 'renameFolder-imap')
      if (GlobalObj?.getInstance()?.getClient()) {
        GlobalObj?.getInstance()?.getClient()?.renameBox(ctx.selectFolder, ctx.inputValue, (err:Error, result:Box) => {
          if (err) {
            ctx.showToast(this.getResourceString('app.string.Renaming_folder_failed_reason') + `：${err.message}`, 'renameFolder-imap')
          } else {
            ctx.selectFolder = null;
            ctx.inputValue = '';
            ctx.textValue = '';
            ctx.showToast(this.getResourceString('app.string.Renaming_folder_successfully'), 'renameFolder-imap')
            ctx.refreshFolderList()
          }
        });
      } else {
        this.showToast(this.getResourceString('app.string.Account_not_logged_in_please_login_and_try_again'), 'renameFolder-imap')
        router.back()
      }

    } catch (err) {
      ctx.showToast(this.getResourceString('app.string.Account_login_error') + `：${err.message}`, 'renameFolder-smtp')
    }
  }

  subBox() {
    const ctx = this;
    try {
      if (!ctx.selectFolder || ctx.selectFolder.length < 1) {
        ctx.showToast(this.getResourceString('app.string.Please_select_your_email_first'), 'subBox-imap')
        return
      }
      ctx.showToast(this.getResourceString('app.string.Subscribe_to_a_folder'), 'subBox-imap')
      if (GlobalObj?.getInstance()?.getClient()) {
        GlobalObj?.getInstance()?.getClient()?.subscribeBox(this.selectFolder, (err:Error) => {
          if (err) {
            ctx.showToast(this.getResourceString('app.string.Subscription_email_failed_reason') + `：${err.message}`, 'subBox-imap')
          } else {
            ctx.inputValue = '';
            ctx.textValue = '';
            ctx.showToast(this.getResourceString('app.string.Subscription_email_successful'), 'subBox-imap')
            // ctx.refreshFolderList()
          }
        });
      } else {
        this.showToast(this.getResourceString('app.string.Account_not_logged_in_please_login_and_try_again'), 'subBox-imap')
        router.back()
      }

    } catch (err) {
      ctx.showToast(this.getResourceString('app.string.Subscription_email_error') + `：${err.message}`, 'subBox-smtp')
    }
  }

  unSubBox() {
    const ctx = this;
    try {
      if (!ctx.selectFolder || ctx.selectFolder.length < 1) {
        ctx.showToast(this.getResourceString('app.string.Please_select_your_email_first'), 'unSubBox-imap')
        return
      }
      ctx.showToast(this.getResourceString('app.string.Unsubscribe_email'), 'unSubBox-imap')
      if (GlobalObj?.getInstance()?.getClient()) {
        GlobalObj?.getInstance()?.getClient()?.unsubscribeBox(this.selectFolder, (err:Error) => {
          if (err) {
            ctx.showToast(this.getResourceString('app.string.Unsubscribe_email_failed_reason') + `：${err.message}`, 'unSubBox-imap')
          } else {
            ctx.inputValue = '';
            ctx.textValue = '';
            ctx.showToast(this.getResourceString('app.string.Unsubscribed_email_successfully'), 'unSubBox-imap')
            // ctx.refreshFolderList()
          }
        });
      } else {
        this.showToast(this.getResourceString('app.string.Account_not_logged_in_please_login_and_try_again'), 'unSubBox-imap')
        router.back()
      }

    } catch (err) {
      ctx.showToast(this.getResourceString('app.string.Unsubscribe_email_error') + `：${err.message}`, 'unSubBox-smtp')
    }
  }

  getSubList() {
    const ctx = this;
    try {
      ctx.showToast(this.getResourceString('app.string.Start_returning_all_files'), 'closeBox-imap')
      if (GlobalObj?.getInstance()?.getClient()) {
        GlobalObj?.getInstance()?.getClient()?.getSubscribedBoxes((err:Error, result:MailBoxes) => {
          if (err) {
            ctx.showToast(this.getResourceString('app.string.Failed_to_retrieve_files_for_all_active_email_addresses_reason') + `：${err.message}`, 'expungeMail-imap')
          } else {
            ctx.showToast(this.getResourceString('app.string.Successfully_obtained_files_for_all_active_email_addresses'), 'expungeMail-imap')
            ctx.listData = [];
            let keyArr = Object.getOwnPropertyNames(result)
            for (let i = 0; i < keyArr.length; i++) {
              console.log(`zdy---getBoxes key--->${keyArr[i]}`);
              ctx.listData.push(keyArr[i])
            }
          }
        });
      } else {
        this.showToast(this.getResourceString('app.string.Account_not_logged_in_please_login_and_try_again'), 'expungeMail-imap')
        router.back()
      }
    } catch (err) {
      ctx.showToast(this.getResourceString('app.string.Error_obtaining_files_for_all_active_email_addresses') + `：${err.message}`, 'expungeMail-smtp')
    }
  }

  getResourceString(resourceName:string) {
    return getContext().resourceManager.getStringSync($r(resourceName).id)
  }
}