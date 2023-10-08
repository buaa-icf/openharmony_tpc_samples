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

import router from '@system.router';
import leven from "leven";
import { setData, CustomDialogExample } from './loding'
import { er } from 'easy-replace'

@Entry
@Component
struct Index {
  @State messagevlA: string= ""
  @State messagevl: string= ""
  @State TextString: string = "Text entry"
  @State messaged: string= "e"
  @State ReplaceString: string= "t"
  @State StringResults: string = "马心"
  @State Text: string= ""
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogExample({}),
    autoCancel: true
  });

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start }) {
        Button("返回")
          .fontSize(16)
          .height(30)
          .onClick(() => {
            router.push({ uri: "pages/HomePage", })
          })
      }

      Column() {
        Text("输入文本").fontSize(18).fontColor("red")
      }.alignItems(HorizontalAlign.Start).width('90%').margin({ left: "20%" })

      TextInput({ placeholder: "请输入文本", text: this.TextString })
        .width("70%")
        .onChange((value) => {
          this.TextString = value
        })
      Column() {
        Text("输入字符比较").fontSize(18).fontColor("red").margin({ top: 30, bottom: 10 })
      }.alignItems(HorizontalAlign.Start).width('90%').margin({ left: "20%" })

      TextInput({ placeholder: "输入字符比较", text: this.messaged })
        .width("70%")
        .onChange((value) => {
          this.messaged = value
        })
      Button("比较字符串")
        .onClick(() => {
          this.messagevl = `字符串相差${leven(this.TextString, this.messaged)}个`
          setData(this.messagevl)
          this.dialogController.open()
        })
      Column() {
        Text("请输入文本中需要替换的字符").fontSize(18).fontColor("red")
      }.alignItems(HorizontalAlign.Start).width('90%').margin({ left: "20%" })

      TextInput({ placeholder: "请输入文本中需要替换的字符", text: this.ReplaceString })
        .width("70%")
        .margin({ top: 10, bottom: 10 })
        .onChange((value) => {
          this.ReplaceString = value
        })
      Column() {
        Text("请输入替换的字符").fontSize(18).fontColor("red")
      }.alignItems(HorizontalAlign.Start).width('90%').margin({ left: "20%" })

      TextInput({ placeholder: "请输入替换的字符", text: this.StringResults })
        .width("70%")
        .onChange((value) => {
          this.StringResults = value
        })
      Button("简单替换")
        .margin({ top: 10, bottom: 10 })
        .onClick(() => {

          this.Text = er(
            this.TextString,
            {
              leftOutsideNot: "",
              leftOutside: "",
              leftMaybe: "",
              searchFor: this.ReplaceString,
              rightMaybe: "",
              rightOutside: "",
              rightOutsideNot: "",
              i: {
                leftOutsideNot: false,
                leftOutside: false,
                leftMaybe: false,
                searchFor: true,
                rightMaybe: false,
                rightOutside: false,
                rightOutsideNot: false,
              },
            },
            this.StringResults
          );
          setData(this.Text)
          this.dialogController.open()
        })
    }
    .width('100%')
    .height('100%')
  }
}



