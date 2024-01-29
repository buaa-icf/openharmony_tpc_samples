/*
 * This software is dual-licensed under Apache 2.0 and WTFPL
 * Copyright (C) 2024 Huawei Device Co., Ltd.
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
 *
 * DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
 *                   Version 2, December 2004
 * Everyone is permitted to copy and distribute verbatim or modified
 * copies of this license document, and changing it is allowed as long
 * as the name is changed.
 *             DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
 *   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
 *   0. You just DO WHAT THE FUCK YOU WANT TO.
 */

import { btoa, atob } from 'Base64'
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
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
it ('can_encode_ASCII_input' , 0, () => {
      expect(btoa ('')).assertEqual('');
      expect(btoa ('f')).assertEqual('Zg==');
      expect(btoa ('fo')).assertEqual('Zm8=');
      expect(btoa ('foo')).assertEqual('Zm9v');
      expect(btoa ('quux')).assertEqual('cXV1eA==');
      expect(btoa ('!"#$%')).assertEqual('ISIjJCU=');
      expect(btoa ("&'()*+")).assertEqual('JicoKSor');
      expect(btoa (',-./012')).assertEqual('LC0uLzAxMg==');
      expect(btoa ('3456789:')).assertEqual('MzQ1Njc4OTo=');
      expect(btoa (';<=>?@ABC')).assertEqual('Ozw9Pj9AQUJD');
      expect(btoa ('DEFGHIJKLM')).assertEqual('REVGR0hJSktMTQ==');
      expect(btoa ('NOPQRSTUVWX')).assertEqual('Tk9QUVJTVFVWV1g=');
      expect(btoa ('YZ[\\]^_`abc')).assertEqual('WVpbXF1eX2BhYmM=');
      expect(btoa ('defghijklmnop')).assertEqual('ZGVmZ2hpamtsbW5vcA==');
      expect(btoa ('qrstuvwxyz{|}~')).assertEqual('cXJzdHV2d3h5ent8fX4=');
    });

    it ('encodeTest', 0, () => {
      expect(String.fromCharCode (0x2708)).assertEqual('✈');
    });

    it ('coerces_input', 0, () => {
      expect(btoa (42)).assertEqual(btoa ('42'));
      expect(btoa (null)).assertEqual(btoa ('null'));
      expect(btoa ({x: 1})).assertEqual(btoa ('[object Object]'));
    });

    it ('can_decode_Base64_encoded_input', 0, () => {
      expect(atob('')).assertEqual('');
      expect(atob('Zg==')).assertEqual('f');
      expect(atob('Zm8=')).assertEqual('fo');
      expect(atob('Zm9v')).assertEqual('foo');
      expect(atob('cXV1eA==')).assertEqual('quux');
      expect(atob('ISIjJCU=')).assertEqual('!"#$%');
      expect(atob('JicoKSor')).assertEqual("&'()*+");
      expect(atob('LC0uLzAxMg==')).assertEqual(',-./012');
      expect(atob('MzQ1Njc4OTo=')).assertEqual('3456789:');
      expect(atob('Ozw9Pj9AQUJD')).assertEqual(';<=>?@ABC');
      expect(atob('REVGR0hJSktMTQ==')).assertEqual('DEFGHIJKLM');
      expect(atob('Tk9QUVJTVFVWV1g=')).assertEqual('NOPQRSTUVWX');
      expect(atob('WVpbXF1eX2BhYmM=')).assertEqual('YZ[\\]^_`abc');
      expect(atob('ZGVmZ2hpamtsbW5vcA==')).assertEqual('defghijklmnop');
      expect(atob('cXJzdHV2d3h5ent8fX4=')).assertEqual('qrstuvwxyz{|}~');
    });

    it ('coerces_input', 0, () => {
      expect(atob (42)).assertEqual(atob ('42'));
      expect(atob (null)).assertEqual(atob ('null'));
    });

    it ('encodeTest', 0, () => {
      //can encode every character in [U+0000, U+00FF]
      for (let code = 0x0; code <= 0xFF; code += 0x1) {
        let char = String.fromCharCode (code);
        expect(atob (btoa (char))).assertEqual(char);
      }
    });
  })
}