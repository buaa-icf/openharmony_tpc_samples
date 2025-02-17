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

import { describe, it, expect } from '@ohos/hypium';
import { postcss } from '@ohos/postcss';

let doubler = postcss((css: postcss.Root) => {
  css.walkDecls((decl: postcss.Declaration) => {
    decl.parent?.prepend(decl.clone())
  })
})

export default function mapTest() {
  describe('mapTest', () => {
    it('misses_source_map_annotation_if_user_ask', 0, () => {
      let css = 'a { }'
      let result = postcss([() => {
      }]).process(css, {
        from: 'a.css',
        map: {
          annotation: false
        },
        to: 'b.css'
      })
      expect(result.css).assertDeepEquals(css)
    })

    it('generates_separated_map_on_annotation_option', 0, () => {
      let result = postcss([() => {
      }]).process('a { }', {
        from: 'a.css',
        map: {
          annotation: false
        },
        to: 'b.css'
      })
      expect(typeof result.map).assertDeepEquals('object')
    })

    it('uses_input_file_name_as_output_file_name', 0, () => {
      let result = doubler.process('a{}', {
        from: 'a.css',
        map: {
          inline: false
        }
      })
      expect(result.map.toJSON().file).assertDeepEquals('a.css')
    })

    it('`map.from`_should_override_the_source_map_sources', 0, () => {
      let result = postcss([() => {
      }]).process('a{}', {
        map: {
          from: 'file:///dir/a.css',
          inline: false
        }
      })
      expect(result.map.toJSON().sources).assertDeepEquals(['file:///dir/a.css'])
    })

    it('preserves_absolute_urls_in_`to`', 0, () => {
      let result = postcss([() => {
      }]).process('a{}', {
        from: '/dir/to/a.css',
        map: {
          inline: false
        },
        to: 'http://example.com/a.css'
      })
      expect(result.map.toJSON().file).assertDeepEquals('http://example.com/a.css')
    })

    it('preserves_absolute_urls_in_sources', 0, () => {
      let result = postcss([() => {
      }]).process('a{}', {
        from: 'file:///dir/a.css',
        map: {
          inline: false
        },
        to: 'http://example.com/a.css'
      })
      expect(result.map.toJSON().sources).assertDeepEquals(['file:///dir/a.css'])
    })

    it('uses_URLs_in_sources', 0, () => {
      let result = postcss([() => {
      }]).process('a{}', {
        from: 'a b.css',
        map: {
          inline: false
        },
        to: 'dir/b.css'
      })
      expect(result.map.toJSON().sources).assertDeepEquals(['../a%20b.css'])
    })

    it('generates_correct_sources_with_empty_processor', 0, () => {
      let result = postcss().process('a {} /*hello world*/', {
        from: 'a.css',
        map: {
          inline: false
        },
        to: 'b.css'
      })
      expect(result.map.toJSON().sources).assertDeepEquals(['a.css'])
    })
  })
}
