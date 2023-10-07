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
import { compile, Key, match, parse, pathToRegexp } from 'path-to-regexp';
import { Options } from './interface';
import { fn, urlMatch, fn1, toPath } from './utils'

const BASE_COUNT = 1

export default function ApiTest() {
  describe('ApiTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })

    it('KeysTest', 0, () => {
      let startTime1 = new Date().getTime();
      const keys: Key[] = [];
      const regexp = pathToRegexp("/foo/:bar", keys);
      let options: Options = {
        name: 'bar',
        prefix: '/',
        suffix: '',
        pattern: '[^\\/#\\?]+?',
        modifier: ''
      }
      let keyStr = JSON.stringify(keys);
      let objStr = JSON.stringify([options]);
      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
      console.log("regexp : KeysTest averageTime : " + averageTime1 + "us")

      expect(keyStr).assertEqual(objStr)
    })

    it('NamedParametersTest', 0, () => {
      let startTime1 = new Date().getTime();
      const keys: Key[] = [];
      const regexp = pathToRegexp("/:foo/:bar", keys);
      let testStr = JSON.stringify(regexp.exec("/test/route"));
      let objStr = JSON.stringify(['/test/route', 'test', 'route']);
      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
      console.log("regexp : NamedParametersTest averageTime : " + averageTime1 + "us")
      expect(testStr).assertEqual(objStr)
    })

    it('CustomMatchingParametersTest', 0, () => {
      let startTime1 = new Date().getTime();
      const regexpNumbers = pathToRegexp("/icon-:foo(\\d+).png");
      let testStr1 = JSON.stringify(regexpNumbers.exec("/icon-123.png"));
      let objStr1 = JSON.stringify(['/icon-123.png', '123']);
      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
      console.log("regexp : CustomMatchingParametersTest1 averageTime : " + averageTime1 + "us")
      expect(testStr1).assertEqual(objStr1)
      let startTime2 = new Date().getTime();
      let testStr2 = regexpNumbers.exec("/icon-abc.png");
      let endTime2 = new Date().getTime();
      let averageTime2 = ((endTime2 - startTime2) * 1000) / BASE_COUNT;
      console.log("regexp : CustomMatchingParametersTest2 averageTime : " + averageTime2 + "us")

      let objStr2: null = null;
      expect(testStr2).assertEqual(objStr2)

      let startTime3 = new Date().getTime();
      const regexpWord = pathToRegexp("/(user|u)");
      let testStr3 = JSON.stringify(regexpWord.exec("/u"));
      let objStr3 = JSON.stringify(['/u', 'u']);
      let endTime3 = new Date().getTime();
      let averageTime3 = ((endTime3 - startTime3) * 1000) / BASE_COUNT;
      console.log("regexp : CustomMatchingParametersTest3 averageTime : " + averageTime3 + "us")
      expect(testStr3).assertEqual(objStr3)

      let startTime4 = new Date().getTime();
      let testStr4 = regexpWord.exec("/users");
      let endTime4 = new Date().getTime();
      let averageTime4 = ((endTime4 - startTime4) * 1000) / BASE_COUNT;
      console.log("regexp : CustomMatchingParametersTest4 averageTime : " + averageTime4 + "us")
      let objStr4: null = null;
      expect(testStr4).assertEqual(objStr4)
    })

    it('CustomPrefixAndSuffixTest', 0, () => {
      let startTime1 = new Date().getTime();
      const regexp = pathToRegexp("/:attr1?{-:attr2}?{-:attr3}?");
      let testStr1 = JSON.stringify(regexp.exec("/test"));
      let objStr1 = JSON.stringify(['/test', 'test', null, null]);
      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
      console.log("regexp : CustomPrefixAndSuffixTest1 averageTime : " + averageTime1 + "us")
      expect(testStr1).assertEqual(objStr1)
      let startTime2 = new Date().getTime();
      let testStr2 = JSON.stringify(regexp.exec("/test-test"));
      let objStr2 = JSON.stringify(['/test-test', 'test', 'test', null]);
      let endTime2 = new Date().getTime();
      let averageTime2 = ((endTime2 - startTime2) * 1000) / BASE_COUNT;
      console.log("regexp : CustomPrefixAndSuffixTest2 averageTime : " + averageTime2 + "us")
      expect(testStr2).assertEqual(objStr2)
    })

    it('UnnamedParametersTest', 0, () => {
      let startTime1 = new Date().getTime();
      const regexp = pathToRegexp("/:foo/(.*)");
      let testStr1 = JSON.stringify(regexp.exec("/test/route"));
      let objStr1 = JSON.stringify(['/test/route', 'test', 'route']);
      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
      console.log("regexp : UnnamedParametersTest averageTime : " + averageTime1 + "us")
      expect(testStr1).assertEqual(objStr1)
    })

    it('ModifiersTest', 0, () => {
      let startTime1 = new Date().getTime();
      const regexp = pathToRegexp("/:foo/:bar?");
      let testStr1 = JSON.stringify(regexp.exec("/test"));
      let objStr1 = JSON.stringify(['/test', 'test', null]);
      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
      console.log("regexp : ModifiersTest1 averageTime : " + averageTime1 + "us")
      expect(testStr1).assertEqual(objStr1)

      let startTime2 = new Date().getTime();
      let testStr2 = JSON.stringify(regexp.exec("/test/route"));
      let objStr2 = JSON.stringify(['/test/route', 'test', 'route']);
      let endTime2 = new Date().getTime();
      let averageTime2 = ((endTime2 - startTime2) * 1000) / BASE_COUNT;
      console.log("regexp : ModifiersTest2 averageTime : " + averageTime2 + "us")
      expect(testStr2).assertEqual(objStr2)
    })

    it('OptionalTest', 0, () => {
      let startTime1 = new Date().getTime();
      const regexp = pathToRegexp("/search/:tableName\\?useIndex=true&term=amazing");
      let testStr1 = JSON.stringify(regexp.exec("/search/people?useIndex=true&term=amazing"));
      let objStr1 = JSON.stringify(['/search/people?useIndex=true&term=amazing', 'people']);
      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
      console.log("regexp : OptionalTest1 averageTime : " + averageTime1 + "us")
      expect(testStr1).assertEqual(objStr1)
      let startTime2 = new Date().getTime();
      let testStr2 = regexp.exec("/search/people?term=amazing&useIndex=true");
      let endTime2 = new Date().getTime();
      let averageTime2 = ((endTime2 - startTime2) * 1000) / BASE_COUNT;
      console.log("regexp : OptionalTest2 averageTime : " + averageTime2 + "us")
      let objStr2: null = null;
      expect(testStr2).assertEqual(objStr2)
    })

    it('ZeroOrMoreTest', 0, () => {
      let startTime1 = new Date().getTime();
      const regexp = pathToRegexp("/:foo*");
      let testStr1 = JSON.stringify(regexp.exec("/"));
      let objStr1 = JSON.stringify(['/', undefined]);
      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
      console.log("regexp : ZeroOrMoreTest1 averageTime : " + averageTime1 + "us")
      expect(testStr1).assertEqual(objStr1)
      let startTime2 = new Date().getTime();
      let testStr2 = JSON.stringify(regexp.exec("/bar/baz"));
      let objStr2 = JSON.stringify(['/bar/baz', 'bar/baz']);
      let endTime2 = new Date().getTime();
      let averageTime2 = ((endTime2 - startTime2) * 1000) / BASE_COUNT;
      console.log("regexp : ZeroOrMoreTest2 averageTime : " + averageTime2 + "us")
      expect(testStr2).assertEqual(objStr2)
    })

    it('OneOrMoreTest', 0, () => {
      let startTime1 = new Date().getTime();
      const regexp = pathToRegexp("/:foo+");
      let testStr1 = regexp.exec("/");
      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
      console.log("regexp : OneOrMoreTest1 averageTime : " + averageTime1 + "us")
      let objStr1: null = null;
      expect(testStr1).assertEqual(objStr1)
      let startTime2 = new Date().getTime();
      let testStr2 = JSON.stringify(regexp.exec("/bar/baz"));
      let objStr2 = JSON.stringify(['/bar/baz', 'bar/baz']);
      let endTime2 = new Date().getTime();
      let averageTime2 = ((endTime2 - startTime2) * 1000) / BASE_COUNT;
      console.log("regexp : OneOrMoreTest2 averageTime : " + averageTime2 + "us")
      expect(testStr2).assertEqual(objStr2)
    })

    it('MatchTest', 0, () => {
      let startTime1 = new Date().getTime();
      let testStr1 = JSON.stringify(fn("/user/123"));
      let options: Options = {
        path: '/user/123', index: 0, params: {
          id: '123'
        }
      }
      let objStr1 = JSON.stringify(options);
      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
      console.log("regexp : MatchTest1 averageTime : " + averageTime1 + "us")
      expect(testStr1).assertEqual(objStr1)
      let startTime2 = new Date().getTime();
      let testStr2 = fn("/invalid");
      let objStr2 = false;
      let endTime2 = new Date().getTime();
      let averageTime2 = ((endTime2 - startTime2) * 1000) / BASE_COUNT;
      console.log("regexp : MatchTest2 averageTime : " + averageTime2 + "us")
      expect(testStr2).assertEqual(objStr2);
    })

    it('urlMatchTest', 0, () => {
      let startTime1 = new Date().getTime();
      let testStr1 = JSON.stringify(urlMatch("/users/1234/photos"));
      let options: Options = {
        path: '/users/1234/photos', index: 0, params: {
          id: '1234', tab: 'photos'
        }
      }
      let objStr1 = JSON.stringify(options);
      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
      console.log("regexp : urlMatchTest1 averageTime : " + averageTime1 + "us")
      expect(testStr1).assertEqual(objStr1)
      let startTime2 = new Date().getTime();
      let testStr2 = JSON.stringify(urlMatch("/users/1234/bio"));
      let options2: Options = {
        path: '/users/1234/bio', index: 0, params: {
          id: '1234', tab: 'bio'
        }
      }
      let objStr2 = JSON.stringify(options2);
      let endTime2 = new Date().getTime();
      let averageTime2 = ((endTime2 - startTime2) * 1000) / BASE_COUNT;
      console.log("regexp : urlMatchTest2 averageTime : " + averageTime2 + "us")
      expect(testStr2).assertEqual(objStr2);

      let startTime3 = new Date().getTime();
      let testStr3 = urlMatch("/users/1234/otherstuff");
      let objStr3 = false;
      let endTime3 = new Date().getTime();
      let averageTime3 = ((endTime3 - startTime3) * 1000) / BASE_COUNT;
      console.log("regexp : urlMatchTest3 averageTime : " + averageTime3 + "us")
      expect(testStr3).assertEqual(objStr3);
    })


    it('ProcessPathnameTest', 0, () => {
      let startTime1 = new Date().getTime();
      let testStr1 = JSON.stringify(fn1("/caf%C3%A9"));
      let options: Options = {
        path: '/caf%C3%A9', index: 0, params: {}
      }
      let objStr1 = JSON.stringify(options);
      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
      console.log("regexp : ProcessPathnameTest averageTime : " + averageTime1 + "us")
      expect(testStr1).assertEqual(objStr1)
    })

    it('AlternativeUsingNormalizeTest', 0, () => {
      let startTime1 = new Date().getTime();
      const re = pathToRegexp("/caf\u00E9");
      const input = encodeURI("/cafe\u0301");

      let testStr1 = re.test(input);
      let objStr1 = false;
      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
      console.log("regexp : AlternativeUsingNormalizeTest1 averageTime : " + averageTime1 + "us")
      expect(testStr1).assertEqual(objStr1)
      let startTime2 = new Date().getTime();
      let testStr2 = re.test(normalizePathname(input));
      let objStr2 = true;
      let endTime2 = new Date().getTime();
      let averageTime2 = ((endTime2 - startTime2) * 1000) / BASE_COUNT;
      console.log("regexp : AlternativeUsingNormalizeTest2 averageTime : " + averageTime2 + "us")
      expect(testStr2).assertEqual(objStr2)
    })

    it('ParseTest', 0, () => {
      let startTime1 = new Date().getTime();
      const tokens = parse("/route/:foo/(.*)");
      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
      console.log("regexp : ParseTest averageTime : " + averageTime1 + "us")
      let testStr1 = tokens[0];
      let objStr1 = "/route";

      expect(testStr1).assertEqual(objStr1)

      let testStr2 = JSON.stringify(tokens[1]);
      let options: Options = {
        name: 'foo',
        prefix: '/',
        suffix: '',
        pattern: '[^\\/#\\?]+?',
        modifier: ''
      }
      let objStr2 = JSON.stringify(options);

      expect(testStr2).assertEqual(objStr2);

      let testStr3 = JSON.stringify(tokens[2]);
      let options2: Options = {
        name: 0,
        prefix: '/',
        suffix: '',
        pattern: '.*',
        modifier: ''
      }
      let objStr3 = JSON.stringify(options2);
      expect(testStr3).assertEqual(objStr3);
    })

    it('CompileTest', 0, () => {
      let startTime1 = new Date().getTime();

      let testStr1 = toPath({
        id: 123
      });
      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
      console.log("regexp : CompileTest1 averageTime : " + averageTime1 + "us")
      let objStr1 = "/user/123";
      expect(testStr1).assertEqual(objStr1)
      let startTime2 = new Date().getTime();
      let testStr2 = toPath({
        id: "café"
      });
      let objStr2 = "/user/caf%C3%A9";
      let endTime2 = new Date().getTime();
      let averageTime2 = ((endTime2 - startTime2) * 1000) / BASE_COUNT;
      console.log("regexp : CompileTest2 averageTime : " + averageTime2 + "us")
      expect(testStr2).assertEqual(objStr2);
      let startTime3 = new Date().getTime();
      let testStr3 = toPath({
        id: "/"
      });
      let objStr3 = "/user/%2F";
      let endTime3 = new Date().getTime();
      let averageTime3 = ((endTime3 - startTime3) * 1000) / BASE_COUNT;
      console.log("regexp : CompileTest3 averageTime : " + averageTime3 + "us")
      expect(testStr3).assertEqual(objStr3);
      let startTime4 = new Date().getTime();
      let testStr4 = toPath({
        id: ":/"
      });
      let objStr4 = "/user/%3A%2F";
      let endTime4 = new Date().getTime();
      let averageTime4 = ((endTime4 - startTime4) * 1000) / BASE_COUNT;
      console.log("regexp : CompileTest4 averageTime : " + averageTime4 + "us")
      expect(testStr4).assertEqual(objStr4);

      let startTime5 = new Date().getTime();
      const toPathRaw = compile("/user/:id");
      let testStr5 = toPathRaw({
        id: "%3A%2F"
      });
      let objStr5 = "/user/%3A%2F";
      let endTime5 = new Date().getTime();
      let averageTime5 = ((endTime5 - startTime5) * 1000) / BASE_COUNT;
      console.log("regexp : CompileTest5 averageTime : " + averageTime5 + "us")
      expect(testStr5).assertEqual(objStr5);

      let startTime6 = new Date().getTime();
      let options: Options = {
        validate: false
      }
      const toPathRaw1 = compile("/user/:id", options);
      let testStr6 = toPathRaw1({
        id: ":/"
      });
      let objStr6 = "/user/:/";
      let endTime6 = new Date().getTime();
      let averageTime6 = ((endTime6 - startTime6) * 1000) / BASE_COUNT;
      console.log("regexp : CompileTest6 averageTime : " + averageTime6 + "us")
      expect(testStr6).assertEqual(objStr6);

      let startTime7 = new Date().getTime();
      const toPathRepeated = compile("/:segment+");
      let testStr7 = toPathRepeated({
        segment: "foo"
      }); //=> "/foo"
      let objStr7 = "/foo";
      let endTime7 = new Date().getTime();
      let averageTime7 = ((endTime7 - startTime7) * 1000) / BASE_COUNT;
      console.log("regexp : CompileTest7 averageTime : " + averageTime7 + "us")
      expect(testStr7).assertEqual(objStr7);

      let startTime8 = new Date().getTime();
      let testStr8 = toPathRepeated({
        segment: ["a", "b", "c"]
      }); //=> "/a/b/c"
      let objStr8 = "/a/b/c";
      let endTime8 = new Date().getTime();
      let averageTime8 = ((endTime8 - startTime8) * 1000) / BASE_COUNT;
      console.log("regexp : CompileTest8 averageTime : " + averageTime8 + "us")
      expect(testStr8).assertEqual(objStr8);

      let startTime9 = new Date().getTime();
      const toPathRegexp = compile("/user/:id(\\d+)");
      let testStr9 = toPathRegexp({
        id: 123
      });
      let objStr9 = "/user/123";
      let endTime9 = new Date().getTime();
      let averageTime9 = ((endTime9 - startTime9) * 1000) / BASE_COUNT;
      console.log("regexp : CompileTest9 averageTime : " + averageTime9 + "us")
      expect(testStr9).assertEqual(objStr9);

      let startTime10 = new Date().getTime();
      let testStr10 = toPathRegexp({
        id: "123"
      });
      let objStr10 = "/user/123";
      let endTime10 = new Date().getTime();
      let averageTime10 = ((endTime10 - startTime10) * 1000) / BASE_COUNT;
      console.log("regexp : CompileTest10 averageTime : " + averageTime10 + "us")
      expect(testStr10).assertEqual(objStr10);

      let startTime11 = new Date().getTime();
      try {
        toPathRegexp({
          id: "abc"
        });
      } catch (err) {
        let isTypeErr = false;
        if (err instanceof TypeError) {
          isTypeErr = true;
        }
        let endTime11 = new Date().getTime();
        let averageTime11 = ((endTime11 - startTime11) * 1000) / BASE_COUNT;
        console.log("regexp : CompileTest11 averageTime : " + averageTime11 + "us")
        expect(isTypeErr).assertTrue();
      }
      let startTime12 = new Date().getTime();
      const toPathRegexp1 = compile("/user/:id(\\d+)", options);

      let testStr11 = toPathRegexp1({
        id: "abc"
      });
      let objStr11 = "/user/abc";
      let endTime12 = new Date().getTime();
      let averageTime12 = ((endTime12 - startTime12) * 1000) / BASE_COUNT;
      console.log("regexp : CompileTest12 averageTime : " + averageTime12 + "us")
      expect(testStr11).assertEqual(objStr11);

    })
  })
}

let reg: RegExp = new RegExp("\/+", 'g')
function normalizePathname(pathname: string) {
  return (
  decodeURI(pathname)
    .replace(reg, "/")
    .normalize()
  );
}