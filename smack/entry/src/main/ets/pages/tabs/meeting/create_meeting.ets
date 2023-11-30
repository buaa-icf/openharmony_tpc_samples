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

@Entry
@Component
struct Create_meeting {
  @State message: string = 'Hello World'

  build() {
    Flex({ direction: FlexDirection.Column }) {
      Toolbar({
        title: '创建会议',
        isBack: true
      })
      Flex({ direction: FlexDirection.Column }) {
        Text('会议名称').fontSize(15).padding(10)
        TextInput()
        Text('密码').fontSize(15).padding(10)
        TextInput()
        Button('创 建').onClick(e => {
          this.onCreateMeeting()
        }).margin({ top: 20 })
      }
      .padding(30)
    }
    .backgroundColor('#ffffff')
    .borderRadius(10)
  }

  // todo 创建会议
  onCreateMeeting() {

  }
}