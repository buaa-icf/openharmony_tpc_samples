/**
 *  MIT License
 *
 *  Copyright (c) 2024 Huawei Device Co., Ltd.
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in all
 *  copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 *  SOFTWARE.
 */

import hilog from '@ohos.hilog';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { Buffer } from 'buffer/';

export default function arrayBufferTest() {
  describe('arrayBufferTest', () => {
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
    const LENGTH = 16;

    const ab = new ArrayBuffer(LENGTH);
    const dv = new DataView(ab);
    const ui = new Uint8Array(ab);
    const buf = Buffer.from(ab);
    it('test01', 0, () => {
      expect(buf instanceof Buffer).assertDeepEquals(true)
      expect(buf.buffer).assertDeepEquals(ab)
      expect(buf.length).assertDeepEquals(ab.byteLength)
    })
    it('test02', 0, () => {
      buf.fill(0xC);
      for (let i = 0; i < LENGTH; i++) {
        expect(ui[i]).assertDeepEquals(0xC)
        ui[i] = 0xF;
        expect(buf[i]).assertDeepEquals(0xF)
      }

      buf.writeUInt32LE(0xF00, 0);
      buf.writeUInt32BE(0xB47, 4);
      buf.writeDoubleLE(3.1415, 8);

      expect(dv.getUint32(0, true)).assertDeepEquals(0xF00)
      expect(dv.getUint32(4)).assertDeepEquals(0xB47)
      expect(dv.getFloat64(8, true)).assertDeepEquals(3.1415)
    })
    it('test03', 0, () => {
      const ab = new Uint8Array(5);
      ab[0] = 1;
      ab[1] = 2;
      ab[2] = 3;
      ab[3] = 4;
      ab[4] = 5;
      const buf = Buffer.from(ab.buffer, 1, 3);
      expect(buf.length).assertDeepEquals(3)
      expect(buf[0]).assertDeepEquals(2)
      expect(buf[1]).assertDeepEquals(3)
      expect(buf[2]).assertDeepEquals(4)
      buf[0] = 9;
      expect(ab[1]).assertDeepEquals(9)
    })
  })
}