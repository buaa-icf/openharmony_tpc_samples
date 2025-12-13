/*
 * Copyright (C) 2025 Huawei Device Co., Ltd.
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

import { RiveAnimationView } from '@ohos/rive';

@Entry
@Component
struct TouchPassthroughPage {
  @State count: number = 0;
  @State isOn: string = 'Off';
  @State passThrough: boolean = false;

  build() {
    Column() {

      Text('Touch pass-through:' + this.isOn)
        .fontSize(15)
        .textAlign(TextAlign.Center)
        .position({ x: '5%', y: '5%' })
        .zIndex(99)

      Toggle({ type: ToggleType.Switch, isOn: false })
        .selectedColor('#007DFF')
        .switchPointColor('#FFFFFF')
        .onChange((isOn: boolean) => {
          if (isOn) {
            this.isOn = 'On';
            this.passThrough = true;
          } else {
            this.isOn = 'Off';
            this.passThrough = false;
          }
        })
        .width('15%')
        .position({ x: '5%', y: '9%' })
        .height(25)
        .zIndex(99)

      Button('Click Count:' + this.count)
        .onClick(() => {
          if (this.isOn === 'On') {
            this.count = this.count + 1;
          }
        })
        .backgroundColor('#FF9370DB')
        .controlSize(ControlSize.NORMAL)
        .width(180)
        .position({ x: '30%', y: '50%' })
        .zIndex(99)

      RiveAnimationView({
        riveResource: '@rawfile/touchpassthrough.riv',
        riveFit: 'fill',
        touchPassThrough: this.passThrough
      })
        .width('100%')
        .height('100%')
    }
  }
}