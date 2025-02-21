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
import { ItemText } from '../../base/ItemText'

import { MUCRoomAffiliation, MUCRoomRole } from '@ohos/smack'
import { PresenceRoomType } from '@ohos/smack'
import router from '@ohos.router';
import { GroupUserEntity } from '../../../entity/GroupUserEntity'
import { Smack } from '@ohos/smack'

@Entry
@Component
struct group_all_member {
  @State isAdministrator: boolean = false //是否为管理员
  @State isMember: boolean = false //是否为会员
  @State isOwner: boolean = false //是否为群主
  @State isBanned: boolean = false //是否禁言
  @State isCompere: boolean = false //是否为主持人
  private states: string[] = [getContext().resourceManager.getStringByNameSync('GroupMember_String1') ,
    getContext().resourceManager.getStringByNameSync('GroupMember_String2') ,
    getContext().resourceManager.getStringByNameSync('GroupMember_String3') ,
    getContext().resourceManager.getStringByNameSync('GroupMember_String4') ,
    getContext().resourceManager.getStringByNameSync('GroupMember_String5') ,
    getContext().resourceManager.getStringByNameSync('GroupMember_String6') ]
  @State select: number = 0
  @State users: Array<GroupUserEntity> = []

  // todo 设置用户在线状态
  private onSetOnLineState() {
    let presenceType: PresenceRoomType = PresenceRoomType.Available
    let state = 'Available'
    if (this.select == 0) {
      state = 'Available'
      presenceType = PresenceRoomType.Available
    } else if (this.select == 1) {
      state = 'Chat'
      presenceType = PresenceRoomType.Chat
    } else if (this.select == 2) {
      state = 'Away'
      presenceType = PresenceRoomType.Away
    } else if (this.select == 3) {
      state = 'DND'
      presenceType = PresenceRoomType.DND
    } else if (this.select == 4) {
      state = 'XA'
      presenceType = PresenceRoomType.XA
    } else if (this.select == 5) {
      state = 'Unavailable'
      presenceType = PresenceRoomType.Unavailable
    }
    Smack.setPresence(presenceType, state)
  }

  public aboutToAppear() {
    this.users = (router.getParams() as Record<string, Object>)['userData'] as Array<GroupUserEntity>
  }

  public getUsers(): string{
    let str = ""
    for (let i = 0;i < this.users.length; i++) {
      let item = this.users[i]
      str = str.concat(item.name)
      if (i != this.users.length - 1)
      str = str.concat(",")
    }
    return str
  }

