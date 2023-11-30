import { Toolbar } from '../../base/toolbar'
import { ItemText } from '../../base/ItemText'

import { MUCRoomAffiliation, MUCRoomRole } from '@ohos/smack'
import { PresenceRoomType } from '@ohos/smack'
import router from '@ohos.router';

@Entry
@Component
struct group_all_member {
  @State isAdministrator: boolean = false //是否为管理员
  @State isMember: boolean = false //是否为会员
  @State isOwner: boolean = false //是否为群主
  @State isBanned: boolean = false //是否禁言
  @State isCompere: boolean = false //是否为主持人
  private states: string[] = ['在线', '空闲', '离开', '请勿打扰', '长时间离开', '离线']
  @State select: number = 0
  @State users: Array<{
    name: string,
    isCheck: number
  }> = []

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
    globalThis.Smack.setPresence(presenceType, state)
  }

  public aboutToAppear() {
    this.users = router.getParams()['userData']
  }

  public getUsers(): string{
    let str = ""
    for (var i = 0;i < this.users.length; i++) {
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
          ForEach(this.users, (item) => {
            ListItem() {
              Row() {
                Image($r('app.media.app_icon')).height(60).width(60).borderRadius(10)
                Text(item.name)
                  .padding(13)
                  .backgroundColor('#ffffff')
                  .fontSize(18)
              }
            }.editable(true)
          }, item => item.name)
        }.width('100%')
        .listDirection(Axis.Horizontal) // 排列方向

      }.height(100).margin({ left: 20, top: 20 })

      ItemText({ title: "踢出群聊", clickEvent: () => {
        if (this.users.length == 1) {
          globalThis.Smack.kick(this.users[0].name, "kick");
        } else {
          globalThis.Smack.bans(this.getUsers(), "bans");
        }
        router.back()
      } })

      ItemText({ title: "加入黑名单", clickEvent: () => {
        globalThis.Smack.ban(this.users[0].name, "ban");
      } })

      if (this.isCompere) {

        ItemText({ title: "撤销设为主持人", clickEvent: () => {
          this.isCompere = !this.isCompere
          if (this.users.length > 1) {
            globalThis.Smack.setRoles(this.getUsers(), MUCRoomRole.RoleParticipant, "RoleParticipant");
          } else {
            globalThis.Smack.setRole(this.users[0].name, MUCRoomRole.RoleParticipant, "RoleParticipant");
          }
        } })

      } else {
        ItemText({ title: "设为主持人", clickEvent: () => {
          this.isCompere = !this.isCompere
          if (this.users.length > 1) {
            globalThis.Smack.setRoles(this.getUsers(), MUCRoomRole.RoleModerator, "RoleModerator");
          } else {
            globalThis.Smack.setRole(this.users[0].name, MUCRoomRole.RoleModerator, "RoleModerator");
          }
        } })
      }
      ItemText({ title: "设置用户状态", clickEvent: () => {
        TextPickerDialog.show({
          range: this.states,
          selected: this.select,
          onAccept: (value: TextPickerResult) => {
            this.select = value.index
            this.onSetOnLineState()
          }
        })
      } })

      if (this.isAdministrator) {

        ItemText({ title: "撤销管理员身份", clickEvent: () => {
          this.isAdministrator = !this.isAdministrator
          if (this.users.length > 1) {
            globalThis.Smack.setAffiliations(this.getUsers(), MUCRoomAffiliation.AffiliationNone, "AffiliationNone");
          } else {
            globalThis.Smack.setAffiliation(this.users[0].name, MUCRoomAffiliation.AffiliationNone, "AffiliationNone");
          }
        } })

      } else {
        ItemText({ title: "设置为群管理员", clickEvent: () => {
          this.isAdministrator = !this.isAdministrator
          if (this.users.length > 1) {
            globalThis.Smack.setAffiliations(this.getUsers(), MUCRoomAffiliation.AffiliationAdmin, "AffiliationAdmin");
          } else {
            globalThis.Smack.setAffiliation(this.users[0].name, MUCRoomAffiliation.AffiliationAdmin, "AffiliationAdmin");
          }
        } })

      }
      if (this.isMember) {
        ItemText({ title: "取消会员身份", clickEvent: () => {
          this.isMember = !this.isMember
          if (this.users.length > 1) {
            globalThis.Smack.setAffiliations(this.getUsers(), MUCRoomAffiliation.AffiliationNone, "AffiliationNone");
          } else {
            globalThis.Smack.setAffiliation(this.users[0].name, MUCRoomAffiliation.AffiliationNone, "AffiliationNone");
          }
        } })

      } else {
        ItemText({ title: "设为会员", clickEvent: () => {
          this.isMember = !this.isMember
          if (this.users.length > 1) {
            globalThis.Smack.setAffiliations(this.getUsers(), MUCRoomAffiliation.AffiliationMember, "AffiliationMember");
          } else {
            globalThis.Smack.setAffiliation(this.users[0].name, MUCRoomAffiliation.AffiliationMember, "AffiliationMember");
          }
        } })
      }
      if (this.isOwner) {
        ItemText({ title: "撤销设为群主", clickEvent: () => {
          this.isOwner = !this.isOwner
          if (this.users.length > 1) {
            globalThis.Smack.setAffiliations(this.getUsers(), MUCRoomAffiliation.AffiliationNone, "AffiliationNone");
          } else {
            globalThis.Smack.setAffiliation(this.users[0].name, MUCRoomAffiliation.AffiliationNone, "AffiliationNone");
          }
        } })
      } else {
        ItemText({ title: "设为群主", clickEvent: () => {
          this.isOwner = !this.isOwner
          if (this.users.length > 1) {
            globalThis.Smack.setAffiliations(this.getUsers(), MUCRoomAffiliation.AffiliationOwner, "AffiliationOwner");
          } else {
            globalThis.Smack.setAffiliation(this.users[0].name, MUCRoomAffiliation.AffiliationOwner, "AffiliationOwner");
          }
        } })

      }
      if (this.isBanned) {
        ItemText({ title: "取消禁言", clickEvent: () => {
          this.isBanned = !this.isBanned
          if (this.users.length > 1) {
            globalThis.Smack.grantVoices(this.getUsers(), "grantVoices");
          } else {
            globalThis.Smack.grantVoice(this.users[0].name, "grantVoice");
          }
        }
        })

      } else {
        ItemText({ title: "禁言", clickEvent: () => {
          this.isBanned = !this.isBanned
          if (this.users.length > 1) {
            globalThis.Smack.revokeVoices(this.getUsers(), "revokeVoices");
          } else {
            globalThis.Smack.revokeVoice(this.users[0].name, "revokeVoice");
          }
        } })
      }
      Text("发消息")
        .backgroundColor(Color.Red)
        .width('60%')
        .height(50)
        .borderRadius(25)
        .textAlign(TextAlign.Center)
        .padding(5)
        .fontColor(Color.White)
        .fontSize(20)
        .margin({ top: 30 })
        .onClick(() => {
          router.push({ url: "pages/chat/one_chat/one_chat_main", params: { userName: this.users[0].name } })
          router.back()
        })
    }
  }
}