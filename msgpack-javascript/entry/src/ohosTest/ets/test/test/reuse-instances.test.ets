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
import { Encoder, Decoder, decode } from "@msgpack/msgpack";
import hilog from '@ohos.hilog';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'

export default function reuseInstancesTest() {
  describe('reuseInstancesTest', function () {
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
    const createStream = async function* (...args: any) {
      for (const item of args) {
        yield item;
      }
    };

    const N = 10;
    assert.context("encode() and decodeSync()", () => {
      it("runs_multiple_times", 0,() => {

        const encoder = new Encoder();
        const decoder = new Decoder();

        const object = {
          nil: null,
          integer: 1,
          float: Math.PI,
          string: "Hello, world!",
          binary: Uint8Array.from([1, 2, 3]),
          array: [10, 20, 30],
          map: { foo: "bar" },
          timestampExt: new Date(),
        };

        for (let i = 0; i < N; i++) {
          let startTime1 = new Date().getTime();
          const encoded: Uint8Array = encoder.encode(object);
          let decoded = decoder.decode(encoded)
          let endTime1 = new Date().getTime();
          let averageTime1 = ((endTime1 - startTime1) * 1000) / 2;
          console.log(`msgpack-javascript:runs_multiple_times#${i} averageTime = ${averageTime1}`)
          assert.deepStrictEqual(decoded, object, `#${i}`);

        }
      });
    });

    assert.context("encode() and decodeAsync()", () => {
      it("runs_multiple_times",0, async () => {
        const encoder = new Encoder();
        const decoder = new Decoder();

        const object = {
          nil: null,
          integer: 1,
          float: Math.PI,
          string: "Hello, world!",
          binary: Uint8Array.from([1, 2, 3]),
          array: [10, 20, 30],
          map: { foo: "bar" },
          timestampExt: new Date(),
        };

        for (let i = 0; i < N; i++) {
          let startTime1 = new Date().getTime();
          const encoded: Uint8Array = encoder.encode(object);
          let decoded = await decoder.decodeAsync(createStream(encoded));
          let endTime1 = new Date().getTime();
          let averageTime1 = ((endTime1 - startTime1) * 1000) / 2;
          console.log(`msgpack-javascript:runs_multiple_times#${i} averageTime = ${averageTime1}`)
          assert.deepStrictEqual(decoded, object, `#${i}`);

        }
      });
    });

    assert.context("encode() and decodeStream()", () => {
      it("runs_multiple_times",0, async () => {
        const encoder = new Encoder();
        const decoder = new Decoder();

        const object = {
          nil: null,
          integer: 1,
          float: Math.PI,
          string: "Hello, world!",
          binary: Uint8Array.from([1, 2, 3]),
          array: [10, 20, 30],
          map: { foo: "bar" },
          timestampExt: new Date(),
        };

        for (let i = 0; i < N; i++) {
          let startTime1 = new Date().getTime();
          const encoded: Uint8Array = encoder.encode(object);
          const a: Array<any> = [];
          for await (const item of decoder.decodeStream(createStream(encoded))) {
            a.push(item);
          }
          let endTime1 = new Date().getTime();
          let averageTime1 = ((endTime1 - startTime1) * 1000) / 2;
          console.log(`msgpack-javascript:runs_multiple_times#${i} averageTime = ${averageTime1}`)
          assert.deepStrictEqual(a, [object], `#${i}`);

        }
      });
    });

    assert.context("encode() and decodeArrayStream()", () => {
      it("runs_multiple_times",0, async () => {
        const encoder = new Encoder();
        const decoder = new Decoder();

        const object = {
          nil: null,
          integer: 1,
          float: Math.PI,
          string: "Hello, world!",
          binary: Uint8Array.from([1, 2, 3]),
          array: [10, 20, 30],
          map: { foo: "bar" },
          timestampExt: new Date(),
        };

        for (let i = 0; i < N; i++) {
          let startTime1 = new Date().getTime();
          const encoded: Uint8Array = encoder.encode([object]);
          const a: Array<any> = [];
          for await (const item of decoder.decodeStream(createStream(encoded))) {
            a.push(item);
          }
          let endTime1 = new Date().getTime();
          let averageTime1 = ((endTime1 - startTime1) * 1000) / 2;
          console.log(`msgpack-javascript:runs_multiple_times#${i} averageTime = ${averageTime1}`)
          assert.deepStrictEqual(a, [[object]], `#${i}`);

        }
      });

      assert.context("regression #212", () => {
        it("runs_multiple_times",0, () => {
          const encoder = new Encoder();
          const decoder = new Decoder();

          const data1 = {
            isCommunication: false,
            isWarning: false,
            alarmId: "619f65a2774abf00568b7210",
            intervalStart: "2022-05-20T12:00:00.000Z",
            intervalStop: "2022-05-20T13:00:00.000Z",
            triggeredAt: "2022-05-20T13:00:00.000Z",
            component: "someComponent",
            _id: "6287920245a582301475627d",
          };

          const data2 = {
            foo: "bar",
          };

          const arr = [data1, data2];
          const enc = arr.map((x) => [x, encoder.encode(x)] as const);

          enc.forEach(([orig, acc]) => {
            let startTime1 = new Date().getTime();
            const des = decoder.decode(acc);

            let endTime1 = new Date().getTime();
            let averageTime1 = ((endTime1 - startTime1) * 1000) / 1;
            console.log(`msgpack-javascript:regression #212 runs_multiple_times#${orig} #${acc} averageTime = ${averageTime1}`)

            assert.deepStrictEqual(des, orig);

          });
        });
      });

      assert.context("Encoder#encodeSharedRef()", () => {
        it("returns_the_shared_reference",0, () => {
          const encoder = new Encoder();
          let startTime1 = new Date().getTime();
          const a = encoder.encodeSharedRef(true);
          const b = encoder.encodeSharedRef(false);
          let endTime1 = new Date().getTime();
          let averageTime1 = ((endTime1 - startTime1) * 1000) / 2;
          console.log(`msgpack-javascript:returns_the_shared_reference averageTime = ${averageTime1}`)

          assert.deepStrictEqual(decode(a), decode(b)); // yes, this is the expected behavior
          assert.deepStrictEqual(a.buffer, b.buffer);
        });
      });
    });
  })


}






