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

import PCX from 'pcx-js'

interface Tests {
  name: string
  func: () => void
}

@Entry
@Component
struct Index {
  @State p1Pixels: PixelMap | undefined = undefined;
  mCount: number = 0
  @State p2Pixels: PixelMap | undefined = undefined;
  @State p3Pixels: PixelMap | undefined = undefined;
  mCount2: number = 0
  @State p4Pixels: PixelMap | undefined = undefined;
  @State p5Pixels: PixelMap | undefined = undefined;
  smallUint8: Uint8Array | undefined = undefined;
  smallPcx: PCX | undefined = undefined;
  @State testTimeHint: Resource = $r("app.string.Text_reminder_of_test_time")
  @State testTimeHint2: string = ''
  @State testNilPcx: Resource = $r("app.string.The_test_object_is_empty")
  @State testNoDataPcx: Resource = $r("app.string.Test_the_PCX_image_with_problem_with_parameters")

  build() {
    Scroll() {
      Column() {
        Button($r("app.string.Decode_thimbleweed_pcx_585KB")).fontSize(20).onClick(() => {

          this.getUIContext().getHostContext()!.resourceManager.getMediaContent($r("app.media.thimbleweed").id).then((uint8Array) => {
            let pcxDecoder: PCX = new PCX(uint8Array.buffer as ArrayBuffer);
            let decodeData: PCX.DecodeType = pcxDecoder.decode();
            this.RBGA2BGRA(decodeData.pixelArray)
            image.createPixelMap(this.typedArrayToBuffer(decodeData.pixelArray), {
              'size': {
                'width': decodeData.width,
                'height': decodeData.height
              }
            }).then((pixels) => {
              this.p1Pixels = pixels;
            })
          })
        })

        Image(this.p1Pixels == undefined ? "" : this.p1Pixels)
          .objectFit(ImageFit.Contain)
          .width(200)
          .height(200)
          .backgroundColor(Color.Pink)
          .margin(10)
        Button($r("app.string.Decode_small_pcx_1KB")).fontSize(20).onClick(() => {

          this.getUIContext().getHostContext()!.resourceManager.getMediaContent($r('app.media.small').id).then((uint8Array) => {
            this.smallUint8 = uint8Array;
            let pcxDecoder: PCX = new PCX(uint8Array.buffer as ArrayBuffer);
            this.smallPcx = pcxDecoder;
            let decodeData: PCX.DecodeType = pcxDecoder.decode();
            this.RBGA2BGRA(decodeData.pixelArray)
            image.createPixelMap(this.typedArrayToBuffer(decodeData.pixelArray), {
              'size': {
                'width': decodeData.width,
                'height': decodeData.height
              }
            }).then((pixels) => {
              this.p2Pixels = pixels;
            })
          })
        })

        Image(this.p2Pixels == undefined ? "" : this.p2Pixels)
          .objectFit(ImageFit.Contain)
          .width(200)
          .height(200)
          .backgroundColor(Color.Pink)
          .margin(10)
        Button($r("app.string.Decode_parrot_pcx_25KB")).fontSize(20).onClick(() => {
          this.getUIContext().getHostContext()!.resourceManager.getMediaContent($r('app.media.parrot').id).then((uint8Array) => {
            let pcxDecoder: PCX = new PCX(uint8Array.buffer as ArrayBuffer);
            let decodeData: PCX.DecodeType = pcxDecoder.decode();
            this.RBGA2BGRA(decodeData.pixelArray)
            image.createPixelMap(this.typedArrayToBuffer(decodeData.pixelArray), {
              'size': {
                'width': decodeData.width,
                'height': decodeData.height
              }
            }).then((pixels) => {
              this.p3Pixels = pixels;
            })
          })
        })

        Image(this.p3Pixels == undefined ? "" : this.p3Pixels)
          .objectFit(ImageFit.Contain)
          .width(200)
          .height(200)
          .backgroundColor(Color.Pink)
          .margin(10)

        Button($r("app.string.Decode_16col_pcx_40KB")).fontSize(20).onClick(() => {
          this.getUIContext().getHostContext()!.resourceManager.getMediaContent($r('app.media.16col').id).then((uint8Array) => {
            let pcxDecoder: PCX = new PCX(uint8Array.buffer as ArrayBuffer);
            let decodeData: PCX.DecodeType = pcxDecoder.decode();
            this.RBGA2BGRA(decodeData.pixelArray)
            image.createPixelMap(this.typedArrayToBuffer(decodeData.pixelArray), {
              'size': {
                'width': decodeData.width,
                'height': decodeData.height
              }
            }).then((pixels) => {
              this.p4Pixels = pixels;
            })
          })
        })

        Image(this!.p4Pixels)
          .objectFit(ImageFit.Contain)
          .width(200)
          .height(200)
          .backgroundColor(Color.Pink)
          .margin(10)
        Button($r("app.string.Decode_clown_pcx_73KB")).fontSize(20).onClick(() => {
          this.getUIContext().getHostContext()!.resourceManager.getMediaContent($r('app.media.clown').id).then((uint8Array) => {
            let pcxDecoder: PCX = new PCX(uint8Array.buffer as ArrayBuffer);
            let decodeData: PCX.DecodeType = pcxDecoder.decode();
            this.RBGA2BGRA(decodeData.pixelArray)
            image.createPixelMap(this.typedArrayToBuffer(decodeData.pixelArray), {
              'size': {
                'width': decodeData.width,
                'height': decodeData.height
              }
            }).then((pixels) => {
              this.p5Pixels = pixels;
            })
          })
        })

        Image(this.p5Pixels == undefined ? "" : this.p5Pixels)
          .objectFit(ImageFit.Contain)
          .width(200)
          .height(200)
          .backgroundColor(Color.Pink)
          .margin(10)

        Text(this.testTimeHint).margin({ top: 5, bottom: 5 })
        Text(this.testTimeHint2).margin({ top: 5, bottom: 5 })
        Button($r("app.string.Click_on_small_first_and_then_click_test_time_button")).onClick(() => {
          if (this.smallUint8 && this.smallPcx) {
            this.clickTestTime()
          } else {
            this.testTimeHint = $r("app.string.smallUint8smallPcx_empty_please_click_small_load_before_continuing_test")
          }
        })
          .margin({ top: 5, bottom: 5 })
        Text(this.testNilPcx)
          .margin({ top: 5, bottom: 5 })
        Button($r("app.string.Click_the_empty_object_PCX_call_decode")).onClick(() => {
          let pcx: PCX | null = null
          if (!pcx) {
            this.testNilPcx = $r("app.string.The_pcx_object_empty_and_cannot_called")
          } else if (this.smallUint8 && this.smallUint8 instanceof Uint8Array) {
            let pcx: PCX = new PCX(this.smallUint8.buffer as ArrayBuffer);
            this.testNilPcx = $r("app.string.If_pcx_object_empty_and_small_data_decode_method_can_called")
            let decodeData: PCX.DecodeType = pcx.decode();
          }
        })
          .margin({ top: 5, bottom: 5 })
        Text(this.testNoDataPcx)
          .margin({ top: 5, bottom: 5 })
        Button($r("app.string.Click_invoke_the_parsing_parameterless_PCX")).onClick(() => {
          this.testErrorInput();
        }).margin({ top: 5, bottom: 5 })


      }
    }
    .width('100%')
    .height('100%')
  }

