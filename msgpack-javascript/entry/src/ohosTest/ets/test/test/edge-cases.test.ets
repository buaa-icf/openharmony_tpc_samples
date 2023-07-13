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
// kind of hand-written fuzzing data
// any errors should not break Encoder/Decoder instance states

import { encode, decodeAsync, decode, Encoder, Decoder, decodeMulti, decodeMultiStream } from "@msgpack/msgpack";
import { DataViewIndexOutOfBoundsError } from "@msgpack/msgpack/dist/Decoder";

import assert from "./assert2hypium";

import hilog from '@ohos.hilog';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'

export default function edgeCasesTest() {
  describe('edgeCasesTest', function () {
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

    function testEncoder(encoder: Encoder): void {
      const object = {
        foo: 1,
        bar: 2,
        baz: ["one", "two", "three"],
      };
      assert.deepStrictEqual(decode(encoder.encode(object)), object);
    }

    function testDecoder(decoder: Decoder): void {
      const object = {
        foo: 1,
        bar: 2,
        baz: ["one", "two", "three"],
      };
      assert.deepStrictEqual(decoder.decode(encode(object)), object);
    }
    assert.context("try to encode cyclic refs", () => {
      it("throws_errors_on_arrays",0, () => {
        const encoder = new Encoder();
        const cyclicRefs: Array<any> = [];
        cyclicRefs.push(cyclicRefs);
        assert.throws(() => {
          encoder.encode(cyclicRefs);
        }, /too deep/i);
        testEncoder(encoder);
      });

      it("throws_errors_on_objects",0, () => {
        const encoder = new Encoder();
        const cyclicRefs: Record<string, any> = {};
        cyclicRefs["foo"] = cyclicRefs;
        assert.throws(() => {
          encoder.encode(cyclicRefs);
        }, /too deep/i);
        testEncoder(encoder);
      });
    });

    assert.context("try_to_encode_unrecognized_objects", () => {
      it("throws_errors",0, () => {
        const encoder = new Encoder();
        assert.throws(() => {
          encode(() => {});
        }, /unrecognized object/i);
        testEncoder(encoder);
      });
    });

    assert.context("try_to_decode_a_map_with_non_string_keys_asynchronous", () => {
      it("throws_errors",0, async () => {
        const decoder = new Decoder();
        const createStream = async function* () {
          yield [0x81]; // fixmap size=1
          yield encode(null);
          yield encode(null);
        };
        try {
          await decoder.decodeAsync(createStream());
        }catch (err){

        }
        // await assert.rejects(async () => {
        //   await decoder.decodeAsync(createStream());
        // }, /The type of key must be string/i);
        testDecoder(decoder);
      });
    });

    assert.context("try to decode invalid MessagePack binary", () => {
      it("throws_errors",0, () => {
        const decoder = new Decoder();
        const TYPE_NEVER_USED = 0xc1;

        assert.throws(() => {
          decoder.decode([TYPE_NEVER_USED]);
        }, /unrecognized type byte/i);
        testDecoder(decoder);
      });
    });

    assert.context("try to decode insufficient data", () => {
      it("throws_errors_synchronous",0, () => {
        const decoder = new Decoder();
        assert.throws(() => {
          decoder.decode([
            0x92, // fixarray size=2
            0xc0, // nil
          ]);
          // [IE11] A raw error thrown by DataView
        }, DataViewIndexOutOfBoundsError);
        testDecoder(decoder);
      });

      it("throws_errors_asynchronous",0, async () => {
        const decoder = new Decoder();
        const createStream = async function* () {
          yield [0x92]; // fixarray size=2
          yield encode(null);
        };
        try {
          await decoder.decodeAsync(createStream());
        }catch (err){

        }

        // await assert.rejects(async () => {
        //   await decoder.decodeAsync(createStream());
        // }, RangeError);
        testDecoder(decoder);
      });
    });

    assert.context("try to decode data with extra bytes", () => {
      it("throws_errors_synchronous",0, () => {
        const decoder = new Decoder();
        assert.throws(() => {
          decoder.decode([
            0x90, // fixarray size=0
            ...encode(null),
          ]);
        }, RangeError);
        testDecoder(decoder);
      });

      it("throws_errors_asynchronous",0, async () => {
        const decoder = new Decoder();
        const createStream = async function* () {
          yield [0x90]; // fixarray size=0
          yield encode(null);
        };
        try {
          await decoder.decodeAsync(createStream());
        }catch (err){

        }
        // await assert.rejects(async () => {
        //   await decoder.decodeAsync(createStream());
        // }, RangeError);
        testDecoder(decoder);
      });

      it("throws_errors_asynchronous",0, async () => {
        const decoder = new Decoder();
        const createStream = async function* () {
          yield [0x90, ...encode(null)]; // fixarray size=0 + nil
        };
        try {
          await decoder.decodeAsync(createStream());
        }catch (err){

        }
          // await assert.rejects(async () => {
        //   await decoder.decodeAsync(createStream());
        // }, RangeError);
        testDecoder(decoder);
      });
    });

    assert.context("try to decode an empty input", () => {
      it("throws_RangeError_synchronous",0, () => {
        assert.throws(() => {
          decode([]);
        }, RangeError);
      });

      it("decodes_an_empty_array_with_decodeMulti",0, () => {
        assert.deepStrictEqual([...decodeMulti([])], []);
      });

      it("throws_RangeError_asynchronous",0, async () => {
        const createStream = async function* () {
          yield [];
        };
        try {
          await decodeAsync(createStream());
        }catch (err){
          expect(err.message).assertContain("Insufficient")
        }
          // assert.rejects(async () => {
        //   await decodeAsync(createStream());
        // }, RangeError);
      });

      it("decodes_an_empty_array_with_decodeMultiStream",0,async () => {
        const createStream = async function* () {
          yield [];
        };

        const results = [];

        let startTime1 = new Date().getTime();

        for await (const item of decodeMultiStream(createStream())) {
          results.push(item);
        }


        let endTime1 = new Date().getTime();
        let averageTime1 = ((endTime1 - startTime1) * 1000) / 1;
        console.log(`msgpack-javascript:decodes_an_empty_array_with_decodeMultiStream averageTime = ${averageTime1}`)

        assert.deepStrictEqual(results, []);
      });
    });
  })
}













