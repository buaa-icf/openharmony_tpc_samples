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

export default function shiftedBy() {
  describe('shiftedBytest', function () {

    function t(expected, n, k) {
      new Test().areEqual(String(expected), String(new BigNumber(n).shiftedBy(k)));
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
    it('shiftedBy', 0, function () {
      BigNumber.config({
        DECIMAL_PLACES: 20,
        ROUNDING_MODE: 4,
        EXPONENTIAL_AT: [-7, 21],
        RANGE: 1e9,
        POW_PRECISION: 0
      });

      t(0, 0, 0);
      t(10, 1, 1);
      t(0.1, 1, -1);
      t(200, 2, 2);
      t(2e+31, 2, 31);
      t(0.02, 2, -2);
      t(0.0002, 2, -4);
      t(1e+100, 1, 100);
      t(9999990, 9999.99, 3);

      t(NaN, NaN, 0);
      t(NaN, NaN, -1);
      t(NaN, NaN, 1);
      t(NaN, NaN, 2);
      t(NaN, NaN, -2);

      t(Infinity, Infinity, 0);
      t(-Infinity, -Infinity, -1);
      t(Infinity, Infinity, 1);
      t(-Infinity, -Infinity, 2);
      t(Infinity, Infinity, -2);

      t(0, 0, 1000);
      t(0, 0, 2);
      t(0, 0, -2);
      t(2, 2, 0);

      new Test().areEqual('0', new BigNumber(0).shiftedBy(0).valueOf());
      new Test().areEqual('-0', new BigNumber(-0).shiftedBy(0).valueOf());
      new Test().areEqual('0', new BigNumber(0).shiftedBy(-0).valueOf());
      new Test().areEqual('-0', new BigNumber(-0).shiftedBy(-0).valueOf());
      new Test().areEqual('0', new BigNumber(0).shiftedBy(1000).valueOf());

      t('1e+1000000', 1, 1e6)
      t(1, '1e-1000000', 1e6)
      t('9.9e+999999999', 0.99, 1e+9);

      // @ts-ignore
      new Test().isException(function () {new BigNumber('12.345').shiftedBy(true)}, ".shiftedBy(true)");
      // @ts-ignore
      new Test().isException(function () {new BigNumber('12.345').shiftedBy(false)}, ".shiftedBy(false)");
      // @ts-ignore
      new Test().isException(function () {new BigNumber('12.345').shiftedBy([])}, ".shiftedBy([])");
      // @ts-ignore
      new Test().isException(function () {new BigNumber('12.345').shiftedBy({})}, ".shiftedBy({})");
      // @ts-ignore
      new Test().isException(function () {new BigNumber('12.345').shiftedBy('')}, ".shiftedBy('')");
      // @ts-ignore
      new Test().isException(function () {new BigNumber('12.345').shiftedBy(' ')}, ".shiftedBy(' ')");
      // @ts-ignore
      new Test().isException(function () {new BigNumber('12.345').shiftedBy('4e')}, ".shiftedBy('4e')");
      // @ts-ignore
      new Test().isException(function () {new BigNumber('12.345').shiftedBy('hello')}, ".shiftedBy('hello')");
      // @ts-ignore
      new Test().isException(function () {new BigNumber('12.345').shiftedBy('\t')}, ".shiftedBy('\t')");
      // @ts-ignore
      new Test().isException(function () {new BigNumber('12.345').shiftedBy(new Date)}, ".shiftedBy(new Date)");
      // @ts-ignore
      new Test().isException(function () {new BigNumber('12.345').shiftedBy(new RegExp)}, ".shiftedBy(new RegExp)");
      // @ts-ignore
      new Test().isException(function () {new BigNumber('12.345').shiftedBy(function (){})}, ".shiftedBy(function (){})");

      t('3.45345e+196', 0.000345345, 200);
      t('3.45345e-14', 0.000345345, -10);
    })
  })
}