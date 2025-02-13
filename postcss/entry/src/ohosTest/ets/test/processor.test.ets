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
import LazyResult from '@ohos/postcss/src/main/ets/components/lib/lazy-result'
import Processor from '@ohos/postcss/src/main/ets/components/lib/processor'
import Result from '@ohos/postcss/src/main/ets/components/lib/result'
import Root from '@ohos/postcss/src/main/ets/components/lib/root'

function prs(): Root {
  return new Root({ raws: { after: 'ok' } })
}

function str(node: postcss.Node, builder: (s: string) => void): void {
  builder(`${node.raws.after}!`)
}

let beforeFix = new Processor([
  (root: postcss.Root) => {
    root.walkRules(rule => {
      if (!rule.selector.match(new RegExp('::(before|after)'))) {
        return
      }
      if (!rule.some(i => i.type === 'decl' && i.prop === 'content')) {
        rule.prepend({ prop: 'content', value: '""' })
      }
    })
  }
])

export default function processorTest() {
  describe('processorTest', () => {
    it('test01', 0, () => {
      let a = (): void => {
      }
      let processor = new Processor()
      processor.use(a)
      expect(processor.plugins).assertDeepEquals([a])
    })
    it('test02', 0, () => {
      let a = (): void => {
      }
      let processor = new Processor()
      processor.use({
        postcss: a
      })
      expect(processor.plugins).assertDeepEquals([a])
    })
    it('test03', 0, () => {
      let a = (): void => {
      }
      let obj: ESObject = () => {
      }
      obj.postcss = a
      let processor = new Processor()
      processor.use(obj)
      expect(processor.plugins).assertDeepEquals([a])
    })
    it('test04', 0, () => {
      let a = (): void => {
      }
      let processor = new Processor()
      let other = new Processor([a])
      processor.use(other)
      expect(processor.plugins).assertDeepEquals([a])
    })
    it('test05', 0, () => {
      let a = (): void => {
      }
      let processor = new Processor()
      let other = new Processor([a])
      processor.use({
        postcss: other
      })
      expect(processor.plugins).assertDeepEquals([a])
    })
    it('test06', 0, () => {
      let a = (): void => {
      }
      let b = (): void => {
      }
      let processor = new Processor()
      expect(processor.use(a).use(b).plugins).assertDeepEquals([a, b])
    })
    it('test07', 0, () => {
      let result = beforeFix.process('a::before{top:0}')
      expect(result.css).assertDeepEquals('a::before{content:"";top:0}')
    })
    it('test08', 0, () => {
      let root = postcss.parse('a::before{top:0}')
      let result = beforeFix.process(root)
      expect(result.css).assertDeepEquals('a::before{content:"";top:0}')
    })
    it('test09', 0, () => {
      let result = new Processor([() => {
      }]).process('a::before{top:0}')
      result = beforeFix.process(result)
      expect(result.css).assertDeepEquals('a::before{content:"";top:0}')
    })
    it('test12', 0, () => {
      let processor = new Processor([
        (result: postcss.Root) => {
          result = new postcss.Root()
        }
      ])
      expect(processor.process('a {}').css).assertDeepEquals('a {}')
    })
    it('test13', 0, () => {
      let result = new Processor([() => {
      }]).process('a{}')
      expect(result instanceof LazyResult).assertDeepEquals(true)
      expect(result.css).assertDeepEquals('a{}')
      expect(result.toString()).assertDeepEquals('a{}')
    })
    it('test14', 0, () => {
      expect(
        typeof new Processor([
          (css: postcss.Root) => {
            expect(css instanceof postcss.Root).assertDeepEquals(true)
          }
        ]).process('a {}').css
      ).assertDeepEquals('string')
    })
    it('test15', 0, async () => {
      let plugin1 = (css: postcss.Root, result: postcss.Result): void => {
        expect(result.lastPlugin).assertDeepEquals(plugin1)
      }
      let plugin2 = (css: postcss.Root, result: postcss.Result): void => {
        expect(result.lastPlugin).assertDeepEquals(plugin2)
      }
      let processor = new Processor([plugin1, plugin2])
      let result = await processor.process('a{}', {
        from: undefined
      })
      expect(result.lastPlugin).assertDeepEquals(plugin2)
    })
    it('test16', 0, () => {
      let a = (): void => {
      }
      let processor = new Processor()
      let other = (() => {
        return new Processor([a])
      }) as postcss.PluginCreator<void>
      other.postcss = true
      processor.use(other)
      expect(processor.plugins).assertDeepEquals([a])
    })
    it('throws_on_wrong_format', 0, () => {
      let pr = new Processor()
      try {
        pr.use(1)
      } catch (e) {
        expect(e.message.toString()).assertDeepEquals('1 is not a PostCSS plugin')
      }
    })
    it('takes_maps_from_previous_result', 0, async () => {
      let one = new Processor([() => {
      }]).process('a{}', {
        from: 'a.css',
        map: {
          inline: false
        },
        to: 'b.css'
      })
      let two = await new Processor([() => {
      }]).process(one, {
        to: 'c.css'
      })
      expect(two.map.toJSON().sources).assertDeepEquals(['a.css'])
    })

    it('calls_all_plugins_once', 0, async () => {
      let calls = ''
      let a = (): void => {
        calls += 'a'
      }
      let b = (): void => {
        calls += 'b'
      }

      let result = new Processor([a, b]).process('', {
        from: undefined
      })
      result.css;
      (await result).map
      result.root
      await result
      expect(calls).assertDeepEquals('ab')
    })

    it('send_result_to_plugins', 0, () => {
      let processor = new Processor([() => {
      }])
      processor
        .use((css: string, result: Result) => {
          expect(result instanceof Result).assertDeepEquals(true)
          expect(result.processor).assertDeepEquals(processor)
          expect(result.opts).assertDeepEquals({
            map: true
          })
          expect(result.root).assertDeepEquals(css)
        })
        .process('a {}', {
          from: undefined, map: true
        })
    })

    it('supports_async_plugins', 0, async () => {
      let starts = 0
      let finish = 0
      let async1 = (css: postcss.Root): Promise<void> =>
      new Promise<void>(resolve => {
        starts += 1
        setTimeout(() => {
          expect(starts).assertDeepEquals(1)
          css.append('a {}')
          finish += 1
          resolve()
        }, 1)
      })
      let async2 = (css: postcss.Root): Promise<void> =>
      new Promise<void>(resolve => {
        expect(starts).assertDeepEquals(1)
        expect(finish).assertDeepEquals(1)

        starts += 1
        setTimeout(() => {
          css.append('b {}')
          finish += 1
          resolve()
        }, 1)
      })
      let r = await new Processor([async1, async2]).process('', {
        from: 'a'
      })
      expect(starts).assertDeepEquals(2)
      expect(finish).assertDeepEquals(2)
      expect(r.css).assertDeepEquals('a {}b {}')
    })

    it('works_async_without_plugins', 0, async () => {
      let r = await new Processor([() => {
      }]).process('a {}', {
        from: 'a'
      })
      expect(r.css).assertDeepEquals('a {}')
    })

    it('runs_async_plugin_only_once', 0, async () => {
      let calls = 0
      let async = (): Promise<void> => {
        return new Promise<void>(resolve => {
          setTimeout(() => {
            calls += 1
            resolve()
          }, 1)
        })
      }

      let result = new Processor([async]).process('a {}', {
        from: undefined
      })
      result.then(() => {
      })
      await result
      await result
      expect(calls).assertDeepEquals(1)
    })

    it('throws_error_on_sync_method_to_async_plugin', 0, () => {
      let async = (): Promise<void> => {
        return new Promise<void>(resolve => {
          resolve()
        })
      }
      try {
        new Processor([async]).process('a{}').css
      } catch (err) {
        expect(err.message).assertDeepEquals('Use process(css).then(cb) to work with async plugins')
      }
    })

    it('throws_a_sync_call_in_async_running', 0, async () => {
      let async = (): Promise<void> =>
      new Promise<void>(resolve => setTimeout(resolve, 1))

      let processor = new Processor([async]).process('a{}', {
        from: 'a.css'
      })
      processor.async()

      try {
        processor.sync()
      } catch (err) {
        expect(err.message).assertDeepEquals('Use process(css).then(cb) to work with async plugins')
      }
    })

    it('remembers_errors', 0, async () => {
      let calls = 0
      let plugin: postcss.Plugin = {
        Once() {
          calls += 1
          throw new Error('test')
        },
        postcssPlugin: 'plugin'
      }

      let processing = postcss([plugin]).process('a{}', {
        from: undefined
      })
      try {
        processing.css
      } catch (err) {
        expect(err.message).assertDeepEquals('test')
      }
      try {
        processing.root
      } catch (err) {
        expect(err.message).assertDeepEquals('test')
      }

      let asyncError: Error
      try {
        await processing
      } catch (e) {
        asyncError = e
        expect(asyncError.message).assertDeepEquals('test')
      }
      expect(calls).assertDeepEquals(1)
    })

    it('uses_custom_parsers', 0, async () => {
      let processor = new Processor([])
      let result = await processor.process('a{}', {
        from: undefined, parser: prs
      })
      expect(result.css).assertDeepEquals('ok')
    })

    it('uses_custom_stringifier', 0, async () => {
      let processor = new Processor([])
      let result = await processor.process('a{}', {
        from: 'a', stringifier: str
      })
      expect(result.css).assertDeepEquals('!')
    })

    it('uses_custom_syntax', 0, async () => {
      let processor = new Processor([() => {
      }])
      let result = await processor.process('a{}', {
        from: undefined,
        syntax: {
          parse: prs, stringify: str
        }
      })
      expect(result.css).assertDeepEquals('ok!')
    })

    it('throws_on_syntax_as_plugin', 0, () => {
      let processor = new Processor([() => {
      }])
      try {
        processor.use({
          parse() {
          }
        })
      } catch (err) {
        expect(err.message).assertDeepEquals('[object Object] is not a PostCSS plugin')
      }
    })

    it('throws_an_error_on_root_access_on_no_plugins_mode', 0, () => {
      try {
        postcss().process('// invalid', {
          from: 'a'
        }).root
      } catch (err) {
        expect(err.message).assertDeepEquals('ERR_INVALID_URL_SCHEME, file')
      }
    })

    it('supports_plugin_creators_returning_processors', 0, () => {
      let a = (): void => {
      }
      let processor = new Processor()
      let other = (() => {
        return new Processor([a])
      }) as postcss.PluginCreator<void>
      other.postcss = true
      processor.use(other)
      expect(processor.plugins).assertDeepEquals([a])
    })
  })
}