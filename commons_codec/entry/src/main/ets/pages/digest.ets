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
import jsMd5 from 'js-md5'
import jsMd2 from 'js-md2'
import jsSha256 from 'js-sha256'
import jsSha1 from 'js-sha1'

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
struct Digest {
  @State mMd5Input: string = 'Qi Li Xiang'
  @State mMd5Result: string= ''
  //===============================
  @State mMd2Input: string = 'Qi Li Xiang'
  @State mMd2Result: string= ''
  //==============================
  @State mSha256Input: string = 'Qi Li Xiang'
  @State mSha256Result: string= ''
  @State mSha256Type: number= 0
  @State mSha256HexInput: string = 'Qi Li Xiang'
  @State mSha256HexResult: string= ''
  //====================================
  @State mSha224Input: string = 'Qi Li Xiang'
  @State mSha224Result: string= ''
  @State mSha224Type: number= 0
  @State mSha224HexInput: string = 'Qi Li Xiang'
  @State mSha224HexResult: string= ''
  //==========================================
  @State mSha1Input: string = 'Qi Li Xiang'
  @State mSha1Result: string= ''
  @State mSha1Type: number= 0
  @State mSha1HexInput: string = 'Qi Li Xiang'
  @State mSha1HexResult: string= ''

  build() {
    Scroll() {
      Column() {
        Text('MD5加密内容：Qi Li Xiang；Log打印结果：d962b63a0f819b562a86b05a8aa60c3a  \n 支持文本/数字/特殊字符').textFancy(12, Color.Black, true)
        Flex({ alignItems: ItemAlign.Center }) {
          TextInput({ placeholder: '', text: this.mMd5Input })
            .onChange((value: string) => {
              this.mMd5Input = value;
            })
            .width(220)

          Button() {
            Text('MD5').textFancy(13, Color.White, true)

          }
          .buttonFancy()
          .onClick(() => {
            //https://github.com/emn178/js-md5
            this.mMd5Result = jsMd5(this.mMd5Input)
            console.log("Md5加密 = " + "【" + this.mMd5Result + "】")
          })
        }

        Text(this.mMd5Result).textFancy(12, Color.Black, false)
        //======================================================================================
        Divider().dividerFancy()
        //===================================================================================
        Text('MD2加密内容：Qi Li Xiang；Log打印结果：505753f30e271890f1832c8021e7e66e \n 支持文本/数字/特殊字符').textFancy(12, Color.Black, true)

        Flex({ alignItems: ItemAlign.Center }) {
          TextInput({ placeholder: '', text: this.mMd2Input })
            .onChange((value: string) => {
              this.mMd2Input = value;
            })
            .width(220)

          Button() {
            Text('MD2').textFancy(13, Color.White, false)
          }
          .buttonFancy()
          .onClick(() => {
            //https://github.com/emn178/js-md2
            this.mMd2Result = jsMd2(this.mMd2Input)
            console.log("Md2加密 = " + "【" + this.mMd2Result + "】")
          })
        }

        Text(this.mMd2Result).textFancy(12, Color.Black, false)
        //======================================================================================
        Divider().dividerFancy()
        //===================================================================================
        Text('SHA256内容：Qi Li Xiang；Log打印结果：63f14d6a5c155d3710c35c421d5b47152c0cee26d0bf930d1688403419e60adb \n 支持文本/数字/特殊字符')
          .textFancy(12, Color.Black, true)

        Flex({ alignItems: ItemAlign.Center }) {
          TextInput({ placeholder: '', text: this.mSha256Input })
            .onChange((value: string) => {
              this.mSha256Input = value;
            })
            .width(220)

          Button() {
            Text('SHA256').textFancy(13, Color.White, false)
          }
          .buttonFancy()
          .onClick(() => {
            //  https://github.com/emn178/js-sha256
            this.mSha256Type = 1
            var sha256 = jsSha256.sha256
            this.mSha256Result = sha256(this.mSha256Input)
            console.log("SHA256编码= " + "【" + this.mSha256Result + "】")
          })
        }

        Text(this.mSha256Type == 1 ? this.mSha256Result : this.mSha256HexResult).textFancy(12, Color.Black, false)

        Flex({ alignItems: ItemAlign.Center }) {
          TextInput({ placeholder: '', text: this.mSha256HexInput })
            .onChange((value: string) => {
              this.mSha256HexInput = value;
            })
            .width(220)

          Button() {
            Text('SHA256 Hex').textFancy(13, Color.White, false)
          }
          .buttonFancy()
          .onClick(() => {
            //  https://github.com/emn178/js-sha256
            this.mSha256Type = 2
            var sha256 = jsSha256.sha256
            this.mSha256HexResult = sha256.hex(this.mSha256HexInput)
            console.log("SHA256编码转Hex = " + "【" + this.mSha256HexResult + "】")
          })
        }

        //======================================================================================
        Divider().dividerFancy()
        //===================================================================================
        Text('SHA224内容：Qi Li Xiang；Log打印结果：9526b1c9cea665794322b4807cd5a6f8770aad4f8619be812b9879da \n 支持文本/数字/特殊字符')
          .textFancy(12, Color.Black, true)

        Flex({ alignItems: ItemAlign.Center }) {
          TextInput({ placeholder: '', text: this.mSha224Input })
            .onChange((value: string) => {
              this.mSha224Input = value;
            })
            .width(220)

          Button() {
            Text('SHA224').textFancy(13, Color.White, false)
          }
          .buttonFancy()
          .onClick(() => {
            //  https://github.com/emn178/js-sha256
            this.mSha224Type = 1

            var sha224 = jsSha256.sha224
            this.mSha224Result = sha224(this.mSha224Input)
            console.log("SHA224编码= " + "【" + this.mSha224Result + "】")
          })
        }

        Text(this.mSha224Type == 1 ? this.mSha224Result : this.mSha224HexResult).textFancy(12, Color.Black, false)

        Flex({ alignItems: ItemAlign.Center }) {
          TextInput({ placeholder: '', text: this.mSha224HexInput })
            .onChange((value: string) => {
              this.mSha224HexInput = value;
            })
            .width(220)

          Button() {
            Text('SHA224 Hex').textFancy(13, Color.White, false)
          }
          .buttonFancy()
          .onClick(() => {
            //  https://github.com/emn178/js-sha256
            this.mSha224Type = 2
            var sha224 = jsSha256.sha224
            this.mSha224HexResult = sha224.hex(this.mSha224HexInput)
            console.log("SHA224编码转Hex = " + "【" + this.mSha224HexResult + "】")
          })
        }
        //======================================================================================
        Divider().dividerFancy()
        //===================================================================================
        Text('SHA1内容：Qi Li Xiang；Log打印结果：a800c4835d35221ee87a252c824aa47e1d09d88c \n 支持文本/数字/特殊字符').textFancy(12, Color.Black, true)

        Flex({ alignItems: ItemAlign.Center }) {
          TextInput({ placeholder: '', text: this.mSha1Input })
            .onChange((value: string) => {
              this.mSha1Input = value;
            })
            .width(220)

          Button() {
            Text('SHA1').textFancy(13, Color.White, false)
          }
          .buttonFancy()
          .onClick(() => {
            this.mSha1Type = 1
            //SHA1加密 https://github.com/emn178/js-sha1
            this.mSha1Result = jsSha1(this.mSha1Input)
            console.log("SHA1编码= " + "【" + this.mSha1Result + "】")
          })
        }

        Text(this.mSha1Type == 1 ? this.mSha1Result : this.mSha1HexResult).textFancy(12, Color.Black, false)

        Flex({ alignItems: ItemAlign.Center }) {
          TextInput({ placeholder: '', text: this.mSha1HexInput })
            .onChange((value: string) => {
              this.mSha1HexInput = value;
            })
            .width(220)

          Button() {
            Text('SHA1 Hex').textFancy(13, Color.White, false)
          }
          .buttonFancy()
          .onClick(() => {

            this.mSha1Type = 2
            //SHA1加密 https://github.com/emn178/js-sha1
            this.mSha1HexResult = jsSha1.hex(this.mSha1HexInput)
            console.log("SHA1编码转Hex = " + "【" + this.mSha1HexResult + "】")
          })
        }


      }.alignItems(HorizontalAlign.Start)
      .margin(5)
    }.scrollable(ScrollDirection.Vertical)


  }
}