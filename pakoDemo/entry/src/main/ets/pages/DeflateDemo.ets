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

export async function DeflateFile(src: string, dest: string): Promise<boolean> {
  try {
    let stat = fs.statSync(src);
    let buf = new ArrayBuffer(stat.size);
    let reader = fs.openSync(src, fs.OpenMode.READ_ONLY);
    fs.readSync(reader.fd, buf);
    let writer = fs.openSync(dest, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    let options: pako.DeflateFunctionOptions = { level: 9 };
    fs.writeSync(writer.fd, pako.deflate(new Uint8Array(buf), options)?.buffer);
    fs.closeSync(reader);
    fs.closeSync(writer);
    return true;
  } catch (error) {
    return false;
  }
}


export async function InflateFile(src: string, target: string): Promise<boolean> {
  try {
    let reader = fs.openSync(src, fs.OpenMode.READ_ONLY);
    let stat = fs.statSync(src);
    let buf = new ArrayBuffer(stat.size);
    await fs.read(reader.fd, buf);
    let options: pako.DeflateFunctionOptions = { level: 9 };
    let data: string | Uint8Array | undefined = pako.inflate(new Uint8Array(buf), options);
    if (typeof data == 'string') {
      return false
    }
    let writer = fs.openSync(target, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
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
struct DeflateTest {
  @State isCompressGZipFileShow: boolean = false;
  @State isDeCompressGZipShow: boolean = false;
  preTimestamp: number = 0;

  getResourceString(res:Resource){
    return getContext().resourceManager.getStringSync(res.id)
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
      Text($r("app.string.Deflate_related_features"))
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
        Text($r("app.string.Click_Compress"))
          .fontSize(16)
          .margin({ top: 32 })
          .padding(8)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            if (!this.isFastClick()) {
              this.DeflateFileTest()
            }
          })
      }

      if (this.isDeCompressGZipShow) {
        Text($r("app.string.Click_Unzip"))
          .fontSize(16)
          .margin({ top: 32 })
          .padding(8)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            if (!this.isFastClick()) {
              this.InflateFileTest()
            }
          })
      }
    }.width('100%')
    .height('100%')
  }

  InflateFileTest(): void {
    let context: Context = GlobalContext.getContext().getObject("context") as Context
    try {
      let data = context.filesDir
      InflateFile(data + "/hello.txt.deflate", data + '/test.txt')
        .then(() => {
          AlertDialog.show({
            title: $r("app.string.Decompression_successful"),
            message: this.getResourceString($r("app.string.Check_out_sandbox_path")) + data + '/test.txt',
            confirm: {
              value: 'OK', action: () => {
              }
            }
          })
        });
    } catch (error) {
      console.error('File to obtain the file directory. Cause: ' + error.message);
    }
  }

  DeflateFileTest(): void {
    let context: Context = GlobalContext.getContext().getObject("context") as Context
    try {
      let data = context.filesDir
      console.info('directory obtained. Data:' + data);
      DeflateFile(data + '/hello.txt', data + '/hello.txt.deflate')
        .then((isSuccess) => {
          if (isSuccess) {
            AlertDialog.show({
              title: $r("app.string.Compression_succeeded"),
              message: this.getResourceString($r("app.string.Check_out_sandbox_path")) + data + '/test.txt.deflate',
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

  generateTextFile(): void {
    let context: Context = GlobalContext.getContext().getObject("context") as Context
    try {
      let data = context.filesDir
      let writer = fs.openSync(data + '/hello.txt', fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
      fs.writeSync(writer.fd, "hello, world!  adjasjdakjdakjdkjakjdakjskjasdkjaskjdajksdkjasdkjaksjdkja\n"
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