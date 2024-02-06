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
import {easeElastic, easeElasticIn, easeElasticOut, easeElasticInOut} from "d3-ease";
import {out, inOut} from "./generic"
import {assertInDelta} from "./asserts";

export default function easeElasticTest() {

  describe('easeElasticTest', () => {

    it("easeElastic_is_an_alias_for_easeElasticOut", 0, () => {
      expect(easeElastic).assertEqual(easeElasticOut);
    });

    it("easeElasticIn_returns_the_expected_results", 0, () => {
      expect(easeElasticIn(0.0)).assertEqual(0.00);
      expect(assertInDelta(easeElasticIn(0.1), 0.000978)).assertTrue();
      expect(assertInDelta(easeElasticIn(0.2), -0.001466)).assertTrue();
      expect(assertInDelta(easeElasticIn(0.3), -0.003421)).assertTrue();
      expect(assertInDelta(easeElasticIn(0.4), 0.014663)).assertTrue();
      expect(assertInDelta(easeElasticIn(0.5), -0.015152)).assertTrue();
      expect(assertInDelta(easeElasticIn(0.6), -0.030792)).assertTrue();
      expect(assertInDelta(easeElasticIn(0.7), 0.124145)).assertTrue();
      expect(assertInDelta(easeElasticIn(0.8), -0.124633)).assertTrue();
      expect(assertInDelta(easeElasticIn(0.9), -0.249756)).assertTrue();
      expect(easeElasticIn(1.0)).assertEqual(1.0);
    });

    it("easeElasticOut_returns_the_expected_results", 0, () => {
      let elasticOut = out(easeElasticIn);
      expect(easeElasticOut(0.0)).assertEqual(0.00);
      expect(assertInDelta(easeElasticOut(0.1), elasticOut(0.1))).assertTrue();
      expect(assertInDelta(easeElasticOut(0.2), elasticOut(0.2))).assertTrue();
      expect(assertInDelta(easeElasticOut(0.3), elasticOut(0.3))).assertTrue();
      expect(assertInDelta(easeElasticOut(0.4), elasticOut(0.4))).assertTrue();
      expect(assertInDelta(easeElasticOut(0.5), elasticOut(0.5))).assertTrue();
      expect(assertInDelta(easeElasticOut(0.6), elasticOut(0.6))).assertTrue();
      expect(assertInDelta(easeElasticOut(0.7), elasticOut(0.7))).assertTrue();
      expect(assertInDelta(easeElasticOut(0.8), elasticOut(0.8))).assertTrue();
      expect(assertInDelta(easeElasticOut(0.9), elasticOut(0.9))).assertTrue();
      expect(easeElasticOut(1.0)).assertEqual(1.0);
    });


    it("easeElasticInOut_returns_the_expected_results", 0, () => {
      let elasticInOut = inOut(easeElasticIn);
      expect(assertInDelta(easeElasticInOut(0.0), elasticInOut(0.0))).assertTrue();
      expect(assertInDelta(easeElasticInOut(0.1), elasticInOut(0.1))).assertTrue();
      expect(assertInDelta(easeElasticInOut(0.2), elasticInOut(0.2))).assertTrue();
      expect(assertInDelta(easeElasticInOut(0.3), elasticInOut(0.3))).assertTrue();
      expect(assertInDelta(easeElasticInOut(0.4), elasticInOut(0.4))).assertTrue();
      expect(assertInDelta(easeElasticInOut(0.5), elasticInOut(0.5))).assertTrue();
      expect(assertInDelta(easeElasticInOut(0.6), elasticInOut(0.6))).assertTrue();
      expect(assertInDelta(easeElasticInOut(0.7), elasticInOut(0.7))).assertTrue();
      expect(assertInDelta(easeElasticInOut(0.8), elasticInOut(0.8))).assertTrue();
      expect(assertInDelta(easeElasticInOut(0.9), elasticInOut(0.9))).assertTrue();
      expect(assertInDelta(easeElasticInOut(0.0), elasticInOut(0.0))).assertTrue();
    });
  })
}