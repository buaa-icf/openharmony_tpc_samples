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


import { er } from "easy-replace";

export default function caseinsensitive() {
  describe('caseinsensitive', function () {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(function () {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
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

    var count = 0;
    var test = function (name, func){
     name = name.replace(/[ /d]/g, '');
     name = name.replace(/-/g,"");
      it(name,count++,func)
    }

    var equal = function (src,dst,tag){
      console.log('tag:'+tag+"  src="+src+ " dst="+dst);
      expect(src).assertEqual(dst)
    }


    // ==============================
    // case-insensitive opts flag
    // ==============================

    test("01 - case-insensitive flag works", () => {
      equal(
        er(
          "zzz abbb zzz",
          // @ts-ignore
          {
            leftOutsideNot: "",
            leftOutside: "",
            leftMaybe: "a",
            searchFor: "bbb",
            rightMaybe: "c",
            rightOutside: "",
            rightOutsideNot: "",
          },
          "yyy"
        ),
        "zzz yyy zzz",
        "test 15.1.1 - all ok, flag off"
      );
      equal(
        er(
          "zzz aBBB zzz",
          // @ts-ignore
          {
            leftOutsideNot: "",
            leftOutside: "",
            leftMaybe: "a",
            searchFor: "bbb",
            rightMaybe: "c",
            rightOutside: "",
            rightOutsideNot: "",
          },
          "yyy"
        ),
        "zzz aBBB zzz",
        "test 15.1.2 - case mismatch, nothing replaced because flag's off"
      );
      equal(
        er(
          "zzz aBBB zzz",
          {
            leftOutsideNot: "",
            leftOutside: "",
            leftMaybe: "a",
            searchFor: "bbb",
            rightMaybe: "c",
            rightOutside: "",
            rightOutsideNot: "",
            // @ts-ignore
            i: {
              searchFor: true,
            },
          },
          "yyy"
        ),
        "zzz yyy zzz",
        "test 15.1.3 - case mismatch, but flag allows it, so replace happens"
      );
      equal(
        er(
          "zzz aBBB zzz bbB zzz aBbBc zzz",
          {
            leftOutsideNot: "",
            leftOutside: "",
            leftMaybe: "a",
            searchFor: "bbb",
            rightMaybe: "c",
            rightOutside: "",
            rightOutsideNot: "",
            // @ts-ignore
            i: {
              searchFor: true,
            },
          },
          "yyy"
        ),
        "zzz yyy zzz yyy zzz yyy zzz",
        "test 15.1.4 - case-insensitive flag, multiple replacements"
      );
    });

    test("02 - case-insensitive leftMaybe", () => {
      equal(
        er(
          "zzz Abbb zzz",
          // @ts-ignore
          {
            leftOutsideNot: "",
            leftOutside: "",
            leftMaybe: "a",
            searchFor: "bbb",
            rightMaybe: "c",
            rightOutside: "",
            rightOutsideNot: "",
          },
          "yyy"
        ),
        "zzz Ayyy zzz",
        "02.01"
      );
      equal(
        er(
          "zzz Abbb zzz",
          {
            leftOutsideNot: "",
            leftOutside: "",
            leftMaybe: "a",
            searchFor: "bbb",
            rightMaybe: "c",
            rightOutside: "",
            rightOutsideNot: "",
            // @ts-ignore
            i: {
              leftMaybe: true,
            },
          },
          "yyy"
        ),
        "zzz yyy zzz",
        "02.02"
      );
      equal(
        er(
          "zzz Abbb zzz",
          {
            leftOutsideNot: "",
            leftOutside: "",
            leftMaybe: "a",
            searchFor: "bBb",
            rightMaybe: "c",
            rightOutside: "",
            rightOutsideNot: "",
            // @ts-ignore
            i: {
              leftMaybe: true,
            },
          },
          "yyy"
        ),
        "zzz Abbb zzz",
        "02.03"
      );
      equal(
        er(
          "zzz Abbb zzz",
          {
            leftOutsideNot: "",
            leftOutside: "",
            leftMaybe: "a",
            searchFor: "bBb",
            rightMaybe: "c",
            rightOutside: "",
            rightOutsideNot: "",
            // @ts-ignore
            i: {
              leftMaybe: true,
              searchFor: true,
            },
          },
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
          // @ts-ignore
          {
            leftOutsideNot: "",
            leftOutside: "",
            leftMaybe: "a",
            searchFor: "bbb",
            rightMaybe: "c",
            rightOutside: "",
            rightOutsideNot: "",
          },
          "yyy"
        ),
        "zzz yyyC zzz",
        "03.01"
      );
      equal(
        er(
          "zzz bbbC zzz",
          {
            leftOutsideNot: "",
            leftOutside: "",
            leftMaybe: "a",
            searchFor: "bbb",
            rightMaybe: "c",
            rightOutside: "",
            rightOutsideNot: "",
            // @ts-ignore
            i: {
              rightMaybe: true,
            },
          },
          "yyy"
        ),
        "zzz yyy zzz",
        "03.02"
      );
      equal(
        er(
          "zzz bbbC zzz",
          {
            leftOutsideNot: "",
            leftOutside: "",
            leftMaybe: "a",
            searchFor: "bBb",
            rightMaybe: "c",
            rightOutside: "",
            rightOutsideNot: "",
            // @ts-ignore
            i: {
              rightMaybe: true,
            },
          },
          "yyy"
        ),
        "zzz bbbC zzz",
        "03.03"
      );
      equal(
        er(
          "zzz bbbC zzz",
          {
            leftOutsideNot: "",
            leftOutside: "",
            leftMaybe: "a",
            searchFor: "bBb",
            rightMaybe: "c",
            rightOutside: "",
            rightOutsideNot: "",
            // @ts-ignore
            i: {
              rightMaybe: true,
              searchFor: true,
            },
          },
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
          // @ts-ignore
          {
            leftOutsideNot: "",
            leftOutside: "a",
            leftMaybe: "",
            searchFor: "bbb",
            rightMaybe: "",
            rightOutside: "",
            rightOutsideNot: "",
          },
          "yyy"
        ),
        "zzz Abbb zzz",
        "04.01"
      );
      equal(
        er(
          "zzz Abbb zzz",
          {
            leftOutsideNot: "",
            leftOutside: "a",
            leftMaybe: "",
            searchFor: "bbb",
            rightMaybe: "",
            rightOutside: "",
            rightOutsideNot: "",
            // @ts-ignore
            i: {
              leftOutside: true,
            },
          },
          "yyy"
        ),
        "zzz Ayyy zzz",
        "04.02"
      );
      equal(
        er(
          "zzz Abbb zzz",
          {
            leftOutsideNot: "",
            leftOutside: "a",
            leftMaybe: "",
            searchFor: "bBb",
            rightMaybe: "",
            rightOutside: "",
            rightOutsideNot: "",
            // @ts-ignore
            i: {
              leftOutside: true,
            },
          },
          "yyy"
        ),
        "zzz Abbb zzz",
        "04.03"
      );
      equal(
        er(
          "zzz Abbb zzz",
          {
            leftOutsideNot: "",
            leftOutside: "a",
            leftMaybe: "",
            searchFor: "bBb",
            rightMaybe: "",
            rightOutside: "",
            rightOutsideNot: "",
            // @ts-ignore
            i: {
              leftOutside: true,
              searchFor: true,
            },
          },
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
          // @ts-ignore
          {
            leftOutsideNot: "",
            leftOutside: "",
            leftMaybe: "",
            searchFor: "bbb",
            rightMaybe: "",
            rightOutside: "c",
            rightOutsideNot: "",
          },
          "yyy"
        ),
        "zzz bbbC zzz",
        "05.01"
      );
      equal(
        er(
          "zzz bbbC zzz",
          {
            leftOutsideNot: "",
            leftOutside: "",
            leftMaybe: "",
            searchFor: "bbb",
            rightMaybe: "",
            rightOutside: "c",
            rightOutsideNot: "",
            // @ts-ignore
            i: {
              rightOutside: true,
            },
          },
          "yyy"
        ),
        "zzz yyyC zzz",
        "05.02"
      );
      equal(
        er(
          "zzz bbbC zzz",
          {
            leftOutsideNot: "",
            leftOutside: "",
            leftMaybe: "",
            searchFor: "bBb",
            rightMaybe: "",
            rightOutside: "c",
            rightOutsideNot: "",
            // @ts-ignore
            i: {
              rightOutside: true,
            },
          },
          "yyy"
        ),
        "zzz bbbC zzz",
        "05.03"
      );
      equal(
        er(
          "zzz bbbC zzz",
          {
            leftOutsideNot: "",
            leftOutside: "",
            leftMaybe: "",
            searchFor: "bBb",
            rightMaybe: "",
            rightOutside: "c",
            rightOutsideNot: "",
            // @ts-ignore
            i: {
              rightOutside: true,
              searchFor: true,
            },
          },
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
          // @ts-ignore
          {
            leftOutsideNot: "a",
            leftOutside: "",
            leftMaybe: "",
            searchFor: "bbb",
            rightMaybe: "",
            rightOutside: "",
            rightOutsideNot: "",
          },
          "yyy"
        ),
        "zzz Ayyy zzz",
        "06.01"
      );
      equal(
        er(
          "zzz Abbb zzz",
          {
            leftOutsideNot: "a",
            leftOutside: "",
            leftMaybe: "",
            searchFor: "bbb",
            rightMaybe: "",
            rightOutside: "",
            rightOutsideNot: "",
            // @ts-ignore
            i: {
              leftOutsideNot: true,
            },
          },
          "yyy"
        ),
        "zzz Abbb zzz",
        "06.02"
      );
      equal(
        er(
          "zzz Abbb zzz",
          {
            leftOutsideNot: "a",
            leftOutside: "",
            leftMaybe: "",
            searchFor: "bBb",
            rightMaybe: "",
            rightOutside: "",
            rightOutsideNot: "",
            // @ts-ignore
            i: {
              leftOutsideNot: true,
            },
          },
          "yyy"
        ),
        "zzz Abbb zzz",
        "06.03"
      );
      equal(
        er(
          "zzz Abbb zzz",
          {
            leftOutsideNot: "a",
            leftOutside: "",
            leftMaybe: "",
            searchFor: "bBb",
            rightMaybe: "",
            rightOutside: "",
            rightOutsideNot: "",
            // @ts-ignore
            i: {
              leftOutsideNot: true,
              searchFor: true,
            },
          },
          "yyy"
        ),
        "zzz Abbb zzz",
        "06.04"
      );
      equal(
        er(
          "zzz Abbb zzz",
          {
            leftOutsideNot: "a",
            leftOutside: "",
            leftMaybe: "",
            searchFor: "bBb",
            rightMaybe: "",
            rightOutside: "",
            rightOutsideNot: "",
            // @ts-ignore
            i: {
              leftOutsideNot: false,
              searchFor: true,
            },
          },
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
          // @ts-ignore
          {
            leftOutsideNot: "",
            leftOutside: "",
            leftMaybe: "",
            searchFor: "bbb",
            rightMaybe: "",
            rightOutside: "",
            rightOutsideNot: "c",
          },
          "yyy"
        ),
        "zzz yyyC zzz",
        "07.01"
      );
      equal(
        er(
          "zzz bbbC zzz",
          {
            leftOutsideNot: "",
            leftOutside: "",
            leftMaybe: "",
            searchFor: "bbb",
            rightMaybe: "",
            rightOutside: "",
            rightOutsideNot: "c",
            // @ts-ignore
            i: {
              rightOutsideNot: true,
            },
          },
          "yyy"
        ),
        "zzz bbbC zzz",
        "07.02"
      );
      equal(
        er(
          "zzz bbbC zzz",
          {
            leftOutsideNot: "",
            leftOutside: "",
            leftMaybe: "",
            searchFor: "bBb",
            rightMaybe: "",
            rightOutside: "",
            rightOutsideNot: "c",
            // @ts-ignore
            i: {
              rightOutsideNot: true,
            },
          },
          "yyy"
        ),
        "zzz bbbC zzz",
        "07.03"
      );
      equal(
        er(
          "zzz bbbC zzz",
          {
            leftOutsideNot: "",
            leftOutside: "",
            leftMaybe: "",
            searchFor: "bBb",
            rightMaybe: "",
            rightOutside: "",
            rightOutsideNot: "c",
            // @ts-ignore
            i: {
              rightOutsideNot: true,
              searchFor: true,
            },
          },
          "yyy"
        ),
        "zzz bbbC zzz",
        "07.04"
      );
      equal(
        er(
          "zzz bbbC zzz",
          {
            leftOutsideNot: "",
            leftOutside: "",
            leftMaybe: "",
            searchFor: "bBb",
            rightMaybe: "",
            rightOutside: "",
            rightOutsideNot: "c",
            // @ts-ignore
            i: {
              rightOutsideNot: false,
              searchFor: true,
            },
          },
          "yyy"
        ),
        "zzz yyyC zzz",
        "07.05"
      );
    });


  })
}


