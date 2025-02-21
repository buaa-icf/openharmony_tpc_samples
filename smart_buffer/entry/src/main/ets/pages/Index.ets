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

import { SmartBuffer, SmartBufferOptions } from '@ohos/smart_buffer';
import Buffer from '@ohos.buffer';
import { checkEncoding, isFiniteInteger } from '@ohos/smart_buffer/src/main/ets/utils';

@Entry
@Component
struct Index {
  @State result: string = 'RESULT:\r\n';
  @State message: string = getContext().resourceManager.getStringSync($r('app.string.run'));
  private scrollerForList: Scroller = new Scroller()

  build() {
    Column() {
      Button(this.message)
        .fontSize(18)
        .width(120)
        .fontWeight(FontWeight.Bold)
        .align(Alignment.Center)
        .margin({ top: 20 })
        .onClick(() => {
          this.constructing_with_an_existing_Buffer()
          this.constructing_with_an_existing_Buffer_and_setting_the_encoding()
          this.constructing_with_a_specified_size()
          this.constructing_with_SmartBufferOptions()
          this.constructing_with_factory_methods()
          this.constructing_with_a_specified_encoding()
          this.reading_or_Writing_To_From_SmartBuffer()
          this.When_BigInt_is_available_and_so_are_Buffer_methods()
          this.basic_String_Values()
          this.mixed_Encoding_Strings()
          this.null_or_non_null_terminating_strings()
          this.reading_string_without_specifying_length()
          this.write_string_as_specific_position()
          this.Null_Terminated_Buffer_Writing()
          this.writing_buffer_to_position_0()
          this.Adding_more_data_to_the_buffer_than_the_internal_buffer_currently_allows()
          this.Inserting_values_into_specific_positions()
          this.skipping_around_data()
          this.setting_write_and_read_offsets()
          this.describeSetting_encoding()
          this.automatic_internal_buffer_resizing()
          this.clearing_the_buffer()
          this.displaying_the_buffer_as_a_string()
          this.ensureWritable()
          this.destroy()
          this.isSmartBufferOptions()
          this.utils()
        })
      Scroll(this.scrollerForList) {
        Text(this.result)
          .fontSize(16)
          .align(Alignment.TopStart)
      }
      .height('90%')
      .width('100%')
    }
    .height('100%')
    .width('100%')
  }

  private constructing_with_an_existing_Buffer() {
    let buff =
      Buffer.from([0xaa, 0xbb, 0xcc, 0xdd, 0xff, 0x00, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88, 0x99]);
    let reader = SmartBuffer.fromBuffer(buff);
    this.result += 'constructing_with_an_existing_Buffer\r\n'
    this.result += '--> reader.internalBuffer: ' + JSON.stringify(reader.internalBuffer) + '\r\n'
    this.result += '--> reader.toBuffer(): ' + JSON.stringify(reader.toBuffer()) + '\r\n\r\n'
  }

  private constructing_with_an_existing_Buffer_and_setting_the_encoding() {
    const buff =
      Buffer.from([0xaa, 0xbb, 0xcc, 0xdd, 0xff, 0x00, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88, 0x99]);
    const reader = SmartBuffer.fromBuffer(buff, 'ascii');
    this.result += 'constructing_with_an_existing_Buffer_and_setting_the_encoding\r\n'
    this.result += '--> reader.internalBuffer: ' + JSON.stringify(reader.internalBuffer) + '\r\n'
    this.result += '--> reader.encoding: ' + JSON.stringify(reader.encoding) + '\r\n\r\n'
  }

  private constructing_with_a_specified_size() {
    const size = 128;
    const reader = SmartBuffer.fromSize(size);
    this.result += 'constructing_with_a_specified_size\r\n'
    this.result += '--> reader.internalBuffer.length: ' + JSON.stringify(reader.internalBuffer.length) + '\r\n\r\n'
  }

  private constructing_with_a_specified_encoding() {
    const encoding: Buffer.BufferEncoding = 'utf8';
    const reader = SmartBuffer.fromOptions({
      encoding
    });

    this.result += 'constructing_with_a_specified_encoding\r\n'
    this.result += '-->fromOptions encoding: ' + JSON.stringify(reader.encoding) + '\r\n'

    const reader1 = SmartBuffer.fromSize(1024, encoding);
    this.result += '-->fromSize encoding: ' + JSON.stringify(reader1.encoding) + '\r\n\r\n'
  }

