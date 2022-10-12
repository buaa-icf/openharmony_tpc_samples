/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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
import router from '@ohos.router';

function routerfun(url) {
  let options = {
    url: url
  }
  router.push(options)
}

@Entry
@Component
struct Index {
  scroller: Scroller = new Scroller()
  @State touchableBool: boolean = true
  @State message: string = 'mathjs test'
  @State crcalc: string = 'crcalc test'
  @State ejmlMatrix: string = 'ejmlMatrix test'
  @State ejmlMathjs: string = 'ejmlMathjs test'
  @State jafama: string = 'jafama test'

  build() {
    Scroll(this.scroller) {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)

        Text(this.crcalc)
          .fontSize(16)
          .padding(8)
          .margin({ top: 32 })
          .fontWeight(FontWeight.Bold)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            routerfun('crcalc/crcalc')
            this.touchableBool = false
            setTimeout(() => {
              this.touchableBool = true;
            }, 3000);
          })
          .touchable(this.touchableBool)

        Text(this.ejmlMatrix)
          .fontSize(16)
          .padding(8)
          .margin({ top: 32 })
          .fontWeight(FontWeight.Bold)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            routerfun('ejml/ejml')
            this.touchableBool = false
            setTimeout(() => {
              this.touchableBool = true;
            }, 3000);
          })
          .touchable(this.touchableBool)

        Text(this.ejmlMathjs)
          .fontSize(20)
          .padding(8)
          .margin({ top: 32 })
          .fontWeight(FontWeight.Bold)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            routerfun('ejml/ejmlMathjs')
            this.touchableBool = false
            setTimeout(() => {
              this.touchableBool = true;
            }, 3000);
          })
          .touchable(this.touchableBool)

        Text(this.jafama)
          .fontSize(16)
          .padding(8)
          .margin({ top: 32 })
          .fontWeight(FontWeight.Bold)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            routerfun('jafama/jafama')
            this.touchableBool = false
            setTimeout(() => {
              this.touchableBool = true;
            }, 3000);
          })
          .touchable(this.touchableBool)

        Text(this.message)
          .touchable(this.touchableBool)
          .fontSize(16)
          .padding(8)
          .margin({ top: 32 })
          .fontWeight(FontWeight.Bold)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            routerfun('mathjs/mathjs')
            this.touchableBool = false
            setTimeout(() => {
              this.touchableBool = true;
            }, 3000);
          })


      }
      .width('100%')
    }
    .scrollable(ScrollDirection.Vertical)
    .scrollBar(BarState.On)
    .scrollBarColor(Color.Gray)
    .scrollBarWidth(30)
    .onScroll((xOffset: number, yOffset: number) => {
      console.info(xOffset + ' ' + yOffset)
    })
    .onScrollEdge((side: Edge) => {
      console.info('To the edge')
    })
    .onScrollEnd(() => {
      console.info('Scroll Stop')
    })
  }
}