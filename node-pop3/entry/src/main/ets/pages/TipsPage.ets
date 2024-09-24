/*
 * Copyright (C) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { getResourceStr } from './GetResourceStr'

@Entry
@Component
struct TipsPage {
  @State message: string = getResourceStr($r("app.string.Pop3_Precautions"))

  aboutToAppear() {
    this.message = this.message += '\r\n' + '\r\n' + getResourceStr($r("app.string.Command_Description"))
    this.message = this.message += '\r\n' + '\r\n' + getResourceStr($r("app.string.USER_username"))
    this.message = this.message += '\r\n' + '\r\n' + getResourceStr($r("app.string.PASS_password"))
    this.message = this.message += '\r\n' + '\r\n' + getResourceStr($r("app.string.APOP_Name"))
    this.message = this.message += '\r\n' + '\r\n' + getResourceStr($r("app.string.STAT"))
    this.message = this.message += '\r\n' + '\r\n' + getResourceStr($r("app.string.UIDL"))
    this.message = this.message += '\r\n' + '\r\n' + getResourceStr($r("app.string.LIST"))
    this.message = this.message += '\r\n' + '\r\n' + getResourceStr($r("app.string.RETR"))
    this.message = this.message += '\r\n' + '\r\n' + getResourceStr($r("app.string.DELE"))
    this.message = this.message += '\r\n' + '\r\n' + getResourceStr($r("app.string.RSET"))
    this.message = this.message += '\r\n' + '\r\n' + getResourceStr($r("app.string.TOP"))
    this.message = this.message += '\r\n' + '\r\n' + getResourceStr($r("app.string.NOOP"))
    this.message = this.message += '\r\n' + '\r\n' + getResourceStr($r("app.string.QUIT"))
    this.message = this.message += '\r\n' + '\r\n' + getResourceStr($r("app.string.Note"))
    this.message = this.message += '\r\n' + '\r\n' + getResourceStr($r("app.string.USER"))
    this.message = this.message += '\r\n' + '\r\n' + getResourceStr($r("app.string.PASS"))
    this.message = this.message += '\r\n' + '\r\n' + getResourceStr($r("app.string.Used_STAT"))
    this.message = this.message += '\r\n' + '\r\n' + getResourceStr($r("app.string.Used_LIST"))
    this.message = this.message += '\r\n' + '\r\n' + getResourceStr($r("app.string.Used_DELE"))
    this.message = this.message += '\r\n' + '\r\n' + getResourceStr($r("app.string.Used_RSET"))
    this.message = this.message += '\r\n' + '\r\n' + getResourceStr($r("app.string.Used_RETR"))
    this.message = this.message += '\r\n' + '\r\n' + getResourceStr($r("app.string.Used_TOP"))
    this.message = this.message += '\r\n' + '\r\n' + getResourceStr($r("app.string.Used_NOOP"))
    this.message = this.message += '\r\n' + '\r\n' + getResourceStr($r("app.string.Used_QUIT"))
  }

  build() {
    Row() {
      Column() {
        Scroll() {
          Text(this.message)
            .fontSize(20)
            .textAlign(TextAlign.Start)
            .padding(20)
        }
      }
      .width('100%')
      .height('100%')
    }
    .height('100%')
  }
}