  private constructing_with_SmartBufferOptions() {
    const validOptions1: SmartBufferOptions = {
      size: 1024,
      encoding: 'ascii'
    };
    const sbuff = SmartBuffer.fromOptions(validOptions1);
    this.result += 'constructing_with_SmartBufferOptions\r\n'
    this.result += '-->encoding: ' + JSON.stringify(sbuff.encoding) + '\r\n'
    this.result += '-->internalBuffer.length: ' + JSON.stringify(sbuff.internalBuffer.length) + '\r\n\r\n'
  }

  private constructing_with_factory_methods() {
    const originalBuffer = Buffer.alloc(10);
    const sbuff1 = SmartBuffer.fromBuffer(originalBuffer);
    this.result += 'constructing_with_factory_methods\r\n'
    this.result += '-->sbuff1.internalBuffer: ' + JSON.stringify(sbuff1.internalBuffer) + '\r\n'
    const sbuff2 = SmartBuffer.fromSize(1024);
    this.result += '-->sbuff2.internalBuffer.length: ' + JSON.stringify(sbuff2.internalBuffer.length) + '\r\n'
    const options: SmartBufferOptions = {
      size: 1024,
      encoding: 'ascii'
    };
    const sbuff3 = SmartBuffer.fromOptions(options);
    this.result += '-->sbuff3.encoding: ' + JSON.stringify(sbuff3.encoding) + '\r\n'
    this.result += '-->sbuff3.internalBuffer.length: ' + JSON.stringify(sbuff3.internalBuffer.length) + '\r\n\r\n'
  }

