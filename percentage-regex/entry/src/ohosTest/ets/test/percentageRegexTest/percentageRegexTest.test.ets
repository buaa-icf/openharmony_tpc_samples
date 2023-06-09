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

import percentageRegex from 'percentage-regex';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'

export default function percentageRegexTest() {
  describe('percentageRegexTest', function () {
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
    const shouldPass = [
      '19%',
      '10.0%',
      '1%',
      '1.0%',
      '1.00%',
      '1 %',
      '39 %',
      '1.00 %',
      '0%',
      '.5%',
      '.05%',
      '.05 %'
    ];

    const shouldFail = [
      '',
      '   ',
      'foobar',
      '10',
      '10.0',
      '10.00',
      '.5',
      '.5 ',
      '1..00%',
      '%%',
      '%',
      '.',
      ' %',
      '. 5%',
      '.%',
      '. %',
      '..5%',
      '. 5%',
      '.\t5%',
      '.5.5%',
      '12.%'
    ];
    it('exact_regex_should_match', 0, function () {
      shouldPass.forEach(fixture => {
        expect(percentageRegex({
          exact: true
        }).test(fixture)).assertTrue()
      })
    })

    it('exact_regex_should_not_match', 0, function () {
      shouldFail.forEach(fixture => {
        expect(percentageRegex({
          exact: true
        }).test(fixture)).assertFalse()
      })
    })

    it('non_exact_regex_should_match_all_percentages_in_a_string', 0, function () {
      expect('10%'.match(percentageRegex({
        exact: false
      })).toString()).assertEqual(['10%'].toString())
      expect('foo 10% bar'.match(percentageRegex({
        exact: false
      })).toString()).assertEqual(['10%'].toString())
      expect('foo 10%'.match(percentageRegex({
        exact: false
      })).toString()).assertEqual(['10%'].toString())
      expect('.5% 10%'.match(percentageRegex({
        exact: false
      })).toString()).assertEqual(['.5%', '10%'].toString())
      expect('foo .5% 10%'.match(percentageRegex({
        exact: false
      })).toString()).assertEqual(['.5%', '10%'].toString())
      expect('.5% 10% bar'.match(percentageRegex({
        exact: false
      })).toString()).assertEqual(['.5%', '10%'].toString())
      expect('0% 10% bar'.match(percentageRegex({
        exact: false
      })).toString()).assertEqual(['0%', '10%'].toString())
    })

    it('exact_should_default_to_false', 0, function () {
      let result = 'foo 10% bar'.match(percentageRegex())
      expect(result.toString()).assertEqual(['10%'].toString())
    })
  })
}
