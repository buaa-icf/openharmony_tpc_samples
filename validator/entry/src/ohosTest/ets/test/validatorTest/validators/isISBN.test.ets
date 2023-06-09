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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import validator from 'validator';

export default function isISBNTest() {
  describe('isISBN', function () {
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

    it('should_validate_ISBNs', 0, () => {
      test({
        validator: 'isISBN',
        args: [{
          version: 10
        }],
        valid: [
          '3836221195', '3-8362-2119-5', '3 8362 2119 5',
          '1617290858', '1-61729-085-8', '1 61729 085-8',
          '0007269706', '0-00-726970-6', '0 00 726970 6',
          '3423214120', '3-423-21412-0', '3 423 21412 0',
          '340101319X', '3-401-01319-X', '3 401 01319 X',
        ],
        invalid: [
          '3423214121', '3-423-21412-1', '3 423 21412 1',
          '978-3836221191', '9783836221191',
          '123456789a', 'foo', '',
        ],
      });
      test({
        validator: 'isISBN',
        args: [{
          version: 13
        }],
        valid: [
          '9783836221191', '978-3-8362-2119-1', '978 3 8362 2119 1',
          '9783401013190', '978-3401013190', '978 3401013190',
          '9784873113685', '978-4-87311-368-5', '978 4 87311 368 5',
        ],
        invalid: [
          '9783836221190', '978-3-8362-2119-0', '978 3 8362 2119 0',
          '3836221195', '3-8362-2119-5', '3 8362 2119 5',
          '01234567890ab', 'foo', '',
        ],
      });
      test({
        validator: 'isISBN',
        valid: [
          '340101319X',
          '9784873113685',
        ],
        invalid: [
          '3423214121',
          '9783836221190',
        ],
      });
      test({
        validator: 'isISBN',
        args: [{
          version: 'foo'
        }],
        invalid: [
          '340101319X',
          '9784873113685',
        ],
      });
    })
  });
}

