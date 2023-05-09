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
import { Exam } from "./msgpacksuit/exam";
import { MsgTimestamp } from "./msg/msg-timestamp";

import ohBuffer from '@ohos.buffer';

import assert from "./assert2hypium";
import { encode, decode, ExtensionCodec, EXT_TIMESTAMP, encodeTimeSpecToTimestamp } from "@msgpack/msgpack";
import hilog from '@ohos.hilog';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'


export default function nmsgpackTestSuiteTest() {
  describe('msgpackTestSuiteTest', function () {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(function () {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(function () {
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

    assert.context("specs not covered by msgpack-test-js", () => {
      // by detecting test coverage
      const SPECS = {
        FLOAT64_POSITIVE_INF: Number.POSITIVE_INFINITY,
        FLOAT64_NEGATIVE_INF: Number.NEGATIVE_INFINITY,
        FLOAT64_NAN: Number.NaN,
        STR16: "a".repeat(0x100),
        STR16_MBS: "🌏".repeat(0x100),
        STR32: "b".repeat(0x10_000),
        STR32_MBS: "🍣".repeat(0x10_000),
        STR32LARGE: "c".repeat(0x50_000), // may cause "RangeError: Maximum call stack size exceeded" in simple implelementions
        STR_INCLUDING_NUL: "foo\0bar\0",
        STR_BROKEN_FF: "\xff",
        BIN16: new Uint8Array(0x100).fill(0xff),
        BIN32: new Uint8Array(0x10_000).fill(0xff),
        BIN32LARGE: new Uint8Array(0x50_000).fill(0xff), // regression: caused "RangeError: Maximum call stack size exceeded"
        ARRAY16: new Array<boolean>(0x100).fill(true),
        ARRAY32: new Array<boolean>(0x10000).fill(true),
        MAP16: new Array<null>(0x100).fill(null).reduce<Record<string, number>>((acc, _val, i) => {
          acc[`k${i}`] = i;
          return acc;
        }, {}),
        MAP32: new Array<null>(0x10000).fill(null).reduce<Record<string, number>>((acc, _val, i) => {
          acc[`k${i}`] = i;
          return acc;
        }, {}),
        MIXED: new Array(0x10).fill(Number.MAX_SAFE_INTEGER),
      } as Record<string, any>;

      for (const name of Object.keys(SPECS)) {
        const value = SPECS[name];

        it(`encodes_and_decodes_${name}`,0, () => {
          let startTime1 = new Date().getTime();
          let encoded;
          let decoded;
          try{
           encoded = encode(value);
           decoded =  decode(new Uint8Array(encoded))
          }catch (err){

          } finally {
            let endTime1 = new Date().getTime();
            let averageTime1 = ((endTime1 - startTime1) * 1000) / 2;
            console.log(`msgpack-javascript:encodes_and_decodes_${name} averageTime = ${averageTime1}`)
          }
            assert.deepStrictEqual(decoded, value);
        });
      }
    });

    it("int_8", 0,() => {
      let startTime1 = new Date().getTime();
      assert.deepStrictEqual(encode(-128), Uint8Array.from([0xd0, 0x80]));
      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / 1;
      console.log(`msgpack-javascript:int_8 averageTime = ${averageTime1}`)
    });
  })
}








