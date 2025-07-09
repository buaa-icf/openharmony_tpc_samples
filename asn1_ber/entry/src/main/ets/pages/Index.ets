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

import { BerReader, BerWriter } from '@ohos/asn1_ber'
import Buffer from '@ohos.buffer';
import { buffer } from '@kit.ArkTS';

@Entry
@Component
struct Index {
  @State result: string = '';
  @State message: string = '';
  private scrollerForList: Scroller = new Scroller();
  private TAG: string = '[asn1_ber]: ';

  aboutToAppear(): void {
    try {
      this.message = this.getUIContext().getHostContext()?.resourceManager.getStringSync($r('app.string.run')) || '';
    }catch (e) {
      this.message = '';
      console.info(this.TAG + JSON.stringify(e));
    }
  }

  build() {
    Column() {
      Button(this.message)
        .fontSize(18)
        .width(120)
        .fontWeight(FontWeight.Bold)
        .align(Alignment.Center)
        .margin({ top: 20 })
        .onClick(() => {
          this.readByte()
          this.readInt()
          this.readBoolean()
          this.readEnumeration()
          this.readOID()
          this.readString()
          this.readSequence()
          this.readBitString()
          this.complex_sequences()
          this.long_strings()

          this.writeByte()
          this.writeInt()
          this.writeBoolean()
          this.writeString()
          this.writeBuffer()
          this.writeStringArray()
          this.oversized_data()
          this.complexsequences()
          this.nested_sequences_write()
          this.multiple_sequences_write()
          this.writeOID()
        })
      Scroll(this.scrollerForList) {
        Text(this.result)
          .fontSize(16)
          .align(Alignment.TopStart)
      }
      .margin({ top: 20 })
      .height('90%')
      .width('100%')
    }
    .height('100%')
    .width('100%')
  }

  private readByte() {
    let reader = new BerReader(Buffer.from([0xde]))
    this.result += 'readByte\r\n'
    this.result += '--> reader.internalBuffer: ' + (reader.readByte(false) == 0xde) + '\r\n'
  }

