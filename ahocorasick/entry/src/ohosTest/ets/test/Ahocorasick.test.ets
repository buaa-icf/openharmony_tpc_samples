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
import {describe, expect, it } from '@ohos/hypium'

import AhoCorasick from 'ahocorasick'

export default function ahocorasickTest() {
  var testCases = [
    {
      keywords: ['hero', 'heroic'],
      text: 'hero',
      expected: [
        [3, ['hero']]
      ]
    },
    {
      keywords: ['hero', 'heroic', 'heroism'],
      text: 'the hero performed a heroic act of heroism',
      expected: [
      // "hero" is a substring of "heroic" and "heroism", so we should find it 3 times
        [7, ['hero']],
        [24, ['hero']],
        [26, ['heroic']],
        [38, ['hero']],
        [41, ['heroism']]
      ]
    },
    {
      keywords: ['keyword1', 'keyword2', 'etc'],
      text: 'should find keyword1 at position 19 and keyword2 at position 30.',
      expected: [
        [19, ['keyword1']],
        [47, ['keyword2']]
      ]
    },
    {
      keywords: ['he', 'she', 'his', 'hers'],
      text: 'she was expecting his visit',
      expected: [
        [2, ['he', 'she']],
        [20, ['his']]
      ]
    },
    {
      keywords: ['çp?', 'éâà'],
      text: 'éâàqwfwéâéeqfwéâàqef àéçp?ẃ wqqryht cp?',
      expected: [
        [2, ['éâà']],
        [16, ['éâà']],
        [25, ['çp?']]
      ]
    },
    {
      keywords: ['**', '666', 'his', 'n', '\\', '\n'],
      text: '\n & 666 ==! \n',
      expected: [
        [0, ['\n']],
        // [20, ['his']]
        [6, ['666']],
        [12, ['\n']]
      ]
    },
    {
      keywords: ['Федеральной', 'ной', 'idea'],
      text: '! Федеральной I have no idea what this means.',
      expected: [
        [12, ['Федеральной', 'ной']],
        [27, ['idea']]
      ]
    },
    {
      keywords: ['.com.au', '.com'],
      text: 'www.yahoo.com',
      expected: [
        [12, ['.com']]
      ]
    }
  ].map(function (ts) {
    ts.expected = ts.expected.map(function (expected) {
      if (typeof expected[1] == "object" && Array.isArray(expected[1])) {
        expected[1] = expected[1].sort();
      }
      return expected;
    });
    return ts;
  });

  var _s = AhoCorasick.prototype.search;
  AhoCorasick.prototype.searchKeyWord = function (string) {
    var results = _s.call(this, string).map(function (result) {
      if (typeof result[1] == "object" && Array.isArray(result[1])) {
        result[1] = result[1].sort();
      }
      return result;
    });
    return results;
  };

  describe('AhocorasickTest', function () {
    it('AhoCorasick_Test', 0, function () {
      var count = 0;
      testCases.forEach(function (ts) {
        var keys = ts.keywords;
        var text = ts.text;
        var expected = ts.expected;

        it('AhoCorasick_search_keys' + count, 0, function () {
          var aho = new AhoCorasick(keys);
          expect(aho.searchKeyWord(text)).assertDeepEquals(expected);
        });
        count++;
      });
    })

    it('AhoCorasick_search_emoji', 0, function () {
      var aho = new AhoCorasick(['bla', '😁', '😀', '😀😁😀']);
      expect(aho.searchKeyWord('Bla 😁 bla 😀 1 😀 - 😀😁😀-')).assertDeepEquals([
      [5, ['😁']],
      [9, ['bla']],
      [12, ['😀']],
      [17, ['😀']],
      [22, ['😀']],
      [24, ['😁']],
      [26, ['😀', '😀😁😀']],
      ]);
    })

    it('AhoCorasick_search_emoji2', 0, function () {
      var aho = new AhoCorasick(['bla', '😁', '😀', '°□°', 'w', '┻━┻']);
      expect(aho.searchKeyWord("-  (╯°□°）╯︵ ┻━┻ ")).assertDeepEquals([
      [7, ['°□°']],
      [14, ['┻━┻']],
      ]);
    })
  })
}