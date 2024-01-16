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
import * as buffer from 'buffer/'

export default function swapTest() {
  describe('swapTest', () => {
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
    
    it('test02', 0, () => {
      const buf = Buffer.from([0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7]);
      buf.slice(1, 5).swap32();
      expect(buf).assertDeepEquals(Buffer.from([0x1, 0x5, 0x4, 0x3, 0x2, 0x6, 0x7]))
      buf.slice(1, 5).swap16();
      expect(buf).assertDeepEquals(Buffer.from([0x1, 0x4, 0x5, 0x2, 0x3, 0x6, 0x7]))
    })
    it('test03', 0, () => {
      const buf = Buffer.from([0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08,
        0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f, 0x10,
        0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08,
        0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f, 0x10]);

      buf.slice(2, 18).swap64();

      expect(buf).assertDeepEquals(Buffer.from([0x01, 0x02, 0x0a, 0x09, 0x08, 0x07,
        0x06, 0x05, 0x04, 0x03, 0x02, 0x01,
        0x10, 0x0f, 0x0e, 0x0d, 0x0c, 0x0b,
        0x03, 0x04, 0x05, 0x06, 0x07, 0x08,
        0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e,
        0x0f, 0x10]))
    })
    it('test04', 0, () => {
      const bufData = new Uint32Array(256).fill(0x04030201);
      const buf = Buffer.from(bufData.buffer, bufData.byteOffset);
      const otherBufData = new Uint32Array(256).fill(0x03040102);
      const otherBuf = Buffer.from(otherBufData.buffer, otherBufData.byteOffset);
      buf.swap16();
      expect(buf).assertDeepEquals(otherBuf)
    })
    it('test05', 0, () => {
      const bufData = new Uint32Array(256).fill(0x04030201);
      const buf = Buffer.from(bufData.buffer);
      const otherBufData = new Uint32Array(256).fill(0x01020304);
      const otherBuf = Buffer.from(otherBufData.buffer, otherBufData.byteOffset);
      buf.swap32();
      expect(buf).assertDeepEquals(otherBuf)
    })
    it('test06', 0, () => {
      const bufData = new Uint8Array(256 * 8);
      const otherBufData = new Uint8Array(256 * 8);
      for (let i = 0; i < bufData.length; i++) {
        bufData[i] = i % 8;
        otherBufData[otherBufData.length - i - 1] = i % 8;
      }
      const buf = Buffer.from(bufData.buffer, bufData.byteOffset);
      const otherBuf = Buffer.from(otherBufData.buffer, otherBufData.byteOffset);
      buf.swap64();
      expect(buf).assertDeepEquals(otherBuf)
    })
    it('test07', 0, () => {
      const bufData = new Uint8Array(256 * 8);
      const otherBufData = new Uint8Array(256 * 8 - 2);
      for (let i = 0; i < bufData.length; i++) {
        bufData[i] = i % 2;
      }
      for (let i = 1; i < otherBufData.length; i++) {
        otherBufData[otherBufData.length - i] = (i + 1) % 2;
      }
      const buf = Buffer.from(bufData.buffer, bufData.byteOffset);
      // 0|1 0|1 0|1...
      const otherBuf = Buffer.from(otherBufData.buffer, otherBufData.byteOffset);
      // 0|0 1|0 1|0...

      buf.slice(1, buf.length - 1).swap16();
      expect(buf.slice(0, otherBuf.length)).assertDeepEquals(otherBuf)
    })
    it('test08', 0, () => {
      const bufData = new Uint8Array(256 * 8);
      const otherBufData = new Uint8Array(256 * 8 - 4);
      for (let i = 0; i < bufData.length; i++) {
        bufData[i] = i % 4;
      }
      for (let i = 1; i < otherBufData.length; i++) {
        otherBufData[otherBufData.length - i] = (i + 1) % 4;
      }
      const buf = Buffer.from(bufData.buffer, bufData.byteOffset);
      // 0|1 2 3 0|1 2 3...
      const otherBuf = Buffer.from(otherBufData.buffer, otherBufData.byteOffset);
      // 0|0 3 2 1|0 3 2...

      buf.slice(1, buf.length - 3).swap32();
      expect(buf.slice(0, otherBuf.length)).assertDeepEquals(otherBuf)
    })
    it('test09', 0, () => {
      const bufData = new Uint8Array(256 * 8);
      const otherBufData = new Uint8Array(256 * 8 - 8);
      for (let i = 0; i < bufData.length; i++) {
        bufData[i] = i % 8;
      }
      for (let i = 1; i < otherBufData.length; i++) {
        otherBufData[otherBufData.length - i] = (i + 1) % 8;
      }
      const buf = Buffer.from(bufData.buffer, bufData.byteOffset);
      // 0|1 2 3 4 5 6 7 0|1 2 3 4...
      const otherBuf = Buffer.from(otherBufData.buffer, otherBufData.byteOffset);
      // 0|0 7 6 5 4 3 2 1|0 7 6 5...

      buf.slice(1, buf.length - 7).swap64();
      expect(buf.slice(0, otherBuf.length)).assertDeepEquals(otherBuf)
    })
  })
}