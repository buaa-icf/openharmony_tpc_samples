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

import { TitleBar } from '../common/TitleBar';
import { FrameCallback } from '@kit.ArkUI';
import { Renderer, RiveAnimationView } from '@ohos/rive';

@Entry
@Component
export struct MetricsPage {
  @State fpsInfo: string = 'Frame rate: -- Hz (-- ms)'
  private riveView: RiveAnimationView | null = null
  private frameCallBack: RiveFrameCallBack | null = null

  build() {
    Column() {
      TitleBar()
      RiveAnimationView({
        riveResource: '@rawfile/off_road_car_blog.riv',
        riveFit: 'cover',
        onReady: (view: RiveAnimationView) => {
          this.riveView = view;
          setTimeout(() => {
            this.frameCallBack =
              new RiveFrameCallBack(this.riveView!.getRenderer(), this.updateFps, this.getUIContext());
            this.getUIContext().postFrameCallback(this.frameCallBack)
          }, 500);
        }
      })
        .width('100%')
        .height(339)

      Text(this.fpsInfo)
        .fontSize(16)
        .fontColor(Color.Black)
        .margin(10)
    }
  }

  updateFps: (fps: number) => void = (fps: number) => {
    if (fps > 0) {
      const frameTime = 1000 / fps;
      this.fpsInfo = `Frame rate: ${fps.toFixed(1)} Hz (${frameTime.toFixed(2)} ms)`;
      console.debug(`RiveAnimationView: this.fpsInfo 222${this.fpsInfo}`);
    }
  }
}

class RiveFrameCallBack extends FrameCallback {
  public renderer: Renderer | null
  public onFpsUpdate: ((fps: number) => void) = (fps: number) => {
  }
  private context: UIContext;

  constructor(renderer: Renderer | null, onFpsUpdate: (fps: number) => void, uiContext: UIContext) {
    super();
    this.renderer = renderer
    this.onFpsUpdate = onFpsUpdate
    this.context = uiContext
  }

  onFrame(framTimeNanos?: number) {
      if (this.renderer && this.renderer.isPlaying) {
        if (this.renderer.hasCppObject) {
          const avgFps = this.renderer.averageFps;
        if (this.onFpsUpdate) {
          this.onFpsUpdate(avgFps);
        }
      }
      this.context.postFrameCallback(this)
    }
  }
}
