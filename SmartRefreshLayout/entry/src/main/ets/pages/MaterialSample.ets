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
import {SmartRefresh} from "@ohos/smartrefreshlayout"
import {Material} from "@ohos/smartrefreshlayout"
import {MaterialBottom} from "@ohos/smartrefreshlayout"

class ThemeParam{
  index:number = 0;
  name:string = "";
}

@Entry
@ComponentV2
struct MaterialRefreshSample {
  @Local model: SmartRefresh.Model = new SmartRefresh.Model()

  arr: Array<ThemeParam> = [
    {index:0,name: getContext(this).resourceManager.getStringSync($r('app.string.red_theme').id)},
    {index:1,name: getContext(this).resourceManager.getStringSync($r('app.string.green_theme').id)},
    {index:2,name: getContext(this).resourceManager.getStringSync($r('app.string.blue_theme').id)},
    {index:3,name: getContext(this).resourceManager.getStringSync($r('app.string.orange_theme').id)},
    {index:4,name: getContext(this).resourceManager.getStringSync($r('app.string.orange_theme').id)},
    {index:5,name: getContext(this).resourceManager.getStringSync($r('app.string.orange_theme').id)},
    {index:6,name: getContext(this).resourceManager.getStringSync($r('app.string.orange_theme').id)},
    {index:7,name: getContext(this).resourceManager.getStringSync($r('app.string.orange_theme').id)},
    {index:8,name: getContext(this).resourceManager.getStringSync($r('app.string.orange_theme').id)},
    {index:9,name: getContext(this).resourceManager.getStringSync($r('app.string.orange_theme').id)},
    {index:10,name: getContext(this).resourceManager.getStringSync($r('app.string.orange_theme').id)}
  ]

  pickColor(SelectColorParam: string) {
    let SelectColor = SelectColorParam.trim()
    if (SelectColor == this.arr[0].name.trim()) {
      this.model.setAccentColor(Color.Red)
    } else if (SelectColor == this.arr[1].name.trim()) {
      this.model.setAccentColor(Color.Green)
    } else if (SelectColor == this.arr[2].name.trim()) {
      this.model.setAccentColor(Color.Blue)
    } else {
      this.model.setAccentColor(Color.Orange)
    }
  }
  @Builder testHeader() {
    Material({ model: this.model!!})
  }
  @Builder card(item: string) {
    Row() {
      Button(item).onClick(()=> {this.pickColor(item)}).fontSize(40).width("100%").height("100%").backgroundColor("#CCCCCC")
    }
    .width("100%")
    .height("280lpx")
    .margin("10lpx")
    .backgroundColor(Color.White)
    .padding("20lpx")
    .alignItems(VerticalAlign.Top)
    .border({ width: "2lpx", color: "#aaaaaa", style: BorderStyle.Solid })
  }
  @Builder testMain() {
    Column() {
      ForEach(this.arr, (item:ThemeParam) => {
        this.card(item.name)
      }, (item:ThemeParam) => item.index.toString())
    }.width("100%").padding("20lpx")
  }

  @Builder testFooter() {
    Column() {
      MaterialBottom({ model: this.model!!})
    }.width("100%").padding("20lpx")
  }

  build() {
    Column() {
      SmartRefresh({
        model: this.model!!,
        header:()=> {this.testHeader()},
        main:()=> {this.testMain()},
        footer: ()=> {this.testFooter()}  })
    }.backgroundColor("#dddddd")
  }
}
