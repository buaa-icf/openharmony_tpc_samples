/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { MinizipNative, unzipToDirectory, MinizipCompressNative } from '@ohos/minizip'
import taskpool from '@ohos.taskpool';
import promptAction from '@ohos.promptAction'

@Concurrent
function myAsyncFunction(selectFilePath: string, password: string) {
  let startTime: number = Date.now();
  let minizipEntry = new MinizipNative(selectFilePath);
  minizipEntry.SetCharEncoding(936);
  if (minizipEntry.Open() == 0) {
    let entryNames = minizipEntry.GetEntryNames();
    for (let i = 0; i < entryNames.length; i++) {
      console.log('names:' + entryNames[i]);
      if (!entryNames[i].endsWith("/")) {
        let arrBuffer = minizipEntry.ExtractFileToJS(entryNames[i], password);
        if (arrBuffer != undefined) {
          console.log('' + arrBuffer.byteLength);
        } else {
          console.log('' + arrBuffer);
          promptAction.showToast({
            message: 'unzip failed',
            duration: 1000,
          });
          return;
        }
      }
    }
    let endTime: number = Date.now();
    console.log("unzip time: " + (endTime - startTime));
    promptAction.showToast({
      message: 'unzip success',
      duration: 1000,
    });
  } else {
    promptAction.showToast({
      message: 'unzip failed',
      duration: 1000,
    });
  }
}

@Concurrent
function myAsyncFunction1(selectFilePath: string, targetPath: string, password: string) {
  let startTime: number = Date.now();
  unzipToDirectory(selectFilePath, targetPath, password, 936).then((data: string) => {
    let endTime: number = Date.now();
    console.log("unzip time: " + (endTime - startTime));
    promptAction.showToast({
      message: data,
      duration: 1000,
    });
  }).catch((err: string) => {
    promptAction.showToast({
      message: err,
      duration: 1000,
    });
  });
}

@Concurrent
function myAsyncFunctionCompress(selectFilePath: string, targetPath: string[], password: string) {
  let startTime: number = Date.now();
  let minizipCompressEntry = new MinizipCompressNative(selectFilePath);
  if (minizipCompressEntry.Open() == 0) {
    let code : number = minizipCompressEntry.Compress(targetPath, password);
    if(code == 0){
      console.log('' + code);
    } else {
      console.log('' + code);
      promptAction.showToast({
        message: 'zip failed',
        duration: 1000,
      });
      return;
    }
    let endTime: number = Date.now();
    console.log("zip time: " + (endTime - startTime));
    promptAction.showToast({
      message: 'zip success',
      duration: 1000,
    });
  } else {
    promptAction.showToast({
      message: 'unzip failed',
      duration: 1000,
    });
  }
  minizipCompressEntry.Close();
}

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  @State selectFilePath: string = getContext().filesDir + '/test.zip'
  @State targetPath: string = getContext().filesDir;
  @State password: string = ""; //测试资源密码： 123456
  @State directory: string = "";

  @State selectFilePathCompress: string = getContext().filesDir + '/test_compress.zip'
  @State targetPathCompress: string = getContext().filesDir;
  @State passwordCompress: string = ""; //测试资源密码： 123456
  @State directoryCompress: string[] = [];

  build() {
    Row() {
      Column() {

        TextInput({ placeholder: $r('app.string.input_password')})
          .margin(10)
          .onChange((value: string) => {
            this.password = value;
          })
        Button() {
          Text($r('app.string.Extract'))
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
            .maxLines(1)
            .textAlign(TextAlign.Center)

        }
        .backgroundColor(Color.Blue)
        .width("100%")
        .margin({ right: 8 })
        .onClick(() => {
          this.asyncGet(this.selectFilePath, this.password);
        })

        TextInput({ placeholder: $r('app.string.Extract_folder')})
          .margin(10)
          .onChange((value: string) => {
            this.directory = value;
          })

        Button() {
          Text($r('app.string.Extract_disk'))
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
            .maxLines(1)
            .textAlign(TextAlign.Center)

        }
        .backgroundColor(Color.Blue)
        .width("100%")
        .margin({ right: 8 })
        .onClick(() => {
          this.asyncGet1(this.selectFilePath, this.targetPath + "/" + this.directory, this.password)
        })

        TextInput({ placeholder: $r('app.string.input_password_compress')})
          .margin(10)
          .onChange((value: string) => {
            this.passwordCompress = value;
          })

        TextInput({ placeholder: $r('app.string.Compress_folder')})
          .margin(10)
          .onChange((value: string) => {
            let tmparray = value.split(",");
            for (let index = 0; index < tmparray.length; index++) {
              const element = this.targetPathCompress + "/" + tmparray[index];
              this.directoryCompress.push(element);
            }
          })

        Button() {
          Text($r('app.string.Compress'))
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
            .maxLines(1)
            .textAlign(TextAlign.Center)

        }
        .backgroundColor(Color.Blue)
        .width("100%")
        .margin({ right: 8 })
        .onClick(() => {
          this.asyncGetCompress(this.selectFilePathCompress, this.directoryCompress, this.passwordCompress);
        })
      }
      .width('100%')
    }
    .height('100%')
  }

  async asyncGet(paths: string, password: string): Promise<void> {
    let task: taskpool.Task = new taskpool.Task(myAsyncFunction, paths, password);
    await taskpool.execute(task);
    console.info("taskpool: task end");
  }

  async asyncGet1(selectFilePath: string, targetPath: string, password: string): Promise<void> {
    let task: taskpool.Task = new taskpool.Task(myAsyncFunction1, selectFilePath, targetPath, password);
    await taskpool.execute(task);
    console.info("taskpool: task end");
  }

  async asyncGetCompress(selectFilePath: string, targetPath: string[], password: string): Promise<void> {
    let task: taskpool.Task = new taskpool.Task(myAsyncFunctionCompress, selectFilePath, targetPath, password);
    await taskpool.execute(task);
    console.info("taskpool: task end");
  }
}