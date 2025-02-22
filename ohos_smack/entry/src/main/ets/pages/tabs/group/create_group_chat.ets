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
import router from '@ohos.router';
import prompt from '@ohos.prompt';
import { Constant } from '../../../entity/Constant'
import { Smack } from '@ohos/smack'
import { GlobalContext } from '../../../entity/GlobalContext';
import { promptAction } from '@kit.ArkUI';


@Entry
@Component
struct Create_group_chat {
  inputName: string = ''
  passWordDialog: CustomDialogController = new CustomDialogController({
    builder: PassWordDialog({}),
    customStyle: true,
    alignment: DialogAlignment.Center,

  })

  build() {
    Flex({ direction: FlexDirection.Column }) {
      Toolbar({
        title: 'Create a group chat',
        isBack: true
      })
      Flex({ direction: FlexDirection.Column }) {
        Text('Group chat name').fontSize(15).padding(10)
        TextInput().onChange(v => {
          this.inputName = v
        })
        Button('Create').onClick(e => {
          if (this.inputName != '') {
            this.onCreateGroupChat(this.inputName)
          } else {
            promptAction.showToast({ message: "Please enter the room name" })
          }
        }).margin({ top: 20 })
        Button('Join the password room').onClick(e => {
          if (this.inputName) {
            Smack.createRoom(GlobalContext.getContext().getValue('userName') as string, this.inputName, Constant.HOST_DOMAIN, Constant.SERVICE_NAME);
            this.passWordDialog.open()
          } else {
            promptAction.showToast({
              message: 'Enter room name'
            })
          }
        }).margin({ top: 20 })
      }
      .padding(30)
    }
    .backgroundColor('#ffffff')
    .borderRadius(10)
  }

  // todo 创建群聊
  onCreateGroupChat(input: string) {
    Smack.createRoom(GlobalContext.getContext().getValue('userName') as string, input, Constant.HOST_DOMAIN, Constant.SERVICE_NAME);
    setTimeout(() => {
      Smack.join();
    }, 500)

    setTimeout(() => {
      if (Smack.isJoined() == '1') {
        promptAction.showToast({
          message: 'Room created successfully'
        })
        router.replaceUrl({
          url: 'pages/chat/group_chat/group_chat_main'
        })
      } else {
        promptAction.showToast({
          message: 'Failed to enter the room'
        })
      }
    }, 1200)
  }
}

@CustomDialog
struct PassWordDialog {
  controller: CustomDialogController = {} as CustomDialogController;
  inputStr: string = ''

  build() {
    Flex({ direction: FlexDirection.Column }) {
      Text('Password').fontSize(15).padding(10)
      TextInput().onChange(v => {
        this.inputStr = v
      })
      Button('Confirm').onClick(e => {
        Smack.setPassword(this.inputStr)
        this.onJoinInMeeting()
        if(this.controller != null)
        {
          this.controller.close()
        }
      }).margin({ top: 20 })
    }
    .padding(20)
    .height(px2vp(280))
    .backgroundColor('#ffffff')
    .borderRadius(10)
    .width('80%')
  }

  // todo 从会议列表里进入会议
  onJoinInMeeting() {
    setTimeout(() => {
      Smack.join();
      if(this.controller != null)
      {
        this.controller.close()
      }
      setTimeout(() => {
        if (Smack.isJoined() == '1') {
          router.replaceUrl({
            url: 'pages/chat/group_chat/group_chat_main'
          })
        } else {
          promptAction.showToast({
            message: 'Failed to enter the room'
          })
        }
      }, 1000)
    }, 500)
  }
}