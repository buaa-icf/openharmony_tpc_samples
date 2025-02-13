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
import { Rule } from '@ohos/postcss'

function isSyntaxError(e: Object): boolean {
  return e instanceof Error && e.name === 'CssSyntaxError' && e instanceof postcss.CssSyntaxError
}

async function catchError(cb: () => Promise<ESObject>): Promise<postcss.CssSyntaxError> {
  try {
    await cb()
  } catch (e) {
    if (isSyntaxError(e)) {
      return e
    } else {
      throw new Error(e)
    }
  }
  throw new Error('Error was not thrown')
}

interface ParseErrorOptions {
  from?: string;
  map?: boolean | Object;
}

function parseError(
  css: string,
  opts?: ParseErrorOptions
): postcss.CssSyntaxError {
  try {
    postcss.parse(css, opts)
  } catch (e) {
    if (isSyntaxError(e)) {
      return e
    } else {
      throw new Error(e)
    }
  }
  throw new Error('Error was not thrown')
}

export default function cssTest() {
  describe('cssTest', () => {
    it('test01', 0, () => {
      let error = parseError('a {\n  content: "\n}')
      expect(error instanceof postcss.CssSyntaxError).assertDeepEquals(true)
      expect(error.name).assertDeepEquals('CssSyntaxError')
      expect(error.message).assertDeepEquals('<css input>:2:12: Unclosed string')
      expect(error.reason).assertDeepEquals('Unclosed string')
      expect(error.line).assertDeepEquals(2)
      expect(error.column).assertDeepEquals(12)
      expect(error.source).assertDeepEquals('a {\n  content: "\n}')
      expect(error.input).assertDeepEquals({
        column: error.column,
        endColumn: error.endColumn,
        endLine: error.endLine,
        line: error.line,
        source: error.source
      })
    })
    it('test02', 0, () => {
      let error = parseError('a {')
      error.source = undefined
      expect(error.toString()).assertDeepEquals(
        'CssSyntaxError: <css input>:1:1: Unclosed block'
      )
    })
    it('test03', 0, () => {
      let decl = postcss.decl({
        prop: 'color', value: 'black'
      })
      let error = decl.error('Test')
      expect(error.toString()).assertDeepEquals('CssSyntaxError: <css input>: Test')
    })
    it('highlights_broken_line', 0, () => {
      expect(parseError('a {\n  content: "\n}').showSourceCode(false))
        .assertDeepEquals('  1 | a {\n' + '> 2 |   content: "\n' + '    |            ^\n' + '  3 | }')
    })
    it('highlights_broken_line_when_indented_with_tabs', 0, () => {
      expect(parseError('a {\n\t \t  content:\t"\n}').showSourceCode(false)).assertDeepEquals(
        '  1 | a {\n' +
          '> 2 | \t \t  content:\t"\n' +
          '    | \t \t          \t^\n' +
          '  3 | }')
    })
    it('highlights_small_code_example', 0, () => {
      expect(parseError('a {').showSourceCode(false)).assertDeepEquals('> 1 | a {\n' + '    | ^')
    })

    it('add_leading_space_for_line_numbers', 0, () => {
      let css = '\n\n\n\n\n\n\na {\n  content: "\n}\n\n\n'
      expect(parseError(css).showSourceCode(false)).assertDeepEquals(
        '   7 | \n' +
          '   8 | a {\n' +
          '>  9 |   content: "\n' +
          '     |            ^\n' +
          '  10 | }\n' +
          '  11 | ')
    })

    it('cut_minified_css', 0, () => {
      let css =
        '.a{position:absolute!important;clip:rect(1px,1px,1px,1px);}' +
          '.b{border:0;background;text-decoration:none;font-size:100%;}' +
          '.c{position:absolute!important;clip:rect(1px,1px,1px,1px);}' +
          '.d{position:absolute!important;clip:rect(1px,1px,1px,1px);}'
      expect(parseError(css).showSourceCode(false)).assertDeepEquals(
        '> 1 | ,1px);}.b{border:0;background;text-decoration:none\n' +
          '    |                    ^')
    })

    it('correct_mark_position_on_cut_minified_css', 0, () => {
      let css =
        '.a{background;position:absolute!important;clip:rect(1px,1px,1px,1px);}' +
          '.b{border:0;text-decoration:none;font-size:100%;}' +
          '.c{position:absolute!important;clip:rect(1px,1px,1px,1px);}' +
          '.d{position:absolute!important;clip:rect(1px,1px,1px,1px);}'
      expect(parseError(css).showSourceCode(false))
        .assertDeepEquals('> 1 | .a{background;position:absolute!im\n' + '    |    ^')
    })
    it('prints_with_highlight', 0, () => {
      expect(parseError('a {').toString()).assertDeepEquals('CssSyntaxError: <css input>:1:1: Unclosed block\n' +
        '\n' +
        '> 1 | a {\n' +
        '    | ^\n')
    })

    it('set_plugin_automatically_in_async', 0, async () => {
      let plugin: postcss.Plugin = {
        Once(css) {
          return new Promise((resolve, reject) => {
            if (css.first) {
              reject(css.first.error('Error'))
            }
          })
        },
        postcssPlugin: 'async-plugin'
      }

      let error = await catchError(() =>
      postcss([plugin]).process('a{}', {
        from: undefined
      })
      )
      expect(error.plugin).assertDeepEquals('async-plugin')
    })
  })
}