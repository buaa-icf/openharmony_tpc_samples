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
struct SimplePage {
  private context: Context = getContext() as Context;

  private riveUrlVehicles(): string {
    return this.context.resourceManager.getStringSync($r('app.string.rive_url_vehicles'));
  }

  build() {
    Column() {

      Scroll() {
        Column() {
          RiveAnimationView({
            riveResource: '@rawfile/off_road_car_blog.riv',
            riveFit: 'cover'
          })
            .width('100%')
            .height(339)

          RiveAnimationView({
            riveUrl: this.riveUrlVehicles(),
            riveFit: 'cover'
          })
            .width('100%')
            .height(345)
        }
        .width('100%')
        .padding({ bottom: 5 })
      }
      .width('100%')
      .layoutWeight(1)
      .backgroundColor('#F5F5F5')
    }
    .width('100%')
    .height('100%')
  }
}