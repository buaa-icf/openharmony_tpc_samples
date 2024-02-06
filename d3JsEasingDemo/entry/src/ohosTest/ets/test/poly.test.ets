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
import {easePoly, easePolyIn, easePolyOut, easePolyInOut} from "d3-ease";
import {out, inOut} from "./generic"
import {assertInDelta} from "./asserts";

export default function easePolyTest() {

  describe('easePolyTest', () => {

    it("easePoly_is_an_alias_for_easePolyInOut", 0, () => {
      expect(easePoly).assertEqual(easePolyInOut)
    });

    it("easePolyIn_returns_the_expected_results", 0, () => {
      expect(easePolyIn(0.0)).assertEqual(0.00);
      expect(assertInDelta(easePolyIn(0.1), 0.001)).assertTrue();
      expect(assertInDelta(easePolyIn(0.2), 0.008)).assertTrue();
      expect(assertInDelta(easePolyIn(0.3), 0.027)).assertTrue();
      expect(assertInDelta(easePolyIn(0.4), 0.064)).assertTrue();
      expect(assertInDelta(easePolyIn(0.5), 0.125)).assertTrue();
      expect(assertInDelta(easePolyIn(0.6), 0.216)).assertTrue();
      expect(assertInDelta(easePolyIn(0.7), 0.343)).assertTrue();
      expect(assertInDelta(easePolyIn(0.8), 0.512)).assertTrue();
      expect(assertInDelta(easePolyIn(0.9), 0.729)).assertTrue();
      expect(easePolyIn(1.0)).assertEqual(1.0);
    });

    it("easePolyOut_returns_the_expected_results", 0, () => {
      let ployOut = out(easePolyIn);
      expect(easePolyOut(0.0)).assertEqual(0.00);
      expect(assertInDelta(easePolyOut(0.1), ployOut(0.1))).assertTrue();
      expect(assertInDelta(easePolyOut(0.2), ployOut(0.2))).assertTrue();
      expect(assertInDelta(easePolyOut(0.3), ployOut(0.3))).assertTrue();
      expect(assertInDelta(easePolyOut(0.4), ployOut(0.4))).assertTrue();
      expect(assertInDelta(easePolyOut(0.5), ployOut(0.5))).assertTrue();
      expect(assertInDelta(easePolyOut(0.6), ployOut(0.6))).assertTrue();
      expect(assertInDelta(easePolyOut(0.7), ployOut(0.7))).assertTrue();
      expect(assertInDelta(easePolyOut(0.8), ployOut(0.8))).assertTrue();
      expect(assertInDelta(easePolyOut(0.9), ployOut(0.9))).assertTrue();
      expect(easePolyOut(1.0)).assertEqual(1.0);
    });


    it("easePolyInOut_returns_the_expected_results", 0, () => {
      let ployInOut = inOut(easePolyIn);
      expect(assertInDelta(easePolyInOut(0.0), ployInOut(0.0))).assertTrue();
      expect(assertInDelta(easePolyInOut(0.1), ployInOut(0.1))).assertTrue();
      expect(assertInDelta(easePolyInOut(0.2), ployInOut(0.2))).assertTrue();
      expect(assertInDelta(easePolyInOut(0.3), ployInOut(0.3))).assertTrue();
      expect(assertInDelta(easePolyInOut(0.4), ployInOut(0.4))).assertTrue();
      expect(assertInDelta(easePolyInOut(0.5), ployInOut(0.5))).assertTrue();
      expect(assertInDelta(easePolyInOut(0.6), ployInOut(0.6))).assertTrue();
      expect(assertInDelta(easePolyInOut(0.7), ployInOut(0.7))).assertTrue();
      expect(assertInDelta(easePolyInOut(0.8), ployInOut(0.8))).assertTrue();
      expect(assertInDelta(easePolyInOut(0.9), ployInOut(0.9))).assertTrue();
      expect(assertInDelta(easePolyInOut(0.0), ployInOut(0.0))).assertTrue();
    });
  })
}