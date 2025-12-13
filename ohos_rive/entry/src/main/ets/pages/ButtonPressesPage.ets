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
struct ButtonPressesPage {
  @State myButtonCounter: number = 0;
  private riveButton: RiveAnimationView |null = null;
  private pressAnimation: string = 'press';

  build() {
    Column() {
      TitleBar()

      Row() {
        Text('Simple button.')
          .fontSize(16)
        Text(' Clicks Counter: ')
          .fontSize(16)
        Text(this.myButtonCounter.toString())
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .margin({ top: 20, bottom: 20 })

      RiveAnimationView({
        riveResource: '@rawfile/button.riv',
        onReady: (view) => {
          this.riveButton = view;
        }
      })
        .width('80%')
        .height('15%')
        .margin({ top: 10 })
        .gesture(
          TapGesture()
            .onAction(() => {
              this.performClick();
            })
        )
    }
    .width('100%')
    .height('100%')
  }

  performClick(): void {
    this.myButtonCounter++;
    if(this.riveButton) {
      try {
        this.riveButton.stop();
        if(this.pressAnimation) {
          this.riveButton.play(this.pressAnimation);
        } else {
          this.riveButton.play();
        }
      } catch(error) {
        console.error('Error playing animation:', error);
      }
    }
  }
}