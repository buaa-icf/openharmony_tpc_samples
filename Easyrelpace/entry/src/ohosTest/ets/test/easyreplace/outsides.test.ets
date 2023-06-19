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

export default function outsides() {
  describe('outsides', function () {
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
// outsides
// ==============================

test("01 - left and right outsides as arrays (majority found)", () => {
  equal(
    er(
      "🐴 a🦄🐴💘a a💘🐴🦄a a💘🐴💘a a🦄🐴🦄a 🐴",
      // @ts-ignore
      {
        leftOutsideNot: "",
        leftOutside: ["🦄", "💘", "doesn't exist", "this one too"],
        leftMaybe: "",
        searchFor: "🐴",
        rightMaybe: "",
        rightOutside: ["more stuff here", "and here", "🦄", "💘"],
        rightOutsideNot: "",
      },
      "c"
    ),
    "🐴 a🦄c💘a a💘c🦄a a💘c💘a a🦄c🦄a 🐴",
    "test 11.1"
  );
});

test("02 - left and right outsides as arrays (one found)", () => {
  equal(
    er(
      "🐴 a🦄🐴💘a a💘🐴🦄a a💘🐴💘a a🦄🐴🦄a 🐴",
      // @ts-ignore
      {
        leftOutsideNot: "",
        leftOutside: ["🦄", "doesn't exist", "this one too"],
        leftMaybe: "",
        searchFor: "🐴",
        rightMaybe: "",
        rightOutside: ["more stuff here", "and here", "💘"],
        rightOutsideNot: "",
      },
      "c"
    ),
    "🐴 a🦄c💘a a💘🐴🦄a a💘🐴💘a a🦄🐴🦄a 🐴",
    "test 11.2"
  );
});

test("03 - outsides as arrays, beyond found maybes", () => {
  equal(
    er(
      "🦄🐴 a🦄🐴💘a a💘🐴🦄a a💘🐴💘a a🦄🐴🦄a 🐴🦄",
      // @ts-ignore
      {
        leftOutsideNot: "",
        leftOutside: ["a"],
        leftMaybe: ["🦄", "💘"],
        searchFor: "🐴",
        rightMaybe: ["🦄", "💘"],
        rightOutside: ["a"],
        rightOutsideNot: "",
      },
      "c"
    ),
    "🦄🐴 aca aca aca aca 🐴🦄",
    "test 11.3"
  );
});

test("04 - outsides as arrays blocking maybes", () => {
  equal(
    er(
      "🦄🐴 a🦄🐴💘a a💘🐴🦄a a💘🐴💘a a🦄🐴🦄a 🐴🦄",
      // @ts-ignore
      {
        leftOutsideNot: "",
        leftOutside: ["b"],
        leftMaybe: ["🦄", "💘"],
        searchFor: "🐴",
        rightMaybe: ["🦄", "💘"],
        rightOutside: ["b"],
        rightOutsideNot: "",
      },
      "whatevs"
    ),
    "🦄🐴 a🦄🐴💘a a💘🐴🦄a a💘🐴💘a a🦄🐴🦄a 🐴🦄",
    "test 11.4"
  );
});

test("05 - maybes matching outsides, blocking them", () => {
  equal(
    er(
      "🦄🐴 a🦄🐴💘a a💘🐴🦄a a💘🐴💘a a🦄🐴🦄a 🐴🦄",
      // @ts-ignore
      {
        leftOutsideNot: "",
        leftOutside: ["🦄", "💘"],
        leftMaybe: ["🦄", "💘"],
        searchFor: "🐴",
        rightMaybe: ["🦄", "💘"],
        rightOutside: ["🦄", "💘"],
        rightOutsideNot: "",
      },
      "whatevs"
    ),
    "🦄🐴 a🦄🐴💘a a💘🐴🦄a a💘🐴💘a a🦄🐴🦄a 🐴🦄",
    "test 11.5"
  );
});

test("06 - maybes matching outsides, blocking them", () => {
  equal(
    er(
      "🦄🐴 a🦄🐴💘a a💘🐴🦄a a💘🐴💘a a🦄🐴🦄a 🐴🦄",
      // @ts-ignore
      {
        leftOutsideNot: "",
        leftOutside: ["🦄", "💘"],
        leftMaybe: ["🦄", "💘"],
        searchFor: "🐴",
        rightMaybe: ["🦄", "💘"],
        rightOutside: ["🦄", "💘"],
        rightOutsideNot: "",
      },
      "whatevs"
    ),
    "🦄🐴 a🦄🐴💘a a💘🐴🦄a a💘🐴💘a a🦄🐴🦄a 🐴🦄",
    "test 11.6"
  );
});

test("07 - maybes matching outsides, found", () => {
  equal(
    er(
      "🦄🐴🦄 a💘🦄🐴💘🦄a a🦄💘🐴🦄💘a a💘💘🐴💘💘a a🦄🦄🐴🦄🦄a 🦄🐴🦄",
      // @ts-ignore
      {
        leftOutsideNot: "",
        leftOutside: ["🦄", "💘"],
        leftMaybe: ["🦄", "💘"],
        searchFor: "🐴",
        rightMaybe: ["🦄", "💘"],
        rightOutside: ["🦄", "💘"],
        rightOutsideNot: "",
      },
      "c"
    ),
    "🦄🐴🦄 a💘c🦄a a🦄c💘a a💘c💘a a🦄c🦄a 🦄🐴🦄",
    "test 11.6"
  );
});

test("08 - maybes matching outsides, mismatching", () => {
  equal(
    er(
      "🍺🐴🍺 a💘🍺🐴🌟🦄a a🦄🌟🐴🍺💘a a💘🌟🐴🌟💘a a🦄🍺🐴🍺🦄a 🌟🐴🌟",
      // @ts-ignore
      {
        leftOutsideNot: "",
        leftOutside: ["🦄", "💘"],
        leftMaybe: ["🍺", "🌟"],
        searchFor: "🐴",
        rightMaybe: ["🍺", "🌟"],
        rightOutside: ["🦄", "💘"],
        rightOutsideNot: "",
      },
      "c"
    ),
    "🍺🐴🍺 a💘c🦄a a🦄c💘a a💘c💘a a🦄c🦄a 🌟🐴🌟",
    "test 11.6"
  );
});

test("09 - rightOutside & with case-insensitive flag", () => {
  equal(
    er(
      "aaaBBBccc aaazzzCCC aaaCCC",
      // @ts-ignore
      {
        leftOutsideNot: "",
        leftOutside: "",
        leftMaybe: "",
        searchFor: "aaa",
        rightMaybe: "",
        rightOutside: "u",
        rightOutsideNot: "",
      },
      "!"
    ),
    "aaaBBBccc aaazzzCCC aaaCCC",
    "test 11.7.1 - nothing matches, without flag"
  );
  equal(
    er(
      "aaaBBBccc aaazzzCCC aaaCCC",
      {
        leftOutsideNot: "",
        leftOutside: "",
        leftMaybe: "",
        searchFor: "aaa",
        rightMaybe: "",
        rightOutside: "u",
        rightOutsideNot: "",
        // @ts-ignore
        i: {
          rightOutside: true,
        },
      },
      "!"
    ),
    "aaaBBBccc aaazzzCCC aaaCCC",
    "test 11.7.2 - nothing matches, with flag"
  );
  equal(
    er(
      "aaaBBBccc aaazzzCCC aaaCCC",
      {
        leftOutsideNot: "",
        leftOutside: "",
        leftMaybe: "",
        searchFor: "aaa",
        rightMaybe: "",
        rightOutside: "c",
        rightOutsideNot: "",
        // @ts-ignore
        i: {
          rightOutside: true,
        },
      },
      "!"
    ),
    "aaaBBBccc aaazzzCCC !CCC",
    "test 11.7.3 - one match, with flag"
  );
});

  })
}