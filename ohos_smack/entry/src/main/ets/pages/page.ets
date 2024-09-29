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

import { PresenceType, Smack } from '@ohos/smack'
import { MUCRoomAffiliation } from '@ohos/smack'
import { MUCRoomRole } from '@ohos/smack'
import { PresenceRoomType } from '@ohos/smack'
import { MUCOperation } from '@ohos/smack'
import {Constant} from '../entity/Constant'
import { RoomConfig } from '@ohos/smack'

@Entry
@Component
struct page {

  service:string="@"+Constant.HOST_DOMAIN+Constant.HOST_RES
  aboutToAppear() {
    Smack.registerGroupMessageCallback((id:ESObject, msg:ESObject) => {
      console.info(getContext().resourceManager.getStringByNameSync('Page_String1') +'  id = ' + id + '   msg = ' + msg)
    })
    Smack.registerInvitationListener((v0:string) => {
      console.info(getContext().resourceManager.getStringByNameSync('Page_String2') +'  v0 = ' + v0 )
    })
    Smack.registerMUCParticipantPresenceListener((nike: string, presenceType: string) => {
      console.info(getContext().resourceManager.getStringByNameSync('Page_String3') +'  nike = ' + nike + '   presenceType = ' + presenceType )
    })
    Smack.handleSubscriptionRequestListener((resultStr:ESObject) => {
      console.info('handleSubscriptionRequestListener  resultStr = ' + resultStr)
    })
  }

