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

export default function indexOfTest() {
  describe('indexOfTest', () => {
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
    let b = Buffer.from('abcdef');
    let buf_a = Buffer.from('a');
    let buf_bc = Buffer.from('bc');
    let buf_f = Buffer.from('f');
    let buf_z = Buffer.from('z');
    let buf_empty = Buffer.from('');
    it('test01', 0, () => {
      expect(b.indexOf('a')).assertDeepEquals(0)
      expect(b.indexOf('a', 1)).assertDeepEquals(-1)
      expect(b.indexOf('a', -1)).assertDeepEquals(-1)
      expect(b.indexOf('a', -4)).assertDeepEquals(-1)
      expect(b.indexOf('a', -b.length)).assertDeepEquals(0)
    })
    it('test02', 0, () => {
      expect(b.indexOf('d', 2)).assertDeepEquals(3)
      expect(b.indexOf('f', 5)).assertDeepEquals(5)
      expect(b.indexOf('f', -1)).assertDeepEquals(5)
      expect(b.indexOf('f', 6)).assertDeepEquals(-1)
      expect(b.indexOf(Buffer.from('d'), 2)).assertDeepEquals(3)
      expect(b.indexOf(Buffer.from('f'), 5)).assertDeepEquals(5)
      expect(b.indexOf(Buffer.from('f'), -1)).assertDeepEquals(5)
      expect(b.indexOf(Buffer.from('f'), 6)).assertDeepEquals(-1)
    })
    it('test03', 0, () => {
      expect(Buffer.from(b.toString('hex'), 'hex')
        .indexOf('64', 0, 'hex')).assertDeepEquals(3)

      expect( Buffer.from(b.toString('hex'), 'hex')
        .indexOf(Buffer.from('64', 'hex'), 0, 'hex')).assertDeepEquals(3)
      // test base64 encoding
      expect(Buffer.from(b.toString('base64'), 'base64')
        .indexOf('ZA==', 0, 'base64')).assertDeepEquals(3)

      expect(Buffer.from(b.toString('base64'), 'base64')
        .indexOf(Buffer.from('ZA==', 'base64'), 0, 'base64')).assertDeepEquals(3)
      // test ascii encoding
      expect(Buffer.from(b.toString('ascii'), 'ascii')
        .indexOf('d', 0, 'ascii')).assertDeepEquals(3)

      expect( Buffer.from(b.toString('ascii'), 'ascii')
        .indexOf(Buffer.from('d', 'ascii'), 0, 'ascii')).assertDeepEquals(3)
      // test latin1 encoding

      expect(Buffer.from(b.toString('latin1'), 'latin1')
        .indexOf('d', 0, 'latin1')).assertDeepEquals(3)

      expect( Buffer.from(b.toString('latin1'), 'latin1')
        .indexOf(Buffer.from('d', 'latin1'), 0, 'latin1')).assertDeepEquals(3)

      // test binary encoding

      expect(Buffer.from(b.toString('binary'), 'binary')
        .indexOf('d', 0, 'binary')).assertDeepEquals(3)

     expect(Buffer.from(b.toString('binary'), 'binary')
       .indexOf(Buffer.from('d', 'binary'), 0, 'binary')).assertDeepEquals(3)
    })
    it('test04', 0, () => {
      expect(Buffer.from('aaaa0').indexOf('30',100, 'hex')).assertDeepEquals(-1)
      expect(Buffer.from('aaaa00a').indexOf('3030',100, 'hex')).assertDeepEquals(-1)
    })
    it('test05', 0, () => {
      let twoByteString = Buffer.from('\u039a\u0391\u03a3\u03a3\u0395', 'ucs2');

      expect(8).assertDeepEquals(twoByteString.indexOf('\u0395', 4, 'ucs2'))
      expect(6).assertDeepEquals(twoByteString.indexOf('\u03a3', -4, 'ucs2'))
    })
    it('test06', 0, () => {
      let mixedByteStringUcs2 = Buffer.from('\u039a\u0391abc\u03a3\u03a3\u0395', 'ucs2');

      expect(6).assertDeepEquals(mixedByteStringUcs2.indexOf('bc', 0, 'ucs2'))
      expect(10).assertDeepEquals(mixedByteStringUcs2.indexOf('\u03a3', 0, 'ucs2'))
    })
    it('test07', 0, () => {
      let twoByteString = Buffer.from('\u039a\u0391\u03a3\u03a3\u0395', 'ucs2');


      expect(0).assertDeepEquals(twoByteString.indexOf('\u039a', 0, 'ucs2'))
      expect(2).assertDeepEquals(twoByteString.indexOf('\u0391', 0, 'ucs2'))
      expect(4).assertDeepEquals(twoByteString.indexOf('\u03a3', 0, 'ucs2'))
    })
    it('test08', 0, () => {
      let mixedByteStringUtf8 = Buffer.from('\u039a\u0391abc\u03a3\u03a3\u0395');

      expect(5).assertDeepEquals(mixedByteStringUtf8.indexOf('bc'))
      expect(5).assertDeepEquals(mixedByteStringUtf8.indexOf('bc', 5))
    })
    it('test09', 0, () => {
      let longString = 'A';
      for (let i = 66; i < 76; i++) {  // from 'B' to 'K'
        longString = longString + String.fromCharCode(i) + longString;
      }

      let longBufferString = Buffer.from(longString);

      // pattern of 15 chars, repeated every 16 chars in long
      let pattern = 'ABACABADABACABA';
      for (let i = 0; i < longBufferString.length - pattern.length; i += 7) {
        let index = longBufferString.indexOf(pattern, i);
        expect((i + 15) & ~0xf).assertDeepEquals(index)
      }
    })
    it('test10', 0, () => {
      expect(b.lastIndexOf('a')).assertDeepEquals(0)
      expect(b.lastIndexOf('a', 1)).assertDeepEquals(0)
      expect(b.lastIndexOf('b', 1)).assertDeepEquals(1)
      expect(b.lastIndexOf('c', 1)).assertDeepEquals(-1)
      expect(b.lastIndexOf('a', -1)).assertDeepEquals(0)
      expect(b.lastIndexOf('a', -4)).assertDeepEquals(0)
      expect(b.lastIndexOf('a', -b.length)).assertDeepEquals(0)
      expect(b.lastIndexOf('a', -b.length - 1)).assertDeepEquals(-1)
    })
    it('test11', 0, () => {
      expect(b.lastIndexOf(buf_a)).assertDeepEquals(0)
      expect(b.lastIndexOf(buf_a)).assertDeepEquals(0)
      expect(b.lastIndexOf(buf_a, -1)).assertDeepEquals(0)
      expect(b.lastIndexOf(buf_a, -4)).assertDeepEquals(0)
      expect(b.lastIndexOf(buf_a, -b.length)).assertDeepEquals(0)
      expect(b.lastIndexOf(buf_a, -b.length - 1)).assertDeepEquals(-1)
    })
    it('test12', 0, () => {
      expect(b.lastIndexOf(0x61)).assertDeepEquals(0)
      expect(b.lastIndexOf(0x61, 1)).assertDeepEquals(0)
      expect(b.lastIndexOf(0x61, -1)).assertDeepEquals(0)
      expect(b.lastIndexOf(0x61, -4)).assertDeepEquals(0)
      expect(b.lastIndexOf(0x61, -b.length)).assertDeepEquals(0)
      expect(b.lastIndexOf(buf_a, -b.length - 1)).assertDeepEquals(-1)
    })
  })
}