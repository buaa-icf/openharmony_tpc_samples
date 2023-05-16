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
import { encode, decode, ExtensionCodec, decodeAsync } from "@msgpack/msgpack";
import hilog from '@ohos.hilog';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'

export default function ExtensionCodecTest() {
  describe('ExtensionCodecTest', function () {
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

    assert.context("timestamp", () => {
      const extensionCodec = ExtensionCodec.defaultCodec;

      it("encodes_and_decodes_a_date_without_milliseconds_timestamp_32",0, () => {
        let startTime1 = new Date().getTime();
        const date = new Date(1556633024000);
        const encoded = encode(date, { extensionCodec });
        assert.deepStrictEqual(
          decode(encoded, { extensionCodec }),
          date,
          `date: ${date.toISOString()}, encoded: ${encoded}`,
        );
        let endTime1 = new Date().getTime();
        let averageTime1 = ((endTime1 - startTime1) * 1000) / 2;
        console.log(`msgpack-javascript:encodes_and_decodes_a_date_without_milliseconds_timestamp_32 averageTime = ${averageTime1}`)
      });

      it("encodes_and_decodes_a_date_with_milliseconds_timestamp_64",0, () => {
        let startTime1 = new Date().getTime();
        const date = new Date(1556633024123);
        const encoded = encode(date, { extensionCodec });
        assert.deepStrictEqual(
          decode(encoded, { extensionCodec }),
          date,
          `date: ${date.toISOString()}, encoded: ${encoded}`,
        );
        let endTime1 = new Date().getTime();
        let averageTime1 = ((endTime1 - startTime1) * 1000) / 2;
        console.log(`msgpack-javascript:encodes_and_decodes_a_date_with_milliseconds_timestamp_64 averageTime = ${averageTime1}`)
      });

      it("encodes_and_decodes_a_future_date_timestamp_96_",0, () => {
        let startTime1 = new Date().getTime();
        const date = new Date(0x400000000 * 1000);
        const encoded = encode(date, { extensionCodec });
        assert.deepStrictEqual(
          decode(encoded, { extensionCodec }),
          date,
          `date: ${date.toISOString()}, encoded: ${encoded}`,
        );
        let endTime1 = new Date().getTime();
        let averageTime1 = ((endTime1 - startTime1) * 1000) / 2;
        console.log(`msgpack-javascript:encodes_and_decodes_a_future_date_timestamp_96_ averageTime = ${averageTime1}`)
      });
    });

    assert.context("custom extensions", () => {
      const extensionCodec = new ExtensionCodec();

      // Set<T>
      extensionCodec.register({
        type: 0,
        encode: (object: unknown): Uint8Array | null => {
          if (object instanceof Set) {
            return encode([...object]);
          } else {
            return null;
          }
        },
        decode: (data: Uint8Array) => {
          const array = decode(data) as Array<unknown>;
          return new Set(array);
        },
      });

      // Map<T>
      extensionCodec.register({
        type: 1,
        encode: (object: unknown): Uint8Array | null => {
          if (object instanceof Map) {
            return encode([...object]);
          } else {
            return null;
          }
        },
        decode: (data: Uint8Array) => {
          const array = decode(data) as Array<[unknown, unknown]>;
          return new Map(array);
        },
      });

      it("encodes_and_decodes_custom_data_types_synchronously",0, () => {
        let startTime1 = new Date().getTime();
        const set = new Set([1, 2, 3]);
        const map = new Map([
          ["foo", "bar"],
          ["bar", "baz"],
        ]);
        const encoded = encode([set, map], { extensionCodec });
        assert.deepStrictEqual(decode(encoded, { extensionCodec }), [set, map]);
        let endTime1 = new Date().getTime();
        let averageTime1 = ((endTime1 - startTime1) * 1000) / 2;
        console.log(`msgpack-javascript:encodes_and_decodes_custom_data_types_synchronously averageTime = ${averageTime1}`)
      });

      it("encodes_and_decodes_custom_data_types_asynchronously_",0, async () => {
        let startTime1 = new Date().getTime();
        const set = new Set([1, 2, 3]);
        const map = new Map([
          ["foo", "bar"],
          ["bar", "baz"],
        ]);
        const encoded = encode([set, map], { extensionCodec });
        const createStream = async function* () {
          yield encoded;
        };
        assert.deepStrictEqual(await decodeAsync(createStream(), { extensionCodec }), [set, map]);
        let endTime1 = new Date().getTime();
        let averageTime1 = ((endTime1 - startTime1) * 1000) / 2;
        console.log(`msgpack-javascript:encodes_and_decodes_custom_data_types_asynchronously_ averageTime = ${averageTime1}`)
      });
    });

    assert.context("custom_extensions_with_custom_context", () => {
      class Context {
        public expectations: Array<any> = [];
        constructor(public ctxVal: number) {}
        public hasVisited(val: any) {
          this.expectations.push(val);
        }
      }
      const extensionCodec = new ExtensionCodec<Context>();

      class Magic<T> {
        constructor(public val: T) {}
      }

      // Magic
      extensionCodec.register({
        type: 0,
        encode: (object: unknown, context): Uint8Array | null => {
          if (object instanceof Magic) {
            context.hasVisited({ encoding: object.val });
            return encode({ magic: object.val, ctx: context.ctxVal }, { extensionCodec, context });
          } else {
            return null;
          }
        },
        decode: (data: Uint8Array, extType, context) => {
          extType;
          const decoded = decode(data, { extensionCodec, context }) as { magic: number };
          context.hasVisited({ decoding: decoded.magic, ctx: context.ctxVal });
          return new Magic(decoded.magic);
        },
      });

      it("encodes_and_decodes_custom_data_types_synchronously",0, () => {
        const context = new Context(42);
        const magic1 = new Magic(17);
        const magic2 = new Magic({ foo: new Magic("inner") });
        const test = [magic1, magic2];

        let startTime1 = new Date().getTime();
        const encoded = encode(test, { extensionCodec, context });
        let decoded = decode(encoded, { extensionCodec, context });
        let endTime1 = new Date().getTime();
        let averageTime1 = ((endTime1 - startTime1) * 1000) / 2;
        console.log(`msgpack-javascript:encodes_and_decodes_custom_data_types_synchronously averageTime = ${averageTime1}`)

        assert.deepStrictEqual(decoded, test);
        assert.deepStrictEqual(context.expectations, [
          {
            encoding: magic1.val,
          },
          {
            encoding: magic2.val,
          },
          {
            encoding: magic2.val.foo.val,
          },
          {
            ctx: 42,
            decoding: magic1.val,
          },
          {
            ctx: 42,
            decoding: magic2.val.foo.val,
          },
          {
            ctx: 42,
            decoding: magic2.val,
          },
        ]);

      });

      it("encodes_and_decodes_custom_data_types_asynchronously_",0, async () => {

        const context = new Context(42);
        const magic1 = new Magic(17);
        const magic2 = new Magic({ foo: new Magic("inner") });
        const test = [magic1, magic2];

        let startTime1 = new Date().getTime();
        const encoded = encode(test, { extensionCodec, context });
        const createStream = async function* () {
          yield encoded;
        };
        let decoded = await decodeAsync(createStream(), { extensionCodec, context });
        let endTime1 = new Date().getTime();
        let averageTime1 = ((endTime1 - startTime1) * 1000) / 2;
        console.log(`msgpack-javascript:encodes_and_decodes_custom_data_types_asynchronously_ averageTime = ${averageTime1}`)


        assert.deepStrictEqual(decoded, test);
        assert.deepStrictEqual(context.expectations, [
          {
            encoding: magic1.val,
          },
          {
            encoding: magic2.val,
          },
          {
            encoding: magic2.val.foo.val,
          },
          {
            ctx: 42,
            decoding: magic1.val,
          },
          {
            ctx: 42,
            decoding: magic2.val.foo.val,
          },
          {
            ctx: 42,
            decoding: magic2.val,
          },
        ]);

      });
    });

  })
}




