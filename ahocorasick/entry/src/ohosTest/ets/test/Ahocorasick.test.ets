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
import {ahoCorasick,testCases}  from './AhocorasickData'
export default function ahocorasickTest() {

  describe('AhocorasickTest', ()=> {
    it('AhoCorasick_Test', 0, ()=> {
      let count = 0;
      testCases.forEach( (ts)=> {
        let keys = ts.keywords;
        let text = ts.text;
        let expected = ts.expected;

        it('AhoCorasick_search_keys' + count, 0, ()=> {
          let aho:AhoCorasick = ahoCorasick(keys);
          expect(aho.searchKeyWord(text)).assertDeepEquals(expected);
        });
        count++;
      });
    })

    it('AhoCorasick_search_emoji', 0, ()=> {
      let aho:AhoCorasick = ahoCorasick(['bla', '😁', '😀', '😀😁😀']);
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

    it('AhoCorasick_search_emoji2', 0, ()=> {
      let aho:AhoCorasick = ahoCorasick(['bla', '😁', '😀', '°□°', 'w', '┻━┻']);
      expect(aho.searchKeyWord("-  (╯°□°）╯︵ ┻━┻ ")).assertDeepEquals([
      [7, ['°□°']],
      [14, ['┻━┻']],
      ]);
    })
  })
}