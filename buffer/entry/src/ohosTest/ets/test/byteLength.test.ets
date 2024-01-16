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

export default function byteLengthTest() {
  describe('byteLengthTest', () => {
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
    it('test01', 0, () => {
      expect(Buffer.byteLength('', undefined)).assertDeepEquals(0)
    })
    it('test02', 0, () => {
      const incomplete:ESObject = Buffer.from([0xe4, 0xb8, 0xad, 0xe6, 0x96]);
      expect(Buffer.byteLength(incomplete)).assertDeepEquals(5)
      const ascii:ESObject = Buffer.from('abc');
      expect(Buffer.byteLength(ascii)).assertDeepEquals(3)
    })
    it('test03', 0, () => {
      const buffer:ESObject = new ArrayBuffer(8);
      expect(Buffer.byteLength(buffer)).assertDeepEquals(8)
    })
    it('test04', 0, () => {
      const int8:ESObject = new Int8Array(8);
      expect(Buffer.byteLength(int8)).assertDeepEquals(8);
      const uint8:ESObject = new Uint8Array(8);
      expect(Buffer.byteLength(uint8)).assertDeepEquals(8);
      const uintc8:ESObject = new Uint8ClampedArray(2);
      expect(Buffer.byteLength(uintc8)).assertDeepEquals(2);
      const int16:ESObject = new Int16Array(8);
      expect(Buffer.byteLength(int16)).assertDeepEquals(16);
      const uint16:ESObject = new Uint16Array(8);
      expect(Buffer.byteLength(uint16)).assertDeepEquals(16);
      const int32:ESObject = new Int32Array(8);
      expect(Buffer.byteLength(int32)).assertDeepEquals(32);
      const uint32:ESObject = new Uint32Array(8);
      expect(Buffer.byteLength(uint32)).assertDeepEquals(32);
      const float32:ESObject = new Float32Array(8);
      expect(Buffer.byteLength(float32)).assertDeepEquals(32);
      const float64:ESObject = new Float64Array(8);
      expect(Buffer.byteLength(float64)).assertDeepEquals(64);
    })
    it('test05', 0, () => {
      const dv:ESObject = new DataView(new ArrayBuffer(2));
      expect(Buffer.byteLength(dv)).assertDeepEquals(2)
    })
    it('test06', 0, () => {
      expect(Buffer.byteLength('', 'ascii')).assertDeepEquals(0)
      expect(Buffer.byteLength('', 'HeX')).assertDeepEquals(0)
    })
    it('test07', 0, () => {
      expect(Buffer.byteLength('∑éllö wørl∂!', 'utf-8')).assertDeepEquals(19)
      expect(Buffer.byteLength('κλμνξο', 'utf8')).assertDeepEquals(12)
    })
    it('test08', 0, () => {
      expect(Buffer.byteLength('hey there')).assertDeepEquals(9)
      expect(Buffer.byteLength('𠱸挶νξ#xx :)')).assertDeepEquals(17)
      expect(Buffer.byteLength('hello world', '')).assertDeepEquals(11)
    })
    it('test09', 0, () => {
      expect(Buffer.byteLength('hello world', 'abc')).assertDeepEquals(11)
      expect(Buffer.byteLength('ßœ∑≈', 'unkn0wn enc0ding')).assertDeepEquals(10)
    })
    it('test10', 0, () => {
      expect(Buffer.byteLength('aGVsbG8gd29ybGQ=', 'base64')).assertDeepEquals(11)
    })
  })
}