/**
 * MIT License
 *
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the 'Software'), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to all conditions.
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import pako, { constants } from 'pako'
import prompt from '@ohos.promptAction';

interface levelType {
  level: number
}

interface optionsType {
  gzip: boolean,
  level: number
}

@Entry
@Component
export default struct deflateDemo {
  @State Deflate1: string | undefined = "0";
  @State Deflate2: string | undefined = "0";
  @State Deflate3: string | undefined = "0";
  @State Inflate: string | undefined = "0";
  @State Inflate2: string | undefined = "0";
  @State ungzip1: string | undefined = "0";

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start }) {
      List({ space: 20, initialIndex: 0 }) {
        ListItem() {
          Column({ space: 12 }) {
            Button($r('app.string.testDeflateOne'), { type: ButtonType.Normal })
              .fontSize(18)
              .fontColor('#000')
              .height(60)
              .width(300)
              .margin({ top: 20 })
              .backgroundColor('#12939f')
              .onClick(() => {
                this.DeflateTest1()
              })
            Text($r('app.string.respectResult') +
              '120,94,99,100,98,102,97,101,99,231,224,228,226,230,225,229,227,23,16,20,18,6,0,5,69,0,191')
              .fontSize(20)
              .margin({ top: 16 })
            Text(`${$r('app.string.realResult')}${this.Deflate1}`)
              .fontSize(20)
              .margin({ top: 16 })
            Button($r('app.string.testDeflateTwo'), { type: ButtonType.Normal })
              .fontSize(18)
              .fontColor('#000')
              .height(60)
              .width(300)
              .margin({ top: 20 })
              .backgroundColor('#12939f')
              .onClick(() => {
                this.DeflateTest2()
              })
            Text($r('app.string.respectResult')+'120,156,99,100,98,102,97,101,99,231,224,4,0,0,174,0,46')
              .fontSize(20)
              .margin({ top: 16 })
            Text(`${$r('app.string.realResult')}${this.Deflate2}`)
              .fontSize(20)
              .margin({ top: 16 })
            Button($r('app.string.testDeflateThree'), { type: ButtonType.Normal })
              .fontSize(18)
              .fontColor('#000')
              .height(60)
              .width(300)
              .margin({ top: 20 })
              .backgroundColor('#12939f')
              .onClick(() => {
                this.DeflateTest3()
              })
            Text($r('app.string.respectResult')+'99,100,98,102,97,101,99,231,224,4,0')
              .fontSize(20)
              .margin({ top: 16 })

            Text(`${$r('app.string.realResult')}${this.Deflate3}`)
              .fontSize(20)
              .margin({ top: 16 })
            Button($r('app.string.testInflate'), { type: ButtonType.Normal })
              .fontSize(18)
              .fontColor('#000')
              .height(60)
              .width(300)
              .margin({ top: 20 })
              .backgroundColor('#12939f')
              .onClick(() => {
                this.InflateInflateTest()
              })
            Text($r('app.string.respectResult')+'1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19')
              .fontSize(20)
              .margin({ top: 16 })
            Text(`${$r('app.string.realResult')}${this.Inflate}`)
              .fontSize(20)
              .margin({ top: 16 })
            Button($r('app.string.testinflateRaw'), { type: ButtonType.Normal })
              .fontSize(18)
              .fontColor('#000')
              .height(60)
              .width(300)
              .margin({ top: 20 })
              .backgroundColor('#12939f')
              .onClick(() => {
                this.InflateInflateRawTest()
              })
            Text($r('app.string.respectResult')+'1,2,3,4,5,6,7,8,9')
              .fontSize(20)
              .margin({ top: 16 })

            Text(`${$r('app.string.realResult')}${this.Inflate2}`)
              .fontSize(20)
              .margin({ top: 16 })
            Button('测试ungzip接口', { type: ButtonType.Normal })
              .fontSize(18)
              .fontColor('#000')
              .height(60)
              .width(300)
              .margin({ top: 20 })
              .backgroundColor('#12939f')
              .onClick(() => {
                this.ungzipTest()
              })
            Text($r('app.string.respectResult')+'1,2,3,4,5,6,7,8,9')
              .fontSize(20)
              .margin({ top: 16 })
            Text(`${$r('app.string.realResult')}${this.ungzip1}`)
              .fontSize(20)
              .margin({ top: 16 })
          }
        }
      }
    }
  }

  DeflateTest1() {
    let chunk1 = new Uint8Array([1, 2, 3, 4, 5, 6, 7, 8, 9])
    let chunk2 = new Uint8Array([10, 11, 12, 13, 14, 15, 16, 17, 18, 19]);
    let levelData: levelType = { level: 3 }
    const deflate: pako.Deflate = new pako.Deflate(levelData);
    deflate.push(chunk1, false);
    deflate.push(chunk2, true);
    let deflateArray: Uint8Array | undefined = deflate.result
    this.Deflate1 = deflateArray?.toString()
    let err: string | number = deflate.err != constants.Z_OK ? deflate.msg : constants.Z_OK
    prompt.showToast({ message: "" + err, duration: 4000 })
  }

  DeflateTest2() {
    const data = new Uint8Array([1, 2, 3, 4, 5, 6, 7, 8, 9]);
    let array = new Uint8Array([120, 156, 99, 100, 98, 102, 97, 101, 99, 231, 224, 4, 0, 0, 174, 0, 46])
    let deflateArray: Uint8Array | undefined = pako.deflate(data)
    this.Deflate2 = deflateArray?.toString()
    let result: Boolean = (deflateArray?.toString() === array.toString())
    prompt.showToast({ message: result.toString(), duration: 4000 })
  }

  DeflateTest3() {
    let data = new Uint8Array([1, 2, 3, 4, 5, 6, 7, 8, 9])
    let deflateArray: Uint8Array | undefined = pako.deflateRaw(data)
    let array = new Uint8Array([99, 100, 98, 102, 97, 101, 99, 231, 224, 4, 0])
    this.Deflate3 = deflateArray?.toString()
    let result: Boolean = (deflateArray?.toString() === array.toString())
    prompt.showToast({ message: result.toString(), duration: 4000 })

  }

  InflateInflateTest() {
    let levelData: levelType = { level: 3 }
    const chunk1 = new Uint8Array([120, 94, 99, 100, 98, 102, 97, 101, 99, 231, 224])
    const chunk2 = new Uint8Array([228, 226, 230, 225, 229, 227, 23, 16, 20, 18, 6, 0, 5, 69, 0, 191]);
    const inflate: pako.Inflate = new pako.Inflate(levelData);

    inflate.push(chunk1, false);
    inflate.push(chunk2, true);

    let err: string | number = inflate.err != constants.Z_OK ? inflate.msg : constants.Z_OK
    this.Inflate = inflate.result?.toString()
    prompt.showToast({ message: "" + err, duration: 4000 })
  }

  InflateInflateRawTest() {
    const chunk1 = new Uint8Array([99, 100, 98, 102, 97, 101, 99, 231, 224, 4, 0])
    const inflate: string | Uint8Array | undefined = pako.inflateRaw(chunk1);
    this.Inflate2 = inflate?.toString()
    let array = new Uint8Array([1, 2, 3, 4, 5, 6, 7, 8, 9])
    let result: Boolean = (inflate?.toString() === array.toString())
    prompt.showToast({ message: result.toString(), duration: 4000 })
  }

  ungzipTest() {
    let ungzipTestData: optionsType = { gzip: true, level: 9 }
    let array = new Uint8Array([1, 2, 3, 4, 5, 6, 7, 8, 9])
    let gzip: Uint8Array | undefined = pako.gzip(array, ungzipTestData);
    let ungzip: string | Uint8Array | undefined = pako.ungzip(gzip, ungzipTestData);
    this.ungzip1 = ungzip?.toString()
    let result: Boolean = (ungzip?.toString() === array.toString())
    prompt.showToast({ message: result.toString(), duration: 4000 })
  }
}