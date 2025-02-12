/**
 *
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 *
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice,this
 * list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS,
 *
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import * as CSSwhat from "css-what";

@Entry
@Component
struct Index {
  getResourceString(res: Resource) {
    return getContext().resourceManager.getStringSync(res.id)
  }

  build() {
    Column() {
      Text(this.getResourceString($r('app.string.parse'))  + JSON.stringify(CSSwhat.parse("[attr]")))
        .fontSize(20)
      Text(this.getResourceString($r('app.string.stringify'))  + CSSwhat.stringify(CSSwhat.parse("[attr]")))
        .fontSize(20)
      Text(this.getResourceString($r('app.string.isTraversal'))  + JSON.stringify(CSSwhat.isTraversal(CSSwhat.parse("foo[bar]:baz")[0][0])))
        .fontSize(20)
      Text(this.getResourceString($r('app.string.isTraversal'))  + JSON.stringify(CSSwhat.isTraversal(CSSwhat.parse(">")[0][0])))
        .fontSize(20)
    }
    .height('100%')
    .width('100%')
  }
}