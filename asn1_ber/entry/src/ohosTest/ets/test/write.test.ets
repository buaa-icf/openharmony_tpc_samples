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
import { BerWriter } from '@ohos/asn1_ber'
import {buffer} from '@kit.ArkTS';

export default function writeTest() {
  describe("writeByte", () => {
    it("can write a value", 0, () => {
      let writer = new BerWriter()
      writer.writeByte(0xC2)
      let buffer: buffer.Buffer = writer.buffer
      expect(buffer.length).assertEqual(1)
      expect(buffer[0]).assertEqual(0xc2)
    })
  })

  describe("writeInt", () => {
    it("can write zero", 0, () => {
      let writer = new BerWriter()
      writer.writeInt(0)
      let buffer: buffer.Buffer = writer.buffer
      expect(buffer.length).assertEqual(3)
      expect(buffer[0]).assertEqual(0x02)
      expect(buffer[1]).assertEqual(0x01)
      expect(buffer[2]).assertEqual(0x00)
    })

    it("can write 1 byte positive integers - lowest", 0, () => {
      let writer = new BerWriter()
      writer.writeInt(1)
      let buffer: buffer.Buffer = writer.buffer
      expect(buffer.length).assertEqual(3)
      expect(buffer[0]).assertEqual(0x02)
      expect(buffer[1]).assertEqual(0x01)
      expect(buffer[2]).assertEqual(0x01)
    })

    it("can write 1 byte positive integers - middle", 0, () => {
      let writer = new BerWriter()
      writer.writeInt(101)
      let buffer: buffer.Buffer = writer.buffer
      expect(buffer.length).assertEqual(3)
      expect(buffer[0]).assertEqual(0x02)
      expect(buffer[1]).assertEqual(0x01)
      expect(buffer[2]).assertEqual(0x65)
    })

    it("can write 1 byte positive integers - highest", 0, () => {
      let writer = new BerWriter()
      writer.writeInt(127)
      let buffer: buffer.Buffer = writer.buffer
      expect(buffer.length).assertEqual(3)
      expect(buffer[0]).assertEqual(0x02)
      expect(buffer[1]).assertEqual(0x01)
      expect(buffer[2]).assertEqual(0x7f)
    })

    it("can write 2 byte positive integers - lowest", 0, () => {
      let writer = new BerWriter()
      writer.writeInt(128)
      let buffer: buffer.Buffer = writer.buffer
      expect(buffer.length).assertEqual(4)
      expect(buffer[0]).assertEqual(0x02)
      expect(buffer[1]).assertEqual(0x02)
      expect(buffer[2]).assertEqual(0x00)
      expect(buffer[3]).assertEqual(0x80)
    })

    it("can write 2 byte positive integers - middle", 0, () => {
      let writer = new BerWriter()
      writer.writeInt(9374)
      let buffer: buffer.Buffer = writer.buffer
      expect(buffer.length).assertEqual(4)
      expect(buffer[0]).assertEqual(0x02)
      expect(buffer[1]).assertEqual(0x02)
      expect(buffer[2]).assertEqual(0x24)
      expect(buffer[3]).assertEqual(0x9e)
    })

    it("can write 2 byte positive integers - highest", 0, () => {
      let writer = new BerWriter()
      writer.writeInt(32767)
      let buffer: buffer.Buffer = writer.buffer
      expect(buffer.length).assertEqual(4)
      expect(buffer[0]).assertEqual(0x02)
      expect(buffer[1]).assertEqual(0x02)
      expect(buffer[2]).assertEqual(0x7f)
      expect(buffer[3]).assertEqual(0xff)
    })

    it("can write 3 byte positive integers - lowest", 0, () => {
      let writer = new BerWriter()
      writer.writeInt(32768)
      let buffer: buffer.Buffer = writer.buffer
      expect(buffer.length).assertEqual(5)
      expect(buffer[0]).assertEqual(0x02)
      expect(buffer[1]).assertEqual(0x03)
      expect(buffer[2]).assertEqual(0x00)
      expect(buffer[3]).assertEqual(0x80)
      expect(buffer[4]).assertEqual(0x00)
    })

    it("can write 3 byte positive integers - middle", 0, () => {
      let writer = new BerWriter()
      writer.writeInt(5938243)
      let buffer: buffer.Buffer = writer.buffer
      expect(buffer.length).assertEqual(5)
      expect(buffer[0]).assertEqual(0x02)
      expect(buffer[1]).assertEqual(0x03)
      expect(buffer[2]).assertEqual(0x5a)
      expect(buffer[3]).assertEqual(0x9c)
      expect(buffer[4]).assertEqual(0x43)
    })

    it("can write 3 byte positive integers - highest", 0, () => {
      let writer = new BerWriter()
      writer.writeInt(8388607)
      let buffer: buffer.Buffer = writer.buffer
      expect(buffer.length).assertEqual(5)
      expect(buffer[0]).assertEqual(0x02)
      expect(buffer[1]).assertEqual(0x03)
      expect(buffer[2]).assertEqual(0x7f)
      expect(buffer[3]).assertEqual(0xff)
      expect(buffer[4]).assertEqual(0xff)
    })

    it("can write 4 byte positive integers - lowest", 0, () => {
      let writer = new BerWriter()
      writer.writeInt(8388608)
      let buffer: buffer.Buffer = writer.buffer
      expect(buffer.length).assertEqual(6)
      expect(buffer[0]).assertEqual(0x02)
      expect(buffer[1]).assertEqual(0x04)
      expect(buffer[2]).assertEqual(0x00)
      expect(buffer[3]).assertEqual(0x80)
      expect(buffer[4]).assertEqual(0x00)
      expect(buffer[5]).assertEqual(0x00)
    })

    it("can write 4 byte positive integers - middle", 0, () => {
      let writer = new BerWriter()
      writer.writeInt(1483722690)
      let buffer: buffer.Buffer = writer.buffer
      expect(buffer.length).assertEqual(6)
      expect(buffer[0]).assertEqual(0x02)
      expect(buffer[1]).assertEqual(0x04)
      expect(buffer[2]).assertEqual(0x58)
      expect(buffer[3]).assertEqual(0x6f)
      expect(buffer[4]).assertEqual(0xcf)
      expect(buffer[5]).assertEqual(0xc2)
    })

    it("can write 4 byte positive integers - highest", 0, () => {
      let writer = new BerWriter()
      writer.writeInt(2147483647)
      let buffer: buffer.Buffer = writer.buffer
      expect(buffer.length).assertEqual(6)
      expect(buffer[0]).assertEqual(0x02)
      expect(buffer[1]).assertEqual(0x04)
      expect(buffer[2]).assertEqual(0x7f)
      expect(buffer[3]).assertEqual(0xff)
      expect(buffer[4]).assertEqual(0xff)
      expect(buffer[5]).assertEqual(0xff)
    })

    it("can write 5 byte positive integers - lowest", 0, () => {
      let writer = new BerWriter()
      writer.writeInt(2147483648)
      let buffer: buffer.Buffer = writer.buffer
      expect(buffer.length).assertEqual(7)
      expect(buffer[0]).assertEqual(0x02)
      expect(buffer[1]).assertEqual(0x05)
      expect(buffer[2]).assertEqual(0x00)
      expect(buffer[3]).assertEqual(0x80)
      expect(buffer[4]).assertEqual(0x00)
      expect(buffer[5]).assertEqual(0x00)
      expect(buffer[6]).assertEqual(0x00)
    })

    it("can write 5 byte positive integers - middle", 0, () => {
      let writer = new BerWriter()
      writer.writeInt(3843548325)
      let buffer: buffer.Buffer = writer.buffer
      expect(buffer.length).assertEqual(7)
      expect(buffer[0]).assertEqual(0x02)
      expect(buffer[1]).assertEqual(0x05)
      expect(buffer[2]).assertEqual(0x00)
      expect(buffer[3]).assertEqual(0xe5)
      expect(buffer[4]).assertEqual(0x17)
      expect(buffer[5]).assertEqual(0xe4)
      expect(buffer[6]).assertEqual(0xa5)
    })

    it("can write 5 byte positive integers - highest", 0, () => {
      let writer = new BerWriter()
      writer.writeInt(4294967295)
      let buffer: buffer.Buffer = writer.buffer
      expect(buffer.length).assertEqual(7)
      expect(buffer[0]).assertEqual(0x02)
      expect(buffer[1]).assertEqual(0x05)
      expect(buffer[2]).assertEqual(0x00)
      expect(buffer[3]).assertEqual(0xff)
      expect(buffer[4]).assertEqual(0xff)
      expect(buffer[5]).assertEqual(0xff)
      expect(buffer[6]).assertEqual(0xff)
    })

    it("can write 1 byte negative integers - lowest", 0, () => {
      let writer = new BerWriter()
      writer.writeInt(-128)
      let buffer: buffer.Buffer = writer.buffer
      expect(buffer.length).assertEqual(3)
      expect(buffer[0]).assertEqual(0x02)
      expect(buffer[1]).assertEqual(0x01)
      expect(buffer[2]).assertEqual(0x80)
    })

    it("can write 1 byte negative integers - middle", 0, () => {
      let writer = new BerWriter()
      writer.writeInt(-73)
      let buffer: buffer.Buffer = writer.buffer
      expect(buffer.length).assertEqual(3)
      expect(buffer[0]).assertEqual(0x02)
      expect(buffer[1]).assertEqual(0x01)
      expect(buffer[2]).assertEqual(0xb7)
    })

    it("can write 1 byte negative integers - highest", 0, () => {
      let writer = new BerWriter()
      writer.writeInt(-1)
      let buffer: buffer.Buffer = writer.buffer
      expect(buffer.length).assertEqual(3)
      expect(buffer[0]).assertEqual(0x02)
      expect(buffer[1]).assertEqual(0x01)
      expect(buffer[2]).assertEqual(0xff)
    })

    it("can write 2 byte negative integers - lowest", 0, () => {
      let writer = new BerWriter()
      writer.writeInt(-32768)
      let buffer: buffer.Buffer = writer.buffer
      expect(buffer.length).assertEqual(4)
      expect(buffer[0]).assertEqual(0x02)
      expect(buffer[1]).assertEqual(0x02)
      expect(buffer[2]).assertEqual(0x80)
      expect(buffer[3]).assertEqual(0x00)
    })

    it("can write 2 byte negative integers - middle", 0, () => {
      let writer = new BerWriter()
      writer.writeInt(-22400)
      let buffer: buffer.Buffer = writer.buffer
      expect(buffer.length).assertEqual(4)
      expect(buffer[0]).assertEqual(0x02)
      expect(buffer[1]).assertEqual(0x02)
      expect(buffer[2]).assertEqual(0xa8)
      expect(buffer[3]).assertEqual(0x80)
    })

    it("can write 2 byte negative integers - highest", 0, () => {
      let writer = new BerWriter()
      writer.writeInt(-129)
      let buffer: buffer.Buffer = writer.buffer
      expect(buffer.length).assertEqual(4)
      expect(buffer[0]).assertEqual(0x02)
      expect(buffer[1]).assertEqual(0x02)
      expect(buffer[2]).assertEqual(0xff)
      expect(buffer[3]).assertEqual(0x7f)
    })

    it("can write 3 byte negative integers - lowest", 0, () => {
      let writer = new BerWriter()
      writer.writeInt(-8388608)
      let buffer: buffer.Buffer = writer.buffer
      expect(buffer.length).assertEqual(5)
      expect(buffer[0]).assertEqual(0x02)
      expect(buffer[1]).assertEqual(0x03)
      expect(buffer[2]).assertEqual(0x80)
      expect(buffer[3]).assertEqual(0x00)
      expect(buffer[4]).assertEqual(0x00)
    })

    it("can write 3 byte negative integers - middle", 0, () => {
      let writer = new BerWriter()
      writer.writeInt(-481653)
      let buffer: buffer.Buffer = writer.buffer
      expect(buffer.length).assertEqual(5)
      expect(buffer[0]).assertEqual(0x02)
      expect(buffer[1]).assertEqual(0x03)
      expect(buffer[2]).assertEqual(0xf8)
      expect(buffer[3]).assertEqual(0xa6)
      expect(buffer[4]).assertEqual(0x8b)
    })

    it("can write 3 byte negative integers - highest", 0, () => {
      let writer = new BerWriter()
      writer.writeInt(-32769)
      let buffer: buffer.Buffer = writer.buffer
      expect(buffer.length).assertEqual(5)
      expect(buffer[0]).assertEqual(0x02)
      expect(buffer[1]).assertEqual(0x03)
      expect(buffer[2]).assertEqual(0xff)
      expect(buffer[3]).assertEqual(0x7f)
      expect(buffer[4]).assertEqual(0xff)
    })

    it("can write 4 byte negative integers - lowest", 0, () => {
      let writer = new BerWriter()
      writer.writeInt(-2147483648)
      let buffer: buffer.Buffer = writer.buffer
      expect(buffer.length).assertEqual(6)
      expect(buffer[0]).assertEqual(0x02)
      expect(buffer[1]).assertEqual(0x04)
      expect(buffer[2]).assertEqual(0x80)
      expect(buffer[3]).assertEqual(0x00)
      expect(buffer[4]).assertEqual(0x00)
      expect(buffer[5]).assertEqual(0x00)
    })

    it("can write 4 byte negative integers - middle", 0, () => {
      let writer = new BerWriter()
      writer.writeInt(-1522904131)
      let buffer: buffer.Buffer = writer.buffer
      expect(buffer.length).assertEqual(6)
      expect(buffer[0]).assertEqual(0x02)
      expect(buffer[1]).assertEqual(0x04)
      expect(buffer[2]).assertEqual(0xa5)
      expect(buffer[3]).assertEqual(0x3a)
      expect(buffer[4]).assertEqual(0x53)
      expect(buffer[5]).assertEqual(0xbd)
    })

    it("can write 4 byte negative integers - highest", 0, () => {
      let writer = new BerWriter()
      writer.writeInt(-8388609)
      let buffer: buffer.Buffer = writer.buffer
      expect(buffer.length).assertEqual(6)
      expect(buffer[0]).assertEqual(0x02)
      expect(buffer[1]).assertEqual(0x04)
      expect(buffer[2]).assertEqual(0xff)
      expect(buffer[3]).assertEqual(0x7f)
      expect(buffer[4]).assertEqual(0xff)
      expect(buffer[5]).assertEqual(0xff)
    })
  })

  describe("writeBoolean", () => {
    it("can write a true and false value", 0, () => {
      let writer = new BerWriter()
      writer.writeBoolean(true)
      writer.writeBoolean(false)
      let buffer: buffer.Buffer = writer.buffer
      expect(buffer.length).assertEqual(6)
      expect(buffer[0]).assertEqual(0x01)
      expect(buffer[1]).assertEqual(0x01)
      expect(buffer[2]).assertEqual(0xff)
      expect(buffer[3]).assertEqual(0x01)
      expect(buffer[4]).assertEqual(0x01)
      expect(buffer[5]).assertEqual(0x00)
    })
  })

  describe("writeString", () => {
    it("can write a value", 0, () => {
      let writer = new BerWriter()
      writer.writeString("hello world")
      let buffer: buffer.Buffer = writer.buffer
      expect(buffer.length).assertEqual(13)
      expect(buffer[0]).assertEqual(0x04)
      expect(buffer[1]).assertEqual(11)
      expect(buffer.subarray(2).toString("utf8")).assertEqual("hello world")
    })
  })

  describe("writeBuffer", () => {
    it("can write a value", 0, () => {
      let writer = new BerWriter()
      writer.writeString("hello world")
      let expected:buffer.Buffer = buffer.from([
        0x04, 0x0b, 0x30, 0x09, 0x02, 0x01, 0x0f, 0x01,
        0x01, 0xff, 0x01, 0x01, 0xff
      ])
      writer.writeBuffer(expected.subarray(2, expected.length), 0x04)
      let buffer1: buffer.Buffer = writer.buffer;
      expect(buffer1.length).assertEqual(26)
      expect(buffer1[0]).assertEqual(0x04)
      expect(buffer1[1]).assertEqual(11)
      expect(buffer1.subarray(2, 13).toString("utf8")).assertEqual("hello world")
      expect(buffer1[13]).assertEqual(expected[0])
      expect(buffer1[14]).assertEqual(expected[1])
      for (let i = 13, j = 0; i < buffer1.length && j < expected.length; i++, j++) {
        expect(buffer1[i]).assertEqual( expected[j])
      }
    })
  })

  describe("writeStringArray", () => {
    it("can write an array of strings", 0, () => {
      let writer = new BerWriter()
      writer.writeStringArray(["hello world", "fubar!"])
      let buffer: buffer.Buffer = writer.buffer
      expect(buffer.length).assertEqual(21)
      expect(buffer[0]).assertEqual(0x04)
      expect(buffer[1]).assertEqual(11)
      expect(buffer.subarray(2, 13).toString("utf8")).assertEqual("hello world")
      expect(buffer[13]).assertEqual(0x04)
      expect(buffer[14]).assertEqual(6)
      expect(buffer.subarray(15).toString("utf8")).assertEqual("fubar!")
    })
  })

  describe("oversized_data", () => {
    it("results in a buffer resize", 0, () => {
      let writer = new BerWriter({
        size: 2
      })
      writer.writeString("hello world")
      let buffer: buffer.Buffer = writer.buffer
      expect(buffer.length).assertEqual(13)
      expect(buffer[0]).assertEqual(0x04)
      expect(buffer[1]).assertEqual(11)
      expect(buffer.subarray(2).toString("utf8")).assertEqual("hello world")
    })
  })

  describe("complexsequences", () => {
    it("are processed correctly", 0, () => {
      let writer = new BerWriter({
        size: 25
      })
      writer.startSequence()
      writer.writeString("hello world")
      writer.endSequence()

      let buffer: buffer.Buffer = writer.buffer
      expect(buffer.length).assertEqual(15)
      expect(buffer[0]).assertEqual(0x30)
      expect(buffer[1]).assertEqual(13)
      expect(buffer[2]).assertEqual(0x04)
      expect(buffer[3]).assertEqual(11)
      expect(buffer.subarray(4).toString("utf8")).assertEqual("hello world")
    })
  })

  describe("nested_sequences", () => {
    it("are processed correctly", 0, () => {
      let writer = new BerWriter({
        size: 25
      })
      writer.startSequence()
      writer.writeString("hello world")
      writer.startSequence()
      writer.writeString("hello world")
      writer.endSequence()
      writer.endSequence()

      let buffer: buffer.Buffer = writer.buffer
      expect(buffer.length).assertEqual(30)
      expect(buffer[0]).assertEqual( 0x30)
      expect(buffer[1]).assertEqual( 28)
      expect(buffer[2]).assertEqual( 0x04)
      expect(buffer[3]).assertEqual( 11)
      expect(buffer.subarray(4, 15).toString("utf8")).assertEqual( "hello world")
      expect(buffer[15]).assertEqual( 0x30)
      expect(buffer[16]).assertEqual( 13)
      expect(buffer[17]).assertEqual( 0x04)
      expect(buffer[18]).assertEqual( 11)
      expect(buffer.subarray(19, 30).toString("utf8")).assertEqual("hello world")
    })
  })

  describe("multiple_sequences", () => {
    it("are processed correctly", 0, () => {
      // An anonymous LDAP v3 BIND request
      let dn = "cn=foo,ou=unit,o=test"
      let writer = new BerWriter()
      writer.startSequence()
      writer.writeInt(3)
      writer.startSequence(0x60)
      writer.writeInt(3)
      writer.writeString(dn)
      writer.writeByte(0x80)
      writer.writeByte(0x00)
      writer.endSequence()
      writer.endSequence()

      let buffer: buffer.Buffer = writer.buffer
      expect(buffer.length).assertEqual(35)
      expect(buffer[0]).assertEqual(0x30)
      expect(buffer[1]).assertEqual(33)
      expect(buffer[2]).assertEqual(0x02)
      expect(buffer[3]).assertEqual(1)
      expect(buffer[4]).assertEqual(0x03)
      expect(buffer[5]).assertEqual(0x60)
      expect(buffer[6]).assertEqual(28)
      expect(buffer[7]).assertEqual(0x02)
      expect(buffer[8]).assertEqual(1)
      expect(buffer[9]).assertEqual(0x03)
      expect(buffer[10]).assertEqual(0x04)
      expect(buffer[11]).assertEqual(dn.length)
      expect(buffer.subarray(12, 33).toString("utf8")).assertEqual(dn)
      expect(buffer[33]).assertEqual(0x80)
      expect(buffer[34]).assertEqual(0x00)
    })
  })

  describe("writeOID", () => {
    it("can write a value", 0, () => {
      let writer = new BerWriter()
      writer.writeOID("1.2.840.113549.1.1.1")
      let buffer: buffer.Buffer = writer.buffer
      expect(buffer.toString("hex")).assertEqual("06092a864886f70d010101")
    })
  })
}