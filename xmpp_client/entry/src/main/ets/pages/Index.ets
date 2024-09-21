/**
 * ISC License
 * Copyright (C) 2024 Huawei Device Co., Ltd.
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
 * REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
 * INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
 * LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE
 * OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
 * PERFORMANCE OF THIS SOFTWARE.
 */

import router from '@ohos.router';
@Entry
@Component
struct Index {
  build() {
    Column() {
      Button($r('app.string.ws_connection')).onClick((v) => {
        router.pushUrl({ url: "pages/WebSocketPage" })
      }).margin({ top: px2vp(50) })

      Button($r('app.string.tcp_connection')).onClick((v) => {
        router.pushUrl({ url: "pages/TcpSocketPage" })
      }).margin({ top: px2vp(50) })

      Button($r('app.string.tls_connection')).onClick((v) => {
        router.pushUrl({ url: "pages/TlsSocketPage" })
      }).margin({ top: px2vp(50) })
    }
    .height('100%')
    .width('100%')
  }
}
