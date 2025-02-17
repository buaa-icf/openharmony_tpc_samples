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
import { postcss, Rule } from '@ohos/postcss'

function checkOffset(source: string, node: postcss.Node, expected: string): void {
  let start = node.source!.start!.offset
  let end = node.source!.end!.offset
  expect(source.slice(start, end)).assertDeepEquals(expected)
}

export default function locationTest() {
  describe('locationTest', () => {
    it('rule', 0, () => {
      let source = '.a{}'
      let css = postcss.parse(source)

      let rule = css.first as Rule
      checkOffset(source, rule, '.a{}')
      expect(rule.source!.start).assertDeepEquals({
        column: 1,
        line: 1,
        offset: 0
      })
      expect(rule.source!.end).assertDeepEquals({
        column: 4,
        line: 1,
        offset: 4
      })
    })

    it('single_decl_(no_semicolon)', 0, () => {
      let source = '.a{b:c}'
      let css = postcss.parse(source)

      let rule = css.first as Rule
      let decl = rule.first as postcss.Declaration
      checkOffset(source, rule, '.a{b:c}')
      checkOffset(source, decl, 'b:c')
      expect(rule.source!.start).assertDeepEquals({
        column: 1,
        line: 1,
        offset: 0
      })
      expect(rule.source!.end).assertDeepEquals({
        column: 7,
        line: 1,
        offset: 7
      })
      expect(decl.source!.start).assertDeepEquals({
        column: 4,
        line: 1,
        offset: 3
      })
      expect(decl.source!.end).assertDeepEquals({
        column: 6,
        line: 1,
        offset: 6
      })
    })

    it('single_decl_(with_semicolon)', 0, () => {
      let source = '.a{b:c;}'
      let css = postcss.parse(source)

      let rule = css.first as Rule
      let decl = rule.first as postcss.Declaration
      checkOffset(source, rule, '.a{b:c;}')
      checkOffset(source, decl, 'b:c;')
      expect(rule.source!.start).assertDeepEquals({
        column: 1,
        line: 1,
        offset: 0
      })
      expect(rule.source!.end).assertDeepEquals({
        column: 8,
        line: 1,
        offset: 8
      })
      expect(decl.source!.start).assertDeepEquals({
        column: 4,
        line: 1,
        offset: 3
      })
      expect(decl.source!.end).assertDeepEquals({
        column: 7,
        line: 1,
        offset: 7
      })
    })

    it('two_decls', 0, () => {
      let source = '.a{b:c;d:e}'
      let css = postcss.parse(source)

      let rule = css.first as Rule
      let decl1 = rule.first as postcss.Declaration
      let decl2 = decl1.next() as postcss.Declaration
      checkOffset(source, decl1, 'b:c;')
      checkOffset(source, decl2, 'd:e')
      expect(rule.source!.start).assertDeepEquals({
        column: 1,
        line: 1,
        offset: 0
      })
      expect(rule.source!.end).assertDeepEquals({
        column: 11,
        line: 1,
        offset: 11
      })
      expect(decl1.source!.start).assertDeepEquals({
        column: 4,
        line: 1,
        offset: 3
      })
      expect(decl1.source!.end).assertDeepEquals({
        column: 7,
        line: 1,
        offset: 7
      })
      expect(decl2.source!.start).assertDeepEquals({
        column: 8,
        line: 1,
        offset: 7
      })
      expect(decl2.source!.end).assertDeepEquals({
        column: 10,
        line: 1,
        offset: 10
      })
    })

    it('...rule_nested_in_rule', 0, () => {
      let source = '.a{.b{}}'
      let css = postcss.parse(source)

      let rule = css.first as Rule
      let rule2 = rule.first as Rule
      checkOffset(source, rule, '.a{.b{}}')
      checkOffset(source, rule2, '.b{}')
      expect(rule.source!.start).assertDeepEquals({
        column: 1,
        line: 1,
        offset: 0
      })
      expect(rule.source!.end).assertDeepEquals({
        column: 8,
        line: 1,
        offset: 8
      })
      expect(rule2.source!.start).assertDeepEquals({
        column: 4,
        line: 1,
        offset: 3
      })
      expect(rule2.source!.end).assertDeepEquals({
        column: 7,
        line: 1,
        offset: 7
      })
    })

    it('at-rule_with_semicolon', 0, () => {
      let source = '@a b;'
      let css = postcss.parse(source)

      let atrule = css.first as postcss.AtRule
      checkOffset(source, atrule, '@a b;')
      expect(atrule.source!.start).assertDeepEquals({
        column: 1,
        line: 1,
        offset: 0
      })
      expect(atrule.source!.end).assertDeepEquals({
        column: 5,
        line: 1,
        offset: 5
      })
    })

    it('unclosed_at-rule', 0, () => {
      let source = '@a b'
      let css = postcss.parse(source)

      let atrule = css.first as postcss.AtRule
      checkOffset(source, atrule, '@a b')
      expect(atrule.source!.start).assertDeepEquals({
        column: 1,
        line: 1,
        offset: 0
      })
      expect(atrule.source!.end).assertDeepEquals({
        column: 4,
        line: 1,
        offset: 4
      })
    })

    it('unclosed_at-rule_in_at-rule', 0, () => {
      let source = '@a{@b c}'
      let css = postcss.parse(source)

      let atrule = css.first as postcss.AtRule
      let atrule2 = atrule.first as postcss.AtRule
      checkOffset(source, atrule, '@a{@b c}')
      checkOffset(source, atrule2, '@b c')
      expect(atrule.source!.start).assertDeepEquals({
        column: 1,
        line: 1,
        offset: 0
      })
      expect(atrule.source!.end).assertDeepEquals({
        column: 8,
        line: 1,
        offset: 8
      })
      expect(atrule2.source!.start).assertDeepEquals({
        column: 4,
        line: 1,
        offset: 3
      })
      expect(atrule2.source!.end).assertDeepEquals({
        column: 7,
        line: 1,
        offset: 7
      })
    })

    it('at-rule_with_body', 0, () => {
      let source = '@a{}'
      let css = postcss.parse(source)

      let atrule = css.first as postcss.AtRule
      checkOffset(source, atrule, '@a{}')
      expect(atrule.source!.start).assertDeepEquals({
        column: 1,
        line: 1,
        offset: 0
      })
      expect(atrule.source!.end).assertDeepEquals({
        column: 4,
        line: 1,
        offset: 4
      })
    })

    it('at-rule_nested_in_atrule', 0, () => {
      let source = '@a{@b{}}'
      let css = postcss.parse(source)

      let atrule = css.first as Rule
      let atrule2 = atrule.first as Rule
      checkOffset(source, atrule, '@a{@b{}}')
      checkOffset(source, atrule2, '@b{}')
      expect(atrule.source!.start).assertDeepEquals({
        column: 1,
        line: 1,
        offset: 0
      })
      expect(atrule.source!.end).assertDeepEquals({
        column: 8,
        line: 1,
        offset: 8
      })
      expect(atrule2.source!.start).assertDeepEquals({
        column: 4,
        line: 1,
        offset: 3
      })
      expect(atrule2.source!.end).assertDeepEquals({
        column: 7,
        line: 1,
        offset: 7
      })
    })

    it('comment', 0, () => {
      let source = '/*a*/'
      let css = postcss.parse(source)

      let rule = css.first as postcss.Comment
      checkOffset(source, rule, '/*a*/')
      expect(rule.source!.start).assertDeepEquals({
        column: 1,
        line: 1,
        offset: 0
      })
      expect(rule.source!.end).assertDeepEquals({
        column: 5,
        line: 1,
        offset: 5
      })
    })
  })
}
