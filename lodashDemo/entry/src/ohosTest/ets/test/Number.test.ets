/**
 *  MIT License
 *
 *  Copyright (c) 2023 Huawei Device Co., Ltd.
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in all
 *  copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 *  SOFTWARE.
 */

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import {
  clamp,
  inRange,
  random } from 'lodash';

export default function numberTest() {
  describe('NumberTest', () => {
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
    it('clampTest01',0, () => {
      expect(clamp(-10, -5, 5)).assertEqual(-5);
    })

    it('clampTest02',0, () => {
      expect(clamp(10, -5, 5)).assertEqual(5);
    })

    it('inRangeTest01',0, () => {
      expect(inRange(3, 2, 4)).assertTrue();
    })

    it('inRangeTest02',0, () => {
      expect(inRange(2, 2)).assertFalse();
    })

    it('randomTest01',0, () => {
      let actual: number[] = [
      random(Number.MIN_VALUE, Number.MIN_VALUE),
      random('1', '1'),
      random(Math.PI, Math.PI)
      ];
      expect(JSON.stringify(actual)).assertEqual('[5e-324,1,3.141592653589793]');
    })

    it('randomTest02',0, () => {
      let actual: number[] = [
      random(Number.MIN_VALUE, Number.MIN_VALUE),
      ];
      expect(JSON.stringify(actual)).assertEqual('[5e-324]');
    })
  })
}