  private readInt() {
    let reader = new BerReader(Buffer.from([0x02, 0x01, 0x00]))
    this.result += 'readInt\r\n'
    this.result += '--> read zero: ' + (reader.readInt() == 0) + '\r\n'
    this.result += '--> read zero: ' + (reader.length == 1) + '\r\n'

    let reader1 = new BerReader(Buffer.from([0x02, 0x01, 0x01]))
    this.result += '--> read a 1 byte positive - lowest: ' + (reader1.readInt() == 1) + '\r\n'
    this.result += '--> read a 1 byte positive - lowest: ' + (reader1.length == 1) + '\r\n'

    let reader2 = new BerReader(Buffer.from([0x02, 0x01, 0x34]))
    this.result += '--> read a 1 byte positive - middle: ' + (reader2.readInt() == 52) +
      '\r\n'
    this.result += '--> read a 1 byte positive - middle: ' + (reader2.length == 1) + '\r\n'


    let reader3 = new BerReader(Buffer.from([0x02, 0x01, 0x7f]))
    this.result += '--> read a 1 byte positive - highest: ' + (reader3.readInt() == 127) +
      '\r\n'
    this.result += '--> read a 1 byte positive - highest: ' + (reader3.length == 1) + '\r\n'

    let reader4 = new BerReader(Buffer.from([0x02, 0x02, 0x00, 0x80]))
    this.result += '--> read a 2 byte positive - lowest: ' + (reader4.readInt() == 128) +
      '\r\n'
    this.result += '--> read a 2 byte positive - lowest: ' + (reader4.length == 2) + '\r\n'

    let reader5 = new BerReader(Buffer.from([0x02, 0x02, 0x7e, 0xde]))
    this.result += '--> read a 2 byte positive - middle: ' + (reader5.readInt() == 0x7ede) +
      '\r\n'
    this.result += '--> read a 2 byte positive - middle: ' + (reader5.length == 2) + '\r\n'

    let reader6 = new BerReader(Buffer.from([0x02, 0x02, 0x7f, 0xff]))
    this.result += '--> read a 2 byte positive - middle: ' + (reader6.readInt() == 32767) +
      '\r\n'
    this.result += '--> read a 2 byte positive - middle: ' + (reader6.length == 2) + '\r\n'

    let reader7 = new BerReader(Buffer.from([0x02, 0x03, 0x00, 0x80, 0x00]))
    this.result += '--> read a 3 byte positive - lowest: ' + (reader7.readInt() == 32768) +
      '\r\n'
    this.result += '--> read a 3 byte positive - lowest: ' + (reader7.length == 3) + '\r\n'

    let reader8 = new BerReader(Buffer.from([0x02, 0x03, 0x7e, 0xde, 0x03]))
    this.result += '--> read a 3 byte positive - middle: ' + (reader8.readInt() == 8314371) +
      '\r\n'
    this.result += '--> read a 3 byte positive - middle: ' + (reader8.length == 3) + '\r\n'

    let reader9 = new BerReader(Buffer.from([0x02, 0x03, 0x7e, 0xde, 0x03]))
    this.result += '--> read a 3 byte positive - highest: ' +
    JSON.stringify(reader9.readInt() == 0x7ede03) + '\r\n'
    this.result += '--> read a 3 byte positive - highest: ' + (reader9.length == 3) + '\r\n'

    let reader10 = new BerReader(Buffer.from([0x02, 0x04, 0x00, 0x80, 0x00, 0x00]))
    this.result += '--> read a 4 byte positive - lowest: ' + (reader10.readInt() == 8388608) +
      '\r\n'
    this.result += '--> read a 4 byte positive - lowest: ' + (reader10.length == 4) + '\r\n'

    let reader11 = new BerReader(Buffer.from([0x02, 0x04, 0x7e, 0xde, 0x03, 0x01]))
    this.result += '--> read a 4 byte positive - middle: ' +
    JSON.stringify(reader11.readInt() == 2128478977) + '\r\n'
    this.result += '--> read a 4 byte positive - middle: ' + (reader11.length == 4) + '\r\n'

    let reader12 = new BerReader(Buffer.from([0x02, 0x04, 0x7f, 0xff, 0xff, 0xff]))
    this.result += '--> read a 4 byte positive - highest: ' +
    JSON.stringify(reader12.readInt() == 2147483647) + '\r\n'
    this.result += '--> read a 4 byte positive - highest: ' + (reader12.length == 4) + '\r\n'

    let reader13 = new BerReader(Buffer.from([0x02, 0x05, 0x00, 0x80, 0x00, 0x00, 0x00]))
    this.result += '--> read a 5 byte positive - lowest: ' +
    JSON.stringify(reader13.readInt() == 2147483648) + '\r\n'
    this.result += '--> read a 5 byte positive - lowest: ' + (reader13.length == 5) + '\r\n'

    let reader14 = new BerReader(Buffer.from([0x02, 0x05, 0x00, 0x8b, 0xde, 0x03, 0x01]))
    this.result += '--> read a 5 byte positive - middle: ' + (reader14.readInt() == 2346582785) + '\r\n'
    this.result += '--> read a 5 byte positive - middle: ' + (reader14.length == 5) + '\r\n'

    let reader15 = new BerReader(Buffer.from([0x02, 0x05, 0x00, 0xff, 0xff, 0xff, 0xff]))
    this.result += '--> read a 5 byte positive - highest: ' + (reader15.readInt() == 4294967295) + '\r\n'
    this.result += '--> read a 5 byte positive - highest: ' + (reader15.length == 5) + '\r\n'

    let reader16 = new BerReader(Buffer.from([0x02, 0x01, 0x80]))
    this.result += '--> read a 1 byte negative - lowest: ' + (reader16.readInt() == -128) + '\r\n'
    this.result += '--> read a 1 byte negative - lowest: ' + (reader16.length == 1) + '\r\n'

    let reader17 = new BerReader(Buffer.from([0x02, 0x01, 0xdc]))
    this.result += '--> read a 1 byte negative - middle: ' + (reader17.readInt() == -36) + '\r\n'
    this.result += '--> read a 1 byte negative - middle: ' + (reader17.length == 1) + '\r\n'

    let reader18 = new BerReader(Buffer.from([0x02, 0x01, 0xff]))
    this.result += '--> read a 1 byte negative - highest: ' + (reader18.readInt() == -1) + '\r\n'
    this.result += '--> read a 1 byte negative - highest: ' + (reader18.length == 1) + '\r\n'

    let reader19 = new BerReader(Buffer.from([0x02, 0x02, 0x80, 0x00]))
    this.result += '--> read a 2 byte negative - lowest: ' + (reader19.readInt() == -32768) + '\r\n'
    this.result += '--> read a 2 byte negative - lowest: ' + (reader19.length == 2) + '\r\n'

    let reader20 = new BerReader(Buffer.from([0x02, 0x02, 0xc0, 0x4e]))
    this.result += '--> read a 2 byte negative - middle: ' + (reader20.readInt() == -16306) + '\r\n'
    this.result += '--> read a 2 byte negative - middle: ' + (reader20.length == 2) + '\r\n'

    let reader21 = new BerReader(Buffer.from([0x02, 0x02, 0xff, 0x7f]))
    this.result += '--> read a 2 byte negative - highest: ' + (reader21.readInt() == -129) + '\r\n'
    this.result += '--> read a 2 byte negative - highest: ' + (reader21.length == 2) + '\r\n'

    let reader22 = new BerReader(Buffer.from([0x02, 0x03, 0x80, 0x00, 0x00]))
    this.result += '--> read a 3 byte negative - lowest: ' + (reader22.readInt() == -8388608) + '\r\n'
    this.result += '--> read a 3 byte negative - lowest: ' + (reader22.length == 3) + '\r\n'

    let reader23 = new BerReader(Buffer.from([0x02, 0x03, 0xff, 0x00, 0x19]))
    this.result += '--> read a 3 byte negative - middle: ' + (reader23.readInt() == -65511) + '\r\n'
    this.result += '--> read a 3 byte negative - middle: ' + (reader23.length == 3) + '\r\n'

    let reader24 = new BerReader(Buffer.from([0x02, 0x03, 0xff, 0x7f, 0xff]))
    this.result += '--> read a 3 byte negative - highest: ' + (reader24.readInt() == -32769) + '\r\n'
    this.result += '--> read a 3 byte negative - highest: ' + (reader24.length == 3) + '\r\n'

    let reader25 = new BerReader(Buffer.from([0x02, 0x04, 0x80, 0x00, 0x00, 0x00]))
    this.result += '--> read a 4 byte negative - lowest: ' + (reader25.readInt() == -2147483648) + '\r\n'
    this.result += '--> read a 4 byte negative - lowest: ' + (reader25.length == 4) + '\r\n'

    let reader26 = new BerReader(Buffer.from([0x02, 0x04, 0x91, 0x7c, 0x22, 0x1f]))
    this.result += '--> read a 4 byte negative - middle: ' + (reader26.readInt() == -1854135777) + '\r\n'
    this.result += '--> read a 4 byte negative - middle: ' + (reader26.length == 4) + '\r\n'

    let reader27 = new BerReader(Buffer.from([0x02, 0x04, 0xff, 0x7f, 0xff, 0xff]))
    this.result += '--> read a 4 byte negative - highest: ' + (reader27.readInt() == -8388609) + '\r\n'
    this.result += '--> read a 4 byte negative - highest: ' + (reader27.length == 4) + '\r\n\r\n'
  }

  private readBoolean() {
    let reader = new BerReader(Buffer.from([0x01, 0x01, 0xff]))
    this.result += 'readBoolean\r\n'
    this.result += '--> read a true value: ' + (reader.readBoolean() == true) + '\r\n'
    this.result += '--> read a true value: ' + (reader.length == 0x01) + '\r\n'

    let reader1 = new BerReader(Buffer.from([0x01, 0x01, 0x00]))
    this.result += '--> read a false value: ' + (reader1.readBoolean() == false) + '\r\n'
    this.result += '--> read a false value: ' + (reader1.length == 0x01) + '\r\n\r\n'
  }

