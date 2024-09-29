/*
 * Copyright (C) 2023 Huawei Device Co., Ltd.
 * Licensed under the MIT License (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://opensource.org/licenses/MIT
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import fs from '@ohos.file.fs';
import promptAction from '@ohos.promptAction';

let context = getContext();

export function writeCacheDirFile(fileName: string, fileData: string | ArrayBuffer): string {
  const path = `${context.cacheDir}/${fileName}`;
  const openInfo = fs.openSync(path, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.writeSync(openInfo.fd, fileData);
  promptAction.showToast({ message: getContext().resourceManager.getStringByNameSync('Log_String1') });
  console.log(getContext().resourceManager.getStringByNameSync('Log_String1') + path)
  return path
}

export async function loadAsyncFromRawFile(fileName: string): Promise<Uint8Array | void> {
  const resourceManager = context.resourceManager;
  try {
    const data = await resourceManager.getRawFileContent(fileName);
    promptAction.showToast({ message: getContext().resourceManager.getStringByNameSync('Log_String2') });

    return data;
  } catch (err) {
    promptAction.showToast({ message: getContext().resourceManager.getStringByNameSync('Log_String3')});
  }
}