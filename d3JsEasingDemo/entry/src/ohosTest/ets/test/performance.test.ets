/*
 * Copyright (C) 2024 Huawei Device Co., Ltd.
 *
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
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND
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


import {  describe, expect, it } from '@ohos/hypium';
import * as Easing from "d3-ease";
import hilog from '@ohos.hilog';

const calcTime = (funcName: string) => {
  const startTime = new Date().getTime();
  for (let i = 0; i< 2000; i++) {
    Easing[funcName](Math.random());
  }
  const endTime = new Date().getTime();
  const averageTime = ((endTime - startTime ) * 1000) / 2000;
  hilog.info(0x0000, 'performanceTest', `${funcName} averageTime: ${averageTime}  us`)
  return averageTime;
}

export default function performanceTest() {


  // 循环2000次所有接口要小于 500 微秒
  describe('performanceTest', () => {

    it("duration_of_2000_iterations_of_the_easeLinear_function", 0, () => {
      expect(calcTime('easeLinear')).assertLess(500);
    });
    it("duration_of_2000_iterations_of_the_easeQuad_function", 0, () => {
      expect(calcTime('easeQuadIn')).assertLess(500);
      expect(calcTime('easeQuadOut')).assertLess(500);
      expect(calcTime('easeQuadInOut')).assertLess(500);
    });
    it("duration_of_2000_iterations_of_the_easeCubic_function", 0, () => {
      expect(calcTime('easeCubicIn')).assertLess(500);
      expect(calcTime('easeCubicOut')).assertLess(500);
      expect(calcTime('easeCubicInOut')).assertLess(500);
    });
    it("duration_of_2000_iterations_of_the_easePoly_function", 0, () => {
      expect(calcTime('easePolyIn')).assertLess(500);
      expect(calcTime('easePolyOut')).assertLess(500);
      expect(calcTime('easePolyInOut')).assertLess(500);
    });
    it("duration_of_2000_iterations_of_the_easeSin_function", 0, () => {
      expect(calcTime('easeSinIn')).assertLess(500);
      expect(calcTime('easeSinOut')).assertLess(500);
      expect(calcTime('easeSinInOut')).assertLess(500);
    });
    it("duration_of_2000_iterations_of_the_easeExp_function", 0, () => {
      expect(calcTime('easeExpIn')).assertLess(500);
      expect(calcTime('easeExpOut')).assertLess(500);
      expect(calcTime('easeExpInOut')).assertLess(500);
    });
    it("duration_of_2000_iterations_of_the_easeCircle_function", 0, () => {
      expect(calcTime('easeCircleIn')).assertLess(500);
      expect(calcTime('easeCircleOut')).assertLess(500);
      expect(calcTime('easeCircleInOut')).assertLess(500);
    });
    it("duration_of_2000_iterations_of_the_easeBounce_function", 0, () => {
      expect(calcTime('easeBounceIn')).assertLess(500);
      expect(calcTime('easeBounceOut')).assertLess(500);
      expect(calcTime('easeBounceInOut')).assertLess(500);
    });
    it("duration_of_2000_iterations_of_the_easeBack_function", 0, () => {
      expect(calcTime('easeBackIn')).assertLess(500);
      expect(calcTime('easeBackOut')).assertLess(500);
      expect(calcTime('easeBackInOut')).assertLess(500);
    });
    it("duration_of_2000_iterations_of_the_easeElastic_function", 0, () => {
      expect(calcTime('easeElasticIn')).assertLess(500);
      expect(calcTime('easeElasticOut')).assertLess(500);
      expect(calcTime('easeElasticInOut')).assertLess(500);
    });
  })
}