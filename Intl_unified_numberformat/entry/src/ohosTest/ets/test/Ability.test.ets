/*
 * MIT License
 *
 * Copyright (C) 2024 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import * as intl_unified_numberformat from '@f-fjs/intl-unified-numberformat';

export default function abilityTest() {
  describe('ActsAbilityTest', ()=> {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(()=> {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(()=> {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(()=> {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(()=> {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    it('test_core_isUnitSupported_degree', 0, ()=> {
      let unit:intl_unified_numberformat.Unit = 'degree';
      let supportedResult = intl_unified_numberformat.isUnitSupported(unit);
      expect(supportedResult).assertTrue();
    });
    it('test_core_isUnitSupported_acre', 0, ()=> {
      let unit:intl_unified_numberformat.Unit = 'acre';
      let supportedResult = intl_unified_numberformat.isUnitSupported(unit);
      expect(supportedResult).assertTrue();
    });
    it('test_core_isUnitSupported_hectare', 0, ()=> {
      let unit:intl_unified_numberformat.Unit = 'hectare';
      let supportedResult = intl_unified_numberformat.isUnitSupported(unit);
      expect(supportedResult).assertTrue();
    });
    it('test_core_isUnitSupported_false', 0, ()=> {
      let unit:intl_unified_numberformat.Unit = '' as intl_unified_numberformat.Unit;
      let supportedResult = intl_unified_numberformat.isUnitSupported(unit);
      expect(supportedResult).assertFalse();
    });
  })
}