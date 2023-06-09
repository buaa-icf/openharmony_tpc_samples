/*
 * Copyright (C) 2022 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 * - The above copyright notice and this permission notice shall be included in
 *   all copies or substantial portions of the Software.
 * - The Software is provided "as is", without warranty of any kind, express or
 *   implied, including but not limited to the warranties of merchantability,
 *   fitness for a particular purpose and noninfringement. In no event shall the
 *   authors or copyright holders be liable for any claim, damages or other
 *   liability, whether in an action of contract, tort or otherwise, arising from,
 *   out of or in connection with the Software or the use or other dealings in the
 *   Software.
 */

import validator from 'validator';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'

export default function isAfterTest() {
  describe('isAfter', function () {
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

    function test(options) {
      const args = options.args || [];

      args.unshift(null);

      if (options.error) {
        options.error.forEach((error) => {
          args[0] = error;

          try {
            expect(validator[options.validator](...args)).assertFail()
          } catch (err) {
            console.log(`ValidatorsTest validator.${options.validator}(${args}) ` + err)
          }
        });
      }

      if (options.valid) {
        options.valid.forEach((valid) => {
          args[0] = valid;
          let resule: boolean = validator[options.validator](...args)
          expect(resule).assertTrue()
        });
      }

      if (options.invalid) {
        options.invalid.forEach((invalid) => {
          args[0] = invalid;
          let resule: boolean = validator[options.validator](...args)
          expect(resule).assertFalse()
        });
      }
    }

    it('should_validate_dates_against_a_start_date', 0, () => {
      test({
        validator: 'isAfter',
        args: [{
          comparisonDate: '2011-08-03'
        }],
        valid: ['2011-08-04', new Date(2011, 8, 10).toString()],
        invalid: ['2010-07-02', '2011-08-03', new Date(0).toString(), 'foo'],
      });

      test({
        validator: 'isAfter',
        valid: ['2100-08-04', new Date(Date.now() + 86400000).toString()],
        invalid: ['2010-07-02', new Date(0).toString()],
      });

      test({
        validator: 'isAfter',
        args: [{
          comparisonDate: '2011-08-03'
        }],
        valid: ['2015-09-17'],
        invalid: ['invalid date'],
      });

      test({
        validator: 'isAfter',
        args: [{
          comparisonDate: 'invalid date'
        }],
        invalid: ['invalid date', '2015-09-17'],
      });

      test({
        validator: 'isAfter',
        args: ['2011-08-03'],
        valid: ['2011-08-04', new Date(2011, 8, 10).toString()],
        invalid: ['2010-07-02', '2011-08-03', new Date(0).toString(), 'foo'],
      });

      test({
        validator: 'isAfter',
        valid: ['2100-08-04', new Date(Date.now() + 86400000).toString()],
        invalid: ['2010-07-02', new Date(0).toString()],
      });

      test({
        validator: 'isAfter',
        args: ['2011-08-03'],
        valid: ['2015-09-17'],
        invalid: ['invalid date'],
      });

      test({
        validator: 'isAfter',
        args: ['invalid date'],
        invalid: ['invalid date', '2015-09-17'],
      });
    })
  })
}