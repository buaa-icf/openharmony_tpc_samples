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
import { encode, decode, decodeAsync } from "@msgpack/msgpack";
import type { DecodeOptions } from "@msgpack/msgpack/dist/decode";

import hilog from '@ohos.hilog';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'


export default function DecodeMaxLengthTest() {
  describe('DecodeMaxLengthTest', function () {
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

    assert.context("maxStrLength", () => {

      let startTime1 = new Date().getTime();

      const input = encode("foo");
      const options: DecodeOptions = { maxStrLength: 1 };

      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / 1;
      console.log(`msgpack-javascript:maxStrLength averageTime = ${averageTime1}`)

      it("throws_errors_synchronous_",0, () => {
        assert.throws(() => {
          decode(input, options);
        }, /max length exceeded/i);
      });


    });

    assert.context("maxBinLength", () => {
      let startTime1 = new Date().getTime();

      const input = encode(Uint8Array.from([1, 2, 3]));
      const options: DecodeOptions = { maxBinLength: 1 };

      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / 1;
      console.log(`msgpack-javascript:maxBinLength averageTime = ${averageTime1}`)

      it("throws_errors_synchronous",0, () => {
        assert.throws(() => {
          decode(input, options);
        }, /max length exceeded/i);
      });


    });

    assert.context("maxArrayLength", () => {
      let startTime1 = new Date().getTime();

      const input = encode([1, 2, 3]);
      const options: DecodeOptions = { maxArrayLength: 1 };

      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / 1;
      console.log(`msgpack-javascript:maxArrayLength averageTime = ${averageTime1}`)

      it("throws_errors_synchronous_",0, () => {
        assert.throws(() => {
          decode(input, options);
        }, /max length exceeded/i);
      });


    });

    assert.context("maxMapLength", () => {
      let startTime1 = new Date().getTime();

      const input = encode({ foo: 1, bar: 1, baz: 3 });
      const options: DecodeOptions = { maxMapLength: 1 };

      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / 1;
      console.log(`msgpack-javascript:maxMapLength averageTime = ${averageTime1}`)

      it("throws_errors_synchronous",0, () => {
        assert.throws(() => {
          decode(input, options);
        }, /max length exceeded/i);
      });


    });

    assert.context("maxExtType", () => {
      let startTime1 = new Date().getTime();

      const input = encode(new Date());
      // timextamp ext requires at least 4 bytes.
      const options: DecodeOptions = { maxExtLength: 1 };

      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / 1;
      console.log(`msgpack-javascript:maxExtType averageTime = ${averageTime1}`)

      it("throws_errors_synchronous",0, () => {
        assert.throws(() => {
          decode(input, options);
        }, /max length exceeded/i);
      });


    });

  })
}




