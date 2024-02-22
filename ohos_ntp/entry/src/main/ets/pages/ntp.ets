/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import router from '@ohos.router';
import { getNetworkTime } from '@ohos/ntp';

@Entry
@Component
struct NtpClient {
  @State server: string | undefined = 'ntp.aliyun.com';
  @State port: string | undefined = '123';
  @State timeout: string | undefined = '2000';
  @State ntpResult: string | undefined = ''
  @State timeoutResult: String | undefined = ''

  aboutToDisappear(): void {
    this.server = undefined
    this.port = undefined
    this.timeout = undefined
    this.ntpResult = undefined
    this.timeoutResult = undefined
  }

  build() {
    Column() {
      Button('返回')
        .margin(10)
        .width('95%')
        .height('150px')
        .fontSize(18)
        .fontColor('#fff')
        .align(Alignment.Center)
        .margin(10)
        .onClick(() => {
          router.back();
        })

      Text('请输入NTP服务器地址')

      TextInput({ text: this.server })
        .caretColor(Color.Blue)
        .height('150px')
        .fontSize('18fp')
        .onChange((value: string) => {
          this.server = value
        })
        .margin(10)

      Text('请输入远端端口')

      TextInput({ text: this.port })
        .caretColor(Color.Blue)
        .height('150px')
        .fontSize('18fp')
        .onChange((value: string) => {
          this.port = value
        })
        .margin(10)

      Text('请输入等待响应时长(ms)')

      TextInput({ text: this.timeout })
        .caretColor(Color.Blue)
        .height('150px')
        .fontSize('18fp')
        .margin(10)
        .onChange((value: string) => {
          this.timeout = value
        })


      Button('请求NTP')
        .margin(10)
        .width('95%')
        .height('150px')
        .fontSize(18)
        .fontColor('#fff')
        .align(Alignment.Center)
        .onClick(() => {
          getNetworkTime({
            server: this.server as string,
            port: Number(this.port) as number,
            delayTime: Number(this.timeout) as number
          })
            .then((date: Date) => {
              this.ntpResult = JSON.stringify(date)
            })
            .catch((err: string) => {
              this.timeoutResult = JSON.stringify(err)
            })
        })

      Text('Result:' + this.ntpResult)
        .width('100%')
        .padding(10)
        .textAlign(TextAlign.Start)
        .fontSize(20)
      Text('Timeout Result:' + this.timeoutResult)
        .width('100%')
        .padding(10)
        .textAlign(TextAlign.Start)
        .fontSize(20)
    }
    .width('100%')
    .height('100%');
  };
}