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
import { MUCOperation } from '@ohos/smack'
@Entry
@Component
struct Group_all_member {
  @State allList: Array<{
    name: string,
    isCheck: number
  }> = []
  @State adminList: Array<string> = []
  @State roomName: string = ''
  @State memberNumber:number=0
  @State IsBatch: boolean = false
  @State rightTxt: string = '批量操作'

  aboutToAppear() {
    this.onGetAllMemberFriends()
    this.onGetAllAdminFriends()
  }

  // todo 查看所有群成员
  onGetAllMemberFriends() {
    this.allList = []
    let roomitems: Array<any> = JSON.parse(globalThis.Smack.getRoomItems())
    for (var index = 0; index < roomitems.length; index++) {
      let str = roomitems[index].room.replace(" ", "")
      str = str.substr(str.lastIndexOf("/") + 1, str.length - 1)
      this.allList.push({ name: str, isCheck: 0 });
      this.memberNumber=this.allList.length
    }
  }
  // todo 查看所有群管理
  onGetAllAdminFriends() {
    this.adminList = []
    let roomitems = globalThis.Smack.requestList(MUCOperation.RequestAdminList)
    let items=JSON.parse(roomitems)
    for (var index = 0; index < items.length; index++) {
      let str = items[index].jid.replace(" ", "")
      this.adminList.push(str);
    }
  }

  onGetOperations(): Array<any>{
    let users = []
    for (var index = 0; index < this.allList.length; index++) {
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
        title: '群成员',
        isBack: true,
      })
      Text("管理员")
        .width('100%')
        .fontSize(18)
        .alignSelf(ItemAlign.Center)
        .backgroundColor(Color.White)
        .height(40)
        .padding({ left: 20 })
      List() {
        ForEach(this.adminList, item => {
          ListItem() {
            Text(item)
              .padding(13)
              .backgroundColor('#ffffff')
              .fontSize(18)
              .width('100%')
              .margin({ top: 1 })
              .onClick(v => {
                router.push({
                  url: 'pages/chat/group_chat/group_member',
                  params: { userData: [item] }
                })
              })
          }
        }, item => item.toString())
      }

      Row() {

        Text("成员 ("+this.memberNumber+")")
          .width('60%')
          .fontSize(18)
          .alignSelf(ItemAlign.Center)
          .backgroundColor(Color.White)
          .height(40)
          .padding({ left: 20 })
        Text(this.IsBatch ? "完成" : "批量操作")
          .height(40)
          .padding({ right: 20 })
          .fontSize(18)
          .backgroundColor(Color.White)
          .width('40%')
          .alignSelf(ItemAlign.Center)
          .textAlign(TextAlign.End)
          .onClick(v => {
            if (this.IsBatch) {
              router.push({
                url: 'pages/chat/group_chat/group_member',
                params: { userData: this.onGetOperations() }
              })
            }
            this.IsBatch = !this.IsBatch
          })
      }

      List() {
        ForEach(this.allList, item => {
          ListItem() {
            Row() {
              if (this.IsBatch) {
                Checkbox({ name: 'checkbox2', group: 'checkboxGroup' })
                  .select(false)
                  .selectedColor(0x39a2db)
                  .onChange((value: boolean) => {
                    console.info('Checkbox2 change is' + value)
                    item.isCheck = value
                  })
              }
              Text(item.name)
                .padding(13)
                .fontSize(18)
                .width('100%')
                .margin({ top: 1 })
                .onClick(v => {
                  router.push({
                    url: 'pages/chat/group_chat/group_member',
                    params: { userData: [item] }
                  })
                })
            }

          }.backgroundColor('#ffffff')
        }, item => item.name)
      }
    }
    .backgroundColor('#ececec')
  }
}