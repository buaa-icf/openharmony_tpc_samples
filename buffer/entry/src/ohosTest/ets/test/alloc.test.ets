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

export default function allocTest() {
  describe('allocTest', () => {
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
      const b = Buffer.allocUnsafe(1024);
      expect(1024).assertDeepEquals(b.length)
    })
    it('test02', 0, () => {
      const b = Buffer.allocUnsafe(1024);
      b[0] = -1;
      expect(b[0]).assertDeepEquals(255)
    })
    it('test03', 0, () => {
      const b = Buffer.allocUnsafe(1024);
      b[0] = -1;
      for (let i = 0; i < 1024; i++) {
        b[i] = i % 256;
      }

      for (let i = 0; i < 1024; i++) {
        expect(i % 256).assertDeepEquals(b[i])
      }
    })
    it('test04', 0, () => {
      const c = Buffer.allocUnsafe(512);
      expect(512).assertDeepEquals(c.length)

      const d = Buffer.from([]);
      expect(0).assertDeepEquals(d.length)
    })
    it('test05', 0, () => {
      const b = Buffer.alloc(128);
      expect(0).assertDeepEquals(b.byteOffset)
    })
    it('test06', 0, () => {
      const writeTest = Buffer.from('abcdes');
      writeTest.write('n',0);
      writeTest.write('o', 1);
      writeTest.write('d', 2);
      writeTest.write('e', 3);
      writeTest.write('j', 4);
      expect(writeTest.toString()).assertDeepEquals('nodejs')
    })
    it('test07', 0, () => {
      const asciiString = 'hello world';
      const offset = 100;
      const b = Buffer.allocUnsafe(1024);
      const sliceA = b.slice(offset, offset + asciiString.length);
      const sliceB = b.slice(offset, offset + asciiString.length);
      expect(sliceA[1]).assertDeepEquals(sliceB[1])
    })
    it('test08', 0, () => {
      const utf8String = '¡hέlló wôrld!';
      const offset = 100;
      const b = Buffer.allocUnsafe(1024);
      b.write(utf8String, 0, Buffer.byteLength(utf8String), 'utf8');
      let utf8Slice = b.toString('utf8', 0, Buffer.byteLength(utf8String));

      utf8Slice = b.toString('utf8', offset,
        offset + Buffer.byteLength(utf8String));

      const sliceA = b.slice(offset, offset + Buffer.byteLength(utf8String));
      const sliceB = b.slice(offset, offset + Buffer.byteLength(utf8String));
      expect(sliceA[1]).assertDeepEquals(sliceB[1])
    })
    it('test09', 0, () => {
      const testValue = '\u00F6\u65E5\u672C\u8A9E';
      const buffer = Buffer.allocUnsafe(32);
      const size = buffer.write(testValue, 0, 0,'utf8');
      const slice = buffer.toString('utf8', 0, size);
      expect('ö日本語').assertDeepEquals(testValue)
    })
    it('test10', 0, () => {
      const a = Buffer.allocUnsafe(8);
      for (let i = 0; i < 8; i++) a[i] = i;
      const b = a.slice(4, 8);
      const c = b.slice(2, 4);
      expect(7).assertDeepEquals(c[1])
    })
    it('test11', 0, () => {
      const d = Buffer.from([23, 42, 255]);
      expect(d.length).assertDeepEquals(3)
    })
    it('test12', 0, () => {
      const e = Buffer.from('über');
      expect(e).assertDeepEquals(Buffer.from([195, 188, 98, 101, 114]))
    })
    it('test13', 0, () => {
      const f = Buffer.from('über', 'ascii');
      expect(f).assertDeepEquals(Buffer.from([252, 98, 101, 114]))
    })
    it('test14', 0, () => {
      const f = Buffer.from('\uD83D\uDC4D', 'utf-16le'); // THUMBS UP SIGN (U+1F44D)
      expect(f.length).assertDeepEquals(4)
      expect(f).assertDeepEquals( Buffer.from('3DD84DDC', 'hex'))
    })
    it('test15', 0, () => {
      expect('TWFu').assertDeepEquals((Buffer.from('Man')).toString('base64'))
    })
    it('test16', 0, () => {
      const expected = [0xff, 0xff, 0xbe, 0xff, 0xef, 0xbf, 0xfb, 0xef, 0xff];
      expect(Buffer.from('//++/++/++//', 'base64')).assertDeepEquals(Buffer.from(expected))
    })
    it('test17', 0, () => {
      const quote = 'Man is distinguished, not only by his reason, but by this ' +
        'singular passion from other animals, which is a lust ' +
        'of the mind, that by a perseverance of delight in the ' +
        'continued and indefatigable generation of knowledge, ' +
        'exceeds the short vehemence of any carnal pleasure.';
      const expected = 'TWFuIGlzIGRpc3Rpbmd1aXNoZWQsIG5vdCBvbmx5IGJ5IGhpcyByZWFzb' +
        '24sIGJ1dCBieSB0aGlzIHNpbmd1bGFyIHBhc3Npb24gZnJvbSBvdGhlci' +
        'BhbmltYWxzLCB3aGljaCBpcyBhIGx1c3Qgb2YgdGhlIG1pbmQsIHRoYXQ' +
        'gYnkgYSBwZXJzZXZlcmFuY2Ugb2YgZGVsaWdodCBpbiB0aGUgY29udGlu' +
        'dWVkIGFuZCBpbmRlZmF0aWdhYmxlIGdlbmVyYXRpb24gb2Yga25vd2xlZ' +
        'GdlLCBleGNlZWRzIHRoZSBzaG9ydCB2ZWhlbWVuY2Ugb2YgYW55IGNhcm' +
        '5hbCBwbGVhc3VyZS4=';
      expect(expected).assertDeepEquals((Buffer.from(quote)).toString('base64'))
    })
    it('test18', 0, () => {
      expect(Buffer.from('Kg==', 'base64').toString()).assertDeepEquals('*')
      expect(Buffer.from('Kio=', 'base64').toString()).assertDeepEquals('*'.repeat(2))
      expect(Buffer.from('Kioq', 'base64').toString()).assertDeepEquals('*'.repeat(3))
    })
    it('test19', 0, () => {
      expect(Buffer.from('72INjkR5fchcxk9+VgdGPFJDxUBFR5/rMFsghgxADiw==', 'base64').length).assertDeepEquals(32)
    })
    it('test20', 0, () => {
      const dot = Buffer.from('//4uAA==', 'base64');
      expect(dot[0]).assertDeepEquals(0xff)
    })
    it('test21', 0, () => {
      const segments = ['TWFkbmVzcz8h', 'IFRoaXM=', 'IGlz', 'IG5vZGUuanMh'];
      const b = Buffer.allocUnsafe(64);
      let pos = 0;

      for (let i = 0; i < segments.length; ++i) {
        pos += b.write(segments[i], pos,100,'base64');
      }
      expect(b.toString('latin1', 0, pos)).assertDeepEquals('Madness?! This is node.js!')
    })
    it('test22', 0, () => {
      expect(Buffer.from('=bad'.repeat(1e4), 'base64').length).assertDeepEquals(0)
      expect(Buffer.from('w0  ', 'base64')).assertDeepEquals(Buffer.from('w0', 'base64'))
      expect(Buffer.from(' YWJvcnVtLg', 'base64')).assertDeepEquals(Buffer.from('YWJvcnVtLg', 'base64'))
    })
    it('test23', 0, () => {
      const hexb = Buffer.allocUnsafe(256);
      for (let i = 0; i < 256; i++) {
        hexb[i] = i;
      }
      const hexStr = hexb.toString('hex');
      expect(hexStr).assertDeepEquals('000102030405060708090a0b0c0d0e0f' +
        '101112131415161718191a1b1c1d1e1f' +
        '202122232425262728292a2b2c2d2e2f' +
        '303132333435363738393a3b3c3d3e3f' +
        '404142434445464748494a4b4c4d4e4f' +
        '505152535455565758595a5b5c5d5e5f' +
        '606162636465666768696a6b6c6d6e6f' +
        '707172737475767778797a7b7c7d7e7f' +
        '808182838485868788898a8b8c8d8e8f' +
        '909192939495969798999a9b9c9d9e9f' +
        'a0a1a2a3a4a5a6a7a8a9aaabacadaeaf' +
        'b0b1b2b3b4b5b6b7b8b9babbbcbdbebf' +
        'c0c1c2c3c4c5c6c7c8c9cacbcccdcecf' +
        'd0d1d2d3d4d5d6d7d8d9dadbdcdddedf' +
        'e0e1e2e3e4e5e6e7e8e9eaebecedeeef' +
        'f0f1f2f3f4f5f6f7f8f9fafbfcfdfeff')
      const hexb2 = Buffer.from(hexStr, 'hex');
      for (let i = 0; i < 256; i++) {
        expect(hexb2[i]).assertDeepEquals(hexb[i])
      }
    })
    it('test24', 0, () => {
      expect(Buffer.from('A', 'hex').length).assertDeepEquals(0)
      expect(Buffer.from('Abx', 'hex')).assertDeepEquals(Buffer.from('Ab', 'hex'))
      expect(Buffer.from('A', 'base64').length).assertDeepEquals(0)
    })
    it('test25', 0, () => {
      const b = Buffer.from([1, 2, 3, 4, 5]);
      const b2 = b.toString('hex', 1, 10000);
      const b3 = b.toString('hex', 1, 5);
      const b4 = b.toString('hex', 1);
      expect(b2).assertDeepEquals(b3)
      expect(b2).assertDeepEquals(b4)
    })
    it('test26', 0, () => {
      const b = Buffer.from([0xde, 0xad, 0xbe, 0xef]);
      let s = String.fromCharCode(0xffff);
      b.write(s, 0,100 ,'latin1');
      expect(0xff).assertDeepEquals(b[0])
      expect(0xad).assertDeepEquals(b[1])
      expect(0xbe).assertDeepEquals(b[2])
      expect(0xef).assertDeepEquals(b[3])
      s = String.fromCharCode(0xaaee);
      b.write(s, 0, 100,'latin1');
      expect(0xee).assertDeepEquals(b[0])
      expect(0xad).assertDeepEquals(b[1])
      expect(0xbe).assertDeepEquals(b[2])
      expect(0xef).assertDeepEquals(b[3])
    })
    it('test27', 0, () => {
      let buf = Buffer.from('\0');
      expect(buf.length).assertDeepEquals(1)
      buf = Buffer.from('\0\0');
      expect(buf.length).assertDeepEquals(2)
    })
    it('test28', 0, () => {
      const buf = Buffer.allocUnsafe(2);
      expect(buf.write('')).assertDeepEquals(0)
      expect(buf.write('\0')).assertDeepEquals(1)
      expect(buf.write('a\0')).assertDeepEquals(2)
      expect(buf.write('あ')).assertDeepEquals(0)
      expect(buf.write('\0あ')).assertDeepEquals(1)
      expect(buf.write('\0あ')).assertDeepEquals(1)
    })
    it('test29', 0, () => {
      const buf = Buffer.allocUnsafe(10);
      expect(buf.write('あいう')).assertDeepEquals(9)
      expect(buf.write('あいう\0')).assertDeepEquals(10)
    })
    it('test30', 0, () => {
      const buf = Buffer.allocUnsafe(4);
      buf.fill(0xFF);
      expect(buf.write('abcd', 1, 2, 'utf8')).assertDeepEquals(2)
      expect(buf[0]).assertDeepEquals(0xFF)
      expect(buf[1]).assertDeepEquals(0x61)
      expect(buf[2]).assertDeepEquals(0x62)
      expect(buf[3]).assertDeepEquals(0xFF)
    })
    it('test31', 0, () => {
      const b = Buffer.allocUnsafe(16);
      expect(4).assertDeepEquals(b.writeUInt32LE(0, 0))
      expect(6).assertDeepEquals(b.writeUInt16LE(0, 4))
      expect(7).assertDeepEquals(b.writeUInt8(0, 6))
      expect(8).assertDeepEquals(b.writeInt8(0, 7))
      expect(16).assertDeepEquals(b.writeDoubleLE(0, 8))
    })
    it('test32', 0, () => {
      const buf = Buffer.from('ab\ud800cd', 'utf8');
      expect(buf[0]).assertDeepEquals(0x61)
      expect(buf[1]).assertDeepEquals(0x62)
      expect(buf[2]).assertDeepEquals(0xef)
      expect(buf[3]).assertDeepEquals(0xbf)
      expect(buf[4]).assertDeepEquals(0xbd)
      expect(buf[5]).assertDeepEquals(0x63)
      expect(buf[6]).assertDeepEquals(0x64)
    })
    it('test33', 0, () => {
      const buf = Buffer.from('ab\ud800cd', 'utf8');
      expect(buf[0]).assertDeepEquals(0x61)
      expect(buf[1]).assertDeepEquals(0x62)
      expect(buf[2]).assertDeepEquals(0xef)
      expect(buf[3]).assertDeepEquals(0xbf)
      expect(buf[4]).assertDeepEquals(0xbd)
      expect(buf[5]).assertDeepEquals(0x63)
      expect(buf[6]).assertDeepEquals(0x64)
    })
  })

}

