/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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
import JSZip from "jszip";
import fileio from '@ohos.fileio';
import { zipCompress, zipDeCompress } from '../zip/zipApi';

@Entry
@Component
export struct ZipTest {
  TAG: string = "Test----";
  @State newFolder: string = 'newFolder';
  @State timejsZip: number = 0;
  @State timejsUNZip: number = 0;
  @State timejspassZip: number = 0;
  @State timejsunpassZip: number = 0;
  preTimestamp: number = 0;
  newName: string = 'hello.txt'
  password: string = '123'
  unpassword: string

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
      Text('zip4j相关功能')
        .fontSize(20)
        .margin({ top: 16 })

      Text('点击生成hello.txt')
        .fontSize(16)
        .margin({ top: 32 })
        .padding(8)
        .border({ width: 2, color: '#535353', radius: 6 })
        .onClick((event) => {
          this.generateTextFile()
        })

      Text('点击压缩hello.txt为zip文件')
        .fontSize(16)
        .margin({ top: 32 })
        .padding(8)
        .border({ width: 2, color: '#535353', radius: 6 })
        .onClick((event) => {
          this.jsZipTest()
        })

      Text('压缩zip文件时间：' + this.timejsZip)
        .fontSize(20)
        .margin({ top: 16 })


      Text('点击解压zip文件')
        .fontSize(16)
        .margin({ top: 32 })
        .padding(8)
        .border({ width: 2, color: '#535353', radius: 6 })
        .onClick((event) => {
          this.unJsZipTest()
        })

      Text('解压zip文件时间：' + this.timejsUNZip)
        .fontSize(20)
        .margin({ top: 16 })

      TextInput({ placeholder: '请输压缩文件的名称 如： hello.txt' })
        .caretColor(Color.Blue)
        .height(50)
        .fontSize(30)
        .onChange((value) => {
          this.newName = value
        })

      TextInput({ placeholder: '请输入密码 如： 123456' })
        .caretColor(Color.Blue)
        .height(50)
        .fontSize(30)
        .onChange((value) => {
          this.password = value
        })


      Text('点击加密压缩zip文件')
        .fontSize(16)
        .margin({ top: 32 })
        .padding(8)
        .border({ width: 2, color: '#535353', radius: 6 })
        .onClick((event) => {
          this.jsZipEncryption(this.password, this.newName)
        })

      Text('加密压缩zip文件时间：' + this.timejspassZip)
        .fontSize(20)
        .margin({ top: 16 })

      TextInput({ placeholder: '请输入密码 如： 123456' })
        .caretColor(Color.Blue)
        .height(50)
        .fontSize(30)
        .onChange((value) => {
          this.unpassword = value
        })


      Text('点击解压加密zip文件')
        .fontSize(16)
        .margin({ top: 32 })
        .padding(8)
        .border({ width: 2, color: '#535353', radius: 6 })
        .onClick((event) => {
          this.jsZipUnEncryption(this.unpassword)
        })

      Text('解压加密zip文件时间：' + this.timejsunpassZip)
        .fontSize(20)
        .margin({ top: 16 })
    }
    .width('100%')
    .height('100%')
  }

  aboutToAppear() {
  }

  generateTextFile(): void {
    try {
      var data = globalThis.context.filesDir
      const writer = fileio.openSync(data + this.newFolder + '/hello.txt', 0o102, 0o666);
      fileio.writeSync(writer, "hello, world!  adjasjdakjdakjdkjakjdakjskjasdkjaskjdajksdkjasdkjaksjdkja\n"
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
      fileio.closeSync(writer);
      AlertDialog.show({ title: '生成成功',
        message: '请查看手机路径' + data + '/' + this.newFolder + '/hello.txt',
        confirm: { value: 'OK', action: () => {
        } }
      })
    } catch (error) {
      console.error('File to obtain the file directory. Cause: ' + error.message);
    }
  }

  jsZipTest(): void {
    try {
      var data = globalThis.context.filesDir
      let time = Date.now()
      zipCompress(data + '/' + this.newFolder, data + '/' + this.newFolder + '/' + this.newFolder + '.zip').then((isSuccess) => {
        if (isSuccess) {
          AlertDialog.show({ title: '压缩成功',
            message: '请查看手机路径 ' + data + '/' + this.newFolder,
            confirm: { value: 'OK', action: () => {
            } }
          })
          let time1 = Date.now()
          this.timejsZip = time1 - time
        } else {
          AlertDialog.show({ title: '压缩失败',
            message: '请重新尝试',
            confirm: { value: 'OK', action: () => {
            } }
          })
        }
      })
    } catch (error) {
      console.error('File to obtain the file directory. Cause: ' + error.message);
    }
  }

  unJsZipTest(): void {
    try {
      var data = globalThis.context.filesDir
      let time = Date.now()
      zipDeCompress(data + '/' + this.newFolder + '/' + this.newFolder + '.zip', data + '/newTarget')
        .then((isZipDecompree) => {
          if (isZipDecompree) {
            AlertDialog.show({ title: '解缩成功',
              message: '请查看手机路径 ' + data + "/newTarget",
              confirm: { value: 'OK', action: () => {
              } }
            })
          } else {
            AlertDialog.show({ title: '解压失败',
              message: '请重新尝试',
              confirm: { value: 'OK', action: () => {
              } }
            })
          }
        })
      let time1 = Date.now()
      this.timejsUNZip = time1 - time
    } catch (error) {
      console.error('File to obtain the file directory. Cause: ' + error.message);
    }
  }

  async jsZipEncryption(password: string, name: string) {
    try {

      let data = globalThis.context.filesDir + '/' + this.newFolder + '/' + name;
      const stat = fileio.statSync(data);
      const reader = fileio.openSync(data, 0o2);
      const buf = new ArrayBuffer(stat.size);
      fileio.readSync(reader, buf);

      let time = Date.now()
      const zip = new JSZip();
      zip.file(name, buf);

      const content = await zip.generateAsync({
        type: 'arraybuffer',
        // @ts-ignore
        password: password,
        encryptStrength: 3
      });
      let time1 = Date.now()
      this.timejspassZip = time1 - time
      let path = globalThis.context.filesDir + '/helloTest.zip'
      const open = fileio.openSync(path, 0o102, 0o666);
      fileio.writeSync(open, content);
      fileio.closeSync(open)
      this.newName = name
      AlertDialog.show({ title: '压缩成功',
        message: '请查看手机路径 ' + data + '/',
        confirm: { value: 'OK', action: () => {
        } }
      })

    } catch (err) {
      console.error('File to obtain the file directory. Cause: ' + err);
      AlertDialog.show({ title: '压缩失败',
        message: '请重新尝试',
        confirm: { value: 'OK', action: () => {
        } }
      })

    }
  }

  jsZipUnEncryption(unpassword: string) {
    let path = globalThis.context.filesDir + '/helloTest.zip'
    let target = globalThis.context.filesDir + '/target'
    let time = Date.now()
    zipDeCompress(path, target, unpassword).then((data) => {
      let time1 = Date.now()
      this.timejsunpassZip = time1 - time
      if (data) {
        AlertDialog.show({ title: '解缩成功',
          message: '请查看手机路径 ' + target,
          confirm: { value: 'OK', action: () => {
          } }
        })
      } else {
        AlertDialog.show({ title: '解压失败',
          message: '请重新尝试',
          confirm: { value: 'OK', action: () => {
          } }
        })
      }

    }).catch((error) => {
      console.error('File to obtain the file directory. Cause: ' + error.message);
    });

  }
}
