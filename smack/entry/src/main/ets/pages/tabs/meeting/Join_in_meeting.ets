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

@Entry
@Component
struct Join_in_meeting {

  build() {
    Flex({ direction: FlexDirection.Column }) {
      Toolbar({
        title: '加入会议',
        isBack: true
      })
      Flex({ direction: FlexDirection.Column }){
        Text('会议名称').fontSize(15).padding(10)
        TextInput()
        Text('昵称').fontSize(15).padding(10)
        TextInput()
        Text('密码').fontSize(15).padding(10)
        TextInput()
        Button('加 入').onClick(e => {
          this.onJoinInMeeting()
        }).margin({ top: 20 })
      }
      .padding(30)
    }
    .backgroundColor('#ffffff')
    .borderRadius(10)
  }

  // todo 加入会议
  onJoinInMeeting(){

  }
}