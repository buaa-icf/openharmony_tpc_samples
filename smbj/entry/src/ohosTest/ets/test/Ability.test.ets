/*
 * (The MIT License)

 * Copyright (c) 2021 Huawei Device Co., Ltd.

 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * 'Software'), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:

 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.

 * THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
 * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium'
import { SMB2} from '@ohos/smbj'


export default function abilityTest() {
  var client;
  describe('SmbjTest', function () {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(function () {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
      client = new SMB2(
        {
          share: '\\\\10.50.40.44\\test_smbj',
          domain:'DOMAIN',
          username: 'Administrator',
          password: 'ck123321ck',
          clientIP:'10.50.40.52'
        }
      )
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
    it('exists', 0, function () {
      client.exists('test.txt', function (err, exit) {
        if (err) {
          console.log('smb erro:' + err.message)
          expect().assertFail()
          throw err;

        }
        expect(exit).assertTrue()
      })
    })
    it('mkdir', 0, function () {
      client.exists('chen', function (err) {

        expect(err).assertNull()
      })
    })
    it('readdir', 0, function () {
      client.readdir('songy', function (err,fileNames) {
        expect(fileNames.length).assertEqual(1)
      })
    })
    it('readFile', 0, function () {
      client.readFile('ss.txt' , null, (err,result) => {
        expect(result).assertEqual('1234567')
      })
    })
    it('rename', 0, function () {
      client.rename('test','retest', function (err) {
        expect(err).assertNull()
      })
    })
    it('writeFile', 0, function () {
      client.writeFile('chen.txt','1234455','UTF-8', function (err) {
        expect(err).assertNull()
      })
    })
    it('rmdir', 0, function () {
      client.rmdir('test1',(err,files)=> {
        expect(err).assertNull()
      })
    })
    it('unlink', 0, function () {
      client.unlink('songy\\st.txt',(err,result) =>{
        expect(err).assertNull()
      })
    })

  })
}