/**
 * MIT License
 *
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the 'Software'), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to all conditions.
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import fs from '@ohos.file.fs';
import router from '@ohos.router';
import common from '@ohos.app.ability.common';
import pako from 'pako';

/**
 * 指定文件路径压缩文件gz方法
 *
 * @since 7
 * @permission N
 * @param {string} path - path.
 * @param {string} dest -path and file name after the .gz file is generated.
 * @returns {void | Promise<boolean>} callback return Promise otherwise return true or false.
 */
interface optionsType {
  gzip: boolean,
  level: number
}

export async function gzipFile(src: string, dest: string): Promise<boolean> {
  try {
    let stat = fs.statSync(src);
    const buf = new ArrayBuffer(stat.size);
    const reader = fs.openSync(src, fs.OpenMode.READ_ONLY);
    fs.readSync(reader.fd, buf);
    const writer = fs.openSync(dest, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    const options: optionsType = { gzip: true, level: 9 };
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
    fs.readSync(reader.fd, buf);
    const options: optionsType = { gzip: true, level: 9 };
    const data: string | Uint8Array | undefined = pako.inflate(new Uint8Array(buf), options);
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

  build() {

    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
      Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
        Button($r('app.string.back'))
          .onClick(() => {
            router.back();
          })
          .backgroundColor('#7ba54c')
          .width(100)
          .fontSize(14)
          .flexGrow(0)
      }
      Text($r('app.string.gzipAbout'))
        .fontSize(20)
        .margin({ top: 16 })
      Text($r('app.string.generateHello'))
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
        Text($r('app.string.zipHello'))
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
        Text($r('app.string.unZipFile'))
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
    let context = getContext(this) as common.UIAbilityContext;
    try {
      let data = context.filesDir
      const writer = fs.openSync(data + '/hello.txt', fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
      fs.writeSync(writer.fd,
        "hello, world! adjasjdakjdakjdkjakjdakjskjasdkjaskjdajksdkjasdkjaksjdkja\n"
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
        title: $r('app.string.generateSuccess'),
        message: context.resourceManager.getStringSync($r('app.string.checkSandBox').id) + data + '/hello.txt',
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
    let context = getContext(this) as common.UIAbilityContext;
    try {
      let data = context.filesDir
      console.info('directory obtained. Data:' + data);
      gzipFile(data + '/hello.txt', data + '/hello.txt.gz')
        .then((isSuccess) => {
          if (isSuccess) {
            AlertDialog.show({
              title: context.resourceManager.getStringSync($r('app.string.zipSuccess').id),
              message: context.resourceManager.getStringSync($r('app.string.checkSandBox').id) + data + '/hello.txt.gz',
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
    let context = getContext(this) as common.UIAbilityContext;
    try {
      let data = context.filesDir
      unGzipFile(data + '/hello.txt.gz', data + '/test.txt')
        .then((isSuccess) => {
          if (isSuccess) {
            AlertDialog.show({
              title: context.resourceManager.getStringSync($r('app.string.unzipSuccess').id),
              message: context.resourceManager.getStringSync($r('app.string.checkSandBox').id) + data + '/test.txt',
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