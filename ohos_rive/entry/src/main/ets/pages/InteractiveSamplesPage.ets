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
struct InteractiveSamplesPage {
  @State keepGoing: boolean = true;
  clockView: RiveAnimationView |null= null;

  aboutToDisappear() {
    // This is the exit point for any RiveAnimationView, if we try to access
    // underlying properties (e.g. setNumberState() above) _after_ we detached, underlying
    // objects have probably been deallocated and this will result in a crash.
    this.keepGoing = false;
  }

  setTime() {
    try {
      const date = new Date();
      const hours = date.getHours() % 12;
      const minutes = date.getMinutes();
      const seconds = date.getSeconds();
      // Calculate the hour position including minutes and seconds for smooth movement
      const hourPosition = hours + minutes / 60 + seconds / 3600;
      if (this.clockView) {
        this.clockView.setNumberState('Time', 'isTime', hourPosition);
      }
    } catch (error) {
      console.error('Error setting time: ' + error);
    }
  }

  startClockTimer() {
    if (!this.keepGoing) {
      return;
    }
    setTimeout(() => {
      if (this.keepGoing) {
        this.setTime();
        this.startClockTimer();
      }
    }, 360); // Update every 360ms to match Android implementation
  }

  build() {
    Column() {
      TitleBar()
      Scroll() {
        Column() {
          RiveAnimationView({
            riveResource: '@rawfile/play_button_event_example.riv',
            riveFit: 'cover',
            riveStateMachine: 'State Machine'
          })
            .width('100%')
            .height('50%')
          RiveAnimationView({
            riveResource: '@rawfile/switch_event_example.riv',
            riveFit: 'cover',
            riveStateMachine: 'Main State Machine'
          })
            .width('100%')
            .height('50%')

          RiveAnimationView({
            riveResource: '@rawfile/leg_day_events_example.riv',
            riveFit: 'cover',
            riveStateMachine: 'Don\'t Skip Leg Day'
          })
            .width('100%')
            .height('50%')

          RiveAnimationView({
            riveResource: '@rawfile/watch_v1.riv',
            riveFit: 'cover',
            riveStateMachine: 'Time',
            onReady: (view) => {
              this.clockView = view;
              this.setTime();
              this.startClockTimer();
            }
          })
            .width('100%')
            .height('50%')
        }
        .width('100%')
      }
      .width('100%')
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
  }
}