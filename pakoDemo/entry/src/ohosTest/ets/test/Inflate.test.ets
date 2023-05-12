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
import pako  from 'pako';
import {testInflate} from './pako/helpers'



export default function InflateTest() {
  // fromCharCode, but understands right > 0xffff values

  describe('inflateTest', function () {
    beforeAll(function () {

    })

    var samples = {}

    beforeEach(function () {
      let name =[
        'blank',
        'lorem',
        'lorem_cat',
        'lorem_en_100k',
        'lorem_utf_100k'
      ]


      let nameRes = [
      $r('app.media.blank'),
      $r('app.media.lorem'),
      $r('app.media.lorem_cat'),
      $r('app.media.lorem_en_100k'),
      $r('app.media.lorem_utf_100k'),
      ]
      for (let i=0; i<nameRes.length; i++){
        globalThis.resourceManager.getMediaContent(nameRes[i].id).then(uint8=>{
          samples[name[i]] = uint8;
        });
      }

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
    it('Forceusemaxwindowsizebydefault',0, () => {

      globalThis.resourceManager.getMediaContent($r('app.media.bad_wbits1').id).then(uint81=>{

        globalThis.resourceManager.getMediaContent($r('app.media.bad_wbits').id).then(uint82=>{

          expect(pako.inflate(uint81)).assertDeepEquals(new Uint8Array(uint82));
        })
      });


        // it('shouldthrowonthewrongdictionary',1, () => {
        //   // const zCompressed = helpers.deflateSync('world', { dictionary: Buffer.from('hello') });
        //   const zCompressed = new Uint8Array([ 120, 187, 6, 44, 2, 21, 43, 207, 47, 202, 73, 1, 0, 6, 166, 2, 41 ]);
        //
        //   try {
        //     let func = function () {
        //       pako.inflate(zCompressed, {
        //         dictionary: 'world'
        //       });
        //     };
        //     func();
        //   }catch (err){
        //     expect(err).assertContain(/need dictionary/)
        //   }
        //   ;
        // //
        // //   assert.throws(function () {
        // //     pako.inflate(zCompressed, { dictionary: 'world' });
        // //   }, /need dictionary/);
        // });

        it('trivialdictionary',2, () => {
          const dict = 'abcdefghijklmnoprstuvwxyz';

          testInflate(samples, { dictionary: dict }, { dictionary: dict });
        });

        it('spdydictionary',3, () => {

          globalThis.resourceManager.getMediaContent($r('app.media.spdy_dict').id).then(uint8=>{
          let spdyDict = uint8;
          testInflate(samples, { dictionary: spdyDict }, { dictionary: spdyDict });
            })
        });

        // it('shouldthrowifdirectoryisnotsuppliedtorawinflate',4, () => {
        //   const dict = 'abcdefghijklmnoprstuvwxyz';
        //   assert.throws(function () {
        //     testInflate(samples, { raw: true }, { raw: true, dictionary: dict });
        //   });
        // });

        it('testsrawinflatewithspdydictionary',5, () => {
          globalThis.resourceManager.getMediaContent($r('app.media.spdy_dict').id).then(uint8=>{
            let spdyDict = uint8;
            testInflate(samples, { raw: true, dictionary: spdyDict }, { raw: true, dictionary: spdyDict });
          })

        });

        it('testsdictionaryasUint8Array',6, () => {
          const dict = new Uint8Array(100);
          for (let i = 0; i < 100; i++) dict[i] = Math.random() * 256;
          testInflate(samples, { dictionary: dict }, { dictionary: dict });
        });

        it('testsdictionaryasArrayBuffer',7, () => {
          const dict = new Uint8Array(100);
          for (let i = 0; i < 100; i++) dict[i] = Math.random() * 256;
          testInflate(samples, { dictionary: dict.buffer }, { dictionary: dict });
        });


        // Since difference is only in rwapper, test for store/fast/slow methods are enough
        it('level9',8, () => {
          testInflate(samples, { raw: true }, { level: 9, raw: true });
        });
        it('level8',9, () => {
          testInflate(samples, { raw: true }, { level: 8, raw: true });
        });
        it('level7',10, () => {
          testInflate(samples, { raw: true }, { level: 7, raw: true });
        });
        it('level6',11, () => {
          testInflate(samples, { raw: true }, { level: 6, raw: true });
        });
        it('level5',12, () => {
          testInflate(samples, { raw: true }, { level: 5, raw: true });
        });
        it('level4',13, () => {
          testInflate(samples, { raw: true }, { level: 4, raw: true });
        });
        it('level3', 14,() => {
          testInflate(samples, { raw: true }, { level: 3, raw: true });
        });
        it('level2', 15,() => {
          testInflate(samples, { raw: true }, { level: 2, raw: true });
        });
        it('level1', 16,() => {
          testInflate(samples, { raw: true }, { level: 1, raw: true });
        });
        it('level0', 17,() => {
          testInflate(samples, { raw: true }, { level: 0, raw: true });
        });


        it('Z_DEFAULT_STRATEGY', 18, () => {
          testInflate(samples, {}, { strategy: 0 });
        });
        it('Z_FILTERED', 19, () => {
          testInflate(samples, {}, { strategy: 1 });
        });
        it('Z_HUFFMAN_ONLY', 20, () => {
          testInflate(samples, {}, { strategy: 2 });
        });
        it('Z_RLE', 21, () => {
          testInflate(samples, {}, { strategy: 3 });
        });
        it('Z_FIXED', 22, () => {
          testInflate(samples, {}, { strategy: 4 });
        });


        it('windowBits15',23, () => {
          testInflate(samples, {}, { windowBits: 15 });
        });
        it('windowBits14',24, () => {
          testInflate(samples, {}, { windowBits: 14 });
        });
        it('windowBits13',25, () => {
          testInflate(samples, {}, { windowBits: 13 });
        });
        it('windowBits12', 26, () => {
          testInflate(samples, {}, { windowBits: 12 });
        });
        it('windowBits11', 27, () => {
          testInflate(samples, {}, { windowBits: 11 });
        });
        it('windowBits10', 28 , () => {
          testInflate(samples, {}, { windowBits: 10 });
        });
        it('windowBits9' , 29, () => {
          testInflate(samples, {}, { windowBits: 9 });
        });
        it('windowBits8', 30, () => {
          testInflate(samples, {}, { windowBits: 8 });
        });


        it('level9',31, () => {
          testInflate(samples, {}, { level: 9 });
        });
        it('level8',32, () => {
          testInflate(samples, {}, { level: 8 });
        });
        it('level7',33, () => {
          testInflate(samples, {}, { level: 7 });
        });
        it('level6',34, () => {
          testInflate(samples, {}, { level: 6 });
        });
        it('level5',35, () => {
          testInflate(samples, {}, { level: 5 });
        });
        it('level4',36, () => {
          testInflate(samples, {}, { level: 4 });
        });
        it('level3',37, () => {
          testInflate(samples, {}, { level: 3 });
        });
        it('level2',38, () => {
          testInflate(samples, {}, { level: 2 });
        });
        it('level1',39, () => {
          testInflate(samples, {}, { level: 1 });
        });
        it('level0',40, () => {
          testInflate(samples, {}, { level: 0 });
        });
        it('withautodetect',41, () => {
          testInflate(samples, {}, { gzip: true });
        });

        it('withmethodsetdirectly',42, () => {
          testInflate(samples, { windowBits: 16 }, { gzip: true });
        });

        it('inflatenooptions',43, () => {
          testInflate(samples, {}, {});
        });

        it('inflaterawnooptions',44, () => {
          testInflate(samples, { raw: true }, { raw: true });
        });

        // it('inflaterawfromcompressedsamples',45, () => {
        //
        //   let name =[
        //     'KW_Rocketry_1',
        //     'shapefile',
        //     'sheet2',
        //     'sheet3',
        //     'sheet4'
        //   ]
        //
        //
        //   let nameRes = [
        //   $r('app.media.KW_Rocketry_1'),
        //   $r('app.media.shapefile'),
        //   $r('app.media.sheet2'),
        //   $r('app.media.sheet3'),
        //   $r('app.media.sheet4'),
        //   ]
        //
        //   var sampleTemp = {};
        //   for (let i=0; i<nameRes.length; i++){
        //     globalThis.resourceManager.getMediaContent(nameRes[i].id).then(uint8=>{
        //       sampleTemp[name[i]] = uint8;
        //       const pako_result = pako.inflateRaw(sampleTemp[name[i]]);
        //       // zlib属于node依赖暂无法测试
        //       const zlib_result = zlib.inflateRawSync(sampleTemp[name[i]]);
        //
        //       expect(pako_result).assertDeepEquals(zlib_result);
        //
        //     });
        //   }
        // });


    });
  })
}







