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
import { er } from 'easy-replace'
import router from '@system.router';
import { setData, CustomDialogExample } from './loding'

@Entry
@Component
struct Index {
  @State TextCompletes: string = "&nbsp; Nbsp &nbsp nbsp"
  @State Replace: string= "nbsp"
  @State StringResults: string = "&"
  @State Text: string= ""
  @State replaces: string= "&nbsp"
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogExample({}),
    autoCancel: true
  });

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start }) {
        Button($r('app.string.Back'))
          .fontSize(16)
          .height(30)
          .onClick(() => {
            router.push({ uri: "pages/HomePage", })
          })
      }

      Column() {
        Text($r('app.string.Please_enter_text')).fontSize(18).fontColor("red")
      }.alignItems(HorizontalAlign.Start).width('90%').margin({ left: "20%" })

      TextInput({ placeholder: $r('app.string.Please_enter_text'), text: this.TextCompletes }).width("70%")
        .onChange((value) => {
          this.TextCompletes = value
        })
      Column() {
        Text($r('app.string.Please_enter_the_characters')).fontSize(18).fontColor("red")
      }.alignItems(HorizontalAlign.Start).width('90%').margin({ left: "20%" })

      TextInput({ placeholder: $r('app.string.Please_enter_the_characters'), text: this.Replace })
        .width("70%")
        .margin({ top: 10, bottom: 10 })
        .onChange((value) => {
          this.Replace = value
        })
      Column() {
        Text($r('app.string.Please_enter_the_replacement')).fontSize(18).fontColor("red")
      }.alignItems(HorizontalAlign.Start).width('90%').margin({ left: "20%" })

      TextInput({ placeholder: $r('app.string.Please_enter_the_replacement'), text: this.StringResults })
        .width("70%")
        .onChange((value) => {
          this.StringResults = value
        })
      Button($r('app.string.Surrounding_replacement'))
        .margin({ top: 10, bottom: 10 })
        .onClick(() => {
          this.Text = er(
            this.TextCompletes,
            {
              leftOutsideNot: "",
              leftOutside: "",
              leftMaybe: this.StringResults,
              searchFor: this.Replace,
              rightMaybe: "",
              rightOutside: "",
              rightOutsideNot: "",
              i: {
                leftOutsideNot: false,
                leftOutside: false,
                leftMaybe: true,
                searchFor: true,
                rightMaybe: false,
                rightOutside: false,
                rightOutsideNot: false,
              },
            },
            this.StringResults + this.Replace,
          );
          setData(this.Text)
          this.dialogController.open()
        })
    }
    .width('100%')
    .height('100%')
  }
}
