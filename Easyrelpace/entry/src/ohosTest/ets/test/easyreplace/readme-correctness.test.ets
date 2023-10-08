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

import { er,Opts } from "easy-replace";

export default function readmecorrectness() {
  describe('readmecorrectness', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
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
    // it('assertContain',0, function () {
    //   // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
    //   hilog.isLoggable(0x0000, 'testTag', hilog.LogLevel.INFO);
    //   hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
    //   let a = 'abc'
    //   let b = 'b'
    //   // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
    //   expect(a).assertContain(b)
    //   expect(a).assertEqual(a)
    // })

    let count = 0;
    let test = (name: string, func: Function) => {
      name = name.replace(new RegExp("/[ /d]/g"), '');
      name = name.replace(new RegExp("/-/g"), "");
      it(name, count++, func)
    }

    let equal = (src: string, dst: string, tag: string) => {
      console.log('tag:' + tag + "  src=" + src + " dst=" + dst);
      expect(src).assertEqual(dst)
    }
    // ==============================
    // double-check the README's corectness
    // ==============================
    let optsFunc = (leftOutsideNot: string | string[] = "",
                    leftOutside: string | string[] = "",
                    leftMaybe: string | string[] = "",
                    searchFor: string | string[] = "",
                    rightMaybe: string | string[] = "",
                    rightOutside: string | string[] = "",
                    rightOutsideNot: string | string[] = ""): Opts => {
      return {
        leftOutsideNot,
        leftOutside,
        leftMaybe,
        searchFor,
        rightMaybe,
        rightOutside,
        rightOutsideNot,
        i: {
          leftOutsideNot: false,
          leftOutside: false,
          leftMaybe: false,
          searchFor: false,
          rightMaybe: false,
          rightOutside: false,
          rightOutsideNot: false
        }
      }
    }
    test("01 - readme example #1", () => {
      equal(
        er("a x c x d",optsFunc("","","","x","","",""), "🦄"),
        "a 🦄 c 🦄 d",
        "test 13.1"
      );
    });

    test("02 - readme example #2", () => {
      equal(
        er("🐴i🦄 🐴i i🦄 i",optsFunc("","",["🐴", "🦄"],"i",["🐴", "🦄"],"",""), "x"
        ),
        "x x x x",
        "test 13.2"
      );
    });

    test("03 - readme example #3", () => {
      equal(
        er("a🦄c x🦄x",optsFunc("","","","🦄","","",["c", "d"]), "🐴"),
        "a🦄c x🐴x",
        "test 13.3"
      );
    });

    test("04 - readme example #4", () => {
      equal(
        er("zzzzz  zzzzzz zzzzzz",optsFunc(""," ",""," ","","",""), ""),
        "zzzzz zzzzzz zzzzzz",
        "test 13.4"
      );
    });

    test("05 - readme example #5", () => {
      equal(
        er(
          "<br /><br/><br />",optsFunc(" ","","","/>","","",""), " />"
        ),
        "<br /><br /><br />",
        "test 13.5"
      );
    });

    test("06 - readme example #6", () => {
      equal(
        er("&nbsp; nbsp &nbsp nbsp;",optsFunc("","","&","nbsp",";","",""), "&nbsp;"),
        "&nbsp; &nbsp; &nbsp; &nbsp;",
        "test 13.6"
      );
    });

  })
}
