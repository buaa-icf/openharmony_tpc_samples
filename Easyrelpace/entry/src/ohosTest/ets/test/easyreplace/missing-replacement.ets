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

export default function missingreplacement() {
  describe('missingreplacement', function () {
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
test("01 - empty string as replacement = deletion mode", () => {
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
      ""
    ),
    "aa",
    "test 10.1"
  );
});

test("02 - null as replacement = deletion mode", () => {
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
      null
    ),
    "aa",
    "test 10.2"
  );
});

test("03 - replacement bool, nothing left", () => {
  equal(
    er(
      "🐴",
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
      true
    ),
    "",
    "test 10.3"
  );
});

test("04 - replacement Bool, nothing left, searchFor Integer", () => {
  equal(
    er(
      "2",
      {
        leftOutsideNot: "",
        leftOutside: "",
        leftMaybe: "",
        // @ts-ignore
        searchFor: 2,
        rightMaybe: "",
        rightOutside: "",
        rightOutsideNot: "",
      },
      false
    ),
    "",
    "test 10.4"
  );
});

test("05 - nothing left, replacement undefined", () => {
  equal(
    er(
      "fljlh fdlg ldfhgl abc aldjsdlflkjd ljfl fgklh fl",
      // @ts-ignore
      {
        leftOutsideNot: "",
        leftOutside: "",
        leftMaybe: "",
        searchFor: "fljlh fdlg ldfhgl abc aldjsdlflkjd ljfl fgklh fl",
        rightMaybe: "",
        rightOutside: "",
        rightOutsideNot: "",
      },
      undefined
    ),
    "",
    "test 10.5"
  );
});

test("06 - nothing left - more undefined", () => {
  equal(
    er(
      "zzz",
      // @ts-ignore
      {
        leftOutsideNot: "",
        leftOutside: "",
        leftMaybe: "",
        searchFor: "zzz",
        rightMaybe: "",
        rightOutside: "",
        rightOutsideNot: "",
      },
      undefined
    ),
    "",
    "test 10.6"
  );
});

test("07 - emoji, null replacement, both outsides found", () => {
  equal(
    er(
      "a🦄🐴🦄a",
      // @ts-ignore
      {
        leftOutsideNot: "",
        leftOutside: "🦄",
        leftMaybe: "",
        searchFor: "🐴",
        rightMaybe: "",
        rightOutside: "🦄",
        rightOutsideNot: "",
      },
      null
    ),
    "a🦄🦄a",
    "test 10.7"
  );
});

test("08 - raw integers everywhere must work too", () => {
  equal(
    er(
      // @ts-ignore
      6,
      {
        leftOutsideNot: "",
        leftOutside: "",
        leftMaybe: "",
        searchFor: 6,
        rightMaybe: "",
        rightOutside: "",
        rightOutsideNot: "",
      },
      9
    ),
    "9",
    "test 10.8"
  );
});

test("09 - searchFor is an array of 1 element", () => {
  equal(
    er(
      "a b c",
      // @ts-ignore
      {
        leftOutsideNot: "",
        leftOutside: "",
        leftMaybe: "",
        searchFor: ["b"],
        rightMaybe: "",
        rightOutside: "",
        rightOutsideNot: "",
      },
      "d"
    ),
    "a d c",
    "test 10.9"
  );
});

test("10 - searchFor is an array of few elements (no find)", () => {
  equal(
    er(
      "a b c",
      // @ts-ignore
      {
        leftOutsideNot: "",
        leftOutside: "",
        leftMaybe: "",
        searchFor: ["b", "x"],
        rightMaybe: "",
        rightOutside: "",
        rightOutsideNot: "",
      },
      "d"
    ),
    "a b c",
    "test 10.10"
  );
});

test("11 - searchFor is an array of few elements (won't work)", () => {
  equal(
    er(
      "a bx c",
      // @ts-ignore
      {
        leftOutsideNot: "",
        leftOutside: "",
        leftMaybe: "",
        searchFor: ["b", "x"],
        rightMaybe: "",
        rightOutside: "",
        rightOutsideNot: "",
      },
      "d"
    ),
    "a bx c",
    "test 10.11"
  );
});

  })
}

