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
import { add,
  ceil,
  divide,
  floor,
  max, maxBy, mean, meanBy, min, minBy, multiply,
  round, subtract, sum,
  sumBy } from 'lodash';

export default function mathTest() {
  describe('MathTest', () => {
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
    class N{
      n: number = 0
    }
    it('addTest01',0, () => {
      let adds: number = add(1, 3);
      expect(adds).assertEqual(4);
    })

    it('addTest02',0, () => {
      let adds: number = add(134, 34);
      expect(adds).assertEqual(168);
    })

    it('ceilTest01',0, () => {
      let ceils: number = ceil(4.006);
      expect(ceils).assertEqual(5);
    })

    it('ceilTest02',0, () => {
      let ceils: number = ceil(6.004, 2);
      expect(ceils).assertEqual(6.01);
    })

    it('divideTest01',0, () => {
      let divided: number = divide(6, 4);
      expect(divided).assertEqual(1.5);
    })

    it('divideTest02',0, () => {
      let divided: number = divide(15, 3);
      expect(divided).assertEqual(5);
    })

    it('floorTest01',0, () => {
      let floorNumber: number = floor(4.006);
      expect(floorNumber).assertEqual(4);
    })

    it('floorTest02',0, () => {
      let floorNumber: number = floor(0.046, 2);
      expect(floorNumber).assertEqual(0.04);
    })

    it('maxTest01',0, () => {
      let maxNumber: number = max([4, 2, 8, 6]);
      expect(maxNumber).assertEqual(8);
    })

    it('maxTest02',0, () => {
      let maxNumber: number = max([]);
      expect(maxNumber).assertUndefined();
    })

    it('maxByTest01',0, () => {
      let objects: N[] = [{ n: 1 }, { n: 2 }];
      let maxByNumber: object = maxBy(objects,(o: N)=> { return o.n; });
      expect(JSON.stringify(maxByNumber)).assertEqual('{"n":2}');
    })

    it('maxByTest02',0, () => {
      let objects: N[] = [{ n: 1 }, { n: 2 }];
      let maxByNumber: object = maxBy(objects, 'n');
      expect(JSON.stringify(maxByNumber)).assertEqual('{"n":2}');
    })

    it('meanTest01',0, () => {
      expect(mean([4, 2, 8, 6])).assertEqual(5);
    })

    it('meanTest02',0, () => {
      expect(mean([45, 8, 16, 45, 10, 98])).assertEqual(37);
    })

    it('meanByTest01',0, () => {
      let objects: N[] = [{ n: 4 }, { n: 2 }, { n: 8 }, { n: 6 }];

      let mean: number = meanBy(objects, (o: N)=> { return o.n; });
      expect(mean).assertEqual(5);
    })

    it('meanByTest02',0, () => {
      let objects: N[] = [{ n: 4 }, { n: 2 }, { n: 8 }, { n: 6 }];

      let mean: number = meanBy(objects, 'n');
      expect(mean).assertEqual(5);
    })

    it('minTest01',0, () => {
      expect(min([4, 2, 8, 6])).assertEqual(2);
    })

    it('minTest02',0, () => {
      expect(min([])).assertUndefined();
    })

    it('minByTest01',0, () => {
      let objects: N[] = [{ n: 1 }, { n: 2 }];
      let min: object = minBy(objects, (o: N)=> { return o.n; });
      expect(JSON.stringify(min)).assertEqual('{"n":1}');
    })

    it('minByTest02',0, () => {
      let objects: N[] = [{ n: 1 }, { n: 2 }];
      let min: object = minBy(objects, 'n');
      expect(JSON.stringify(min)).assertEqual('{"n":1}');
    })

    it('multiplyTest01',0, () => {
      expect(multiply(6, 4)).assertEqual(24);
    })

    it('multiplyTest02',0, () => {
      expect(multiply(3, 12)).assertEqual(36);
    })

    it('roundTest01',0, () => {
      expect(round(4.006)).assertEqual(4);
    })

    it('roundTest02',0, () => {
      expect(round(4060, -2)).assertEqual(4100);
    })

    it('subtractTest01',0, () => {
      expect(subtract(6, 4)).assertEqual(2);
    })

    it('subtractTest02',0, () => {
      expect(subtract(3, 9)).assertEqual(-6);
    })

    it('sumTest01',0, () => {
      expect(sum([6, 4])).assertEqual(10);
    })

    it('sumTest02',0, () => {
      expect(sum([1, 3, 5, 3, 9])).assertEqual(21);
    })

    it('sumByTest01',0, () => {
      let objects: N[] = [{ n: 4 }, { n: 2 }, { n: 8 }, { n: 6 }];
      let sum: number = sumBy(objects, (o: N)=> { return o.n; });
      expect(sum).assertEqual(20);
    })

    it('sumByTest02',0, () => {
      let objects: N[] = [{ n: 4 }, { n: 2 }, { n: 8 }, { n: 6 }];
      let sum: number = sumBy(objects, 'n');
      expect(sum).assertEqual(20);
    })
  })
}