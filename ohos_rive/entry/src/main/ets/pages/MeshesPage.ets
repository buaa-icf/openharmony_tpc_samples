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
import http from '@ohos.net.http';
import { LengthMetrics } from '@kit.ArkUI';


@Entry
@Component
struct MeshesPage {
  @State riveView : RiveAnimationView | null = null
  build() {
    Column() {
      Text('Rive Samples')
        .width('100%')
        .height(60)
        .margin({left:20})
        .fontSize(25)
        .fontWeight(FontWeight.Medium)
      Divider().strokeWidth(1).color('#F1F3F5')
      RiveAnimationView({
        riveResource:'@rawfile/prop_example.riv',
        riveStateMachine:'State Machine 1',
        onReady: (view) => {
          this.riveView = view
        }
      })
        .margin({top:16,left:16,right:16})
        .id('http_view')
        .width('90%')
        .height(300)
    }
  }

}