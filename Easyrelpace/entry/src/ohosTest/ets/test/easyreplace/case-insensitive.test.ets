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

import { er, Opts } from "easy-replace";

export default function caseinsensitive() {
  describe('caseinsensitive', () => {
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

    let count: number = 0;
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
    // case-insensitive opts flag
    // ==============================
    let optsFunc = (leftOutsideNot:boolean = false,
                    leftOutside:boolean = false,
                    leftMaybe:boolean = false,
                    searchFor:boolean = false,
                    rightMaybe:boolean = false,
                    rightOutside:boolean = false,
                    rightOutsideNot:boolean = false,
                    searchForText:string|string[]="bbb",
                    leftOutsideNotText:string|string[]="",
                    leftOutsideText:string|string[]="",
                    leftMaybeText:string|string[]="a",
                    rightMaybeText:string|string[]="c",
                    rightOutsideText:string|string[]="",
                    rightOutsideNotText:string|string[]=""): Opts => {
      return {
        leftOutsideNot: leftOutsideNotText,
        leftOutside: leftOutsideText,
        leftMaybe: leftMaybeText,
        searchFor: searchForText,
        rightMaybe: rightMaybeText,
        rightOutside:rightOutsideText,
        rightOutsideNot:rightOutsideNotText,
        i: {
          leftOutsideNot,
          leftOutside,
          leftMaybe,
          searchFor,
          rightMaybe,
          rightOutside,
          rightOutsideNot
        }
      }
    }
    test("01 - case-insensitive flag works", () => {
      equal(
        er("zzz abbb zzz", optsFunc(), "yyy"),
        "zzz yyy zzz",
        "test 15.1.1 - all ok, flag off"
      );
      equal(
        er(
          "zzz aBBB zzz", optsFunc(), "yyy"
        ),
        "zzz aBBB zzz",
        "test 15.1.2 - case mismatch, nothing replaced because flag's off"
      );
      equal(
        er("zzz aBBB zzz", optsFunc(false,
          false,
          false,
          true,
          false,
          false,
          false), "yyy"),
        "zzz yyy zzz",
        "test 15.1.3 - case mismatch, but flag allows it, so replace happens"
      );
      equal(
        er("zzz aBBB zzz bbB zzz aBbBc zzz", optsFunc(false,
          false,
          false,
          true,
          false,
          false,
          false)
          ,
          "yyy"
        ),
        "zzz yyy zzz yyy zzz yyy zzz",
        "test 15.1.4 - case-insensitive flag, multiple replacements"
      );
    });

    test("02 - case-insensitive leftMaybe", () => {
      equal(
        er(
          "zzz Abbb zzz",optsFunc() , "yyy"
        ),
        "zzz Ayyy zzz",
        "02.01"
      );
      equal(
        er(
          "zzz Abbb zzz",
          optsFunc(false,
            false,
            true,
            false,
            false,
            false,
            false),
          "yyy"
        ),
        "zzz yyy zzz",
        "02.02"
      );
      equal(
        er(
          "zzz Abbb zzz",
          optsFunc(false,
            false,
            true,
            false,
            false,
            false,
            false,"bBb"),
          "yyy"
        ),
        "zzz Abbb zzz",
        "02.03"
      );
      equal(
        er(
          "zzz Abbb zzz",
          optsFunc(false,
            false,
            true,
            true,
            false,
            false,
            false,"bBb"),
          "yyy"
        ),
        "zzz yyy zzz",
        "02.04"
      );
    });

    test("03 - case-insensitive rightMaybe", () => {
      equal(
        er(
          "zzz bbbC zzz",
          optsFunc(),
          "yyy"
        ),
        "zzz yyyC zzz",
        "03.01"
      );
      equal(
        er(
          "zzz bbbC zzz",
          optsFunc(false,
            false,
            false,
            false,
            true,
            false,
            false),
          "yyy"
        ),
        "zzz yyy zzz",
        "03.02"
      );
      equal(
        er(
          "zzz bbbC zzz",
          optsFunc(false,
            false,
            false,
            false,
            true,
            false,
            false,"bBb"),
          "yyy"
        ),
        "zzz bbbC zzz",
        "03.03"
      );
      equal(
        er(
          "zzz bbbC zzz",
          optsFunc(false,
            false,
            false,
            true,
            true,
            false,
            false,"bBb"),
          "yyy"
        ),
        "zzz yyy zzz",
        "03.04"
      );
    });

    test("04 - case-insensitive leftOutside", () => {
      equal(
        er(
          "zzz Abbb zzz",
          optsFunc(false,false,false,false,false,false,false,"bbb","","a","",""),
          "yyy"
        ),
        "zzz Abbb zzz",
        "04.01"
      );
      equal(
        er(
          "zzz Abbb zzz",
          optsFunc(false,
            true,
            false,
            false,
            false,
            false,
            false,"bbb","","a","",""),
          "yyy"
        ),
        "zzz Ayyy zzz",
        "04.02"
      );
      equal(
        er(
          "zzz Abbb zzz",
          optsFunc(false,
            true,
            false,
            false,
            false,
            false,
            false,"bBb","","a","",""),
          "yyy"
        ),
        "zzz Abbb zzz",
        "04.03"
      );
      equal(
        er(
          "zzz Abbb zzz",
          optsFunc(false,
            true,
            false,
            true,
            false,
            false,
            false,"bBb","","a","",""),
          "yyy"
        ),
        "zzz Ayyy zzz",
        "04.04"
      );
    });

    test("05 - case-insensitive rightOutside", () => {
      equal(
        er(
          "zzz bbbC zzz",
          optsFunc(false,false,false,false,false,false,false,"bbb","","","","","c"),
          "yyy"
        ),
        "zzz bbbC zzz",
        "05.01"
      );
      equal(
        er(
          "zzz bbbC zzz",
          optsFunc(false,
            false,
            false,
            false,
            false,
            true,
            false,"bbb","","","","","c"),
          "yyy"
        ),
        "zzz yyyC zzz",
        "05.02"
      );
      equal(
        er(
          "zzz bbbC zzz", optsFunc(false,
          false,
          false,
          false,
          false,
          true,
          false,"bBb","","","","","c"),
          "yyy"
        ),
        "zzz bbbC zzz",
        "05.03"
      );
      equal(
        er(
          "zzz bbbC zzz", optsFunc(false,
          false,
          false,
          true,
          false,
          true,
          false,"bBb","","","","","c"),
          "yyy"
        ),
        "zzz yyyC zzz",
        "05.04"
      );
    });

    test("06 - case-insensitive leftOutsideNot", () => {
      equal(
        er(
          "zzz Abbb zzz",
          optsFunc(false,
            false,
            false,
            false,
            false,
            false,
            false,"bbb","a","","",""),
          "yyy"
        ),
        "zzz Ayyy zzz",
        "06.01"
      );
      equal(
        er(
          "zzz Abbb zzz",
          optsFunc(true,
            false,
            false,
            false,
            false,
            false,
            false,"bbb","a","","",""),
          "yyy"
        ),
        "zzz Abbb zzz",
        "06.02"
      );
      equal(
        er(
          "zzz Abbb zzz",
          optsFunc(true,
            false,
            false,
            false,
            false,
            false,
            false,"bBb","a","","",""),
          "yyy"
        ),
        "zzz Abbb zzz",
        "06.03"
      );
      equal(
        er(
          "zzz Abbb zzz", optsFunc(true,
          false,
          false,
          true,
          false,
          false,
          false,"bBb","a","","",""),
          "yyy"
        ),
        "zzz Abbb zzz",
        "06.04"
      );
      equal(
        er(
          "zzz Abbb zzz",
          optsFunc(false,
            false,
            false,
            true,
            false,
            false,
            false,"bBb","a","","",""),
          "yyy"
        ),
        "zzz Ayyy zzz",
        "06.05"
      );
    });

    test("07 - case-insensitive rightOutsideNot", () => {
      equal(
        er(
          "zzz bbbC zzz",
          optsFunc(false,
            false,
            false,
            false,
            false,
            false,
            false,"bbb","","","","","","c"),
          "yyy"
        ),
        "zzz yyyC zzz",
        "07.01"
      );
      equal(
        er(
          "zzz bbbC zzz",
          optsFunc(false,
            false,
            false,
            false,
            false,
            false,
            true,"bbb","","","","","","c"),
          "yyy"
        ),
        "zzz bbbC zzz",
        "07.02"
      );
      equal(
        er(
          "zzz bbbC zzz",
          optsFunc(false,
            false,
            false,
            false,
            false,
            false,
            true,"bBb","","","","","","c"),
          "yyy"
        ),
        "zzz bbbC zzz",
        "07.03"
      );
      equal(
        er(
          "zzz bbbC zzz",
          optsFunc(false,
            false,
            false,
            true,
            false,
            false,
            true,"bBb","","","","","","c"),
          "yyy"
        ),
        "zzz bbbC zzz",
        "07.04"
      );
      equal(
        er(
          "zzz bbbC zzz",
          optsFunc(false,
            false,
            false,
            true,
            false,
            false,
            false,"bBb","","","","","","c"),
          "yyy"
        ),
        "zzz yyyC zzz",
        "07.05"
      );
    });
  })
}


