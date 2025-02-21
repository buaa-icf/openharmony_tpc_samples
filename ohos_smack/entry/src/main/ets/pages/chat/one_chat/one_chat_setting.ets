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

import { Toolbar } from '../../base/toolbar'
import prompt from '@ohos.prompt';
import { Constant } from '../../../entity/Constant'
import router from '@ohos.router';
import { Smack } from '@ohos/smack'
import { GlobalContext } from '../../../entity/GlobalContext';
import { promptAction } from '@kit.ArkUI';


@Entry
@Component
struct One_chat_setting {
  textDialog: CustomDialogController = new CustomDialogController({
    builder: TextDialog({}),
    customStyle: true,
    alignment: DialogAlignment.Center,
  })
  @State userName: string = ''

  aboutToAppear() {
    this.userName = (router.getParams() as Record<string, Object>)['userName'] as string
  }

  RandomStr(length: number, firstToUpper?: boolean) {
    let str = ""
    for (let i = 0; i < length; i++) {
      if (firstToUpper && i == 1) {
        str += String.fromCharCode(this.RangeInteger(97, 123)).toUpperCase()
      }
      str += String.fromCharCode(this.RangeInteger(97, 123))
    }
    return str
  }

  RangeInteger(min: number, max: number): number{
    const range = max - min
    const value = Math.floor(Math.random() * range) + min
    return value
  }

  build() {
    Flex({ direction: FlexDirection.Column }) {
      Toolbar({
        isBack: true,
        title: getContext().resourceManager.getStringByNameSync('OneChat_Stirng2') ,
      })

      Text(getContext().resourceManager.getStringByNameSync('OneChat_Stirng3'))
        .padding(15)
        .backgroundColor('#ffffff')
        .fontSize(18)
        .onClick(e => {
          this.textDialog.open()
        })
      Line().width('100%').height(1).backgroundColor('#ececec').margin({ left: 20 })
      Text(getContext().resourceManager.getStringByNameSync('OneChat_Stirng4')).padding(15).fontSize(18).backgroundColor('#ffffff')
        .onClick(e => {
          let roomName:string = Smack.username()+ this.RandomStr(3)
          Smack.createOrJoinRoom(roomName, Constant.HOST_DOMAIN, Constant.SERVICE_NAME/*, password?: string*/)

          setTimeout(() => {
            let isJoined = Smack.isJoined();
            if (isJoined == '1') {
              Smack.invite(this.userName+"@"+Constant.HOST_DOMAIN+Constant.HOST_RES, "invite");
              router.back();
              router.replaceUrl({
                url: 'pages/chat/group_chat/group_chat_main'
              })
            } else {
              promptAction.showToast({
                message: 'Create room error'
              })
            }
          }, 800)
        })
      Line().width('100%').height(1).backgroundColor('#ececec').margin({ left: 20 })
      Column() {
        Button('Delete Friends')
          .height(40)
          .fontSize(15)
          .width('50%')
          .backgroundColor('red')
          .margin({ top: 30 })
          .onClick(e => {
            this.onDeleteFriend()
          })
      }.width('100%')
    }
    .width('100%')
    .backgroundColor('#ececec')
  }

  // todo 删除好友
  onDeleteFriend() {
    Smack.delfriend(this.userName + "@" + Constant.HOST_DOMAIN);

    promptAction.showToast({
      message: 'Delete Success'
    })

    router.clear()
    router.replaceUrl({
      url: 'pages/main'
    })
  }
}

@CustomDialog
struct TextDialog {
  controller: CustomDialogController ={} as CustomDialogController
  @State newGroup: string = ''

  build() {
    Flex({ direction: FlexDirection.Column }) {
      Text('Please enter a new group name').fontSize(px2vp(30)).margin({top: 10})
      TextInput()
        .margin({ bottom: 20, top: 10})
        .height(px2vp(80))
        .fontSize(px2fp(30))
        .onChange(v => {
          this.newGroup = v
        })
      Button('Change')
        .height(px2vp(80))
        .fontSize(px2fp(30))
        .onClick(e => {
          this.onChangeFriendsGroup()
          this.controller.close()
        })
    }
    .width('90%')
    .backgroundColor('#ffffff')
    .height(px2vp(330))
    .padding(px2vp(20))
    .borderRadius(10)
  }

  // todo 修改好友分组信息
  onChangeFriendsGroup() {
    if (this.newGroup == '') {
      promptAction.showToast({
        message: 'Please enter the complete information'
      })
    } else {
      let name: string = (router.getParams() as Record<string, Object>)['userName'] as string
      Smack.changeFriendGroup(name + "@" + Constant.HOST_DOMAIN, this.newGroup);

      promptAction.showToast({
        message: 'Success'
      })
    }
  }
}