/*
 * Copyright (C) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { afterAll, beforeAll, describe, expect, it } from '@ohos/hypium';
import { Compress, Config7z, Uncompress } from '@ohos/oh7zip';
import GlobalContext from './GlobalContext';


export default function abilityTest() {
  describe('ActsAbilityTest', () => {
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
        },
        {
          src: resourceDir + "/test_rar.rar",
          dst: filesDir,
          pwd: "test_rar"
        },
        {
          src: resourceDir + "/test_zip.zip",
          dst: filesDir,
          pwd: "test_zip"
        },
        {
          src: resourceDir + "/test_tar.tar.gz",
          dst: filesDir
        },
        {
          src: resourceDir + "/test_tar.tar",
          dst: filesDir
        }
      ]

      compressConfig = [
        {
          src: resourceDir + "/test/normal",
          dst: filesDir + "/test_7z.7z",
          pwd: "test_7z",
          fmt: "7z"
        },
        {
          src: resourceDir + "/test/normal",
          dst: filesDir + "/test_zip.zip",
          pwd: "test_zip",
          fmt: "zip"
        },
        {
          src: resourceDir + "/test/normal",
          dst: filesDir + "/test_tar.tar",
          fmt: "tar"
        },
        {
          src: resourceDir + "/test_tar.tar",
          dst: filesDir + "/test_tar.tar.xz",
          fmt: "xz"
        },
        {
          src: resourceDir + "/test_tar.tar",
          dst: filesDir + "/test_tar.tar.bzip2",
          fmt: "bzip2"
        },
        {
          src: resourceDir + "/test_tar.tar",
          dst: filesDir + "/test_tar.tar.gz",
          fmt: "gzip"
        }
      ]
    })


    it('UncompressSync', 0, () => {
      let result: number = 0
      for (let i = 0; i < uncompressConfig.length; i++) {
        result += uncompress.extractSync(uncompressConfig[i])
      }
      if (result != 0) {
        expect().assertFail()
      } else {
        expect(true).assertTrue()
      }
    })

    it('UncompressSyncNameIsLong', 0, () => {
      let uncompressConfig: Config7z = {
        src: resourceDir + "/test_90s7uas897as87f98ffas8f7a8s96f89as.zip",
        dst: filesDir,
        pwd: "test_zip"
      }

      let result: number = uncompress.extractSync(uncompressConfig)
      if (result != 0) {
        expect().assertFail()
      } else {
        expect(true).assertTrue()
      }
    })

    it('UncompressSyncNameIsEmpty', 0, () => {
      let uncompressConfig: Config7z = {
        src: '',
        dst: filesDir,
        pwd: "test_zip"
      }

      let result: number = uncompress.extractSync(uncompressConfig)
      if (result != 2) {
        expect().assertFail()
      } else {
        expect(true).assertTrue()
      }
    })

    it('UncompressSyncLargeFile', 0, () => {
      let uncompressConfig: Config7z = {
        src: resourceDir + "/test_large.rar",
        dst: filesDir,
        pwd: "123123"
      }

      let result: number = uncompress.extractSync(uncompressConfig)
      if (result != 0) {
        expect().assertFail()
      } else {
        expect(true).assertTrue()
      }
    })

    it('UncompressAsync', 0, () => {
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
    })

    it('CompressSync', 0, () => {
      let result: number = 0
      for (let i = 0; i < compressConfig.length; i++) {
        result += compress.compressSync(compressConfig[i])
      }
      if (result != 0) {
        expect().assertFail()
      } else {
        expect(true).assertTrue()
      }
    })

    it('CompressLongFileName', 0, () => {
      let compressConfig: Config7z={
        src: resourceDir + "/test/longname",
        dst: filesDir + "/test_longname_compress.zip",
        pwd: "test_zip",
        fmt: "zip"
      }

      let result: number= compress.compressSync(compressConfig)
      if (result != 0) {
        expect().assertFail()
      } else {
        expect(true).assertTrue()
      }
    })

    it('CompressEmpty', 0, () => {
      let compressConfig: Config7z={
        src: "",
        dst: filesDir + "/test_large_compress.zip",
        pwd: "test_zip",
        fmt: "zip"
      }

      let result: number= compress.compressSync(compressConfig)
      if (result != 2) {
        expect().assertFail()
      } else {
        expect(true).assertTrue()
      }
    })

    it('CompressLarge', 0, () => {
      let compressConfig: Config7z={
        src: resourceDir + "/test/large",
        dst: filesDir + "/test_large_compress.zip",
        pwd: "test_zip",
        fmt: "zip"
      }

      let result: number= compress.compressSync(compressConfig)
      if (result != 0) {
        expect().assertFail()
      } else {
        expect(true).assertTrue()
      }
    })

    it('CompressAsync', 0, () => {
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
    })
  })
}