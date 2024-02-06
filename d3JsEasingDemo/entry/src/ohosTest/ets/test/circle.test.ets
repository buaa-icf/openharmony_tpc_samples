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


import {  describe, expect, it } from '@ohos/hypium';
import {easeCircle, easeCircleIn, easeCircleOut, easeCircleInOut} from "d3-ease";
import {out, inOut} from "./generic"
import {assertInDelta} from "./asserts";

export default function easeCircleTest() {

  describe('easeCircleTest', () => {

    it("easeCircle_is_an_alias_for_easeCircleInOut", 0, () => {
      expect(easeCircle).assertEqual(easeCircleInOut);
    });

    it("easeCircleIn_returns_the_expected_results", 0, () => {
      expect(easeCircleIn(0.0)).assertEqual(0.00);
      expect(assertInDelta(easeCircleIn(0.1), 0.005013)).assertTrue();
      expect(assertInDelta(easeCircleIn(0.2), 0.020204)).assertTrue();
      expect(assertInDelta(easeCircleIn(0.3), 0.046061)).assertTrue();
      expect(assertInDelta(easeCircleIn(0.4), 0.083485)).assertTrue();
      expect(assertInDelta(easeCircleIn(0.5), 0.133975)).assertTrue();
      expect(assertInDelta(easeCircleIn(0.6), 0.200000)).assertTrue();
      expect(assertInDelta(easeCircleIn(0.7), 0.285857)).assertTrue();
      expect(assertInDelta(easeCircleIn(0.8), 0.400000)).assertTrue();
      expect(assertInDelta(easeCircleIn(0.9), 0.564110)).assertTrue();
      expect(easeCircleIn(1.0)).assertEqual(1.0);
    });

    it("easeCircleOut_returns_the_expected_results", 0, () => {
      let circleOut = out(easeCircleIn);
      expect(easeCircleOut(0.0)).assertEqual(0.00);
      expect(assertInDelta(easeCircleOut(0.1), circleOut(0.1))).assertTrue();
      expect(assertInDelta(easeCircleOut(0.2), circleOut(0.2))).assertTrue();
      expect(assertInDelta(easeCircleOut(0.3), circleOut(0.3))).assertTrue();
      expect(assertInDelta(easeCircleOut(0.4), circleOut(0.4))).assertTrue();
      expect(assertInDelta(easeCircleOut(0.5), circleOut(0.5))).assertTrue();
      expect(assertInDelta(easeCircleOut(0.6), circleOut(0.6))).assertTrue();
      expect(assertInDelta(easeCircleOut(0.7), circleOut(0.7))).assertTrue();
      expect(assertInDelta(easeCircleOut(0.8), circleOut(0.8))).assertTrue();
      expect(assertInDelta(easeCircleOut(0.9), circleOut(0.9))).assertTrue();
      expect(easeCircleOut(1.0)).assertEqual(1.0);
    });


    it("easeCircleInOut_returns_the_expected_results", 0, () => {
      let circleInOut = inOut(easeCircleIn);
      expect(assertInDelta(easeCircleInOut(0.0), circleInOut(0.0))).assertTrue();
      expect(assertInDelta(easeCircleInOut(0.1), circleInOut(0.1))).assertTrue();
      expect(assertInDelta(easeCircleInOut(0.2), circleInOut(0.2))).assertTrue();
      expect(assertInDelta(easeCircleInOut(0.3), circleInOut(0.3))).assertTrue();
      expect(assertInDelta(easeCircleInOut(0.4), circleInOut(0.4))).assertTrue();
      expect(assertInDelta(easeCircleInOut(0.5), circleInOut(0.5))).assertTrue();
      expect(assertInDelta(easeCircleInOut(0.6), circleInOut(0.6))).assertTrue();
      expect(assertInDelta(easeCircleInOut(0.7), circleInOut(0.7))).assertTrue();
      expect(assertInDelta(easeCircleInOut(0.8), circleInOut(0.8))).assertTrue();
      expect(assertInDelta(easeCircleInOut(0.9), circleInOut(0.9))).assertTrue();
      expect(assertInDelta(easeCircleInOut(0.0), circleInOut(0.0))).assertTrue();
    });
  })
}