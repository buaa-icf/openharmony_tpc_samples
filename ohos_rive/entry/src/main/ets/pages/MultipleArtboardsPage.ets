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
struct MultipleArtboardsPage {
  build() {
    Column() {
      TitleBar()
      Scroll() {
        Column() {
          // Square - go around
          Text('Square - go around')
            .width('100%')
            .height('wrap_content')

          RiveAnimationView({
            riveResource: '@rawfile/artboard_animations.riv',
            riveArtboard: 'Square',
            riveAnimation: 'goaround'
          })
            .width('100%')
            .height('50%')

          // Square - roll around
          Text('Square - roll around')
            .width('100%')


          RiveAnimationView({
            riveResource: '@rawfile/artboard_animations.riv',
            riveArtboard: 'Square',
            riveAnimation: 'rollaround'
          })
            .width('100%')
            .height('50%')

          // Circle
          Text('Circle')
            .width('100%')

          RiveAnimationView({
            riveResource: '@rawfile/artboard_animations.riv',
            riveArtboard: 'Circle'
          })
            .width('100%')
            .height('50%')

          // Star
          Text('Star')
            .width('100%')

          RiveAnimationView({
            riveResource: '@rawfile/artboard_animations.riv',
            riveArtboard: 'Star'
          })
            .width('100%')
            .height('50%')
        }
        .width('100%')
        .padding({ bottom: 5 })
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
  }
}