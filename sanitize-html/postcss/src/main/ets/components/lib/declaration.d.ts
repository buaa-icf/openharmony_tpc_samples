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
import Container from './container.js'
import Node from './node.js'

interface DeclarationRaws {
  /**
   * The space symbols before the node. It also stores `*`
   * and `_` symbols before the declaration (IE hack).
   */
  before?: string

  /**
   * The symbols between the property and value for declarations.
   */
  between?: string

  /**
   * The content of the important statement, if it is not just `!important`.
   */
  important?: string

  /**
   * Declaration value with comments.
   */
  value: {
    value: string
    raw: string
  }
}

export interface DeclarationProps {
  /** Name of the declaration. */
  prop: string
  /** Value of the declaration. */
  value: string
  /** Whether the declaration has an `!important` annotation. */
  important?: boolean
  /** Information used to generate byte-to-byte equal node string as it was in the origin input. */
  raws?: DeclarationRaws
}

/**
 * Represents a CSS declaration.
 *
 * ```js
 * Once (root, { Declaration }) {
 *   let color = new Declaration({ prop: 'color', value: 'black' })
 *   root.append(color)
 * }
 * ```
 *
 * ```js
 * const root = postcss.parse('a { color: black }')
 * const decl = root.first.first
 * decl.type       //=> 'decl'
 * decl.toString() //=> ' color: black'
 * ```
 */
export default class Declaration extends Node {
  type: 'decl'
  parent: Container | undefined
  raws: DeclarationRaws

  /**
   * The declaration's property name.
   *
   * ```js
   * const root = postcss.parse('a { color: black }')
   * const decl = root.first.first
   * decl.prop //=> 'color'
   * ```
   */
  prop: string

  /**
   * The declaration’s value.
   *
   * This value will be cleaned of comments. If the source value contained
   * comments, those comments will be available in the `raws` property.
   * If you have not changed the value, the result of `decl.toString()`
   * will include the original raws value (comments and all).
   *
   * ```js
   * const root = postcss.parse('a { color: black }')
   * const decl = root.first.first
   * decl.value //=> 'black'
   * ```
   */
  value: string

  /**
   * `true` if the declaration has an `!important` annotation.
   *
   * ```js
   * const root = postcss.parse('a { color: black !important; color: red }')
   * root.first.first.important //=> true
   * root.first.last.important  //=> undefined
   * ```
   */
  important: boolean

  /**
   * `true` if declaration is declaration of CSS Custom Property
   * or Sass variable.
   *
   * ```js
   * const root = postcss.parse(':root { --one: 1 }')
   * let one = root.first.first
   * one.variable //=> true
   * ```
   *
   * ```js
   * const root = postcss.parse('$one: 1')
   * let one = root.first
   * one.variable //=> true
   * ```
   */
  variable: boolean

  constructor(defaults?: DeclarationProps)
  assign(overrides: object | DeclarationProps): this
  clone(overrides?: Partial<DeclarationProps>): this
  cloneBefore(overrides?: Partial<DeclarationProps>): this
  cloneAfter(overrides?: Partial<DeclarationProps>): this
}
