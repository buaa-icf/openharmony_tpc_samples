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
import Container, { ContainerProps } from './container.js'
import Document from './document.js'
import { ProcessOptions } from './postcss.js'
import Result from './result.js'

interface RootRaws extends Record<string, any> {
  /**
   * The space symbols after the last child to the end of file.
   */
  after?: string

  /**
   * Non-CSS code before `Root`, when `Root` is inside `Document`.
   *
   * **Experimental:** some aspects of this node could change within minor
   * or patch version releases.
   */
  codeBefore?: string

  /**
   * Non-CSS code after `Root`, when `Root` is inside `Document`.
   *
   * **Experimental:** some aspects of this node could change within minor
   * or patch version releases.
   */
  codeAfter?: string

  /**
   * Is the last child has an (optional) semicolon.
   */
  semicolon?: boolean
}

export interface RootProps extends ContainerProps {
  /**
   * Information used to generate byte-to-byte equal node string
   * as it was in the origin input.
   * */
  raws?: RootRaws
}

/**
 * Represents a CSS file and contains all its parsed nodes.
 *
 * ```js
 * const root = postcss.parse('a{color:black} b{z-index:2}')
 * root.type         //=> 'root'
 * root.nodes.length //=> 2
 * ```
 */
export default class Root extends Container {
  type: 'root'
  parent: Document | undefined
  raws: RootRaws

  /**
   * Returns a `Result` instance representing the root’s CSS.
   *
   * ```js
   * const root1 = postcss.parse(css1, { from: 'a.css' })
   * const root2 = postcss.parse(css2, { from: 'b.css' })
   * root1.append(root2)
   * const result = root1.toResult({ to: 'all.css', map: true })
   * ```
   *
   * @param opts Options.
   * @return Result with current root’s CSS.
   */
  toResult(options?: ProcessOptions): Result

  constructor(defaults?: RootProps)
  assign(overrides: object | RootProps): this
}
