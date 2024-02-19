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
import {easeExp, easeExpIn, easeExpOut, easeExpInOut} from "d3-ease";
import {out, inOut} from "./generic"
import {assertInDelta} from "./asserts";

export default function easeExpTest() {

  describe('easeExpTest', () => {

    it("easeExp_is_an_alias_for_easeExpInOut", 0, () => {
      expect(easeExp).assertEqual(easeExpInOut);
    });

    it("easeExpIn_returns_the_expected_results", 0, () => {
      expect(easeExpIn(0.0)).assertEqual(0.00);
      expect(assertInDelta(easeExpIn(0.1), 0.000978)).assertTrue();
      expect(assertInDelta(easeExpIn(0.2), 0.002933)).assertTrue();
      expect(assertInDelta(easeExpIn(0.3), 0.006843)).assertTrue();
      expect(assertInDelta(easeExpIn(0.4), 0.014663)).assertTrue();
      expect(assertInDelta(easeExpIn(0.5), 0.030303)).assertTrue();
      expect(assertInDelta(easeExpIn(0.6), 0.061584)).assertTrue();
      expect(assertInDelta(easeExpIn(0.7), 0.124145)).assertTrue();
      expect(assertInDelta(easeExpIn(0.8), 0.249267)).assertTrue();
      expect(assertInDelta(easeExpIn(0.9), 0.499511)).assertTrue();
      expect(easeExpIn(1.0)).assertEqual(1.0);
    });

    it("easeExpIn_coerces_t_to_a_number", 0, () => {
      expect(easeExpIn('.9')).assertEqual(easeExpIn(.9));
      expect(easeExpIn({ valueOf: () => 0.9 })).assertEqual(easeExpIn(.9));
    });

    it("easeExpOut_returns_the_expected_results", 0, () => {
      let expOut = out(easeExpIn);
      expect(easeExpOut(0.0)).assertEqual(expOut(0.0));
      expect(assertInDelta(easeExpOut(0.1), expOut(0.1))).assertTrue();
      expect(assertInDelta(easeExpOut(0.2), expOut(0.2))).assertTrue();
      expect(assertInDelta(easeExpOut(0.3), expOut(0.3))).assertTrue();
      expect(assertInDelta(easeExpOut(0.4), expOut(0.4))).assertTrue();
      expect(assertInDelta(easeExpOut(0.5), expOut(0.5))).assertTrue();
      expect(assertInDelta(easeExpOut(0.6), expOut(0.6))).assertTrue();
      expect(assertInDelta(easeExpOut(0.7), expOut(0.7))).assertTrue();
      expect(assertInDelta(easeExpOut(0.8), expOut(0.8))).assertTrue();
      expect(assertInDelta(easeExpOut(0.9), expOut(0.9))).assertTrue();
      expect(easeExpOut(1.0)).assertEqual(expOut(1.0));
    });

    it("easeExpOut_coerces_t_to_a_number", 0, () => {
      expect(easeExpOut('.9')).assertEqual(easeExpOut(.9));
      expect(easeExpOut({ valueOf: () => 0.9 })).assertEqual(easeExpOut(.9));
    });

    it("easeExpInOut_returns_the_expected_results", 0, () => {
      let expInOut = inOut(easeExpIn);
      expect(easeExpInOut(0.0)).assertEqual(expInOut(0.0));
      expect(assertInDelta(easeExpInOut(0.1), expInOut(0.1))).assertTrue();
      expect(assertInDelta(easeExpInOut(0.2), expInOut(0.2))).assertTrue();
      expect(assertInDelta(easeExpInOut(0.3), expInOut(0.3))).assertTrue();
      expect(assertInDelta(easeExpInOut(0.4), expInOut(0.4))).assertTrue();
      expect(assertInDelta(easeExpInOut(0.5), expInOut(0.5))).assertTrue();
      expect(assertInDelta(easeExpInOut(0.6), expInOut(0.6))).assertTrue();
      expect(assertInDelta(easeExpInOut(0.7), expInOut(0.7))).assertTrue();
      expect(assertInDelta(easeExpInOut(0.8), expInOut(0.8))).assertTrue();
      expect(assertInDelta(easeExpInOut(0.9), expInOut(0.9))).assertTrue();
      expect(easeExpInOut(1.0)).assertEqual(expInOut(1.0));
    });
  })

  it("easeExpInOut_coerces_t_to_a_number", 0, () => {
    expect(easeExpInOut('.9')).assertEqual(easeExpInOut(.9));
    expect(easeExpInOut({ valueOf: () => 0.9 })).assertEqual(easeExpInOut(.9));
  });
}