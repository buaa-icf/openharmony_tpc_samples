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
import { SmartRefreshForTaurus } from "@ohos/smartrefreshlayout"
import { Taurus } from "@ohos/smartrefreshlayout"
import { TaurusBottomRefresh } from "@ohos/smartrefreshlayout"

class ArrParam {
  index: number = 0;
  name: string = "";
  color: string = "";
}

@Entry
@ComponentV2
struct TaurusSample {
  @Local model: SmartRefreshForTaurus.Model = new SmartRefreshForTaurus.Model()
  private arr: Array<ArrParam> = [
    { index: 11, name: getContext(this).resourceManager.getStringSync($r('app.string.collapse').id), color: '1' },
    { index: 22, name: getContext(this).resourceManager.getStringSync($r('app.string.expand').id), color: '2' },

    {
      index: 44,
      name: getContext(this).resourceManager.getStringSync($r('app.string.red_theme').id),
      color: '#ff4444'
    },
    {
      index: 55,
      name: getContext(this).resourceManager.getStringSync($r('app.string.green_theme').id),
      color: '#99cc00'
    },
    {
      index: 66,
      name: getContext(this).resourceManager.getStringSync($r('app.string.blue_theme').id),
      color: '#2299ee'
    },
    {
      index: 33,
      name: getContext(this).resourceManager.getStringSync($r('app.string.orange_theme').id),
      color: '#ffbb33'
    },
  ]
  private arrNumberOfCycles: Array<number> = [1, 2, 3, 4, 5, 6]

  aboutToAppear() {
    this.model.setBackgroundColor('#ffbb33')
    this.model.setExpand(true)
    this.model.setTitleName(getContext(this).resourceManager.getStringSync($r("app.string.reaching_clouds").id))
  }

  @Builder
  testHeader() {
    Taurus({ model: this.model!! })
  }

  @Builder
  testMain() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start, justifyContent: FlexAlign.Start }) {
      ForEach(this.arr, (itemOther: ArrParam) => {
        Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start, justifyContent: FlexAlign.Start }) {
          Text(itemOther.name)
            .fontSize(30)
            .fontColor('#282828')
            .padding({ left: 10, top: 10 })

          Text(
            itemOther.color == '1' ?
            getContext(this).resourceManager.getStringSync($r('app.string.collapse_description').id) :
              itemOther.color == '2' ?
              getContext(this).resourceManager.getStringSync($r('app.string.expand_description').id) :
              getContext(this).resourceManager.getStringSync($r('app.string.change_color').id, itemOther.name))
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
          if (itemOther.color == '1') {
            this.model.setExpand(false)
          } else if (itemOther.color == '2') {
            this.model.setExpand(true)
          } else {
            this.model.setBackgroundColor(itemOther.color)
          }
        })

      }, (item: ArrParam) => item.index.toString())
      ForEach(this.arrNumberOfCycles, (item: ArrParam) => {

        Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start, justifyContent: FlexAlign.Start }) {
          Text($r('app.string.orange_theme'))
            .fontSize(30)
            .fontColor('#282828')
            .padding({ left: 10, top: 10 })

          Text($r('app.string.change_color_orange'))
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
          this.model.setBackgroundColor('#ffbb33')
        })
      }, (item: number) => item.toString())
    }
    .width("100%")
    .backgroundColor("#ffffff")
  }

  @Builder
  testFooter() {
    Column() {
      TaurusBottomRefresh({ model: this.model!! })
    }.width("100%")
  }

  build() {
    Column() {
      SmartRefreshForTaurus({
        model: this.model!!,
        header: () => {
          this.testHeader()
        },
        main: () => {
          this.testMain()
        },
        footer: () => {
          this.testFooter()
        }
      })
    }.backgroundColor("#dddddd")
  }
}