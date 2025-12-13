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
struct NestedTextRunsPage {
  @State riveView:RiveAnimationView |null = null;

  onButtonClick(buttonId: string) {
    try {
      switch (buttonId) {
        case 'set_b1':
          this.riveView?.setTextRunValue('ArtboardBRun', 'ArtboardB-1 Updated', 'ArtboardB-1');
          break;
        case 'set_b2':
         this.riveView?.setTextRunValue('ArtboardBRun', 'ArtboardB-2 Updated', 'ArtboardB-2');
          break;
        case 'set_b1_c1':
         this.riveView?.setTextRunValue('ArtboardCRun', 'ArtboardB-1/C-1 Updated', 'ArtboardB-1/ArtboardC-1');
          break;
        case 'set_b1_c2':
         this.riveView?.setTextRunValue('ArtboardCRun', 'ArtboardB-1/C-2 Updated', 'ArtboardB-1/ArtboardC-2');
          break;
        case 'set_b2_c1':
         this.riveView?.setTextRunValue('ArtboardCRun', 'ArtboardB-2/C-1 Updated', 'ArtboardB-2/ArtboardC-1');
          break;
        case 'set_b2_c2':
         this.riveView?.setTextRunValue('ArtboardCRun', 'ArtboardB-2/C-2 Updated', 'ArtboardB-2/ArtboardC-2');
          break;
        default:
          console.log('Unknown button ID:', buttonId);
      }
    } catch (error) {
      console.error('Error setting input state:', error);
    }
  }

  build() {
    Column({ space: 10 }) {
      RiveAnimationView({
        riveResource: '@rawfile/runtime_nested_text_runs.riv',
        riveArtboard: 'ArtboardA',
        riveStateMachine: 'State Machine 1',
        onReady: (view) => {
          this.riveView = view;
        }
      })
        .width('100%')
        .height(400)
      Column({ space: 10 }) {
        Button('Set B1')
          .onClick(() => {
            this.onButtonClick('set_b1')
          })

        Button('Set B2')
          .onClick(() => {
            this.onButtonClick('set_b2')
          })

        Button('Set B1/C1')
          .onClick(() => {
            this.onButtonClick('set_b1_c1')
          })

        Button('Set B1/C2')
          .onClick(() => {
            this.onButtonClick('set_b1_c2')
          })

        Button('Set B2/C1')
          .onClick(() => {
            this.onButtonClick('set_b2_c1')
          })

        Button('Set B2/C2')
          .onClick(() => {
            this.onButtonClick('set_b2_c2')
          })
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .height('100%')
  }
}