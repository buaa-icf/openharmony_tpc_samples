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

export default function searchForoutsides() {
  describe('searchForoutsides', () => {
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
    // searchFor + only outsides
    // ==============================
    let optsFunc = (leftOutsideNot: string | string[] = "",
                    leftOutside: string | string[] = "",
                    leftMaybe: string | string[] = "",
                    searchFor: string | string[] = "",
                    rightMaybe: string | string[] = "",
                    rightOutside: string | string[] = "",
                    rightOutsideNot: string | string[] = "",searchForBool:boolean=false,
                    rightOutsideBool:boolean=false): Opts => {
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
          searchFor: searchForBool,
          rightMaybe: false,
          rightOutside: rightOutsideBool,
          rightOutsideNot: false
        }
      }
    }
    test("01 - both outsides only, emoji, found", () => {
      equal(
        er(
          "🦄 🐴 🦄",optsFunc("","🦄 ","","🐴",""," 🦄",""), "z"
        ),
        "🦄 z 🦄",
        "test 5.1.1"
      );
      equal(
        er(
          "🦄 🐴 🦄",optsFunc("",["🦄 "],"","🐴","",[" 🦄"],""), "z"
        ),
        "🦄 z 🦄",
        "test 5.1.2"
      );
    });

    test("02 - both outsides only, emoji, not found", () => {
      equal(
        er(
          "a 🐴 a",optsFunc("","🦄","","🐴","","🦄",""), "z"
        ),
        "a 🐴 a",
        "test 5.2"
      );
    });

    test("03 - both outsides, emoji, not found", () => {
      equal(
        er(
          "🦄 🐴 a",optsFunc("","🦄","","🐴","","🦄",""), "z"
        ),
        "🦄 🐴 a",
        "test 5.3"
      );
    });

    test("04 - both outsides, emoji, not found #1", () => {
      equal(
        er(
          "a 🐴 a🦄",optsFunc("","🦄","","🐴","","🦄",""), "z"
        ),
        "a 🐴 a🦄",
        "test 5.4"
      );
    });

    test("05 - both outsides, emoji, not found #2", () => {
      equal(
        er(
          "kgldfj lkfjkl jfk \ng \t;lgkh a 🐴 a🦄 slkgj fhjf jkghljk",optsFunc("","🦄","","🐴","","🦄",""), "z"
        ),
        "kgldfj lkfjkl jfk \ng \t;lgkh a 🐴 a🦄 slkgj fhjf jkghljk",
        "test 5.5"
      );
    });

    test("06 - line break as rightOutside, found", () => {
      equal(
        er(
          "aaab\n",optsFunc("","","","b","","\n",""), "c"
        ),
        "aaac\n",
        "test 5.6"
      );
    });

    test("07 - line breaks as both outsides", () => {
      equal(
        er(
          "aaa\nb\n",optsFunc("","\n","","b","","\n",""), "c"
        ),
        "aaa\nc\n",
        "test 5.7"
      );
    });

    test("08 - \\n as outsides, replacement = undefined", () => {
      equal(
        er(
          "aaa\nb\n",optsFunc("","\n","","b","","\n",""), undefined
        ),
        "aaa\n\n",
        "test 5.8"
      );
    });

    test("09 - line breaks as outsides, replacement = Bool", () => {
      equal(
        er(
          "aaa\nb\n",optsFunc("","\n","","b","","\n",""), ""
        ),
        "aaa\n\n",
        "test 5.9"
      );
    });

    test("10 - line breaks as outsides, replacement = null", () => {
      equal(
        er(
          "aaa\nb\n",optsFunc("","\n","","b","","\n",""),null
        ),
        "aaa\n\n",
        "test 5.10"
      );
    });

    test("11 - left outside requirement not satisfied for replacement to happen", () => {
      equal(
        er("aaaBBBccc",optsFunc("","x","","bbb","","z","",true,true),""),
        "aaaBBBccc",
        "test 5.11 - did not replace because of o.leftOutside"
      );
    });

    test("12 - right outside requirement not satisfied for replacement to happen", () => {
      equal(
        er("aaaBBBccc",optsFunc("","x","","bbb","","z","",true,true),""),
        "aaaBBBccc",
        "test 5.12 - did not replace because of o.rightOutside"
      );
    });
  })
}
