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
import { setData, CustomDialogExample } from './loding'
import router from '@system.router';
interface T {
  data:string|string[]
}
@Entry
@Component
struct Index {
  @State TextString: string = this.getResourceString($r('app.string.A_horse_i'))
  @State Replace: string= "i"
  @State StringResults: string = "x"
  @State Text: string= ""
  @State leftMy: T= { data:[this.getResourceString($r('app.string.horse')), this.getResourceString($r('app.string.heart'))]}
  @State rightMy: T = {data:[this.getResourceString($r('app.string.horse')), this.getResourceString($r('app.string.heart'))]}
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogExample({}),
    autoCancel: true
  });
  getResourceString(res: Resource) {
    return getContext().resourceManager.getStringSync(res.id)
  }
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

      TextInput({ placeholder: $r('app.string.Please_enter_text'), text: this.TextString })
        .width("70%")
        .onChange((value) => {
          this.TextString = value
        })
      Column() {
        Text($r('app.string.Input_to_array')).fontSize(18).fontColor("red")
      }.alignItems(HorizontalAlign.Start).width('90%').margin({ left: "20%" })

      TextInput({ placeholder: $r('app.string.Please_enter_text'), text: this.leftMy.data + "" })
        .width("70%")
        .onChange((value) => {
          this.leftMy = {
            data:value
          }
        })
      Column() {
        Text($r('app.string.right_side')).fontSize(18).fontColor("red")
      }.alignItems(HorizontalAlign.Start).width('90%').margin({ left: "20%" })

      TextInput({ placeholder: $r('app.string.Please_enter_text'), text: this.rightMy.data + "" })
        .width("70%")
        .onChange((value) => {
          this.rightMy = {
            data:value
          }
        })
      Column() {
        Text($r('app.string.Please_enter_the_characters')).fontSize(18).fontColor("red")
      }.alignItems(HorizontalAlign.Start).width('90%').margin({ left: "20%" })

      TextInput({ placeholder: $r('app.string.Please_enter_the_characters'), text: this.Replace + "" })
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
          let dataArrFunc = (str:string)=>{
            let dataArr:string[] = []
            for(let i =0;i<str.length;i++){
              dataArr.push(str.charAt(i))
            }
            return dataArr
          }
          this.Text = er(
            this.TextString,
            {
              leftOutsideNot: "",
              leftOutside: "",
              leftMaybe: dataArrFunc(this.leftMy.data as string), //["马","心"]
              searchFor: this.Replace,
              rightMaybe: dataArrFunc(this.rightMy.data as string), //["马","心"]
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
