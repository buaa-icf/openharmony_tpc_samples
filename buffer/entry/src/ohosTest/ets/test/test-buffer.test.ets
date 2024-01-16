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
import { Buffer } from 'buffer/'

export default function bufferTest() {
  describe('BufferTest', () => {
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
    let cntr = 0;
    let b = new Buffer(1024);
    let c =new Buffer(512);
    it('Buffer01', 0, () => {
      expect(b.length).assertEqual(1024);
      expect(b.length).assertEqual(1024);
      expect(b.length).assertEqual(1024);
    })

    it('Buffer02', 0, () => {
      b[0] = -1;
      expect(b[0]).assertEqual(255);
      for (let i = 0; i < 1024; i++) {
        b[i] = i % 256;
      }
      for (let i = 0; i < 1024; i++) {
        expect(b[i]).assertEqual(i % 256);
      }
    })

    it('Buffer03', 0, () => {
      expect(c.length).assertEqual(512);
    })

    it('Buffer_fill02', 0, () => {
      let c =new Buffer(8);
      expect(JSON.stringify(c.fill('9'))).assertEqual('{"type":"Buffer","data":[57,57,57,57,57,57,57,57]}');
    })

    it('Buffer_fill01', 0, () => {
      let buf = new Buffer(64);
      buf.fill(10);
      for (let i = 0; i < buf.length; i++) {
        expect(buf[i]).assertEqual(10);
      }
      buf.fill(11, 0, buf.length >> 1);

      for (let i = (buf.length >> 1) + 1; i < buf.length; i++) {
        expect(buf[i]).assertEqual(10);
      }
    })

    it('Buffer_fill03', 0, () => {
      let buf = new Buffer(10);
      buf.fill('abc');
      expect(buf.toString()).assertEqual('abcabcabca');
      buf.fill('է');
      expect(buf.toString()).assertEqual('էէէէէ');
    })

    it('Buffer_copy01', 0, () => {
      b.fill(++cntr);
      c.fill(++cntr);
      let copied = b.copy(c, 0, 0, 512);
      expect(copied).assertEqual(512);
      for (let i = 0; i < c.length; i++) {
        expect(b[i]).assertEqual(c[i]);
      }
    })

    it('Buffer_copy02', 0, () => {
      b.fill(++cntr);
      c.fill(++cntr);
      let copied = c.copy(b, 0, 0);
      expect(c.length).assertEqual(copied);
      for (let i = 0; i < c.length; i++) {
        expect(c[i]).assertEqual(b[i]);
      }
    })

    it('Buffer_copy03', 0, () => {
      b.fill(++cntr);
      c.fill(++cntr);
      let copied = c.copy(b, 0);
      expect(c.length).assertEqual(copied);
      for (let i = 0; i < c.length; i++) {
        expect(c[i]).assertEqual(b[i]);
      }
    })

    it('Buffer_copy04', 0, () => {
      b.fill(++cntr);
      c.fill(++cntr);
      let copied = b.copy(c);
      expect(c.length).assertEqual(copied);
      for (let i = 0; i < c.length; i++) {
        expect(b[i]).assertEqual(c[i]);
      }
    })

    it('Buffer_copy05', 0, () => {
      b.fill(++cntr);
      c.fill(++cntr);
      let copied = b.copy(c, 0, b.length - Math.floor(c.length / 2));
      expect(Math.floor(c.length / 2)).assertEqual(copied);
      for (let i = 0; i < Math.floor(c.length / 2); i++) {
        expect(b[b.length - Math.floor(c.length / 2) + i]).assertEqual(c[i]);
      }
      for (let i = Math.floor(c.length / 2) + 1; i < c.length; i++) {
        expect(c[c.length - 1]).assertEqual(c[i]);
      }
    })

    it('Buffer_toString1', 0, () => {
      let rangeBuffer = new Buffer('abc');
      // if start >= buffer's length, empty string will be returned
      expect(rangeBuffer.toString('ascii', 3)).assertEqual('');
      expect(rangeBuffer.toString('ascii', +Infinity)).assertEqual('');
      expect(rangeBuffer.toString('ascii', 3.14, 3)).assertEqual('');

      // if end <= 0, empty string will be returned
      expect(rangeBuffer.toString('ascii', 1, 0)).assertEqual('');
      expect(rangeBuffer.toString('ascii', 1, -1.2)).assertEqual('');
      expect(rangeBuffer.toString('ascii', 1, -100)).assertEqual('');
      expect(rangeBuffer.toString('ascii', 1, -Infinity)).assertEqual('');

      // if start < 0, start will be taken as zero
      expect(rangeBuffer.toString('ascii',-1, 3)).assertEqual('abc');
      expect(rangeBuffer.toString('ascii', -1.99, 3)).assertEqual('abc');
      expect(rangeBuffer.toString('ascii', -Infinity, 3)).assertEqual('abc');

      // if start is an invalid integer, start will be taken as zero
      expect(rangeBuffer.toString('ascii', NaN, 3)).assertEqual('abc');
      expect(rangeBuffer.toString('ascii', null, 3)).assertEqual('abc');
      expect(rangeBuffer.toString('ascii', undefined, 3)).assertEqual('abc');

      // but, if start is an integer when coerced, then it will be coerced and used.
      expect(rangeBuffer.toString('ascii', Number(3), 3)).assertEqual('');
      expect(rangeBuffer.toString('ascii', 1.99, 3)).assertEqual('bc');

      // if end > buffer's length, end will be taken as buffer's length
      expect(rangeBuffer.toString('ascii', 0, 5)).assertEqual('abc');
      expect(rangeBuffer.toString('ascii', 0, 6.99)).assertEqual('abc');
      expect(rangeBuffer.toString('ascii', 0, Infinity)).assertEqual('abc');

      // if end is an invalid integer, end will be taken as buffer's length
      expect(rangeBuffer.toString('ascii', 0, NaN)).assertEqual('');
      expect(rangeBuffer.toString('ascii', 0, undefined)).assertEqual('abc');
      expect(rangeBuffer.toString('ascii', 0)).assertEqual('abc');
      expect(rangeBuffer.toString('ascii', 0, NaN)).assertEqual('');

      // but, if end is an integer when coerced, then it will be coerced and used.
      expect(rangeBuffer.toString('ascii', 0, Number(3))).assertEqual('abc');
      expect(rangeBuffer.toString('ascii', 0, 1.99)).assertEqual('a');
    })

    it('Buffer_write1', 0, () => {
      // testing for smart defaults and ability to pass string values as offset
      let writeTest = new Buffer('abcdes');
      writeTest.write('n', 0, 0, 'ascii');
      writeTest.write('o', 1, 0, 'ascii');
      writeTest.write('d', 2, 0, 'ascii');
      writeTest.write('e', 3, 0, 'ascii');
      writeTest.write('j', 4, 0, 'ascii');
      expect(writeTest.toString()).assertEqual('abcdes');
    })

    it('Buffer_slice01', 0, () => {
      let asciiString = 'hello world';
      let offset = 100;

      let sliceA = b.slice(offset, offset + asciiString.length);
      let sliceB = b.slice(offset, offset + asciiString.length);
      for (let i = 0; i < asciiString.length; i++) {
        expect(sliceA[i]).assertEqual(sliceB[i]);
      }
    })

    it('Buffer_slice02', 0, () => {
      let utf8String = '¡hέlló wôrld!';
      let offset = 100;

      b.write(utf8String, 0, Buffer.byteLength(utf8String), 'utf8');
      let utf8Slice = b.toString('utf8', 0, Buffer.byteLength(utf8String));
      expect(utf8String).assertEqual('¡hέlló wôrld!');

      expect(Buffer.byteLength(utf8String)).assertEqual(17);
      utf8Slice = b.toString('utf8', offset, offset + Buffer.byteLength(utf8String));

      let sliceA = b.slice(offset, offset + Buffer.byteLength(utf8String));
      let sliceB = b.slice(offset, offset + Buffer.byteLength(utf8String));
      for (let i = 0; i < Buffer.byteLength(utf8String); i++) {
        expect(sliceA[i]).assertEqual(sliceB[i]);
      }
      let slice = b.slice(100, 150);
      expect(50).assertEqual(slice.length);
      for (let i = 0; i < 50; i++) {
        expect(b[100 + i]).assertEqual(slice[i]);
      }
    })

    it('Test_triple_slice', 0, () => {
      let a = new Buffer(8);
      for (let i = 0; i < 8; i++) a[i] = i;
      let b = a.slice(4, 8);
      expect(4).assertEqual(b[0]);
      expect(5).assertEqual(b[1]);
      expect(6).assertEqual(b[2]);
      expect(7).assertEqual(b[3]);
      let c = b.slice(2, 4);
      expect(6).assertEqual(c[0]);
      expect(7).assertEqual(c[1]);
    })

    it("toString_base64", 0, () => {
      expect((new Buffer('Man')).toString('base64')).assertEqual('TWFu');
    })

    it("Buffer_toString2", 0, () => {
      expect(new Buffer('', 'base64').toString()).assertEqual('');
      expect(new Buffer('K', 'base64').toString()).assertEqual('');

      // multiple-of-4 with padding
      expect(new Buffer('Kg==', 'base64').toString()).assertEqual('*');
      expect(new Buffer('Kio=', 'base64').toString()).assertEqual('**');
      expect(new Buffer('Kioq', 'base64').toString()).assertEqual('***');

      expect(new Buffer('KioqKg==', 'base64').toString()).assertEqual('****');
      expect(new Buffer('KioqKio=', 'base64').toString()).assertEqual('*****');
      expect(new Buffer('KioqKioq', 'base64').toString()).assertEqual('******');
      expect(new Buffer('KioqKioqKg==', 'base64').toString()).assertEqual('*******');
      expect(new Buffer('KioqKioqKio=', 'base64').toString()).assertEqual('********');
      expect(new Buffer('KioqKioqKioq', 'base64').toString()).assertEqual('*********');
      expect(new Buffer('KioqKioqKioqKg==', 'base64').toString()).assertEqual('**********');
      expect(new Buffer('KioqKioqKioqKio=', 'base64').toString()).assertEqual('***********');
      expect(new Buffer('KioqKioqKioqKioq', 'base64').toString()).assertEqual('************');
      expect(new Buffer('KioqKioqKioqKioqKg==', 'base64').toString()).assertEqual('*************');
      expect(new Buffer('KioqKioqKioqKioqKio=', 'base64').toString()).assertEqual('**************');
      expect(new Buffer('KioqKioqKioqKioqKioq', 'base64').toString()).assertEqual('***************');
      expect(new Buffer('KioqKioqKioqKioqKioqKg==', 'base64').toString()).assertEqual('****************');
      expect(new Buffer('KioqKioqKioqKioqKioqKio=', 'base64').toString()).assertEqual('*****************');
      expect(new Buffer('KioqKioqKioqKioqKioqKioq', 'base64').toString()).assertEqual('******************');
      expect(new Buffer('KioqKioqKioqKioqKioqKioqKg==', 'base64').toString()).assertEqual('*******************');
      expect(new Buffer('KioqKioqKioqKioqKioqKioqKio=', 'base64').toString()).assertEqual('********************');
    })

    it("test_hex_toString", 0, () => {
      let hexb = new Buffer(256);
      for (let i = 0; i < 256; i++) {
        hexb[i] = i;
      }
      let hexStr = hexb.toString('hex');
      expect(hexStr).assertEqual('000102030405060708090a0b0c0d0e0f' +
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
        'f0f1f2f3f4f5f6f7f8f9fafbfcfdfeff');
    })

    it("Buffer_write2", 0, () => {
      // test offset returns are correct
      let b = new Buffer(16);
      expect(b.writeUInt32LE(0, 0)).assertEqual(4);
      expect(b.writeUInt16LE(0, 4)).assertEqual(6);
      expect(b.writeUInt8(0, 6)).assertEqual(7);
      expect(b.writeInt8(0, 7)).assertEqual(8);
      expect(b.writeDoubleLE(0, 8)).assertEqual(16);
    })

    it("Buffer_isEncoding", 0, () => {
      [ 'hex',
        'utf8',
        'utf-8',
        'ascii',
        'latin1',
        'binary',
        'base64',
        'ucs2',
        'ucs-2',
        'utf16le',
        'utf-16le' ].forEach((enc)=> {
        expect(Buffer.isEncoding(enc)).assertEqual(true);
      });

      [ 'utf9',
        'utf-7',
        'Unicode-FTW',
        'new gnu gun' ].forEach((enc)=> {
        expect(Buffer.isEncoding(enc)).assertEqual(false);
      });
    })

    it("Buffer_equals", 0, () => {
      let buf = new Buffer('test');
      let json = JSON.stringify(buf);
      let obj: ESObject = JSON.parse(json);
      let copy = new Buffer(obj);
      expect(buf.equals(copy)).assertEqual(true);
    })

    it("Buffer_readUInt8", 0, () => {
      let bufs = new Buffer([0xFF]);
      expect(bufs.readUInt8(0)).assertEqual(255);
      expect(bufs.readInt8(0)).assertEqual(-1);
    })

    it("Buffer_readUInt01", 0, () => {
      [16, 32].forEach((bits)=> {
        let buf = new Buffer([0xFF, 0xFF, 0xFF, 0xFF]);
        expect(buf['readUInt' + bits + 'BE'](0)).assertEqual((0xFFFFFFFF >>> (32 - bits)));
        expect(buf['readUInt' + bits + 'LE'](0)).assertEqual((0xFFFFFFFF >>> (32 - bits)));
        expect(buf['readInt' + bits + 'BE'](0)).assertEqual((0xFFFFFFFF >> (32 - bits)));
        expect(buf['readInt' + bits + 'LE'](0)).assertEqual((0xFFFFFFFF >> (32 - bits)));
      });
    })

    it("read_IntLE_BE", 0, () => {
      let buf = new Buffer([0x01, 0x02, 0x03, 0x04, 0x05, 0x06]);

      expect(buf.readUIntLE(0, 1)).assertEqual(0x01);
      expect(buf.readUIntBE(0, 1)).assertEqual(0x01);
      expect(buf.readUIntLE(0, 3)).assertEqual(0x030201);
      expect(buf.readUIntBE(0, 3)).assertEqual(0x010203);
      expect(buf.readUIntLE(0, 5)).assertEqual(0x0504030201);
      expect(buf.readUIntBE(0, 5)).assertEqual(0x0102030405);
      expect(buf.readUIntLE(0, 6)).assertEqual(0x060504030201);
      expect(buf.readUIntBE(0, 6)).assertEqual(0x010203040506);
      expect(buf.readUIntLE(0, 5)).assertEqual(0x0504030201);
      expect(buf.readUIntLE(0, 5)).assertEqual(0x0504030201);
      expect(buf.readIntLE(0, 1)).assertEqual(0x01);
      expect(buf.readIntBE(0, 1)).assertEqual(0x01);
    })
  })
}