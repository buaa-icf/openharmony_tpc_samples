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
import {  encode, decode, ExtData } from "@msgpack/msgpack";
import hilog from '@ohos.hilog';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'

export default function msgpackExtTest() {
  describe('msgpackExtTest', function () {
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

    function seq(n: number) {
      const a: Array<number> = [];
      for (let i = 0; i < n; i++) {
        a.push((i + 1) % 0xff);
      }
      return Uint8Array.from(a);
    }

    const SPECS = {
      FIXEXT1: [0xd4, new ExtData(0, seq(1))],
      FIXEXT2: [0xd5, new ExtData(0, seq(2))],
      FIXEXT4: [0xd6, new ExtData(0, seq(4))],
      FIXEXT8: [0xd7, new ExtData(0, seq(8))],
      FIXEXT16: [0xd8, new ExtData(0, seq(16))],
      EXT8: [0xc7, new ExtData(0, seq(17))],
      EXT16: [0xc8, new ExtData(0, seq(0x100))],
      EXT32: [0xc9, new ExtData(0, seq(0x10000))],
    } as Record<string, [number, ExtData]>;

    for (const name of Object.keys(SPECS)) {
      const [msgpackType, extData] = SPECS[name]!;

      it(`preserves_ExtData_by_decode_encode_${name}__`,0, () => {
        let startTime1 = new Date().getTime();
        const encoded = encode(extData);
        let decoded = decode(encoded)
        let endTime1 = new Date().getTime();
        let averageTime1 = ((endTime1 - startTime1) * 1000) / 2;
        console.log(`msgpack-javascript:preserves_ExtData_by_decode_encode_${name}__ averageTime = ${averageTime1}`)

        assert.strictEqual(encoded[0], msgpackType);
        assert.deepStrictEqual(decoded, extData);

      });
    }
  })
}






