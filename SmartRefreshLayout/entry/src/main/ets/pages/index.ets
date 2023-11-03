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

import router from '@system.router'

@Entry
@Component
struct Index {
  scroller: Scroller = new Scroller()
  private refreshTypeMap: Array<any> = [
    { name: "Classics", url: "pages/ClassicsSample" },
    { name: "WaterSwipe", url: "pages/WaterSwipeSample" },
    { name: "BezierCircle", url: "pages/BezierCircleSample" },
    { name: "Material", url: "pages/MaterialSample" },
    { name: "WaveSwipe", url: "pages/WaveSwipeSample" },
    { name: "BezierRadar", url: "pages/BezierRadarSample" },
    { name: "StoreHouse", url: "pages/StoreHouseSample" },
    { name: "Delivery", url: "pages/DeliverySample" },
    { name: "DropBox", url: "pages/DropBoxSample" },
    { name: "FlyRefreshHeader", url: "pages/FlyRefreshStylePage" },
    { name: "BattleCity", url: "pages/BattleCitySample" },
    { name: "HitBlock", url: "pages/HitBlockSample" },
    { name: "Phoenix", url: "pages/PhoenixSample" },
    { name: "Taurus", url: "pages/TaurusSample" },
  ]
  private index: number = 0
  build() {
    Stack() {
      Scroll(this.scroller) {
        Column({ space: 20 }) {
          ForEach(this.refreshTypeMap, item => {
            Text(item.name)
              .height(50)
              .fontSize(40)
              .fontColor(Color.Black)
              .backgroundColor(Color.Gray)
              .width("100%")
              .textAlign(TextAlign.Center)
              .onClick(() => {
                router.push({ uri: item.url,
                  params: {} })
              })
          }, item => item.toString())
        }
      }
    }
  }
}