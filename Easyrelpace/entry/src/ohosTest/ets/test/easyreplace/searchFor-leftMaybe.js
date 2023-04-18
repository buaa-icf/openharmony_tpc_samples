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

export default function searchForleftMaybe() {
  describe('searchForleftMaybe', function () {
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
// searchFor + leftMaybe
// ==============================

test("01 - left maybe found", () => {
  equal(
    er(
      "a🦄🐴🦄c",
      {
        leftOutsideNot: "",
        leftOutside: "",
        leftMaybe: "🦄",
        searchFor: "🐴",
        rightMaybe: "",
        rightOutside: "",
        rightOutsideNot: "",
      },
      "b"
    ),
    "ab🦄c",
    "test 2.1"
  );
  equal(
    er(
      "a🦄🐴🦄c",
      {
        leftOutsideNot: "",
        leftOutside: "",
        leftMaybe: ["🦄"],
        searchFor: "🐴",
        rightMaybe: "",
        rightOutside: "",
        rightOutsideNot: "",
      },
      "b"
    ),
    "ab🦄c",
    "test 2.1"
  );
});

test("02 - two replacements with one leftmaybe, nearby", () => {
  equal(
    er(
      "ab🐴🦄🐴c",
      {
        leftOutsideNot: "",
        leftOutside: "",
        leftMaybe: "🦄",
        searchFor: "🐴",
        rightMaybe: "",
        rightOutside: "",
        rightOutsideNot: "",
      },
      "d"
    ),
    "abddc",
    "test 2.2"
  );
  equal(
    er(
      "ab🐴🦄🐴c",
      {
        leftOutsideNot: "",
        leftOutside: "",
        leftMaybe: ["🦄"],
        searchFor: "🐴",
        rightMaybe: "",
        rightOutside: "",
        rightOutsideNot: "",
      },
      "d"
    ),
    "abddc",
    "test 2.2"
  );
});

test("03 - two consecutive maybes found/replaced", () => {
  equal(
    er(
      "ab🦄🐴🦄🐴c",
      {
        leftOutsideNot: "",
        leftOutside: "",
        leftMaybe: "🦄",
        searchFor: "🐴",
        rightMaybe: "",
        rightOutside: "",
        rightOutsideNot: "",
      },
      "d"
    ),
    "abddc",
    "test 2.3"
  );
  equal(
    er(
      "ab🦄🐴🦄🐴c",
      {
        leftOutsideNot: "",
        leftOutside: "",
        leftMaybe: ["🦄"],
        searchFor: "🐴",
        rightMaybe: "",
        rightOutside: "",
        rightOutsideNot: "",
      },
      "d"
    ),
    "abddc",
    "test 2.3"
  );
});

test("04 - futile left maybe", () => {
  equal(
    er(
      "'🐴",
      {
        leftOutsideNot: "",
        leftOutside: "",
        leftMaybe: "🦄",
        searchFor: "🐴",
        rightMaybe: "",
        rightOutside: "",
        rightOutsideNot: "",
      },
      "d"
    ),
    "'d",
    "test 2.4"
  );
  equal(
    er(
      "'🐴",
      {
        leftOutsideNot: "",
        leftOutside: "",
        leftMaybe: ["🦄"],
        searchFor: "🐴",
        rightMaybe: "",
        rightOutside: "",
        rightOutsideNot: "",
      },
      "d"
    ),
    "'d",
    "test 2.4"
  );
});

test("05 - line break as search string", () => {
  equal(
    er(
      "\n\n\n",
      {
        leftOutsideNot: "",
        leftOutside: "",
        leftMaybe: "",
        searchFor: "\n",
        rightMaybe: "",
        rightOutside: "",
        rightOutsideNot: "",
      },
      "a"
    ),
    "aaa",
    "test 2.5"
  );
});

test("06 - line break as both searchFor and maybe replaced", () => {
  equal(
    er(
      "\n\n\n",
      {
        leftOutsideNot: "",
        leftOutside: "",
        leftMaybe: "\n",
        searchFor: "\n",
        rightMaybe: "",
        rightOutside: "",
        rightOutsideNot: "",
      },
      "a"
    ),
    "aaa",
    "test 2.6"
  );
  equal(
    er(
      "\n\n\n",
      {
        leftOutsideNot: "",
        leftOutside: "",
        leftMaybe: ["\n"],
        searchFor: "\n",
        rightMaybe: "",
        rightOutside: "",
        rightOutsideNot: "",
      },
      "a"
    ),
    "aaa",
    "test 2.6"
  );
});

test("07 - operations on line breaks only", () => {
  equal(
    er(
      "\n\n",
      {
        leftOutsideNot: "",
        leftOutside: "",
        leftMaybe: "",
        searchFor: "\n\n",
        rightMaybe: "",
        rightOutside: "",
        rightOutsideNot: "",
      },
      "\n"
    ),
    "\n",
    "test 2.7"
  );
});

test("08 - three left maybes (found)", () => {
  equal(
    er(
      "a🦄🐴🦄c",
      {
        leftOutsideNot: "",
        leftOutside: "",
        leftMaybe: ["🦄", "a", "x"],
        searchFor: "🐴",
        rightMaybe: "",
        rightOutside: "",
        rightOutsideNot: "",
      },
      "b"
    ),
    "ab🦄c",
    "test 2.8"
  );
});

test("09 - three left maybes (not found)", () => {
  equal(
    er(
      "a🦄🐴🦄c",
      {
        leftOutsideNot: "",
        leftOutside: "",
        leftMaybe: ["🦄", "🐴", "c"],
        searchFor: "🍺",
        rightMaybe: "",
        rightOutside: "",
        rightOutsideNot: "",
      },
      "b"
    ),
    "a🦄🐴🦄c",
    "test 2.9"
  );
});

test("10 - three left maybes (multiple hungry finds)", () => {
  equal(
    er(
      "🐴 a🍺🦄🐴🦄c a🦄🍺🐴🦄c a🦄🐴🦄c a🍺🐴🦄c 🐴",
      {
        leftOutsideNot: "",
        leftOutside: "",
        leftMaybe: ["🦄", "🍺", "c"],
        searchFor: "🐴",
        rightMaybe: "",
        rightOutside: "",
        rightOutsideNot: "",
      },
      "b"
    ),
    "b a🍺b🦄c a🦄b🦄c ab🦄c ab🦄c b",
    "test 2.10.1"
  );
  equal(
    er(
      "🐴 a🍺🦄🐴🦄c a🦄🍺🐴🦄c a🦄🐴🦄c a🍺🐴🦄c 🐴",
      {
        leftOutsideNot: "",
        leftOutside: "",
        leftMaybe: ["c", "🦄", "🍺"],
        searchFor: "🐴",
        rightMaybe: "",
        rightOutside: "",
        rightOutsideNot: "",
      },
      "b"
    ),
    "b a🍺b🦄c a🦄b🦄c ab🦄c ab🦄c b",
    "test 2.10.2"
  );
  equal(
    er(
      "🐴 a🍺🦄🐴🦄c a🦄🍺🐴🦄c a🦄🐴🦄c a🍺🐴🦄c 🐴",
      {
        leftOutsideNot: "",
        leftOutside: "",
        leftMaybe: ["🍺", "c", "🦄"],
        searchFor: "🐴",
        rightMaybe: "",
        rightOutside: "",
        rightOutsideNot: "",
      },
      "b"
    ),
    "b a🍺b🦄c a🦄b🦄c ab🦄c ab🦄c b",
    "test 2.10.3"
  );
});
// if leftMaybe is simply merged and not iterated, and is queried to exist
// explicitly as string on the left side of the searchFor, it will not be found
// if the order of array is wrong, yet characters are all the same.

test("11 - sneaky array conversion situation", () => {
  equal(
    er(
      "a🦄🐴🦄c",
      {
        leftOutsideNot: "",
        leftOutside: "",
        leftMaybe: ["a", "🦄"],
        searchFor: "🐴",
        rightMaybe: "",
        rightOutside: "",
        rightOutsideNot: "",
      },
      "b"
    ),
    "ab🦄c",
    "test 2.11"
  );
});

test("12 - sneaky array conversion situation", () => {
  equal(
    er(
      "a🦄🐴🦄c",
      {
        leftOutsideNot: "",
        leftOutside: "",
        leftMaybe: ["🦄", "a"],
        searchFor: "🐴",
        rightMaybe: "",
        rightOutside: "",
        rightOutsideNot: "",
      },
      "b"
    ),
    "ab🦄c",
    "test 2.12"
  );
});

test("13 - normal words, few of them, leftMaybe as array", () => {
  equal(
    er(
      "this emotion is really a promotion in motion",
      {
        leftOutsideNot: "",
        leftOutside: "",
        leftMaybe: ["e", "pro"],
        searchFor: "motion",
        rightMaybe: "",
        rightOutside: "",
        rightOutsideNot: "",
      },
      "test"
    ),
    "this test is really a test in test",
    "test 2.13"
  );
});

test("14 - normal words, few of them, leftMaybe as array", () => {
  equal(
    er(
      "this emotion is really a promotion in motion",
      {
        leftOutsideNot: "",
        leftOutside: "",
        leftMaybe: ["pro", "e"],
        searchFor: "motion",
        rightMaybe: "",
        rightOutside: "",
        rightOutsideNot: "",
      },
      "test"
    ),
    "this test is really a test in test",
    "test 2.14"
  );
});

test("15 - leftMaybe is array, but with only 1 null value", () => {
  equal(
    er(
      "some text",
      {
        leftOutsideNot: "",
        leftOutside: "",
        leftMaybe: [null],
        searchFor: "look for me",
        rightMaybe: "",
        rightOutside: "",
        rightOutsideNot: "",
      },
      "replace with me"
    ),
    "some text",
    "test 2.15"
  );
});

test("16 - leftMaybe is array, but with only 1 null value", () => {
  equal(
    er(
      "some text",
      {
        leftOutsideNot: "",
        leftOutside: "",
        leftMaybe: [null, null, null],
        searchFor: "look for me",
        rightMaybe: "",
        rightOutside: "",
        rightOutsideNot: "",
      },
      "replace with me"
    ),
    "some text",
    "test 2.16"
  );
});

test("17 - leftMaybe is couple integers in an array", () => {
  equal(
    er(
      "1234",
      {
        leftOutsideNot: "",
        leftOutside: "",
        leftMaybe: [2, 3],
        searchFor: 4,
        rightMaybe: "",
        rightOutside: "",
        rightOutsideNot: "",
      },
      9
    ),
    "129",
    "test 2.17"
  );
});

test("18 - leftMaybe is couple integers in an array", () => {
  equal(
    er(
      "1234",
      {
        leftOutsideNot: "",
        leftOutside: "",
        leftMaybe: [3, 2],
        searchFor: 4,
        rightMaybe: "",
        rightOutside: "",
        rightOutsideNot: "",
      },
      9
    ),
    "129",
    "test 2.18"
  );
});

test("19 - sneaky case of overlapping leftMaybes", () => {
  equal(
    er(
      "this is a word to be searched for",
      {
        leftOutsideNot: "",
        leftOutside: "",
        leftMaybe: ["be ", "to be ", "this not exists"],
        searchFor: "searched",
        rightMaybe: "",
        rightOutside: "",
        rightOutsideNot: "",
      },
      "we look"
    ),
    "this is a word we look for",
    "test 2.19.1 - no flag"
  );
  equal(
    er(
      "this is a word To Be searched for",
      {
        leftOutsideNot: "",
        leftOutside: "",
        leftMaybe: ["be ", "to be ", "this not exists"],
        searchFor: "searched",
        rightMaybe: "",
        rightOutside: "",
        rightOutsideNot: "",
        i: {
          leftMaybe: true,
        },
      },
      "we look"
    ),
    "this is a word we look for",
    "test 2.19.2 - varying case"
  );
  equal(
    er(
      "this is a word To Be searched for",
      {
        leftOutsideNot: "",
        leftOutside: "",
        leftMaybe: ["this not exists", "zzz"],
        searchFor: "searched",
        rightMaybe: "",
        rightOutside: "",
        rightOutsideNot: "",
        i: {
          leftMaybe: true,
        },
      },
      "we look"
    ),
    "this is a word To Be we look for",
    "test 2.19.3"
  );
});

  })
}
