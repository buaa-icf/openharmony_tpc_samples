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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { utilConcatView, bufferToHexCodes,
  arrayBufferToString,
  getUTCDate,
  getParametersValue,
  checkBufferParams,
  LocalBaseBlock,
  utilFromBase,
  utilToBase,
  padNumber,
  utilEncodeTC,
  toBase64,
  fromBase64,
  stringToArrayBuffer,
  nearestPowerOf2,
  clearProps,
  isEqualBuffer,
  utilConcatBuf } from "pvutils"

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
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
    let data = new Uint8Array([0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A]);
    it('getUTCDate', 0, () => {
      let data = new Date('2017-08-08T12:46:15.797Z');
      let getDate = getUTCDate(data)
      expect(getDate.toString()).assertEqual('Tue Aug 08 2017 12:46:15 GMT+0800');
    })

    it('getParametersValue', 0, () => {
      let data: Record<string, string> = { 'name': 'May', 'age': '2' }
      let message: string = getParametersValue(data, 'age', '');
      expect(getParametersValue({ name: 33 }, "name", 2)).assertEqual(33);
      expect(getParametersValue({ name: 33 }, "fake", 2)).assertEqual(2);
      expect(message).assertEqual('2');
    })

    it('bufferToHexCodes', 0, () => {
      expect(bufferToHexCodes(data.buffer)).assertEqual('0102030405060708090A');
      expect(bufferToHexCodes(data.buffer, 1)).assertEqual('02030405060708090A');
      expect(bufferToHexCodes(data.buffer, 1, 3)).assertEqual('020304');
      expect(bufferToHexCodes(data.buffer, 1, 3, true)).assertEqual('02 03 04');
    })

    it('checkBufferParams', 0, () => {
      let baseBlock = {} as LocalBaseBlock;
      let buffer = new ArrayBuffer(10);
      let intArray = new Uint8Array(buffer);
      intArray[0] = 25;
      let message: boolean = checkBufferParams(baseBlock, buffer, 12, 6);
      expect(message).assertEqual(false);
      expect(checkBufferParams(baseBlock, data.buffer, 1, 1)).assertEqual(true);
      expect(checkBufferParams(baseBlock, (new Uint8Array()).buffer, 1, 1)).assertEqual(false);
      expect(checkBufferParams(baseBlock, data.buffer, -1, 1)).assertEqual(false);
    })

    it('checkBufferParamsTest', 0, () => {
      let baseBlock = {} as LocalBaseBlock;
      let result = checkBufferParams(baseBlock, 1 as ESObject, 1, 1);
      expect(result).assertEqual(false);
      expect(baseBlock.error).assertEqual("Wrong parameter: inputBuffer must be \"ArrayBuffer\"");

      result = checkBufferParams(baseBlock, (new Uint8Array()).buffer, 1, 1);
      expect(result).assertEqual(false);
      expect(baseBlock.error).assertEqual("Wrong parameter: inputBuffer has zero length");

      result = checkBufferParams(baseBlock, data.buffer, -1, 1);
      expect(result).assertEqual(false);
      expect(baseBlock.error).assertEqual("Wrong parameter: inputOffset less than zero");

      result = checkBufferParams(baseBlock, data.buffer, 1, -1);
      expect(result).assertEqual(false);
      expect(baseBlock.error).assertEqual("Wrong parameter: inputLength less than zero");

      result = checkBufferParams(baseBlock, data.buffer, 11, 1);
      expect(result).assertEqual(false);
      expect(baseBlock.error).assertEqual("End of input reached before message was fully decoded (inconsistent offset and length values)");

      result = checkBufferParams(baseBlock, data.buffer, 1, 1);
      expect(result).assertEqual(true);
    })

    it('utilFromBase', 0, () => {
      let buffer = new ArrayBuffer(12);
      let inputBuffer = new Uint8Array(buffer);
      inputBuffer[0] = 30;
      let message = utilFromBase(inputBuffer, 8);
      expect(message).assertEqual(9.284550294640352e+27);
      expect(utilFromBase(new Uint8Array([0x01]), 7)).assertEqual(1);
      expect(utilFromBase(new Uint8Array([0x01, 0x01]), 7)).assertEqual(129);
      expect(utilFromBase(new Uint8Array([0x01, 0x01, 0x01]), 7)).assertEqual(16513);
    })

    it('utilToBase', 0, () => {
      let message = utilToBase(2, 2);
      expect(bufferToHexCodes(utilToBase(1, 7))).assertEqual('01');
      expect(bufferToHexCodes(utilToBase(129, 7))).assertEqual('0101');
      expect(bufferToHexCodes(utilToBase(16513, 7))).assertEqual('010101');
      expect(bufferToHexCodes(utilToBase(16513, 7, 4))).assertEqual('00010101');
      expect(bufferToHexCodes(utilToBase(16513, 7, 0))).assertEqual('');
      expect(bufferToHexCodes(utilToBase(16777218, 3))).assertEqual('');
      expect(JSON.stringify(message)).assertEqual('{}');
    })

    it('utilConcatBuf', 0, () => {
      let buffer = new ArrayBuffer(22);
      let intArray = new Uint8Array(buffer);
      let buffers: ArrayBuffer[] = [intArray, intArray]
      let message = JSON.stringify(utilConcatBuf(...buffers));
      expect(message).assertEqual('{}');
      expect(bufferToHexCodes(utilConcatBuf(data.buffer, data.buffer, data.buffer))).assertEqual('0102030405060708090A0102030405060708090A0102030405060708090A');
      expect(bufferToHexCodes(utilConcatBuf(data.buffer, data.buffer))).assertEqual('0102030405060708090A0102030405060708090A');
      expect(bufferToHexCodes(utilConcatBuf(data.buffer))).assertEqual('0102030405060708090A');
    })

    it('utilConcatView', 0, () => {
      let buffer = new ArrayBuffer(2);
      let intArray = new Uint8Array(buffer);
      let buffers: Uint8Array[] = [intArray, intArray]
      let message = JSON.stringify(utilConcatView(...buffers));
      expect(message).assertEqual('{"0":0,"1":0,"2":0,"3":0}');
      expect(bufferToHexCodes(utilConcatView(data).buffer)).assertEqual('0102030405060708090A');
      expect(bufferToHexCodes(utilConcatView(data, data).buffer)).assertEqual('0102030405060708090A0102030405060708090A');
      expect(bufferToHexCodes(utilConcatView(data, data, data).buffer)).assertEqual('0102030405060708090A0102030405060708090A0102030405060708090A');
    })

    it('utilEncodeTC', 0, () => {
      expect(bufferToHexCodes(utilEncodeTC(32639))).assertEqual('7F7F');
      expect(bufferToHexCodes(utilEncodeTC(-32639))).assertEqual('8081');
      expect(bufferToHexCodes(utilEncodeTC(256))).assertEqual('0100');
      expect(bufferToHexCodes(utilEncodeTC(-256))).assertEqual('FF00');
      expect(bufferToHexCodes(utilEncodeTC(128))).assertEqual('0080');
      expect(bufferToHexCodes(utilEncodeTC(18446744073709552001))).assertEqual('');
    })

    it('isEqualBuffer', 0, () => {
      let buffer = new ArrayBuffer(10);
      let intArray = new Uint8Array(buffer);
      intArray[0] = 52;
      let bufferCompare = new ArrayBuffer(10);
      let intArrayCompare = new Uint8Array(bufferCompare);
      intArrayCompare[0] = 9;
      let message = isEqualBuffer(buffer, bufferCompare);
      expect(message).assertEqual(false);
      expect(isEqualBuffer(data.buffer, data.buffer)).assertEqual(true);
      expect(isEqualBuffer(data.buffer, (new Uint8Array()).buffer)).assertEqual(false);
      expect(isEqualBuffer(data.buffer, (new Uint8Array([0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0F])).buffer)).assertEqual(false);
    })

    it('padNumber', 0, () => {
      let message = padNumber(4, 2);
      expect(message).assertEqual('04');
      expect(padNumber(1, -1)).assertEqual('');
      expect(padNumber(1, 1)).assertEqual('1');
      expect(padNumber(1, 2)).assertEqual('01');
    })

    it('toBase64', 0, () => {
      expect(toBase64("\x01\x02\x03\x04\x05\x06\x07\x08\xFF\xFF")).assertEqual('AQIDBAUGBwj//w==');
      expect(toBase64("\x01\x02\x03\x04\x05\x06\x07\x08\xFF\xFF", true)).assertEqual('AQIDBAUGBwj__w==');
      expect(toBase64("\x01\x02\x03\x04\x05\x06\xFF\xFF\xFF\xFF", true, true)).assertEqual('AQIDBAUG_____w');
      expect(toBase64("\x00\x00\x01\x02\x03\x04\x05\x06\xFF\xFF\xFF\xFF\xFF", true, true, true)).assertEqual('AQIDBAUG______8');
    })

    it('fromBase64', 0, () => {
      let message = fromBase64('aGVsbG8=');
      expect(message).assertEqual('hello');
      expect(fromBase64("AQIDBAUGBwj//w==")).assertEqual("\x01\x02\x03\x04\x05\x06\x07\x08\xFF\xFF");
      expect(fromBase64("AQIDBAUGBwj__w==", true)).assertEqual("\x01\x02\x03\x04\x05\x06\x07\x08\xFF\xFF");
      expect(fromBase64("AQIDBAUGBwj__wAA", true, true)).assertEqual("\x01\x02\x03\x04\x05\x06\x07\x08\xFF\xFF");
      expect(fromBase64("AQIDBAUGBwj__w==", true, true)).assertEqual("\x01\x02\x03\x04\x05\x06\x07\x08\xFF\xFF");
      expect(fromBase64("AAAAAA====", true, true)).assertEqual('');
      expect(fromBase64("AAAAAAAAA", true, true)).assertEqual('');
    })

    it('arrayBufferToString', 0, () => {
      let buffer = new ArrayBuffer(2);
      let intArray = new Uint8Array(buffer);
      intArray[0] = 72;
      intArray[1] = 105;
      let message = arrayBufferToString(buffer);
      expect(message).assertEqual('Hi');
      expect(arrayBufferToString(data.buffer)).assertEqual("\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0A");
    })

    it('stringToArrayBuffer', 0, () => {
      let message = stringToArrayBuffer('hello');
      expect(JSON.stringify(message)).assertEqual('{}');
      expect(isEqualBuffer(stringToArrayBuffer("\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0A"), data.buffer)).assertEqual(true);
    })

    it('nearestPowerOf2', 0, () => {
      let message = nearestPowerOf2(6);
      expect(message).assertEqual(3);
      expect(nearestPowerOf2(7)).assertEqual(3);
      expect(nearestPowerOf2(5)).assertEqual(2);
    })

    it('clearProps', 0, () => {
      let object: Record<string, ESObject> = { 'name': 'may', 'key': 12 }
      let message = JSON.stringify(clearProps(object, ['name']));
      expect(message).assertUndefined();
    })
  })
}