  private readEnumeration() {
    let reader = new BerReader(Buffer.from([0x0a, 0x01, 0x20]))
    this.result += 'readEnumeration\r\n'
    this.result += '--> read a value: ' + (reader.readEnumeration() == 0x20) + '\r\n'
    this.result += '--> read a value: ' + (reader.length == 0x01) + '\r\n\r\n'
  }

  private readOID() {
    let buffer = Buffer.from([6, 18, 43, 6, 1, 4, 1, 245, 12, 1, 1, 5, 1, 1, 19, 138, 224, 215, 210, 120])
    let reader = new BerReader(buffer)
    this.result += 'readOID\r\n'
    this.result += '--> does not convert to unsigned: ' +
      (reader.readOID() == "1.3.6.1.4.1.14988.1.1.5.1.1.19.2887117176") + '\r\n'
    this.result += '--> does not convert to unsigned: ' + (reader.length == 18) + '\r\n\r\n'
  }

  private readString() {
    try {
      let string = 'cn=foo,ou=unit,o=test'
      let buffer = Buffer.alloc(string.length + 2)
      buffer[0] = 0x04
      buffer[1] = Buffer.byteLength(string)
      buffer.write(string, 2)

      let reader = new BerReader(buffer)
      this.result += 'readString\r\n'
      this.result += '--> read a value: ' + (reader.readString() == string) + '\r\n'
      this.result += '--> read a value: ' + (reader.length == string.length) + '\r\n\r\n'
    }catch (e) {
      console.error(`${this.TAG}readString error, message:` + JSON.stringify(e))
    }
  }

  private readSequence() {
    let reader = new BerReader(Buffer.from([0x30, 0x03, 0x01, 0x01, 0xff]))
    this.result += 'readSequence\r\n'
    this.result += '--> read a sequence: ' + (reader.readSequence() == 0x30) + '\r\n'
    this.result += '--> read a sequence: ' + (reader.length == 0x03) + '\r\n'
    this.result += '--> read a sequence: ' + (reader.readBoolean() == true) + '\r\n'
    this.result += '--> read a sequence: ' + (reader.length == 0x01) + '\r\n\r\n'
  }

  private readBitString() {
    let reader = new BerReader(Buffer.from([0x03, 0x07, 0x04, 0x0a, 0x3b, 0x5f, 0x29, 0x1c, 0xd0]))
    this.result += 'readBitString\r\n'
    this.result += '--> read a value: ' +
      (reader.readBitString() == '00001010001110110101111100101001000111001101') + '\r\n'
    this.result += '--> read a value: ' + (reader.length == 7) + '\r\n\r\n'
  }

  private complex_sequences() {
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
    this.result += 'are processed correctly\r\n'
    this.result += '--> are processed correctly: ' + (reader.readSequence() == 48) + '\r\n'
    this.result += '--> are processed correctly: ' + (reader.length == 12) + '\r\n'
    this.result += '--> are processed correctly: ' + (reader.readInt() == 4) + '\r\n'
    this.result += '--> are processed correctly: ' + (reader.readSequence() == 96) + '\r\n'
    this.result += '--> are processed correctly: ' + (reader.length == 7) + '\r\n'
    this.result += '--> are processed correctly: ' + (reader.readInt() == 3) + '\r\n'
    this.result += '--> are processed correctly: ' + (reader.readString() == '') + '\r\n'
    this.result += '--> are processed correctly: ' + (reader.length == 0) + '\r\n'
    this.result += '--> are processed correctly: ' + (reader.readByte(false) == 0x80) + '\r\n'
    this.result += '--> are processed correctly: ' + (reader.readByte(false) == 0) + '\r\n\r\n'
  }

  private long_strings() {
    try{
      let buffer = Buffer.alloc(256)
      let string = "2;649;CN=Red Hat CS 71GA Demo,O=Red Hat CS 71GA Demo,C=US;"
        + "CN=RHCS Agent - admin01,UID=admin01,O=redhat,C=US [1] This is "
        + "Teena Vradmin's description."
      buffer[0] = 0x04
      buffer[1] = 0x81
      buffer[2] = 0x94
      buffer.write(string, 3)

      let reader = new BerReader(buffer.subarray(0, 3 + string.length));
      this.result += 'long_strings\r\n'

      console.info(this.TAG + string)
      this.result += '--> be parsed: ' + (reader.readString() == string) + '\r\n\r\n'
    }catch (e) {
      console.error(`${this.TAG}long_strings error, message:` + JSON.stringify(e))
    }
  }

  private writeByte() {
    let writer = new BerWriter()
    writer.writeByte(0xC2)
    let buffer: buffer.Buffer = writer.buffer
    this.result += 'writeByte\r\n'
    this.result += '-->  write a value: ' + (buffer.length == 1) + '\r\n'
    this.result += '-->  write a value: ' + (buffer[0] == 0xc2) + '\r\n'
  }