  build() {
    Column() {
      Toolbar({
        title: '',
        isBack: true
      })
      Row() {
        List({}) {
          ForEach(this.users, (item : GroupUserEntity) => {
            ListItem() {
              Row() {
                Image($r('app.media.app_icon')).height(60).width(60).borderRadius(10)
                Text(item.name)
                  .padding(13)
                  .backgroundColor('#ffffff')
                  .fontSize(18)
              }
            }.enabled(true)
          }, (item : GroupUserEntity) => item.name)
        }.width('100%')
        .listDirection(Axis.Horizontal) // 排列方向

      }.height(100).margin({ left: 20, top: 20 })

      ItemText({ title: "Kick out group chat", clickEvent: () => {
        if (this.users.length == 1) {
          Smack.kick(this.users[0].name, "kick");
        } else {
          Smack.bans(this.getUsers(), "bans");
        }
        router.back()
      } })

      ItemText({ title: "JOIN IN BLACKLIST", clickEvent: () => {
        Smack.ban(this.users[0].name, "ban");
      } })

      if (this.isCompere) {

        ItemText({ title:getContext().resourceManager.getStringByNameSync('GroupMember_String7'), clickEvent: () => {
          this.isCompere = !this.isCompere
          if (this.users.length > 1) {
            Smack.setRoles(this.getUsers(), MUCRoomRole.RoleParticipant, "RoleParticipant");
          } else {
            Smack.setRole(this.users[0].name, MUCRoomRole.RoleParticipant, "RoleParticipant");
          }
        } })

      } else {
        ItemText({ title: getContext().resourceManager.getStringByNameSync('GroupMember_String8'), clickEvent: () => {
          this.isCompere = !this.isCompere
          if (this.users.length > 1) {
            Smack.setRoles(this.getUsers(), MUCRoomRole.RoleModerator, "RoleModerator");
          } else {
            Smack.setRole(this.users[0].name, MUCRoomRole.RoleModerator, "RoleModerator");
          }
        } })
      }
      ItemText({ title: getContext().resourceManager.getStringByNameSync('GroupMember_String9'), clickEvent: () => {
        TextPickerDialog.show({
          range: this.states,
          selected: this.select,
          onAccept: (value: TextPickerResult) => {
            if(typeof value.index == 'number'){
              this.select = (value.index as number);
              this.onSetOnLineState()
            }

          }
        })
      } })

      if (this.isAdministrator) {

        ItemText({ title: getContext().resourceManager.getStringByNameSync('GroupMember_String10'), clickEvent: () => {
          this.isAdministrator = !this.isAdministrator
          if (this.users.length > 1) {
            Smack.setAffiliations(this.getUsers(), MUCRoomAffiliation.AffiliationNone, "AffiliationNone");
          } else {
            Smack.setAffiliation(this.users[0].name, MUCRoomAffiliation.AffiliationNone, "AffiliationNone");
          }
        } })

      } else {
        ItemText({ title: getContext().resourceManager.getStringByNameSync('GroupMember_String11'), clickEvent: () => {
          this.isAdministrator = !this.isAdministrator
          if (this.users.length > 1) {
            Smack.setAffiliations(this.getUsers(), MUCRoomAffiliation.AffiliationAdmin, "AffiliationAdmin");
          } else {
            Smack.setAffiliation(this.users[0].name, MUCRoomAffiliation.AffiliationAdmin, "AffiliationAdmin");
          }
        } })

      }
      if (this.isMember) {
        ItemText({ title: getContext().resourceManager.getStringByNameSync('GroupMember_String12'), clickEvent: () => {
          this.isMember = !this.isMember
          if (this.users.length > 1) {
            Smack.setAffiliations(this.getUsers(), MUCRoomAffiliation.AffiliationNone, "AffiliationNone");
          } else {
            Smack.setAffiliation(this.users[0].name, MUCRoomAffiliation.AffiliationNone, "AffiliationNone");
          }
        } })

      } else {
        ItemText({ title: getContext().resourceManager.getStringByNameSync('GroupMember_String13'), clickEvent: () => {
          this.isMember = !this.isMember
          if (this.users.length > 1) {
            Smack.setAffiliations(this.getUsers(), MUCRoomAffiliation.AffiliationMember, "AffiliationMember");
          } else {
            Smack.setAffiliation(this.users[0].name, MUCRoomAffiliation.AffiliationMember, "AffiliationMember");
          }
        } })
      }
      if (this.isOwner) {
        ItemText({ title: getContext().resourceManager.getStringByNameSync('GroupMember_String14'), clickEvent: () => {
          this.isOwner = !this.isOwner
          if (this.users.length > 1) {
            Smack.setAffiliations(this.getUsers(), MUCRoomAffiliation.AffiliationNone, "AffiliationNone");
          } else {
            Smack.setAffiliation(this.users[0].name, MUCRoomAffiliation.AffiliationNone, "AffiliationNone");
          }
        } })
      } else {
        ItemText({ title: getContext().resourceManager.getStringByNameSync('GroupMember_String15'), clickEvent: () => {
          this.isOwner = !this.isOwner
          if (this.users.length > 1) {
            Smack.setAffiliations(this.getUsers(), MUCRoomAffiliation.AffiliationOwner, "AffiliationOwner");
          } else {
            Smack.setAffiliation(this.users[0].name, MUCRoomAffiliation.AffiliationOwner, "AffiliationOwner");
          }
        } })

      }
      if (this.isBanned) {
        ItemText({ title: getContext().resourceManager.getStringByNameSync('GroupMember_String16'), clickEvent: () => {
          this.isBanned = !this.isBanned
          if (this.users.length > 1) {
            Smack.grantVoices(this.getUsers(), "grantVoices");
          } else {
            Smack.grantVoice(this.users[0].name, "grantVoice");
          }
        }
        })

      } else {
        ItemText({ title: getContext().resourceManager.getStringByNameSync('GroupMember_String17'), clickEvent: () => {
          this.isBanned = !this.isBanned
          if (this.users.length > 1) {
            Smack.revokeVoices(this.getUsers(), "revokeVoices");
          } else {
            Smack.revokeVoice(this.users[0].name, "revokeVoice");
          }

          if (this.users.length > 1) {
            Smack.setAffiliations(this.getUsers(), MUCRoomAffiliation.AffiliationNone, "AffiliationNone");
          } else {
            Smack.setAffiliation(this.users[0].name, MUCRoomAffiliation.AffiliationNone, "AffiliationNone");
          }
        } })
      }
      // Text("发消息")
      //   .backgroundColor(Color.Red)
      //   .width('60%')
      //   .height(50)
      //   .borderRadius(25)
      //   .textAlign(TextAlign.Center)
      //   .padding(5)
      //   .fontColor(Color.White)
      //   .fontSize(20)
      //   .margin({ top: 30 })
      //   .onClick(() => {
      //     router.push({ url: "pages/chat/one_chat/one_chat_main", params: { userName: this.users[0].name } })
      //     router.back()
      //   })
    }
  }
}