/*
 * MIT License
 *
 * Copyright (C) 2024 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import timers from 'timers/'

export default function abilityTest() {
  describe('ActsAbilityTest', () => {

    it('string_parse_1', 0, () => {
      expect(timers.every('10ms').time).assertEqual(10)
    })

    it('string_parse_2', 0, () => {
      expect(timers.every('2s').time).assertEqual(2000)
    })

    it('string_parse_3', 0, () => {
      expect(timers.every('2.5m').time).assertEqual(150000)
    })

    it('string_parse_4', 0, () => {
      expect(timers.every('2h').time).assertEqual(7200000)
    })

    it('string_parse_5', 0, () => {
      expect(timers.every('2d').time).assertEqual(172800000)
    })

    it('string_parse_6', 0, () => {
      expect(timers.every('2hour').time).assertEqual(7200000)
    })

    it('string_parse_7', 0, () => {
      expect(timers.every('2 hour').time).assertEqual(7200000)
    })

    it('string_parse_8', 0, () => {
      expect(timers.every('2 hours').time).assertEqual(7200000)
    })

    it('string_parse_9', 0, () => {
      expect(timers.every(' 2  day ').time).assertEqual(172800000)
    })

    it('string_parse_10', 0, () => {
      expect(timers.every('2days ').time).assertEqual(172800000)
    })

    it('every_do', 0, () => {
      let count: number = 0
      timers.every('10ms').do(()=>{
        count ++
      })

      setTimeout(()=>{
        expect(count).assertEqual(1)
      },15)

      setTimeout(()=>{
        expect(count).assertEqual(2)
      },25)
    })

    it('every_stop', 0, () => {
      let count: number = 0
      let obj:ESObject = timers.every('10ms')
      obj.do(()=>{
        count ++
      })

      setTimeout(()=>{
        expect(count).assertEqual(1)
        clearInterval(0)
        obj.stop()
      },15)

      setTimeout(()=>{
        expect(count).assertEqual(1)
      },25)
    })
  })
}