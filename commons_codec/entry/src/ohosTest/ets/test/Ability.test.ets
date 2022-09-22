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
import jsBase64 from 'js-base64'
import jsBase32 from 'hi-base32'

import jsMd5 from 'js-md5'
import jsMd2 from 'js-md2'
import jsSha256 from 'js-sha256'
import jsSha1 from 'js-sha1'
import jsCaverPhone from 'caverphone'
import { soundex } from 'soundex-code'
import { metaphone } from 'metaphone'

export default function abilityTest() {
  describe('ActsAbilityTest', function () {
    it('Base63_encode', 0, function () {
      var source = '小飼弾'
      var result = '5bCP6aO85by+'
      var results = jsBase64.encode(source)
      expect(result).assertEqual(results)
    })

    it('Base63_decode', 0, function () {
      var source = '5bCP6aO85by+'
      var result = '小飼弾'
      var results = jsBase64.decode(source)
      expect(result).assertEqual(results)
    })
    it('Base32_encode', 0, function () {
      expect(jsBase32.encode([72, 101, 108, 108])).assertEqual('JBSWY3A=');
      expect(jsBase32.encode([72, 101, 108, 108, 111])).assertEqual('JBSWY3DP');
    })
    it('Base32_decode', 0, function () {
      expect(jsBase32.decode('JA======')).assertEqual('H');
      expect(jsBase32.decode('JBSWY3DP')).assertEqual('Hello');
    })

    it('md2', 0, function () {
      expect(jsMd2('𠜎')).assertEqual('434fc70b04f5ce106b1463f2201223a2');
      expect(jsMd2('')).assertEqual('8350e5a3e24c153df2275c9f80692773');
      expect(jsMd2('The quick brown fox jumps over the lazy dog')).assertEqual('03d85a0d629d2c442e987525319fc471');
    })

    it('md5', 0, function () {
      expect(jsMd5('𠜎')).assertEqual('b90869aaf121210f6c563973fa855650');
      expect(jsMd5('The quick brown fox jumps over the lazy dog')).assertEqual('9e107d9d372bb6826bd81d3542a419d6');
    })

    it('SHA1', 0, function () {
      expect(jsSha1('𠜎')).assertEqual('4667688a63420661469c8dbc0f871770349bab08');
      expect(jsSha1('The quick brown fox jumps over the lazy dog'))
        .assertEqual('2fd4e1c67a2d28fced849ee1bb76e7391b93eb12');
    })

    it('SHA256', 0, function () {
      expect(jsSha256.sha256('𠜎')).assertEqual('8d10a48685dbc34484696de7ea7434d80a54c1d60100530faccf697463ef19c9');
      expect(jsSha256.sha256('The quick brown fox jumps over the lazy dog'))
        .assertEqual('d7a8fbb307d7809469ca9abcb0082e4f8d5651e46d3cdb762d02d0bf37c9e592');
    })

    it('caverphone', 0, function () {
      expect(jsCaverPhone('word')).assertEqual('WT11111111');
    })

    it('metaphone', 0, function () {
      expect(metaphone('Xavier')).assertEqual('SFR');
      expect(metaphone('acceptingness')).assertEqual('AKSPTNKNS');
    })

    it('soundex', 0, function () {
      expect(soundex('phonetics')).assertEqual('P532');
      expect(soundex('Ashcraftersson', 6)).assertEqual('A26136');
    })

  })
}