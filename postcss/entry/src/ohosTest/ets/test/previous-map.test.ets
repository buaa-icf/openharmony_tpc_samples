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

export default function previousMapTest() {
  describe('previousMapTest', () => {
    class obj {
      version: number = 3
      file: ESObject = null
      sources: ESObject = []
      names: ESObject = []
      mappings: string = ''
    }

    let mapObj: obj = {
      version: 3,
      file: null,
      sources: [],
      names: [],
      mappings: ''
    }
    let map = JSON.stringify(mapObj)
    it('test01', 0, () => {
      expect(postcss.parse('a{}').source?.input.map).assertUndefined()
    })
    it('test02', 0, () => {
      let root = postcss.parse('a{}', {
        map: {
          prev: map
        }
      })
      expect(root.source?.input.map.text).assertDeepEquals(map)
    })
    it('test03', 0, () => {
      let root1 = postcss.parse('a{}', {
        map: {
          prev: map
        }
      })
      expect(root1.source?.input.map.annotation).assertUndefined()

      let root2 = postcss.parse('a{}/*# sourceMappingURL=a.css.map */', {
        map: {
          prev: map
        }
      })
      expect(root2.source?.input.map.annotation).assertDeepEquals('a.css.map')
    })
    it('test04', 0, () => {
      let map2: ESObject = {
        version: 3,
        file: 'b',
        sources: ['a'],
        names: [],
        mappings: ''
      }
      expect(postcss.parse('a{}', {
        map: {
          prev: map2
        }
      }).source?.input.map.withContent()).assertDeepEquals(false)
      map2.sourcesContent = ['a{}']
      expect(postcss.parse('a{}', {
        map: {
          prev: map2
        }
      }).source?.input.map.withContent()).assertDeepEquals(true)
    })

    it('creates_property_if_map_present', 0, () => {
      let root = postcss.parse('a{}', {
        map: {
          prev: map
        }
      })
      expect(root.source?.input.map.text).assertDeepEquals(map)
    })

    it('decodes_URI_maps', 0, () => {
      let uri = 'data:application/json,' + decodeURI(map)
      let css = `a{}\n/*# sourceMappingURL=${uri} */`
      expect(postcss.parse(css).source?.input.map.text).assertDeepEquals(map)
    })

    it('decodes_URI_UTF-8_maps', 0, () => {
      let uri = decodeURI(map)
      let css =
        'a{}\n/*# sourceMappingURL=data:application/json;' +
          'charset=utf-8,' +
          uri +
          ' */'
      expect(postcss.parse(css).source?.input.map.text).assertDeepEquals(map)
    })

    it('accepts_different_name_for_URI_maps_with_UTF-8_encoding', 0, () => {
      let uri = decodeURI(map)
      let css =
        'a{}\n/*# sourceMappingURL=data:application/json;' +
          'charset=utf8,' +
          uri +
          ' */'
      expect(postcss.parse(css).source?.input.map.text).assertDeepEquals(map)
    })

    it('removes_map_on_request', 0, () => {
      let uri = 'data:application/json,' + decodeURI(map)
      let css = `a{}\n/*# sourceMappingURL=${uri} */`

      let input = postcss.parse(css, {
        map: {
          prev: false
        }
      }).source?.input
      expect(input?.map).assertUndefined()
    })

    it('raises_on_unknown_inline_encoding', 0, () => {
      let css =
        'a { }\n/*# sourceMappingURL=data:application/json;' +
          'md5,68b329da9893e34099c7d8ad5cb9c940*/'
      try {
        postcss.parse(css)
      } catch (err) {
        expect(err.message).assertDeepEquals('Unsupported source map encoding md5')
      }
    })
  })
}