  build() {
    Row() {
      Scroll() {
        Column() {

          Item({
            text: getContext().resourceManager.getStringByNameSync('Page_String4') ,
            click: () => {
              Smack.send('test3'+this.service, 'hello from test2 abc');
            }
          })

          Item({
            text: getContext().resourceManager.getStringByNameSync('Page_String5'),
            click: () => {
              Smack.unregister();
            }
          })

          Item({
            text: getContext().resourceManager.getStringByNameSync('Page_String6'),
            click: () => {
              Smack.changPwd("test");
            }
          })

          Item({
            text: getContext().resourceManager.getStringByNameSync('Page_String7'),
            click: () => {
              Smack.createGroup("foo");
            }
          })

          Item({
            text: getContext().resourceManager.getStringByNameSync('Page_String8'),
            click: () => {
              console.log("Test NAPI getFriends result:" + Smack.getFriendList());
            }
          })

          Item({
            text: getContext().resourceManager.getStringByNameSync('Page_String9'),
            click: () => {
              Smack.addFriends("test@"+Constant.HOST_DOMAIN, "test", "group");
            }
          })

          Item({
            text: getContext().resourceManager.getStringByNameSync('Page_String10'),
            click: () => {
              Smack.delfriend("test3"+this.service);
            }
          })

          Item({
            text:getContext().resourceManager.getStringByNameSync('Page_String11'),
            click: () => {
              Smack.changePresence(PresenceType.Away, 'Online');
            }
          })

          Item({
            text: getContext().resourceManager.getStringByNameSync('Page_String12'),
            click: () => {
              Smack.changeFriendGroup("test3@"+Constant.HOST_DOMAIN, "friend");
            }
          })

          Item({
            text: getContext().resourceManager.getStringByNameSync('Page_String13'),
            click: () => {
              Smack.changeGroup("ts", "friend");
            }
          })

          Item({
            text: getContext().resourceManager.getStringByNameSync('Page_String14'),
            click: () => {
              Smack.createRoom("444@"+Constant.HOST_IP+Constant.HOST_RES, "room1", Constant.HOST_DOMAIN, Constant.SERVICE_NAME);
            }
          })

          Item({
            text: getContext().resourceManager.getStringByNameSync('Page_String15'),
            click: () => {
              Smack.join();
            }
          })

          Item({
            text: getContext().resourceManager.getStringByNameSync('Page_String16'),
            click: () => {
              Smack.leave("leave msg");
            }
          })

          Item({
            text: getContext().resourceManager.getStringByNameSync('Page_String17'),
            click: () => {
              Smack.sendGroupMessage("group msg test");
            }
          })

          Item({
            text: getContext().resourceManager.getStringByNameSync('Page_String18'),
            click: () => {
              Smack.setSubject("subject");
            }
          })

          Item({
            text: getContext().resourceManager.getStringByNameSync('Page_String19'),
            click: () => {
              Smack.destroy("999@"+Constant.HOST_IP+Constant.HOST_RES, "123");
            }
          })

          Item({
            text: getContext().resourceManager.getStringByNameSync('Page_String20'),
            click: () => {
              Smack.kick("555", "kick");
            }
          })

          Item({
            text: getContext().resourceManager.getStringByNameSync('Page_String21'),
            click: () => {
              Smack.ban("555", "ban");
            }
          })

          Item({
            text: getContext().resourceManager.getStringByNameSync('Page_String22'),
            click: () => {
              Smack.grantVoice("555", "grantVoice");
            }
          })

          Item({
            text: getContext().resourceManager.getStringByNameSync('Page_String23'),
            click: () => {
              Smack.revokeVoice("555", "revokeVoice");
            }
          })

          Item({
            text: getContext().resourceManager.getStringByNameSync('Page_String24'),
            click: () => {
              Smack.setAffiliation("555", MUCRoomAffiliation.AffiliationOwner, "AffiliationOwner");
            }
          })

          Item({
            text: getContext().resourceManager.getStringByNameSync('Page_String25'),
            click: () => {
              Smack.setRole("888", MUCRoomRole.RoleModerator, "RoleModerator");
            }
          })

          Item({
            text: getContext().resourceManager.getStringByNameSync('Page_String26'),
            click: () => {
              Smack.setPresence(PresenceRoomType.Away, "Away");
            }
          })

          Item({
            text: getContext().resourceManager.getStringByNameSync('Page_String27'),
            click: () => {
              Smack.invite("777"+this.service, "invite");
            }
          })

          Item({
            text: getContext().resourceManager.getStringByNameSync('Page_String28'),
            click: () => {
              let number:ESObject = Smack.getRoomItems();
              console.info('getRoomItems = ' + JSON.stringify(number))
            }
          })

          Item({
            text: getContext().resourceManager.getStringByNameSync('Page_String29'),
            click: () => {
              let list:ESObject = Smack.requestList(MUCOperation.RequestOwnerList);
              console.info('requestList = ' + JSON.stringify(list))
            }
          })

          Item({
            text: getContext().resourceManager.getStringByNameSync('Page_String30'),
            click: () => {
              Smack.declineInvitation("888_room@"+Constant.SERVICE_NAME+"."+Constant.HOST_DOMAIN, "888@"+Constant.HOST_DOMAIN, "room inviation refuesd");
            }
          })

          Item({
            text: getContext().resourceManager.getStringByNameSync('Page_String31'),
            click: () => {
              let info:ESObject = Smack.createOrJoinRoom("room4", Constant.HOST_DOMAIN, Constant.SERVICE_NAME, "123");
            }
          })

          Item({
            text: getContext().resourceManager.getStringByNameSync('Page_String32'),
            click: () => {
              let info:ESObject = Smack.setPassword("123123");
            }
          })

          Item({
            text: getContext().resourceManager.getStringByNameSync('Page_String33'),
            click: () => {
              console.info("test page setRoomConfig");
              let roomConfig: RoomConfig = new RoomConfig();

              roomConfig.allowinvites = "1";
              roomConfig.canchangenick = "1";
              roomConfig.changesubject = "1";
              roomConfig.enablelogging = "1";
              roomConfig.membersonly = "1";
              roomConfig.moderatedroom = "1";
              roomConfig.passwordprotectedroom = "1";
              roomConfig.persistentroom = "1";
              roomConfig.publicroom = "1";
              roomConfig.registration = "1";
              roomConfig.reservednick = "1";
              roomConfig.allowpm = 'anyone';
              roomConfig.whois = "anyone";// "anyone" : "moderators"
              roomConfig.roomname = "roomName";//roomName
              roomConfig.roomdesc = "room desc";
              roomConfig.maxusers = "25"
              roomConfig.roomsecret = "123"
              roomConfig.presencebroadcast = ["participant", "moderator", "visitor"];
              console.info("test page setRoomConfig str:"+JSON.stringify(roomConfig))
              let info:ESObject = Smack.setRoomConfig(JSON.stringify(roomConfig));
            }
          })

          Item({
            text: getContext().resourceManager.getStringByNameSync('Page_String34'),
            click: () => {
              let info:ESObject = Smack.bans("888,555", "bans");
            }
          })

          Item({
            text: getContext().resourceManager.getStringByNameSync('Page_String35'),
            click: () => {
              let info:ESObject = Smack.setNick("new_nike_name");
            }
          })

          Item({
            text: getContext().resourceManager.getStringByNameSync('Page_String36'),
            click: () => {
              let isJoined:ESObject = Smack.isJoined();
              console.info('isJoined = ' + isJoined)
            }
          })

          Item({
            text: getContext().resourceManager.getStringByNameSync('Page_String37'),
            click: () => {
              let nick:ESObject = Smack.nick();
              console.info('nick = ' + nick)
            }
          })
          Item({
            text: getContext().resourceManager.getStringByNameSync('Page_String38'),
            click: () => {
              let isConnected:ESObject = Smack.isConnected();
              console.info('State = ' + isConnected)
            }
          })
          Item({
            text: getContext().resourceManager.getStringByNameSync('Page_String38'),
            click: () => {
              let username:ESObject = Smack.username();
              console.info('Connect State = ' + username)
            }
          })
          Item({
            text: 'connect',
            click: () => {
              let connect:ESObject = Smack.connect();
              console.info('connect = ' + connect)
            }
          })
          Item({
            text: 'setServer',
            click: () => {
              Smack.setServer(Constant.HOST_IP);
              console.info('setServer = ')
            }
          })
          Item({
            text: 'setUsernameAndPassword',
            click: () => {
              let value:ESObject=Smack.setUsernameAndPassword("zhang", "123456");
              console.info('setUsernameAndPassword = '+value)
            }
          })
          Item({
            text: 'setPort',
            click: () => {
              let value:ESObject=Smack.setPort(Constant.HOST_PORT);
              console.info('setUsernameAndPassword = '+value)
            }
          })
          Item({
            text: 'password',
            click: () => {
              let value:ESObject=Smack.password();
              console.info('password = '+value)
            }
          })
          Item({
            text: 'setResource',
            click: () => {
              let value:ESObject=Smack.setResource(Constant.HOST_RES.replace("/",""));
              console.info('password = '+value)
            }
          })
          Item({
            text: 'receiveFriends',
            click: () => {
              let value:ESObject=Smack.receiveFriends("555@"+Constant.HOST_DOMAIN, "group", "receive request");
            }
          })

          Item({
            text: 'rejectFriends',
            click: () => {
              let value:ESObject=Smack.rejectFriends("555@"+Constant.HOST_DOMAIN, "reject request");
            }
          })
        }
        .width('100%')
      }
    }
    .height('100%')
  }
}

@Component
struct Item {
  text: string = ''
  click: () => void = () => {}

  build() {
    Column() {
      Button(this.text)
        .fontSize(px2fp(30))
        .width('90%')
        .margin(px2vp(10))
        .padding(px2vp(15))
        .onClick(v => {
          this.click()
        })
    }

  }
}