  private writeInt() {
    let writer = new BerWriter()
    writer.writeInt(0)
    let buffer: buffer.Buffer = writer.buffer
    this.result += 'writeInt\r\n'
    this.result += '--> write zero: ' + (buffer.length == 3) + '\r\n'
    this.result += '--> write zero: ' + (buffer[0] == 0x02) + '\r\n'
    this.result += '--> write zero: ' + (buffer[1] == 0x01) + '\r\n'
    this.result += '--> write zero: ' + (buffer[2] == 0x00) + '\r\n'

    let writer1 = new BerWriter()
    writer1.writeInt(1)
    let buffer1: buffer.Buffer = writer1.buffer

    this.result += '-->  write 1 byte positive - lowest: ' + (buffer1.length == 3) + '\r\n'
    this.result += '-->  write 1 byte positive - lowest: ' + (buffer1[0] == 0x02) + '\r\n'
    this.result += '-->  write 1 byte positive - lowest: ' + (buffer1[1] == 0x01) + '\r\n'
    this.result += '-->  write 1 byte positive - lowest: ' + (buffer1[2] == 0x01) + '\r\n'

    let writer2 = new BerWriter()
    writer2.writeInt(101)
    let buffer2: buffer.Buffer = writer2.buffer
    this.result += '-->  write 1 byte positive - middle: ' + (buffer2.length == 3) + '\r\n'
    this.result += '-->  write 1 byte positive - middle: ' + (buffer2[0] == 0x02) + '\r\n'
    this.result += '-->  write 1 byte positive - middle: ' + (buffer2[1] == 0x01) + '\r\n'
    this.result += '-->  write 1 byte positive - middle: ' + (buffer2[2] == 0x65) + '\r\n'

    let writer3 = new BerWriter()
    writer3.writeInt(127)
    let buffer3: buffer.Buffer = writer3.buffer
    this.result += '-->  write 1 byte positive - highest: ' + (buffer3.length == 3) + '\r\n'
    this.result += '-->  write 1 byte positive - highest: ' + (buffer3[0] == 0x02) + '\r\n'
    this.result += '-->  write 1 byte positive - highest: ' + (buffer3[1] == 0x01) + '\r\n'
    this.result += '-->  write 1 byte positive - highest: ' + (buffer3[2] == 0x7f) + '\r\n'

    let writer4 = new BerWriter()
    writer4.writeInt(128)
    let buffer4: buffer.Buffer = writer4.buffer
    this.result += '-->  write 2 byte positive - lowest: ' + (buffer4.length == 4) + '\r\n'
    this.result += '-->  write 2 byte positive - lowest: ' + (buffer4[0] == 0x02) + '\r\n'
    this.result += '-->  write 2 byte positive - lowest: ' + (buffer4[1] == 0x02) + '\r\n'
    this.result += '-->  write 2 byte positive - lowest: ' + (buffer4[2] == 0x00) + '\r\n'
    this.result += '-->  write 2 byte positive - lowest: ' + (buffer4[3] == 0x80) + '\r\n'

    let writer5 = new BerWriter()
    writer5.writeInt(9374)
    let buffer5: buffer.Buffer = writer5.buffer
    this.result += '-->  write 2 byte positive - middle: ' + (buffer5.length == 4) + '\r\n'
    this.result += '-->  write 2 byte positive - middle: ' + (buffer5[0] == 0x02) + '\r\n'
    this.result += '-->  write 2 byte positive - middle: ' + (buffer5[1] == 0x02) + '\r\n'
    this.result += '-->  write 2 byte positive - middle: ' + (buffer5[2] == 0x24) + '\r\n'
    this.result += '-->  write 2 byte positive - middle: ' + (buffer5[3] == 0x9e) + '\r\n'

    let writer6 = new BerWriter()
    writer6.writeInt(32767)
    let buffer6: buffer.Buffer = writer6.buffer
    this.result += '-->  write 2 byte positive - highest: ' + (buffer6.length == 4) + '\r\n'
    this.result += '-->  write 2 byte positive - highest: ' + (buffer6[0] == 0x02) + '\r\n'
    this.result += '-->  write 2 byte positive - highest: ' + (buffer6[1] == 0x02) + '\r\n'
    this.result += '-->  write 2 byte positive - highest: ' + (buffer6[2] == 0x7f) + '\r\n'
    this.result += '-->  write 2 byte positive - highest: ' + (buffer6[3] == 0xff) + '\r\n'


    let writer7 = new BerWriter()
    writer7.writeInt(32768)
    let buffer7: buffer.Buffer = writer7.buffer
    this.result += '-->  write 3 byte positive - lowest: ' + (buffer7.length == 5) + '\r\n'
    this.result += '-->  write 3 byte positive - lowest: ' + (buffer7[0] == 0x02) + '\r\n'
    this.result += '-->  write 3 byte positive - lowest: ' + (buffer7[1] == 0x03) + '\r\n'
    this.result += '-->  write 3 byte positive - lowest: ' + (buffer7[2] == 0x00) + '\r\n'
    this.result += '-->  write 3 byte positive - lowest: ' + (buffer7[3] == 0x80) + '\r\n'
    this.result += '-->  write 3 byte positive - lowest: ' + (buffer7[4] == 0x00) + '\r\n'

    let writer8 = new BerWriter()
    writer8.writeInt(5938243)
    let buffer8: buffer.Buffer = writer8.buffer
    this.result += '-->  write 3 byte positive - middle: ' + (buffer8.length == 5) + '\r\n'
    this.result += '-->  write 3 byte positive - middle: ' + (buffer8[0] == 0x02) + '\r\n'
    this.result += '-->  write 3 byte positive - middle: ' + (buffer8[1] == 0x03) + '\r\n'
    this.result += '-->  write 3 byte positive - middle: ' + (buffer8[2] == 0x5a) + '\r\n'
    this.result += '-->  write 3 byte positive - middle: ' + (buffer8[3] == 0x9c) + '\r\n'
    this.result += '-->  write 3 byte positive - middle: ' + (buffer8[4] == 0x43) + '\r\n'


    let writer9 = new BerWriter()
    writer9.writeInt(8388607)
    let buffer9: buffer.Buffer = writer9.buffer
    this.result += '-->  write 3 byte positive -highest: ' + (buffer9.length == 5) + '\r\n'
    this.result += '-->  write 3 byte positive -highest: ' + (buffer9[0] == 0x02) + '\r\n'
    this.result += '-->  write 3 byte positive -highest: ' + (buffer9[1] == 0x03) + '\r\n'
    this.result += '-->  write 3 byte positive -highest: ' + (buffer9[2] == 0x7f) + '\r\n'
    this.result += '-->  write 3 byte positive -highest: ' + (buffer9[3] == 0xff) + '\r\n'
    this.result += '-->  write 3 byte positive -highest: ' + (buffer9[4] == 0xff) + '\r\n'

    let writer10 = new BerWriter()
    writer10.writeInt(8388608)
    let buffer10: buffer.Buffer = writer10.buffer
    this.result += '-->  write 4 byte positive -lowest: ' + (buffer10.length == 6) + '\r\n'
    this.result += '-->  write 4 byte positive -lowest: ' + (buffer10[0] == 0x02) + '\r\n'
    this.result += '-->  write 4 byte positive -lowest: ' + (buffer10[1] == 0x04) + '\r\n'
    this.result += '-->  write 4 byte positive -lowest: ' + (buffer10[2] == 0x00) + '\r\n'
    this.result += '-->  write 4 byte positive -lowest: ' + (buffer10[3] == 0x80) + '\r\n'
    this.result += '-->  write 4 byte positive -lowest: ' + (buffer10[4] == 0x00) + '\r\n'
    this.result += '-->  write 4 byte positive -lowest: ' + (buffer10[5] == 0x00) + '\r\n'

    let writer11 = new BerWriter()
    writer11.writeInt(1483722690)
    let buffer11: buffer.Buffer = writer11.buffer
    this.result += '-->  write 4 byte positive -middle: ' + (buffer11.length == 6) + '\r\n'
    this.result += '-->  write 4 byte positive -middle: ' + (buffer11[0] == 0x02) + '\r\n'
    this.result += '-->  write 4 byte positive -middle: ' + (buffer11[1] == 0x04) + '\r\n'
    this.result += '-->  write 4 byte positive -middle: ' + (buffer11[2] == 0x58) + '\r\n'
    this.result += '-->  write 4 byte positive -middle: ' + (buffer11[3] == 0x6f) + '\r\n'
    this.result += '-->  write 4 byte positive -middle: ' + (buffer11[4] == 0xcf) + '\r\n'
    this.result += '-->  write 4 byte positive -middle: ' + (buffer11[5] == 0xc2) + '\r\n'

    let writer12 = new BerWriter()
    writer12.writeInt(2147483647)
    let buffer12: buffer.Buffer = writer12.buffer
    this.result += '-->  write 4 byte positive -highest: ' + (buffer12.length == 6) + '\r\n'
    this.result += '-->  write 4 byte positive -highest: ' + (buffer12[0] == 0x02) + '\r\n'
    this.result += '-->  write 4 byte positive -highest: ' + (buffer12[1] == 0x04) + '\r\n'
    this.result += '-->  write 4 byte positive -highest: ' + (buffer12[2] == 0x7f) + '\r\n'
    this.result += '-->  write 4 byte positive -highest: ' + (buffer12[3] == 0xff) + '\r\n'
    this.result += '-->  write 4 byte positive -highest: ' + (buffer12[4] == 0xff) + '\r\n'
    this.result += '-->  write 4 byte positive -highest: ' + (buffer12[5] == 0xff) + '\r\n'

    let writer13 = new BerWriter()
    writer13.writeInt(2147483648)
    let buffer13: buffer.Buffer = writer13.buffer
    this.result += '-->  write 5 byte positive -lowest: ' + (buffer13.length == 7) + '\r\n'
    this.result += '-->  write 5 byte positive -lowest: ' + (buffer13[0] == 0x02) + '\r\n'
    this.result += '-->  write 5 byte positive -lowest: ' + (buffer13[1] == 0x05) + '\r\n'
    this.result += '-->  write 5 byte positive -lowest: ' + (buffer13[2] == 0x00) + '\r\n'
    this.result += '-->  write 5 byte positive -lowest: ' + (buffer13[3] == 0x80) + '\r\n'
    this.result += '-->  write 5 byte positive -lowest: ' + (buffer13[4] == 0x00) + '\r\n'
    this.result += '-->  write 5 byte positive -lowest: ' + (buffer13[5] == 0x00) + '\r\n'
    this.result += '-->  write 5 byte positive -lowest: ' + (buffer13[6] == 0x00) + '\r\n'

    let writer14 = new BerWriter()
    writer14.writeInt(3843548325)
    let buffer14: buffer.Buffer = writer14.buffer
    this.result += '-->  write 5 byte positive -middle: ' + (buffer14.length == 7) + '\r\n'
    this.result += '-->  write 5 byte positive -middle: ' + (buffer14[0] == 0x02) + '\r\n'
    this.result += '-->  write 5 byte positive -middle: ' + (buffer14[1] == 0x05) + '\r\n'
    this.result += '-->  write 5 byte positive -middle: ' + (buffer14[2] == 0x00) + '\r\n'
    this.result += '-->  write 5 byte positive -middle: ' + (buffer14[3] == 0xe5) + '\r\n'
    this.result += '-->  write 5 byte positive -middle: ' + (buffer14[4] == 0x17) + '\r\n'
    this.result += '-->  write 5 byte positive -middle: ' + (buffer14[5] == 0xe4) + '\r\n'
    this.result += '-->  write 5 byte positive -middle: ' + (buffer14[6] == 0xa5) + '\r\n'

    let writer15 = new BerWriter()
    writer15.writeInt(4294967295)
    let buffer15: buffer.Buffer = writer15.buffer
    this.result += '-->  write 5 byte positive -highest: ' + (buffer15.length == 7) + '\r\n'
    this.result += '-->  write 5 byte positive -highest: ' + (buffer15[0] == 0x02) + '\r\n'
    this.result += '-->  write 5 byte positive -highest: ' + (buffer15[1] == 0x05) + '\r\n'
    this.result += '-->  write 5 byte positive -highest: ' + (buffer15[2] == 0x00) + '\r\n'
    this.result += '-->  write 5 byte positive -highest: ' + (buffer15[3] == 0xff) + '\r\n'
    this.result += '-->  write 5 byte positive -highest: ' + (buffer15[4] == 0xff) + '\r\n'
    this.result += '-->  write 5 byte positive -highest: ' + (buffer15[5] == 0xff) + '\r\n'
    this.result += '-->  write 5 byte positive -highest: ' + (buffer15[6] == 0xff) + '\r\n'

    let writer16 = new BerWriter()
    writer16.writeInt(-128)
    let buffer16: buffer.Buffer = writer16.buffer
    this.result += '-->  write 1 byte negative - lowest: ' + (buffer16.length == 3) + '\r\n'
    this.result += '-->  write 1 byte negative - lowest: ' + (buffer16[0] == 0x02) + '\r\n'
    this.result += '-->  write 1 byte negative - lowest: ' + (buffer16[1] == 0x01) + '\r\n'
    this.result += '-->  write 1 byte negative - lowest: ' + (buffer16[2] == 0x80) + '\r\n'

    let writer17 = new BerWriter()
    writer17.writeInt(-73)
    let buffer17: buffer.Buffer = writer17.buffer
    this.result += '-->  write 1 byte negative - middle: ' + (buffer17.length == 3) + '\r\n'
    this.result += '-->  write 1 byte negative - middle: ' + (buffer17[0] == 0x02) + '\r\n'
    this.result += '-->  write 1 byte negative - middle: ' + (buffer17[1] == 0x01) + '\r\n'
    this.result += '-->  write 1 byte negative - middle: ' + (buffer17[2] == 0xb7) + '\r\n'

    let writer18 = new BerWriter()
    writer18.writeInt(-1)
    let buffer18: buffer.Buffer = writer18.buffer
    this.result += '-->  write 1 byte negative - highest: ' + (buffer18.length == 3) + '\r\n'
    this.result += '-->  write 1 byte negative - highest: ' + (buffer18[0] == 0x02) + '\r\n'
    this.result += '-->  write 1 byte negative - highest: ' + (buffer18[1] == 0x01) + '\r\n'
    this.result += '-->  write 1 byte negative - highest: ' + (buffer18[2] == 0xff) + '\r\n'


    let writer19 = new BerWriter()
    writer19.writeInt(-32768)
    let buffer19: buffer.Buffer = writer19.buffer
    this.result += '-->  write 2 byte negative - lowest: ' + (buffer19.length == 4) + '\r\n'
    this.result += '-->  write 2 byte negative - lowest: ' + (buffer19[0] == 0x02) + '\r\n'
    this.result += '-->  write 2 byte negative - lowest: ' + (buffer19[1] == 0x02) + '\r\n'
    this.result += '-->  write 2 byte negative - lowest: ' + (buffer19[2] == 0x80) + '\r\n'
    this.result += '-->  write 2 byte negative - lowest: ' + (buffer19[3] == 0x00) + '\r\n'

    let writer20 = new BerWriter()
    writer20.writeInt(-22400)
    let buffer20: buffer.Buffer = writer20.buffer
    this.result += '-->  write 2 byte negative - middle: ' + (buffer20.length == 4) + '\r\n'
    this.result += '-->  write 2 byte negative - middle: ' + (buffer20[0] == 0x02) + '\r\n'
    this.result += '-->  write 2 byte negative - middle: ' + (buffer20[1] == 0x02) + '\r\n'
    this.result += '-->  write 2 byte negative - middle: ' + (buffer20[2] == 0xa8) + '\r\n'
    this.result += '-->  write 2 byte negative - middle: ' + (buffer20[3] == 0x80) + '\r\n'

    let writer21 = new BerWriter()
    writer21.writeInt(-129)
    let buffer21: buffer.Buffer = writer21.buffer
    this.result += '-->  write 2 byte negative - highest: ' + (buffer21.length == 4) + '\r\n'
    this.result += '-->  write 2 byte negative - highest: ' + (buffer21[0] == 0x02) + '\r\n'
    this.result += '-->  write 2 byte negative - highest: ' + (buffer21[1] == 0x02) + '\r\n'
    this.result += '-->  write 2 byte negative - highest: ' + (buffer21[2] == 0xff) + '\r\n'
    this.result += '-->  write 2 byte negative - highest: ' + (buffer21[3] == 0x7f) + '\r\n'

    let writer22 = new BerWriter()
    writer22.writeInt(-8388608)
    let buffer22: buffer.Buffer = writer22.buffer
    this.result += '-->  write 3 byte negative - lowest: ' + (buffer22.length == 5) + '\r\n'
    this.result += '-->  write 3 byte negative - lowest: ' + (buffer22[0] == 0x02) + '\r\n'
    this.result += '-->  write 3 byte negative - lowest: ' + (buffer22[1] == 0x03) + '\r\n'
    this.result += '-->  write 3 byte negative - lowest: ' + (buffer22[2] == 0x80) + '\r\n'
    this.result += '-->  write 3 byte negative - lowest: ' + (buffer22[3] == 0x00) + '\r\n'
    this.result += '-->  write 3 byte negative - lowest: ' + (buffer22[4] == 0x00) + '\r\n'

    let writer23 = new BerWriter()
    writer23.writeInt(-481653)
    let buffer23: buffer.Buffer = writer23.buffer
    this.result += '-->  write 3 byte negative - middle: ' + (buffer23.length == 5) + '\r\n'
    this.result += '-->  write 3 byte negative - middle: ' + (buffer23[0] == 0x02) + '\r\n'
    this.result += '-->  write 3 byte negative - middle: ' + (buffer23[1] == 0x03) + '\r\n'
    this.result += '-->  write 3 byte negative - middle: ' + (buffer23[2] == 0xf8) + '\r\n'
    this.result += '-->  write 3 byte negative - middle: ' + (buffer23[3] == 0xa6) + '\r\n'
    this.result += '-->  write 3 byte negative - middle: ' + (buffer23[4] == 0x8b) + '\r\n'

    let writer24 = new BerWriter()
    writer24.writeInt(-32769)
    let buffer24: buffer.Buffer = writer24.buffer
    this.result += '-->  write 3 byte negative - highest: ' + (buffer24.length == 5) + '\r\n'
    this.result += '-->  write 3 byte negative - highest: ' + (buffer24[0] == 0x02) + '\r\n'
    this.result += '-->  write 3 byte negative - highest: ' + (buffer24[1] == 0x03) + '\r\n'
    this.result += '-->  write 3 byte negative - highest: ' + (buffer24[2] == 0xff) + '\r\n'
    this.result += '-->  write 3 byte negative - highest: ' + (buffer24[3] == 0x7f) + '\r\n'
    this.result += '-->  write 3 byte negative - highest: ' + (buffer24[4] == 0xff) + '\r\n'

    let writer25 = new BerWriter()
    writer25.writeInt(-2147483648)
    let buffer25: buffer.Buffer = writer25.buffer
    this.result += '-->  write 4 byte negative - lowest: ' + (buffer25.length == 6) + '\r\n'
    this.result += '-->  write 4 byte negative - lowest: ' + (buffer25[0] == 0x02) + '\r\n'
    this.result += '-->  write 4 byte negative - lowest: ' + (buffer25[1] == 0x04) + '\r\n'
    this.result += '-->  write 4 byte negative - lowest: ' + (buffer25[2] == 0x80) + '\r\n'
    this.result += '-->  write 4 byte negative - lowest: ' + (buffer25[3] == 0x00) + '\r\n'
    this.result += '-->  write 4 byte negative - lowest: ' + (buffer25[4] == 0x00) + '\r\n'
    this.result += '-->  write 4 byte negative - lowest: ' + (buffer25[5] == 0x00) + '\r\n'

    let writer26 = new BerWriter()
    writer26.writeInt(-1522904131)
    let buffer26: buffer.Buffer = writer26.buffer
    this.result += '-->  write 4 byte negative - middle: ' + (buffer26.length == 6) + '\r\n'
    this.result += '-->  write 4 byte negative - middle: ' + (buffer26[0] == 0x02) + '\r\n'
    this.result += '-->  write 4 byte negative - middle: ' + (buffer26[1] == 0x04) + '\r\n'
    this.result += '-->  write 4 byte negative - middle: ' + (buffer26[2] == 0xa5) + '\r\n'
    this.result += '-->  write 4 byte negative - middle: ' + (buffer26[3] == 0x3a) + '\r\n'
    this.result += '-->  write 4 byte negative - middle: ' + (buffer26[4] == 0x53) + '\r\n'
    this.result += '-->  write 4 byte negative - middle: ' + (buffer26[5] == 0xbd) + '\r\n'

    let writer27 = new BerWriter()
    writer27.writeInt(-8388609)
    let buffer27: buffer.Buffer = writer27.buffer
    this.result += '-->  write 4 byte negative - highest: ' + (buffer27.length == 6) + '\r\n'
    this.result += '-->  write 4 byte negative - highest: ' + (buffer27[0] == 0x02) + '\r\n'
    this.result += '-->  write 4 byte negative - highest: ' + (buffer27[1] == 0x04) + '\r\n'
    this.result += '-->  write 4 byte negative - highest: ' + (buffer27[2] == 0xff) + '\r\n'
    this.result += '-->  write 4 byte negative - highest: ' + (buffer27[3] == 0x7f) + '\r\n'
    this.result += '-->  write 4 byte negative - highest: ' + (buffer27[4] == 0xff) + '\r\n'
    this.result += '-->  write 4 byte negative - highest: ' + (buffer27[5] == 0xff) + '\r\n\r\n'
  }

