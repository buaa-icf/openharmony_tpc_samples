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

export default function sliceTest() {
  describe('sliceTest', () => {
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
    const buf = Buffer.from('0123456789', 'utf8');
    const expectedSameBufs = [
      [buf.slice(-10, 10), Buffer.from('0123456789', 'utf8')],
      [buf.slice(-20, 10), Buffer.from('0123456789', 'utf8')],
      [buf.slice(-20, -10), Buffer.from('', 'utf8')],
      [buf.slice(), Buffer.from('0123456789', 'utf8')],
      [buf.slice(0), Buffer.from('0123456789', 'utf8')],
      [buf.slice(0, 0), Buffer.from('', 'utf8')],
      [buf.slice(undefined), Buffer.from('0123456789', 'utf8')],
      [buf.slice(undefined, undefined), Buffer.from('0123456789', 'utf8')],
      [buf.slice(2), Buffer.from('23456789', 'utf8')],
      [buf.slice(5), Buffer.from('56789', 'utf8')],
      [buf.slice(10), Buffer.from('', 'utf8')],
      [buf.slice(5, 8), Buffer.from('567', 'utf8')],
      [buf.slice(8, -1), Buffer.from('8', 'utf8')],
      [buf.slice(-10), Buffer.from('0123456789', 'utf8')],
      [buf.slice(0, -9), Buffer.from('0', 'utf8')],
      [buf.slice(0, -10), Buffer.from('', 'utf8')],
      [buf.slice(0, -1), Buffer.from('012345678', 'utf8')],
      [buf.slice(2, -2), Buffer.from('234567', 'utf8')],
      [buf.slice(0, 65536), Buffer.from('0123456789', 'utf8')],
      [buf.slice(65536, 0), Buffer.from('', 'utf8')],
      [buf.slice(-5, -8), Buffer.from('', 'utf8')],
      [buf.slice(-5, -3), Buffer.from('56', 'utf8')],
      [buf.slice(-10, 10), Buffer.from('0123456789', 'utf8')],
    ];
    for (let i = 0, s = buf.toString(); i < buf.length; ++i) {
      expectedSameBufs.push(
        [buf.slice(i), Buffer.from(s.slice(i))],
        [buf.slice(0, i), Buffer.from(s.slice(0, i))],
        [buf.slice(-i), Buffer.from(s.slice(-i))],
        [buf.slice(0, -i), Buffer.from(s.slice(0, -i))]
      );
    }
    it('test01', 0, () => {
      expect(0).assertDeepEquals(Buffer.from('hello', 'utf8').slice(0, 0).length)
      expect(0).assertDeepEquals(new Buffer('hello', 'utf8').slice(0, 0).length)
    })
    it('test02', 0, () => {
      const utf16Buf = Buffer.from('0123456789', 'utf16le');
      expect(utf16Buf.slice(0, 6)).assertDeepEquals(Buffer.from('012', 'utf16le'))
    })
    it('test03', 0, () => {
      expect('bcde').assertDeepEquals(Buffer.from('abcde', 'utf8').slice(1).toString('utf8'))
    })
    it('test04', 0, () => {
      const buf = Buffer.from('abcd', 'utf8');
      expect(buf.slice(buf.length / 3).toString('utf8')).assertDeepEquals(buf.slice(buf.length / 3).toString('utf8'))
      expect(buf.slice(buf.length / 3, buf.length).toString()).assertDeepEquals('bcd')
    })
    it('test05', 0, () => {
      const buf = Buffer.from('abcdefg', 'utf8');
      expect(buf.slice(-(-1 >>> 0) - 1).toString('utf8')).assertDeepEquals(buf.toString('utf8'))
    })
    it('test06', 0, () => {
      const buf = Buffer.from('abc', 'utf8');
      expect(buf.slice(-0.5).toString('utf8')).assertDeepEquals(buf.toString('utf8'))
    })
    it('test07', 0, () => {
      const buf = Buffer.from([
        1, 29, 0, 0, 1, 143, 216, 162, 92, 254, 248, 63, 0,
        0, 0, 18, 184, 6, 0, 175, 29, 0, 8, 11, 1, 0, 0
      ]);
      const chunk1 = Buffer.from([
        1, 29, 0, 0, 1, 143, 216, 162, 92, 254, 248, 63, 0
      ]);
      const chunk2 = Buffer.from([
        0, 0, 18, 184, 6, 0, 175, 29, 0, 8, 11, 1, 0, 0
      ]);
      const middle = buf.length / 2;

      expect(buf.slice(0, middle)).assertDeepEquals(chunk1)
      expect(buf.slice(middle)).assertDeepEquals(chunk2)
    })
  })
}