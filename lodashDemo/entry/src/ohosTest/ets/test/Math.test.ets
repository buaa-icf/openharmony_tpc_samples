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
    class N {
      n: number = 0
    }
    it('addTest01', 0, () => {
      let startTime0 = new Date().getTime()
      console.info('appInfoTest xts addTest01 startTime:' + startTime0 + "us")
      let adds: number = add(1, 3);

      let endTime0 = new Date().getTime()
      console.info('appInfoTest xts addTest01 endTime:' + endTime0 + "us")
      let averageTime0 = endTime0 - startTime0
      console.info('appInfoTest xts addTest01 averageTime:' + averageTime0 + "us")
      expect(adds).assertEqual(4);
    })


    it('addTest02', 0, () => {
      let startTime1 = new Date().getTime()
      console.info('appInfoTest xts addTest02 startTime:' + startTime1 + "us")
      let adds: number = add(134, 34);

      let endTime1 = new Date().getTime()
      console.info('appInfoTest xts addTest02 endTime:' + endTime1 + "us")
      let averageTime1 = endTime1 - startTime1
      console.info('appInfoTest xts addTest02 averageTime:' + averageTime1 + "us")
      expect(adds).assertEqual(168);
    })


    it('ceilTest01', 0, () => {
      let startTime2 = new Date().getTime()
      console.info('appInfoTest xts ceilTest01 startTime:' + startTime2 + "us")
      let ceils: number = ceil(4.006);

      let endTime2 = new Date().getTime()
      console.info('appInfoTest xts ceilTest01 endTime:' + endTime2 + "us")
      let averageTime2 = endTime2 - startTime2
      console.info('appInfoTest xts ceilTest01 averageTime:' + averageTime2 + "us")
      expect(ceils).assertEqual(5);
    })


    it('ceilTest02', 0, () => {
      let startTime3 = new Date().getTime()
      console.info('appInfoTest xts ceilTest02 startTime:' + startTime3 + "us")
      let ceils: number = ceil(6.004, 2);

      let endTime3 = new Date().getTime()
      console.info('appInfoTest xts ceilTest02 endTime:' + endTime3 + "us")
      let averageTime3 = endTime3 - startTime3
      console.info('appInfoTest xts ceilTest02 averageTime:' + averageTime3 + "us")
      expect(ceils).assertEqual(6.01);
    })


    it('divideTest01', 0, () => {
      let startTime4 = new Date().getTime()
      console.info('appInfoTest xts divideTest01 startTime:' + startTime4 + "us")
      let divided: number = divide(6, 4);

      let endTime4 = new Date().getTime()
      console.info('appInfoTest xts divideTest01 endTime:' + endTime4 + "us")
      let averageTime4 = endTime4 - startTime4
      console.info('appInfoTest xts divideTest01 averageTime:' + averageTime4 + "us")
      expect(divided).assertEqual(1.5);
    })


    it('divideTest02', 0, () => {
      let startTime5 = new Date().getTime()
      console.info('appInfoTest xts divideTest02 startTime:' + startTime5 + "us")
      let divided: number = divide(15, 3);

      let endTime5 = new Date().getTime()
      console.info('appInfoTest xts divideTest02 endTime:' + endTime5 + "us")
      let averageTime5 = endTime5 - startTime5
      console.info('appInfoTest xts divideTest02 averageTime:' + averageTime5 + "us")
      expect(divided).assertEqual(5);
    })


    it('floorTest01', 0, () => {
      let startTime6 = new Date().getTime()
      console.info('appInfoTest xts floorTest01 startTime:' + startTime6 + "us")
      let floorNumber: number = floor(4.006);

      let endTime6 = new Date().getTime()
      console.info('appInfoTest xts floorTest01 endTime:' + endTime6 + "us")
      let averageTime6 = endTime6 - startTime6
      console.info('appInfoTest xts floorTest01 averageTime:' + averageTime6 + "us")
      expect(floorNumber).assertEqual(4);
    })


    it('floorTest02', 0, () => {
      let startTime7 = new Date().getTime()
      console.info('appInfoTest xts floorTest02 startTime:' + startTime7 + "us")
      let floorNumber: number = floor(0.046, 2);

      let endTime7 = new Date().getTime()
      console.info('appInfoTest xts floorTest02 endTime:' + endTime7 + "us")
      let averageTime7 = endTime7 - startTime7
      console.info('appInfoTest xts floorTest02 averageTime:' + averageTime7 + "us")
      expect(floorNumber).assertEqual(0.04);
    })


    it('maxTest01', 0, () => {
      let startTime8 = new Date().getTime()
      console.info('appInfoTest xts maxTest01 startTime:' + startTime8 + "us")
      let maxNumber: number = max([4, 2, 8, 6]);

      let endTime8 = new Date().getTime()
      console.info('appInfoTest xts maxTest01 endTime:' + endTime8 + "us")
      let averageTime8 = endTime8 - startTime8
      console.info('appInfoTest xts maxTest01 averageTime:' + averageTime8 + "us")
      expect(maxNumber).assertEqual(8);
    })


    it('maxTest02', 0, () => {
      let startTime9 = new Date().getTime()
      console.info('appInfoTest xts maxTest02 startTime:' + startTime9 + "us")
      let maxNumber: number = max([]);

      let endTime9 = new Date().getTime()
      console.info('appInfoTest xts maxTest02 endTime:' + endTime9 + "us")
      let averageTime9 = endTime9 - startTime9
      console.info('appInfoTest xts maxTest02 averageTime:' + averageTime9 + "us")
      expect(maxNumber).assertUndefined();
    })


    it('maxByTest01', 0, () => {
      let startTime10 = new Date().getTime()
      console.info('appInfoTest xts maxByTest01 startTime:' + startTime10 + "us")
      let objects: N[] = [{
        n: 1
      }, {
        n: 2
      }];

      let maxByNumber: object = maxBy(objects, (o: N) => {
        return o.n;
      });

      let endTime10 = new Date().getTime()
      console.info('appInfoTest xts maxByTest01 endTime:' + endTime10 + "us")
      let averageTime10 = endTime10 - startTime10
      console.info('appInfoTest xts maxByTest01 averageTime:' + averageTime10 + "us")
      expect(JSON.stringify(maxByNumber)).assertEqual('{"n":2}');
    })


    it('maxByTest02', 0, () => {
      let startTime11 = new Date().getTime()
      console.info('appInfoTest xts maxByTest02 startTime:' + startTime11 + "us")
      let objects: N[] = [{
        n: 1
      }, {
        n: 2
      }];

      let maxByNumber: object = maxBy(objects, 'n');

      let endTime11 = new Date().getTime()
      console.info('appInfoTest xts maxByTest02 endTime:' + endTime11 + "us")
      let averageTime11 = endTime11 - startTime11
      console.info('appInfoTest xts maxByTest02 averageTime:' + averageTime11 + "us")
      expect(JSON.stringify(maxByNumber)).assertEqual('{"n":2}');
    })


    it('meanTest01', 0, () => {
      let startTime12 = new Date().getTime()
      console.info('appInfoTest xts meanTest01 startTime:' + startTime12 + "us")
      expect(mean([4, 2, 8, 6])).assertEqual(5);
      let endTime12 = new Date().getTime()
      console.info('appInfoTest xts meanTest01 endTime:' + endTime12 + "us")
      let averageTime12 = endTime12 - startTime12
      console.info('appInfoTest xts meanTest01 averageTime:' + averageTime12 + "us")
    })


    it('meanTest02', 0, () => {
      let startTime13 = new Date().getTime()
      console.info('appInfoTest xts meanTest02 startTime:' + startTime13 + "us")
      expect(mean([45, 8, 16, 45, 10, 98])).assertEqual(37);
      let endTime13 = new Date().getTime()
      console.info('appInfoTest xts meanTest02 endTime:' + endTime13 + "us")
      let averageTime13 = endTime13 - startTime13
      console.info('appInfoTest xts meanTest02 averageTime:' + averageTime13 + "us")
    })


    it('meanByTest01', 0, () => {
      let startTime14 = new Date().getTime()
      console.info('appInfoTest xts meanByTest01 startTime:' + startTime14 + "us")
      let objects: N[] = [{
        n: 4
      }, {
        n: 2
      }, {
        n: 8
      }, {
        n: 6
      }];


      let mean: number = meanBy(objects, (o: N) => {
        return o.n;
      });

      let endTime14 = new Date().getTime()
      console.info('appInfoTest xts meanByTest01 endTime:' + endTime14 + "us")
      let averageTime14 = endTime14 - startTime14
      console.info('appInfoTest xts meanByTest01 averageTime:' + averageTime14 + "us")
      expect(mean).assertEqual(5);
    })


    it('meanByTest02', 0, () => {
      let startTime15 = new Date().getTime()
      console.info('appInfoTest xts meanByTest02 startTime:' + startTime15 + "us")
      let objects: N[] = [{
        n: 4
      }, {
        n: 2
      }, {
        n: 8
      }, {
        n: 6
      }];


      let mean: number = meanBy(objects, 'n');

      let endTime15 = new Date().getTime()
      console.info('appInfoTest xts meanByTest02 endTime:' + endTime15 + "us")
      let averageTime15 = endTime15 - startTime15
      console.info('appInfoTest xts meanByTest02 averageTime:' + averageTime15 + "us")
      expect(mean).assertEqual(5);
    })


    it('minTest01', 0, () => {
      let startTime16 = new Date().getTime()
      console.info('appInfoTest xts minTest01 startTime:' + startTime16 + "us")
      expect(min([4, 2, 8, 6])).assertEqual(2);
      let endTime16 = new Date().getTime()
      console.info('appInfoTest xts minTest01 endTime:' + endTime16 + "us")
      let averageTime16 = endTime16 - startTime16
      console.info('appInfoTest xts minTest01 averageTime:' + averageTime16 + "us")
    })


    it('minTest02', 0, () => {
      let startTime17 = new Date().getTime()
      console.info('appInfoTest xts minTest02 startTime:' + startTime17 + "us")
      expect(min([])).assertUndefined();
      let endTime17 = new Date().getTime()
      console.info('appInfoTest xts minTest02 endTime:' + endTime17 + "us")
      let averageTime17 = endTime17 - startTime17
      console.info('appInfoTest xts minTest02 averageTime:' + averageTime17 + "us")
    })


    it('minByTest01', 0, () => {
      let startTime18 = new Date().getTime()
      console.info('appInfoTest xts minByTest01 startTime:' + startTime18 + "us")
      let objects: N[] = [{
        n: 1
      }, {
        n: 2
      }];

      let min: object = minBy(objects, (o: N) => {
        return o.n;
      });

      let endTime18 = new Date().getTime()
      console.info('appInfoTest xts minByTest01 endTime:' + endTime18 + "us")
      let averageTime18 = endTime18 - startTime18
      console.info('appInfoTest xts minByTest01 averageTime:' + averageTime18 + "us")
      expect(JSON.stringify(min)).assertEqual('{"n":1}');
    })


    it('minByTest02', 0, () => {
      let startTime19 = new Date().getTime()
      console.info('appInfoTest xts minByTest02 startTime:' + startTime19 + "us")
      let objects: N[] = [{
        n: 1
      }, {
        n: 2
      }];

      let min: object = minBy(objects, 'n');

      let endTime19 = new Date().getTime()
      console.info('appInfoTest xts minByTest02 endTime:' + endTime19 + "us")
      let averageTime19 = endTime19 - startTime19
      console.info('appInfoTest xts minByTest02 averageTime:' + averageTime19 + "us")
      expect(JSON.stringify(min)).assertEqual('{"n":1}');
    })


    it('multiplyTest01', 0, () => {
      let startTime20 = new Date().getTime()
      console.info('appInfoTest xts multiplyTest01 startTime:' + startTime20 + "us")
      expect(multiply(6, 4)).assertEqual(24);
      let endTime20 = new Date().getTime()
      console.info('appInfoTest xts multiplyTest01 endTime:' + endTime20 + "us")
      let averageTime20 = endTime20 - startTime20
      console.info('appInfoTest xts multiplyTest01 averageTime:' + averageTime20 + "us")
    })


    it('multiplyTest02', 0, () => {
      let startTime21 = new Date().getTime()
      console.info('appInfoTest xts multiplyTest02 startTime:' + startTime21 + "us")
      expect(multiply(3, 12)).assertEqual(36);
      let endTime21 = new Date().getTime()
      console.info('appInfoTest xts multiplyTest02 endTime:' + endTime21 + "us")
      let averageTime21 = endTime21 - startTime21
      console.info('appInfoTest xts multiplyTest02 averageTime:' + averageTime21 + "us")
    })


    it('roundTest01', 0, () => {
      let startTime22 = new Date().getTime()
      console.info('appInfoTest xts roundTest01 startTime:' + startTime22 + "us")
      expect(round(4.006)).assertEqual(4);
      let endTime22 = new Date().getTime()
      console.info('appInfoTest xts roundTest01 endTime:' + endTime22 + "us")
      let averageTime22 = endTime22 - startTime22
      console.info('appInfoTest xts roundTest01 averageTime:' + averageTime22 + "us")
    })


    it('roundTest02', 0, () => {
      let startTime23 = new Date().getTime()
      console.info('appInfoTest xts roundTest02 startTime:' + startTime23 + "us")
      expect(round(4060, -2)).assertEqual(4100);
      let endTime23 = new Date().getTime()
      console.info('appInfoTest xts roundTest02 endTime:' + endTime23 + "us")
      let averageTime23 = endTime23 - startTime23
      console.info('appInfoTest xts roundTest02 averageTime:' + averageTime23 + "us")
    })


    it('subtractTest01', 0, () => {
      let startTime24 = new Date().getTime()
      console.info('appInfoTest xts subtractTest01 startTime:' + startTime24 + "us")
      expect(subtract(6, 4)).assertEqual(2);
      let endTime24 = new Date().getTime()
      console.info('appInfoTest xts subtractTest01 endTime:' + endTime24 + "us")
      let averageTime24 = endTime24 - startTime24
      console.info('appInfoTest xts subtractTest01 averageTime:' + averageTime24 + "us")
    })


    it('subtractTest02', 0, () => {
      let startTime25 = new Date().getTime()
      console.info('appInfoTest xts subtractTest02 startTime:' + startTime25 + "us")
      expect(subtract(3, 9)).assertEqual(-6);
      let endTime25 = new Date().getTime()
      console.info('appInfoTest xts subtractTest02 endTime:' + endTime25 + "us")
      let averageTime25 = endTime25 - startTime25
      console.info('appInfoTest xts subtractTest02 averageTime:' + averageTime25 + "us")
    })


    it('sumTest01', 0, () => {
      let startTime26 = new Date().getTime()
      console.info('appInfoTest xts sumTest01 startTime:' + startTime26 + "us")
      expect(sum([6, 4])).assertEqual(10);
      let endTime26 = new Date().getTime()
      console.info('appInfoTest xts sumTest01 endTime:' + endTime26 + "us")
      let averageTime26 = endTime26 - startTime26
      console.info('appInfoTest xts sumTest01 averageTime:' + averageTime26 + "us")
    })


    it('sumTest02', 0, () => {
      let startTime27 = new Date().getTime()
      console.info('appInfoTest xts sumTest02 startTime:' + startTime27 + "us")
      expect(sum([1, 3, 5, 3, 9])).assertEqual(21);
      let endTime27 = new Date().getTime()
      console.info('appInfoTest xts sumTest02 endTime:' + endTime27 + "us")
      let averageTime27 = endTime27 - startTime27
      console.info('appInfoTest xts sumTest02 averageTime:' + averageTime27 + "us")
    })


    it('sumByTest01', 0, () => {
      let startTime28 = new Date().getTime()
      console.info('appInfoTest xts sumByTest01 startTime:' + startTime28 + "us")
      let objects: N[] = [{
        n: 4
      }, {
        n: 2
      }, {
        n: 8
      }, {
        n: 6
      }];

      let sum: number = sumBy(objects, (o: N) => {
        return o.n;
      });

      let endTime28 = new Date().getTime()
      console.info('appInfoTest xts sumByTest01 endTime:' + endTime28 + "us")
      let averageTime28 = endTime28 - startTime28
      console.info('appInfoTest xts sumByTest01 averageTime:' + averageTime28 + "us")
      expect(sum).assertEqual(20);
    })


    it('sumByTest02', 0, () => {
      let startTime29 = new Date().getTime()
      console.info('appInfoTest xts sumByTest02 startTime:' + startTime29 + "us")
      let objects: N[] = [{
        n: 4
      }, {
        n: 2
      }, {
        n: 8
      }, {
        n: 6
      }];

      let sum: number = sumBy(objects, 'n');

      let endTime29 = new Date().getTime()
      console.info('appInfoTest xts sumByTest02 endTime:' + endTime29 + "us")
      let averageTime29 = endTime29 - startTime29
      console.info('appInfoTest xts sumByTest02 averageTime:' + averageTime29 + "us")
      expect(sum).assertEqual(20);
    })
  })
}