  private writeBoolean() {
    let writer = new BerWriter()
    writer.writeBoolean(true)
    writer.writeBoolean(false)
    let buffer: buffer.Buffer = writer.buffer
    this.result += 'writeBoolean\r\n'
    this.result += '-->  write a true and false value: ' + (buffer.length == 6) + '\r\n'
    this.result += '-->  write a true and false value: ' + (buffer[0] == 0x01) + '\r\n'
    this.result += '-->  write a true and false value: ' + (buffer[1] == 0x01) + '\r\n'
    this.result += '-->  write a true and false value: ' + (buffer[2] == 0xff) + '\r\n'
    this.result += '-->  write a true and false value: ' + (buffer[3] == 0x01) + '\r\n'
    this.result += '-->  write a true and false value: ' + (buffer[4] == 0x01) + '\r\n'
    this.result += '-->  write a true and false value: ' + (buffer[5] == 0x00) + '\r\n\r\n'
  }

  private writeString() {
    let writer = new BerWriter()
    writer.writeString("hello world")
    let buffer: buffer.Buffer = writer.buffer
    this.result += 'writeString\r\n'
    this.result += '-->  write a value: ' + (buffer.length == 13) + '\r\n'
    this.result += '-->  write a value: ' + (buffer[0] == 0x04) + '\r\n'
    this.result += '-->  write a value: ' + (buffer[1] == 11) + '\r\n'
    this.result += '-->  write a value: ' + (buffer.subarray(2).toString("utf8") == "hello world") + '\r\n\r\n'
  }

