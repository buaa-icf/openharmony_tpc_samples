/**
 * MIT License
 *
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the 'Software'), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to all conditions.
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import { describe, it, expect } from '@ohos/hypium'
import { postcss } from '@ohos/postcss'

export default function atRuleTest() {
  describe('atRuleTest', () => {
    it('test01', 0, () => {
      let rule = new postcss.AtRule({
        name: 'encoding', params: '"utf-8"'
      })
      expect(rule.name).assertDeepEquals('encoding')
    })
    it('test02', 0, () => {
      let rule = new postcss.AtRule({
        name: 'encoding', params: '"utf-8"'
      })
      expect(rule.params).assertDeepEquals('"utf-8"')
    })
    it('test03', 0, () => {
      let rule = new postcss.AtRule({
        name: 'encoding', params: '"utf-8"'
      })
      expect(rule.toString()).assertDeepEquals('@encoding "utf-8"')
    })
    it('test04', 0, () => {
      let rule = new postcss.AtRule()
      rule.each(() => {
        throw new Error('AtRule has no children')
      })
    })
    it('test05', 0, () => {
      let rule = new postcss.AtRule()
      expect(rule.nodes).assertUndefined()
      rule.prepend('color: black')
      expect(rule.nodes?.length).assertDeepEquals(1)
    })
    it('test06', 0, () => {
      let rule = new postcss.AtRule()
      expect(rule.nodes).assertUndefined()
      rule.append('color: black')
      expect(rule.nodes?.length).assertDeepEquals(1)
    })
    it('test07', 0, () => {
      let rule = new postcss.AtRule({
        name: 'page', nodes: [], params: 1
      })
      expect(rule.toString()).assertDeepEquals('@page 1 {}')
    })
    it('test08', 0, () => {
      let root = postcss.parse('@page{}a{}')
      let rule = new postcss.AtRule({
        name: 'page', nodes: [], params: 1
      })
      root.append(rule)
      expect(rule.toString()).assertDeepEquals('@page 1{}')
    })
    it('test09', 0, () => {
      let root = postcss.parse('@layer a, b, c;')
      let layer = root.first as postcss.AtRule
      expect(layer.nodes).assertUndefined()
    })
  })
}