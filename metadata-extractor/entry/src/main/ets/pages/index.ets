/*
* Copyright (c) 2022 Huawei Device Co., Ltd.

* Permission to use, copy, modify, and/or distribute this software for any purpose
* with or without fee is hereby granted, provided that the above copyright notice
* and this permission notice appear in all copies.

* THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
* REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
* INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS
* OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER
* TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF
* THIS SOFTWARE.
*/

import router from '@ohos.router'

@Entry
@Component
struct Index {
  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Column() {
        Button("图片", { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8).width("70%").height("8%").margin("2%")
          .onClick(() => {
            router.push({
              url: "pages/Picture"
            })
          })

        Button("音频", { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8).width("70%").height("8%").margin("2%")
          .onClick(() => {
            router.push({
              url: "pages/Audio"
            })
          })

        Button("视频", { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8).width("70%").height("8%").margin("2%")
          .onClick(() => {
            router.push({
              url: "pages/Videos"
            })
          })
        Button("其他", { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8).width("70%").height("8%").margin("2%")
          .onClick(() => {
            router.push({
              url: "pages/OtherSample"
            })
          })
      }
    }
    .width('100%')
    .height('100%')
  }
}
