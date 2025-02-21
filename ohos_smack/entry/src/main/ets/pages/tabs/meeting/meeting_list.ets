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

@Component
struct MeetingListComponent {
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogExample({}),
    customStyle: true,
    alignment: DialogAlignment.TopEnd,
    offset: { dx: -20, dy: 50 }
  })
  textDialogController: CustomDialogController = new CustomDialogController({
    builder: TextDialog({}),
    customStyle: true,
    alignment: DialogAlignment.Center,
  })
  @State meetingsList: Array<string> = []

  aboutToAppear() {
    this.getAllMeetings()
  }

  // todo 获取所有会议列表
  getAllMeetings() {
    for (let i = 0; i < 10; i++) {
      this.meetingsList.push('Online Meeting Name ' + (i + 1))
    }
  }

  build() {
    Column() {
      Toolbar({
        title: 'Meeting',
        rightIcon: $r('app.media.add'),
        rightClickCallBack: () => {
          this.dialogController.open()
        }
      })
      List() {
        ForEach(this.meetingsList, (item:string) => {
          ListItem() {
            Column() {
              Text(item)
                .fontSize(18)
                .padding(12)
                .width('100%')
                .textAlign(TextAlign.Start)
                .margin({ bottom: 1 })
                .backgroundColor('#ffffff')
            }
          }
          .onClick(e => {
            this.textDialogController.open()
          })
        }, (item:string) => item.toString())
      }
    }
    .width('100%')
    .backgroundColor('#ececec')
  }
}

@CustomDialog
struct TextDialog {
  controller: CustomDialogController ={} as CustomDialogController;

  build() {
    Flex({ direction: FlexDirection.Column }) {
      Text('Name ').fontSize(15).padding(10)
      TextInput()
      Text('Password').fontSize(15).padding(10)
      TextInput()
      Button('Confirm').onClick(e => {
        this.onJoinInMeeting()
        this.controller.close()
      }).margin({ top: 20 })
    }
    .padding(20)
    .height(280)
    .backgroundColor('#ffffff')
    .borderRadius(10)
    .width('80%')
  }

  // todo 从会议列表里进入会议
  onJoinInMeeting() {

    router.pushUrl({
      url: 'pages/chat/meeting_chat/meeting_chat_main'
    })
  }
}

@CustomDialog
struct CustomDialogExample {
  controller: CustomDialogController = {} as CustomDialogController;

  build() {
    Column() {
      Text('Create Meeting')
        .fontSize(16)
        .padding(10)
        .onClick(() => {
          router.pushUrl({
            url: 'pages/tabs/meeting/create_meeting'
          })
          if(this.controller != null)
          {
            this.controller.close()
          }
        })

      Text('')
        .height(1)
        .width('100%')
        .backgroundColor('#ececec')

      Text('Join Meeting')
        .fontSize(16)
        .padding(10)
        .onClick(() => {
          router.pushUrl({
            url: 'pages/tabs/meeting/Join_in_meeting'
          })
          if(this.controller != null)
          {
            this.controller.close()
          }
        })
    }
    .backgroundColor('#ffffff')
    .borderRadius(10)
    .width(100)
  }
}

@Entry
@Component
struct Meeting_list {
  build() {
    Column() {
      MeetingListComponent()
    }
    .width('100%')
    .height('100%')
  }
}

export { MeetingListComponent }