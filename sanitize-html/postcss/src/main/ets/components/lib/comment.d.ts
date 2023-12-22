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
import Node, { NodeProps } from './node.js'

interface CommentRaws {
  /**
   * The space symbols before the node.
   */
  before?: string

  /**
   * The space symbols between `/*` and the comment’s text.
   */
  left?: string

  /**
   * The space symbols between the comment’s text.
   */
  right?: string
}

export interface CommentProps extends NodeProps {
  /** Content of the comment. */
  text: string
  /** Information used to generate byte-to-byte equal node string as it was in the origin input. */
  raws?: CommentRaws
}

/**
 * Represents a comment between declarations or statements (rule and at-rules).
 *
 * ```js
 * Once (root, { Comment }) {
 *   let note = new Comment({ text: 'Note: …' })
 *   root.append(note)
 * }
 * ```
 *
 * Comments inside selectors, at-rule parameters, or declaration values
 * will be stored in the `raws` properties explained above.
 */
export default class Comment extends Node {
  type: 'comment'
  parent: Container | undefined
  raws: CommentRaws

  /**
   * The comment's text.
   */
  text: string

  constructor(defaults?: CommentProps)
  assign(overrides: object | CommentProps): this
  clone(overrides?: Partial<CommentProps>): this
  cloneBefore(overrides?: Partial<CommentProps>): this
  cloneAfter(overrides?: Partial<CommentProps>): this
}
