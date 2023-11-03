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
import {HitBlock} from "@ohos/smartrefreshlayout"

@Entry
@Component
struct HitBlockSample {
  private arr: Array<any> = [
    { name: '默认主题', color: '#ffffff' },
    { name: '橙色主题', color: '#ffbb33' },
    { name: '红色主题', color: '#ff4444' },
    { name: '绿色主题', color: '#99cc00' },
    { name: '蓝色主题', color: '#2299ee' },
  ]
  @State model: SmartRefreshForGame.Model = new SmartRefreshForGame.Model()
  private isClick: boolean = false

  public aboutToAppear() {
    this.model.setBackgroundColor('#ffffff')
    this.model.setRefreshCallback(() => {
      if (!this.isClick) {
        this.isClick = true
        setTimeout(() => {
          this.isClick = false
          this.model.finishRefresh(true)
        }, 3000)
      }
    })
    setTimeout(() => {
      this.model.autoRefresh()
    }, 100)
  }

  @Builder testHeader() {
    HitBlock({ model: this.model })
  }

  @Builder testMain() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start, justifyContent: FlexAlign.Start }) {
      ForEach(this.arr, (item) => {
        ForEach(this.arr, (item2) => {
          Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start, justifyContent: FlexAlign.Start }) {
            Text(item2.name)
              .fontSize(30)
              .fontColor('#282828')
              .padding({ left: 10, top: 10 })

            Text('更改为' + item2.name + '颜色')
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
            this.model.setBackgroundColor(item2.color)
            this.model.autoRefresh()
          })

        }, item => item.toString())
      }, item => item.toString())
    }
    .width("100%")
    .backgroundColor("#ffffff")
  }

  build() {
    Column() {
      SmartRefreshForGame({
        model: this.model,
        header: () => {
          this.testHeader()
        },
        main: () => {
          this.testMain()
        }
      })
    }
  }
}