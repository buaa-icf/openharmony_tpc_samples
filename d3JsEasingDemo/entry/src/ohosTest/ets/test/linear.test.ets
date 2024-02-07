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
import {easeLinear} from "d3-ease";
import {assertInDelta} from "./asserts";


export default function LinearEasingTest() {
  describe('linearTest', () => {

    it("easeLinear_returns_the_expected_results", 0, () => {
      // expect(0)
      expect(easeLinear(0)).assertEqual(0)
      expect(assertInDelta(easeLinear(0.1), 0.1)).assertTrue();
      expect(assertInDelta(easeLinear(0.2), 0.2)).assertTrue();
      expect(assertInDelta(easeLinear(0.3), 0.3)).assertTrue();
      expect(assertInDelta(easeLinear(0.4), 0.4)).assertTrue();
      expect(assertInDelta(easeLinear(0.5), 0.5)).assertTrue();
      expect(assertInDelta(easeLinear(0.6), 0.6)).assertTrue();
      expect(assertInDelta(easeLinear(0.7), 0.7)).assertTrue();
      expect(assertInDelta(easeLinear(0.8), 0.8)).assertTrue();
      expect(assertInDelta(easeLinear(0.9), 0.9)).assertTrue();
      expect(easeLinear(1)).assertEqual(1)
    });

  })
}

