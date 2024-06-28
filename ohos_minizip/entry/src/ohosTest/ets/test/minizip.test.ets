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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { MinizipNative, unzipToDirectory } from '@ohos/minizip'
import { GlobalContext } from './globalThis'

export default function miniZipTest() {
  let filesDir : string = ""
  describe('miniZipTestTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
      let gloContext: Context = GlobalContext.getContext().getObject("context") as Context
      filesDir = gloContext.createModuleContext('entry_test').filesDir
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    it('MinizipNative', 0, () => {
      let selectFilePath : string = filesDir + '/test.zip'
      let minizipEntry = new MinizipNative(selectFilePath);
      if(minizipEntry.Open() == 0){
        let entryNames = minizipEntry.GetEntryNames();
        for (let i = 0; i < entryNames.length; i++) {
          console.log('names:' + entryNames[i]);
          if(!entryNames[i].endsWith("/")) {
            let arrBuffer = minizipEntry.ExtractFileToJS(entryNames[i], "123456");
            expect(arrBuffer?.byteLength !== 0).assertTrue()
          }
        }
      }
    })

    it('unzipToDirectory', 0, async () => {
      let selectFilePath : string = filesDir + '/test.zip'
      let targetPath: string = filesDir + "/target"
      let password: string = "123456"
      let result: string = await unzipToDirectory(selectFilePath, targetPath, password)
      expect(result).assertEqual("unzip success")
    })
  })
}