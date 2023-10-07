/*
 * Copyright (C) 2021 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
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
  describe('MathTest', function () {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(function () {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(function () {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(function () {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(function () {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    it('addTest01',0, function () {
      let adds = add(1, 3);
      expect(adds).assertEqual(4);
    })

    it('addTest02',0, function () {
      let adds = add(134, 34);
      expect(adds).assertEqual(168);
    })

    it('ceilTest01',0, function () {
      let ceils = ceil(4.006);
      expect(ceils).assertEqual(5);
    })

    it('ceilTest02',0, function () {
      let ceils = ceil(6.004, 2);
      expect(ceils).assertEqual(6.01);
    })

    it('divideTest01',0, function () {
      let divided = divide(6, 4);
      expect(divided).assertEqual(1.5);
    })

    it('divideTest02',0, function () {
      let divided = divide(15, 3);
      expect(divided).assertEqual(5);
    })

    it('floorTest01',0, function () {
      let floorNumber = floor(4.006);
      expect(floorNumber).assertEqual(4);
    })

    it('floorTest02',0, function () {
      let floorNumber = floor(0.046, 2);
      expect(floorNumber).assertEqual(0.04);
    })

    it('maxTest01',0, function () {
      let maxNumber = max([4, 2, 8, 6]);
      expect(maxNumber).assertEqual(8);
    })

    it('maxTest02',0, function () {
      let maxNumber = max([]);
      expect(maxNumber).assertUndefined();
    })

    it('maxByTest01',0, function () {
      let objects = [{ 'n': 1 }, { 'n': 2 }];
      let maxByNumber = maxBy(objects, function(o) { return o.n; });
      expect(JSON.stringify(maxByNumber)).assertEqual('{"n":2}');
    })

    it('maxByTest02',0, function () {
      let objects = [{ 'n': 1 }, { 'n': 2 }];
      let maxByNumber = maxBy(objects, 'n');
      expect(JSON.stringify(maxByNumber)).assertEqual('{"n":2}');
    })

    it('meanTest01',0, function () {
      expect(mean([4, 2, 8, 6])).assertEqual(5);
    })

    it('meanTest02',0, function () {
      expect(mean([45, 8, 16, 45, 10, 98])).assertEqual(37);
    })

    it('meanByTest01',0, function () {
      let objects = [{ 'n': 4 }, { 'n': 2 }, { 'n': 8 }, { 'n': 6 }];

      let mean = meanBy(objects, function(o) { return o.n; });
      expect(mean).assertEqual(5);
    })

    it('meanByTest02',0, function () {
      let objects = [{ 'n': 4 }, { 'n': 2 }, { 'n': 8 }, { 'n': 6 }];

      let mean = meanBy(objects, 'n');
      expect(mean).assertEqual(5);
    })

    it('minTest01',0, function () {
      expect(min([4, 2, 8, 6])).assertEqual(2);
    })

    it('minTest02',0, function () {
      expect(min([])).assertUndefined();
    })

    it('minByTest01',0, function () {
      let objects = [{ 'n': 1 }, { 'n': 2 }];
      let min = minBy(objects, function(o) { return o.n; });
      expect(JSON.stringify(min)).assertEqual('{"n":1}');
    })

    it('minByTest02',0, function () {
      let objects = [{ 'n': 1 }, { 'n': 2 }];
      let min = minBy(objects, 'n');
      expect(JSON.stringify(min)).assertEqual('{"n":1}');
    })

    it('multiplyTest01',0, function () {
      expect(multiply(6, 4)).assertEqual(24);
    })

    it('multiplyTest02',0, function () {
      expect(multiply(3, 12)).assertEqual(36);
    })

    it('roundTest01',0, function () {
      expect(round(4.006)).assertEqual(4);
    })

    it('roundTest02',0, function () {
      expect(round(4060, -2)).assertEqual(4100);
    })

    it('subtractTest01',0, function () {
      expect(subtract(6, 4)).assertEqual(2);
    })

    it('subtractTest02',0, function () {
      expect(subtract(3, 9)).assertEqual(-6);
    })

    it('sumTest01',0, function () {
      expect(sum([6, 4])).assertEqual(10);
    })

    it('sumTest02',0, function () {
      expect(sum([1, 3, 5, 3, 9])).assertEqual(21);
    })

    it('sumByTest01',0, function () {
      let objects = [{ 'n': 4 }, { 'n': 2 }, { 'n': 8 }, { 'n': 6 }];
      let sum = sumBy(objects, function(o) { return o.n; });
      expect(sum).assertEqual(20);
    })

    it('sumByTest02',0, function () {
      let objects = [{ 'n': 4 }, { 'n': 2 }, { 'n': 8 }, { 'n': 6 }];
      let sum = sumBy(objects, 'n');
      expect(sum).assertEqual(20);
    })
  })
}