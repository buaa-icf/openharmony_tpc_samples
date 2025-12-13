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
struct FragmentPage {
  build() {
    Column() {
      TitleBar()
      this.RiveFragmentComponent()
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  RiveFragmentComponent() {
    Scroll() {
      Column() {
        RiveAnimationView({
          riveResource: '@rawfile/basketball.riv',
          riveFit: 'contain',
          riveAutoPlay: true
        })
          .width('100%')
          .height('55%')
        RiveAnimationView({
          riveResource: '@rawfile/flux_capacitor.riv',
          riveFit: 'contain',
          riveAutoPlay: true
        })
          .width('100%')
          .height('70%')
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
    }
    .width('100%')
    .height('100%')
  }
}
