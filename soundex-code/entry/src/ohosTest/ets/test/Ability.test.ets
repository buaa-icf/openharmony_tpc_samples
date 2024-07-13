/*
 * Copyright (C) 2023 Huawei Device Co., Ltd.
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
import { soundex } from 'soundex-code'

export default function abilityTest() {
  describe('ActsAbilityTest',  () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() =>{
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() =>{
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    it('assertContain',0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
      let a = 'abc'
      let b = 'b'
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertContain(b)
      expect(a).assertEqual(a)
    })
    let equal =(src:string,dst:string,info?:string) =>{

      expect(src).assertEqual(dst)


      if(info){
        console.log(tag+info)
      }
    }
    interface equalType{
      equal: (src: string, dst: string, info?: string) => void,
    }
    let assert:equalType = {
      equal:equal
    }

    it('soundex', 1, () => {
      assert.equal(soundex('PHONETICS'), soundex('phonetics'), 'case insensitive')
      assert.equal(
        soundex('PhoNeTicS'),
        soundex('phonetics'),
        'case insensitive (2)'
      )

      assert.equal(soundex('p'), 'P000', 'pad')
      assert.equal(soundex('pc'), 'P200', 'pad (2)')
      assert.equal(soundex('pcd'), 'P230', 'pad (3)')
      assert.equal(soundex('pcdl'), 'P234', 'pad (4)')
      assert.equal(soundex('pcdlm'), 'P234', 'pad (5)')
      assert.equal(soundex('pcdlmr'), 'P234', 'pad (6)')

      assert.equal(soundex('b', 2), 'B0', 'max-length argument (1)')
      assert.equal(soundex('bc', 2), 'B2', 'max-length argument (2)')
      assert.equal(soundex('bcd', 2), 'B2', 'max-length argument (3)')
      assert.equal(soundex('bcdl', 2), 'B2', 'max-length argument (4)')
      assert.equal(soundex('bcdlm', 2), 'B2', 'max-length argument (5)')
      assert.equal(soundex('bcdlmr', 2), 'B2', 'max-length argument (6)')

      assert.equal(soundex('b', 6), 'B000', 'max-length argument (7)')
      assert.equal(soundex('bc', 6), 'B200', 'max-length argument (8)')
      assert.equal(soundex('bcd', 6), 'B230', 'max-length argument (9)')
      assert.equal(soundex('bcdl', 6), 'B234', 'max-length argument (10)')
      assert.equal(soundex('bcdlm', 6), 'B2345', 'max-length argument (11)')
      assert.equal(soundex('bcdlmr', 6), 'B23456', 'max-length argument (12)')
      assert.equal(soundex('bcdlmrf', 6), 'B23456', 'max-length argument (13)')

      // Natural provides several unit tests. See:
      // <https://github.com/NaturalNode/natural>

      assert.equal(soundex('blackberry'), 'B421')
      assert.equal(soundex('calculate'), 'C424')
      assert.equal(soundex('fox'), 'F200')
      assert.equal(soundex('jump'), 'J510')
      assert.equal(soundex('phonetics'), 'P532')


      // The PHP implementation, based on Knuths, gives several examples. See:
      // <https://php.net/manual/en/function.soundex.php>

      assert.equal(soundex('Euler'), 'E460')
      assert.equal(soundex('Gauss'), 'G200')
      assert.equal(soundex('Hilbert'), 'H416')
      assert.equal(soundex('Knuth'), 'K530')
      assert.equal(soundex('Lloyd'), 'L300')
      assert.equal(soundex('Lukasiewicz'), 'L222')
      assert.equal(soundex('Ellery'), 'E460')
      assert.equal(soundex('Ghosh'), 'G200')
      assert.equal(soundex('Heilbronn'), 'H416')
      assert.equal(soundex('Kant'), 'K530')
      assert.equal(soundex('Ladd'), 'L300')
      assert.equal(soundex('Lissajous'), 'L222')

      // The original implementation gives several examples. See:
      // <https://www.archives.gov/research/census/soundex.html>

      assert.equal(soundex('Washington'), 'W252')
      assert.equal(soundex('Lee'), 'L000')
      assert.equal(soundex('Gutierrez'), 'G362')
      assert.equal(soundex('Pfister'), 'P236')
      assert.equal(soundex('Jackson'), 'J250')
      assert.equal(soundex('Tymczak'), 'T522')
      assert.equal(soundex('VanDeusen'), 'V532')
      assert.equal(soundex('Deusen'), 'D250')
      assert.equal(soundex('Ashcraft'), 'A261')
    })

  })
}