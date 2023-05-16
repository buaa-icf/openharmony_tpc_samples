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
import { encode, decodeAsync } from "@msgpack/msgpack";
import hilog from '@ohos.hilog';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
type BufferSource = ArrayBufferView | ArrayBuffer;

export default function DecodeAsyncTest() {
  describe('DecodeAsyncTest', function () {
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
    function wrapWithNoisyBuffer(byte: number) {
      return Uint8Array.from([0x01, byte, 0x02]).subarray(1, 2);
    }

    it("decodes_nil",0, async () => {
      const createStream = async function* () {
        yield wrapWithNoisyBuffer(0xc0); // nil
      };

      let startTime1 = new Date().getTime();

      const object = await decodeAsync(createStream());

      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / 1;
      console.log(`msgpack-javascript:decodes_nil averageTime = ${averageTime1}`)

      assert.deepStrictEqual(object, null);
    });

    it("decodes_fixarray_nil",0, async () => {
      const createStream = async function* () {
        yield wrapWithNoisyBuffer(0x91); // fixarray size=1
        yield [0xc0]; // nil
      };

      let startTime1 = new Date().getTime();

      const object = await decodeAsync(createStream());

      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / 1;
      console.log(`msgpack-javascript:decodes_fixarray_nil averageTime = ${averageTime1}`)

      assert.deepStrictEqual(object, [null]);
    });

    it("decodes_fixmap_foo_bar_",0, async () => {
      const createStream = async function* () {
        yield [0x81]; // fixmap size=1
        yield encode("foo");
        yield encode("bar");
      };

      let startTime1 = new Date().getTime();

      const object = await decodeAsync(createStream());

      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / 1;
      console.log(`msgpack-javascript:decodes_fixmap_foo_bar_ averageTime = ${averageTime1}`)

      assert.deepStrictEqual(object, { "foo": "bar" });
    });

    it("decodes_multi_byte_integer_byte_by_byte",0, async () => {
      const createStream = async function* () {
        yield [0xcd]; // uint 16
        yield [0x12];
        yield [0x34];
      };

      let startTime1 = new Date().getTime();

      const object = await decodeAsync(createStream());

      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / 1;
      console.log(`msgpack-javascript:decodes_multi_byte_integer_byte_by_byte averageTime = ${averageTime1}`)


      assert.deepStrictEqual(object, 0x1234);
    });

    it("decodes_fixstr_byte_by_byte",0, async () => {
      const createStream = async function* () {
        yield [0xa3]; // fixstr size=3
        yield [0x66]; // "f"
        yield [0x6f]; // "o"
        yield [0x6f]; // "o"
      };

      let startTime1 = new Date().getTime();

      const object = await decodeAsync(createStream());

      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / 1;
      console.log(`msgpack-javascript:decodes_fixstr_byte_by_byte averageTime = ${averageTime1}`)

      assert.deepStrictEqual(object, "foo");
    });

    it("decodes_binary_byte_by_byte",0, async () => {
      const createStream = async function* () {
        yield [0xc4]; // bin 8
        yield [0x03]; // bin size=3
        yield [0x66]; // "f"
        yield [0x6f]; // "o"
        yield [0x6f]; // "o"
      };

      let startTime1 = new Date().getTime();

      const object = await decodeAsync(createStream());

      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / 1;
      console.log(`msgpack-javascript:decodes_binary_byte_by_byte averageTime = ${averageTime1}`)

      assert.deepStrictEqual(object, Uint8Array.from([0x66, 0x6f, 0x6f]));
    });

    it("decodes_binary_with_noisy_buffer",0, async () => {
      const createStream = async function* () {
        yield wrapWithNoisyBuffer(0xc5); // bin 16
        yield [0x00];
        yield [0x00]; // bin size=0
      };

      let startTime1 = new Date().getTime();

      const object = await decodeAsync(createStream());

      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / 1;
      console.log(`msgpack-javascript:decodes_binary_with_noisy_buffer averageTime = ${averageTime1}`)

      assert.deepStrictEqual(object, new Uint8Array(0));
    });

    it("decodes_mixed_object_byte_by_byte",0, async () => {
      const object = {
        nil: null,
        true: true,
        false: false,
        int: -42,
        uint64: Number.MAX_SAFE_INTEGER,
        int64: Number.MIN_SAFE_INTEGER,
        float: Math.PI,
        string: "Hello, world!",
        longString: "Hello, world!\n".repeat(100),
        binary: Uint8Array.from([0xf1, 0xf2, 0xf3]),
        array: [1000, 2000, 3000],
        map: { foo: 1, bar: 2, baz: 3 },
        timestampExt: new Date(),
        map0: {},
        array0: [],
        str0: "",
        bin0: Uint8Array.from([]),
      };

      const createStream = async function* () {
        for (const byte of encode(object)) {
          yield [byte];
        }
      };
      let stream = createStream();
      let startTime1 = new Date().getTime();
      let result = await decodeAsync(stream)

      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / 1;
      console.log(`msgpack-javascript:decodes_mixed_object_byte_by_byte averageTime = ${averageTime1}`)
      assert.deepStrictEqual(result, object);
    });

    it("decodes_BufferSource",0, async () => {
      // https://developer.mozilla.org/en-US/docs/Web/API/BufferSource
      const createStream = async function* () {
        yield [0x81] as ArrayLike<number>; // fixmap size=1
        yield encode("foo") as BufferSource;
        yield encode("bar") as BufferSource;
      };

      let startTime1 = new Date().getTime();
      // createStream() returns AsyncGenerator<ArrayLike<number> | BufferSource, ...>
      const object = await decodeAsync(createStream());

      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / 1;
      console.log(`msgpack-javascript:decodes_BufferSource averageTime = ${averageTime1}`)

      assert.deepStrictEqual(object, { "foo": "bar" });
    });

  })
}




