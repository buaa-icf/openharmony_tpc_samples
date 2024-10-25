/**
 * MIT License
 *
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the 'Software'), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to all conditions.
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, } from '@ohos/hypium'
import { BlufiDH } from '@ohos/espblufiforharmony'

export default function BlufiDHTest() {
  describe('BlufiDHTest', () => {

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
    it('BlufiDH', 0, async () => {

      let a: string = 'strTest';
      expect(a).assertInstanceOf('String');

      let aDHTool: BlufiDH = new BlufiDH();
      let aPublb: Uint8Array = aDHTool.getPublicKey();
      let alen: number = aPublb.length;
      expect(alen).assertLarger(0);

      let bDHTool: BlufiDH = new BlufiDH();
      let bPublb: Uint8Array = bDHTool.getPublicKey();
      let blen: number = bPublb.length;
      expect(blen).assertLarger(0);

      let bScrect: string = await bDHTool.generateSecretKey({
        data: aPublb
      });

      let aScrect: string = await aDHTool.generateSecretKey({
        data: bPublb
      });

      expect(bScrect).assertInstanceOf('String');
      expect(aScrect).assertInstanceOf('String');

      let really: boolean = bScrect == aScrect;
      expect(really).assertTrue();

    })
  })
}