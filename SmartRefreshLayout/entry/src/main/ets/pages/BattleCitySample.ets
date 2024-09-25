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

import { SmartRefreshForGame } from "@ohos/smartrefreshlayout"
import { BattleCity } from "@ohos/smartrefreshlayout"

class ThemeParam {
  color: string = "";
  name: string = "";
  index: number = 0;
}

@Entry
@ComponentV2
struct BattleCitySample {
  arr: Array<ThemeParam> = [
    {
      index: 1,
      name: getContext(this).resourceManager.getStringSync($r('app.string.default_theme').id),
      color: '#ffffff'
    },
    {
      index: 2,
      name: getContext(this).resourceManager.getStringSync($r('app.string.blue_theme').id),
      color: '#2299ee'
    },
    {
      index: 3,
      name: getContext(this).resourceManager.getStringSync($r('app.string.green_theme').id),
      color: '#99cc00'
    },
    { index: 4, name: getContext(this).resourceManager.getStringSync($r('app.string.red_theme').id), color: '#ff4444' },
    {
      index: 5,
      name: getContext(this).resourceManager.getStringSync($r('app.string.orange_theme').id),
      color: '#ffbb33'
    },
    {
      index: 6,
      name: getContext(this).resourceManager.getStringSync($r('app.string.orange_theme').id),
      color: '#ffbb33'
    },
    {
      index: 7,
      name: getContext(this).resourceManager.getStringSync($r('app.string.orange_theme').id),
      color: '#ffbb33'
    },
    {
      index: 8,
      name: getContext(this).resourceManager.getStringSync($r('app.string.orange_theme').id),
      color: '#ffbb33'
    },
    {
      index: 9,
      name: getContext(this).resourceManager.getStringSync($r('app.string.orange_theme').id),
      color: '#ffbb33'
    },
    {
      index: 10,
      name: getContext(this).resourceManager.getStringSync($r('app.string.orange_theme').id),
      color: '#ffbb33'
    },
    {
      index: 11,
      name: getContext(this).resourceManager.getStringSync($r('app.string.orange_theme').id),
      color: '#ffbb33'
    },
  ]
  @Local model: SmartRefreshForGame.Model = new SmartRefreshForGame.Model()

  public aboutToAppear() {
    this.model.setBackgroundColor('#ffffff')
  }

  @Builder
  testHeader() {
    BattleCity({ model: this.model!! })
  }

  @Builder
  testMain() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start, justifyContent: FlexAlign.Start }) {
      ForEach(this.arr, (itemOther: ThemeParam) => {
        Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start, justifyContent: FlexAlign.Start }) {
          Text(itemOther.name)
            .fontSize(30)
            .fontColor('#282828')
            .padding({ left: 10, top: 10 })

          Text(getContext(this).resourceManager.getStringSync($r('app.string.change_color').id, itemOther.name))
            .fontSize(25)
            .fontColor('#8c8c8c')
            .padding({ left: 10, top: 5 })

          Text('')
            .backgroundColor('#ececec')
            .height(0.5)
            .width('100%')
            .margin({ top: 10, bottom: 5 })
        }
        .onClick(e => {
          this.model.setBackgroundColor(itemOther.color)
          this.model.autoRefresh()
        })
      }, (item: ThemeParam) => item.index.toString())
    }
    .width("100%")
    .backgroundColor("#ffffff")
  }

  build() {
    Column() {
      SmartRefreshForGame({
        modelGame: this.model!!,
        header: () => {
          this.testHeader()
        },
        main: () => {
          this.testMain()
        },
        footer: () => {
        }
      })
    }
  }
}
