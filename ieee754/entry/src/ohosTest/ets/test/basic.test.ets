/**
 * BSD License
 *
 * Copyright (c) 2024 Huawei Device Co., Ltd. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * * Redistributions of source code must retain the above copyright notice, this
 *  list of conditions and the following disclaimer.
 *
 * * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * * Neither the name Facebook nor the names of its contributors may be used to
 * endorse or promote products derived from this software without specific
 * prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
import hilog from '@ohos.hilog';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import * as ieee754 from 'ieee754'
import {Buffer} from "buffer/"

export default function basicTest() {

  const EPSILON = 0.00001

  describe('basicTest', () => {
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
    it('test01', 0, () => {
      let val = 42.42
      let buf:ESObject = Buffer.alloc(4)

      buf.writeFloatLE(val, 0)
      let num = ieee754.read(buf, 0, true, 23, 4)
      expect(Math.abs(num - val) < EPSILON).assertDeepEquals(true)
    })
    it('test02', 0, () => {
      const val = 42.42
      let buf:ESObject = Buffer.alloc(4)

      ieee754.write(buf, val, 0, true, 23, 4)
      let num:ESObject = buf.readFloatLE(0)
      expect(Math.abs(num - val) < EPSILON).assertDeepEquals(true)
    })
    it('test03', 0, () => {
      const value = 12345.123456789
      const buf:ESObject = Buffer.alloc(8)

      buf.writeDoubleLE(value, 0)
      const num = ieee754.read(buf, 0, true, 52, 8)
      expect(Math.abs(num - value) < EPSILON).assertDeepEquals(true)
    })
    it('test04', 0, () => {
      const value = 12345.123456789
      const buf:ESObject = Buffer.alloc(8)

      ieee754.write(buf, value, 0, true, 52, 8)
      const num:ESObject = buf.readDoubleLE(0)
      expect(Math.abs(num - value) < EPSILON).assertDeepEquals(true)
    })
  })
}