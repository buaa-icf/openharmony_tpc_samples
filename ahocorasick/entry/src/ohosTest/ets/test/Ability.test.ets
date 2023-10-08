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

import AhoCorasick from 'ahocorasick'

export default function abilityTest() {
  describe('ActsAbilityTest', ()=> {
    it('AhoCorasick_Search_1', 0, ()=> {
      let keys = ['keyword1', 'keyword2', 'etc'];
      let text = 'should find keyword1 at position 19 and keyword2 at position 30.'
      let expected = [[19, ['keyword1']],[47,["keyword2"]]]
      let aho:AhoCorasick = new AhoCorasick(keys);
      let result:Object = aho.search(text)
      expect(JSON.stringify(expected)).assertEqual(JSON.stringify(result))
    })

    it('AhoCorasick_Search_2', 0, ()=> {
      let keys = ['hero', 'heroic'];
      let text = 'hero'
      let expected = [[3, ['hero']]]
      let aho:AhoCorasick = new AhoCorasick(keys);
      let result:Object[] = aho.search(text)
      expect(JSON.stringify(expected)).assertEqual(JSON.stringify(result))
    })
  })
}