/*
 * Copyright (C) 2021 Huawei Device Co., Ltd.
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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import adler32 from 'adler-32'

export default function abilityTest() {
  describe('adler32Test', function () {
    beforeAll(function () {
    })
    beforeEach(function () {
    })
    afterEach(function () {
    })
    afterAll(function () {
    })
    it('buf_function_test',0, function () {
      let pam = [
        1,23,56,2,43,98,15,87,56,120
      ];
      let result = 130417142;
      let adler32Result = adler32.buf(pam)
      expect(result).assertEqual(adler32Result)
    })
    it('bstr_function_test',0, function () {
      let pam = "SheetJS";
      let result = 176947863;
      let adler32Result = adler32.bstr(pam)
      expect(result).assertEqual(adler32Result)
    })
    it('bstr_ucs_2function_test',0, function () {
      let pam = "\u2603";
      let result = 262148;
      let adler32Result = adler32.bstr(pam)
      expect(result).assertEqual(adler32Result)
    })
    it('str_function_test',0, function () {
      let pam = "foo bar baz٪☃🍣";
      let result = 1543572022;
      let adler32Result = adler32.str(pam)
      expect(result).assertEqual(adler32Result)
    })
    it('version_function_test',0, function () {
      let result = "1.3.1";
      let adler32Result = adler32.version
      expect(result).assertEqual(adler32Result)
    })
  })
}