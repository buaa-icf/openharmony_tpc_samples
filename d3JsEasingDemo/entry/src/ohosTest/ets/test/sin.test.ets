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
import {easeSin, easeSinIn, easeSinOut, easeSinInOut} from "d3-ease";
import {out, inOut} from "./generic"
import {assertInDelta} from "./asserts";

export default function easeSinTest() {

  describe('easeSinTest', () => {

    it("easeSin_is_an_alias_for_easeSinInOut", 0, () => {
      expect(easeSin).assertEqual(easeSinInOut);
    });

    it("easeSinIn_returns_the_expected_results", 0, () => {
      expect(easeSinIn(0.0)).assertEqual(0.00);
      expect(assertInDelta(easeSinIn(0.1), 0.012312)).assertTrue();
      expect(assertInDelta(easeSinIn(0.2), 0.048943)).assertTrue();
      expect(assertInDelta(easeSinIn(0.3), 0.108993)).assertTrue();
      expect(assertInDelta(easeSinIn(0.4), 0.190983)).assertTrue();
      expect(assertInDelta(easeSinIn(0.5), 0.292893)).assertTrue();
      expect(assertInDelta(easeSinIn(0.6), 0.412215)).assertTrue();
      expect(assertInDelta(easeSinIn(0.7), 0.546010)).assertTrue();
      expect(assertInDelta(easeSinIn(0.8), 0.690983)).assertTrue();
      expect(assertInDelta(easeSinIn(0.9), 0.843566)).assertTrue();
      expect(easeSinIn(1.0)).assertEqual(1.0);
    });

    it("easeSinOut_returns_the_expected_results", 0, () => {
      let sinOut = out(easeSinIn);
      expect(easeSinOut(0.0)).assertEqual(0.00);
      expect(assertInDelta(easeSinOut(0.1), sinOut(0.1))).assertTrue();
      expect(assertInDelta(easeSinOut(0.2), sinOut(0.2))).assertTrue();
      expect(assertInDelta(easeSinOut(0.3), sinOut(0.3))).assertTrue();
      expect(assertInDelta(easeSinOut(0.4), sinOut(0.4))).assertTrue();
      expect(assertInDelta(easeSinOut(0.5), sinOut(0.5))).assertTrue();
      expect(assertInDelta(easeSinOut(0.6), sinOut(0.6))).assertTrue();
      expect(assertInDelta(easeSinOut(0.7), sinOut(0.7))).assertTrue();
      expect(assertInDelta(easeSinOut(0.8), sinOut(0.8))).assertTrue();
      expect(assertInDelta(easeSinOut(0.9), sinOut(0.9))).assertTrue();
      expect(easeSinOut(1.0)).assertEqual(1.0);
    });


    it("easeSinInOut_returns_the_expected_results", 0, () => {
      let sinInOut = inOut(easeSinIn);
      expect(assertInDelta(easeSinInOut(0.0), sinInOut(0.0))).assertTrue();
      expect(assertInDelta(easeSinInOut(0.1), sinInOut(0.1))).assertTrue();
      expect(assertInDelta(easeSinInOut(0.2), sinInOut(0.2))).assertTrue();
      expect(assertInDelta(easeSinInOut(0.3), sinInOut(0.3))).assertTrue();
      expect(assertInDelta(easeSinInOut(0.4), sinInOut(0.4))).assertTrue();
      expect(assertInDelta(easeSinInOut(0.5), sinInOut(0.5))).assertTrue();
      expect(assertInDelta(easeSinInOut(0.6), sinInOut(0.6))).assertTrue();
      expect(assertInDelta(easeSinInOut(0.7), sinInOut(0.7))).assertTrue();
      expect(assertInDelta(easeSinInOut(0.8), sinInOut(0.8))).assertTrue();
      expect(assertInDelta(easeSinInOut(0.9), sinInOut(0.9))).assertTrue();
      expect(assertInDelta(easeSinInOut(0.0), sinInOut(0.0))).assertTrue();
    });
  })
}