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

import { systemDateTime } from '@kit.BasicServicesKit';

export class SpeedControlUtil {
  private ONE_MILLION: number = 1000000;
  private prevPresentUsec: number = 0;
  private prevMonoUsec: number = 0;
  private fixedFrameDurationUsec: number = 0;
  private loopReset: boolean = true;

  // 设置帧率（FPS）
  setFixedPlaybackRate(fps: number): void {
    if (fps <= 0) {
      return;
    }
    this.fixedFrameDurationUsec = this.ONE_MILLION / fps;
  }

  // 帧渲染时间控制核心逻辑
  async preRender(presentationTimeUsec: number): Promise<void> {
    if (this.prevMonoUsec == 0) {
      this.prevMonoUsec = systemDateTime.getUptime(systemDateTime.TimeType.ACTIVE, true) / 1000; // 纳秒转微秒
      this.prevPresentUsec = presentationTimeUsec;
    } else {
      let frameDelta: number;
      if (this.loopReset) {
        this.prevPresentUsec = presentationTimeUsec - this.ONE_MILLION / 30;
        this.loopReset = false;
      }

      // 计算帧间隔
      if (this.fixedFrameDurationUsec != 0) {
        frameDelta = this.fixedFrameDurationUsec;
      } else {
        frameDelta = presentationTimeUsec - this.prevPresentUsec;
      }

      // 帧间隔边界保护
      if (frameDelta < 0) {
        frameDelta = 0;
      }
      if (frameDelta > 10 * this.ONE_MILLION) {
        frameDelta = 5 * this.ONE_MILLION;
      }

      const desiredUsec: number = this.prevMonoUsec + frameDelta;
      let nowUsec: number = systemDateTime.getUptime(systemDateTime.TimeType.ACTIVE, true) / 1000;

      // 微秒级精准等待（鸿蒙替代Thread.sleep）
      while (nowUsec < desiredUsec - 100) {
        let sleepTimeUsec: number = desiredUsec - nowUsec;
        if (sleepTimeUsec > 500000) {
          sleepTimeUsec = 500000;
        }

        let sleepTime = sleepTimeUsec / 1000 + ((sleepTimeUsec % 1000) * 1000)
        await this.sleep(sleepTime);
        nowUsec = systemDateTime.getUptime(systemDateTime.TimeType.ACTIVE, true) / 1000;
      }

      // 更新计时基准
      this.prevMonoUsec += frameDelta;
      this.prevPresentUsec += frameDelta;
    }
  }

  sleep(time: number): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, time));
  }

  // 重置状态
  reset(): void {
    this.prevPresentUsec = 0;
    this.prevMonoUsec = 0;
  }
}