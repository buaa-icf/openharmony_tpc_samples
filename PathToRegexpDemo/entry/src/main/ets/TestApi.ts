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

import { compile, Key, Keys, match, parse, pathToRegexp } from 'path-to-regexp';

interface result  {
  regexp:RegExp;
  keys:Keys;
}

export default class TestApi {
  constructor() {
  }

  public pathToRegexpTest(param?: string): result {
    try {
      const regexp = pathToRegexp(param);
      return regexp;
    } catch (err) {
      throw err
    }
  }

  public namedParametersTest(param?: string): object {
    try {
      const res = pathToRegexp(param);
      const result = res.regexp.exec('/test/route')
      return result;
    } catch (err) {
      return err
    }
  }

  public customMatchingParametersTest(param?: string, keys?: Key[]): Array<object> {
    const result = []
    try {
      const regexpNumbers = pathToRegexp('/icon-:foo.png');
      const firstResult = regexpNumbers.regexp.exec('/icon-123.png');
      result.push(firstResult);
      const secondResult = regexpNumbers.regexp.exec('/icon-abc.png')
      result.push(secondResult);
      const regexpWord = pathToRegexp('/:foo');
      const thirdResult = regexpWord.regexp.exec('/u');
      result.push(thirdResult);
      const fourResult = regexpWord.regexp.exec('/users');
      result.push(fourResult);

      return result;
    } catch (err) {
      result.push(err);
      return result
    }
  }


  public customPrefixSuffixTest(param?: string, keys?: Key[]): Array<object> {
    const result = []
    try {
      const res = pathToRegexp("/:attr");
      const single = res.regexp.exec('/test');
      result.push(single);
      const double = res.regexp.exec('/test-test')
      result.push(double);
      return result;
    } catch (err) {
      result.push(err);
      return result
    }
  }

  public unNamedParametersTest(param?: string, keys?: Key[]): object {
    try {
      const res = pathToRegexp("/:foo/:bar");
      const unNamed = res.regexp.exec('/test/route');
      return unNamed;
    } catch (err) {
      return err
    }
  }

  public modifiersPageTest(param?: string, keys?: Key[]): Array<object> {
    const result = []
    try {
      const res = pathToRegexp('/:foo/:bar');
      const single = res.regexp.exec('/test');
      result.push(single);
      const double = res.regexp.exec('/test/route')
      result.push(double);
      return result;
    } catch (err) {
      result.push(err);
      return result
    }
  }

  public optionalTest(param?: string, keys?: Key[]): Array<object> {
    const result = []
    try {
      const res = pathToRegexp('/search/:tableName\\?useIndex=true&term=amazing');
      const positive = res.regexp.exec('/search/people?useIndex=true&term=amazing');
      result.push(positive);
      const reverse = res.regexp.exec('/search/people?term=amazing&useIndex=true');
      result.push(reverse);
      return result;
    } catch (err) {
      result.push(err);
      return result
    }
  }

  public zeroTest(param?: string, keys?: Key[]): Array<object> {
    const result = []
    try {
      const res = pathToRegexp("/:foo");
      const single = res.regexp.exec('/');
      result.push(single);
      const double = res.regexp.exec('/bar/baz')
      result.push(double);
      return result;
    } catch (err) {
      result.push(err);
      return result
    }
  }

  public oneTest(param?: string, keys?: Key[]): Array<object> {
    const result = []
    try {
      const res = pathToRegexp('/:foo');
      const single = res.regexp.exec('/');
      result.push(single);
      const double = res.regexp.exec('/bar/baz')
      result.push(double);
      return result;
    } catch (err) {
      result.push(err);
      return result
    }
  }


  public matchTest(param?: string, keys?: Key[]): Array<object> {
    const result = []
    try {
      const fn = match('/user/:id', {
        decode: decodeURIComponent
      });
      const number = fn('/user/123');
      result.push(number);
      const invalid = fn('/invalid')
      result.push(invalid);
      const decode = fn('/user/caf%c3%A9')
      result.push(decode);

      const urlMatch = match('/users/:id/:tab', {
        decode: decodeURIComponent
      });
      const photos = urlMatch('/users/1234/photos');
      result.push(photos);
      const bio = urlMatch('/users/1234/bio');
      result.push(bio);
      const otherstuff = urlMatch('/users/1234/otherstuff');
      result.push(otherstuff);
      return result;
    } catch (err) {
      result.push(err);
      return result
    }
  }

  public processPathnameTest(param?: string, keys?: Key[]): Array<object> {
    const result = []
    try {
      const fn = match("/café", {
        encodePath: encodeURI
      });
      const number = fn("/caf%C3%A9");
      result.push(number);
      return result;
    } catch (err) {
      result.push(err);
      return result
    }
  }

  public alternativeTest(param?: string, keys?: Key[]): Array<object> {
    const result = new Array()
    try {
      const re = pathToRegexp('/caf\u00E9');
      const input = encodeURI('/cafe\u0301');

      const testPath = re.regexp.test(input);
      result.push(testPath);
      const testDiy = re.regexp.test(this.normalizePathname(input));
      result.push(testDiy);
      return result;
    } catch (err) {
      result.push(err);
      return result
    }
  }

  public parseTest(param?: string, keys?: Key[]): Array<object> {
    const result = []
    try {
      const tokens = parse('/route/:foo/:bar');
      result.push(tokens[0]);
      result.push(tokens[1]);
      result.push(tokens[2]);
      return result;
    } catch (err) {
      result.push(err);
      return result
    }
  }

  public compileTest(param?: string, keys?: Key[]): Array<object> {
    const result = []
    try {
      const toPath = compile('/user/:id', {
        encode: encodeURIComponent
      });
      let number = toPath({
        id: "123"
      })
      result.push(number);
      let words = toPath({
        id: "café"
      })
      result.push(words);
      let symbol = toPath({
        id: '/'
      })
      result.push(symbol);
      let doubleSymbol = toPath({
        id: ':/'
      })
      result.push(doubleSymbol);

      const toPathRaw = compile('/user/:id');
      let decode = toPathRaw({
        id: '%3A%2F'
      })
      result.push(decode);

      const toPathRepeated = compile('/:segment');
      let segment = toPathRepeated({
        segment: 'foo'
      })
      result.push(segment);
      let segments = toPathRepeated({
        segment: "a"
      })
      result.push(segments);

      const toPathRegexp = compile('/user/:id');
      let numberRegexp = toPathRegexp({
        id: "123"
      })
      result.push(numberRegexp);
      let wordRegexp = toPathRegexp({
        id: '123'
      })
      result.push(wordRegexp);

      let lettersRegexp = toPathRegexp({
        id: 'abc'
      })
      result.push(lettersRegexp);


      return result;
    } catch (err) {
      result.push('Throws `TypeError`');
      return result
    }
  }

  private normalizePathname(pathname: string): string {
    try {

      return (decodeURI(pathname).replace(/\/+/g, '/')).normalize();
    } catch (err) {
      return JSON.stringify(err)
    }
  }
}