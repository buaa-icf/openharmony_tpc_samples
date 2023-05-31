/*
 * Copyright (C) 2023 Huawei Device Co., Ltd.
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
import BigNumber from 'bignumber.js';
import Test from './tester';

export default function minmax() {
  describe('minmaxtest', function () {

    function t(value) {
      new Test().isTrue(value);
    }
    function tb(min, max, arr) {
      new Test().isTrue(new BigNumber(min).eq(BigNumber.min.apply(null, arr)));
      new Test().isTrue(new BigNumber(max).eq(BigNumber.max.apply(null, arr)));
    }
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
    it('minmax', 0, function () {
      BigNumber.config({
        DECIMAL_PLACES: 20,
        ROUNDING_MODE: 4,
        EXPONENTIAL_AT: [-7, 21],
        RANGE: 1e9
      });

      new Test().areEqual(BigNumber.maximum, BigNumber.max);
      new Test().areEqual(BigNumber.minimum, BigNumber.min);

      t(!BigNumber.min(0, 0, 0).isNaN());
      t(BigNumber.min(NaN, -2, 0, -1).isNaN());
      t(BigNumber.max(NaN, -2, 0, -1).isNaN());
      t(BigNumber.min(-2, 0, -1, new BigNumber(NaN)).isNaN());
      t(BigNumber.max(-2, 0, -1, new BigNumber(NaN)).isNaN());

      t(!BigNumber.min(-2, 0, -1).isNaN());
      t(!BigNumber.max(-2, 0, -1).isNaN());
      t(!BigNumber.min(-2, 0, -1, Infinity).isNaN());
      t(!BigNumber.max(-2, 0, -1, -Infinity).isNaN());
      t(!BigNumber.min(-2, 0, -1, Infinity).isNaN());
      t(!BigNumber.max(-2, 0, -1, Infinity).isNaN());
      t(!BigNumber.min(-2, -Infinity, 0, -1, Infinity).isNaN());

      t(new BigNumber(-Infinity).eq(BigNumber.min(-Infinity, -2, 0, -1, Infinity)));
      t(new BigNumber(-Infinity).eq(BigNumber.min(Infinity, -2, 0, -1, -Infinity)));
      t(new BigNumber(Infinity).eq(BigNumber.max(Infinity, -2, 0, -1, -Infinity)));
      t(new BigNumber(Infinity).eq(BigNumber.max(-Infinity, -2, 0, new BigNumber(Infinity), -1)));

      t(new BigNumber(-2).eq(BigNumber.min(-2, 0, -1)));
      t(new BigNumber(0).eq(BigNumber.max(-2, 0, -1)));
      t(new BigNumber(-2).eq(BigNumber.min(-2, -1, 0)));
      t(new BigNumber(0).eq(BigNumber.max(-2, -1, 0)));
      t(new BigNumber(-2).eq(BigNumber.min(0, -2, -1)));
      t(new BigNumber(0).eq(BigNumber.max(0, -2, -1)));
      t(new BigNumber(-2).eq(BigNumber.min(0, -1, -2)));
      t(new BigNumber(0).eq(BigNumber.max(0, -1, -2)));
      t(new BigNumber(-2).eq(BigNumber.min(-1, -2, 0)));
      t(new BigNumber(0).eq(BigNumber.max(-1, -2, 0)));
      t(new BigNumber(-2).eq(BigNumber.min(-1, 0, -2)));

      t(new BigNumber(-1).eq(BigNumber.min(-1, 0, 1)));
      t(new BigNumber(1).eq(BigNumber.max(-1, 0, 1)));
      t(new BigNumber(-1).eq(BigNumber.min(-1, 1, 0)));
      t(new BigNumber(1).eq(BigNumber.max(-1, 1, 0)));
      t(new BigNumber(-1).eq(BigNumber.min(0, -1, 1)));
      t(new BigNumber(1).eq(BigNumber.max(0, -1, 1)));
      t(new BigNumber(-1).eq(BigNumber.min(0, 1, -1)));
      t(new BigNumber(1).eq(BigNumber.max(0, 1, -1)));
      t(new BigNumber(-1).eq(BigNumber.min(1, -1, 0)));
      t(new BigNumber(1).eq(BigNumber.max(1, -1, 0)));
      t(new BigNumber(-1).eq(BigNumber.min(1, 0, -1)));

      t(new BigNumber(-1).eq(BigNumber.min('-1', 0, new BigNumber(1))));
      t(new BigNumber(1).eq(BigNumber.max('-1', 0, new BigNumber(1))));
      t(new BigNumber(-1).eq(BigNumber.min('-1', new BigNumber(1), 0)));
      t(new BigNumber(1).eq(BigNumber.max('-1', new BigNumber(1), 0)));
      t(new BigNumber(-1).eq(BigNumber.min(0, '-1', new BigNumber(1))));
      t(new BigNumber(1).eq(BigNumber.max(0, '-1', new BigNumber(1))));
      t(new BigNumber(-1).eq(BigNumber.min(0, new BigNumber(1), '-1')));
      t(new BigNumber(1).eq(BigNumber.max(0, new BigNumber(1), '-1')));
      t(new BigNumber(-1).eq(BigNumber.min(new BigNumber(1), '-1', 0)));
      t(new BigNumber(1).eq(BigNumber.max(new BigNumber(1), '-1', 0)));
      t(new BigNumber(-1).eq(BigNumber.min(new BigNumber(1), 0, '-1')));

      t(new BigNumber(0).eq(BigNumber.min(0, 1, 2)));
      t(new BigNumber(2).eq(BigNumber.max(0, 1, 2)));
      t(new BigNumber(0).eq(BigNumber.min(0, 2, 1)));
      t(new BigNumber(2).eq(BigNumber.max(0, 2, 1)));
      t(new BigNumber(0).eq(BigNumber.min(1, 0, 2)));
      t(new BigNumber(2).eq(BigNumber.max(1, 0, 2)));
      t(new BigNumber(0).eq(BigNumber.min(1, 2, 0)));
      t(new BigNumber(2).eq(BigNumber.max(1, 2, 0)));
      t(new BigNumber(0).eq(BigNumber.min(2, 1, 0)));
      t(new BigNumber(2).eq(BigNumber.max(2, 1, 0)));
      t(new BigNumber(0).eq(BigNumber.min(2, 0, 1)));
      t(new BigNumber(2).eq(BigNumber.max(2, 0, 1)));

      tb(-2, 0, [-2, -1, 0]);
      tb(-2, 0, [-2, 0, -1]);
      tb(-2, 0, [-1, -2, 0]);
      tb(-2, 0, [-1, 0, -2]);
      tb(-2, 0, [0, -2, -1]);
      tb(-2, 0, [0, -1, -2]);

      tb(-1, 1, [-1, 0, 1]);
      tb(-1, 1, [-1, 1, 0]);
      tb(-1, 1, [0, -1, 1]);
      tb(-1, 1, [0, 1, -1]);
      tb(-1, 1, [1, -1, 0]);
      tb(-1, 1, [1, 0, -1]);

      tb(0, 2, [0, 1, 2]);
      tb(0, 2, [0, 2, 1]);
      tb(0, 2, [1, 0, 2]);
      tb(0, 2, [1, 2, 0]);
      tb(0, 2, [2, 1, 0]);
      tb(0, 2, [2, 0, 1]);

      tb(-0.000001, 999.001, [2, -0, '1e-9000000000000000', 324.32423423, -0.000001, '999.001', 10]);
      tb('-9.99999e+9000000000000000', Infinity, [10, '-9.99999e+9000000000000000', new BigNumber(Infinity), '9.99999e+9000000000000000', 0]);
      tb('-9.999999e+9000000000000000', '1.01e+9000000000000000', ['-9.99998e+9000000000000000', '-9.999999e+9000000000000000', '9e+8999999999999999', '1.01e+9000000000000000', 1e+300]);
      tb(1, Infinity, [1, '1e+9000000000000001', 1e200]);
      tb(-Infinity, 1, [1, '-1e+9000000000000001', -1e200]);
      tb(0, 1, [1, '1e-9000000000000001', 1e-200]);
      tb(0, 1, [1, '-1e-9000000000000001', 1e-200]);
      tb(-3, 3, [1, '2', 3, '-1', -2, '-3']);

    })
  })
}