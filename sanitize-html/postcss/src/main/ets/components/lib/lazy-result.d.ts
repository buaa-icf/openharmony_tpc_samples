/**
 * MIT License
 *
 * Copyright (C) 2022 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
import Result, { Message, ResultOptions } from './result.js'
import { SourceMap } from './postcss.js'
import Processor from './processor.js'
import Warning from './warning.js'
import Root from './root.js'

/**
 * A Promise proxy for the result of PostCSS transformations.
 *
 * A `LazyResult` instance is returned by `Processor#process`.
 *
 * ```js
 * const lazy = postcss([autoprefixer]).process(css)
 * ```
 */
export default class LazyResult implements PromiseLike<Result> {
  /**
   * Processes input CSS through synchronous and asynchronous plugins
   * and calls `onFulfilled` with a Result instance. If a plugin throws
   * an error, the `onRejected` callback will be executed.
   *
   * It implements standard Promise API.
   *
   * ```js
   * postcss([autoprefixer]).process(css, { from: cssPath }).then(result => {
   *   console.log(result.css)
   * })
   * ```
   */
  then: Promise<Result>['then']

  /**
   * Processes input CSS through synchronous and asynchronous plugins
   * and calls onRejected for each error thrown in any plugin.
   *
   * It implements standard Promise API.
   *
   * ```js
   * postcss([autoprefixer]).process(css).then(result => {
   *   console.log(result.css)
   * }).catch(error => {
   *   console.error(error)
   * })
   * ```
   */
  catch: Promise<Result>['catch']

  /**
   * Processes input CSS through synchronous and asynchronous plugins
   * and calls onFinally on any error or when all plugins will finish work.
   *
   * It implements standard Promise API.
   *
   * ```js
   * postcss([autoprefixer]).process(css).finally(() => {
   *   console.log('processing ended')
   * })
   * ```
   */
  finally: Promise<Result>['finally']

  /**
   * @param processor Processor used for this transformation.
   * @param css       CSS to parse and transform.
   * @param opts      Options from the `Processor#process` or `Root#toResult`.
   */
  constructor(processor: Processor, css: string, opts: ResultOptions)

  /**
   * Returns the default string description of an object.
   * Required to implement the Promise interface.
   */
  get [Symbol.toStringTag](): string

  /**
   * Returns a `Processor` instance, which will be used
   * for CSS transformations.
   */
  get processor(): Processor

  /**
   * Options from the `Processor#process` call.
   */
  get opts(): ResultOptions

  /**
   * Processes input CSS through synchronous plugins, converts `Root`
   * to a CSS string and returns `Result#css`.
   *
   * This property will only work with synchronous plugins.
   * If the processor contains any asynchronous plugins
   * it will throw an error. This is why this method is only
   * for debug purpose, you should always use `LazyResult#then`.
   */
  get css(): string

  /**
   * An alias for the `css` property. Use it with syntaxes
   * that generate non-CSS output.
   *
   * This property will only work with synchronous plugins.
   * If the processor contains any asynchronous plugins
   * it will throw an error. This is why this method is only
   * for debug purpose, you should always use `LazyResult#then`.
   */
  get content(): string

  /**
   * Processes input CSS through synchronous plugins
   * and returns `Result#map`.
   *
   * This property will only work with synchronous plugins.
   * If the processor contains any asynchronous plugins
   * it will throw an error. This is why this method is only
   * for debug purpose, you should always use `LazyResult#then`.
   */
  get map(): SourceMap

  /**
   * Processes input CSS through synchronous plugins
   * and returns `Result#root`.
   *
   * This property will only work with synchronous plugins. If the processor
   * contains any asynchronous plugins it will throw an error.
   *
   * This is why this method is only for debug purpose,
   * you should always use `LazyResult#then`.
   */
  get root(): Root

  /**
   * Processes input CSS through synchronous plugins
   * and returns `Result#messages`.
   *
   * This property will only work with synchronous plugins. If the processor
   * contains any asynchronous plugins it will throw an error.
   *
   * This is why this method is only for debug purpose,
   * you should always use `LazyResult#then`.
   */
  get messages(): Message[]

  /**
   * Processes input CSS through synchronous plugins
   * and calls `Result#warnings`.
   *
   * @return Warnings from plugins.
   */
  warnings(): Warning[]

  /**
   * Alias for the `LazyResult#css` property.
   *
   * ```js
   * lazy + '' === lazy.css
   * ```
   *
   * @return Output CSS.
   */
  toString(): string

  /**
   * Run plugin in sync way and return `Result`.
   *
   * @return Result with output content.
   */
  sync(): Result

  /**
   * Run plugin in async way and return `Result`.
   *
   * @return Result with output content.
   */
  async(): Promise<Result>
}
