/*
 * (The MIT License)

 * Copyright (c) 2023 Huawei Device Co., Ltd.

 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * 'Software'), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:

 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.

 * THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
 * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import { beforeAll, describe, expect, it, TestType } from '@ohos/hypium';
import { Compress, Config7z, Uncompress } from '@ohos/oh7zip';
import GlobalContext from './GlobalContext';

export default function InterfaceTime() {

  describe('interfaceTime', () => {
    const BASE_COUNT = 100
    const BASELINE_CREATEHTTP = 10000
    let uncompress = new Uncompress()
    let compress = new Compress()

    let filesDir: string;
    let resourceDir: string;
    let uncompressConfig: Config7z[]
    let compressConfig: Config7z[]

    beforeAll(() => {
      filesDir = GlobalContext.getContext().getValue('filesDir') as string
      resourceDir = GlobalContext.getContext().getValue('resourceDir') as string
      uncompressConfig = [
        {
          src: resourceDir + "/test_7z.7z",
          dst: filesDir,
          pwd: "test_7z"
        }
      ]

      compressConfig = [
        {
          src: resourceDir + "/test/normal",
          dst: filesDir + "/test_7z.7z",
          pwd: "test_7z",
          fmt: "7z"
        }
      ]
    })

    it('UncompressSync', TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime()
        let result: number = 0
        for (let i = 0; i < uncompressConfig.length; i++) {
          result += uncompress.extractSync(uncompressConfig[i])
        }
        if (result != 0) {
          expect().assertFail()
        } else {
          expect(true).assertTrue()
        }
      let endTime = new Date().getTime()
      console.log("Session.get endTime:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("Session.get averageTime:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done()
    })

    it('UncompressAsync', TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime()

      let fail: boolean = false
      for (let i = 0; i < uncompressConfig.length; i++) {
        uncompress.extractAsync(uncompressConfig[i]).then((result) => {
          if (fail) {
            return
          }
          if (result != 0) {
            expect().assertFail()
          } else {
            expect(true).assertTrue()
          }
        })
      }
      let endTime = new Date().getTime()
      console.log("Session getBulk endTime:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("Session getBulk averageTime:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done()
    })

    it('CompressSync', TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime()
      let result: number = 0
      for (let i = 0; i < compressConfig.length; i++) {
        result += compress.compressSync(compressConfig[i])
      }
      if (result != 0) {
        expect().assertFail()
      } else {
        expect(true).assertTrue()
      }
      let endTime = new Date().getTime()
      console.log("Session.getNext endTime:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("Session.getNext averageTime:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done()
    })

    it('CompressAsync', TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime()

      let fail: boolean = false
      for (let i = 0; i < compressConfig.length; i++) {
        compress.compressAsync(compressConfig[i]).then((result) => {
          if (fail) {
            return
          }
          if (result != 0) {
            expect().assertFail()
          } else {
            expect(true).assertTrue()
          }
        })
      }
      let endTime = new Date().getTime()
      console.log("Session.subtree endTime:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("Session.subtree  averageTime:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done()
    })
  })
}