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
import AMF from 'amf-convert'
import router from '@ohos.router';

export interface TestData {
  any: string,
  you: string
}

export interface TestData2 {
  array: Array<Object>,
  reference: Array<Object>
}

export interface TestData3 {
  nesting: "of objects",
  yeah: boolean,
  ref: Array<number>
}

@Entry
@Component
struct Index {
  @State message: string | ResourceStr = $r("app.string.AMFstringify_and_AMFparse_click_see_display")
  @State message2: string | ResourceStr = $r("app.string.AMFserialize_and_AMFdeserialize_click_see_display")
  @State changedMsg: string | ResourceStr = this.getResourceString($r("app.string.To_be_converted"))
  @State changedMsg2: string | ResourceStr = this.getResourceString($r("app.string.To_be_converted"))
  @State hint1: string | Resource = this.getResourceString($r("app.string.Transformed_data"))
  @State hint2: string | Resource = this.getResourceString($r("app.string.Transformed_data"))
  @State data1: string | Resource = ''
  @State data2: string | Resource = ''

  private getResourceString(res: Resource) {
    return getContext().resourceManager.getStringSync(res.id)
  }

  build() {
    Row() {
      Scroll() {
        Column() {
          Column() {
            Text(`${this.getResourceString($r("app.string.Source_input"))}data = { any: 'data', you: 'like!'};`)
              .width('100%')
              .height(50)
            Text(`${this.getResourceString($r("app.string.After_AMFstringify_and_AMFparse_conversions"))}:${this.changedMsg}`)
              .width('100%')
              .height(100)
            Button(this.message)
              .fontSize(12)
              .fontWeight(FontWeight.Bold)
              .onClick(() => {
                let data: TestData = {
                  any: 'data',
                  you: 'like!'
                };

                let encodedData: Object = AMF.stringify(data);
                let obj = AMF.parse(encodedData);
                let str = JSON.stringify(obj);
                this.changedMsg = str;
                console.log(str);
              }).height(40)
          }.width('100%')
          .height(190)
          .backgroundColor(Color.Orange)


          Column() {
            Text(`${this.getResourceString($r("app.string.Source_input"))}data = {"array": [99, 100, 101,{"nesting": "of objects", "yeah?": true, ref: [1, 2, 3]}],"reference": [1, 2, 3]};`)
              .width('100%')
              .height(70)
            Text(`${this.getResourceString($r("app.string.After_AMFserialize_and_AMFdeserialize_conversions"))}:${this.changedMsg2}`)
              .width('100%')
              .height(140)
            Button(this.message2)
              .fontSize(12)
              .fontWeight(FontWeight.Bold)
              .onClick(() => {
                let dataInner: TestData3 = { nesting: "of objects", yeah: true, ref: [1, 2, 3] }
                let data: TestData2 = {
                  array: [99, 100, 101,
                    dataInner
                  ],
                  reference: [1, 2, 3]
                }

                let encodedData: Object = AMF.serialize(data);
                let obj = AMF.deserialize(encodedData);
                let str = JSON.stringify(obj);
                this.changedMsg2 = str;
                console.log(str);
              }).height(40)
          }.width('100%')
          .height(250)
          .backgroundColor(Color.Orange)


          Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
            Text(this.hint1)

            TextArea({ placeholder: $r("app.string.Enter_any_data") })
              .placeholderColor("rgb(0,0,35)")
              .placeholderFont({
                size: 20,
                weight: 100,
                family: 'cursive',
                style: FontStyle.Italic
              })
              .textAlign(TextAlign.Center)
              .caretColor(Color.Blue)
              .height(40)
              .width(144)
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontFamily("sans-serif")
              .fontStyle(FontStyle.Normal)
              .fontColor(Color.Red)
              .onChange((value: string) => {
                this.data1 = value
              })
            Button($r("app.string.After_filling_data_click_here_view_amf_stringify_parse_data"))
              .onClick(() => {

                let encodedData: Object = AMF.stringify(this.data1 as Object);
                let obj = AMF.parse(encodedData);
                let str = JSON.stringify(obj);
                this.hint1 = this.getResourceString($r("app.string.Transformed_data")) + str;
              })

          }.width('100%')
          .margin({ bottom: 5 })

          Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
            Text(this.hint2)
            TextArea({ placeholder: $r("app.string.Enter_any_data") })
              .placeholderColor("rgb(0,0,35)")
              .placeholderFont({
                size: 20,
                weight: 100,
                family: 'cursive',
                style: FontStyle.Italic
              })
              .textAlign(TextAlign.Center)
              .caretColor(Color.Blue)
              .height(40)
              .width(144)
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontFamily("sans-serif")
              .fontStyle(FontStyle.Normal)
              .fontColor(Color.Red)
              .onChange((value: string) => {
                this.data2 = value
              })
            Button($r("app.string.After_filling_data_click_here_view_AMF_Serialize_deserialize_data"))
              .onClick(() => {
                let encodedData: Object = AMF.serialize(this.data2 as Object);
                let obj = AMF.deserialize(encodedData);
                let str = JSON.stringify(obj);
                this.hint2 = this.getResourceString($r("app.string.Transformed_data")) + str;
              })

          }.width('100%')
          .margin({ bottom: 5 })

          Button($r("app.string.Jump_to_next_page_test_more_types"))
            .onClick(() => {
              router.pushUrl({ url: "pages/Second" })
            })
        }
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
  }
}