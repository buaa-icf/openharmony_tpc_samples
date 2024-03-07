/*
 * Copyright (C) 2024 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import { apng } from '@ohos/apng';

@Entry
@Component
struct Index {
  @State demoType: boolean = false;
  @State textContext: string = '';

  @Builder
  loadApng(){
    Scroll(){
      apng({
        src: $r('app.media.stack'),
        speedRate: 1
      })
    }
  }

  build() {
    Flex({
      direction: FlexDirection.Column,
      alignContent: FlexAlign.Center
    }) {
      Row() {
        Text('APNG 组件')
          .fontSize('18vp')
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Center)
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .flexBasis('100vp')

      Flex({
        direction: FlexDirection.Column,
        alignItems: ItemAlign.Center
      }) {
       Button(this.demoType ? (this.textContext = '取消加载') :(this.textContext = '点击加载apng'))
         .margin({left:'33%', right:''})
         .onClick(() => {
           this.demoType = !this.demoType
         })
        if(this.demoType){
           this.loadApng()
        }
      }
    }
    .width('100%')
    .padding({
      left: '16vp',
      right: '16vp'
    })
  }
}