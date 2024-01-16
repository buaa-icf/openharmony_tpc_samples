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

export default function includeTest() {
  describe('includeTest', () => {
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
    let  b = Buffer.from('abcdef');
    let  buf_a = Buffer.from('a');
    let  buf_bc = Buffer.from('bc');
    let  buf_f = Buffer.from('f');
    let  buf_z = Buffer.from('z');
    let  buf_empty = Buffer.from('');
    it('test01', 0, () => {
      expect(b.includes('a')).assertDeepEquals(true)
      expect(!b.includes('a', 1)).assertDeepEquals(true)
      expect(!b.includes('a', -1)).assertDeepEquals(true)
      expect(!b.includes('a', -4)).assertDeepEquals(true)
      expect(b.includes('a', -b.length)).assertDeepEquals(true)
      expect(b.includes('bc')).assertDeepEquals(true)
    })
    it('test02', 0, () => {
      expect(b.includes('d', 2)).assertDeepEquals(true)
      expect(b.includes('f', 5)).assertDeepEquals(true)
      expect(b.includes('f', -1)).assertDeepEquals(true)
      expect(!b.includes('f', 6)).assertDeepEquals(true)
      expect(b.includes(Buffer.from('d'), 2)).assertDeepEquals(true)
      expect(b.includes(Buffer.from('f'), 5)).assertDeepEquals(true)
    })
    it('test03', 0, () => {
      expect(Buffer.from(b.toString('hex'), 'hex')
        .includes('64', 0, 'hex')).assertDeepEquals(true)
    })
    it('test04', 0, () => {
      expect(Buffer.from(b.toString('hex'), 'hex')
        .includes(Buffer.from('64', 'hex'), 0, 'hex')).assertDeepEquals(true)
    })
    it('test05', 0, () => {
      expect(Buffer.from(b.toString('base64'), 'base64')
        .includes('ZA==', 0, 'base64')).assertDeepEquals(true)
    })
    it('test06', 0, () => {
      expect( Buffer.from(b.toString('base64'), 'base64')
        .includes(Buffer.from('ZA==', 'base64'), 0, 'base64')).assertDeepEquals(true)
    })
    it('test07', 0, () => {
      expect(Buffer.from(b.toString('ascii'), 'ascii')
        .includes(Buffer.from('d', 'ascii'), 0, 'ascii')).assertDeepEquals(true)
    })
    it('test08', 0, () => {
      expect(Buffer.from(b.toString('latin1'), 'latin1')
        .includes('d', 0, 'latin1')).assertDeepEquals(true)
    })
    it('test09', 0, () => {
      expect(Buffer.from(b.toString('latin1'), 'latin1')
        .includes(Buffer.from('d', 'latin1'), 0, 'latin1')).assertDeepEquals(true)
    })
    it('test10', 0, () => {
      expect(Buffer.from(b.toString('binary'), 'binary')
        .includes('d', 0, 'binary')).assertDeepEquals(true)
    })
    it('test11', 0, () => {
      expect(Buffer.from(b.toString('binary'), 'binary')
        .includes(Buffer.from('d', 'binary'), 0, 'binary')).assertDeepEquals(true)
    })
    it('test12', 0, () => {
      expect(Buffer.from(b.toString('binary'), 'binary')
        .includes(Buffer.from('d', 'binary'), 0, 'binary')).assertDeepEquals(true)
    })
    it('test13', 0, () => {
      let twoByteString = Buffer.from('\u039a\u0391\u03a3\u03a3\u0395', 'ucs2');
      expect(twoByteString.includes('\u0395', 4, 'ucs2')).assertDeepEquals(true)
      expect(twoByteString.includes('\u03a3', -4, 'ucs2')).assertDeepEquals(true)
      expect(twoByteString.includes('\u03a3', -6, 'ucs2')).assertDeepEquals(true)
      expect(twoByteString.includes(
        Buffer.from('\u03a3', 'ucs2'), -6, 'ucs2')).assertDeepEquals(true)
    })
  })
}