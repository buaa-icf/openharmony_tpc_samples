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
import { MUCOperation } from '@ohos/smack'
import { GroupUserEntity } from '../../../entity/GroupUserEntity';
import { Smack } from '@ohos/smack'
import { GlobalContext } from '../../../entity/GlobalContext';
import prompt from '@ohos.prompt';
import { promptAction } from '@kit.ArkUI';
import { GroupMember } from './group_chat_main';

export interface RoomItem {
  room: string;         // 房间完整路径
  name?: string;        // 成员名称（可选）
  affiliation?: string; // 成员身份（可选）
}

@Entry
@Component
struct Group_all_member {
  @State allList: Array<GroupUserEntity> = []
  @State adminList: Array<string> = []
  @State roomName: string = ''
  @State memberNumber:number=0
  @State IsBatch: boolean = false
  @State rightTxt: string = getContext().resourceManager.getStringByNameSync('Page_String40')
  private ownerList: Array<string> = [];
  private userName: string = '';

  aboutToAppear() {
    this.userName = GlobalContext.getContext().getValue('userName').toString().split('@')[0];
    this.onGetAllMemberFriends()
    this.onGetAllAdminFriends()
    this.onGetAllOwnerList();
  }


  //是否是管理员
  isAdmin(): boolean {
    if (this.adminList && this.adminList.length>0) {
      for (let i = 0; i < this.adminList.length; i++) {
        let user = this.adminList[i].split("@")[0];
        if (user == this.userName) {
          return true;
        }
      }
    }
    return false;
  }

  //是否是拥有者
  isOwner(): boolean {
    if (this.ownerList && this.ownerList.length>0) {
      for (let i = 0; i < this.ownerList.length; i++) {
        let user = this.ownerList[i].split("@")[0];
        if (user == this.userName) {
          return true;
        }
      }
    }
    return false;
  }

  //是否可以执行操作
  isOprationer(): boolean {
    return this.isOwner() || this.isAdmin();
  }

  //获取房屋拥有者列表
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

  // todo 查看所有群成员
  onGetAllMemberFriends() {
    this.allList = []
    let roomitems: Array<RoomItem> = JSON.parse(Smack.getRoomItems())
    if (roomitems) {
      for (let index = 0; index < roomitems.length; index++) {
        let str :string= roomitems[index].room.replace(" ", "")
        str = str.substr(str.lastIndexOf("/") + 1, str.length - 1)
        this.allList.push({ name: str, isCheck: 0 });
        this.memberNumber=this.allList.length
      }
    }
  }
  // todo 查看所有群管理
  onGetAllAdminFriends() {
    this.adminList = []
    let roomitems = Smack.requestList(MUCOperation.RequestAdminList)
    if (roomitems) {
      let items:Array<GroupMember>=JSON.parse(roomitems)
      for (let index = 0; index < items.length; index++) {
        let str :string= items[index].jid.replace(" ", "")
        this.adminList.push(str);
      }
    }
  }

  onGetOperations(): Array<GroupUserEntity>{
    let users : Array<GroupUserEntity> =[]
    for (let index = 0; index < this.allList.length; index++) {
      const element = this.allList[index];
      if (element.isCheck == 1) {
        users.push(element)
      }
    }
    return users
  }


  build() {
    Flex({ direction: FlexDirection.Column }) {
      Toolbar({
        title: getContext().resourceManager.getStringByNameSync('GroupAll_String1'),
        isBack: true,
      })
      Text(getContext().resourceManager.getStringByNameSync('GroupAll_String2'))
        .width('100%')
        .fontSize(18)
        .alignSelf(ItemAlign.Center)
        .backgroundColor(Color.White)
        .height(40)
        .padding({ left: 20 })
      List() {
        ForEach(this.adminList, (item:string) => {
          ListItem() {
            Text(item)
              .padding(13)
              .backgroundColor('#ffffff')
              .fontSize(18)
              .width('100%')
              .margin({ top: 1 })
              .onClick(v => {
                if (!this.isOwner()) {
                  promptAction.showToast({
                    message: getContext().resourceManager.getStringByNameSync('GroupAll_String3')
                  })
                  return;
                }
                router.pushUrl({
                  url: 'pages/chat/group_chat/group_member',
                  params: { userData: [item] }
                })
              })
          }
        }, (item:string) => JSON.stringify(item))
      }

      Row() {

        Text(getContext().resourceManager.getStringByNameSync('GroupAll_String4')+ "("+this.memberNumber+")")
          .width('60%')
          .fontSize(18)
          .alignSelf(ItemAlign.Center)
          .backgroundColor(Color.White)
          .height(40)
          .padding({ left: 20 })
        Text(this.IsBatch ? getContext().resourceManager.getStringByNameSync('GroupAll_String5') : getContext().resourceManager.getStringByNameSync('Page_String40'))
          .height(40)
          .padding({ right: 20 })
          .fontSize(18)
          .backgroundColor(Color.White)
          .width('40%')
          .alignSelf(ItemAlign.Center)
          .textAlign(TextAlign.End)
          .onClick(v => {
            if (!this.isOprationer()) {
              promptAction.showToast({
                message: getContext().resourceManager.getStringByNameSync('GroupAll_String6')
              })
              return;
            }
            if (this.IsBatch) {
              let users : Array<GroupUserEntity> = this.onGetOperations();
              if (users && users.length>0) {
                router.pushUrl({
                  url: 'pages/chat/group_chat/group_member',
                  params: { userData: users}
                })
              }
            }
            this.IsBatch = !this.IsBatch
          })
      }

      List() {
        ForEach(this.allList, (item :GroupUserEntity) => {
          ListItem() {
            Row() {
              if (this.IsBatch) {
                Checkbox({ name: 'checkbox2', group: 'checkboxGroup' })
                  .select(false)
                  .selectedColor(0x39a2db)
                  .onChange((value: boolean) => {
                    console.info('Checkbox2 change is' + value)
                    item.isCheck = value ? 1 : 0;
                  })
              }
              Text(item.name)
                .padding(13)
                .fontSize(18)
                .width('100%')
                .margin({ top: 1 })
                .onClick(v => {
                  if (!this.isOprationer()) {
                    promptAction.showToast({
                      message: getContext().resourceManager.getStringByNameSync('GroupAll_String6')
                    })
                    return;
                  }
                  router.pushUrl({
                    url: 'pages/chat/group_chat/group_member',
                    params: { userData: [item] }
                  })
                })
            }

          }.backgroundColor('#ffffff')
        }, (item :GroupUserEntity) => JSON.stringify(item))
      }
    }
    .backgroundColor('#ececec')
  }
}