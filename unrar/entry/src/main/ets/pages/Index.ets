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
import { ICallBack, UnrarApi } from "@ohos/unrar";
import fileio from '@ohos.fileio'
import { testRarData } from './dataTestRar5'
import { nameEncryptData } from './dataNameEncrypt'
import { GlobalContext } from './GlobalContext'

let context: Context = GlobalContext.getContext().getObject('context') as Context

@Entry
@Component
struct Index {
  @State message: string = 'Rar文件解压'
  @State results: string = ''
  @State password: string = ''
  @State tag: boolean = true
  getResourceString(res: Resource) {
    return getContext().resourceManager.getStringSync(res.id)
  }
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogExample({
      cancel: this.onCancel,
      confirm: this.onAccept,
      password: $password,
      tag: $tag
    }),
    cancel: this.existApp,
    autoCancel: true
  })

  onCancel() {
    console.info('Callback when the first button is clicked  ' + this.password)
  }

  onAccept() {
    console.info('Callback when the second button is clicked')
  }

  existApp() {
    console.info('Click the callback in the blank area')
  }

  build() {
    Row() {
      Column() {
        Text($r('app.string.rar_file'))
          .fontSize(50)
          .fontWeight(FontWeight.Bold);

        Button($r('app.string.name_encrypted'), { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .margin(40)
          .backgroundColor(0x317aff)
          .height(50)
          .width(300)
          .onClick(() => {
            if (!this.tag) {
              this.showDialog(this.getResourceString($r('app.string.please_wait')))
              return;
            }
            //hdc_std file send C:\Users\admin\Desktop\鸿蒙openharmony.rar /data/app/el2/100/base/com.huawei.ohosunrar/haps/entry/files
            let path: string = context.filesDir + "/name_encrypted.rar";
            // const path: string = (() => {
            //   return this.context.filesDir + "/name_encrypted.rar";
            // })();

            try {
              fileio.accessSync(path, 0);
              let tag: number = UnrarApi.isEncrypted(path);
              let encrypted: string
              if (tag == 1) {
                encrypted = this.getResourceString($r('app.string.name_encrypted2'))
              } else {
                encrypted = this.getResourceString($r('app.string.name_encrypted2_no'))
              }
              this.showDialog(encrypted)
            } catch (err) {
              this.showDialog(this.getResourceString($r('app.string.file_exist')))
            }
          })

        Button($r('app.string.testRar5'), { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .margin(40)
          .backgroundColor(0x317aff)
          .height(50)
          .width(300)
          .onClick(() => {
            if (!this.tag) {
              this.showDialog(this.getResourceString($r('app.string.please_wait')))
              return;
            }
            let path: string = context.filesDir + "/testRar5.rar";
            try {
              fileio.accessSync(path, 0);
              let tag: number = UnrarApi.isEncrypted(path);
              let encrypted: string = ''
              if (tag == 1) {
                encrypted = this.getResourceString($r('app.string.name_testRar2'))
              } else {
                encrypted = this.getResourceString($r('app.string.name_testRar2_no'))
              }
              this.showDialog(encrypted)
            } catch (err) {
              this.showDialog(this.getResourceString($r('app.string.file_exist')) )
            }
          })

        Button($r('app.string.decompress_testRar5'), { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .margin(40)
          .height(50)
          .width(300)
          .onClick(() => {
            this.extract();
          })

        Button($r('app.string.decompress_encrypted'), { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .margin(40)
          .height(50)
          .width(300)
          .onClick(() => {
            if (!this.tag) {
              this.showDialog(this.getResourceString($r('app.string.please_wait')))
              return;
            }
            this.dialogController.open();
          })
      }
      .width('100%')
    }
    .height('100%')
  }

  private extract() {
    if (!this.tag) {
      this.showDialog(this.getResourceString($r('app.string.please_wait')))
      return;
    }
    let path: string = context.filesDir + "/testRar5.rar";
    try {
      fileio.accessSync(path, 0);
      this.tag = false;
      let that = this;
      let callBack: ICallBack = {
        callBackResult(value: string) {
          let results: string = '';
          that.tag = true;
          if (value == '解压成功') {
            results = '' + context.filesDir;
            that.showDialog(results,$r('app.string.Extract_testRar5'))
          } else {
            results = value;
            that.showDialog(results)
          }
          that.tag = true;

        }
      }
      UnrarApi.RarFiles_Extract(path, context.filesDir, callBack)
    } catch (err) {
      this.tag = true;
      this.showDialog(this.getResourceString($r('app.string.successfully')))
    }
  }

  aboutToAppear() {
    let path: string = context.filesDir;
    this.generateTextFile(path, '/testRar5.rar', testRarData);
    this.generateTextFile(path, '/name_encrypted.rar', nameEncryptData);
  }

  generateTextFile(data: string, fileName: string, arr: Int8Array | Int32Array): void {
    let srcPath = data;
    try {
      fileio.mkdirSync(srcPath);
    } catch (err) {

    }
    const writer = fileio.openSync(srcPath + fileName, 0o100 | 0o2, 0o666); //0o102
    fileio.writeSync(writer, arr.buffer);
    fileio.closeSync(writer);
  }

  showDialog(message: string,title?:ResourceStr) {
    AlertDialog.show(
      {
        title: title,
        message: message,
        confirm: {
          value: 'OK',
          action: () => {
          }
        }
      }
    )
  }
}


@CustomDialog
struct CustomDialogExample {
  @Link password: string
  @Link tag: boolean
  passwords: string = ''
  controller?: CustomDialogController
  cancel: () => void = () => {
  }
  confirm: () => void = () => {
  }
  getResourceString(res: Resource) {
    return getContext().resourceManager.getStringSync(res.id)
  }
  build() {
    Column() {
      Text($r('app.string.Please_input')).width('70%').fontSize(20).margin({ top: 10, bottom: 10 })
      TextInput({ placeholder: 'input your password: 190512' })
        .type(InputType.Password).margin({ top: 20 }).onChange((value) => {
        this.password = value
        this.passwords = value
      })
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button($r('app.string.cancel'))
          .onClick(() => {
            this.controller!.close()
            this.cancel()
          }).backgroundColor(0xffffff).fontColor(Color.Black)
        Button($r('app.string.confirm'))
          .onClick(() => {
            this.rarFiles_Extract();
          }).backgroundColor(0xffffff).fontColor(Color.Red)
      }.margin({ bottom: 10 })
    }.width('100%').height('30%')
  }

  private rarFiles_Extract() {
    if (this.passwords == null || this.passwords == "") {
      this.passwords = ""
      this.showDialog(this.getResourceString($r('app.string.Please_input')))
    } else {
      this.passwords = ""
      let passwords = this.password;
      let path: string = context.filesDir + "/name_encrypted.rar";
      try {
        let tags = fileio.accessSync(path, 0);
        let that = this;
        that.tag = false;

        let callBack: ICallBack = {
          callBackResult(value: string) {
            let results: string = '';
            if (value == '解压成功') {
              results = ''+ context.filesDir;
              that.showDialog(results,$r('app.string.Extract_encrypted'))
            } else {
              results = value;
              that.showDialog(results)
            }

          }
        }
        UnrarApi.RarFiles_Extract(path, context.filesDir, callBack, passwords);
        this.tag = true;
        console.info('accessSync .rar文件+path：' + tags)
      } catch (err) {
        this.tag = true;
        console.info("accessSync failed with error:" + err);
        this.showDialog(this.getResourceString($r('app.string.file_exist')))
      }
      this.controller!.close()
      this.confirm()
    }
  }

  showDialog(message: string,title?:ResourceStr) {
    AlertDialog.show(
      {
        title: title,
        message: message,
        confirm: {
          value: 'OK',
          action: () => {
          }
        }
      }
    )
  }
}