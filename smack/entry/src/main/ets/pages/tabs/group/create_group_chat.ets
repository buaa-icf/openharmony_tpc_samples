/*
  Copyright (C) 2022 Huawei Device Co., Ltd.

  This software is distributed under a license. The full license
  agreement can be found in the file LICENSE in this distribution.
  This software may not be copied, modified, sold or distributed
  other than expressed in the named license agreement.
  This software is distributed without any warranty.
*/

import { Toolbar } from '../../base/toolbar'
import router from '@ohos.router';
import prompt from '@ohos.prompt';
import { Constant } from '../../../entity/Constant'


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
        title: '创建群聊',
        isBack: true
      })
      Flex({ direction: FlexDirection.Column }) {
        Text('群聊名称').fontSize(15).padding(10)
        TextInput().onChange(v => {
          this.inputName = v
        })
        //        Text('描述').fontSize(15).padding(10)
        //        TextInput()
        //        Text('最大用户数').fontSize(15).padding(10)
        //        TextInput().type(InputType.Number)
        Button('创 建').onClick(e => {
          if (this.inputName != '') {
            this.onCreateGroupChat(this.inputName)
          } else {
            prompt.showToast({ message: "请输入房间名" })
          }
        }).margin({ top: 20 })
        Button('加入密码房').onClick(e => {
          globalThis.Smack.createRoom("555@" + Constant.HOST_IP + Constant.HOST_RES, "room", Constant.HOST_DOMAIN, Constant.SERVICE_NAME);
          this.passWordDialog.open()
        }).margin({ top: 20 })
      }
      .padding(30)
    }
    .backgroundColor('#ffffff')
    .borderRadius(10)
  }

  // todo 创建群聊
  onCreateGroupChat(input: string) {
    globalThis.Smack.createRoom(globalThis.userName, input, Constant.HOST_DOMAIN, Constant.SERVICE_NAME);
    prompt.showToast({
      message: '房间创建成功'
    })
    setTimeout(() => {
      router.replace({
        url: 'pages/chat/group_chat/group_chat_main'
      })
    }, 1000)
  }
}

@CustomDialog
struct PassWordDialog {
  controller: CustomDialogController
  inputStr: string = ''

  build() {
    Flex({ direction: FlexDirection.Column }) {
      Text('密码').fontSize(15).padding(10)
      TextInput().onChange(v => {
        this.inputStr = v
      })
      Button('确 定').onClick(e => {
        globalThis.Smack.setPassword(this.inputStr)
        this.onJoinInMeeting()
        this.controller.close()
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
      globalThis.Smack.join();
      this.controller.close()
    }, 500)
  }
}