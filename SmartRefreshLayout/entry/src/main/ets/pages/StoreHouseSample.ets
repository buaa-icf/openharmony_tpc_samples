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
import { SmartRefresh } from "@ohos/smartrefreshlayout"
import { StoreHouse } from "@ohos/smartrefreshlayout"

@Entry
@Component
struct StoreHouseSample {
  @State model: SmartRefresh.Model = new SmartRefresh.Model()
  arr: string[] = ['显示中文', '显示英文', '显示图标', '显示商标', '显示数字', '蓝色主题', '绿色主题', '红色主题', '橙色主题', '显示中文', '显示英文', '显示图标', '显示商标', '显示数字', '蓝色主题', '绿色主题', '红色主题', '橙色主题',]
  @State storeHouseModel: StoreHouse.StoreHouseModel = new StoreHouse.StoreHouseModel();

  @Builder testHeader() {
    StoreHouse({ model: $model, storeHouseModel: $storeHouseModel })
  }

  @Builder testMain() {
    Column() {
      ForEach(this.arr, (item) => {
        Column() {
          Text(item).fontSize("60lpx")
        }.width("100%").alignItems(HorizontalAlign.Start)
        .height("150lpx").onClick(() => {
          if (this.model.refreshState == SmartRefresh.REFRESHSTATE.REFRESHING) { //松开过后的刷新样式
          } else if (this.model.refreshState == SmartRefresh.REFRESHSTATE.TOREFRESH) { //拖住过程中的样式
          } else {
            if (item == "显示中文") {
              this.storeHouseModel.setDemand("C")
              this.storeHouseModel.setMargin(25)
              this.storeHouseModel.setScale(4)
              this.storeHouseModel.change()
            } else if (item == "显示英文") {
              this.storeHouseModel.setDemand("E")
              this.storeHouseModel.setEnglish("StoreHouse")
              this.storeHouseModel.setMargin(35)
              this.storeHouseModel.setScale(1.5)
              this.storeHouseModel.change()
            } else if (item == "显示图标") {
              this.storeHouseModel.setDemand("I")
              this.storeHouseModel.setMargin(15)
              this.storeHouseModel.setScale(7)
              this.storeHouseModel.change()
            } else if (item == "显示商标") {
              this.storeHouseModel.setDemand("T")
              this.storeHouseModel.setMargin(33)
              this.storeHouseModel.setScale(4)
              this.storeHouseModel.change()
            } else if (item == "显示数字") {
              this.storeHouseModel.setDemand("N")
              this.storeHouseModel.setNumber(3.1415926)
              this.storeHouseModel.setMargin(33)
              this.storeHouseModel.setScale(1.5)
              this.storeHouseModel.change()
            } else if (item == "蓝色主题") {
              this.storeHouseModel.setColor("#0000FF")
            } else if (item == "绿色主题") {
              this.storeHouseModel.setColor("#00785D")
            } else if (item == "红色主题") {
              this.storeHouseModel.setColor("#FF0000")
            } else if (item == "橙色主题") {
              this.storeHouseModel.setColor("#FF8000")
            }
          }

        })

        Divider().strokeWidth(2).color(Color.Grey)
      }, item => item)
    }.width("100%").padding("20lpx").backgroundColor(Color.White)
  }

  build() {
    Column() {
      SmartRefresh({ model: $model, header: () => {
        this.testHeader()
      }, main: () => {
        this.testMain()
      } })
    }.backgroundColor("#ffffff")
  }
}
