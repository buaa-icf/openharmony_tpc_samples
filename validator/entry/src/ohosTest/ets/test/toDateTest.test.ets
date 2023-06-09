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

export default function toDateTest() {
  describe('toDateTest', function () {
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

    it('toDate1', 0, function () {
      let result = validator.toDate("2022/12/05")
      expect(result.toString()).assertEqual("Mon Dec 05 2022 00:00:00 GMT+0800")
    })
    it('toDate2', 0, function () {
      let result = validator.toDate("2022-12-05")
      expect(result.toString()).assertEqual("Mon Dec 05 2022 08:00:00 GMT+0800")
    })
    it('toDate3', 0, function () {
      let result = validator.toDate("2007-04-06T00:00")
      expect(result.toString()).assertEqual("Fri Apr 06 2007 00:00:00 GMT+0800")
    })
    it('toDate4', 0, function () {
      let result = validator.toDate("2010-02-18T16:23:48.5")
      expect(result.toString()).assertEqual("Thu Feb 18 2010 16:23:48 GMT+0800")
    })
    it('toDate5', 0, function () {
      let result = validator.toDate("2007-05-19 14:34:23")
      expect(result.toString()).assertEqual("Sat May 19 2007 14:34:23 GMT+0800")
    })
  })
}