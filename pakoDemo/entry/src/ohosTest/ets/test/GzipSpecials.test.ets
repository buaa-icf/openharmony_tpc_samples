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
import pako  from 'pako';

export default function GzipSpecialsTest() {
  // fromCharCode, but understands right > 0xffff values
  function a2s(array) {
    return String.fromCharCode.apply(null, array);
  }

  var Z_SYNC_FLUSH = pako.constants.Z_SYNC_FLUSH;
  describe('gzipspecialsTest', function () {
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

    it('Readcustomheaders',0, () => {

      globalThis.resourceManager.getMediaContent($r('app.media.gzip_headers').id).then(data=>{

        const inflator = new pako.Inflate();
        inflator.push(data);
        expect(inflator.header.name).assertEqual('test name');
        expect(inflator.header.comment).assertEqual('test comment');
        expect(a2s(inflator.header.extra)).assertEqual('test extra');
      });
    });

    it('Writecustomheaders', 1, () => {
      const data = '           ';

      const deflator = new pako.Deflate({
        gzip: true,
        header: {
          hcrc: true,
          time: 1234567,
          os: 15,
          name: 'test name',
          comment: 'test comment',
          extra: [ 4, 5, 6 ]
        }
      });
      deflator.push(data, true);

      const inflator = new pako.Inflate({ to: 'string' });
      inflator.push(deflator.result);

      expect(inflator.err).assertEqual(0);
      expect(inflator.result).assertEqual(data);

      const header = inflator.header;
      expect(header.time).assertEqual(1234567);
      expect(header.os).assertEqual(15);
      expect(header.name).assertEqual('test name');
      expect(header.comment).assertEqual('test comment');
      expect(header.extra).assertDeepEquals(new Uint8Array([ 4, 5, 6 ]));
    });

    // zlib需要node依赖 目前无法测试
    // it('ReadstreamwithSYNCmarksmultistreamsourcefile1',2, () => {
    //   globalThis.resourceManager.getMediaContent($r('app.media.gzip-joined').id).then(data=>{
    //     expect(pako.ungzip(data)).assertDeepEquals(new Uint8Array(zlib.gunzipSync(data))
    //     );
    //   });
    // });
    // zlib需要node依赖 目前无法测试
    // it.skip('Read stream with SYNC marks (multistream source, file 2)', () => {
    //   const data = fs.readFileSync(path.join(__dirname, 'fixtures/gzip-joined-bgzip.gz'));
    //   assert.deepStrictEqual(
    //     // Currently fails with this chunk size
    //     pako.ungzip(data, { chunkSize: 16384 }),
    //     new Uint8Array(zlib.gunzipSync(data))
    //   );
    // });

    it('WritewithZ_SYNC_FLUSH',2, () => {
      const deflator = new pako.Deflate({ gzip: true });
      let count = 0;
      deflator.onData = function (chunk) {
        this.chunks.push(chunk);
        count++;
      };
      deflator.push('12345', Z_SYNC_FLUSH);
      deflator.push('67890', true);
      const flushed = deflator.result;
      const normal = pako.gzip('1234567890');
      expect(count).assertEqual(2);
      expect(pako.ungzip(flushed)).assertDeepEquals(pako.ungzip(normal))
      expect(flushed.length > normal.length).assertTrue()
    });

  })
}