  private writeBuffer() {
    let writer = new BerWriter()
    writer.writeString("hello world")
    let expected: buffer.Buffer = buffer.from([
      0x04, 0x0b, 0x30, 0x09, 0x02, 0x01, 0x0f, 0x01,
      0x01, 0xff, 0x01, 0x01, 0xff
    ])
    writer.writeBuffer(expected.subarray(2, expected.length), 0x04)
    let buffer1: buffer.Buffer = writer.buffer;

    this.result += 'writeBuffer\r\n'
    this.result += '-->  write a value: ' + (buffer1.length == 26) + '\r\n'
    this.result += '-->  write a value: ' + (buffer1[0] == 0x04) + '\r\n'
    this.result += '-->  write a value: ' + (buffer1[1] == 11) + '\r\n'
    this.result += '-->  write a value: ' + (buffer1.subarray(2, 13).toString("utf8") == "hello world") + '\r\n'
    this.result += '-->  write a value: ' + (buffer1[13] == 0) + '\r\n'
    this.result += '-->  write a value: ' + (buffer1[14] == 1) + '\r\n'
    for (let i = 13, j = 0; i < buffer1.length && j < expected.length; i++, j++) {
      this.result += '-->  write a value: ' + (buffer1[i] == expected[j]) + '\r\n'
    }
  }

