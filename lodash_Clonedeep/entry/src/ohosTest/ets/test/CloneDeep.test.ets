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

import hilog from '@ohos.hilog';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it as _it, expect } from '@ohos/hypium'
import cloneDeep from 'lodash.clonedeep';

export default function CloneDeepTest() {
  describe('CloneDeepTest', ()=> {
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

    _it('cloneDeep should deep clone objects with circular references', 0, ()=> {
      let object:ESObject = {
        foo: {
          b: {
            c: {
              d: {}as ESObject
            }as ESObject
          }as ESObject
        }as ESObject,
        bar: {} as ESObject
      };

      object.foo.b.c.d = object;
      object.bar.b = object.foo.b;

      let actual:ESObject = cloneDeep(object);
      expect(actual.bar.b === actual.foo.b && actual === actual.foo.b.c.d && actual !== object).assertTrue()
    });

    _it('cloneDeep should deep clone objects with lots of circular references', 0, ()=> {
      let cyclical:ESObject = {};

      // lodashStable.times(200 + 1, function (index) {
      //   cyclical['v' + index] = [index ? cyclical['v' + (index - 1)] : cyclical];
      // });

      for (let index = 0; index < 201; index++) {
        (cyclical as ESObject)['v' + index] = [index ? cyclical['v' + (index - 1)] : cyclical];
      }
      let clone:ESObject = cloneDeep(cyclical)
      let  actual:ESObject = clone['v' + 200][0];
      expect(actual === clone['v' + (200 - 1)]).assertTrue()
      expect(actual === (cyclical as ESObject)['v' + (200 - 1)]).assertFalse()
    });
  })
}
