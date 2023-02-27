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
import jsBase64 from 'js-base64'
import jsBase32 from 'hi-base32'
import {strToArr, strToHexCharCode}  from '../conversion/binToJson.js'

@Extend(Divider) function dividerFancy () {
  .strokeWidth(1)
  .color(Color.Blue)
  .margin(5)
  .lineCap(LineCapStyle.Butt)
}

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
struct Binary {
  @State mBase64Input: string = 'Qi Li Xiang'
  @State mBase64Result: string= ''
  @State mBase64decodeResult: string= ''
  @State mBase64Type: number= 0
  //===========================================
  @State mBase32Type: number= 0
  @State mBase32Input: string = 'Qi Li Xiang'
  @State mBase32Result: string= ''
  @State mBase32decodeResult: string= ''
  //==================================
  @State mBinary2Input: string = 'Qi Li Xiang'
  @State mBinary2Result: string= ''
  //======================================
  @State mBinary16Input: string = 'Qi Li Xiang'
  @State mBinary16Result: string= ''

  build() {
      Column() {
        Text('Base64测试内容：Qi Li Xiang；Log打印结果： UWkgTGkgWGlhbmc= \n 支持文本/数字/特殊字符/图片').textFancy(12, Color.Black, true)

        Flex({ alignItems: ItemAlign.Center }) {
          TextInput({ placeholder: '', text: this.mBase64Input })
            .onChange((value: string) => {
              this.mBase64Input = value;
            })
            .width(220)
            .margin(5)

          Button() {
            Text('Base64编码').textFancy(13, Color.White, false)
          }
          .buttonFancy()
          .onClick(() => {

            this.mBase64Type = 1
            this.mBase64Result = jsBase64.encode(this.mBase64Input);
            console.log("Base64编码 = " + "【" + this.mBase64Result + "】")

          })
        }

        Text(this.mBase64Type == 1 ? this.mBase64Result : this.mBase64decodeResult).textFancy(12, Color.Black, false)

        Flex({ alignItems: ItemAlign.Center }) {
          TextInput({ placeholder: '', text: this.mBase64Result })
            .onChange((value: string) => {
              this.mBase64Result = value;
            })
            .width(220)
            .margin(5)

          Button() {
            Text('Base64解码').textFancy(13, Color.White, false)
          }
          .buttonFancy()
          .onClick(() => {
            this.mBase64Type = 2
            this.mBase64decodeResult = jsBase64.decode(this.mBase64Result)
            console.log("Base64解码 = " + "【" + this.mBase64decodeResult + "】")
          })
        }

        //======================================================================================
        Divider().dividerFancy()
        //===================================================================================
        Text('Base32测试内容：Qi Li Xiang；Log打印结果：KFUSATDJEBMGSYLOM4======  \n 支持文本/数字/特殊字符/图片').textFancy(12, Color.Black, true)

        Flex({ alignItems: ItemAlign.Center }) {
          TextInput({ placeholder: '', text: this.mBase32Input })
            .onChange((value: string) => {
              this.mBase32Input = value;
            })
            .width(220)
            .margin(5)

          Button() {
            Text('Base32编码').textFancy(13, Color.White, false)
          }
          .buttonFancy()
          .onClick(() => {
            this.mBase32Type = 1
            this.mBase32Result = jsBase32.encode(this.mBase32Input)
            console.log("Base32编码 = " + "【" + this.mBase32Result + "】")
          })
        }


        Text(this.mBase32Type == 1 ? this.mBase32Result : this.mBase32decodeResult).textFancy(13, Color.Black, false)

        Flex({ alignItems: ItemAlign.Center }) {
          TextInput({ placeholder: '', text: this.mBase32Result })
            .onChange((value: string) => {
              this.mBase32Result = value;
            })
            .width(220)
            .margin(5)

          Button() {
            Text('Base32解码').textFancy(13, Color.White, false)
          }
          .buttonFancy()
          .onClick(() => {
            this.mBase32Type = 2
            this.mBase32decodeResult = jsBase32.decode(this.mBase32Result)
            console.log("Base32解码 = " + "【" + this.mBase32decodeResult + "】")
          })
        }

        //======================================================================================
        Divider().dividerFancy()
        //===================================================================================

        Text('二进制测试内容：Qi Li Xiang；Log打印结果：1010001,1101001,100000,1001100,1101001,100000,1011000,1101001,1100001,1101110,1100111  \n 支持文本/数字/特殊字符')
          .textFancy(12, Color.Black, true)

        Flex({ alignItems: ItemAlign.Center }) {
          TextInput({ placeholder: '', text: this.mBinary2Input })
            .onChange((value: string) => {
              this.mBinary2Input = value;
            })
            .width(220)
            .margin(5)

          Button() {
            Text('二进制解析').textFancy(13, Color.White, false)
          }
          .buttonFancy()
          .onClick(() => {
            this.mBinary2Result = strToArr(this.mBinary2Input) + ''
            console.log("二进制解析 = " + "【" + this.mBinary2Result + "】")
          })
        }

        Text(this.mBinary2Result).textFancy(12, Color.Black, false)

        //======================================================================================
        Divider().dividerFancy()
        //===================================================================================

        Text('十六进制测试内容：Qi Li Xiang；Log打印结果：0x5169204c69205869616e67  \n 支持文本/数字/特殊字符').textFancy(12, Color.Black, true)

        Flex({ alignItems: ItemAlign.Center }) {
          TextInput({ placeholder: '', text: this.mBinary16Input })
            .onChange((value: string) => {
              this.mBinary16Input = value;
            })
            .width(220)
            .margin(5)

          Button() {
            Text('十六进制解析').textFancy(13, Color.White, false)
          }
          .buttonFancy()
          .onClick(() => {
            this.mBinary16Result = strToHexCharCode(this.mBinary16Input) + ''
            console.log("十六进制解析 = " + "【" + this.mBinary16Result + "】")
          })
        }

        Text(this.mBinary16Result).textFancy(12, Color.Black, false)
      }.alignItems(HorizontalAlign.Start).margin(5)


  }
}