  private writeStringArray() {
    let writer = new BerWriter()
    writer.writeStringArray(["hello world", "fubar!"])
    let buffer: buffer.Buffer = writer.buffer

    this.result += '\r\nwriteStringArray\r\n'
    this.result += '-->  write an array of string: ' + (buffer.length == 21) + '\r\n'
    this.result += '-->  write an array of string: ' + (buffer[0] == 0x04) + '\r\n'
    this.result += '-->  write an array of string: ' + (buffer[1] == 11) + '\r\n'
    this.result += '-->  write an array of string: ' + (buffer.subarray(2, 13).toString("utf8") == "hello world") +
      '\r\n'
    this.result += '-->  write an array of string: ' + (buffer[13] == 0x04) + '\r\n'
    this.result += '-->  write an array of string: ' + (buffer[14] == 6) + '\r\n'
  }

  private oversized_data() {
    let writer = new BerWriter({
      size: 2
    })
    writer.writeString("hello world")
    let buffer: buffer.Buffer = writer.buffer

    this.result += 'oversized_data\r\n'
    this.result += '--> results in a buffer resize: ' + (buffer.length == 13) + '\r\n'
    this.result += '--> results in a buffer resize: ' + (buffer[0] == 0x04) + '\r\n'
    this.result += '--> results in a buffer resize: ' + (buffer[1] == 11) + '\r\n'
    this.result += '-->  write an array of string: ' + (buffer.subarray(2).toString("utf8") == "hello world") +
      '\r\n\r\n'
  }

