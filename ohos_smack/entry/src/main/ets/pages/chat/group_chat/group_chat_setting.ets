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
import { Smack, MUCOperation } from '@ohos/smack'
import { GlobalContext } from '../../../entity/GlobalContext';
import { promptAction } from '@kit.ArkUI';
import { GroupMember } from './group_chat_main';

@Entry
@Component
struct Group_chat_setting {
  @State name:string=""
  private role: string = '';
  private affiliation: string = '';
  private ownerList: Array<string> = [];

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
  onPageShow(): void {
    this.onGetAllOwnerList();
  }
  onGetAllOwnerList() {
    this.ownerList = []
    let roomitems = Smack.requestList(MUCOperation.RequestOwnerList)
    if (roomitems) {
      let items:Array<GroupMember>=JSON.parse(roomitems)
      for (let index = 0; index < items.length; index++) {
        let str :string= items[index].jid.replace(" ", "")
        this.ownerList.push(str);
      }
    }
  }

  isRoomOwner(): boolean {
    let flag  = false;
    let userName = GlobalContext.getContext().getValue('userName').toString().split('@')[0];
    if (this.ownerList && this.ownerList.length > 0) {
      for (let i = 0; i < this.ownerList.length; i++) {
        let user = this.ownerList[i].split("@")[0];
        if (user == userName) {
          flag = true;
          break;
        }
      }
    }
    return flag;
  }


  build() {
    Flex({ direction: FlexDirection.Column }) {
      Toolbar({
        isBack: true,
        title: 'Setting',
      })
      ItemText({title:getContext().resourceManager.getStringByNameSync('GroupChat_String26') ,clickEvent:()=>{
        router.pushUrl({
          url: 'pages/chat/group_chat/group_all_member'
        })
      }})
      ItemText({title:getContext().resourceManager.getStringByNameSync('GroupChat_String27'),clickEvent:()=>{
        if (this.isRoomOwner()) {
          router.pushUrl({
            url: 'pages/chat/group_chat/group_chat_edit'
          })
        } else {
          promptAction.showToast({
            message: 'operation failed'
          })
        }
      }})
      // ItemText({title:"邀请新用户",clickEvent:()=>{
      //   this.InviteDialog.open()
      // }})
      ItemText({title:getContext().resourceManager.getStringByNameSync('GroupChat_String28'),clickEvent:()=>{
        this.updateThemeDialog.open()
      }})

      Column() {
        Row(){
          Text("Name in Group")
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


      Button('Destroy group chat').backgroundColor('red').margin({ top: 30 })
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
    router.back()
    let options: router.RouterOptions = {
      url: 'pages/main'
    };
    router.replaceUrl(options)
  }
}
@CustomDialog
struct UpdateThemeDialog {
  controller: CustomDialogController = {} as CustomDialogController;
  @State theme: string = ''

  // todo 修改主题
  private onChangTheme() {
    if (this.theme == '') {
      promptAction.showToast({
        message: "Input New Group Chat"
      })
    }
  }

  build() {
    Flex({ direction: FlexDirection.Column }) {
      Text('Input Group Chat')
        .height(40)
        .fontSize(15).padding(10)
      TextInput()
        .height(40)
        .fontSize(15)
        .onChange(v => {
          this.theme = v
        })

      Button('Confirm')
        .height(40)
        .fontSize(15)
        .onClick(e => {
          if (this.theme) {
            Smack.setSubject(this.theme);
          }
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
      promptAction.showToast({
        message: "Input New Name in Group"
      })
    }
  }

  build() {
    Flex({ direction: FlexDirection.Column }) {
      Text('Input Name in Group')
        .height(40)
        .fontSize(15).padding(10)
      TextInput({})
        .height(40)
        .fontSize(15)
        .onChange(v => {
          this.nickStr = v
        })

      Button('Confirm')
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
      promptAction.showToast({
        message: "Please enter the invited username"
      })
    }
  }

  build() {
    Flex({ direction: FlexDirection.Column }) {
      Text('Please enter the invited username')
        .height(40)
        .fontSize(15).padding(10)
      TextInput()
        .height(40)
        .fontSize(15)
        .onChange(v => {
          this.invite = v
        })

      Button('Confirm')
        .height(40)
        .fontSize(15)
        .onClick(e => {
          Smack.invite(this.invite+"@"+Constant.HOST_DOMAIN+Constant.HOST_RES, "invite");
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