  private reading_or_Writing_To_From_SmartBuffer() {
    let reader = new SmartBuffer();
    reader.writeInt8(0x44);
    reader.writeUInt8(0xff);
    reader.writeInt16BE(0x6699);
    reader.writeInt16LE(0x6699);
    reader.writeUInt16BE(0xffdd);
    reader.writeUInt16LE(0xffdd);
    reader.writeInt32BE(0x77889900);
    reader.writeInt32LE(0x77889900);
    reader.writeUInt32BE(0xffddccbb);
    reader.writeUInt32LE(0xffddccbb);
    reader.writeFloatBE(1.234);
    reader.writeFloatLE(1.234);
    reader.writeDoubleBE(1.23456789);
    reader.writeDoubleLE(1.23456789);
    reader.writeUInt8(0xc8, 0);
    reader.writeUInt16LE(0xc8, 4);
    reader.insertUInt16LE(0x6699, 6);
    reader.writeUInt16BE(0x6699);
    reader.insertUInt16BE(0x6699, reader.length - 1);

    let iReader = new SmartBuffer();
    iReader.insertInt8(0x44, 0);
    iReader.insertUInt8(0x44, 0);
    iReader.insertInt16BE(0x6699, 0);
    iReader.insertInt16LE(0x6699, 0);
    iReader.insertUInt16BE(0x6699, 0);
    iReader.insertUInt16LE(0x6699, 0);
    iReader.insertInt32BE(0x6699, 0);
    iReader.insertInt32LE(0x6699, 0);
    iReader.insertUInt32BE(0x6699, 0);
    iReader.insertUInt32LE(0x6699, 0);
    iReader.insertFloatBE(0x6699, 0);
    iReader.insertFloatLE(0x6699, 0);
    iReader.insertDoubleBE(0x6699, 0);
    iReader.insertDoubleLE(0x6699, 0);
    iReader.writeStringNT('h', 2);
    let buf=Buffer.from('he')
    iReader.insertBuffer(buf, 2);
    iReader.insertBufferNT(buf, 2);
    this.result += 'insert_To_From_SmartBuffer\r\n'
    this.result += '-->insert readInt8: ' + JSON.stringify(iReader.readInt8(0)) + '\r\n'
    this.result += '-->insert readUInt8: ' + JSON.stringify(iReader.readUInt8()) + '\r\n'
    this.result += '-->insert readStringNT: ' + JSON.stringify(iReader.readStringNT()) + '\r\n'
    this.result += '-->insert readBuffer: ' + JSON.stringify(iReader.readBuffer(buf.length)) + '\r\n'
    this.result += '-->insert readBufferNT: ' + JSON.stringify(iReader.readBufferNT()) + '\r\n'
    this.result += '-->insert readInt16BE: ' + JSON.stringify(iReader.readInt16BE()) + '\r\n'
    this.result += '-->insert readInt16LE: ' + JSON.stringify(iReader.readInt16LE()) + '\r\n'
    this.result += '-->insert readUInt16BE: ' + JSON.stringify(iReader.readUInt16BE()) + '\r\n'
    this.result += '-->insert readUInt16LE: ' + JSON.stringify(iReader.readUInt16LE()) + '\r\n'
    this.result += '-->insert readInt32BE: ' + JSON.stringify(iReader.readInt32BE()) + '\r\n'
    this.result += '-->insert readInt32LE: ' + JSON.stringify(iReader.readInt32LE()) + '\r\n'
    this.result += '-->insert readUInt32BE: ' + JSON.stringify(iReader.readUInt32BE()) + '\r\n'
    this.result += '-->insert readUInt32LE: ' + JSON.stringify(iReader.readUInt32LE()) + '\r\n'
    this.result += '-->insert readFloatBE: ' + JSON.stringify(iReader.readFloatBE()) + '\r\n'
    this.result += '-->insert readFloatLE: ' + JSON.stringify(iReader.readFloatLE()) + '\r\n'
    this.result += '-->insert readDoubleBE: ' + JSON.stringify(iReader.readDoubleBE()) + '\r\n'
    this.result += '-->insert readDoubleLE: ' + JSON.stringify(iReader.readDoubleLE()) + '\r\n'


    this.result += 'reading_or_Writing_To_From_SmartBuffer\r\n'
    this.result += '-->readUInt8: ' + JSON.stringify(reader.readUInt8()) + '\r\n'
    this.result += '-->readUInt8: ' + JSON.stringify(reader.readUInt8()) + '\r\n'
    this.result += '-->readInt16BE: ' + JSON.stringify(reader.readInt16BE()) + '\r\n'
    this.result += '-->readInt16LE: ' + JSON.stringify(reader.readInt16LE()) + '\r\n'
    this.result += '-->readUInt16BE: ' + JSON.stringify(reader.readUInt16BE()) + '\r\n'
    this.result += '-->readUInt16LE: ' + JSON.stringify(reader.readUInt16LE()) + '\r\n'
    this.result += '-->readInt32BE: ' + JSON.stringify(reader.readInt32BE()) + '\r\n'
    this.result += '-->readInt32LE: ' + JSON.stringify(reader.readInt32LE()) + '\r\n'
    this.result += '-->readUInt32BE: ' + JSON.stringify(reader.readUInt32BE()) + '\r\n'
    this.result += '-->readUInt32LE: ' + JSON.stringify(reader.readUInt32LE()) + '\r\n'
    this.result += '-->readFloatBE: ' + JSON.stringify(reader.readFloatBE()) + '\r\n'
    this.result += '-->readFloatLE: ' + JSON.stringify(reader.readFloatLE()) + '\r\n'
    this.result += '-->readDoubleBE: ' + JSON.stringify(reader.readDoubleBE()) + '\r\n'
    this.result += '-->readDoubleLE: ' + JSON.stringify(reader.readDoubleLE()) + '\r\n'
    this.result += '-->readUInt8: ' + JSON.stringify(reader.readUInt8(0)) + '\r\n'
    this.result += '-->readInt8: ' + JSON.stringify(reader.readInt8(0)) + '\r\n\r\n'
  }

