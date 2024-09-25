/*
 * This software is dual-licensed under Apache 2.0 and WTFPL
 * Copyright (C) 2024 Huawei Device Co., Ltd.
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
 *
 * DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
 *                   Version 2, December 2004
 * Everyone is permitted to copy and distribute verbatim or modified
 * copies of this license document, and changing it is allowed as long
 * as the name is changed.
 *             DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
 *   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
 *   0. You just DO WHAT THE FUCK YOU WANT TO.
 */

import { btoa, atob } from 'Base64'

@Entry
@Component
struct Index {
  @State message: string = '';

  private getResourceStr(data: Resource): string {
    return getContext().resourceManager.getStringSync(data)
  }

  build() {
    Row() {
      Column() {
        Text(this.getResourceStr($r("app.string.Results"))+ this.message)
          .fontSize(16)
        Button(this.getResourceStr($r("app.string.Encode"))+" hello Base64")
          .width(200)
          .onClick((event: ClickEvent) => {
            this.message = btoa('hello Base64');
            console.log(this.getResourceStr($r("app.string.Encode"))+" hello Base64：" + this.message)
          }).margin(20)
        Button(this.getResourceStr($r("app.string.Decode"))+" aGVsbG8gQmFzZTY0")
          .onClick((event: ClickEvent) => {
            this.message = atob('aGVsbG8gQmFzZTY0');
            console.log(this.getResourceStr($r("app.string.Decode"))+" aGVsbG8gQmFzZTY0：" + this.message)
          }).margin(20)
      }
      .width('100%')
    }
    .height('100%')
  }
}