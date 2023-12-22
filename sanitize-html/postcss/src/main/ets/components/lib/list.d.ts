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
export type List = {
  /**
   * Safely splits values.
   *
   * ```js
   * Once (root, { list }) {
   *   list.split('1px calc(10% + 1px)', [' ', '\n', '\t']) //=> ['1px', 'calc(10% + 1px)']
   * }
   * ```
   *
   * @param string separated values.
   * @param separators array of separators.
   * @param last boolean indicator.
   * @return Split values.
   */
  split(string: string, separators: string[], last: boolean): string[]
  /**
   * Safely splits space-separated values (such as those for `background`,
   * `border-radius`, and other shorthand properties).
   *
   * ```js
   * Once (root, { list }) {
   *   list.space('1px calc(10% + 1px)') //=> ['1px', 'calc(10% + 1px)']
   * }
   * ```
   *
   * @param str Space-separated values.
   * @return Split values.
   */
  space(str: string): string[]

  /**
   * Safely splits comma-separated values (such as those for `transition-*`
   * and `background` properties).
   *
   * ```js
   * Once (root, { list }) {
   *   list.comma('black, linear-gradient(white, black)')
   *   //=> ['black', 'linear-gradient(white, black)']
   * }
   * ```
   *
   * @param str Comma-separated values.
   * @return Split values.
   */
  comma(str: string): string[]
}

declare const list: List

export default list
