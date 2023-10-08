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

export default function outsideNot() {
  describe('outsideNot', () => {
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
    // outsideNot's
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
    test("01 - rightOutsideNot satisfied thus not replaced", () => {
  equal(
    er(
      "🐴a",optsFunc("","","","🐴","","","a"),
      "c"
    ),
    "🐴a",
    "test 12.1.1"
    )
    ;
    equal(
      er(
        "🐴a",optsFunc("","","","🐴","","",["a"]),
        "c"
      ),
      "🐴a",
      "test 12.1.2"
    );
    }
    )
    ;

    test("02 - outsideNot left satisfied thus not replaced", () => {
      equal(
        er(
          "a🐴",optsFunc("a","","","🐴","","",""),
          "c"
        ),
        "a🐴",
        "test 12.2.1"
      );
      equal(
        er(
          "a🐴",optsFunc(["a"],"","","🐴","","",""),
          "c"
        ),
        "a🐴",
        "test 12.2.2"
      );
    });

    test("03 - outsideNot's satisfied thus not replaced", () => {
      equal(
        er(
          "a🐴a",optsFunc("a","","","🐴","","","a"),
          "c"
        ),
        "a🐴a",
        "test 12.3"
      );
    });

    test("04 - outsideNot's not satisfied, with 1 maybe replaced", () => {
      equal(
        er(
          "zb🐴y",optsFunc("a","","b","🐴","","","c"),
          "🦄"
        ),
        "z🦄y",
        "test 12.4"
      );
    });

    test("05 - leftOutsideNot blocked positive leftMaybe", () => {
      equal(
        er(
          "zb🐴y",optsFunc("z","","b","🐴","","",""),
          "whatevs"
        ),
        "zb🐴y",
        "test 12.5"
      );
    });

    test("06 - rightOutsideNot blocked both L-R maybes", () => {
      equal(
        er(
          "zb🐴cy",optsFunc("","",["b", "a"],"🐴",["a", "c"],"",["y", "a"]),
          "whatevs"
        ),
        "zb🐴cy",
        "test 12.6"
      );
    });

    test("07 - rightOutsideNot last char goes outside", () => {
      equal(
        er(
          "cccccccca",optsFunc("","","","a","","","b"),
          "b"
        ),
        "ccccccccb",
        "test 12.7"
      );
    });

    test("08 - right maybe is last char, outsideNot satisfied", () => {
      equal(
        er(
          "cccccccca",optsFunc("","","","c","a","","c"),
          "c"
        ),
        "cccccccc",
        "test 12.8"
      );
    });

    test("09 - real life scenario, missing semicol on nbsp #1", () => {
      equal(
        er(
          "&nbsp; &nbsp &nbsp",optsFunc("","","","nbsp","","",";"),
          "nbsp;"
        ),
        "&nbsp; &nbsp; &nbsp;",
        "test 12.9"
      );
    });

    test("10 - real life scenario, missing semicol on nbsp #2", () => {
      equal(
        er(
          "&nbsp;&nbsp&nbsp",optsFunc("","","","nbsp","","",";"),
          "nbsp;"
        ),
        "&nbsp;&nbsp;&nbsp;",
        "test 12.10"
      );
    });

    test("11 - real life scenario, missing ampersand, text", () => {
      equal(
        er(
          "tralalalanbsp;nbsp;&nbsp;",optsFunc("&","","","nbsp","","",""),
          "&nbsp"
        ),
        "tralalala&nbsp;&nbsp;&nbsp;",
        "test 12.11"
      );
    });

    test("12 - as before but with emoji instead", () => {
      equal(
        er(
          "🍺🍺👌🍺",optsFunc("👌","","","🍺","","",""),
          "🍻"
        ),
        "🍻🍻👌🍺",
        "test 12.12"
      );
    });

    test("13 - rightOutsideNot with L-R maybes", () => {
      equal(
        er(
          "zb🐴cy",optsFunc(["a"],"",["b", "a"],"🐴",["a", "c"],"",["c", "a"]),
          "x"
        ),
        "zxy",
        "test 12.13"
      );
    });

    test("14 - all of 'em #1", () => {
      equal(
        er(
          "zb🐴cy",optsFunc(["c", "b"],["z", "y"],["a", "b", "c"],"🐴",["a", "b", "c"],["z", "y"],["c", "b"]),
          "x"
        ),
        "zxy",
        "test 12.14"
      );
    });

    test("15 - all of 'em #2", () => {
      equal(
        er(
          "zb🐴cy",optsFunc(["","",""],["z", "y"],["a", "b", "c"],"🐴",["a", "b", "c"],["z", "y"],["","",""]),
          "x"
        ),
        "zxy",
        "test 12.14"
      );
    });
  })
}
