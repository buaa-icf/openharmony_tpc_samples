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
import hilog from '@ohos.hilog';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import testNapi from "libunrar.so"
import fileio from '@ohos.fileio'
import { testRarData } from './dataTestRar5'
import { nameEncryptData } from './dataNameEncrypt'

export default function unrarTest() {
  describe('UnrarTest', function () {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(function () {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
      let srcPath = globalThis.context.filesDir;
      try {
        fileio.mkdirSync(srcPath);
      } catch (err) {

      }
      const writer = fileio.openSync(srcPath + '/testRar5.rar', 0o100 | 0o2, 0o666); //0o102
      const writer2 = fileio.openSync(srcPath + '/name_encrypted.rar', 0o100 | 0o2, 0o666); //0o102
      fileio.writeSync(writer, testRarData.buffer);
      fileio.writeSync(writer2, nameEncryptData.buffer);
      fileio.closeSync(writer);
      fileio.closeSync(writer2);
    })
    beforeEach(function () {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(function () {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(function () {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })

    it('isEncrypted',0, function () {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.

      let path: string = globalThis.context.filesDir + "/name_encrypted.rar";
      try {
        fileio.accessSync(path, 0);
        let tag: number = testNapi.isEncrypted(path);
        let encrypted
        if (tag == 1) {
          encrypted = "name_encrypted.rar是加密文件！"
          expect(true).assertTrue()
        } else {
          expect(false).assertTrue()
          encrypted = "name_encrypted.rar不是加密文件！"
        }

      } catch (err) {
        expect(false).assertTrue()
        //this.showDialog('文件不存在')
      }
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
    })

    it('rarFiles_Extract', 0, function () {
      let srcPath = globalThis.context.filesDir;
      try {
        fileio.mkdirSync(srcPath);
      } catch (err) {

      }
      const writer = fileio.openSync(srcPath + '/testRar5.rar', 0o100 | 0o2, 0o666); //0o102
      fileio.writeSync(writer, testRarData.buffer);
      fileio.closeSync(writer);

      let path: string = globalThis.context.filesDir + '/testRar5.rar';
      try {
        fileio.accessSync(path, 0);

        let value = testNapi.extract(path, globalThis.context.filesDir);
        let resultss;
        if (value == '解压成功') {
          resultss = 'name_encrypted.rar文件解压成功,解压文件在:' + globalThis.context.filesDir;
          expect(true).assertTrue()
        } else {
          expect(false).assertTrue()
          resultss = value;
        }

      } catch (err) {
        expect(false).assertTrue()
        //this.showDialog('文件不存在')
      }

    })

    it('rarFiles_Extract_Encrypted', 0, function () {
      let srcPath = globalThis.context.filesDir;
      try {
        fileio.mkdirSync(srcPath);
      } catch (err) {

      }
      const writer2 = fileio.openSync(srcPath + '/name_encrypted.rar', 0o100 | 0o2, 0o666); //0o102
      fileio.writeSync(writer2, nameEncryptData.buffer);
      fileio.closeSync(writer2);
      let path2: string = globalThis.context.filesDir + "/name_encrypted.rar";
      try {
        fileio.accessSync(path2, 0);
        testNapi.RarFiles_Extract(path2, globalThis.context.filesDir, "190512").then((value) => {
          let resultss;

          if (value == '解压成功') {
            expect(true).assertTrue()
            resultss = '解压testRar5.rar文件解压成功,解压文件在:' + globalThis.context.filesDir;
          } else {
            expect(false).assertTrue()
            resultss = value;
          }
        }).catch((error) => {
          expect(false).assertTrue()
        });

      } catch (err) {
        expect(false).assertTrue()
        //this.showDialog('文件不存在')
      }
    })


  })




}