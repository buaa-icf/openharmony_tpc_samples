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
import image from '@ohos.multimedia.image';
import util from '@ohos.util';
import { FileUtils } from './utils/FileUtils'
import PCX from 'pcx-js'

@Entry
@Component
struct Index {
  @State p1Pixels: PixelMap = undefined;
  mDecodeIcos: any
  mCount = 0
  @State p2Pixels: PixelMap = undefined;
  @State p3Pixels: PixelMap = undefined;
  mDecodeIcos2: any
  mCount2 = 0

  build() {
    Scroll() {
      Column() {
        Button('点击解码PCX图片').fontSize(20).onClick(() => {

          getContext(this).resourceManager.getMediaContent($r("app.media.thimbleweed").id).then((uint8Array) => {
            console.log("dodo uint8Array length=" + uint8Array.byteLength);
            //            let base64 = new util.Base64Helper();
            //            FileUtils.getInstance().writeFile(path,base64.encodeToStringSync(uint8Array))
            // @ts-ignore
            //            let pcx  = require('pcx-js')
            let pcxDecoder = new PCX(uint8Array.buffer);
            let decodeData = pcxDecoder.decode();
            console.log("dodo decodeData length=" + decodeData.pixelArray.buffer.byteLength);
            //            let images = decodeIco(uint8Array);
            //            this.mDecodeIcos = images;
            //            console.log("dodo colorsBuffer length=" + images[0].data.byteLength);
            this.RBGA2BGRA(decodeData.pixelArray)
            image.createPixelMap(decodeData.pixelArray.buffer, {
              'size': {
                'width': decodeData.width,
                'height': decodeData.height
              }
            }).then((pixels) => {
              this.p1Pixels = pixels;
            })
          })
        })

        Image(this.p1Pixels)
          .objectFit(ImageFit.Contain)
          .width(200)
          .height(200)
          .backgroundColor(Color.Pink)
          .margin(10)
        Button('点击解码PCX图片2').fontSize(20).onClick(() => {
          let path = getContext(this).filesDir + "/small";
          getContext(this).resourceManager.getMediaContent($r('app.media.small').id).then((uint8Array) => {
            let base64 = new util.Base64Helper();
            FileUtils.getInstance().writeFile(path, base64.encodeToStringSync(uint8Array))
            console.log("dodo uint8Array 2 length=" + uint8Array.byteLength);
            // @ts-ignore
            //            let pcx  = require('pcx-js')
            let pcxDecoder = new PCX(uint8Array.buffer);
            let decodeData = pcxDecoder.decode();
            console.log("dodo decodeData 2 length=" + decodeData.pixelArray.buffer.byteLength + " width=" + decodeData.width + " height=" + decodeData.height);

            this.RBGA2BGRA(decodeData.pixelArray)
            image.createPixelMap(decodeData.pixelArray.buffer, {
              'size': {
                'width': decodeData.width,
                'height': decodeData.height
              }
            }).then((pixels) => {
              this.p2Pixels = pixels;
            })
          })
        })

        Image(this.p2Pixels)
          .objectFit(ImageFit.Contain)
          .width(200)
          .height(200)
          .backgroundColor(Color.Pink)
          .margin(10)
        Button('点击解码PCX图片3').fontSize(20).onClick(() => {
          let path = getContext(this).filesDir + "/parrot";
          getContext(this).resourceManager.getMediaContent($r('app.media.parrot').id).then((uint8Array) => {
            let base64 = new util.Base64Helper();
            FileUtils.getInstance().writeFile(path, base64.encodeToStringSync(uint8Array))
            console.log("dodo uint8Array 3 length=" + uint8Array.byteLength);
            // @ts-ignore
            //            let pcx  = require('pcx-js')
            let pcxDecoder = new PCX(uint8Array.buffer);
            let decodeData = pcxDecoder.decode();
            console.log("dodo decodeData 3 length=" + decodeData.pixelArray.buffer.byteLength + " width=" + decodeData.width + " height=" + decodeData.height);

            this.RBGA2BGRA(decodeData.pixelArray)
            image.createPixelMap(decodeData.pixelArray.buffer, {
              'size': {
                'width': decodeData.width,
                'height': decodeData.height
              }
            }).then((pixels) => {
              this.p3Pixels = pixels;
            })
          })
        })

        Image(this.p3Pixels)
          .objectFit(ImageFit.Contain)
          .width(200)
          .height(200)
          .backgroundColor(Color.Pink)
          .margin(10)

      }
    }
    .width('100%')
    .height('100%')
  }

  aboutToAppear() {

  }

  RBGA2BGRA(input: Uint8ClampedArray) {
    for (let i = 0; i < input.byteLength; i = i + 4) {
      let colorR = input[i+0];
      let colorG = input[i+1];
      let colorB = input[i+2];
      let colorA = input[i+3];
      let temp = colorR;
      input[i+0] = colorB;
      input[i+2] = temp;
    }
  }
}