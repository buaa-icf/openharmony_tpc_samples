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
import { ChatContentEntity } from '../../../entity/ChatContentEntity'
import { Smack } from '@ohos/smack'
import { GlobalContext } from '../../../entity/GlobalContext';

@Entry
@Component
struct Group_chat_main {
  @State chatContentList: Array<ChatContentEntity> = []
  @State inputMessage: string = ''
  @State roomName: string = ''
  @State isJoin: number = 0 //0-false,1-true
  aboutToAppear() {
    Smack.registerGroupMessageCallback((id:number, msg:string) => {
      setTimeout(() => {
        console.info('msg test:'+msg)
        this.chatContentList.push(new ChatContentEntity(String(id) == '222' ? '1' : String(id), msg, 1))
      }, 100)

    })
    Smack.registerMUCParticipantPresenceListener((name:string,jsonStr: string) => {
      let obj:ESObject=JSON.parse(jsonStr)
      setTimeout(() => {
        switch (obj.flags) {
          case '1':
            this.chatContentList.push(new ChatContentEntity(name, name + "操作成功", 1, true))
            break;
          case '2':
            this.chatContentList.push(new ChatContentEntity(name, name + "修改了昵称", 1, true))
            break;
          case '3':
            this.chatContentList.push(new ChatContentEntity(name, name + "被踢出了群聊", 1, true))
            break;
          case '4':
            this.chatContentList.push(new ChatContentEntity(name, name + "被群聊屏蔽了", 1, true))
            break;

        }
      }, 100)
      //      switch (presenceType) {
      //        case "0":
      //          this.chatContentList.push(new ChatContentEntity(name, name + "进入了房间", 1, true))
      //          break
      //        case "1":
      //          this.chatContentList.push(new ChatContentEntity(name, name + "状态空闲", 1, true))
      //          break
      //        case "2":
      //          this.chatContentList.push(new ChatContentEntity(name, name + "离开了", 1, true))
      //          break
      //        case "3":
      //          this.chatContentList.push(new ChatContentEntity(name, name + "状态变更为请勿打扰", 1, true))
      //          break
      //        case "4":
      //          this.chatContentList.push(new ChatContentEntity(name, name + "长时间离线了", 1, true))
      //          break
      //        case "5":
      //          this.chatContentList.push(new ChatContentEntity(name, name + "离开了房间", 1, true))
      //          break
      //        case "9":
      //          this.chatContentList.push(new ChatContentEntity(name, name + "的状态发生变化", 1, true))
      //          break
      //      }
    })
    this.isJoin = Number(Smack.isJoined())
    if (this.isJoin == 0) {
      Smack.join();
    }
    GlobalContext.getContext().setValue('roomInfo', Smack.parseXML())
    let roominfo: ESObject = JSON.parse(GlobalContext.getContext().getValue('roomInfo') as string)
    this.roomName = roominfo.description
  }

  aboutToDisappear() {
    Smack.leave("leave msg");
  }

  onPageShow() {

  }

  build() {
    Flex({ direction: FlexDirection.Column }) {
      Toolbar({
        title: this.roomName,
        isBack: true,
        rightIcon: $r('app.media.more'),
        rightClickCallBack: () => {
          router.push({
            url: "pages/chat/group_chat/group_chat_setting"
          })
        }
      })

      Stack({ alignContent: Alignment.Bottom }) {
        List() {
          ForEach(this.chatContentList, (item : ChatContentEntity) => {
            ListItem() {
              Flex({ direction: FlexDirection.Column }) {
                if (item.isTip) {
                  Column() {
                    Text(item.message)
                      .fontSize(13)
                      .textAlign(TextAlign.Center)
                      .backgroundColor('#ffe2e2e2')
                      .padding({ left: 10, right: 10, top: 5, bottom: 5 })
                      .borderRadius(10)
                  }.width('100%')
                } else {
                  Flex({ justifyContent: item.author == '1' ? FlexAlign.End : FlexAlign.Start }) {
                    Flex({ direction: FlexDirection.Column }) {
                      Text(item.author == '1' ? '我' : item.author)
                        .fontSize(15)
                        .padding(5)
                        .alignSelf(item.author == '1' ? ItemAlign.End : ItemAlign.Start)
                      if (item.messageType == 1) {
                        Text(item.message)
                          .backgroundColor(item.author != '1' ? '#ffffff' : '#95ec69')
                          .padding({ left: 15, top: 10, right: 15, bottom: 10 })
                          .alignSelf(ItemAlign.End)
                          .fontSize(18)
                          .borderRadius(10)
                      } else if (item.messageType == 2) {
                        Image(item.message)
                          .objectFit(ImageFit.Cover)
                          .width('50%')
                      }
                    }
                  }
                }
              }
            }
            .padding(10)
          }, (item : ChatContentEntity) => JSON.stringify(item))
        }
        .padding({ bottom: 130 })
        .height('100%')

        Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
          TextInput({ placeholder: '请输入', text: this.inputMessage }).onChange(v => {
            this.inputMessage = v
          })
          Button('发 送').width(100).margin({ left: 8 })
            .onClick(e => {
              this.onSendGroupMessage()
            })
        }
        .height(px2vp(120))
        .width('100%')
        .padding({ left: 15, right: 15 })
        .backgroundColor('#ffffff')
      }
    }
    .height('100%')
    .backgroundColor('#ececec')
  }

  // todo 发送群聊信息
  onSendGroupMessage() {
    Smack.sendGroupMessage(this.inputMessage);
    this.inputMessage = ""
  }
}