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
import {
  clamp,
  inRange,
  random } from 'lodash';

export default function numberTest() {
  describe('NumberTest', () => {
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
    it('clampTest01',0, () => {
      expect(clamp(-10, -5, 5)).assertEqual(-5);
    })

    it('clampTest02',0, () => {
      expect(clamp(10, -5, 5)).assertEqual(5);
    })

    it('inRangeTest01',0, () => {
      expect(inRange(3, 2, 4)).assertTrue();
    })

    it('inRangeTest02',0, () => {
      expect(inRange(2, 2)).assertFalse();
    })

    it('randomTest01',0, () => {
      let actual: number[] = [
      random(Number.MIN_VALUE, Number.MIN_VALUE),
      random('1', '1'),
      random(Math.PI, Math.PI)
      ];
      expect(JSON.stringify(actual)).assertEqual('[5e-324,1,3.141592653589793]');
    })

    it('randomTest02',0, () => {
      let actual: number[] = [
      random(Number.MIN_VALUE, Number.MIN_VALUE),
      ];
      expect(JSON.stringify(actual)).assertEqual('[5e-324]');
    })
  })
}