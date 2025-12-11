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

import { PointRect } from '../util/PointRect';
import { EvaMixAnimPlugin } from './EvaMixAnimPlugin';
import { EvaResource } from './EvaResource';

/**
 * 触摸事件拦截
 */
export class EvaMixTouch {
  private mixAnimPlugin: EvaMixAnimPlugin;

  constructor(mixAnimPlugin: EvaMixAnimPlugin) {
    this.mixAnimPlugin = mixAnimPlugin;
  }

  onTouchEvent(ev: TouchEvent): EvaResource | null {
    const viewWith = this.mixAnimPlugin.playerEva.getRealSize()?.width as number;
    const viewHeight = this.mixAnimPlugin.playerEva.getRealSize()?.height as number;
    console.error('viewWith===', viewWith, 'viewHeight===', viewHeight)
    const config = this.mixAnimPlugin.playerEva.configManager.config;
    console.error('config===', config)
    if (config == undefined || config == null) {
      return null;
    }
    const videoWith = config.width;
    const videoHeight = config.height;
    console.error('videoWith===', videoWith, 'videoHeight===', videoHeight)
    if (videoWith === 0 || videoHeight === 0) {
      return null;
    }

    if (ev.type === TouchType.Down) {
      const touchPoint = ev.touches[0];
      const x = this.mixAnimPlugin.playerEva.vp2px(touchPoint.x) * videoWith /
      this.mixAnimPlugin.playerEva.vp2px(viewWith);
      const y = this.mixAnimPlugin.playerEva.vp2px(touchPoint.y) * videoHeight /
      this.mixAnimPlugin.playerEva.vp2px(viewHeight);

      const list = this.mixAnimPlugin.frameAll?.map?.get(this.mixAnimPlugin.curFrameIndex)?.list;
      if (list) {
        for (const frame of list) {
          const src = this.mixAnimPlugin.srcMap?.map?.get(frame.srcId);
          if (!src) {
            continue;
          }

          let isCalClick = this.calClick(Number.parseInt(x.toString()),Number.parseInt(y.toString()), frame.frame);
          console.error('isCalClick===', isCalClick)
          if (isCalClick) {
            return new EvaResource(src);
          }
        }
      }
    }

    return null;
  }

  private calClick(x: number, y: number, frame: PointRect): boolean {
    console.error('x===', x >= frame.x)
    console.error('x===', x <= frame.x + frame.w)
    console.error('x===', y >= frame.y)
    console.error('x===', y <= frame.y + frame.h)
    if (x >= frame.x &&
      x <= (frame.x + frame.w) &&
      y >= frame.y &&
      y <= (frame.y + frame.h)) {
      return true;
    }
    return false;

  }
}