  aboutToAppear() {

  }

  testErrorInput() {
    try {
      let pcx: PCX = new PCX();
      let decodeData: PCX.DecodeType = pcx.decode();
    } catch (err) {
      this.testNoDataPcx = $r("app.string.If_PCX_does_not_parse_data_decoding_will_cause_program_abnormal")
    }
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

  private getSysTime(): number {
    return new Date().getTime();
  }

  testTimeFunction(name: string, func: Function, count: number, invalid?: number) {
    let sumAve = 0;
    for (let i = 0; i < count; i++) {
      let s = this.getSysTime();
      func();
      let e = this.getSysTime();
      sumAve += (e - s) * 1000
    }
    let ave = (sumAve * 1.0) / (count * 1.0 * (invalid ? invalid : 1));

    console.log(`pcx-js:${name} averageTime = ${ave}us`)
    this.testTimeHint2 += `pcx-js:${name} averageTime = ${ave}us`
  }

  clickTestTime() {
    for (let i = 0; i < this.tests.length; i++) {
      let obj = this.tests[i];
      this.testTimeFunction(obj.name, obj.func, 1000);
    }
  }

  tests: Array<Tests> = [
    {
      name: 'new PCX()',
      func: () => {
        if (this.smallUint8 instanceof Uint8Array) {
          let encoder: PCX = new PCX(this.smallUint8.buffer as ArrayBuffer);
        }
      }
    },
    {
      name: 'pcx.decode()',
      func: () => {
        // let pcx = new PCX(this.smallUint8);
        this.smallPcx!.decode();
      }
    }
  ]

  typedArrayToBuffer(array: Uint8ClampedArray): ArrayBuffer {
    return array.buffer.slice(array.byteOffset, array.byteLength + array.byteOffset)
  }
}