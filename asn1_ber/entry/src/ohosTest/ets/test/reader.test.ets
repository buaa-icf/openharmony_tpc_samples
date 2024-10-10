/*
 * (The MIT License)

 * Copyright (c) 2023 Huawei Device Co., Ltd.

 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * 'Software'), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:

 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.

 * THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
 * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import { describe, it, expect } from '@ohos/hypium';
import { BerReader } from '@ohos/asn1_ber'
import Buffer from '@ohos.buffer';

export default function readerTest() {
  describe('readByte', () => {
    it('can read a value', 0, () => {
      let reader = new BerReader(Buffer.from([0xde]))
      expect(reader.readByte(false)).assertEqual(0xde)
    })
  })

  describe('readInt', () => {
    it("can read zero", 0, () => {
      let reader = new BerReader(Buffer.from([0x02, 0x01, 0x00]))
      expect(reader.readInt()).assertEqual(0)
      expect(reader.length).assertEqual(1)
    })

    it("can read a 1 byte positive integer - lowest", 0, () => {
      let reader = new BerReader(Buffer.from([0x02, 0x01, 0x01]))
      expect(reader.readInt()).assertEqual(1)
      expect(reader.length).assertEqual(1)
    })

    it("can read a 1 byte positive integer - middle", 0, () => {
      let reader = new BerReader(Buffer.from([0x02, 0x01, 0x34]))
      expect(reader.readInt()).assertEqual(52)
      expect(reader.length).assertEqual(1)
    })

    it("can read a 1 byte positive integer - highest", 0, () => {
      let reader = new BerReader(Buffer.from([0x02, 0x01, 0x7f]))
      expect(reader.readInt()).assertEqual(127)
      expect(reader.length).assertEqual(1)
    })

    it("can read a 2 byte positive integer - lowest", 0, () => {
      let reader = new BerReader(Buffer.from([0x02, 0x02, 0x00, 0x80]))
      expect(reader.readInt()).assertEqual(128)
      expect(reader.length).assertEqual(2)
    })

    it("can read a 2 byte positive integer - middle", 0, () => {
      let reader = new BerReader(Buffer.from([0x02, 0x02, 0x7e, 0xde]))
      expect(reader.readInt()).assertEqual(0x7ede)
      expect(reader.length).assertEqual(2)
    })

    it("can read a 2 byte positive integer - highest", 0, () => {
      let reader = new BerReader(Buffer.from([0x02, 0x02, 0x7f, 0xff]))
      expect(reader.readInt()).assertEqual(32767)
      expect(reader.length).assertEqual(2)
    })

    it("can read a 3 byte positive integer - lowest", 0, () => {
      let reader = new BerReader(Buffer.from([0x02, 0x03, 0x00, 0x80, 0x00]))
      expect(reader.readInt()).assertEqual(32768)
      expect(reader.length).assertEqual(3)
    })

    it("can read a 3 byte positive integer - middle", 0, () => {
      let reader = new BerReader(Buffer.from([0x02, 0x03, 0x7e, 0xde, 0x03]))
      expect(reader.readInt()).assertEqual(8314371)
      expect(reader.length).assertEqual(3)
    })

    it("can read a 3 byte positive integer - highest", 0, () => {
      let reader = new BerReader(Buffer.from([0x02, 0x03, 0x7e, 0xde, 0x03]))
      expect(reader.readInt()).assertEqual(0x7ede03)
      expect(reader.length).assertEqual(0x03)
    })

    it("can read a 4 byte positive integer - lowest", 0, () => {
      let reader = new BerReader(Buffer.from([0x02, 0x04, 0x00, 0x80, 0x00, 0x00]))
      expect(reader.readInt(),).assertEqual(8388608)
      expect(reader.length,).assertEqual(4)
    })

    it("can read a 4 byte positive integer - middle", 0, () => {
      let reader = new BerReader(Buffer.from([0x02, 0x04, 0x7e, 0xde, 0x03, 0x01]))
      expect(reader.readInt(),).assertEqual(2128478977)
      expect(reader.length,).assertEqual(4)
    })

    it("can read a 4 byte positive integer - highest", 0, () => {
      let reader = new BerReader(Buffer.from([0x02, 0x04, 0x7f, 0xff, 0xff, 0xff]))
      expect(reader.readInt(),).assertEqual(2147483647)
      expect(reader.length,).assertEqual(4)
    })

    it("can read a 5 byte positive integer - lowest", 0, () => {
      let reader = new BerReader(Buffer.from([0x02, 0x05, 0x00, 0x80, 0x00, 0x00, 0x00]))
      expect(reader.readInt(),).assertEqual(2147483648)
      expect(reader.length,).assertEqual(5)
    })

    it("can read a 5 byte positive integer - middle", 0, () => {
      let reader = new BerReader(Buffer.from([0x02, 0x05, 0x00, 0x8b, 0xde, 0x03, 0x01]))
      expect(reader.readInt(),).assertEqual(2346582785)
      expect(reader.length,).assertEqual(5)
    })

    it("can read a 5 byte positive integer - highest", 0, () => {
      let reader = new BerReader(Buffer.from([0x02, 0x05, 0x00, 0xff, 0xff, 0xff, 0xff]))
      expect(reader.readInt(),).assertEqual(4294967295)
      expect(reader.length,).assertEqual(5)
    })

    it("can read a 1 byte negative integer - lowest", 0, () => {
      let reader = new BerReader(Buffer.from([0x02, 0x01, 0x80]))
      expect(reader.readInt(),).assertEqual(-128)
      expect(reader.length,).assertEqual(1)
    })

    it("can read a 1 byte negative integer - middle", 0, () => {
      let reader = new BerReader(Buffer.from([0x02, 0x01, 0xdc]))
      expect(reader.readInt(),).assertEqual(-36)
      expect(reader.length,).assertEqual(1)
    })

    it("can read a 1 byte negative integer - highest", 0, () => {
      let reader = new BerReader(Buffer.from([0x02, 0x01, 0xff]))
      expect(reader.readInt(),).assertEqual(-1)
      expect(reader.length,).assertEqual(1)
    })

    it("can read a 2 byte negative integer - lowest", 0, () => {
      let reader = new BerReader(Buffer.from([0x02, 0x02, 0x80, 0x00]))
      expect(reader.readInt(),).assertEqual(-32768)
      expect(reader.length,).assertEqual(2)
    })

    it("can read a 2 byte negative integer - middle", 0, () => {
      let reader = new BerReader(Buffer.from([0x02, 0x02, 0xc0, 0x4e]))
      expect(reader.readInt(),).assertEqual(-16306)
      expect(reader.length,).assertEqual(2)
    })

    it("can read a 2 byte negative integer - highest", 0, () => {
      let reader = new BerReader(Buffer.from([0x02, 0x02, 0xff, 0x7f]))
      expect(reader.readInt(),).assertEqual(-129)
      expect(reader.length,).assertEqual(2)
    })

    it("can read a 3 byte negative integer - lowest", 0, () => {
      let reader = new BerReader(Buffer.from([0x02, 0x03, 0x80, 0x00, 0x00]))
      expect(reader.readInt(),).assertEqual(-8388608)
      expect(reader.length,).assertEqual(3)
    })

    it("can read a 3 byte negative integer - middle", 0, () => {
      let reader = new BerReader(Buffer.from([0x02, 0x03, 0xff, 0x00, 0x19]))
      expect(reader.readInt(),).assertEqual(-65511)
      expect(reader.length,).assertEqual(3)
    })

    it("can read a 3 byte negative integer - highest", 0, () => {
      let reader = new BerReader(Buffer.from([0x02, 0x03, 0xff, 0x7f, 0xff]))
      expect(reader.readInt(),).assertEqual(-32769)
      expect(reader.length,).assertEqual(3)
    })

    it("can read a 4 byte negative integer - lowest", 0, () => {
      let reader = new BerReader(Buffer.from([0x02, 0x04, 0x80, 0x00, 0x00, 0x00]))
      expect(reader.readInt(),).assertEqual(-2147483648)
      expect(reader.length,).assertEqual(4)
    })

    it("can read a 4 byte negative integer - middle", 0, () => {
      let reader = new BerReader(Buffer.from([0x02, 0x04, 0x91, 0x7c, 0x22, 0x1f]))
      expect(reader.readInt(),).assertEqual(-1854135777)
      expect(reader.length,).assertEqual(4)
    })

    it("can read a 4 byte negative integer - highest", 0, () => {
      let reader = new BerReader(Buffer.from([0x02, 0x04, 0xff, 0x7f, 0xff, 0xff]))
      expect(reader.readInt(),).assertEqual(-8388609)
      expect(reader.length,).assertEqual(4)
    })
  })

  describe("readBoolean", () => {
    it("can read a true value", 0, () => {
      let reader = new BerReader(Buffer.from([0x01, 0x01, 0xff]))
      expect(reader.readBoolean(),).assertEqual(true)
      expect(reader.length,).assertEqual(0x01)
    })

    it("can read a false value", 0, () => {
      let reader = new BerReader(Buffer.from([0x01, 0x01, 0x00]))
      expect(reader.readBoolean(),).assertEqual(false)
      expect(reader.length,).assertEqual(0x01)
    })
  })

  describe("readEnumeration", () => {
    it("can read a value", 0, () => {
      let reader = new BerReader(Buffer.from([0x0a, 0x01, 0x20]))
      expect(reader.readEnumeration()).assertEqual(0x20)
      expect(reader.length).assertEqual(0x01)
    })
  })

  describe("readOID", () => {
    it("does not convert to unsigned", 0, () => {
      // Make sure 2887117176 is NOT converted to -1407850120
      let buffer = Buffer.from([6, 18, 43, 6, 1, 4, 1, 245, 12, 1, 1, 5, 1, 1, 19, 138, 224, 215, 210, 120])
      let reader = new BerReader(buffer)
      expect(reader.readOID()).assertEqual("1.3.6.1.4.1.14988.1.1.5.1.1.19.2887117176")
      expect(reader.length).assertEqual(18)
    })
  })

  describe("readString", () => {
    it("can read a value", 0, () => {
      let string = 'cn=foo,ou=unit,o=test'
      let buffer = Buffer.alloc(string.length + 2)
      buffer[0] = 0x04
      buffer[1] = Buffer.byteLength(string)
      buffer.write(string, 2)

      let reader = new BerReader(buffer)
      expect(reader.readString()).assertEqual(string)
      expect(reader.length).assertEqual(string.length)
    })
  })

  describe("readSequence", () => {
    it("can read a sequence", 0, () => {
      let reader = new BerReader(Buffer.from([0x30, 0x03, 0x01, 0x01, 0xff]))
      expect(reader.readSequence()).assertEqual(0x30)
      expect(reader.length).assertEqual(0x03)
      expect(reader.readBoolean()).assertEqual(true)
      expect(reader.length).assertEqual(0x01)
    })
  })

  describe("readBitString", () => {
    it("can read a bit string", 0, () => {
      let reader = new BerReader(Buffer.from([0x03, 0x07, 0x04, 0x0a, 0x3b, 0x5f, 0x29, 0x1c, 0xd0]))
      expect(reader.readBitString()).assertEqual('00001010001110110101111100101001000111001101')
      expect(reader.length).assertEqual(7)
    })
  })

  describe("complex_sequences", () => {
    it("are processed correctly", 0, () => {
      let buffer = Buffer.alloc(14);

      // An anonymous LDAP v3 BIND request
      buffer[0] = 0x30 // Sequence
      buffer[1] = 12 // len
      buffer[2] = 0x02 // ASN.1 Integer
      buffer[3] = 1 // len
      buffer[4] = 0x04 // msgid (make up 4)
      buffer[5] = 0x60 // Bind Request
      buffer[6] = 7 // len
      buffer[7] = 0x02 // ASN.1 Integer
      buffer[8] = 1 // len
      buffer[9] = 0x03 // v3
      buffer[10] = 0x04 // String (bind dn)
      buffer[11] = 0 // len
      buffer[12] = 0x80 // ContextSpecific (choice)
      buffer[13] = 0 // simple bind

      let reader = new BerReader(buffer)
      expect(reader.readSequence()).assertEqual(48)
      expect(reader.length).assertEqual(12)
      expect(reader.readInt()).assertEqual(4)
      expect(reader.readSequence()).assertEqual(96)
      expect(reader.length).assertEqual(7)
      expect(reader.readInt()).assertEqual(3)
      expect(reader.readString()).assertEqual("")
      expect(reader.length).assertEqual(0)
      expect(reader.readByte(false)).assertEqual(0x80)
      expect(reader.readByte(false)).assertEqual(0)
    })
  })

  describe("long_strings", () => {
    it("can be parsed", 0, () => {
      let buffer = Buffer.alloc(256)
      let string = "2;649;CN=Red Hat CS 71GA Demo,O=Red Hat CS 71GA Demo,C=US;"
        + "CN=RHCS Agent - admin01,UID=admin01,O=redhat,C=US [1] This is "
        + "Teena Vradmin's description."
      buffer[0] = 0x04
      buffer[1] = 0x81
      buffer[2] = 0x94
      buffer.write(string, 3)

      let reader = new BerReader(buffer.subarray(0, 3 + string.length));
      expect(reader.readString()).assertEqual(string)
    })
  })
}