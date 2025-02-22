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
import { getEasingGroupNames, getEasingTypes } from '../utils';


@Entry
@Component
struct BallAnimatePage {

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
  animator2: AnimatorResult = Animator.create({
    duration: 2000,
    easing: 'linear',
    direction: 'normal',
    iterations: 1,
    delay: 0,
    fill: 'none',
    begin: 0,
    end: 1
  });

  isPlaying = false;

  aboutToAppear(): void {
    this.createAnimation();
    this.easingFunctionNames = [ getEasingGroupNames(), getEasingTypes() ]
  }

  // 小球 marginLeft 30 => 320
  updateBallValue(normalizedTime: number) {
    const distance = this.getBallMoveDistance();
    this.ballAnimateValue = this.ballBeginX + Easing[this.currentEasingFunction](normalizedTime) * distance;

    console.log(`normalizedTime: ${normalizedTime}, transformValue: ${this.ballAnimateValue}`);
  }
  // 黄方块 rotate 0 => 180
  updateRotateValue(normalizedTime: number) {
    const changeAngle = this.getAngleChangeValue();
    this.angleValue = this.angleBegin + Easing[this.currentEasingFunction](normalizedTime) * changeAngle;
  }

  // 红方块 同时更新 width height borderRadius
  updateWHRadius(normalizedTime: number) {
    const transFormWidth = this.widthEnd - this.widthBegin;
    const transFormHeight = this.heightEnd - this.heightBegin;
    const transFormRadius = this.radiusEnd - this.radiusBegin;
    const normalizedAttrChangeValue: number = Easing[this.currentEasingFunction](normalizedTime);
    this.widthValue = this.widthBegin + normalizedAttrChangeValue * transFormWidth;
    this.heightValue = this.heightBegin + normalizedAttrChangeValue * transFormHeight;
    this.borderRadiusValue = this.radiusBegin + normalizedAttrChangeValue * transFormRadius;
  }

  createAnimation() {
    // normalized 归一化的时间
    this.animator.onFrame = (normalizedTime) => {
      if (this.currentEasingFunction) {
        this.updateBallValue(normalizedTime);
        this.updateRotateValue(normalizedTime);
      }
    }
    this.animator2.onFrame = (normalizedTime) => {
      if (this.currentEasingFunction) {
        this.updateWHRadius(normalizedTime);
      }
    }
    this.animator2.onFinish = () => {
      this.isPlaying = false;
    }
  }

  animationPlay() {
    this.isPlaying = true;
    // 1.5s 动画
    this.animator.play();
    // 2.0s 动画
    this.animator2.play();
  }

  MTop:Record<string,number> = { 'top': 50 };

  ballBeginX = 30;
  ballEndX = 320;
  @State ballAnimateValue: number = 30;

  angleBegin = 0;
  angleEnd = 180;
  @State angleValue: number = 0;

  widthBegin = 20;
  widthEnd = 200;
  @State widthValue: number = 20;

  heightBegin = 20;
  heightEnd = 32;
  @State heightValue: number = 20;

  radiusBegin = 0;
  radiusEnd = 40;
  @State borderRadiusValue: number = 0;

  getBallMoveDistance() {
    return this.ballEndX - this.ballBeginX;
  };

  getAngleChangeValue() {
    return this.angleEnd - this.angleBegin;
  };

  @State currentEasingFunction: string = 'easeLinear';

  private easingFunctionNames: string[][] = [];

  build() {
    Column() {
      Stack({alignContent: Alignment.TopStart}) {
        Column(){}.width('100%').height('100%').backgroundColor('#ff58b87c');
        Column(){}
        .width(28).height(28)
        .backgroundColor('#ff0991ec')
        .borderRadius(14)
        .margin({left: this.ballAnimateValue, top: 14});
        Column(){}.width(40).height(40).backgroundColor('#ffece109').margin({left: 30, top: 80}).rotate({ angle: this.angleValue});
        Column(){}
        .width(this.widthValue)
        .height(this.heightValue)
        .backgroundColor('#ffef4265')
        .margin({left: 100, top: 80})
        .borderRadius(this.borderRadiusValue);

      }.width('100%').height(150).margin(this.MTop)
      Column() {

        TextPicker({ range: this.easingFunctionNames })
          .onChange((value: string | string[], index: number | number[]) => {
            if (Array.isArray(value)) {
              const easingGroup = value[0];
              const easingType = value[1];
              this.currentEasingFunction = easingGroup !== 'easeLinear' ? easingGroup + easingType : easingGroup;
            }
          })
          .disappearTextStyle({color: Color.Red, font: {size: 15, weight: FontWeight.Lighter}})
          .textStyle({color: Color.Black, font: {size: 20, weight: FontWeight.Normal}})
          .selectedTextStyle({color: Color.Blue, font: {size: 22, weight: FontWeight.Bolder}})
          .canLoop(false);

        Button('play').onClick(() => {
          if (this.isPlaying) { return; };
          this.animationPlay();
        }).width(220).margin({ top: 16 });
      }

    }.width("100%").height("100%")
  }
}