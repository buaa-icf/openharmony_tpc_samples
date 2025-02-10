/**
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * 
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

import { falseFunc, trueFunc } from 'boolbase';

@Entry
@Component
struct Index {
  getResourceString(res: Resource) {
    return getContext().resourceManager.getStringSync(res.id)
  }
  build() {
    RelativeContainer() {
      Column() {
        Text(this.getResourceString($r('app.string.trueFunc')) + JSON.stringify(trueFunc()))
          .fontSize(20)
        Text(this.getResourceString($r('app.string.falseFunc')) + JSON.stringify(falseFunc()))
          .fontSize(20)
      }
    }
    .height('100%')
    .width('100%')
  }
}