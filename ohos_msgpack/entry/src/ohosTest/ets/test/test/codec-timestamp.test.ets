/**
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 *
 * Permission to use, copy, modify, and/or distribute this software for any purpose
 * with or without fee is hereby granted, provided that the above copyright notice
 * and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL
 * WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL
 * THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR
 * CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING
 * FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF
 * CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */
import assert from "./assert2hypium";
import { encode, decode, decodeTimestampExtension} from "@ohos/msgpack";
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { timestampSPECS } from './stdlib/StdlibData';

export default function CodecTimestampTest() {
  describe('CodecTimestampTest', () => {
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

    assert.context("encode_decode", () => {
      for (const name of Object.keys(timestampSPECS)) {
        const value = timestampSPECS[name]!;

        it(`encodes_and_decodes_${name}_${value.toISOString()}_`, 0, () => {
          let startTime1 = new Date().getTime();
          const encoded = encode<undefined>(value);
          assert.deepStrictEqual(decode<undefined>(encoded), value);
          let endTime1 = new Date().getTime();
          let averageTime1 = ((endTime1 - startTime1) * 1000) / 2;
          console.log(`msgpack-javascript:encodes_and_decodes_${name}_${value.toISOString()}_ averageTime = ${averageTime1}`)
        });
      }
    });

    assert.context("decodeTimestampExtension_for_broken_data", () => {
      it("throws_errors", 0,() => {
        assert.throws(() => {
          let startTime1 = new Date().getTime();
          decodeTimestampExtension(Uint8Array.from([0]));
          let endTime1 = new Date().getTime();
          let averageTime1 = ((endTime1 - startTime1) * 1000) / 1;
          console.log(`msgpack-javascript:decodeTimestampExtension_for_broken_data averageTime = ${averageTime1}`)
        }, new RegExp("/unrecognized data size for timestamp/i"));
      });
    });



  })
}


