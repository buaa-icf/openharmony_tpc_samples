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
import {easeBack, easeBackIn, easeBackOut, easeBackInOut} from "d3-ease";
import {out, inOut} from "./generic"
import {assertInDelta} from "./asserts";

export default function easeBackTest() {

  describe('easeBackTest', () => {

    it("easeBack_is_an_alias_for_easeBackOut", 0, () => {
      expect(easeBack).assertEqual(easeBackInOut);
    });

    it("easeBackIn_returns_the_expected_results", 0, () => {
      expect(easeBackIn(0.0)).assertEqual(0.00);
      expect(assertInDelta(easeBackIn(0.1), -0.014314)).assertTrue();
      expect(assertInDelta(easeBackIn(0.2), -0.046451)).assertTrue();
      expect(assertInDelta(easeBackIn(0.3), -0.080200)).assertTrue();
      expect(assertInDelta(easeBackIn(0.4), -0.099352)).assertTrue();
      expect(assertInDelta(easeBackIn(0.5), -0.087698)).assertTrue();
      expect(assertInDelta(easeBackIn(0.6), -0.029028)).assertTrue();
      expect(assertInDelta(easeBackIn(0.7), +0.092868)).assertTrue();
      expect(assertInDelta(easeBackIn(0.8), +0.294198)).assertTrue();
      expect(assertInDelta(easeBackIn(0.9), +0.591172)).assertTrue();
      expect(easeBackIn(1.0)).assertEqual(1.0);
    });

    it("easeBackIn_coerces_t_to_a_number", 0, () => {
      expect(easeBackIn('.9')).assertEqual(easeBackIn(.9));
      expect(easeBackIn({ valueOf: () => 0.9 })).assertEqual(easeBackIn(.9));
    });

    it("easeBackOut_returns_the_expected_results", 0, () => {
      let backOut = out(easeBackIn);
      expect(easeBackOut(0.0)).assertEqual(backOut(0.0));
      expect(assertInDelta(easeBackOut(0.1), backOut(0.1))).assertTrue();
      expect(assertInDelta(easeBackOut(0.2), backOut(0.2))).assertTrue();
      expect(assertInDelta(easeBackOut(0.3), backOut(0.3))).assertTrue();
      expect(assertInDelta(easeBackOut(0.4), backOut(0.4))).assertTrue();
      expect(assertInDelta(easeBackOut(0.5), backOut(0.5))).assertTrue();
      expect(assertInDelta(easeBackOut(0.6), backOut(0.6))).assertTrue();
      expect(assertInDelta(easeBackOut(0.7), backOut(0.7))).assertTrue();
      expect(assertInDelta(easeBackOut(0.8), backOut(0.8))).assertTrue();
      expect(assertInDelta(easeBackOut(0.9), backOut(0.9))).assertTrue();
      expect(easeBackOut(1.0)).assertEqual(backOut(1.0));
    });

    it("easeBackOut_coerces_t_to_a_number", 0, () => {
      expect(easeBackOut('.9')).assertEqual(easeBackOut(.9));
      expect(easeBackOut({ valueOf: () => 0.9 })).assertEqual(easeBackOut(.9));
    });

    it("easeBackInOut_returns_the_expected_results", 0, () => {
      let backInOut = inOut(easeBackIn);
      expect(easeBackInOut(0.0)).assertEqual(backInOut(0.0));
      expect(assertInDelta(easeBackInOut(0.1), backInOut(0.1))).assertTrue();
      expect(assertInDelta(easeBackInOut(0.2), backInOut(0.2))).assertTrue();
      expect(assertInDelta(easeBackInOut(0.3), backInOut(0.3))).assertTrue();
      expect(assertInDelta(easeBackInOut(0.4), backInOut(0.4))).assertTrue();
      expect(assertInDelta(easeBackInOut(0.5), backInOut(0.5))).assertTrue();
      expect(assertInDelta(easeBackInOut(0.6), backInOut(0.6))).assertTrue();
      expect(assertInDelta(easeBackInOut(0.7), backInOut(0.7))).assertTrue();
      expect(assertInDelta(easeBackInOut(0.8), backInOut(0.8))).assertTrue();
      expect(assertInDelta(easeBackInOut(0.9), backInOut(0.9))).assertTrue();
      expect(easeBackInOut(1.0)).assertEqual(backInOut(1.0));
    });
  })

  it("easeBackInOut_coerces_t_to_a_number", 0, () => {
    expect(easeBackInOut('.9')).assertEqual(easeBackInOut(.9));
    expect(easeBackInOut({ valueOf: () => 0.9 })).assertEqual(easeBackInOut(.9));
  });
}