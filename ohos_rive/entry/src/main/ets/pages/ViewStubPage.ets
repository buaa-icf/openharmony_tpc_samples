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

import {ControllerState, Loop, RiveAnimationView } from '@ohos/rive';
import { TitleBar } from '../common/TitleBar';

@Entry
@Component
struct ViewStubPage {
  @State showRiveContainer: boolean = false;
  @State animationView: RiveAnimationView | null = null;
  @State state: ControllerState | null = null;

  build() {
    Column() {
      TitleBar()
      Row() {
        Button('Show Animation')
          .onClick(() => {
            this.showRiveContainer = true;
          })
          .margin({ right: 20 })

        Button('Hide Animation')
          .onClick(() => {
            this.showRiveContainer = false;
          })
      }
      .width('100%')
      .padding(20)
      .justifyContent(FlexAlign.Center)

      if (this.showRiveContainer) {
        Column() {
          RiveAnimationView({
            riveResource: '@rawfile/tom_morello.riv',
            riveStateMachine: 'State Machine 1',
            riveAutoPlay: true,
            onReady: (view) => {
              this.animationView = view
            }
          })
            .width('100%')
            .height(400)
        }
        .width('80%')
        .onAppear(() => {
          if (!this.state) {
            this.animationView?.play('State Machine 1', Loop.AUTO, undefined, true, false);
            this.animationView?.setBooleanState('State Machine 1', 'Rage', true);
            this.state = this.animationView?.controller?.saveControllerState() as ControllerState;
          } else {
            this.animationView?.controller?.restoreControllerState(this.state);
          }

        })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}