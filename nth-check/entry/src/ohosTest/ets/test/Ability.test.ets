/**
 *
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 *
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice,this
 * list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS,
 *
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import nthCheck, { compile, generate, parse, sequence } from 'nth-check';
import {valid} from './rule'

const valArray = new Array(...Array(2e3)).map((_:string, i) => i);

function slowNth(params: [number, number]): number[] {
  const a = params[0];
  const b = params[1];

  if (a === 0 && b > 0) {
    return [b - 1]; 
  }

  return valArray.filter((val) => {
    for (let i = b; a > 0 ? i <= valArray.length : i >= 1; i += a) {
      if (val === valArray[i - 1]) return true; 
    }
    return false; 
  });
}

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })

    it("compile", 0,() => {
      for (const compileTest of valid) {
        const filtered = valArray.filter(compile(compileTest[1]));
        const iterated = slowNth(compileTest[1]);
        expect(filtered).assertDeepEquals(iterated);
      }
    });

    it("parse", 0,() => {
      for (const parseTest of valid) {
        expect(parse(parseTest[0])).assertDeepEquals(parseTest[1]);
      }
    });

    it("nthCheck", 0,() => {
      for (const parsed of valid) {
        const filtered = valArray.filter(nthCheck(parsed[0]));
        const iterated = slowNth(parsed[1]);
        expect([filtered, parsed[0]]).assertDeepEquals([iterated, parsed[0]]);
      }
    });

    it("generate", 0, () => {
      const gen = generate([2, 2]);
      expect(gen()).assertEqual(1);
      expect(gen()).assertEqual(3);
      expect(gen()).assertEqual(5);
      expect(gen()).assertEqual(7);
      expect(gen()).assertEqual(9);
    });

    it("sequence", 0, () => {
      const gen = sequence("-2n+5");
      expect(gen()).assertEqual(0);
      expect(gen()).assertEqual(2);
      expect(gen()).assertEqual(4);
      expect(gen()).assertEqual(null);
    });
  })
}