  private When_BigInt_is_available_and_so_are_Buffer_methods() {
    const wBuffer = new SmartBuffer();
    wBuffer.writeBigInt64LE(BigInt(Number.MAX_SAFE_INTEGER) * BigInt(2));
    wBuffer.writeBigInt64BE(BigInt(Number.MAX_SAFE_INTEGER) * BigInt(3));
    wBuffer.writeBigUInt64LE(BigInt(Number.MAX_SAFE_INTEGER) * BigInt(4));
    wBuffer.writeBigUInt64BE(BigInt(Number.MAX_SAFE_INTEGER) * BigInt(5));

    this.result += 'Reading written-to buffer should read back the results of the insert\r\n'
    this.result += '-->readBigInt64LE: ' + wBuffer.readBigInt64LE() + '\r\n'
    this.result += '-->readBigInt64BE: ' + wBuffer.readBigInt64BE() + '\r\n'
    this.result += '-->readBigUInt64LE: ' + wBuffer.readBigUInt64LE() + '\r\n'
    this.result += '-->readBigUInt64BE: ' + wBuffer.readBigUInt64BE() + '\r\n\r\n'


    const iBuffer = new SmartBuffer();
    iBuffer.insertBigInt64LE(BigInt(Number.MAX_SAFE_INTEGER) * BigInt(6), 0);
    iBuffer.insertBigInt64BE(BigInt(Number.MAX_SAFE_INTEGER) * BigInt(7), 0);
    iBuffer.insertBigUInt64LE(BigInt(Number.MAX_SAFE_INTEGER) * BigInt(8), 0);
    iBuffer.insertBigUInt64BE(BigInt(Number.MAX_SAFE_INTEGER) * BigInt(9), 0);

    this.result += 'Reading inserted-into buffer should read back the results of the insert\r\n'
    this.result += '-->readBigInt64BE: ' + iBuffer.readBigInt64BE() + '\r\n'
    this.result += '-->readBigInt64LE: ' + iBuffer.readBigInt64LE() + '\r\n'
    this.result += '-->readBigUInt64BE: ' + iBuffer.readBigUInt64BE() + '\r\n'
    this.result += '-->readBigUInt64LE: ' + iBuffer.readBigUInt64LE() + '\r\n\r\n'


    const buffer = new SmartBuffer();
    this.result += 'Reading inserted-into buffer should read back the results of the insert\r\n'
    try {

      buffer.writeBigInt64LE(1n)
      buffer.writeBigInt64BE(2n)
      buffer.writeBigUInt64LE(1n)
      buffer.writeBigUInt64BE(2n)

      buffer.insertBigInt64LE(1n, 0)
      buffer.insertBigInt64BE(2n, 0)
      buffer.insertBigUInt64LE(1n, 0)
      buffer.insertBigUInt64BE(2n, 0)

      buffer.readBigInt64LE()
      buffer.readBigInt64BE()
      buffer.readBigUInt64LE()
      buffer.readBigUInt64BE()
      this.result += '-->success : ' + '\r\n\r\n'
    } catch (err) {
      this.result += '-->err : ' + JSON.stringify(err) + '\r\n\r\n'
    }
  }

  private basic_String_Values() {
    let reader = new SmartBuffer();
    reader.writeStringNT('hello');
    reader.writeString('world');
    reader.writeStringNT('✎✏✎✏✎✏');
    reader.insertStringNT('first', 0);
    reader.writeString('hello', 'ascii');
    reader.writeString('hello');

    this.result += 'basic_String_Values\r\n'
    this.result += '-->readStringNT: ' + JSON.stringify(reader.readStringNT()) + '\r\n'
    this.result += '-->readStringNT: ' + JSON.stringify(reader.readStringNT()) + '\r\n'
    this.result += '-->readString: ' + JSON.stringify(reader.readString(5)) + '\r\n'
    this.result += '-->readStringNT: ' + JSON.stringify(reader.readStringNT()) + '\r\n'
    this.result += '-->readString: ' + JSON.stringify(reader.readString(5, 'ascii')) + '\r\n\r\n'
  }

  private mixed_Encoding_Strings() {
    let reader = SmartBuffer.fromOptions({
      encoding: 'ascii'
    });
    reader.writeStringNT('some ascii text');
    reader.writeStringNT('ѕσмє υтƒ8 тєχт', 'utf8');
    reader.insertStringNT('first', 0, 'ascii');

    this.result += 'mixed_Encoding_Strings\r\n'
    this.result += '-->readStringNT: ' + JSON.stringify(reader.readStringNT()) + '\r\n'
    this.result += '-->readStringNT: ' + JSON.stringify(reader.readStringNT()) + '\r\n'
    this.result += '-->readStringNT: ' + JSON.stringify(reader.readStringNT('utf8')) + '\r\n\r\n'

  }

