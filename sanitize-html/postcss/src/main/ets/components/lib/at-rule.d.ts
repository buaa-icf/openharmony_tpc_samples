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

interface AtRuleRaws {
  /**
   * The space symbols before the node. It also stores `*`
   * and `_` symbols before the declaration (IE hack).
   */
  before?: string

  /**
   * The space symbols after the last child of the node to the end of the node.
   */
  after?: string

  /**
   * The space between the at-rule name and its parameters.
   */
  afterName?: string

  /**
   * The symbols between the last parameter and `{` for rules.
   */
  between?: string

  /**
   * Contains `true` if the last child has an (optional) semicolon.
   */
  semicolon?: boolean

  /**
   * The rule’s selector with comments.
   */
  params?: {
    value: string
    raw: string
  }
}

export interface AtRuleProps extends ContainerProps {
  /** Name of the at-rule. */
  name: string
  /** Parameters following the name of the at-rule. */
  params?: string | number
  /** Information used to generate byte-to-byte equal node string as it was in the origin input. */
  raws?: AtRuleRaws
}

/**
 * Represents an at-rule.
 *
 * ```js
 * Once (root, { AtRule }) {
 *   let media = new AtRule({ name: 'media', params: 'print' })
 *   media.append(…)
 *   root.append(media)
 * }
 * ```
 *
 * If it’s followed in the CSS by a {} block, this node will have
 * a nodes property representing its children.
 *
 * ```js
 * const root = postcss.parse('@charset "UTF-8"; @media print {}')
 *
 * const charset = root.first
 * charset.type  //=> 'atrule'
 * charset.nodes //=> undefined
 *
 * const media = root.last
 * media.nodes   //=> []
 * ```
 */
export default class AtRule extends Container {
  type: 'atrule'
  parent: Container | undefined
  raws: AtRuleRaws

  /**
   * The at-rule’s name immediately follows the `@`.
   *
   * ```js
   * const root  = postcss.parse('@media print {}')
   * media.name //=> 'media'
   * const media = root.first
   * ```
   */
  name: string

  /**
   * The at-rule’s parameters, the values that follow the at-rule’s name
   * but precede any {} block.
   *
   * ```js
   * const root  = postcss.parse('@media print, screen {}')
   * const media = root.first
   * media.params //=> 'print, screen'
   * ```
   */
  params: string

  constructor(defaults?: AtRuleProps)
  assign(overrides: object | AtRuleProps): this
  clone(overrides?: Partial<AtRuleProps>): this
  cloneBefore(overrides?: Partial<AtRuleProps>): this
  cloneAfter(overrides?: Partial<AtRuleProps>): this
}
