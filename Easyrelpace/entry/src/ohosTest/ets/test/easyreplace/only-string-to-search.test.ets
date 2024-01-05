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

export default function onlystringtosearch() {
  describe('onlystringtosearch', () => {
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
    // only the string to search for
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
    test("01 - replace letter with letter", () => {
      equal(
        er(
          "a b c",optsFunc("","","","b","","",""), "d"
        ),
        "a d c",
        "test 1.1"
      );
      equal(
        er(
          "a b c",optsFunc("","","","b","","",""),
          "d"
        ),
        "a d c",
        "test 1.1"
      );
    });

    test("02 - replace 1 emoji with 1 emoji", () => {
      equal(
        er(
          "🐴 🦄 🐴",optsFunc("","","","🦄","","",""),
          "💖"
        ),
        "🐴 💖 🐴",
        "test 1.2"
      );
    });

    test("03 - replace 3 consecutive emoji with emoji", () => {
      equal(
        er("a 🦄🦄🦄 a",optsFunc("","","","🦄","","",""), "💖"),
        "a 💖💖💖 a",
        "test 1.3"
      );
    });

    test("04 - gorilla emoji - in escaped JS", () => {
      equal(
        er("ljghdfjkgzh\ud83e\udd8dlkgljd",optsFunc("","","","\ud83e\udd8d","","",""), " Gorilla "),
        "ljghdfjkgzh Gorilla lkgljd",
        "test 1.4 - http://unicode-table.com/en/1F98D/"
      );
    });

    test("05 - gorilla emoji - in raw", () => {
      equal(
        er(
          "ljghdfjkgzh🦍lkgljd",optsFunc("","","","🦍","","",""), "gorilla"
        ),
        "ljghdfjkgzhgorillalkgljd",
        "test 1.5 - http://unicode-table.com/en/1F98D/"
      );
    });

    test("06 - won't find a letter", () => {
      equal(
        er("a b c",optsFunc("","","","z","","",""), "d"),
        "a b c",
        "test 1.6"
      );
    });

    test("07 - won't find emoji, with new lines", () => {
      equal(
        er(
          "a\nb\nc",optsFunc("","","","🦄","","",""),
          "d"
        ),
        "a\nb\nc",
        "test 1.7"
      );
    });

    test("08 - replacement with new lines", () => {
      equal(
        er(
          "a\nb",optsFunc("","","","a\nb","","",""),
          "c\nd"
        ),
        "c\nd",
        "test 1.8"
      );
    });

    test("09 - multiple letter findings", () => {
      equal(
        er(
          "a a a a a b",optsFunc("","","","a","","",""),
          "c"
        ),
        "c c c c c b",
        "test 1.9"
      );
    });

    test("10 - single digit of string type replaced", () => {
      equal(
        er(
          "0",optsFunc("","","","0","","",""),
          "1"
        ),
        "1",
        "test 1.10"
      );
    });

    test("11 - single digit of integer type replaced", () => {
      equal(
        er(
          "0",optsFunc("","","","0","","",""),
          "1"
        ),
        "1",
        "test 1.11"
      );
    });

    test("12 - source and replacement are of integer type", () => {
      equal(
        er(
          "0",optsFunc("","","","0","","",""),
          "1"
        ),
        "1",
        "test 1.12"
      );
    });

    test("13 - all raw integers: source, replacement and searchFor", () => {
      equal(
        er(
          "0",optsFunc("","","","0","","",""),
          "1"
        ),
        "1",
        "test 1.13"
      );
    });

    test("14 - multiple consecutive letter replacements", () => {
      equal(
        er(
          "aaavvvvccccc",optsFunc("","","","v","","",""),
          "b"
        ),
        "aaabbbbccccc",
        "test 1.14"
      );
    });
  })
}