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
import { SmartRefreshForStoreHouseSample } from "@ohos/smartrefreshlayout"
import { StoreHouse } from "@ohos/smartrefreshlayout"

@Entry
@ComponentV2
struct StoreHouseSample {
  @Local modelStore: SmartRefreshForStoreHouseSample.Model = new SmartRefreshForStoreHouseSample.Model()
  arr: string[] = [
    getContext(this).resourceManager.getStringSync($r('app.string.display_chinese').id),
    getContext(this).resourceManager.getStringSync($r('app.string.display_english').id),
    getContext(this).resourceManager.getStringSync($r('app.string.display_icon').id),
    getContext(this).resourceManager.getStringSync($r('app.string.display_brand').id),
    getContext(this).resourceManager.getStringSync($r('app.string.display_digit').id),
    getContext(this).resourceManager.getStringSync($r('app.string.blue_theme').id),
    getContext(this).resourceManager.getStringSync($r('app.string.green_theme').id),
    getContext(this).resourceManager.getStringSync($r('app.string.orange_theme').id),
    getContext(this).resourceManager.getStringSync($r('app.string.orange_theme').id),
    getContext(this).resourceManager.getStringSync($r('app.string.orange_theme').id),
    getContext(this).resourceManager.getStringSync($r('app.string.orange_theme').id)
  ]

  @Builder
  testHeader() {
    StoreHouse({ model: this.modelStore!! })
  }

  @Builder
  testMain() {
    Column() {
      ForEach(this.arr, (item: string) => {
        Column() {
          Text(item).fontSize("60lpx")
        }.width("100%").alignItems(HorizontalAlign.Start)
        .height("150lpx").onClick(() => {
          if (this.modelStore.refreshState == SmartRefreshForStoreHouseSample.REFRESHSTATE.REFRESHING) { //松开过后的刷新样式
          } else if (this.modelStore.refreshState ==
          SmartRefreshForStoreHouseSample.REFRESHSTATE.TOREFRESH) { //拖住过程中的样式
          } else {
            if (item == "蓝色主题") {
              this.modelStore.setColor("#0000FF")
            } else if (item == "绿色主题") {
              this.modelStore.setColor("#00785D")
            } else if (item == "橙色主题") {
              this.modelStore.setColor("#FF8000")
            } else {
              this.modelStore.setDemand(item)
            }
          }
        })

        Divider().strokeWidth(2).color(Color.Grey)
      }, (item: string) => item)
    }.width("100%").padding("20lpx").backgroundColor(Color.White)
  }

  build() {
    Column() {
      SmartRefreshForStoreHouseSample({
        modelStoreHouse: this.modelStore!!,
        header: () => {
          this.testHeader()
        },
        main: () => {
          this.testMain()
        },
        footer: () => {
        }
      })
    }.backgroundColor("#ffffff")
  }
}
