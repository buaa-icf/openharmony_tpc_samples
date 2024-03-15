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
  @State speedRate: number = 1;

  @Builder
  loadApng() {
    Scroll() {
      Column() {
        apng({
          src: $r('app.media.stack'),
          speedRate: this.speedRate
        })
        apng({
          src: {
            url: 'https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/apng/entry/src/main/resources/base/media/stack.png'
          },
          speedRate: this.speedRate
        })
      }
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
        Button(this.demoType ? (this.textContext = '取消加载') : (this.textContext = '点击加载apng'))
          .margin({ left: '33%', right: '' })
          .onClick(() => {
            this.demoType = !this.demoType
            if (this.demoType) {
              console.log('Time when image loading starts:' + new Date().getTime());
            }
          })
        if (this.demoType) {
          this.loadApng()
        }
        Column() {
          Text('当前速率：' + this.speedRate.toFixed(1))
          Row() {
            Slider({
              value: this.speedRate,
              min: 0.1,
              max: 2,
              step: 0.1,
              style: SliderStyle.OutSet
            })
              .onChange((value: number, model: SliderChangeMode) => {
                this.speedRate = value;
              })
          }
          .width('100%')
          .margin({ top: 10 })
          .justifyContent(FlexAlign.SpaceBetween)
          .visibility((!this.demoType ? Visibility.Visible : Visibility.None))
        }
        .margin({ top: this.demoType ? 0 : '60%' })
      }
    }
    .width('100%')
    .padding({
      left: '16vp',
      right: '16vp'
    })
  }
}