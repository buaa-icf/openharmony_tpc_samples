/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium'
import util from '@ohos.util'
import {
  compile,
  Key,
  match,
  parse,
  pathToRegexp,
  Token
} from 'path-to-regexp';
import { Options } from './interface';
import { TESTS, diff, exec, ToPath } from './utils'

const BASE_COUNT = 1

export default function OriginLibraryTest() {
  describe('PathToRegexpTest', () => {
    const TEST_PATH = "/user/:id";
    const TEST_PARAM: Options = {
      name: "id",
      prefix: "/",
      suffix: "",
      modifier: "",
      pattern: "[^\\/#\\?]+?",
    };
    const tokens = parse(TEST_PATH);

    beforeAll(() => {
      TESTS.push(
        [
          new RegExp("\/(?<groupname>.+)"),
          undefined,
          [
            {
              name: "groupname",
              prefix: "",
              suffix: "",
              modifier: "",
              pattern: "",
            },
          ],
          [
            ["/", null],
            ["/foo", ["/foo", "foo"]],
          ],
          [],
        ],
        [
          new RegExp("\/(?<test>.*).(?<format>html|json)"),
          undefined,
          [
            {
              name: "test",
              prefix: "",
              suffix: "",
              modifier: "",
              pattern: "",
            },
            {
              name: "format",
              prefix: "",
              suffix: "",
              modifier: "",
              pattern: "",
            },
          ],
          [
            ["/route", null],
            ["/route.txt", null],
            ["/route.html", ["/route.html", "route", "html"]],
            ["/route.json", ["/route.json", "route", "json"]],
          ],
          [],
        ],
        [
          new RegExp("\/(.+)\/(?<groupname>.+)\/(.+)"),
          undefined,
          [
            {
              name: 0,
              prefix: "",
              suffix: "",
              modifier: "",
              pattern: "",
            },
            {
              name: "groupname",
              prefix: "",
              suffix: "",
              modifier: "",
              pattern: "",
            },
            {
              name: 1,
              prefix: "",
              suffix: "",
              modifier: "",
              pattern: "",
            },
          ],
          [
            ["/test", null],
            ["/test/testData", null],
            [
              "/test/testData/extraStuff",
              ["/test/testData/extraStuff", "test", "testData", "extraStuff"],
            ],
          ],
          [],
        ]
      );
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })

    it('arguments', 0, () => {
      let startTime1 = new Date().getTime();
      let regexp1 = pathToRegexp("/test");
      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
      console.log("pathToRegexp arguments :  averageTime1 : " + averageTime1 + "us")

      let startTime2 = new Date().getTime();
      let regexp2 = pathToRegexp("/test", []);
      let endTime2 = new Date().getTime();
      let averageTime2 = ((endTime2 - startTime2) * 1000) / BASE_COUNT;
      console.log("pathToRegexp arguments :  averageTime2 : " + averageTime2 + "us")

      let startTime3 = new Date().getTime();
      let options: Options = {}
      let regexp3 = pathToRegexp("/test", undefined, options);
      let endTime3 = new Date().getTime();
      let averageTime3 = ((endTime3 - startTime3) * 1000) / BASE_COUNT;
      console.log("pathToRegexp arguments :  averageTime3 : " + averageTime3 + "us")

      let startTime4 = new Date().getTime();
      let reg1: RegExp = new RegExp("^\/test")
      let regexp4 = pathToRegexp(reg1);
      let endTime4 = new Date().getTime();
      let averageTime4 = ((endTime4 - startTime4) * 1000) / BASE_COUNT;
      console.log("pathToRegexp arguments :  averageTime4 : " + averageTime4 + "us")

      let startTime5 = new Date().getTime();
      let regexp5 = pathToRegexp(reg1, []);
      let endTime5 = new Date().getTime();
      let averageTime5 = ((endTime5 - startTime5) * 1000) / BASE_COUNT;
      console.log("pathToRegexp arguments :  averageTime5 : " + averageTime5 + "us")

      let startTime6 = new Date().getTime();
      let regexp6 = pathToRegexp(reg1, undefined, options);
      let endTime6 = new Date().getTime();
      let averageTime6 = ((endTime6 - startTime6) * 1000) / BASE_COUNT;
      console.log("pathToRegexp arguments :  averageTime6 : " + averageTime6 + "us")

      let startTime7 = new Date().getTime();
      let regexp7 = pathToRegexp(["/a", "/b"]);
      let endTime7 = new Date().getTime();
      let averageTime7 = ((endTime7 - startTime7) * 1000) / BASE_COUNT;
      console.log("pathToRegexp arguments :  averageTime7 : " + averageTime7 + "us")

      let startTime8 = new Date().getTime();
      let regexp8 = pathToRegexp(["/a", "/b"], []);
      let endTime8 = new Date().getTime();
      let averageTime8 = ((endTime8 - startTime8) * 1000) / BASE_COUNT;
      console.log("pathToRegexp arguments :  averageTime8 : " + averageTime8 + "us")

      let startTime9 = new Date().getTime();
      let regexp9 = pathToRegexp(["/a", "/b"], undefined, options);
      let endTime9 = new Date().getTime();
      let averageTime9 = ((endTime9 - startTime9) * 1000) / BASE_COUNT;
      console.log("pathToRegexp arguments :  averageTime9 : " + averageTime9 + "us")

      expect((regexp1 != undefined && regexp1 != null)).assertTrue()
      expect((regexp2 != undefined && regexp2 != null)).assertTrue()
      expect((regexp3 != undefined && regexp3 != null)).assertTrue()
      expect((regexp4 != undefined && regexp4 != null)).assertTrue()
      expect((regexp5 != undefined && regexp5 != null)).assertTrue()
      expect((regexp6 != undefined && regexp6 != null)).assertTrue()
      expect((regexp7 != undefined && regexp7 != null)).assertTrue()
      expect((regexp8 != undefined && regexp8 != null)).assertTrue()
      expect((regexp9 != undefined && regexp9 != null)).assertTrue()
    })

    it('ArrayKeysSecondArgument', 0, () => {
      let startTime = new Date().getTime();
      const keys: Key[] = [];
      let options: Options = {
        end: false
      }
      const re = pathToRegexp(TEST_PATH, keys, options);
      let excResult: RegExpExecArray = exec(re, "/user/123/show")
      let endTime = new Date().getTime();
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT;
      console.log("pathToRegexp  :  ArrayKeysSecondArgument : " + averageTime + "us")

      let result1 = diff(keys, [TEST_PARAM])
      let result2 = diff(excResult, ["/user/123", "123"])
      expect(result1).assertTrue();
      expect(result2).assertTrue();
    })

    it('ThrowNonCapturingPattern', 0, () => {
      let startTime = new Date().getTime();
      expect(() => {
        pathToRegexp("/:foo(?:\\d+(\\.\\d+)?)");
      }).assertThrowError(new TypeError('Pattern cannot start with "?" at 6').message);
      let endTime = new Date().getTime();
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT;
      console.log("pathToRegexp :  ThrowNonCapturingPattern : " + averageTime + "us")
    })

    it('ThrowNestedCapturingGroup', 0, () => {
      let startTime = new Date().getTime();
      expect(() => {
        pathToRegexp("/:foo(\\d+(\\.\\d+)?)");
      }).assertThrowError(new TypeError("Capturing groups are not allowed at 9").message);
      let endTime = new Date().getTime();
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT;
      console.log("pathToRegexp :  ThrowNestedCapturingGroup : " + averageTime + "us")
    })

    it('ThrowUnbalancedPattern', 0, () => {
      let startTime = new Date().getTime();
      expect(() => {
        pathToRegexp("/:foo(abc");
      }).assertThrowError(new TypeError("Unbalanced pattern at 5").message);
      let endTime = new Date().getTime();
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT;
      console.log("pathToRegexp :  ThrowUnbalancedPattern : " + averageTime + "us")
    })

    it('ThrowMissingPattern', 0, () => {
      let startTime = new Date().getTime();
      expect(() => {
        pathToRegexp("/:foo()");
      }).assertThrowError(new TypeError("Missing pattern at 5").message);
      let endTime = new Date().getTime();
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT;
      console.log("pathToRegexp :  ThrowMissingPattern : " + averageTime + "us")
    })

    it('ThrowMissingName', 0, () => {
      let startTime = new Date().getTime();
      expect(() => {
        pathToRegexp("/:(test)");
      }).assertThrowError(new TypeError("Missing parameter name at 1").message);
      let endTime = new Date().getTime();
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT;
      console.log("pathToRegexp :  ThrowMissingName : " + averageTime + "us")
    })

    it('ThrowNestedGroups', 0, () => {
      let startTime = new Date().getTime();
      expect(() => {
        pathToRegexp("/{a{b:foo}}");
      }).assertThrowError(new TypeError("Unexpected OPEN at 3, expected CLOSE").message);
      let endTime = new Date().getTime();
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT;
      console.log("pathToRegexp :  ThrowNestedGroups : " + averageTime + "us")
    })

    it('ThrowMisplacedModifier', 0, () => {
      let startTime = new Date().getTime();
      expect(() => {
        pathToRegexp("/foo?");
      }).assertThrowError(new TypeError("Unexpected MODIFIER at 4, expected END").message);
      let endTime = new Date().getTime();
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT;
      console.log("pathToRegexp :  ThrowMisplacedModifier : " + averageTime + "us")
    })

    it('CompileTokensToRegexp', 0, () => {
      let startTime = new Date().getTime();
      const re = tokensToRegexp(tokens);
      let execResult: RegExpExecArray = exec(re, "/user/123")
      let endTime = new Date().getTime();
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT;
      console.log("pathToRegexp :  CompileTokensToRegexp : " + averageTime + "us")
      let result1 = diff(execResult, ["/user/123", "123"])
      expect(result1).assertTrue();

    })

    it('CompileTokensToPathFunction', 0, () => {
      let startTime = new Date().getTime();
      const fn = tokensToFunction(tokens);
      expect(fn({
        id: 123
      })).assertEqual("/user/123");
      let endTime = new Date().getTime();
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT;
      console.log("pathToRegexp :  CompileTokensToPathFunction : " + averageTime + "us")
    })

    describe("rules", () => {
      TESTS.forEach( (test) => {
        const path = test[0]
        const opts = test[1]
        const tokens = test[2]
        const matchCases = test[3]
        const compileCases: Array<object> = test[4]
        const keys: Key[] = [];
        const re = pathToRegexp(path, keys, opts);
        if (typeof path === 'string') {
          it("ShouldParse", 0, () => {
            let startTime = new Date().getTime();
            let result = parse(path, opts);
            let endTime = new Date().getTime();
            let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT;
            console.log("pathToRegexp :  ShouldParse" + path + " : " + averageTime + "us")
            expect(result).assertEqual(tokens);
          });
          let index = 0;
          compileCases.forEach( (io) => {
            const params: object = io[0]
            const result: object | null = io[1] || null
            const options: object | null = io[2] || null
            const toPath = ToPath(path, opts, options)

            if (result !== null) {
              let name = "ShouldCompileUsing" + index
              it(name, 0, () => {
                let startTime = new Date().getTime();
                let result = toPath(params)
                let endTime = new Date().getTime();
                let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT;
                console.log("pathToRegexp :  " + name + " : " + averageTime + "us")
                expect(result).assertEqual(result);
              });
            } else {
              let name = "ShouldNotCompileUsing" + index
              it(name, 0, () => {
                let startTime = new Date().getTime();
                expect(() => {
                  toPath(params);
                }).assertThrowError('TypeError'); // TODO
                let endTime = new Date().getTime();
                let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT;
                console.log("pathToRegexp :  " + name + " : " + averageTime + "us")
              }
              );
            }
          });


        } else {
          it("ShouldParseKeys", 0, () => {
            let startTime = new Date().getTime();
            let result = tokens.filter( (token) => {
              return typeof token !== "string";
            })
            let endTime = new Date().getTime();
            let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT;
            console.log("pathToRegexp :  ShouldParseKeys : " + averageTime + "us")
            expect(keys).assertEqual(result);
          });
        }
        let matchIndex = 0;
        matchCases.forEach( (io) => {
          const pathname = io[0]
          const matches = io[1]
          const params = io[2]
          const options = io[3]

          const message = `Should${matches ? "" : "Not "}Match${matchIndex}`;

          it(message, 0, () => {
            let startTime = new Date().getTime();
            let result: RegExpExecArray = exec(re, pathname)
            let endTime = new Date().getTime();
            let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT;
            console.log("pathToRegexp :  " + message + " : " + averageTime + "us")
            expect(result).assertEqual(matches);
          });

          if (typeof path === "string" && params !== undefined) {
            const matchs = match(path, options);
            it(message + " params", 0, () => {
              let startTime = new Date().getTime();
              let result = matchs(pathname)
              let endTime = new Date().getTime();
              let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT;
              console.log("pathToRegexp :  " + message + " params" + " : " + averageTime + "us")
              expect(result).assertEqual(params);
            });
          }
        });

      });
    })
    describe("CompileErrors", () => {
      it('ThrowRequiredParamUndefined', 0, () => {
        let startTime = new Date().getTime();
        const toPath = compile("/a/:b/c");
        expect( () => {
          toPath();
        }).assertThrowError(new TypeError('Expected "b" to be a string').message);
        let endTime = new Date().getTime();
        let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT;
        console.log("pathToRegexp :  ThrowRequiredParamUndefined : " + averageTime + "us")
      })

      it('ThrowNotMatchPpattern', 0, () => {
        let startTime = new Date().getTime();
        const toPath = compile("/:foo(\\d+)");
        expect( () => {
          toPath({
            foo: "abc"
          });
        }).assertThrowError(new TypeError('Expected "foo" to match "\\d+", but got "abc"').message);
        let endTime = new Date().getTime();
        let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT;
        console.log("pathToRegexp :  ThrowNotMatchPpattern : " + averageTime + "us")
      })
      it('ThrowExpectingRepeatedValue', 0, () => {
        let startTime = new Date().getTime();
        const toPath = compile("/:foo+");
        expect( () => {
          toPath({
            foo: []
          });
        }).assertThrowError(new TypeError('Expected "foo" to not be empty').message);
        let endTime = new Date().getTime();
        let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT;
        console.log("pathToRegexp :  ThrowExpectingRepeatedValue : " + averageTime + "us")
      })
      it('ThrowNotExpectingRepeatedValue', 0, () => {
        let startTime = new Date().getTime();
        const toPath = compile("/:foo");
        expect( () => {
          toPath({
            foo: []
          });
        }).assertThrowError(new TypeError('Expected "foo" to not repeat, but got an array').message);
        let endTime = new Date().getTime();
        let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT;
        console.log("pathToRegexp :  ThrowNotExpectingRepeatedValue : " + averageTime + "us")
      })
      it('ThrowRepeatedValueNotMatch', 0, () => {
        let startTime = new Date().getTime();
        const toPath = compile("/:foo(\\d+)+");
        expect(() => {
          toPath({
            foo: [1, 2, 3, "a"]
          });
        }).assertThrowError(new TypeError('Expected all "foo" to match "\\d+", but got "a"').message);
        let endTime = new Date().getTime();
        let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT;
        console.log("pathToRegexp :  ThrowNotExpectingRepeatedValue : " + averageTime + "us")
      })
    })

  })
}