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
import {easeBounce, easeBounceIn, easeBounceOut, easeBounceInOut} from "d3-ease";
import {out, inOut} from "./generic"
import {assertInDelta} from "./asserts";

export default function easeBounceTest() {

  describe('easeBounceTest', () => {

    it("easeBounce_is_an_alias_for_easeBounceOut", 0, () => {
      expect(easeBounce).assertEqual(easeBounceOut);
    });

    it("easeBounceIn_returns_the_expected_results", 0, () => {
      expect(easeBounceIn(0.0)).assertEqual(0.00);
      expect(assertInDelta(easeBounceIn(0.1), 0.011875)).assertTrue();
      expect(assertInDelta(easeBounceIn(0.2), 0.060000)).assertTrue();
      expect(assertInDelta(easeBounceIn(0.3), 0.069375)).assertTrue();
      expect(assertInDelta(easeBounceIn(0.4), 0.227500)).assertTrue();
      expect(assertInDelta(easeBounceIn(0.5), 0.234375)).assertTrue();
      expect(assertInDelta(easeBounceIn(0.6), 0.090000)).assertTrue();
      expect(assertInDelta(easeBounceIn(0.7), 0.319375)).assertTrue();
      expect(assertInDelta(easeBounceIn(0.8), 0.697500)).assertTrue();
      expect(assertInDelta(easeBounceIn(0.9), 0.924375)).assertTrue();
      expect(easeBounceIn(1.0)).assertEqual(1.0);
    });

    it("easeBounceOut_returns_the_expected_results", 0, () => {
      let bounceOut = out(easeBounceIn);
      expect(easeBounceOut(0.0)).assertEqual(0.00);
      expect(assertInDelta(easeBounceOut(0.1), bounceOut(0.1))).assertTrue();
      expect(assertInDelta(easeBounceOut(0.2), bounceOut(0.2))).assertTrue();
      expect(assertInDelta(easeBounceOut(0.3), bounceOut(0.3))).assertTrue();
      expect(assertInDelta(easeBounceOut(0.4), bounceOut(0.4))).assertTrue();
      expect(assertInDelta(easeBounceOut(0.5), bounceOut(0.5))).assertTrue();
      expect(assertInDelta(easeBounceOut(0.6), bounceOut(0.6))).assertTrue();
      expect(assertInDelta(easeBounceOut(0.7), bounceOut(0.7))).assertTrue();
      expect(assertInDelta(easeBounceOut(0.8), bounceOut(0.8))).assertTrue();
      expect(assertInDelta(easeBounceOut(0.9), bounceOut(0.9))).assertTrue();
      expect(easeBounceOut(1.0)).assertEqual(1.0);
    });


    it("easeBounceInOut_returns_the_expected_results", 0, () => {
      let bounceInOut = inOut(easeBounceIn);
      expect(assertInDelta(easeBounceInOut(0.0), bounceInOut(0.0))).assertTrue();
      expect(assertInDelta(easeBounceInOut(0.1), bounceInOut(0.1))).assertTrue();
      expect(assertInDelta(easeBounceInOut(0.2), bounceInOut(0.2))).assertTrue();
      expect(assertInDelta(easeBounceInOut(0.3), bounceInOut(0.3))).assertTrue();
      expect(assertInDelta(easeBounceInOut(0.4), bounceInOut(0.4))).assertTrue();
      expect(assertInDelta(easeBounceInOut(0.5), bounceInOut(0.5))).assertTrue();
      expect(assertInDelta(easeBounceInOut(0.6), bounceInOut(0.6))).assertTrue();
      expect(assertInDelta(easeBounceInOut(0.7), bounceInOut(0.7))).assertTrue();
      expect(assertInDelta(easeBounceInOut(0.8), bounceInOut(0.8))).assertTrue();
      expect(assertInDelta(easeBounceInOut(0.9), bounceInOut(0.9))).assertTrue();
      expect(assertInDelta(easeBounceInOut(0.0), bounceInOut(0.0))).assertTrue();
    });
  })
}