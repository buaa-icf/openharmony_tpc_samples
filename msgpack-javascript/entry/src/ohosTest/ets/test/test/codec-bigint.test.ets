/*
 * Copyright (C) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import hilog from '@ohos.hilog';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import assert from "./assert2hypium";
import { encode, decode, ExtensionCodec, DecodeError } from "@msgpack/msgpack";

// 测试用例通过 测试框架不支持 expect cannot serialize a BigInt
export default function CodecBigintTest() {
  describe('CodecBigintTest', function () {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(function () {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })

    beforeEach(function () {
      // if (typeof BigInt === "undefined") {
      //   this.skip();
      // }
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(function () {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(function () {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    it("encodes_and_decodes_0n", 0 ,() => {

      let startTime1 = new Date().getTime();

      const extensionCodec = new ExtensionCodec();
      extensionCodec.register({
        type: 0,
        encode: (input: unknown) => {
          if (typeof input === "bigint") {
            if (input <= Number.MAX_SAFE_INTEGER && input >= Number.MIN_SAFE_INTEGER) {
              return encode(parseInt(input.toString(), 10));
            } else {
              return encode(input.toString());
            }
          } else {
            return null;
          }
        },
        decode: (data: Uint8Array) => {
          const val = decode(data);
          if (!(typeof val === "string" || typeof val === "number")) {
            throw new DecodeError(`unexpected BigInt source: ${val} (${typeof val})`);
          }
          return BigInt(val);
        },
      });
      const value = BigInt(0);
      const encoded = encode(value, { extensionCodec });
      const decoded =  decode(encoded, { extensionCodec })

      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / 4;
      console.log('msgpack-javascript:encodes_and_decodes_0n averageTime ='+averageTime1)
      // 测试框架无法覆盖BitInt(0)的情况
      // assert.deepStrictEqual(decoded, value);
      assert.strictEqual(decoded, value);
    });

    it("encodes_and_decodes_MAX_SAFE_INTEGER_1",0, () => {
      const extensionCodec = new ExtensionCodec();
      extensionCodec.register({
        type: 0,
        encode: (input: unknown) => {
          if (typeof input === "bigint") {
            if (input <= Number.MAX_SAFE_INTEGER && input >= Number.MIN_SAFE_INTEGER) {
              return encode(parseInt(input.toString(), 10));
            } else {
              return encode(input.toString());
            }
          } else {
            return null;
          }
        },
        decode: (data: Uint8Array) => {
          const val = decode(data);
          if (!(typeof val === "string" || typeof val === "number")) {
            throw new DecodeError(`unexpected BigInt source: ${val} (${typeof val})`);
          }
          return BigInt(val);
        },
      });
      const value = BigInt(Number.MAX_SAFE_INTEGER) + BigInt(1);

      let startTime1 = new Date().getTime();

      const encoded = encode(value, { extensionCodec });
      const decoded = decode(encoded, { extensionCodec });

      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / 2;
      console.log('msgpack-javascript:encodes_and_decodes_MAX_SAFE_INTEGER_1 averageTime ='+averageTime1)
      // assert.deepStrictEqual(decoded, value);
      assert.strictEqual(decoded, value);
    });

    it("encodes_and_decodes_MIN_SAFE_INTEGER_minus1",0, () => {
      const extensionCodec = new ExtensionCodec();
      extensionCodec.register({
        type: 0,
        encode: (input: unknown) => {
          if (typeof input === "bigint") {
            if (input <= Number.MAX_SAFE_INTEGER && input >= Number.MIN_SAFE_INTEGER) {
              return encode(parseInt(input.toString(), 10));
            } else {
              return encode(input.toString());
            }
          } else {
            return null;
          }
        },
        decode: (data: Uint8Array) => {
          const val = decode(data);
          if (!(typeof val === "string" || typeof val === "number")) {
            throw new DecodeError(`unexpected BigInt source: ${val} (${typeof val})`);
          }
          return BigInt(val);
        },
      });
      const value = BigInt(Number.MIN_SAFE_INTEGER) - BigInt(1);

      let startTime1 = new Date().getTime();

      const encoded = encode(value, { extensionCodec });
      const decoded = decode(encoded, { extensionCodec });

      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / 2;
      console.log('msgpack-javascript:encodes_and_decodes_MIN_SAFE_INTEGER_minus1 averageTime ='+averageTime1)
      // assert.deepStrictEqual(decoded, value);
      assert.strictEqual(decoded, value);
    });

  })
}








