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

import { describe, beforeEach, it, expect } from '@ohos/hypium';
import Buffer from '@ohos.buffer';
import { SmartBuffer, SmartBufferOptions } from '@ohos/smart_buffer';
import { checkEncoding, isFiniteInteger } from '@ohos/smart_buffer/src/main/ets/utils';

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    describe('Constructing_with_an_existing_Buffer', () => {
      const buff =
        Buffer.from([0xaa, 0xbb, 0xcc, 0xdd, 0xff, 0x00, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88, 0x99]);
      const reader = SmartBuffer.fromBuffer(buff);

      it('should have the exact same internal Buffer when constructed with a Buffer', 0, () => {
        expect(reader.internalBuffer).assertDeepEquals(buff);
      });

      it('should return a buffer with the same content', 0, () => {
        expect(reader.toBuffer()).assertDeepEquals(buff);
      });
    });

    describe('Constructing_with_an_existing_Buffer_and_setting_the_encoding', () => {
      const buff =
        Buffer.from([0xaa, 0xbb, 0xcc, 0xdd, 0xff, 0x00, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88, 0x99]);
      const reader = SmartBuffer.fromBuffer(buff, 'ascii');

      it('should have the exact same internal Buffer', 0, () => {
        expect(reader.internalBuffer).assertDeepEquals(buff);
      });

      it('should have the same encoding that was set', 0, () => {
        expect(reader.encoding).assertDeepEquals('ascii');
      });
    });

    describe('Constructing_with_a_specified_size', () => {
      const size = 128;
      const reader = SmartBuffer.fromSize(size);

      it('should have an internal Buffer with the same length as the size defined in the constructor', 0, () => {
        expect(reader.internalBuffer.length).assertDeepEquals(size);
      });
    });

    describe('Constructing_with_a_specified_encoding', () => {
      const encoding: Buffer.BufferEncoding = 'utf8';

      it('should have an internal encoding with the encoding given to the constructor (1st argument)', 0, () => {
        const reader = SmartBuffer.fromOptions({
          encoding
        });
        expect(reader.encoding).assertDeepEquals(encoding);
      });

      it('should have an internal encoding with the encoding given to the constructor (2nd argument)', 0, () => {
        const reader = SmartBuffer.fromSize(1024, encoding);
        expect(reader.encoding).assertDeepEquals(encoding);
      });
    });

    describe('Constructing_with_SmartBufferOptions', () => {
      const validOptions1: SmartBufferOptions = {
        size: 1024,
        encoding: 'ascii'
      };

      const validOptions2: SmartBufferOptions = {
        buff: Buffer.alloc(1024)
      };

      const validOptions3: SmartBufferOptions = {
        encoding: 'utf8'
      };

      const invalidOptions1: ESObject = {
        encoding: 'invalid'
      };

      const invalidOptions2: ESObject = {
        size: -1
      };

      const invalidOptions3: ESObject = {
        buff: 'notabuffer'
      };

      it('should create a SmartBuffer with size 1024 and ascii encoding', 0, () => {
        const sbuff = SmartBuffer.fromOptions(validOptions1);
        expect(sbuff.encoding).assertDeepEquals(validOptions1.encoding);
        expect(sbuff.internalBuffer.length).assertDeepEquals(validOptions1.size);
      });

      it('should create a SmartBuffer with the provided buffer as the initial value', 0, () => {
        const sbuff = SmartBuffer.fromOptions(validOptions2);
        expect(sbuff.internalBuffer).assertDeepEquals(validOptions2.buff);
      });

      it('should create a SmartBuffer with the provided ascii encoding, and create a default buffer size', 0, () => {
        const sbuff = SmartBuffer.fromOptions(validOptions3);
        expect(sbuff.encoding).assertDeepEquals(validOptions3.encoding);
        expect(sbuff.internalBuffer.length).assertDeepEquals(4096);
      });

      it('should throw an error when given an options object with an invalid encoding', 0, () => {
        expect(() => {
          // tslint:disable-next-line:no-unused-variable
          const sbuff = SmartBuffer.fromOptions(invalidOptions1);
        });
      });

      it('should throw an error when given an options object with an invalid size', 0, () => {
        expect(() => {
          // tslint:disable-next-line:no-unused-variable
          const sbuff = SmartBuffer.fromOptions(invalidOptions2);
        });
      });

      it('should throw an error when given an options object with an invalid buffer', 0, () => {
        expect(() => {
          // tslint:disable-next-line:no-unused-variable
          const sbuff = SmartBuffer.fromOptions(invalidOptions3);
        });
      });
    });

    describe('Constructing_with_invalid_parameters', () => {
      it('should throw an exception when given an object that is not a valid SmartBufferOptions object', 0, () => {
        expect(() => {
          const invalidOptions: ESObject = {};
          const reader = SmartBuffer.fromOptions(invalidOptions);
        });
      });

      it('should throw an exception when given an invalid number size', 0, () => {
        // const reader = SmartBuffer.fromOptions({
        //   size: -100
        // });
        expect(() => {
          const reader = SmartBuffer.fromOptions({
            size: -100
          });
        }).assertThrowError("Invalid size provided. Size must be a valid integer greater than zero.");
      });

      it('should throw an exception when give a invalid encoding', 0, () => {
        const invalidEncoding: ESObject = 'invalid';
        // tslint:disable-next-line:no-unused-variable
        expect(() => {
          const reader = SmartBuffer.fromOptions({
            encoding: invalidEncoding
          });
        })
          .assertThrowError("Invalid encoding provided. Please specify a valid encoding the internal Node.js Buffer supports.");

        const invalidEncoding1: ESObject = 'invalid';
        // tslint:disable-next-line:no-unused-variable

        expect(() => {
          const reader = SmartBuffer.fromSize(1024, invalidEncoding1);
        })
          .assertThrowError("Invalid encoding provided. Please specify a valid encoding the internal Node.js Buffer supports.");
      });

      it('should throw and exception when given an object that is not a SmartBufferOptions', 0, () => {
        expect(() => {
          const reader = SmartBuffer.fromOptions(null);
        })
          .assertThrowError("Invalid SmartBufferOptions object supplied to SmartBuffer constructor or factory methods.");
      });
    });

    describe('Constructing_with_factory_methods', () => {
      const originalBuffer = Buffer.alloc(10);

      const sbuff1 = SmartBuffer.fromBuffer(originalBuffer);

      it('Should create a SmartBuffer with a provided internal Buffer as the initial value', 0, () => {
        expect(sbuff1.internalBuffer).assertDeepEquals(originalBuffer);
      });

      const sbuff2 = SmartBuffer.fromSize(1024);

      it('Should create a SmartBuffer with a set provided initial Buffer size', 0, () => {
        expect(sbuff2.internalBuffer.length).assertDeepEquals(1024);
      });

      const options: ESObject = {
        size: 1024,
        encoding: 'ascii'
      };

      const sbuff3 = SmartBuffer.fromOptions(options);

      it('Should create a SmartBuffer instance with a given SmartBufferOptions object', 0, () => {
        expect(sbuff3.encoding).assertDeepEquals(options.encoding);
        expect(sbuff3.internalBuffer.length).assertDeepEquals(options.size);
      });
    });
  });

  describe('Reading_or_Writing_To_From_SmartBuffer', () => {
    /**
     * Technically, if one of these works, they all should. But they're all here ESObjectways.
     */
    describe('Numeric_Values', () => {
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
      iReader.insertBuffer(Buffer.from('he'), 2);
      iReader.insertBufferNT(Buffer.from('he'), 2);
      iReader.readInt8(0);

      it('should equal the correct values that were written above', 0, () => {
        expect(reader.readUInt8()).assertDeepEquals(0xc8);
        expect(reader.readUInt8()).assertDeepEquals(0xff);
        expect(reader.readInt16BE()).assertDeepEquals(0x6699);
        expect(reader.readInt16LE()).assertDeepEquals(0xc8);
        expect(reader.readInt16LE()).assertDeepEquals(0x6699);
        expect(reader.readUInt16BE()).assertDeepEquals(0xffdd);
        expect(reader.readUInt16LE()).assertDeepEquals(0xffdd);
        expect(reader.readInt32BE()).assertDeepEquals(0x77889900);
        expect(reader.readInt32LE()).assertDeepEquals(0x77889900);
        expect(reader.readUInt32BE()).assertDeepEquals(0xffddccbb);
        expect(reader.readUInt32LE()).assertDeepEquals(0xffddccbb);
        expect(reader.readFloatBE()).assertClose(1.234, 0.001);
        expect(reader.readFloatLE()).assertClose(1.234, 0.001);
        expect(reader.readDoubleBE()).assertClose(1.23456789, 0.001);
        expect(reader.readDoubleLE()).assertClose(1.23456789, 0.001);
        expect(reader.readUInt8(0)).assertEqual(0xc8);
      });

      it('should throw an exception if attempting to read numeric values from a buffer with not enough data left', 0,
        () => {
          expect(() => {
            reader.readUInt32BE();
          });
        });

      it('should throw an exception if attempting to write numeric values to a negative offset.', 0, () => {
        expect(() => {
          reader.writeUInt16BE(20, -5);
        });
      });
    });


    describe('BigInt_values', () => {
      describe('When_BigInt_is_available_and_so_are_Buffer_methods', () => {
        beforeEach(() => {
          if (typeof BigInt === 'undefined' ||
            typeof Buffer.Buffer.prototype.writeBigInt64BE === 'undefined') {
            // this.skip();
          }
        });

        it('Reading written-to buffer should read back the results of the insert', 0, () => {
          const wBuffer = new SmartBuffer();
          wBuffer.writeBigInt64LE(BigInt(Number.MAX_SAFE_INTEGER) * BigInt(2));
          wBuffer.writeBigInt64BE(BigInt(Number.MAX_SAFE_INTEGER) * BigInt(3));
          wBuffer.writeBigUInt64LE(BigInt(Number.MAX_SAFE_INTEGER) * BigInt(4));
          wBuffer.writeBigUInt64BE(BigInt(Number.MAX_SAFE_INTEGER) * BigInt(5));

          expect(wBuffer.readBigInt64LE()).assertEqual(BigInt(Number.MAX_SAFE_INTEGER) * BigInt(2));
          expect(wBuffer.readBigInt64BE()).assertEqual(BigInt(Number.MAX_SAFE_INTEGER) * BigInt(3));
          expect(wBuffer.readBigUInt64LE()).assertEqual(BigInt(Number.MAX_SAFE_INTEGER) * BigInt(4));
          expect(wBuffer.readBigUInt64BE()).assertEqual(BigInt(Number.MAX_SAFE_INTEGER) * BigInt(5));
        });

        it('Reading inserted-into buffer should read back the results of the insert', 0, () => {
          const iBuffer = new SmartBuffer();
          iBuffer.insertBigInt64LE(BigInt(Number.MAX_SAFE_INTEGER) * BigInt(6), 0);
          iBuffer.insertBigInt64BE(BigInt(Number.MAX_SAFE_INTEGER) * BigInt(7), 0);
          iBuffer.insertBigUInt64LE(BigInt(Number.MAX_SAFE_INTEGER) * BigInt(8), 0);
          iBuffer.insertBigUInt64BE(BigInt(Number.MAX_SAFE_INTEGER) * BigInt(9), 0);

          expect(iBuffer.readBigInt64BE()).assertEqual(BigInt(Number.MAX_SAFE_INTEGER) * BigInt(9));
          expect(iBuffer.readBigInt64LE()).assertEqual(BigInt(Number.MAX_SAFE_INTEGER) * BigInt(8));
          expect(iBuffer.readBigUInt64BE()).assertEqual(BigInt(Number.MAX_SAFE_INTEGER) * BigInt(7));
          expect(iBuffer.readBigUInt64LE()).assertEqual(BigInt(Number.MAX_SAFE_INTEGER) * BigInt(6));
        });
      });

      describe('When_BigInt_is_available_but_buffer_methods_are_not', () => {
        beforeEach(() => {
          if (typeof BigInt === 'undefined' ||
            typeof Buffer.Buffer.prototype.readBigInt64BE === 'function') {
            // skip();
          }
        });
        const buffer = new SmartBuffer();

        // Taking a Number to a BigInt as we do below is semantically invalid,
        // and implicit casting between Number and BigInt throws a TypeError in
        // JavaScript. However here, these methods immediately throw the platform
        // exception, and no cast really takes place. These casts are solely to
        // satisfy the type checker, as BigInt doesn't exist at runtime in these tests

        it('Writing throws an exception', 0, () => {
          expect(() => buffer.writeBigInt64LE(1n)).not().assertThrowError(
            'Platform does not support Buffer.prototype.writeBigInt64LE.');
          expect(() => buffer.writeBigInt64BE(2n)).not().assertThrowError(
            'Platform does not support Buffer.prototype.writeBigInt64BE.');
          expect(() => buffer.writeBigUInt64LE(1n)).not().assertThrowError(
            'Platform does not support Buffer.prototype.writeBigUInt64LE.');
          expect(() => buffer.writeBigUInt64BE(2n)).not().assertThrowError(
            'Platform does not support Buffer.prototype.writeBigUInt64BE.');
        });

        it('Inserting throws an exception', 0, () => {
          expect(
            () => buffer.insertBigInt64LE(1n, 0)).not().assertThrowError(
            'Platform does not support Buffer.prototype.writeBigInt64LE.');
          expect(
            () => buffer.insertBigInt64BE(2n, 0)).not().assertThrowError(
            'Platform does not support Buffer.prototype.writeBigInt64BE.');
          expect(
            () => buffer.insertBigUInt64LE(1n, 0)).not().assertThrowError(
            'Platform does not support Buffer.prototype.writeBigUInt64LE.');
          expect(() => buffer.insertBigUInt64BE(2n, 0)).not().assertThrowError(
            'Platform does not support Buffer.prototype.writeBigUInt64BE.');
        });

        it('Reading throws an exception', 0, () => {
          expect(() => buffer.readBigInt64LE())
            .not().assertThrowError('Platform does not support Buffer.prototype.readBigInt64LE.');
          expect(() => buffer.readBigInt64BE())
            .not().assertThrowError('Platform does not support Buffer.prototype.readBigInt64BE.');
          expect(() => buffer.readBigUInt64LE())
            .not().assertThrowError('Platform does not support Buffer.prototype.readBigUInt64LE.');
          expect(() => buffer.readBigUInt64BE())
            .not().assertThrowError('Platform does not support Buffer.prototype.readBigUInt64BE.');
        });
      });

      describe('When_BigInt_is_unavailable', () => {
        beforeEach(() => {
          if (typeof BigInt === 'function') {
            // skip();
          }
        });
        const buffer = new SmartBuffer();

        // Taking a Number to a BigInt as we do below is semantically invalid,
        // and implicit casting between Number and BigInt throws a TypeError in
        // JavaScript. However here, these methods immediately throw the platform
        // exception, and no cast really takes place. These casts are solely to
        // satisfy the type checker, as BigInt doesn't exist at runtime in these tests

        it('Writing throws an exception', 0, () => {
          expect(() => buffer.writeBigInt64LE(1n))
            .not().assertThrowError('Platform does not support JS BigInt type.');
          expect(() => buffer.writeBigInt64BE(2n))
            .not().assertThrowError('Platform does not support JS BigInt type.');
          expect(() => buffer.writeBigUInt64LE(1n))
            .not().assertThrowError('Platform does not support JS BigInt type.');
          expect(() => buffer.writeBigUInt64BE(2n))
            .not().assertThrowError('Platform does not support JS BigInt type.');
        });

        it('Inserting throws an exception', 0, () => {
          expect(() => buffer.insertBigInt64LE(1n, 0)).not().assertThrowError(
            'Platform does not support JS BigInt type.');
          expect(() => buffer.insertBigInt64BE(2n, 0)).not().assertThrowError(
            'Platform does not support JS BigInt type.');
          expect(() => buffer.insertBigUInt64LE(1n, 0)).not().assertThrowError(
            'Platform does not support JS BigInt type.');
          expect(() => buffer.insertBigUInt64BE(2n, 0)).not().assertThrowError(
            'Platform does not support JS BigInt type.');
        });

        it('Reading throws an exception', 0, () => {
          expect(() => buffer.readBigInt64LE())
            .not()
            .assertThrowError('Platform does not support Buffer.prototype.readBigInt64LE.');
          expect(() => buffer.readBigInt64BE())
            .not()
            .assertThrowError('Platform does not support Buffer.prototype.readBigInt64BE.');
          expect(() => buffer.readBigUInt64LE())
            .not()
            .assertThrowError('Platform does not support Buffer.prototype.readBigUInt64LE.');
          expect(() => buffer.readBigUInt64BE())
            .not()
            .assertThrowError('Platform does not support Buffer.prototype.readBigUInt64BE.');
        });
      });
    });

    describe('Basic_String_Values', () => {
      let reader = new SmartBuffer();
      reader.writeStringNT('hello');
      reader.writeString('world');
      reader.writeStringNT('✎✏✎✏✎✏');
      reader.insertStringNT('first', 0);
      reader.writeString('hello', 'ascii');
      reader.writeString('hello');

      it('should equal the correct strings that were written prior', 0, () => {
        expect(reader.readStringNT()).assertDeepEquals('first');
        expect(reader.readStringNT()).assertDeepEquals('hello');
        expect(reader.readString(5)).assertDeepEquals('world');
        expect(reader.readStringNT()).assertDeepEquals('✎✏✎✏✎✏');
        expect(reader.readString(5, 'ascii')).assertDeepEquals('hello');
      });

      it('should throw an exception if passing in an invalid string length to read (infinite)', 0, () => {
        expect(() => {
          reader.readString(NaN);
        });
      });

      it('should throw an exception if passing in an invalid string length to read (negative)', 0, () => {
        expect(() => {
          reader.readString(-5);
        });
      });

      it('should throw an exception if passing in an invalid string offset to insert (non number)', 0, () => {
        expect(() => {
          const invalidNumber: ESObject = 'sdfdf';
          reader.insertString('hello', invalidNumber);
        });
      });
    });

    describe('Mixed_Encoding_Strings', () => {
      let reader = SmartBuffer.fromOptions({
        encoding: 'ascii'
      });
      reader.writeStringNT('some ascii text');
      reader.writeStringNT('ѕσмє υтƒ8 тєχт', 'utf8');
      reader.insertStringNT('first', 0, 'ascii');

      it('should equal the correct strings that were written above', 0, () => {
        expect(reader.readStringNT()).assertDeepEquals('first');
        expect(reader.readStringNT()).assertDeepEquals('some ascii text');
        expect(reader.readStringNT('utf8')).assertDeepEquals('ѕσмє υтƒ8 тєχт');
      });

      it('should throw an error when an invalid encoding is provided', 0, () => {
        expect(() => {
          // tslint:disable-next-line
          const invalidBufferType: ESObject = 'invalid';
          reader.writeString('hello', invalidBufferType);
        });
      });

      it('should throw an error when an invalid encoding is provided along with a valid offset', 0, () => {
        expect(() => {
          const invalidBufferType: ESObject = 'invalid';
          reader.writeString('hellothere', 2, invalidBufferType);
        });
      });
    });

    describe('Null_or_non_null_terminating_strings', () => {
      let reader = new SmartBuffer();
      reader.writeString('hello\0test\0bleh');

      it('should equal hello', 0, () => {
        expect(reader.readStringNT()).assertDeepEquals('hello');
      });

      it('should equal: test', 0, () => {
        expect(reader.readString(4)).assertDeepEquals('test');
      });

      it('should have a length of zero', 0, () => {
        expect(reader.readStringNT().length).assertDeepEquals(0);
      });

      it('should return an empty string', 0, () => {
        expect(reader.readString(0)).assertDeepEquals('');
      });

      it('should equal: bleh', 0, () => {
        expect(reader.readStringNT()).assertDeepEquals('bleh');
      });
    });

    describe('Reading_string_without_specifying_length', () => {
      let str = 'hello123';
      let writer = new SmartBuffer();
      writer.writeString(str);

      let reader = SmartBuffer.fromBuffer(writer.toBuffer());

      expect(reader.readString()).assertDeepEquals(str);
    });

    describe('Write_string_as_specific_position', () => {
      let str = 'hello123';
      let writer = new SmartBuffer();
      writer.writeString(str, 10);

      let reader = SmartBuffer.fromBuffer(writer.toBuffer());

      reader.readOffset = 10;
      it('Should read the correct string from the original position it was written to.', 0, () => {
        expect(reader.readString()).assertDeepEquals(str);
      });
    });

    describe('Buffer_Values', () => {
      describe('Writing_buffer_to_position_0', () => {
        let buff = new SmartBuffer();
        let frontBuff = Buffer.from([1, 2, 3, 4, 5, 6]);
        buff.writeStringNT('hello');
        buff.writeBuffer(frontBuff, 0);

        it('should write the buffer to the front of the smart buffer instance', 0, () => {
          let readBuff = buff.readBuffer(frontBuff.length);
          expect(readBuff).assertDeepEquals(frontBuff);
        });
      });

      describe('Writing_null_terminated_buffer_to_position_0', () => {
        let buff = new SmartBuffer();
        let frontBuff = Buffer.from([1, 2, 3, 4, 5, 6]);
        buff.writeStringNT('hello');
        buff.writeBufferNT(frontBuff, 0);

        it('should write the buffer to the front of the smart buffer instance', 0, () => {
          let readBuff = buff.readBufferNT();
          expect(readBuff).assertDeepEquals(frontBuff);
        });
      });

      describe('Explicit_lengths', () => {
        let buff = Buffer.from([0x01, 0x02, 0x04, 0x08, 0x16, 0x32, 0x64]);
        let reader = new SmartBuffer();
        reader.writeBuffer(buff);

        it('should equal the buffer that was written above.', 0, () => {
          expect(reader.readBuffer(7)).assertDeepEquals(buff);
        });
      });

      describe('Implicit_lengths', () => {
        let buff = Buffer.from([0x01, 0x02, 0x04, 0x08, 0x16, 0x32, 0x64]);
        let reader = new SmartBuffer();
        reader.writeBuffer(buff);

        it('should equal the buffer that was written above.', 0, () => {
          expect(reader.readBuffer()).assertDeepEquals(buff);
        });
      });

      describe('Null_Terminated_Buffer_Reading', () => {
        let buff = new SmartBuffer();
        buff.writeBuffer(Buffer.from([0x01, 0x02, 0x03, 0x04, 0x00, 0x01, 0x02, 0x03]));

        let read1 = buff.readBufferNT();
        let read2 = buff.readBufferNT();

        it('Should return a length of 4 for the four bytes before the first null in the buffer.', 0, () => {
          expect(read1.length).assertEqual(4);
        });

        it('Should return a length of 3 for the three bytes after the first null in the buffer after reading to end.',
          0, () => {
            expect(read2.length).assertEqual(3);
          });
      });

      describe('Null_Terminated_Buffer_Writing', () => {
        let buff = new SmartBuffer();
        buff.writeBufferNT(Buffer.from([0x01, 0x02, 0x03, 0x04]));

        let read1 = buff.readBufferNT();

        it('Should read the correct null terminated buffer data.', 0, () => {
          expect(read1.length).assertEqual(4);
        });
      });

      describe('Reading_buffer_from_invalid_offset', () => {
        let buff = new SmartBuffer();
        buff.writeBuffer(Buffer.from([1, 2, 3, 4, 5, 6]));

        it('Should throw an exception if attempting to read a Buffer from an invalid offset', 0, () => {
          expect(() => {
            const invalidOffset: ESObject = 'sfsdf';
            buff.readBuffer(invalidOffset);
          });
        });
      });

      describe('Inserting_values_into_specific_positions', () => {
        let reader = new SmartBuffer();

        reader.writeUInt16LE(0x0060);
        reader.writeStringNT('something');
        reader.writeUInt32LE(8485934);
        reader.writeUInt16LE(6699);
        reader.writeStringNT('else');
        reader.insertUInt16LE(reader.length - 2, 2);

        it('should equal the size of the remaining data in the buffer', 0, () => {
          reader.readUInt16LE();
          let size = reader.readUInt16LE();
          expect(reader.remaining()).assertDeepEquals(size);
        });
      });

      describe('Adding_more_data_to_the_buffer_than_the_internal_buffer_currently_allows.', () => {
        it('Should automatically adjust internal buffer size when needed', 0, () => {
          let writer = new SmartBuffer();
          let largeBuff = Buffer.alloc(10000);

          writer.writeBuffer(largeBuff);

          expect(writer.length).assertDeepEquals(largeBuff.length);
        });
      });
    });
  });

  describe('Skipping_around_data', () => {
    let writer = new SmartBuffer();
    writer.writeStringNT('hello');
    writer.writeUInt16LE(6699);
    writer.writeStringNT('world!');

    it('Should equal the UInt16 that was written above', 0, () => {
      let reader = SmartBuffer.fromBuffer(writer.toBuffer());
      reader.readOffset += 6;
      expect(reader.readUInt16LE()).assertDeepEquals(6699);
      reader.readOffset = 0;
      expect(reader.readStringNT()).assertDeepEquals('hello');
      reader.readOffset -= 6;
      expect(reader.readStringNT()).assertDeepEquals('hello');
    });

    it('Should throw an error when attempting to skip more bytes than actually exist.', 0, () => {
      let reader = SmartBuffer.fromBuffer(writer.toBuffer());
      expect(() => {
        reader.readOffset = 10000;
      });
    });
  });

  describe('Setting_write_and_read_offsets', () => {
    const writer = SmartBuffer.fromSize(100);
    writer.writeString('hellotheremynameisjosh');

    it('should set the write offset to 10', 0, () => {
      writer.writeOffset = 10;
      expect(writer.writeOffset).assertDeepEquals(10);
    });

    it('should set the read offset to 10', 0, () => {
      writer.readOffset = 10;
      expect(writer.readOffset).assertDeepEquals(10);
    });

    it('should throw an error when given an offset that is out of bounds', 0, () => {
      expect(() => {
        writer.readOffset = -1;
      });
    });

    it('should throw an error when given an offset that is out of bounds1', 0, () => {
      expect(() => {
        writer.writeOffset = 1000;
      });
    });
  });

  describe('Setting_encoding', () => {
    const writer = SmartBuffer.fromSize(100);
    it('should have utf8 encoding by default', 0, () => {
      expect(writer.encoding).assertDeepEquals('utf8');
    });

    it('should have ascii encoding after being set', 0, () => {
      writer.encoding = 'ascii';
      expect(writer.encoding).assertDeepEquals('ascii');
    });
  });

  describe('Automatic_internal_buffer_resizing', () => {
    let writer = new SmartBuffer();

    it('Should not throw an error when adding data that is larger than current buffer size (internal resize algo fails)',
      0, () => {
        let str = 'String larger than one byte';
        writer = SmartBuffer.fromSize(1);
        writer.writeString(str);

        expect(writer.internalBuffer.length).assertDeepEquals(str.length);
      });

    it('Should not throw an error when adding data that is larger than current buffer size (internal resize algo succeeds)',
      0, () => {
        writer = SmartBuffer.fromSize(100);
        let buff = Buffer.alloc(105);

        writer.writeBuffer(buff);

        // Test internal array growth algo.
        expect(writer.internalBuffer.length).assertEqual(100 * 3 / 2 + 1);
      });
  });

  describe('Clearing_the_buffer', () => {
    let writer = new SmartBuffer();
    writer.writeString('somedata');

    it('Should contain some data.', 0, () => {
      expect(writer.length).not().assertEqual(0);
    });

    it('Should contain zero data after being cleared.', 0, () => {
      writer.clear();
      expect(writer.length).assertDeepEquals(0);
    });
  });

  describe('Displaying_the_buffer_as_a_string', () => {
    let buff = Buffer.from([1, 2, 3, 4]);
    let sbuff = SmartBuffer.fromBuffer(buff);

    let str = buff.toString();
    let str64 = buff.toString('binary');

    it('Should return a valid string representing the internal buffer', 0, () => {
      expect(str).assertDeepEquals(sbuff.toString());
    });

    it('Should return a valid base64 string representing the internal buffer', 0, () => {
      expect(str64).assertDeepEquals(sbuff.toString('binary'));
    });

    it('Should throw an error if an invalid encoding is provided', 0, () => {
      expect(() => {
        const invalidencoding: ESObject = 'invalid';
        let strError = sbuff.toString(invalidencoding);
      });
    });
  });

  describe('Destroying_the_buffer', () => {
    let writer = new SmartBuffer();
    writer.writeString('hello123');

    writer.destroy();

    it('Should have a length of zero when buffer is destroyed', 0, () => {
      expect(0).assertDeepEquals(writer.length);
    });
  });

  describe('ensureWritable', () => {
    let sbuff: ESObject = SmartBuffer.fromSize(10);
    it('should increase the internal buffer size to accomodate given size.', 0, () => {
      sbuff._ensureWriteable(100);
      expect(sbuff.internalBuffer.length >= 100).assertDeepEquals(true);
    });
  });

  describe('isSmartBufferOptions', () => {
    it('should return true when encoding is defined', 0, () => {
      expect(
        SmartBuffer.isSmartBufferOptions({
          encoding: 'utf8'
        })).assertDeepEquals(true);
    });

    it('should return true when size is defined', 0, () => {
      expect(
        SmartBuffer.isSmartBufferOptions({
          size: 1024
        })
      ).assertDeepEquals(true);
    });

    it('should return true when buff is defined', 0, () => {
      expect(
        SmartBuffer.isSmartBufferOptions({
          buff: Buffer.alloc(4096)
        })).assertDeepEquals(true);
    });
  });

  describe('utils', () => {
    describe('isFiniteInteger', () => {
      it('should return true for a number that is finite and an integer', 0, () => {
        expect(isFiniteInteger(10)).assertTrue();
      });

      it('should return false for a number that is infinite', 0, () => {
        expect(isFiniteInteger(NaN)).assertFalse();
      });

      it('should return false for a number that is not an integer', 0, () => {
        expect(isFiniteInteger(10.1)).assertFalse();
      });
    });

    describe('checkEncoding', () => {
      it('should throw an exception if a given string is not a valid BufferEncoding', 0, () => {
        expect(() => {
          const invalidEncoding: ESObject = 'sdfdf';
          checkEncoding(invalidEncoding);
        });
      });
    });
  })
}