  private complexsequences() {
    let writer = new BerWriter({
      size: 25
    })
    writer.startSequence()
    writer.writeString("hello world")
    writer.endSequence()

    let buffer: buffer.Buffer = writer.buffer
    this.result += 'complexsequences\r\n'
    this.result += '--> are processed correctly: ' + (buffer.length == 15) + '\r\n'
    this.result += '--> are processed correctly: ' + (buffer[0] == 0x30) + '\r\n'
    this.result += '--> are processed correctly: ' + (buffer[1] == 13) + '\r\n'
    this.result += '--> are processed correctly: ' + (buffer[2] == 0x04) + '\r\n'
    this.result += '--> are processed correctly: ' + (buffer[3] == 11) + '\r\n'
    this.result += '--> are processed correctly: ' + (buffer.subarray(4).toString("utf8") == "hello world") + '\r\n\r\n'
  }

  private nested_sequences_write() {
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

    this.result += 'nested_sequences\r\n'
    this.result += '--> are processed correctly: ' + (buffer.length == 30) + '\r\n'
    this.result += '--> are processed correctly: ' + (buffer[0] == 0x30) + '\r\n'
    this.result += '--> are processed correctly: ' + (buffer[1] == 28) + '\r\n'
    this.result += '--> are processed correctly: ' + (buffer[2] == 0x04) + '\r\n'
    this.result += '--> are processed correctly: ' + (buffer[3] == 11) + '\r\n'
    this.result += '--> are processed correctly: ' + (buffer.subarray(4, 15).toString("utf8") == "hello world") +
      '\r\n'
    this.result += '--> are processed correctly: ' + (buffer[15] == 0x30) + '\r\n'
    this.result += '--> are processed correctly: ' + (buffer[16] == 13) + '\r\n'
    this.result += '--> are processed correctly: ' + (buffer[17] == 0x40) + '\r\n'
    this.result += '--> are processed correctly: ' + (buffer[18] == 11) + '\r\n'
    this.result += '--> are processed correctly: ' + (buffer.subarray(19, 30).toString("utf8") == "hello world") +
      '\r\n\r\n'
  }

  private multiple_sequences_write() {
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

    this.result += 'nested_sequences\r\n'
    this.result += '--> are processed correctly: ' + (buffer.length == 35) + '\r\n'
    this.result += '--> are processed correctly: ' + (buffer[0] == 0x30) + '\r\n'
    this.result += '--> are processed correctly: ' + (buffer[1] == 33) + '\r\n'
    this.result += '--> are processed correctly: ' + (buffer[2] == 0x02) + '\r\n'
    this.result += '--> are processed correctly: ' + (buffer[3] == 1) + '\r\n'
    this.result += '--> are processed correctly: ' + (buffer[4] == 0x03) + '\r\n'
    this.result += '--> are processed correctly: ' + (buffer[5] == 0x60) + '\r\n'
    this.result += '--> are processed correctly: ' + (buffer[6] == 28) + '\r\n'
    this.result += '--> are processed correctly: ' + (buffer[7] == 0x02) + '\r\n'
    this.result += '--> are processed correctly: ' + (buffer[8] == 1) + '\r\n'
    this.result += '--> are processed correctly: ' + (buffer[9] == 0x03) + '\r\n'
    this.result += '--> are processed correctly: ' + (buffer[10] == 0x04) + '\r\n'
    this.result += '--> are processed correctly: ' + (buffer[11] == dn.length) + '\r\n'
    this.result += '--> are processed correctly: ' + (buffer.subarray(12, 33).toString("utf8") == dn) + '\r\n'
    this.result += '--> are processed correctly: ' + (buffer[33] == 0x80) + '\r\n'
    this.result += '--> are processed correctly: ' + (buffer[34] == 0x00) + '\r\n\r\n'
  }

  private writeOID() {
    let writer = new BerWriter()
    writer.writeOID("1.2.840.113549.1.1.1")
    let buffer: buffer.Buffer = writer.buffer

    this.result += 'writeOID\r\n'
    this.result += '-->  write a value: ' + (buffer.toString("hex") == "06092a864886f70d010101") + '\r\n'
  }
}