  private null_or_non_null_terminating_strings() {
    let reader = new SmartBuffer();
    reader.writeString('hello\0test\0bleh');

    this.result += 'null_or_non_null_terminating_strings\r\n'
    this.result += '-->readStringNT: ' + JSON.stringify(reader.readStringNT()) + '\r\n'
    this.result += '-->readString4: ' + JSON.stringify(reader.readString(4)) + '\r\n'
    this.result += '-->readStringNT: ' + JSON.stringify(reader.readStringNT().length) + '\r\n'
    this.result += '-->readString0: ' + JSON.stringify(reader.readString(0)) + '\r\n'
    this.result += '-->readStringNT: ' + JSON.stringify(reader.readStringNT()) + '\r\n\r\n'
  }

  private reading_string_without_specifying_length() {
    let str = 'hello123';
    let writer = new SmartBuffer();
    writer.writeString(str);

    let reader = SmartBuffer.fromBuffer(writer.toBuffer());
    this.result += 'reading_string_without_specifying_length\r\n'
    this.result += '-->readString: ' + JSON.stringify(reader.readString()) + '\r\n\r\n'
  }

  private write_string_as_specific_position() {
    let str = 'hello123';
    let writer = new SmartBuffer();
    writer.writeString(str, 10);
    let reader = SmartBuffer.fromBuffer(writer.toBuffer());
    reader.readOffset = 10;
    this.result += 'write_string_as_specific_position\r\n'
    this.result += '-->readString: ' + JSON.stringify(reader.readString()) + '\r\n\r\n'
  }

  private Null_Terminated_Buffer_Writing() {
    let buff = new SmartBuffer();
    buff.writeBufferNT(Buffer.from([0x01, 0x02, 0x03, 0x04]));

    let read1 = buff.readBufferNT();
    this.result += 'write_string_as_specific_position\r\n'
    this.result += '-->readString: ' + JSON.stringify(read1.length) + '\r\n\r\n'
  }

  private writing_buffer_to_position_0() {
    let buff = new SmartBuffer();
    let frontBuff = Buffer.from([1, 2, 3, 4, 5, 6]);
    buff.writeStringNT('hello');
    buff.writeBuffer(frontBuff, 0);

    let readBuff = buff.readBuffer(frontBuff.length);
    this.result += 'writing_buffer_to_position_0\r\n'
    this.result += '-->readBuffer: ' + JSON.stringify(readBuff) + '\r\n\r\n'
  }

  private Adding_more_data_to_the_buffer_than_the_internal_buffer_currently_allows() {
    let writer = new SmartBuffer();
    let largeBuff = Buffer.alloc(10000);
    writer.writeBuffer(largeBuff);
    this.result += 'Adding_more_data_to_the_buffer_than_the_internal_buffer_currently_allows\r\n'
    this.result += '-->length: ' + JSON.stringify(writer.length == largeBuff.length) + '\r\n\r\n'
  }

  private Inserting_values_into_specific_positions() {
    let reader = new SmartBuffer();

    reader.writeUInt16LE(0x0060);
    reader.writeStringNT('something');
    reader.writeUInt32LE(8485934);
    reader.writeUInt16LE(6699);
    reader.writeStringNT('else');
    reader.insertUInt16LE(reader.length - 2, 2);

    reader.readUInt16LE();
    let size = reader.readUInt16LE();
    this.result += 'writing_buffer_to_position_0\r\n'
    this.result += '-->remaining: ' + JSON.stringify(reader.remaining() == size) + '\r\n\r\n'
  }

  private skipping_around_data() {
    let writer = new SmartBuffer();
    writer.writeStringNT('hello');
    writer.writeUInt16LE(6699);
    writer.writeStringNT('world!');

    let reader = SmartBuffer.fromBuffer(writer.toBuffer());
    reader.readOffset += 6;
    this.result += 'skipping_around_data\r\n'
    this.result += '-->readBuff: ' + JSON.stringify(reader.readUInt16LE()) + '\r\n'
    reader.readOffset = 0;
    this.result += '-->readBuff: ' + JSON.stringify(reader.readStringNT()) + '\r\n'
    reader.readOffset -= 6;
    this.result += '-->readBuff: ' + JSON.stringify(reader.readStringNT()) + '\r\n\r\n'
  }

