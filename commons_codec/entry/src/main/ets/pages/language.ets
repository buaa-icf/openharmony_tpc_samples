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
// @ts-ignore
import jsCaverPhone from 'caverphone'
import {soundex} from 'soundex-code'
import {metaphone} from 'metaphone'

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
struct Language {
  @State mCaverPhoneInput: string = 'word'
  @State mCaverPhoneResult: string= ''
  //=====================================
  @State mSoundexInput: string = 'phonetics'
  @State mSoundexResult: string= ''
  //=====================================
  @State mMetaphoneInput: string = 'michael'
  @State mMetaphoneResult: string= ''

  build() {
    Column() {
      Text('CaverPhone编码内容：word；Log打印结果：WT11111111 \n 只支持字母').textFancy(12, Color.Black, true)

      Flex({ alignItems: ItemAlign.Center }) {
        TextInput({ placeholder: '', text: this.mCaverPhoneInput })
          .onChange((value: string) => {
            this.mCaverPhoneInput = value;
          })
          .width(220)
          .margin(5)

        Button() {
          Text('CaverPhone').textFancy(13, Color.White, false)
        }
        .buttonFancy()
        .onClick(() => {
          // https://github.com/tcort/caverphone
          this.mCaverPhoneResult = jsCaverPhone(this.mCaverPhoneInput)
          console.log("CaverPhone编码 = " + "【" + this.mCaverPhoneResult + "】")
        })
      }

      Text(this.mCaverPhoneResult).textFancy(12, Color.Black, false)

      //======================================================================================
      Divider().dividerFancy()
      //===================================================================================
      Text('Soundex编码内容：phonetics；Log打印结果：P532 \n 只支持字母 ').textFancy(12, Color.Black, true)

      Flex({ alignItems: ItemAlign.Center }) {
        TextInput({ placeholder: '', text: this.mSoundexInput })
          .onChange((value: string) => {
            this.mSoundexInput = value;
          })
          .width(220)
          .margin(5)

        Button() {
          Text('Soundex').textFancy(13, Color.White, false)
        }
        .buttonFancy()
        .onClick(() => {
          //Soundex 算法 https://github.com/LouisT/node-soundex
          // @ts-ignore
          this.mSoundexResult = soundex(this.mSoundexInput)
          console.log("Soundex编码 = " + "【" + this.mSoundexResult + "】")
        })
      }

      Text(this.mSoundexResult).textFancy(12, Color.Black, false)

      //======================================================================================
      Divider().dividerFancy()
      //===================================================================================
      Text('Metaphone 编码内容：michael；Log打印结果：MXL \n 只支持字母').textFancy(12, Color.Black, true)

      Flex({ alignItems: ItemAlign.Center }) {
        TextInput({ placeholder: '', text: this.mMetaphoneInput })
          .onChange((value: string) => {
            this.mMetaphoneInput = value;
          })
          .width(220)
          .margin(5)

        Button() {
          Text('Metaphone').textFancy(13, Color.White, false)
        }
        .buttonFancy()
        .onClick(() => {
          //          this.mMetaphoneResult = jsMetaphone.metaphone(this.mMetaphoneInput)
          this.mMetaphoneResult = metaphone(this.mMetaphoneInput)
          console.log("Metaphone编码 = " + "【" + this.mMetaphoneResult + "】")
        })
      }

      Text(this.mMetaphoneResult).textFancy(12, Color.Black, false)

    }.alignItems(HorizontalAlign.Start).margin(5)
  }
}