/**
 * MIT License
 *
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the 'Software'), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to all conditions.
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, } from '@ohos/hypium'
import { BlufiUtil, BlufiAES } from '@ohos/espblufiforharmony'
import { buffer } from '@kit.ArkTS'
import cryptoFramework from '@ohos.security.cryptoFramework'

export default function BlufiAESTest() {
  describe('BlufiAESTest', () => {
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
    it('BlufiAES', 0, async () => {

      let mAESKeyStr: string = '9999999999999999';
      let SIXTEEN: number = 16;
      let mAESKey: Uint8Array = BlufiUtil.stringToUint8Array(mAESKeyStr, SIXTEEN);
      let transform: string = 'AES128|CBC|PKCS5';
      let sequence: number = 99;
      let ivU8: Uint8Array = new Uint8Array(new ArrayBuffer(SIXTEEN));
      ivU8[0] = sequence;
      let ivDataBlob: cryptoFramework.DataBlob = {
        data: ivU8
      };
      let aesTool: BlufiAES = new BlufiAES(mAESKey, transform, {
        iv: ivDataBlob, algName: 'IvParamsSpec'
      });
      let resultStr: string = '123456778';
      let resultData: Uint8Array = new Uint8Array(buffer.from(resultStr).buffer);
      let resultDataBlob: cryptoFramework.DataBlob = {
        data: resultData
      };
      let encodeData: cryptoFramework.DataBlob | null = await aesTool.encrypt(resultDataBlob);
      expect(encodeData).assertInstanceOf('Object');

      let decryptData: cryptoFramework.DataBlob | null = await aesTool.decrypt(encodeData);
      expect(decryptData).assertInstanceOf('Object');

      let decrypDataStr = '';
      if (decryptData) {
        decryptData!.data.forEach((value) => {
          decrypDataStr += String.fromCharCode(value);
        });
      }
      expect(decrypDataStr.length).assertLarger(0);

      let rightAll: boolean = decrypDataStr == resultStr;
      expect(rightAll).assertTrue();

      let encodeDataSyn: cryptoFramework.DataBlob | null = aesTool.encryptSync(resultDataBlob);
      expect(encodeDataSyn).assertInstanceOf('Object');

      let decryptDataSyn: cryptoFramework.DataBlob | null = aesTool.decryptSync(encodeData);
      expect(decryptDataSyn).assertInstanceOf('Object');

      let decrypDataSynStr: string = '';
      if (decryptDataSyn) {
        decryptData?.data.forEach((item) => {
          decrypDataSynStr += String.fromCharCode(item);
        });
      }
      expect(decrypDataSynStr.length).assertLarger(0);

      let rightSynAll: boolean = decrypDataSynStr == resultStr;
      expect(rightSynAll).assertTrue();
    })

  })

}