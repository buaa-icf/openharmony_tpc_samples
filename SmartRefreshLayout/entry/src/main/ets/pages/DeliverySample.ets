/*
 * Copyright (C) 2022 Huawei Device Co., Ltd.
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
import { Delivery } from "@ohos/smartrefreshlayout"
import { SmartRefresh } from "@ohos/smartrefreshlayout"

@Entry
@Component
struct DeliverySample {
  theme = [
    { text: "默认主题颜色", label: "更改为默认主题颜色", boxColor: [0xff4169E1, 0xff6ea9ff], backgroundColor: 0xff283645 },
    { text: "橙色主题颜色", label: "更改为橙色主题颜色", boxColor: [0xffffe4b5, 0xfffffafa], backgroundColor: 0xffffbb33 },
    { text: "红色主题颜色", label: "更改为红色主题颜色", boxColor: [0xfff08080, 0xfffffafa], backgroundColor: 0xffff4444 },
    { text: "绿色主题颜色", label: "更改为绿色主题颜色", boxColor: [0xff90ee90, 0xfffffafa], backgroundColor: 0xff99cc00 },
    { text: "蓝色主题颜色", label: "更改为蓝色主题颜色", boxColor: [0xffafeeee, 0xfffffafa], backgroundColor: 0xff33aaff },
    { text: "橙色主题颜色", label: "更改为橙色主题颜色", boxColor: [0xffffe4b5, 0xfffffafa], backgroundColor: 0xffffbb33 },
    { text: "红色主题颜色", label: "更改为红色主题颜色", boxColor: [0xfff08080, 0xfffffafa], backgroundColor: 0xffff4444 },
    { text: "绿色主题颜色", label: "更改为绿色主题颜色", boxColor: [0xff90ee90, 0xfffffafa], backgroundColor: 0xff99cc00 },
    { text: "蓝色主题颜色", label: "更改为蓝色主题颜色", boxColor: [0xffafeeee, 0xfffffafa], backgroundColor: 0xff33aaff }
  ]
  @State model: SmartRefresh.Model = new SmartRefresh.Model().setZMainIndex(999)
  arr: string[] = ['内容不偏移', '内容跟随偏移', '默认主题', '橙色主题', '红色主题', '绿色主题', '蓝色主题', '蓝色主题', '蓝色主题', '蓝色主题']

  @Builder deliveryHeader() {
    Delivery({ model: $model })
  }

  @Builder card(index) {
    Row() {
      Flex() {
      }.backgroundColor("#dddddd").height("240lpx").width("240lpx")

      Column() {
        Flex().width("370lpx").height("25lpx").backgroundColor("#dddddd").margin({ top: "10lpx", bottom: "70lpx" })
        Flex().width("200lpx").height("25lpx").backgroundColor("#dddddd").margin({ bottom: "30lpx" })
        Flex().width("200lpx").height("25lpx").backgroundColor("#dddddd").margin({ bottom: "30lpx" })
      }.alignItems(HorizontalAlign.Start).margin("10lpx")
    }
    .width("100%")
    .height("280lpx")
    .margin("10lpx")
    .backgroundColor(Color.White)
    .padding("20lpx")
    .alignItems(VerticalAlign.Top)
    .border({ width: "2lpx", color: "#aaaaaa", style: BorderStyle.Solid })
    .onClick(() => {
      this.model.setBackgroundShadowColor(this.theme[index%this.theme.length].backgroundColor)
    })
  }

  @Builder deliveryMain() {
    Column() {
      ForEach(this.arr, (item, index) => {
        this.card(index)
      }, item => item)
    }.width("100%").padding("20lpx")
  }

  @Builder deliveryFooter() {
    Column() {
      Delivery({ model: $model })
    }.width("100%").padding("20lpx")
  }

  aboutToAppear() {
    this.model.backgroundColor = "#dddddd"
  }

  build() {
    Column() {
      SmartRefresh({ model: $model,
        header: () => {
          this.deliveryHeader()
        }, main: () => {
          this.deliveryMain()
        }, footer: () => {
          //this.deliveryFooter()
        } })
    }.backgroundColor("#dddddd")
  }
}
