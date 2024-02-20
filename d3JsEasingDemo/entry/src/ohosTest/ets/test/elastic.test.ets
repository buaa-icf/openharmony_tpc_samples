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

    it("easeElasticIn_coerces_t_to_a_number", 0, () => {
      expect(easeElasticIn('.9')).assertEqual(easeElasticIn(.9));
      expect(easeElasticIn({ valueOf: () => 0.9 })).assertEqual(easeElasticIn(.9));
    });

    it("easeElasticIn_t_is_the_same_as_elasticIn.amplitude_1._period_0.3_t", 0, () => {
      expect(easeElasticIn(0.1)).assertEqual(easeElasticIn.amplitude(1).period(0.3)(0.1));
      expect(easeElasticIn(0.2)).assertEqual(easeElasticIn.amplitude(1).period(0.3)(0.2));
      expect(easeElasticIn(0.3)).assertEqual(easeElasticIn.amplitude(1).period(0.3)(0.3));
    })

    it("easeElasticIn.amplitude_is_the_same_as_elasticIn_if_a_less_1", 0, () => {
      expect(easeElasticIn.amplitude(-1.0)(0.1)).assertEqual(easeElasticIn(0.1));
      expect(easeElasticIn.amplitude(+0.4)(0.2)).assertEqual(easeElasticIn(0.2));
      expect(easeElasticIn.amplitude(+0.8)(0.3)).assertEqual(easeElasticIn(0.3));
    });

    it("easeElasticIn.amplitude_a_.period_p_t_coerces_t_a_and_p_to_numbers", 0, () => {
      expect(easeElasticIn.amplitude("1.3").period("0.2")(".9")).assertEqual(easeElasticIn.amplitude(1.3).period(0.2)(.9));
      expect(easeElasticIn.amplitude({valueOf: () => 1.3 }).period({valueOf: () => 0.2 })({valueOf: () => .9 }))
        .assertEqual(easeElasticIn.amplitude(1.3).period(0.2)(.9));
    });

    it("easeElasticIn.amplitude_1.3_returns_the_expected_results", 0, () => {
      expect(easeElasticIn.amplitude(1.3)(0.0)).assertEqual(0.000000);
      expect(assertInDelta(easeElasticIn.amplitude(1.3)(0.1), 0.000978)).assertTrue();
      expect(assertInDelta(easeElasticIn.amplitude(1.3)(0.2), -0.003576)).assertTrue();
      expect(assertInDelta(easeElasticIn.amplitude(1.3)(0.3), 0.001501)).assertTrue();
      expect(assertInDelta(easeElasticIn.amplitude(1.3)(0.4), 0.014663)).assertTrue();
      expect(assertInDelta(easeElasticIn.amplitude(1.3)(0.5), -0.036951)).assertTrue();
      expect(assertInDelta(easeElasticIn.amplitude(1.3)(0.6), 0.013510)).assertTrue();
      expect(assertInDelta(easeElasticIn.amplitude(1.3)(0.7), 0.124145)).assertTrue();
      expect(assertInDelta(easeElasticIn.amplitude(1.3)(0.8), -0.303950)).assertTrue();
      expect(assertInDelta(easeElasticIn.amplitude(1.3)(0.9), 0.109580)).assertTrue();
      expect(easeElasticIn.amplitude(1.3)(1.0)).assertEqual(1.000000);
    })

    it("easeElasticIn.amplitude_1.5.period_1_returns_the_expected_results", 0, () => {
      expect(easeElasticIn.amplitude(1.5).period(1)(0.0)).assertEqual(0.000000);
      expect(assertInDelta(easeElasticIn.amplitude(1.5).period(1)(0.1), 0.000148)).assertTrue();
      expect(assertInDelta(easeElasticIn.amplitude(1.5).period(1)(0.2), -0.002212)).assertTrue();
      expect(assertInDelta(easeElasticIn.amplitude(1.5).period(1)(0.3), -0.009390)).assertTrue();
      expect(assertInDelta(easeElasticIn.amplitude(1.5).period(1)(0.4), -0.021498)).assertTrue();
      expect(assertInDelta(easeElasticIn.amplitude(1.5).period(1)(0.5), -0.030303)).assertTrue();
      expect(assertInDelta(easeElasticIn.amplitude(1.5).period(1)(0.6), -0.009352)).assertTrue();
      expect(assertInDelta(easeElasticIn.amplitude(1.5).period(1)(0.7), 0.093642)).assertTrue();
      expect(assertInDelta(easeElasticIn.amplitude(1.5).period(1)(0.8), 0.342077)).assertTrue();
      expect(assertInDelta(easeElasticIn.amplitude(1.5).period(1)(0.9), 0.732374)).assertTrue();
      expect(easeElasticIn.amplitude(1.5).period(1)(1.0)).assertEqual(1.000000);
    })

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

    it("easeElasticOut.amplitude_a_.period_p_t_coerces_t_a_and_p_to_numbers", 0, () => {
      expect(easeElasticOut.amplitude("1.3").period("0.2")(".9")).assertEqual(easeElasticOut.amplitude(1.3).period(0.2)(.9));
      expect(easeElasticOut.amplitude({valueOf: () => 1.3 }).period({valueOf: () => 0.2 })({valueOf: () => .9 }))
        .assertEqual(easeElasticOut.amplitude(1.3).period(0.2)(.9));
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

  it("easeElasticInOut.amplitude_a_.period_p_t_coerces_t_a_and_p_to_numbers", 0, () => {
    expect(easeElasticInOut.amplitude("1.3").period("0.2")(".9")).assertEqual(easeElasticInOut.amplitude(1.3).period(0.2)(.9));
    expect(easeElasticInOut.amplitude({valueOf: () => 1.3 }).period({valueOf: () => 0.2 })({valueOf: () => .9 }))
      .assertEqual(easeElasticInOut.amplitude(1.3).period(0.2)(.9));
  });
}