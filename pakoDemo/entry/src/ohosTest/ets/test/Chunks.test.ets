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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import pako from 'pako';

export default function ChunksTest() {
  // fromCharCode, but understands right > 0xffff values

  describe('chunksTest', function () {
    beforeAll(function () {

    })

    beforeEach(function () {

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

    function randomBuf(size) {
      const buf = new Uint8Array(size);
      for (let i = 0; i < size; i++) {
        buf[i] = Math.round(Math.random() * 256);
      }
      return buf;
    }

    function testChunk(buf, expected, packer, chunkSize) {
      let i, _in, count, pos, size, expFlushCount;

      let onData = packer.onData;
      let flushCount = 0;

      packer.onData = function () {
        flushCount++;
        onData.apply(this, arguments);
      };

      count = Math.ceil(buf.length / chunkSize);
      pos = 0;
      for (i = 0; i < count; i++) {
        size = (buf.length - pos) < chunkSize ? buf.length - pos : chunkSize;
        _in = new Uint8Array(size);
        _in.set(buf.subarray(pos, pos + size), 0);
        packer.push(_in, i === count - 1);
        pos += chunkSize;
      }

      //expected count of onData calls. 16384 output chunk size
      expFlushCount = Math.ceil(packer.result.length / packer.options.chunkSize);

      expect(packer.result).assertDeepEquals(expected)
      expect(flushCount).assertEqual(expFlushCount)

    }


    it('deflate100bby1bchunk', 0, () => {
      const buf = randomBuf(100);
      const deflated = pako.deflate(buf);
      testChunk(buf, deflated, new pako.Deflate(), 1);
    });

    it('deflate20000bby10bchunk', 1, () => {
      const buf = randomBuf(20000);
      const deflated = pako.deflate(buf);
      testChunk(buf, deflated, new pako.Deflate(), 10);
    });

    it('inflate100bresultby1bchunk', 2, () => {
      const buf = randomBuf(100);
      const deflated = pako.deflate(buf);
      testChunk(deflated, buf, new pako.Inflate(), 1);
    });


    // 测试失败
    it('inflate20000bresultby10bchunk', 3, () => {
      const buf = randomBuf(20000);
      const deflated = pako.deflate(buf);
      testChunk(deflated, buf, new pako.Inflate(), 10);
    });

    // 测试失败
    it('deflateend', 4, () => {

      // const data = samples['lorem_utf_100k'];
      globalThis.resourceManager.getMediaContent($r('app.media.lorem_utf_100k').id).then(data => {
        console.log("dodoTag data =" + data.byteLength)
        const deflator = new pako.Deflate();
        deflator.push(data);
        deflator.push([], true);
        expect(deflator.result).assertDeepEquals(pako.deflate(data))
      });


    });

    it('inflateend', 5, () => {

      globalThis.resourceManager.getMediaContent($r('app.media.lorem_utf_100k').id).then(data => {
        // const data = pako.deflate(samples['lorem_utf_100k']);
        const inflator = new pako.Inflate();
        inflator.push(data);
        expect(inflator.result).assertDeepEquals(pako.inflate(data))
      });
    });


    it('shouldbeokonbufferborder', 6, () => {
      let i;
      const data = new Uint8Array(1024 * 1 + 1);

      for (i = 0; i < data.length; i++) {
        data[i] = Math.floor(Math.random() * 255.999);
      }

      const deflated = pako.deflate(data);

      const inflator = new pako.Inflate();

      for (i = 0; i < deflated.length; i++) {
        inflator.push(deflated.subarray(i, i + 1), false);

      }

      inflator.push(new Uint8Array(0));


      expect(data).assertDeepEquals(inflator.result)
      // expect(1).assertEqual(1)
    });

  })
}














