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
import { fileIo as fs } from '@kit.CoreFileKit';
import pako from 'pako';
import { GlobalContext } from '../entryability/GlobalContext';

export async function gzipFile(src: string, dest: string): Promise<boolean> {
  try {
    let stat = fs.statSync(src);
    const buf = new ArrayBuffer(stat.size);
    const reader = fs.openSync(src, fs.OpenMode.READ_ONLY);
    fs.readSync(reader.fd, buf);
    const writer = fs.openSync(dest, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    const options: pako.DeflateOptions = { gzip: true, level: 9 };
    fs.writeSync(writer.fd, pako.gzip(new Uint8Array(buf), options)?.buffer);
    fs.closeSync(reader);
    fs.closeSync(writer);
    return true;
  } catch (error) {
    return false;
  }
}

/**
 * 解压gz文件方法
 *
 * @since 7
 * @permission N
 * @param {string} src - path and name of the decompressed .gz file.
 * @param {string} target -Decompress the package to a specified path.
 * @returns {void | Promise<boolean>} callback return Promise otherwise return true or false.
 */
export async function unGzipFile(src: string, target: string): Promise<boolean> {
  try {
    const reader = fs.openSync(src, fs.OpenMode.READ_ONLY);
    const stat = fs.statSync(src);
    const buf = new ArrayBuffer(stat.size);
    await fs.read(reader.fd, buf);
    const data: string | Uint8Array | undefined = pako.ungzip(new Uint8Array(buf));
    if (typeof data == 'string') {
      return false
    }
    const writer = fs.openSync(target, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    fs.writeSync(writer.fd, data?.buffer);
    fs.closeSync(writer);
    fs.closeSync(reader);
    return true;
  } catch (error) {
    return false;
  }
}

@Entry
@Component
export struct GzipTest {
  @State isCompressGZipFileShow: boolean = false;
  @State isDeCompressGZipShow: boolean = false;
  preTimestamp: number = 0;

  getResourceString(res:Resource) {
    return getContext().resourceManager.getStringSync(res.id)
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
      Text($r("app.string.Gzip_related_functions"))
        .fontSize(20)
        .margin({ top: 16 })

      Text($r("app.string.Click_Generate_hello_txt"))
        .fontSize(16)
        .margin({ top: 32 })
        .padding(8)
        .border({ width: 2, color: '#535353', radius: 6 })
        .onClick((event) => {
          if (!this.isFastClick()) {
            this.generateTextFile()
          }
        })

      if (this.isCompressGZipFileShow) {
        Text($r("app.string.Click_compress_hello_txt_as_GZ_file"))
          .fontSize(16)
          .margin({ top: 32 })
          .padding(8)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick((event) => {
            if (!this.isFastClick()) {
              this.gzipFileTest()
            }
          })
      }

      if (this.isDeCompressGZipShow) {
        Text($r("app.string.Click_extract_GZ_file"))
          .fontSize(16)
          .margin({ top: 32 })
          .padding(8)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick((event) => {
            if (!this.isFastClick()) {
              this.unGzipFileTest()
            }
          })
      }
    }
    .width('100%')
    .height('100%')
  }

  generateTextFile(): void {
    let context: Context = GlobalContext.getContext().getObject("context") as Context
    try {
      let data = context.filesDir
      const writer = fs.openSync(data + '/hello.txt', fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
      fs.writeSync(writer.fd,
        "hello, world! 你好你是什么认为呢 打烂打烂大龙胆大大家记得那几年的 adjasjdakjdakjdkjakjdakjskjasdkjaskjdajksdkjasdkjaksjdkja\n"
          + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
          + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
          + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
          + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
          + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
          + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
          + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
          + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
          + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
          + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
          + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
          + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs"
      );
      fs.closeSync(writer);
      AlertDialog.show({
        title: $r("app.string.Build_succeeded"),
        message: this.getResourceString($r("app.string.Check_out_sandbox_path")) + data + '/hello.txt',
        confirm: {
          value: 'OK', action: () => {
            this.isCompressGZipFileShow = true
          }
        }
      })
    } catch (error) {
      console.error('File to obtain the file directory. Cause: ' + error.message);
    }
  }

  gzipFileTest(): void {
    let context: Context = GlobalContext.getContext().getObject("context") as Context
    try {
      let data = context.filesDir
      console.info('directory obtained. Data:' + data);
      gzipFile(data + '/hello.txt', data + '/test.txt.gz')
        .then((isSuccess) => {
          if (isSuccess) {
            AlertDialog.show({
              title: $r("app.string.Compression_succeeded"),
              message: this.getResourceString($r("app.string.Check_out_sandbox_path")) + data + '/test.txt.gz',
              confirm: {
                value: 'OK', action: () => {
                  this.isDeCompressGZipShow = true
                }
              }
            })
          }
        });
    } catch (error) {
      console.error('File to obtain the file directory. Cause: ' + error.message);
    }
  }

  unGzipFileTest(): void {
    let context: Context = GlobalContext.getContext().getObject("context") as Context
    try {
      let data = context.filesDir
      unGzipFile(data + '/test.txt.gz', data + '/test.txt')
        .then((isSuccess) => {
          if (isSuccess) {
            AlertDialog.show({
              title: $r("app.string.Decompression_successful"),
              message: this.getResourceString($r("app.string.Check_out_sandbox_path")) + data + '/test.txt',
              confirm: {
                value: 'OK', action: () => {
                }
              }
            })
          }
        });
    } catch (error) {
      console.error('File to obtain the file directory. Cause: ' + error.message);
    }
  }

  isFastClick(): boolean {
    let timestamp = Date.parse(new Date().toString());
    if ((timestamp - this.preTimestamp) > 1500) {
      this.preTimestamp = timestamp;
      return false;
    } else {
      return true;
    }
  }
}

