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

import { getNetworkTime, NTPConfig } from '@ohos/ntp';

@Entry
@Component
struct NtpClient {
  @State ntpResult: string | undefined = ''
  @State timeoutResult: string | undefined = ''

  aboutToAppear(): void {
    this.ntpResult = undefined
    this.timeoutResult = undefined
  }

  aboutToDisappear(): void {
    this.ntpResult = undefined
    this.timeoutResult = undefined
  }

  onPageShow(): void {
    this.ntpResult = ''
    this.timeoutResult = ''
  }

  onPageHide(): void {
    this.ntpResult = undefined
    this.timeoutResult = undefined
  }

  build() {
    Column() {
      Text('NTP服务器地址:ntp.aliyun.com')
        .width('100%')
        .padding({ left: 10 })

      Text('远端端口:123')
        .width('100%')
        .padding({ left: 10 })

      Text('等待响应时长(ms):2000')
        .width('100%')
        .padding({ left: 10 })

      Button('请求NTP')
        .margin(10)
        .width('95%')
        .height('100px')
        .onClick(() => {
          let config: NTPConfig | undefined = undefined
          config = {
            server: 'ntp.aliyun.com',
            port: 123,
            delayTime: 2000
          }
          getNetworkTime(config)
            .then((date: Date) => {
              this.ntpResult = JSON.stringify(date)
              config = undefined
            })
            .catch((err: string) => {
              this.timeoutResult = JSON.stringify(err)
              config = undefined
            })
        })

      Text(this.ntpResult)
        .width('100%')
        .padding({ left: 10 })
      Text(this.timeoutResult)
        .width('100%')
        .padding({ left: 10 })
    }
    .width('100%')
    .height('100%');
  };
}