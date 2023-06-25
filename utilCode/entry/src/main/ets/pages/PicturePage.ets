/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

// @ts-ignore
import imtype from 'imtype';

@Entry
@Component
struct PicturePage {
  @State jpg: boolean = false;
  @State png: boolean = false;
  @State gif: boolean = false;
  @State tif: boolean = false;
  @State bmp: boolean = false;

  build() {

    Column() {


      Button('是否jpg:' + this.jpg)
        .fontSize(18)
        .margin({ left: 18 })
        .onClick(() => {
          this.jpgTest()
        })
        .margin({ top: 18 })

      Button('是否png:' + this.png)
        .fontSize(18)
        .margin({ left: 18 })
        .onClick(() => {
          this.pngTest()
        })
        .margin({ top: 18 })


      Button('是否gif:' + this.gif)
        .fontSize(18)
        .margin({ left: 18 })
        .onClick(() => {
          this.gifTest()
        })
        .margin({ top: 18 })

      Button('是否tif:' + this.tif)
        .fontSize(18)
        .margin({ left: 18 })
        .onClick(() => {
          this.tifTest()
        })
        .margin({ top: 18 })

      Button('是否bmp:' + this.bmp)
        .fontSize(18)
        .margin({ left: 18 })
        .onClick(() => {
          this.bmpTest()
        })
        .margin({ top: 18 })

      Button('文本测试')
        .fontSize(18)
        .margin({ left: 18 })
        .onClick(() => {
          this.textTest()
        })
        .margin({ top: 18 })

    }
    .margin({ top: 18 })
  }

  jpgTest() {
    globalThis.context.resourceManager.getMedia($r("app.media.jpg"))
      .then(data => {
        this.jpg = imtype.isJPG(new Uint8Array(data))
      })
      .catch(err => {
        console.log('addFileToDisk err=' + err)
      })
  }

  pngTest() {
    globalThis.context.resourceManager.getMedia($r("app.media.png"))
      .then(data => {
        this.png = imtype.isPNG(new Uint8Array(data))
      })
      .catch(err => {
        console.log('addFileToDisk err=' + err)
      })
  }

  gifTest() {
    globalThis.context.resourceManager.getMedia($r("app.media.gif"))
      .then(data => {
        this.gif = imtype.isGIF(new Uint8Array(data))
      })
      .catch(err => {
        console.log('addFileToDisk err=' + err)
      })
  }

  bmpTest() {
    globalThis.context.resourceManager.getMedia($r("app.media.bmp"))
      .then(data => {
        this.bmp = imtype.isBMP(new Uint8Array(data))
      })
      .catch(err => {
        console.log('addFileToDisk err=' + err)
      })
  }

  tifTest() {
    globalThis.context.resourceManager.getMedia($r("app.media.tif"))
      .then(data => {
        this.tif = imtype.isTIF(new Uint8Array(data))
      })
      .catch(err => {
        console.log('addFileToDisk err=' + err)
      })
  }

  textTest() {
    globalThis.context.resourceManager.getMedia($r("app.media.text"))
      .then(data => {
        console.log('是否jpg:' + imtype.isJPG(new Uint8Array(data)));
        console.log('是否png:' + imtype.isPNG(new Uint8Array(data)));
        console.log('是否gif:' + imtype.isGIF(new Uint8Array(data)));
        console.log('是否bmp:' + imtype.isBMP(new Uint8Array(data)));
        console.log('是否tif:' + imtype.isTIF(new Uint8Array(data)));
      })
      .catch(err => {
        console.log('addFileToDisk err=' + err)
      })

  }
}