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
import hilog from '@ohos.hilog';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'

import pako from 'pako';
import { deflateInit, deflateSetHeader, deflate, deflateEnd, } from 'pako/lib/zlib/deflate.js';
import ZStream from 'pako/lib/zlib/zstream.js';


export default function BeflateCoverTest() {
  // fromCharCode, but understands right > 0xffff values

  describe('BeflateCoverTest', function () {

    var long_sample;
    let c = pako.constants
    beforeAll(function () {

    })
    beforeEach(function () {
      // globalThis.resourceManager.getMediaContent($r('app.media.lorem_en_100k').id).then((uint8:Uint8Array)=>{
      //   console.log("dodoTag= uint8 length"+uint8.byteLength);
      //   long_sample  = uint8
      // });
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
    var short_sample = 'hello world';


    function testDeflate(data, opts, flush) {
      let deflator = new pako.Deflate(opts);
      deflator.push(data, flush);
      deflator.push(data, true);
      let errcode = deflator.err;

      expect(errcode).assertEqual(0)
    }

    it('stored', 0, () => {
      testDeflate(short_sample, {
        level: 0, chunkSize: 200
      }, 0);
      testDeflate(short_sample, {
        level: 0, chunkSize: 10
      }, 5);
    });
    it('fast', 1, () => {
      testDeflate(short_sample, {
        level: 1, chunkSize: 10
      }, 5);
      globalThis.resourceManager.getMediaContent($r('app.media.lorem_en_100k').id).then((uint8: Uint8Array) => {
        long_sample = uint8
        testDeflate(long_sample, {
          level: 1, memLevel: 1, chunkSize: 10
        }, 0);
      });

    });
    it('slow', 2, () => {
      testDeflate(short_sample, {
        level: 4, chunkSize: 10
      }, 5);
      globalThis.resourceManager.getMediaContent($r('app.media.lorem_en_100k').id).then((uint8: Uint8Array) => {
        long_sample = uint8
        testDeflate(long_sample, {
          level: 9, memLevel: 1, chunkSize: 10
        }, 0);
      });
    });
    it('rle', 3, () => {
      testDeflate(short_sample, {
        strategy: 3
      }, 0);
      testDeflate(short_sample, {
        strategy: 3, chunkSize: 10
      }, 5);

      globalThis.resourceManager.getMediaContent($r('app.media.lorem_en_100k').id).then((uint8: Uint8Array) => {
        long_sample = uint8
        testDeflate(long_sample, {
          strategy: 3, chunkSize: 10
        }, 0);
      });
    });
    it('huffman', 4, () => {
      testDeflate(short_sample, {
        strategy: 2
      }, 0);
      testDeflate(short_sample, {
        strategy: 2, chunkSize: 10
      }, 5);
      globalThis.resourceManager.getMediaContent($r('app.media.lorem_en_100k').id).then((uint8: Uint8Array) => {
        long_sample = uint8
        testDeflate(long_sample, {
          strategy: 2, chunkSize: 10
        }, 0);
      });
    });

    //in port checking input parameters was removed
    it('inflatebadparameters1', 5, () => {
      let ret, strm;

      ret = deflate(null, 0);
      expect(ret).assertDeepEquals(c.Z_STREAM_ERROR)


      strm = new ZStream();
      //
      ret = deflateInit(null);

      expect(ret).assertDeepEquals(c.Z_STREAM_ERROR)
      ret = deflateInit(strm, 6);
      expect(ret).assertDeepEquals(c.Z_OK)

      ret = deflateSetHeader(null);

      expect(ret).assertDeepEquals(c.Z_STREAM_ERROR)
      strm.state.wrap = 1;
      ret = deflateSetHeader(strm, null);

      expect(ret).assertDeepEquals(c.Z_STREAM_ERROR)
      strm.state.wrap = 2;
      ret = deflateSetHeader(strm, null);
      expect(ret).assertDeepEquals(c.Z_OK)
      ret = deflate(strm, c.Z_FINISH);

      expect(ret).assertDeepEquals(c.Z_BUF_ERROR)
      ret = deflateEnd(null);

      expect(ret).assertDeepEquals(c.Z_STREAM_ERROR)
      //BS_NEED_MORE
      strm.state.status = 5;
      ret = deflateEnd(strm);
      expect(ret).assertDeepEquals(c.Z_STREAM_ERROR)
    });

  })
}









