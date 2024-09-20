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
import base32 from 'hi-base32'
@Entry
@Component
struct Index {
  @State message: string = getContext(this).resourceManager.getStringByNameSync('text_label').toString()
  @State inputText: string = ''
  @State encodes: string = ''

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(40)
          .fontWeight(FontWeight.Bold)

        TextInput({ placeholder: 'input your word', text: this.inputText })
          .height(60)
          .border({ width: 5, color: Color.Red })
          .placeholderColor(Color.Blue)
          .placeholderFont({ size: 20, weight: FontWeight.Normal, family: "sans-serif", style: FontStyle.Italic })
          .caretColor(Color.Blue)
          .enterKeyType(EnterKeyType.Search)
          .onChange((value: string) => {
            this.inputText = value
          })

        Button($r("app.string.encode_label")).width(300).margin(20).fontSize(25).onClick(()=>{
          this.encodes = base32.encode (this.inputText);
          this.showDialog(this.encodes )
        })

        Button($r("app.string.decode_label")).width(300).margin(20).fontSize(25).onClick(()=>{
          let mess = base32.decode (this.encodes );
          this.showDialog(mess)
        })

      }
      .width('100%')
    }
    .height('100%')
  }
  showDialog(message:string){
    AlertDialog.show({
      title: '',
      message: message,
      confirm: {
        value: 'OK',
        action:()=>{

        }
      }
    })
  }

}