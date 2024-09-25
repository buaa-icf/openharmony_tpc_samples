/**
 * BSD License
 *
 * Copyright (c) 2024 Huawei Device Co., Ltd. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * * Redistributions of source code must retain the above copyright notice, this
 *  list of conditions and the following disclaimer.
 *
 * * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * * Neither the name Facebook nor the names of its contributors may be used to
 * endorse or promote products derived from this software without specific
 * prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import * as ieee754 from 'ieee754'
import {Buffer} from "buffer/"

@Entry
@Component
struct Index {
  @State message: string = 'MIT';
  @State public result: number = 0
  @State public writeResult:number = 0;

  getResourceString(res:Resource){
    return getContext().resourceManager.getStringSync(res.id)
  }

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        Button('read')
          .width('90%')
          .height(50)
          .margin({
            bottom: 10
          })
          .onClick(() => {
            this.click()
          })
        Text(this.getResourceString($r('app.string.Result')) + ": " + this.result)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin({ top: "30px" })
        Button('write')
          .width('90%')
          .height(50)
          .margin({
            bottom: 10
          })
          .onClick(() => {
            this.writeclick()
          })
        Text(this.getResourceString($r('app.string.Result')) + ": " + this.writeResult)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin({ top: "30px" })
      }
      .width('100%')
    }
    .height('100%')
  }
  click(){
    let val = 42.42
    let buf:ESObject = Buffer.alloc(4)

    buf.writeFloatLE(val, 0)
    let num = ieee754.read(buf, 0, true, 23, 4)
    this.result = num
  }
  writeclick(){
    const val = 30.42
    let buf:ESObject = Buffer.alloc(4)

    ieee754.write(buf, val, 0, true, 23, 4)
    let num:ESObject = buf.readFloatLE(0)
    this.writeResult = num
  }
}