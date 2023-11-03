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
import { BezierRadar } from "@ohos/smartrefreshlayout"

@Entry
@Component
struct BezierRadarSample {
  @State model: SmartRefresh.Model = new SmartRefresh.Model()
  @State bezierRadarModel: BezierRadar.BezierRadarModel = new BezierRadar.BezierRadarModel();
  arr: string[] = ['打开左右拖动', '关闭左右拖动', '内容不偏移', '内容跟随偏移', '蓝色主题', '绿色主题', '红色主题', '橙色主题', '打开左右拖动', '关闭左右拖动', '内容不偏移', '内容跟随偏移', '蓝色主题', '绿色主题', '红色主题', '橙色主题', '内容不偏移', '内容跟随偏移', '蓝色主题', '绿色主题', '红色主题', '橙色主题',]

  @Builder testHeader() {
    BezierRadar({ model: $model, bezierRadarModel: $bezierRadarModel })
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
            if (item == "打开左右拖动") {
              this.bezierRadarModel.setMEnableHorizontalDrag(true)
            } else if (item == "关闭左右拖动") {
              this.bezierRadarModel.setMEnableHorizontalDrag(false)
            } else if (item == "内容不偏移") {
              //this.model.setFixedContent(false)
            } else if (item == "内容跟随偏移") {
              //this.model.setFixedContent(true)
            } else if (item == "蓝色主题") {
              this.bezierRadarModel.setMPrimaryColor("#0000FF")
              this.bezierRadarModel.setMRadarFillColor("#ADD8E6")
            } else if (item == "绿色主题") {
              this.bezierRadarModel.setMPrimaryColor("#00785D")
              this.bezierRadarModel.setMRadarFillColor("#90EE90")
            } else if (item == "红色主题") {
              this.bezierRadarModel.setMPrimaryColor("#FF0000")
              this.bezierRadarModel.setMRadarFillColor("#FFB6C1")
            } else if (item == "橙色主题") {
              this.bezierRadarModel.setMPrimaryColor("#FF8000")
              this.bezierRadarModel.setMRadarFillColor("#F5DEB3")
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
