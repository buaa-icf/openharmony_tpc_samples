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

export function writeCacheDirFile(fileName: string, fileData: string | ArrayBuffer, uiContext: UIContext): string {
  try {
    const path = `${uiContext.getHostContext()?.cacheDir}/${fileName}`;
    const openInfo = fs.openSync(path, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    fs.writeSync(openInfo.fd, fileData);
    uiContext.getPromptAction()
      .showToast({ message: uiContext.getHostContext()?.resourceManager.getStringByNameSync('Log_String1') });
    console.log(uiContext.getHostContext()?.resourceManager.getStringByNameSync('Log_String1') + path)
    return path
  }catch(e){
    console.error(`writeCacheDirFile error, message:` + JSON.stringify(e));
    return "";
  }
}

export async function loadAsyncFromRawFile(fileName: string, uiContext: UIContext): Promise<Uint8Array | void> {
  const resourceManager = uiContext.getHostContext()?.resourceManager;
  if(!resourceManager) {
    return ;
  }
  try {
    const data = await resourceManager.getRawFileContent(fileName);
    uiContext.getPromptAction().showToast({ message: uiContext.getHostContext()?.resourceManager.getStringByNameSync('Log_String2') });

    return data;
  } catch (err) {
    try{
      uiContext.getPromptAction().showToast({ message: uiContext.getHostContext()?.resourceManager.getStringByNameSync('Log_String3')});
    }catch(e){
      console.error(`loadAsyncFromRawFile error, message:` + JSON.stringify(e));
    }
  }
}