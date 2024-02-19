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


import { describe, expect, it } from '@ohos/hypium';
import {easeCubic, easeCubicIn, easeCubicOut, easeCubicInOut} from "d3-ease";
import {out, inOut} from "./generic"
import {assertInDelta} from "./asserts";

export default function easeCubicTest() {

  describe('easeCubicTest', () => {

    it("easeCubic_is_an_alias_for_easeCubicInOut", 0, () => {
      expect(easeCubic).assertEqual(easeCubicInOut)
    });

    it("easeCubicIn_returns_the_expected_results", 0, () => {
      expect(easeCubicIn(0.0)).assertEqual(0.00);
      expect(assertInDelta(easeCubicIn(0.1), 0.001)).assertTrue();
      expect(assertInDelta(easeCubicIn(0.2), 0.008)).assertTrue();
      expect(assertInDelta(easeCubicIn(0.3), 0.027)).assertTrue();
      expect(assertInDelta(easeCubicIn(0.4), 0.064)).assertTrue();
      expect(assertInDelta(easeCubicIn(0.5), 0.125)).assertTrue();
      expect(assertInDelta(easeCubicIn(0.6), 0.216)).assertTrue();
      expect(assertInDelta(easeCubicIn(0.7), 0.343)).assertTrue();
      expect(assertInDelta(easeCubicIn(0.8), 0.512)).assertTrue();
      expect(assertInDelta(easeCubicIn(0.9), 0.729)).assertTrue();
      expect(easeCubicIn(1.0)).assertEqual(1.0);
    });

    it("easeCubicIn_coerces_t_to_a_number", 0, () => {
      expect(easeCubicIn('.9')).assertEqual(easeCubicIn(.9));
      expect(easeCubicIn({ valueOf: () => 0.9 })).assertEqual(easeCubicIn(.9));
    });

    it("easeCubicOut_returns_the_expected_results", 0, () => {
      let cubicOut = out(easeCubicIn);
      expect(easeCubicOut(0.0)).assertEqual(cubicOut(0.0));
      expect(assertInDelta(easeCubicOut(0.1), cubicOut(0.1))).assertTrue();
      expect(assertInDelta(easeCubicOut(0.2), cubicOut(0.2))).assertTrue();
      expect(assertInDelta(easeCubicOut(0.3), cubicOut(0.3))).assertTrue();
      expect(assertInDelta(easeCubicOut(0.4), cubicOut(0.4))).assertTrue();
      expect(assertInDelta(easeCubicOut(0.5), cubicOut(0.5))).assertTrue();
      expect(assertInDelta(easeCubicOut(0.6), cubicOut(0.6))).assertTrue();
      expect(assertInDelta(easeCubicOut(0.7), cubicOut(0.7))).assertTrue();
      expect(assertInDelta(easeCubicOut(0.8), cubicOut(0.8))).assertTrue();
      expect(assertInDelta(easeCubicOut(0.9), cubicOut(0.9))).assertTrue();
      expect(easeCubicOut(1.0)).assertEqual(cubicOut(1.0));
    });

    it("easeCubicOut_coerces_t_to_a_number", 0, () => {
      expect(easeCubicOut('.9')).assertEqual(easeCubicOut(.9));
      expect(easeCubicOut({ valueOf: () => 0.9 })).assertEqual(easeCubicOut(.9));
    });

    it("easeCubicInOut_returns_the_expected_results", 0, () => {
      let cubicInOut = inOut(easeCubicIn);
      expect(easeCubicInOut(0.0)).assertEqual(cubicInOut(0.0));
      expect(assertInDelta(easeCubicInOut(0.1), cubicInOut(0.1))).assertTrue();
      expect(assertInDelta(easeCubicInOut(0.2), cubicInOut(0.2))).assertTrue();
      expect(assertInDelta(easeCubicInOut(0.3), cubicInOut(0.3))).assertTrue();
      expect(assertInDelta(easeCubicInOut(0.4), cubicInOut(0.4))).assertTrue();
      expect(assertInDelta(easeCubicInOut(0.5), cubicInOut(0.5))).assertTrue();
      expect(assertInDelta(easeCubicInOut(0.6), cubicInOut(0.6))).assertTrue();
      expect(assertInDelta(easeCubicInOut(0.7), cubicInOut(0.7))).assertTrue();
      expect(assertInDelta(easeCubicInOut(0.8), cubicInOut(0.8))).assertTrue();
      expect(assertInDelta(easeCubicInOut(0.9), cubicInOut(0.9))).assertTrue();
      expect(easeCubicInOut(1.0)).assertEqual(cubicInOut(1.0));
    });
  })

  it("easeCubicInOut_coerces_t_to_a_number", 0, () => {
    expect(easeCubicInOut('.9')).assertEqual(easeCubicInOut(.9));
    expect(easeCubicInOut({ valueOf: () => 0.9 })).assertEqual(easeCubicInOut(.9));
  });
}