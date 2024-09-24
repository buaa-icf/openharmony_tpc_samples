/**
 * Copyright (C) 2023 Huawei Device Co., Ltd.
 *
 * This software is distributed under a license. The full license
 * agreement can be found in the file LICENSE in this distribution.
 * This software may not be copied, modified, sold or distributed
 * other than expressed in the named license agreement.
 *
 * This software is distributed without any warranty.
 */

import { Toolbar } from '../base/toolbar'
import { PresenceType } from '@ohos/smack'
import prompt from '@ohos.prompt';
import router from '@ohos.router';
import { PresenceRoomType, Smack } from '@ohos/smack'
@Entry
@Component
export struct Setting {
  private states: string[] = [
    getContext().resourceManager.getStringByNameSync('GroupMember_String2') ,
    getContext().resourceManager.getStringByNameSync('GroupMember_String1') ,
    getContext().resourceManager.getStringByNameSync('GroupMember_String3') ,
    getContext().resourceManager.getStringByNameSync('GroupMember_String5') ,
    getContext().resourceManager.getStringByNameSync('GroupMember_String4') ]
  @State select: number = 1
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogExample(),
    customStyle: true,
    alignment: DialogAlignment.Center,
  })

  build() {
    Column() {
      Toolbar({ title: 'Setting' })

      Column() {
        Text('Change Password')
          .width('100%')
          .padding(px2vp(30))
          .fontSize(px2fp(30))
          .margin({ bottom: 1 })
          .onClick(e => {
            this.dialogController.open()
          })
          .backgroundColor('#ffffff')

        Text('Setting State （' + this.states[this.select] + '）')
          .width('100%')
          .padding(px2vp(30))
          .fontSize(px2fp(30))
          .margin({ bottom: 1 })
          .backgroundColor('#ffffff')
          .onClick(e => {
            TextPickerDialog.show({
              range: this.states,
              selected: this.select,
              onAccept: (value: TextPickerResult) => {
                if(typeof value.index == 'number')
                {
                  this.select = value.index as number;
                  this.onSetOnLineState()
                }

              }
            })

          })
        Divider().color('#ffe7e7e7')

        Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
          Button('log Out')
            .backgroundColor('red')
            .height(px2vp(80))
            .width('30%')
            .fontSize(px2fp(30))
            .onClick(e => {
              AlertDialog.show({
                title: 'TIP',
                message: 'Are you sure to log out?',
                confirm: {
                  value: 'Yes',
                  action: () => {
                    this.onExitAccount()
                  }
                }
              })
            })

          Button('Account cancellation')
            .margin({ left: 20 })
            .backgroundColor('red')
            .height(px2vp(80))
            .fontSize(px2fp(30))
            .width('30%')
            .onClick(e => {
              AlertDialog.show({
                title: 'TIP',
                message: 'Are you sure to cancel your account？',
                confirm: {
                  value: 'Yes',
                  action: () => {
                    this.onDeleteAccount()
                  }
                }
              })
            })
        }.padding({ top: 30 }).backgroundColor('#ffffff')
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#ffffff')
  }

  // todo 退出登录
  private onExitAccount() {
    Smack.loginout();
    router.clear()
    router.replace({
      url: 'pages/user/login'
    })
  }

  // todo 账号删除
  private onDeleteAccount() {
    Smack.unregister()
    router.replace({
      url: 'pages/user/login'
    })
  }

  // todo 设置在线状态
  private onSetOnLineState() {
    let presenceType: PresenceType = PresenceType.Available
    if (this.select == 0) {
      presenceType = PresenceType.Chat
    } else if (this.select == 1) {
      presenceType = PresenceType.Available
    } else if (this.select == 2) {
      presenceType = PresenceType.Away
    } else if (this.select == 3) {
      presenceType = PresenceType.Xa
    } else if (this.select == 4) {
      presenceType = PresenceType.Dnd
    }
    Smack.changePresence(presenceType, this.states[this.select])
  }
}

@CustomDialog
struct CustomDialogExample {
  controller: CustomDialogController ={} as CustomDialogController;
  @State pass1: string = ''
  @State pass2: string = ''

  // todo 修改密码
  private onChangPassword() {
    if (this.pass1 == '' || this.pass2 == '') {
      prompt.showToast({
        message: "Please Input data"
      })
    } else if (this.pass1 !== this.pass2) {
      prompt.showToast({
        message: "Password error"
      })
    } else {
      Smack.changPwd(this.pass1)
      prompt.showToast({
        message: "Modified successfully"
      })
      console.log('Password modification completed');
    }
  }

  build() {
    Flex({ direction: FlexDirection.Column }) {
      Text('Please Input New Password')
        .height(px2vp(80))
        .fontSize(px2fp(30)).padding(px2vp(10))
      TextInput()
        .height(px2vp(80))
        .fontSize(px2fp(30))
        .padding({left: px2vp(15), top: 0, bottom: 0})
        .onChange(v => {
          this.pass1 = v
        })
      Text('Please Input New Password Again')
        .height(px2vp(80))
        .fontSize(px2fp(30))
        .padding(px2vp(10))
      TextInput()
        .height(px2vp(80))
        .fontSize(px2fp(30))
        .padding({left: px2vp(15), top: 0, bottom: 0})
        .onChange(v => {
          this.pass2 = v
        })
      Button('Confirm')
        .height(px2vp(80))
        .fontSize(px2fp(30))
        .onClick(e => {
          this.onChangPassword()
          if(this.controller != null){
            this.controller.close()
          }
        }).margin({ top: 20 })
    }
    .padding(20)
    .height(px2vp(500))
    .backgroundColor('#ffffff')
    .borderRadius(10)
    .width('80%')
  }
}