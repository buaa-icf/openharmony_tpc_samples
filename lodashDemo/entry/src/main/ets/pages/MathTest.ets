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

import { add, ceil, meanBy } from "lodash";

@Entry
@Component
struct Index {
  private sampleObjects = [{ 'n': 4 }, { 'n': 2 }, { 'n': 8 }, { 'n': 6 }];
  @State augend: number = 0
  @State addend: number = 0
  @State ceilNumber: number = 0
  @State precision: number = 0
  @State mean: number = 0

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {

      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Text("设置加数和被加数，只支持number：")
      TextArea({ placeholder: '加数输入' })
        .placeholderColor("rgb(0,0,35)")
        .placeholderFont({ size: 20, weight: 100, family: 'cursive', style: FontStyle.Italic })
        .textAlign(TextAlign.Center)
        .caretColor(Color.Blue)
        .height(40)
        .width(144)
        .margin(5)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontFamily("sans-serif")
        .fontStyle(FontStyle.Normal)
        .fontColor(Color.Red)
        .onChange((value: string) => {
          try {
            this.augend = parseFloat(value);
          } catch (e) {
            console.log('e.msg=' + e.meesage)
          }
        })

      TextArea({ placeholder: '被加数输入' })
        .placeholderColor("rgb(0,0,180)")
        .placeholderFont({ size: 20, weight: 100, family: 'cursive', style: FontStyle.Italic })
        .textAlign(TextAlign.Center)
        .caretColor(Color.Blue)
        .height(40)
        .width(145)
        .margin(5)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontFamily("sans-serif")
        .fontStyle(FontStyle.Normal)
        .fontColor(Color.Red)
        .onChange((value: string) => {
          try {
            this.addend = parseFloat(value);
          } catch (e) {
            console.log('e.msg=' + e.meesage)
          }
        })
        Button('设置好加数和被加数后，点击进行运算')
          .onClick(() => {
            let additionCount = add(this.augend, this.addend);
            console.log('additionCount:' + additionCount)
          })
      }.width('100%')
       .margin(5)

      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
        Text("设置四舍五入的数字和精度，只支持number：")
        TextArea({ placeholder: '数字输入' })
          .placeholderColor("rgb(0,0,35)")
          .placeholderFont({ size: 20, weight: 100, family: 'cursive', style: FontStyle.Italic })
          .textAlign(TextAlign.Center)
          .caretColor(Color.Blue)
          .height(40)
          .width(144)
          .margin(5)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontFamily("sans-serif")
          .fontStyle(FontStyle.Normal)
          .fontColor(Color.Red)
          .onChange((value: string) => {
            try {
              this.ceilNumber = parseFloat(value);
            } catch (e) {
              console.log('e.msg=' + e.meesage)
            }
          })

        TextArea({ placeholder: '精度输入' })
          .placeholderColor("rgb(0,0,180)")
          .placeholderFont({ size: 20, weight: 100, family: 'cursive', style: FontStyle.Italic })
          .textAlign(TextAlign.Center)
          .caretColor(Color.Blue)
          .height(40)
          .width(145)
          .margin(5)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontFamily("sans-serif")
          .fontStyle(FontStyle.Normal)
          .fontColor(Color.Red)
          .onChange((value: string) => {
            try {
              this.precision = parseFloat(value);
            } catch (e) {
              console.log('e.msg=' + e.meesage)
            }
          })
        Button('设置四舍五入的数字后，点击进行运算')
          .onClick(() => {
            let ceilCount = ceil(this.ceilNumber, this.precision);
            console.log('ceil number:' + ceilCount)
          })
      }.width('100%')
       .margin(5)

      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
        Text("数组平均值：" + this.mean)
        Button('点击求数组平均值')
          .onClick(() => {
            this.mean = meanBy(this.sampleObjects, ({ n }) => n)
            console.log('mean:' + this.mean)
          })
      }.width('100%')
      .margin(5)
    }
    .width('100%')
    .height('100%')
  }
}
