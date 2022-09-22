/*
 * Copyright (C) 2021 Huawei Device Co., Ltd.
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
import {urlEncode, urlDecode}  from '../conversion/binToJson'

@Extend(Text) function textFancy (fontSize: number, textColor: Color, isBold: Boolean) {
  .fontSize(fontSize)
  .fontColor(textColor)
  .fontWeight(isBold ? FontWeight.Bold : FontWeight.Normal)
}

@Extend(Button) function buttonFancy () {
  .type(ButtonType.Capsule)
  .width(90)
  .height(40)
  .align(Alignment.Center)
}

@Entry
@Component
struct UrlEncoding {
  @State mUrlencodeInput: string = 'word is word'
  @State mUrlencodeResult: string= ''
  @State mUrlType: number= 0
  @State mUrldecodeInput: string = ''
  @State mUrldecodeResult: string= ''

  build() {
    Column() {
      Text('urlencode编码内容：word is word ；Log打印结果：word%20is%20word \n 支持文本/数字/特殊字符').textFancy(12, Color.Black, true)
      Flex({ alignItems: ItemAlign.Center }) {
        TextInput({ placeholder: '', text: this.mUrlencodeInput })
          .onChange((value: string) => {
            this.mUrlencodeInput = value;
          })
          .width(220)

        Button() {
          Text('url encode').textFancy(13, Color.White, false)
        }
        .buttonFancy()
        .onClick(() => {
          this.mUrlType = 1
          this.mUrlencodeResult = urlEncode(this.mUrlencodeInput)
          console.log("urlencode编码 = " + "【" + this.mUrlencodeResult + "】")
        })
      }

      Text(this.mUrlType == 1 ? this.mUrlencodeResult : this.mUrldecodeResult).textFancy(13, Color.Black, false)

      Flex({ alignItems: ItemAlign.Center }) {
        TextInput({ placeholder: '', text: this.mUrlencodeResult })
          .onChange((value: string) => {
            this.mUrlencodeResult = value;
          })
          .width(220)

        Button() {
          Text('url decode').textFancy(13, Color.White, false)
        }
        .buttonFancy()
        .onClick(() => {
          this.mUrlType = 2
          this.mUrldecodeResult = urlDecode(this.mUrlencodeResult)
          console.log("urlencode解码 = " + "【" + this.mUrldecodeResult + "】")
        })
      }
    }.alignItems(HorizontalAlign.Start).margin(5)

  }
}