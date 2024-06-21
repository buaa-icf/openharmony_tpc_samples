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

import { MinizipNative } from "libminizip_ng.so"
import fs from '@ohos.file.fs';
import { BusinessError } from '@ohos.base';

export function unzipToDirectory(selectPath: string, targetPath: string, password?: string): Promise<string> {
  return new Promise((resolve, reject) => {
    if(!fs.accessSync(selectPath)) {
      reject("selectPath not exists");
    }
    if(!fs.accessSync(targetPath)) {
      fs.mkdirSync(targetPath);
    }
    if(!password) {
      password = ""
    }
    let minizipEntry = new MinizipNative(selectPath);
    let code: number = minizipEntry.Open()
    if(code == 0) {
      let entryNames: Array<string> = minizipEntry.GetEntryNames();
      for(let i = 0; i < entryNames.length; i++) {
        let path: string = targetPath + "/" + entryNames[i];
        if(entryNames[i].endsWith("/")) {
          if(!fs.accessSync(path)) {
            fs.mkdirSync(path);
          }
        } else {
          let arrBuffer: ArrayBuffer | undefined = minizipEntry.ExtractFileToJS(entryNames[i], password);
          if(arrBuffer != undefined) {
            let file = fs.openSync(path, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
            fs.write(file.fd, arrBuffer).then((writeLen: number) => {

            }).catch((err: BusinessError) => {
              reject("fs.write failed: " + entryNames[i])
            }).finally(() => {
              fs.closeSync(file);
            })
          } else {
            reject("ExtractFileToJS failed: " + entryNames[i])
          }
        }
      }
      resolve("unzip success")
    } else {
      reject("Open failed")
    }
  })
}