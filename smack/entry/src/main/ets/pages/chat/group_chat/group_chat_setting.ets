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
import { ItemText } from '../../base/ItemText';
import { Constant } from '../../../entity/Constant';
import { Smack } from '@ohos/smack'
import { GlobalContext } from '../../../entity/GlobalContext';

@Entry
@Component
struct Group_chat_setting {
  @State name:string=""
  InviteDialog: CustomDialogController = new CustomDialogController({
    builder: InviteDialog({}),
    customStyle: true,
    alignment: DialogAlignment.Center,
  })
  updateThemeDialog: CustomDialogController = new CustomDialogController({
    builder: UpdateThemeDialog({}),
    customStyle: true,
    alignment: DialogAlignment.Center,
  })
  updateNickDialog: CustomDialogController = new CustomDialogController({
    builder: UpdateNickDialog({nick:$name}),
    customStyle: true,
    alignment: DialogAlignment.Center,
  })
  aboutToAppear(){
    this.name = Smack.nick();
  }

  build() {
    Flex({ direction: FlexDirection.Column }) {
      Toolbar({
        isBack: true,
        title: '群聊设置',
      })
      ItemText({title:"查看所有群成员",clickEvent:()=>{
        router.push({
          url: 'pages/chat/group_chat/group_all_member'
        })
      }})
      ItemText({title:"编辑房间配置",clickEvent:()=>{
        router.push({
          url: 'pages/chat/group_chat/group_chat_edit'
        })
      }})
      ItemText({title:"邀请新用户",clickEvent:()=>{
        this.InviteDialog.open()
      }})
      ItemText({title:"修改房间主题",clickEvent:()=>{
        this.updateThemeDialog.open()
      }})

        Column() {
          Row(){
            Text("我在群聊中的昵称")
              .fontSize(15)
              .width('60%')
              .height(50)
              .fontColor(Color.Black)
              .onClick(v => {
                this.updateNickDialog.open()
              })
            Text(this.name)
              .fontSize(15)
              .width('30%')
              .padding({ right: 20 })
              .height(50)
              .textAlign(TextAlign.End)
              .alignSelf(ItemAlign.Center)
              .fontColor(Color.Black)

          }
          Line().width('100%').height(1).backgroundColor('#ececec').margin({ left: 20 })
        }
        .padding({ left: 15 }).height(54)
        .width('100%').backgroundColor(Color.White)


      Button('退 出 群 聊').backgroundColor('red').margin({ top: 30 })
        .onClick(e => {
          this.onExitGroup()
        })
    }
    .width('100%')
  }

  // todo 退出群聊
  onExitGroup() {
    //销毁房间,群主可调用
    Smack.destroy(GlobalContext.getContext().getValue('userName') as string, "123");
  }
}
@CustomDialog
struct UpdateThemeDialog {
  controller: CustomDialogController = {} as CustomDialogController;
  @State theme: string = ''

  // todo 修改主题
  private onChangTheme() {
    if (this.theme == '') {
      prompt.showToast({
        message: "请输入新的群聊主题"
      })
    }
  }

  build() {
    Flex({ direction: FlexDirection.Column }) {
      Text('请输入群聊主题')
        .height(40)
        .fontSize(15).padding(10)
      TextInput()
        .height(40)
        .fontSize(15)
        .onChange(v => {
          this.theme = v
        })

      Button('确定')
        .height(40)
        .fontSize(15)
        .onClick(e => {
          Smack.setSubject("subject");
          //          this.onChangTheme()
          this.controller.close()

        }).margin({ top: 20 })
    }
    .padding(20)
    .height(180)
    .backgroundColor('#ffffff')
    .borderRadius(10)
    .width('80%')
  }
}
@CustomDialog
struct UpdateNickDialog {
  controller: CustomDialogController  = {} as CustomDialogController;
   nickStr: string=''
  @Link nick: string
  // todo 修改昵称
  private onChangTheme() {
    if (this.nickStr == '') {
      prompt.showToast({
        message: "请输入新的群内昵称"
      })
    }
  }

  build() {
    Flex({ direction: FlexDirection.Column }) {
      Text('请输入群内昵称')
        .height(40)
        .fontSize(15).padding(10)
      TextInput({})
        .height(40)
        .fontSize(15)
        .onChange(v => {
          this.nickStr = v
        })

      Button('确定')
        .height(40)
        .fontSize(15)
        .onClick(e => {
          Smack.setNick(this.nickStr)
          this.nick=this.nickStr
          this.controller.close()
        }).margin({ top: 20 })
    }
    .padding(20)
    .height(180)
    .backgroundColor('#ffffff')
    .borderRadius(10)
    .width('80%')
  }
}

@CustomDialog
struct InviteDialog {
  controller: CustomDialogController = {} as CustomDialogController
  @State invite: string = ''

  // todo 邀请新用户
  private onChangTheme() {
    if (this.invite == '') {
      prompt.showToast({
        message: "请输入被邀请用户名"
      })
    }
  }

  build() {
    Flex({ direction: FlexDirection.Column }) {
      Text('请输入被邀请用户名')
        .height(40)
        .fontSize(15).padding(10)
      TextInput()
        .height(40)
        .fontSize(15)
        .onChange(v => {
          this.invite = v
        })

      Button('确定')
        .height(40)
        .fontSize(15)
        .onClick(e => {
          Smack.invite(this.invite+"@"+Constant.HOST_DOMAIN+Constant.HOST_RES, "invite");
          //          this.onChangTheme()
          this.controller.close()

        }).margin({ top: 20 })
    }
    .padding(20)
    .height(180)
    .backgroundColor('#ffffff')
    .borderRadius(10)
    .width('80%')
  }
}
