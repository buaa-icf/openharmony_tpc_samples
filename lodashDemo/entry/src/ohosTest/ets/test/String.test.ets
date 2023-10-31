/*
 * Copyright (C) 2021 Huawei Device Co., Ltd.
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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { camelCase, capitalize, deburr, endsWith, escape, escapeRegExp, kebabCase, lowerCase, lowerFirst,
  map,
  pad,
  padEnd,
  padStart,
  repeat,
  replace,
  snakeCase,
  split,
  startCase,
  startsWith,
  toLower,
  toUpper,
  trim,
  trimEnd,
  trimStart,
  truncate,
  unescape,
  upperCase,
  upperFirst,
  words
} from 'lodash'

export default function stringTest() {
  describe('StringTest', function () {
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
    it('camelCaseTest01',0, function () {
      expect(camelCase('Foo Bar')).assertEqual('fooBar');
    })

    it('camelCaseTest02',0, function () {
      expect(camelCase('--foo-bar--')).assertEqual('fooBar');
    })

    it('capitalizeTest01',0, function () {
      expect(capitalize('FRED')).assertEqual('Fred');
    })

    it('capitalizeTest02',0, function () {
      expect(capitalize('hello')).assertEqual('Hello');
    })

    it('deburrTest01',0, function () {
      expect(deburr('déjà vu')).assertEqual('deja vu');
    })

    it('deburrTest02',0, function () {
      expect(deburr('ãäåæçè')).assertEqual('aaaaece');
    })

    it('endsWithTest01',0, function () {
      expect(endsWith('abc', 'c')).assertTrue();
    })

    it('endsWithTest02',0, function () {
      expect(endsWith('abc', 'b', 2)).assertTrue();
    })

    it('escapeTest01',0, function () {
      expect(escape('fred, barney, & pebbles')).assertEqual('fred, barney, &amp; pebbles');
    })

    it('escapeTest02',0, function () {
      expect(escape('hello, a&b, `world`')).assertEqual('hello, a&amp;b, &#96;world&#96;');
    })

    it('escapeRegExpTest01',0, function () {
      expect(escapeRegExp('[lodash]+(HELLO)')).assertDeepEquals('\\[lodash\\]\\+\\(HELLO\\)');
    })

    it('escapeRegExpTest02',0, function () {
      expect(escapeRegExp('[hello],[($10000)]World!')).assertDeepEquals('\\[hello\\],\\[\\(\\$10000\\)\\]World!');
    })

    it('kebabCaseTest01',0, function () {
      expect(kebabCase('Foo Bar')).assertEqual('foo-bar');
    })

    it('kebabCaseTest02',0, function () {
      expect(kebabCase('__FOO_BAR__')).assertEqual('foo-bar')
    })

    it('lowerCaseTest01',0, function () {
      expect(lowerCase('Foo Bar')).assertEqual('foo bar');
    })

    it('lowerCaseTest02',0, function () {
      expect(lowerCase('__FOO_BAR__')).assertEqual('foo bar')
    })

    it('lowerFirstTest01',0, function () {
      expect(lowerFirst('Fred')).assertEqual('fred');
    })

    it('lowerFirstTest02',0, function () {
      expect(lowerFirst('FRED')).assertEqual('fRED')
    })

    it('padTest01',0, function () {
      expect(pad('abc', 8)).assertEqual('  abc   ');
    })

    it('padTest02',0, function () {
      expect(pad('abc', 8, '_-')).assertEqual('_-abc_-_')
    })

    it('padEndTest01',0, function () {
      expect(padEnd('abc', 6)).assertEqual('abc   ');
    })

    it('padEndTest02',0, function () {
      expect(padEnd('abc', 6, '_-')).assertEqual('abc_-_');
    })

    it('padStartTest01',0, function () {
      expect(padStart('abc', 6)).assertEqual('   abc');
    })

    it('padStartTest02',0, function () {
      expect(padStart('abc', 3)).assertEqual('abc');
    })

    it('parseIntTest01',0, function () {
      expect(parseInt('08')).assertEqual(8);
    })

    it('parseIntTest02',0, function () {
      let parseArray = map(['6', '08', '10'], parseInt)
      expect(JSON.stringify(parseArray)).assertEqual('[6,null,2]');
    })

    it('repeatTest01',0, function () {
      expect(repeat('*', 3)).assertEqual('***');
    })

    it('repeatTest02',0, function () {
      expect(repeat('abc', 2)).assertEqual('abcabc');
    })

    it('replaceTest01',0, function () {
      expect(replace('Hi Fred', 'Fred', 'Barney')).assertEqual('Hi Barney');
    })

    it('replaceTest02',0, function () {
      expect(replace('Stay In', 'In', 'Safe')).assertEqual('Stay Safe');
    })

    it('snakeCaseTest01',0, function () {
      expect(snakeCase('Foo Bar')).assertEqual('foo_bar');
    })

    it('snakeCaseTest02',0, function () {
      expect(snakeCase('--FOO-BAR--')).assertEqual('foo_bar');
    })

    it('splitTest01',0, function () {
      expect(JSON.stringify(split('a-b-c', '-', 2))).assertEqual('["a","b"]');
    })

    it('splitTest02',0, function () {
      expect(JSON.stringify(split('A#B#C', '#', 3))).assertEqual('["A","B","C"]');
    })

    it('startCaseTest01',0, function () {
      expect(startCase('--foo-bar--')).assertEqual('Foo Bar');
    })

    it('startCaseTest02',0, function () {
      expect(startCase('__FOO_BAR__')).assertEqual('FOO BAR');
    })

    it('startsWithTest01',0, function () {
      expect(startsWith('abc', 'a')).assertTrue();
    })

    it('startsWithTest02',0, function () {
      expect(startsWith('abc', 'b')).assertFalse();
    })

    it('toLowerTest01',0, function () {
      expect(toLower('--Foo-Bar--')).assertEqual('--foo-bar--');
    })

    it('toLowerTest02',0, function () {
      expect(toLower('__FOO_BAR__')).assertEqual('__foo_bar__');
    })

    it('toUpperTest01',0, function () {
      expect(toUpper('--foo-bar--')).assertEqual('--FOO-BAR--');
    })

    it('toUpperTest02',0, function () {
      expect(toUpper('__foo_bar__')).assertEqual('__FOO_BAR__');
    })

    it('trimTest01',0, function () {
      expect(trim('  abc  ')).assertEqual('abc');
    })

    it('trimTest02',0, function () {
      expect(JSON.stringify(map(['  foo  ', '  bar  '], trim))).assertEqual('["foo","bar"]');
    })

    it('trimEndTest01',0, function () {
      expect(trimEnd('  abc  ')).assertEqual('  abc');
    })

    it('trimEndTest02',0, function () {
      expect(trimEnd('-_-abc-_-', '_-')).assertEqual('-_-abc');
    })

    it('trimStartTest01',0, function () {
      expect(trimStart('  abc  ')).assertEqual('abc  ');
    })

    it('trimStartTest02',0, function () {
      expect(trimStart('-_-abc-_-', '_-')).assertEqual('abc-_-');
    })

    it('truncateTest01',0, function () {
      expect(truncate('hi-diddly-ho there, neighborino')).assertEqual('hi-diddly-ho there, neighbo...');
    })

    it('truncateTest02',0, function () {
      let string = truncate('hi-diddly-ho there, neighborino', {
        'omission': ' [...]'
      });
      expect(string).assertEqual('hi-diddly-ho there, neig [...]');
    })

    it('unescapeTest01',0, function () {
      expect(unescape('fred, barney, &amp; pebbles')).assertEqual('fred, barney, & pebbles');
    })

    it('unescapeTest02',0, function () {
      expect(unescape('hello, &amp; &gt; world!')).assertEqual('hello, & > world!');
    })

    it('upperCaseTest01',0, function () {
      expect(upperCase('--foo-bar')).assertEqual('FOO BAR');
    })

    it('upperCaseTest02',0, function () {
      expect(upperCase('__foo_bar__')).assertEqual('FOO BAR');
    })

    it('upperFirstTest01',0, function () {
      expect(upperFirst('fred')).assertEqual('Fred');
    })

    it('upperFirstTest02',0, function () {
      expect(upperFirst('FRED')).assertEqual('FRED');
    })

    it('wordsTest01',0, function () {
      expect(JSON.stringify(words('fred, barney, & pebbles'))).assertEqual('["fred","barney","pebbles"]');
    })

    it('wordsTest02',0, function () {
      expect(JSON.stringify(words('fred, barney, & pebbles', /[^, ]+/g))).assertEqual('["fred","barney","&","pebbles"]');
    })
  })
}