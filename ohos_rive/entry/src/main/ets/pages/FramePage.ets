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
import { TitleBar } from '../common/TitleBar';

@Entry
@Component
struct FramePage {
  @State isAnimShow: boolean = false;
  @State animationView: RiveAnimationView | null = null;

  build() {
    Column() {
      TitleBar({ title: 'FramePage' })

      Column() {
        if (this.isAnimShow) {
          RiveAnimationView({
            riveResource: '@rawfile/basketball.riv',
            riveAutoPlay: true,
            onReady: (view) => {
              console.log(`setBoolean onready`)
              this.animationView = view
            }
          })
            .width('100%')
            .height('50%')
        } else {
          Text('Lorem Ipsum')
        }
      }
      .width('80%')
      .height('80%')
      .margin({ top: 20 })
      .borderRadius(8)

      Button('Swap Fragment')
        .onClick(() => {
          this.isAnimShow = !this.isAnimShow;
        })
    }.height('100%')
    .backgroundColor('#F5F5F5')
    .alignItems(HorizontalAlign.Center)
  }
}