  private setting_write_and_read_offsets() {
    const writer = SmartBuffer.fromSize(100);
    writer.writeString('hellotheremynameisjosh');

    writer.writeOffset = 10;
    this.result += 'setting_write_and_read_offsets\r\n'
    this.result += '-->writeOffset: ' + JSON.stringify(writer.writeOffset) + '\r\n'

    writer.readOffset = 10;
    this.result += '-->writeOffset: ' + JSON.stringify(writer.readOffset) + '\r\n\r\n'
  }

  private describeSetting_encoding() {
    const writer = SmartBuffer.fromSize(100);
    this.result += 'describeSetting_encoding\r\n'
    this.result += '-->encoding: ' + JSON.stringify(writer.encoding) + '\r\n'
    writer.encoding = 'ascii';
    this.result += '-->encoding: ' + JSON.stringify(writer.encoding) + '\r\n\r\n'
  }

  private automatic_internal_buffer_resizing() {
    let writer = new SmartBuffer();
    let str = 'String larger than one byte';
    writer = SmartBuffer.fromSize(1);
    writer.writeString(str);
    this.result += 'automatic_internal_buffer_resizing\r\n'
    this.result += '-->internalBuffer.length: ' + JSON.stringify(writer.internalBuffer.length) + '\r\n\r\n'
  }

  private clearing_the_buffer() {
    let writer = new SmartBuffer();
    writer.writeString('somedata');
    this.result += 'clearing_the_buffer\r\n'
    this.result += '-->writer.length: ' + JSON.stringify(writer.length) + '\r\n'
    this.result += '  clear writer.length: ' + JSON.stringify(writer.length) + '\r\n\r\n'
  }

  private displaying_the_buffer_as_a_string() {
    let buff = Buffer.from([1, 2, 3, 4]);
    let sbuff = SmartBuffer.fromBuffer(buff);

    let str = buff.toString();
    let str64 = buff.toString('binary')

    this.result += 'displaying_the_buffer_as_a_string\r\n'
    this.result += '-->readBuff: ' + JSON.stringify(sbuff.toString() == str) + '\r\n'
    this.result += '-->readBuff: ' + JSON.stringify(sbuff.toString('binary') == str64) + '\r\n\r\n'
  }

  private ensureWritable() {
    let sbuff: ESObject = SmartBuffer.fromSize(10);
    sbuff._ensureWriteable(100);
    this.result += 'writing_buffer_to_position_0\r\n'
    this.result += '-->readBuff: ' + JSON.stringify(sbuff.internalBuffer.length >= 100) + '\r\n\r\n'
  }

  private destroy() {
    let writer = new SmartBuffer();
    writer.writeString('hello123');
    writer.destroy();
    this.result += 'destroy\r\n'
    this.result += '-->length is 0: ' + JSON.stringify(writer.length) + '\r\n\r\n'
  }

  private isSmartBufferOptions() {
    this.result += 'isSmartBufferOptions\r\n'
    this.result += '-->isSmartBufferOptions utf8: ' + JSON.stringify(SmartBuffer.isSmartBufferOptions({
      encoding: 'utf8'
    })) + '\r\n'
    this.result += '-->isSmartBufferOptions size 1024: ' + JSON.stringify(SmartBuffer.isSmartBufferOptions({
      size: 1024
    })) + '\r\n'
    this.result += '-->isSmartBufferOptions buffer: ' + JSON.stringify(
      SmartBuffer.isSmartBufferOptions({
        buff: Buffer.alloc(4096)
      })) + '\r\n\r\n'
  }

  private utils() {
    this.result += 'utils\r\n'
    this.result += '-->isFiniteInteger 10: ' + JSON.stringify(isFiniteInteger(10)) + '\r\n'
    this.result += '-->isFiniteInteger NaN : ' + JSON.stringify(isFiniteInteger(NaN)) + '\r\n'
    this.result += '-->isFiniteInteger: 10.1 ' + JSON.stringify(isFiniteInteger(10.1)) + '\r\n'
    try {
      const invalidEncoding: string = 'sdfdf';
      checkEncoding(invalidEncoding)
      this.result += '-->checkEncoding success : '
    } catch (err) {
      this.result += '-->checkEncoding err : ' + JSON.stringify(err) + '\r\n'
    }
  }
}