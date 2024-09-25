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
import { SmartRefreshForDeliverySample } from "@ohos/smartrefreshlayout"

class arrParam {
  index: number = 0;
  content: string = "";
}

class ThemeParam {
  text: string = "";
  label: string = "";
  boxColor: number[] = [];
  backgroundColor: number = 0;
}

@Entry
@ComponentV2
struct DeliverySample {
  theme: ThemeParam[] = [
    {
      text: getContext(this).resourceManager.getStringSync($r('app.string.default_theme_color').id),
      label: getContext(this).resourceManager.getStringSync($r('app.string.change_color_default').id),
      boxColor: [0xff4169E1, 0xff6ea9ff],
      backgroundColor: 0xff283645
    },
    {
      text: getContext(this).resourceManager.getStringSync($r('app.string.orange_theme_color').id),
      label: getContext(this).resourceManager.getStringSync($r('app.string.change_color_orange').id),
      boxColor: [0xffffe4b5, 0xfffffafa],
      backgroundColor: 0xffffbb33
    },
    {
      text: getContext(this).resourceManager.getStringSync($r('app.string.red_theme_color').id),
      label: getContext(this).resourceManager.getStringSync($r('app.string.change_color_red').id),
      boxColor: [0xfff08080, 0xfffffafa],
      backgroundColor: 0xffff4444
    },
    {
      text: getContext(this).resourceManager.getStringSync($r('app.string.green_theme_color').id),
      label: getContext(this).resourceManager.getStringSync($r('app.string.change_color_green').id),
      boxColor: [0xff90ee90, 0xfffffafa],
      backgroundColor: 0xff99cc00
    },
    {
      text: getContext(this).resourceManager.getStringSync($r('app.string.blue_theme_color').id),
      label: getContext(this).resourceManager.getStringSync($r('app.string.change_color_blue').id),
      boxColor: [0xffafeeee, 0xfffffafa],
      backgroundColor: 0xff33aaff
    },
    {
      text: getContext(this).resourceManager.getStringSync($r('app.string.blue_theme_color').id),
      label: getContext(this).resourceManager.getStringSync($r('app.string.change_color_blue').id),
      boxColor: [0xffafeeee, 0xfffffafa],
      backgroundColor: 0xff33aaff
    },
    {
      text: getContext(this).resourceManager.getStringSync($r('app.string.blue_theme_color').id),
      label: getContext(this).resourceManager.getStringSync($r('app.string.change_color_blue').id),
      boxColor: [0xffafeeee, 0xfffffafa],
      backgroundColor: 0xff33aaff
    },
    {
      text: getContext(this).resourceManager.getStringSync($r('app.string.blue_theme_color').id),
      label: getContext(this).resourceManager.getStringSync($r('app.string.change_color_blue').id),
      boxColor: [0xffafeeee, 0xfffffafa],
      backgroundColor: 0xff33aaff
    },
    {
      text: getContext(this).resourceManager.getStringSync($r('app.string.blue_theme_color').id),
      label: getContext(this).resourceManager.getStringSync($r('app.string.change_color_blue').id),
      boxColor: [0xffafeeee, 0xfffffafa],
      backgroundColor: 0xff33aaff
    },
    {
      text: getContext(this).resourceManager.getStringSync($r('app.string.blue_theme_color').id),
      label: getContext(this).resourceManager.getStringSync($r('app.string.change_color_blue').id),
      boxColor: [0xffafeeee, 0xfffffafa],
      backgroundColor: 0xff33aaff
    },
  ]
  @Local modelDelivery: SmartRefreshForDeliverySample.Model =
    new SmartRefreshForDeliverySample.Model().setZMainIndex(999)
  arr: arrParam[] =
    [
      { index: 2, content: getContext(this).resourceManager.getStringSync($r('app.string.default_theme').id) },
      { index: 3, content: getContext(this).resourceManager.getStringSync($r('app.string.orange_theme').id) },
      { index: 4, content: getContext(this).resourceManager.getStringSync($r('app.string.red_theme').id) },
      { index: 5, content: getContext(this).resourceManager.getStringSync($r('app.string.green_theme').id) },
      { index: 6, content: getContext(this).resourceManager.getStringSync($r('app.string.blue_theme').id) },
      { index: 7, content: getContext(this).resourceManager.getStringSync($r('app.string.blue_theme').id) },
      { index: 8, content: getContext(this).resourceManager.getStringSync($r('app.string.blue_theme').id) },
      { index: 9, content: getContext(this).resourceManager.getStringSync($r('app.string.blue_theme').id) }
    ]

  @Builder
  deliveryHeader() {
    Delivery({ model: this.modelDelivery!! })
  }

  @Builder
  card(index: number) {
    Row() {
      Flex() {
      }.backgroundColor(this.theme[index%this.theme.length].backgroundColor).height("240lpx").width("240lpx")

      Column() {
        Text(this.theme[index%this.theme.length].text + "").fontSize(30)
        Text(this.theme[index%this.theme.length].label + "").fontSize(20).fontColor(Color.Gray)
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
      this.modelDelivery.setBackgroundShadowColor(this.theme[index%this.theme.length].backgroundColor)
    })
  }

  @Builder
  deliveryMain() {
    Column() {
      ForEach(this.arr, (item: arrParam) => {
        this.card(item.index)
      }, (item: arrParam) => item.index.toString())
    }.width("100%").padding("20lpx")
  }

  @Builder
  deliveryFooter() {
    Column() {
      Delivery({ model: this.modelDelivery!! })
    }.width("100%").padding("20lpx")
  }

  aboutToAppear() {
    this.modelDelivery.backgroundColor = "#dddddd"
  }

  build() {
    Column() {
      SmartRefreshForDeliverySample({
        modelDelivery: this.modelDelivery!!,
        header: () => {
          this.deliveryHeader()
        },
        main: () => {
          this.deliveryMain()
        },
        footer: () => {
        }
      })
    }.backgroundColor("#dddddd")
  }
}
