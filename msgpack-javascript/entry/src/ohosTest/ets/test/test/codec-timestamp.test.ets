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
import assert from "./assert2hypium";
import buffer from '@ohos.buffer';
import {
  encode,
  decode,
  encodeDateToTimeSpec,
  decodeTimestampExtension,
  decodeTimestampToTimeSpec,
  encodeTimestampExtension,
} from "@msgpack/msgpack";

const TIME = 1556636810389;

const SPECS = {
  ZERO: new Date(0),
  TIME_BEFORE_EPOCH_NS: new Date(-1),
  TIME_BEFORE_EPOCH_SEC: new Date(-1000),
  TIME_BEFORE_EPOCH_SEC_AND_NS: new Date(-1002),
  TIMESTAMP32: new Date(Math.floor(TIME / 1000) * 1000),
  TIMESTAMP64: new Date(TIME),
  TIMESTAMP64_OVER_INT32: new Date(Date.UTC(2200, 0)), // cf. https://github.com/msgpack/msgpack-ruby/pull/172
  TIMESTAMP96_SEC_OVER_UINT32: new Date(0x400000000 * 1000),
  TIMESTAMP96_SEC_OVER_UINT32_WITH_NS: new Date(0x400000000 * 1000 + 2),

  REGRESSION_1: new Date(1556799054803),
} as Record<string, Date>;

import hilog from '@ohos.hilog';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'


export default function CodecTimestampTest() {
  describe('CodecTimestampTest', function () {
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

    assert.context("encode_decode", () => {
      for (const name of Object.keys(SPECS)) {
        const value = SPECS[name]!;

        it(`encodes_and_decodes_${name}_${value.toISOString()}_`, 0, () => {
          let startTime1 = new Date().getTime();
          const encoded = encode(value);
          assert.deepStrictEqual(decode(encoded), value, `encoded: ${(buffer.from(encoded)).toString('utf-8')}`);
          let endTime1 = new Date().getTime();
          let averageTime1 = ((endTime1 - startTime1) * 1000) / 2;
          console.log(`msgpack-javascript:encodes_and_decodes_${name}_${value.toISOString()}_ averageTime = ${averageTime1}`)
        });
      }
    });

    assert.context("encodeDateToTimeSpec", () => {
      it("normalizes_new_Date_fu1_to_sec_fu1_nsec_999000000", 0 , () => {
        let startTime1 = new Date().getTime();
        assert.deepStrictEqual(encodeDateToTimeSpec(new Date(-1)), { sec: -1, nsec: 999000000 });
        let endTime1 = new Date().getTime();
        let averageTime1 = ((endTime1 - startTime1) * 1000) / 1;
        console.log(`msgpack-javascript:normalizes_new_Date_fu1_to_sec_fu1_nsec_999000000 averageTime = ${averageTime1}`)
      });
    });

    assert.context("encodeDateToTimeSpec", () => {
      it("decodes_timestamp_ext_binary_to_TimeSpec", 0 , () => {
        let startTime1 = new Date().getTime();
        const encoded = encodeTimestampExtension(new Date(42000))!;
        assert.deepStrictEqual(decodeTimestampToTimeSpec(encoded), { sec: 42, nsec: 0 });
        let endTime1 = new Date().getTime();
        let averageTime1 = ((endTime1 - startTime1) * 1000) / 2;
        console.log(`msgpack-javascript:decodes_timestamp_ext_binary_to_TimeSpec averageTime = ${averageTime1}`)
      });
    });


    assert.context("decodeTimestampExtension_for_broken_data", () => {
      it("throws_errors", 0,() => {
        assert.throws(() => {
          let startTime1 = new Date().getTime();
          decodeTimestampExtension(Uint8Array.from([0]));
          let endTime1 = new Date().getTime();
          let averageTime1 = ((endTime1 - startTime1) * 1000) / 1;
          console.log(`msgpack-javascript:decodeTimestampExtension_for_broken_data averageTime = ${averageTime1}`)
        }, /unrecognized data size for timestamp/i);
      });
    });



  })
}


