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
import { compareVersions, compare, CompareOperator, satisfies, validate, validateStrict } from "compare-versions";
import promptAction from '@ohos.promptAction';

let tag = "COMPARE_VERSIONS----"

enum ECurrentEdit {
  A,
  B
}

@Entry
@Component
struct Index {
  @State message: string = 'Hello World'
  @State versionA: string = "4.1.0"
  @State versionB: string = "~10.0.0"
  @State operator: CompareOperator = "<"
  @State currentEdit: ECurrentEdit = ECurrentEdit.A
  private quickTexts: Array<string> = [
    "1.2.7 || >=1.2.9 <2.0.0",
    "1.2.3 - 2.3.4",
    ">=10.2.2",
    "<=10.2.2",
    "~10.0.0",
    "^10.0.0",
    ">10.0.4",
    "<10.2.2",
    "=10.0.1",
    "||",">=","<=","-","<",">","=","^","~"
  ]

  @Builder BuildButton(text: Resource, callback: () => void) {
    Button(text).onClick(callback).margin({ right: 4, bottom: 4 })
  }

  @Builder BuildQuickText(text: string) {
    Text(text).fontSize(14).margin({ right: 20, bottom: 10 }).onClick(() => {
      if (this.currentEdit === ECurrentEdit.A) {
        this.versionA = this.versionA.concat(text);
      }
      if (this.currentEdit === ECurrentEdit.B) {
        this.versionB = this.versionB.concat(text);
      }
    })
      .border({width:1,color:Color.Gray}).padding(6).borderRadius(4)
  }

  showMessage(message: string) {
    this.getUIContext().getPromptAction().showToast({ message });
    console.log(`${tag}${message}`)
  }

  build() {
    Column() {
      Row() {
        Text($r("app.string.text_version_a"))
        TextInput({ placeholder: $r("app.string.placeholder_input"), text: this.versionA, })
          .width("50%")
          .onChange((value: string) => {
            this.versionA = value;
          })
          .onBlur(() => {
            this.currentEdit = ECurrentEdit.B
            console.log(`vvvv---${this.currentEdit}}`)
          })
      }.margin({ bottom: 20 })

      Row() {
        Text($r("app.string.text_version_b"))
        TextInput({ placeholder: $r('app.string.placeholder_input'), text: this.versionB })
          .width("50%")
          .onChange((value: string) => {
            this.versionB = value;
          })
          .onBlur(() => {
            this.currentEdit = ECurrentEdit.A
            console.log(`vvvv---${this.currentEdit}}`)
          })
      }.margin({ bottom: 20 })

      Row() {
        Text($r("app.string.text_arithmetic_operators"))
        Row() {
          Row() {
            Radio({ value: 'Radio1', group: 'radioGroup' }).checked(this.operator === ">")
              .height(20)
              .width(20)
              .onChange((isChecked: boolean) => {
                this.operator = ">"
              })
            Text('>')

          }.margin({ right: 10 })

          Row() {
            Radio({ value: 'Radio1', group: 'radioGroup' }).checked(this.operator === "<")
              .height(20)
              .width(20)
              .onChange((isChecked: boolean) => {
                this.operator = "<"

                console.log('Radio1 status is ' + isChecked)
              })
            Text('<')
          }.margin({ right: 10 })

          Row() {
            Radio({ value: 'Radio1', group: 'radioGroup' }).checked(this.operator === "=")
              .height(20)
              .width(20)
              .onChange((isChecked: boolean) => {
                console.log('Radio1 status is ' + isChecked)
                this.operator = "="

              })
            Text('=')
          }.margin({ right: 10 })

          Row() {
            Radio({ value: 'Radio1', group: 'radioGroup' }).checked(this.operator === ">=")
              .height(20)
              .width(20)
              .onChange((isChecked: boolean) => {
                console.log('Radio1 status is ' + isChecked)
                this.operator = ">="

              })
            Text('>=')
          }.margin({ right: 10 })

          Row() {
            Radio({ value: 'Radio1', group: 'radioGroup' }).checked(this.operator === "<=")
              .height(20)
              .width(20)
              .onChange((isChecked: boolean) => {
                console.log('Radio1 status is ' + isChecked)
                this.operator = "<="

              })
            Text('<=')
          }
        }
      }.margin({ bottom: 20 })

      Column() {
        Text($r("app.string.text_quick_operators")).width("100%").margin({ bottom: 10 }).fontSize(16)
        Flex({ wrap: FlexWrap.Wrap }) {
          ForEach(this.quickTexts,(text:string) => {
            this.BuildQuickText(text);
          })
        }
      }.margin({ bottom: 20 }).width("100%")

      Text($r("app.string.text_operators")).width("100%").margin({ top: 30, bottom: 20 })
      Flex({ wrap: FlexWrap.Wrap }) {
        this.BuildButton($r("app.string.button_compare_version"), () => {
          try {
            this.showMessage(compareVersions(this.versionA, this.versionB) + "")
          } catch (err) {
            this.showMessage(err.message);
          }
        })
        this.BuildButton($r("app.string.button_compare_operators"), () => {
          try {
            this.showMessage(compare(this.versionA, this.versionB, this.operator) + "")
          } catch (err) {
            this.showMessage(err.message);
          }
        })
        this.BuildButton($r("app.string.button_compare_satisfies"), () => {
          try {
            this.showMessage(satisfies(this.versionA, this.versionB) + "")
          } catch (err) {
            this.showMessage(err.message);
          }
        })
        this.BuildButton($r("app.string.button_version_sort"), () => {


          try {
            const versions = [this.versionA, this.versionB]
            const sorted = versions.sort(compareVersions);
            this.showMessage(JSON.stringify(sorted))
          } catch (err) {
            this.showMessage(err.message);
          }

        })

        this.BuildButton($r("app.string.button_validate"), () => {
          this.showMessage(validate(this.versionA) + "")
        })


        this.BuildButton($r("app.string.button_strict"), () => {
          this.showMessage(validateStrict(this.versionA) + "")
        })


      }.width("100%")
    }
    .justifyContent(FlexAlign.Start)
    .width('100%')
    .height("100%")
    .padding({ top: 30, left: 10, right: 10 })

  }
}