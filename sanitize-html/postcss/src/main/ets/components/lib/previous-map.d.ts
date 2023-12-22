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
import { SourceMapConsumer } from 'source-map-js'

import { ProcessOptions } from './postcss.js'

/**
 * Source map information from input CSS.
 * For example, source map after Sass compiler.
 *
 * This class will automatically find source map in input CSS or in file system
 * near input file (according `from` option).
 *
 * ```js
 * const root = parse(css, { from: 'a.sass.css' })
 * root.input.map //=> PreviousMap
 * ```
 */
export default class PreviousMap {
  /**
   * Was source map inlined by data-uri to input CSS.
   */
  inline: boolean

  /**
   * `sourceMappingURL` content.
   */
  annotation?: string

  /**
   * Source map file content.
   */
  text?: string

  /**
   * The directory with source map file, if source map is in separated file.
   */
  root?: string

  /**
   * The CSS source identifier. Contains `Input#file` if the user
   * set the `from` option, or `Input#id` if they did not.
   */
  file?: string

  /**
   * Path to source map file.
   */
  mapFile?: string

  /**
   * @param css  Input CSS source.
   * @param opts Process options.
   */
  constructor(css: string, opts?: ProcessOptions)

  /**
   * Create a instance of `SourceMapGenerator` class
   * from the `source-map` library to work with source map information.
   *
   * It is lazy method, so it will create object only on first call
   * and then it will use cache.
   *
   * @return Object with source map information.
   */
  consumer(): SourceMapConsumer

  /**
   * Does source map contains `sourcesContent` with input source text.
   *
   * @return Is `sourcesContent` present.
   */
  withContent(): boolean
}
