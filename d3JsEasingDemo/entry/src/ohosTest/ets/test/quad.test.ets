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
import {easeQuad, easeQuadIn, easeQuadInOut, easeQuadOut} from "d3-ease";
import {out, inOut} from "./generic"
import {assertInDelta} from "./asserts";

export default function easeQuadTest() {

  describe('easeQuadTest', () => {

    it("easeQuad_is_an_alias_for_easeQuadInOut", 0, () => {
      expect(easeQuad).assertEqual(easeQuadInOut)
    });

    it("easeQuadIn_returns_the_expected_results", 0, () => {
      expect(easeQuadIn(0.0)).assertEqual(0.00);
      expect(assertInDelta(easeQuadIn(0.1), 0.01)).assertTrue();
      expect(assertInDelta(easeQuadIn(0.2), 0.04)).assertTrue();
      expect(assertInDelta(easeQuadIn(0.3), 0.09)).assertTrue();
      expect(assertInDelta(easeQuadIn(0.4), 0.16)).assertTrue();
      expect(assertInDelta(easeQuadIn(0.5), 0.25)).assertTrue();
      expect(assertInDelta(easeQuadIn(0.6), 0.36)).assertTrue();
      expect(assertInDelta(easeQuadIn(0.7), 0.49)).assertTrue();
      expect(assertInDelta(easeQuadIn(0.8), 0.64)).assertTrue();
      expect(assertInDelta(easeQuadIn(0.9), 0.81)).assertTrue();
      expect(easeQuadIn(1.0)).assertEqual(1.0);
    });

    it("easeQuadIn_coerces_t_to_a_number", 0, () => {
      expect(easeQuadIn('.9')).assertEqual(easeQuadIn(.9));
      expect(easeQuadIn({ valueOf: () => 0.9 })).assertEqual(easeQuadIn(.9));
    });

    it("easeQuadOut_returns_the_expected_results", 0, () => {
      let quadOut = out(easeQuadIn);
      expect(easeQuadOut(0.0)).assertEqual(quadOut(0.0));
      expect(assertInDelta(easeQuadOut(0.1), quadOut(0.1))).assertTrue();
      expect(assertInDelta(easeQuadOut(0.2), quadOut(0.2))).assertTrue();
      expect(assertInDelta(easeQuadOut(0.3), quadOut(0.3))).assertTrue();
      expect(assertInDelta(easeQuadOut(0.4), quadOut(0.4))).assertTrue();
      expect(assertInDelta(easeQuadOut(0.5), quadOut(0.5))).assertTrue();
      expect(assertInDelta(easeQuadOut(0.6), quadOut(0.6))).assertTrue();
      expect(assertInDelta(easeQuadOut(0.7), quadOut(0.7))).assertTrue();
      expect(assertInDelta(easeQuadOut(0.8), quadOut(0.8))).assertTrue();
      expect(assertInDelta(easeQuadOut(0.9), quadOut(0.9))).assertTrue();
      expect(easeQuadOut(1.0)).assertEqual(quadOut(1.0));
    });

    it("easeQuadOut_coerces_t_to_a_number", 0, () => {
      expect(easeQuadOut('.9')).assertEqual(easeQuadOut(.9));
      expect(easeQuadOut({ valueOf: () => 0.9 })).assertEqual(easeQuadOut(.9));
    });

    it("easeQuadInOut_returns_the_expected_results", 0, () => {
      let quadInOut = inOut(easeQuadIn);
      expect(easeQuadInOut(0.0)).assertEqual(quadInOut(0.0));
      expect(assertInDelta(easeQuadInOut(0.1), quadInOut(0.1))).assertTrue();
      expect(assertInDelta(easeQuadInOut(0.2), quadInOut(0.2))).assertTrue();
      expect(assertInDelta(easeQuadInOut(0.3), quadInOut(0.3))).assertTrue();
      expect(assertInDelta(easeQuadInOut(0.4), quadInOut(0.4))).assertTrue();
      expect(assertInDelta(easeQuadInOut(0.5), quadInOut(0.5))).assertTrue();
      expect(assertInDelta(easeQuadInOut(0.6), quadInOut(0.6))).assertTrue();
      expect(assertInDelta(easeQuadInOut(0.7), quadInOut(0.7))).assertTrue();
      expect(assertInDelta(easeQuadInOut(0.8), quadInOut(0.8))).assertTrue();
      expect(assertInDelta(easeQuadInOut(0.9), quadInOut(0.9))).assertTrue();
      expect(easeQuadInOut(1.0)).assertEqual(quadInOut(1.0));
    });
  })

  it("easeQuadInOut_coerces_t_to_a_number", 0, () => {
    expect(easeQuadInOut('.9')).assertEqual(easeQuadInOut(.9));
    expect(easeQuadInOut({ valueOf: () => 0.9 })).assertEqual(easeQuadInOut(.9));
  });

}

