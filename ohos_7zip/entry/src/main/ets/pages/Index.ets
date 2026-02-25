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

import { Config7z, Uncompress, Compress } from '@ohos/oh7zip'

@Entry
@Component
struct Test7z {
  @State progressSync: number = 0;
  @State progressAsync: number = 0;
  @State uncompressSyncText: string = "stop test"
  @State uncompressAsyncText: string = "stop test"
  @State compressSyncText: string = "stop test"
  @State compressAsyncText: string = "stop test"
  @State dstCheckText: string = "dst check not run"
  private uncompress: Uncompress = new Uncompress()
  private compress: Compress = new Compress()
  private uncompressConfig: Config7z[] = [
    {
      src: getContext().resourceDir + "/test_7z.7z",
      dst: getContext().filesDir,
      pwd: 'test_7z'
    },
    {
      src: getContext().resourceDir + "/test_rar.rar",
      dst: getContext().filesDir,
      pwd: 'test_rar'
    },
    {
      src: getContext().resourceDir + "/test_zip.zip",
      dst: getContext().filesDir,
      pwd: 'test_zip'
    },
    {
      src: getContext().resourceDir + "/test_tar.tar.gz",
      dst: getContext().filesDir
    },
    {
      src: getContext().resourceDir + "/test_tar.tar",
      dst: getContext().filesDir
    }
  ]
  private compressConfig: Config7z[] = [
    {
      src: getContext().resourceDir + "/test",
      dst: getContext().filesDir + "/test_7z.7z",
      pwd: 'test_7z',
      fmt: '7z'
    },
    {
      src: getContext().resourceDir + "/test",
      dst: getContext().filesDir + "/test_zip.zip",
      pwd: 'test_zip',
      fmt: 'zip'
    },
    {
      src: getContext().resourceDir + "/test",
      dst: getContext().filesDir + "/test_tar.tar",
      fmt: 'tar '
    },
    {
      src: getContext().resourceDir + "/test_tar.tar",
      dst: getContext().filesDir + "/test_tar.tar.xz",
      fmt: 'xz'
    },
    {
      src: getContext().resourceDir + "/test_tar.tar",
      dst: getContext().filesDir + "/test_tar.tar.bzip2",
      fmt: 'bzip2'
    },
    {
      src: getContext().resourceDir + "/test_tar.tar",
      dst: getContext().filesDir + "/test_tar.tar.gz",
      fmt: 'gzip'
    }
  ]

  testUncompressSync() {
    this.uncompressSyncText = "testing"
    let result: number = 0
    for (let i = 0; i < this.uncompressConfig.length; i++) {
      result += this.uncompress.extractSync(this.uncompressConfig[i])
      console.info('test-->'+JSON.stringify(this.uncompressConfig[i]))
    }
    if (result != 0) {
      this.uncompressSyncText = "test failed, code = " + result
    } else {
      this.uncompressSyncText = "test over"
    }
  }

  testUncompressAsync() {
    this.uncompressAsyncText = "testing"
    let fail: boolean = false
    for (let i = 0; i < this.uncompressConfig.length; i++) {
      this.uncompress.extractAsync(this.uncompressConfig[i]).then((result) => {
        if (fail) {
          return
        }
        if (result != 0) {
          this.uncompressAsyncText = "test failed, code = " + result
          fail = true
        } else {
          this.uncompressAsyncText = "test over"
        }
      })
    }
  }

  testCompressSync() {
    this.compressSyncText = "testing"
    let result: number = 0
    for (let i = 0; i < this.compressConfig.length; i++) {
      result += this.compress.compressSync(this.compressConfig[i])
    }
    if (result != 0) {
      this.compressSyncText = "test failed, code = " + result
    } else {
      this.compressSyncText = "test over"
    }
  }

  testCompressAsync() {
    this.compressAsyncText = "testing"
    let fail: boolean = false
    for (let i = 0; i < this.compressConfig.length; i++) {
      this.compress.compressAsync(this.compressConfig[i]).then((result) => {
        if (fail) {
          return
        }
        if (result != 0) {
          this.compressAsyncText = "test failed, code = " + result
          fail = true
        } else {
          this.compressAsyncText = "test over"
        }
      })
    }
  }

  // demo：专门测试压缩时 dst 路径合法性相关的错误码（主要是 3 和 4 ）
  testDstValidation() {
    // 复用已有的 src 路径，保证源路径是合法的
    const baseSrc: string = getContext().resourceDir + '/test';

    const configs: Config7z[] = [
      // 场景1：dst 为空字符串 -> 期望触发错误码 3 (ILLEGAL_DST)
      {
        src: baseSrc,
        dst: '',
        fmt: '7z'
      },
      // 场景2：dst 指向一个已存在的目录 -> 期望触发错误码 3 (ILLEGAL_DST)
      {
        src: baseSrc,
        dst: getContext().filesDir,
        fmt: '7z'
      },
      // 场景3：dst 的父目录不存在 -> 期望触发错误码 3 (ILLEGAL_DST)
      {
        src: baseSrc,
        dst: getContext().filesDir + '/not_exist_dir/out.7z',
        fmt: '7z'
      },
      // 场景4：尝试写入可能无权限的路径 -> 通常期望错误码 4 (DST_NO_PERMISSION)，视实际系统权限而定
      {
        src: baseSrc,
        dst: '/system/oh7zip_test.7z',
        fmt: '7z'
      }
    ];

    const results: number[] = [];
    for (let i = 0; i < configs.length; i++) {
      let code = this.compress.compressSync(configs[i]);
      results.push(code);
    }

    this.dstCheckText = `dstEmpty=${results[0]}, dstDir=${results[1]}, dstNoParent=${results[2]}, dstNoPerm=${results[3]}`;
  }

  build() {
    Column() {
      Text(this.uncompressSyncText)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 5 })
      Button("test uncompress sync")
        .width("35%")
        .onClick(() => {
          this.testUncompressSync()
        })
      Text().height("10%")
      Text(this.uncompressAsyncText)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 5 })
      Button("test uncompress async")
        .width("35%")
        .onClick(async () => {
          this.testUncompressAsync()
        })
      Text().height("10%")
      Text(this.compressSyncText)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 5 })
      Button("test compress sync")
        .width("35%")
        .onClick(() => {
          this.testCompressSync()
        })
      Text().height("10%")
      Text(this.compressAsyncText)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 5 })
      Button("test compress async")
        .width("35%")
        .onClick(async () => {
          this.testCompressAsync()
        })
      Text().height("10%")
      Text(this.dstCheckText)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 5 })
      Button("test dst validation")
        .width("50%")
        .onClick(() => {
          this.testDstValidation()
        })

    }
    .height('100%')
    .width('100%')
  }
}