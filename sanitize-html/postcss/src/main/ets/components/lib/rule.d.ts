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

interface RuleRaws {
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
   * The symbols between the selector and `{` for rules.
   */
  between?: string

  /**
   * Contains `true` if the last child has an (optional) semicolon.
   */
  semicolon?: boolean

  /**
   * Contains `true` if there is semicolon after rule.
   */
  ownSemicolon?: string

  /**
   * The rule’s selector with comments.
   */
  selector?: {
    value: string
    raw: string
  }
}

export interface RuleProps extends ContainerProps {
  /** Selector or selectors of the rule. */
  selector?: string
  /** Selectors of the rule represented as an array of strings. */
  selectors?: string[]
  /** Information used to generate byte-to-byte equal node string as it was in the origin input. */
  raws?: RuleRaws
}

/**
 * Represents a CSS rule: a selector followed by a declaration block.
 *
 * ```js
 * Once (root, { Rule }) {
 *   let a = new Rule({ selector: 'a' })
 *   a.append(…)
 *   root.append(a)
 * }
 * ```
 *
 * ```js
 * const root = postcss.parse('a{}')
 * const rule = root.first
 * rule.type       //=> 'rule'
 * rule.toString() //=> 'a{}'
 * ```
 */
export default class Rule extends Container {
  type: 'rule'
  parent: Container | undefined
  raws: RuleRaws

  /**
   * The rule’s full selector represented as a string.
   *
   * ```js
   * const root = postcss.parse('a, b { }')
   * const rule = root.first
   * rule.selector //=> 'a, b'
   * ```
   */
  selector: string

  /**
   * An array containing the rule’s individual selectors.
   * Groups of selectors are split at commas.
   *
   * ```js
   * const root = postcss.parse('a, b { }')
   * const rule = root.first
   *
   * rule.selector  //=> 'a, b'
   * rule.selectors //=> ['a', 'b']
   *
   * rule.selectors = ['a', 'strong']
   * rule.selector //=> 'a, strong'
   * ```
   */
  selectors: string[]

  constructor(defaults?: RuleProps)
  assign(overrides: object | RuleProps): this
  clone(overrides?: Partial<RuleProps>): this
  cloneBefore(overrides?: Partial<RuleProps>): this
  cloneAfter(overrides?: Partial<RuleProps>): this
}
