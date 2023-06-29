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

export default function searchForleftright() {
  describe('searchForleftright', function () {
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
// searchFor + both left and right
// ==============================

test("01 - left and right maybes as emoji", () => {
  equal(
    er(
      "a🦄🐴🦄a",
      // @ts-ignore
      {
        leftOutsideNot: "",
        leftOutside: "",
        leftMaybe: "🦄",
        searchFor: "🐴",
        rightMaybe: "🦄",
        rightOutside: "",
        rightOutsideNot: "",
      },
      "z"
    ),
    "aza",
    "test 4.1.1"
  );
  equal(
    er(
      "a🦄🐴🦄a",
      // @ts-ignore
      {
        leftOutsideNot: "",
        leftOutside: "",
        leftMaybe: ["🦄"],
        searchFor: "🐴",
        rightMaybe: ["🦄"],
        rightOutside: "",
        rightOutsideNot: "",
      },
      "z"
    ),
    "aza",
    "test 4.1.2"
  );
});

test("02 - left and right maybes as text", () => {
  equal(
    er(
      "abc abc abc",
      // @ts-ignore
      {
        leftOutsideNot: "",
        leftOutside: "",
        leftMaybe: "a",
        searchFor: "b",
        rightMaybe: "c",
        rightOutside: "",
        rightOutsideNot: "",
      },
      "z"
    ),
    "z z z",
    "test 4.2.1"
  );
  equal(
    er(
      "abc abc abc",
      // @ts-ignore
      {
        leftOutsideNot: "",
        leftOutside: "",
        leftMaybe: ["a", "c"],
        searchFor: "b",
        rightMaybe: ["a", "c"],
        rightOutside: "",
        rightOutsideNot: "",
      },
      "z"
    ),
    "z z z",
    "test 4.2.2"
  );
});

test("03 - left+right maybes, middle & end of word #1", () => {
  equal(
    er(
      "zzzabc zzzzabczzz abczzzz",
      // @ts-ignore
      {
        leftOutsideNot: "",
        leftOutside: "",
        leftMaybe: "a",
        searchFor: "b",
        rightMaybe: "c",
        rightOutside: "",
        rightOutsideNot: "",
      },
      "z"
    ),
    "zzzz zzzzzzzz zzzzz",
    "test 4.3"
  );
});

test("04 - left+right maybes, middle & end of word #2", () => {
  equal(
    er(
      "zzz🦄🐴🦄 zzzz🦄🐴🦄zzz 🦄🐴🦄zzzz",
      // @ts-ignore
      {
        leftOutsideNot: "",
        leftOutside: "",
        leftMaybe: "🦄",
        searchFor: "🐴",
        rightMaybe: "🦄",
        rightOutside: "",
        rightOutsideNot: "",
      },
      "z"
    ),
    "zzzz zzzzzzzz zzzzz",
    "test 4.4"
  );
});

test("05 - normal words", () => {
  equal(
    er(
      "aaa some test text testing for somebody",
      // @ts-ignore
      {
        leftOutsideNot: "",
        leftOutside: "",
        leftMaybe: ["some "],
        searchFor: "te",
        rightMaybe: ["st", "xt", "sting"],
        rightOutside: "",
        rightOutsideNot: "",
      },
      "check"
    ),
    "aaa check check check for somebody",
    "test 4.5"
  );
});

  })
}
