/*
 * Copyright (C) 2024 Huawei Device Co., Ltd.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * * Redistributions of source code must retain the above copyright notice, this
 *   list of conditions and the following disclaimer.
 *
 * * Redistributions in binary form must reproduce the above copyright notice,
 *   this list of conditions and the following disclaimer in the documentation
 *   and/or other materials provided with the distribution.
 *
 * * Neither the name of the author nor the names of contributors may be used to
 *   endorse or promote products derived from this software without specific prior
 *   written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import Animator, { AnimatorResult } from '@ohos.animator';
import * as Easing from 'd3-ease';
import { getEasingFunctionsRow, EasingFunctions } from '../utils';

interface LineToParams {
  x: number,
  y: number
}

@Entry
@Component
struct LineAnimatePage {
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);
  animator: AnimatorResult = Animator.create({
    duration: 1500,
    easing: 'linear',
    direction: 'normal',
    iterations: 1,
    delay: 0,
    fill: 'none',
    begin: 0,
    end: 1
  });
  isPlaying = false;

  lineToParams: LineToParams = {x: 0, y: 0}

  beginPoint: LineToParams = { x: 30, y: 300 }
  endPoint: LineToParams = { x: 300, y: 30 }

  rowEasing: EasingFunctions[][] = [];

  onAnimateUpdate() {
    if (this.lineToParams.x === this.beginPoint.x) {
      return;
    }
    this.context.lineTo(
      this.lineToParams.x,
      this.lineToParams.y,
    );
    this.context.stroke();
  }


  aboutToAppear(): void {
    this.rowEasing = getEasingFunctionsRow();
  }

  aboutToDisappear(): void {
    this.rowEasing = [];
  }

  easingFunctionName: string = 'easeLinear';

  createAnimation() {
    const xDistance = this.endPoint.x - this.beginPoint.x;
    const yDistance = this.endPoint.y - this.beginPoint.y;
    this.animator.onframe = (value) => {
      this.lineToParams.x = this.beginPoint.x + value * xDistance;
      const f: number = Easing[this.easingFunctionName](value);
      this.lineToParams.y = this.beginPoint.y + f * yDistance;
      this.onAnimateUpdate();
    };
    this.animator.onfinish = () => {
      this.isPlaying = false;
    };
  }

  drawAnimationPath() {
    this.context.clearRect(0, 0, 500, 500);
    this.context.beginPath();
    this.context.moveTo(this.beginPoint.x, this.beginPoint.y);
    this.isPlaying = true;
    this.animator.play();
  }

  build() {
    Column() {
      Canvas(this.context)
        .width('100%')
        .height(350)
        .backgroundColor('#ffff00')
        .onReady(() => {
          this.createAnimation();
        })

      ForEach(this.rowEasing, (item: EasingFunctions[]) => {
        Row() {
          ForEach(item, (easingInfo: EasingFunctions) => {
            Button(`${easingInfo.easingGroup}.${easingInfo.easingType}`)
              .width(120)
              .height(30)
              .fontColor(Color.White)
              .backgroundColor(Color.Red)
              .onClick(() => {
                if (this.isPlaying) { return; }
                const easingGroup = easingInfo.easingGroup;
                const easingType = easingInfo.easingType;
                this.easingFunctionName = easingGroup !== 'easeLinear' ? easingGroup + easingType : easingGroup;
                this.drawAnimationPath();
              })
          })
        }.width('100%').margin(5);
      })
    }.width("100%").height("100%")
  }
}