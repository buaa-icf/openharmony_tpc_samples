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
import { FilePosition } from './input.js'

/**
 * The CSS parser throws this error for broken CSS.
 *
 * Custom parsers can throw this error for broken custom syntax using
 * the `Node#error` method.
 *
 * PostCSS will use the input source map to detect the original error location.
 * If you wrote a Sass file, compiled it to CSS and then parsed it with PostCSS,
 * PostCSS will show the original position in the Sass file.
 *
 * If you need the position in the PostCSS input
 * (e.g., to debug the previous compiler), use `error.input.file`.
 *
 * ```js
 * // Raising error from plugin
 * throw node.error('Unknown variable', { plugin: 'postcss-vars' })
 * ```
 *
 * ```js
 * // Catching and checking syntax error
 * try {
 *   postcss.parse('a{')
 * } catch (error) {
 *   if (error.name === 'CssSyntaxError') {
 *     error //=> CssSyntaxError
 *   }
 * }
 * ```
 */
export default class CssSyntaxError {
  /**
   * @param message Error message.
   * @param line    Source line of the error.
   * @param column  Source column of the error.
   * @param source  Source code of the broken file.
   * @param file    Absolute path to the broken file.
   * @param plugin  PostCSS plugin name, if error came from plugin.
   */
  constructor(
    message: string,
    line?: number,
    column?: number,
    source?: string,
    file?: string,
    plugin?: string
  )

  stack: string

  /**
   * Always equal to `'CssSyntaxError'`. You should always check error type
   * by `error.name === 'CssSyntaxError'`
   * instead of `error instanceof CssSyntaxError`,
   * because npm could have several PostCSS versions.
   *
   * ```js
   * if (error.name === 'CssSyntaxError') {
   *   error //=> CssSyntaxError
   * }
   * ```
   */
  name: 'CssSyntaxError'

  /**
   * Error message.
   *
   * ```js
   * error.message //=> 'Unclosed block'
   * ```
   */
  reason: string

  /**
   * Full error text in the GNU error format
   * with plugin, file, line and column.
   *
   * ```js
   * error.message //=> 'a.css:1:1: Unclosed block'
   * ```
   */
  message: string

  /**
   * Absolute path to the broken file.
   *
   * ```js
   * error.file       //=> 'a.sass'
   * error.input.file //=> 'a.css'
   * ```
   *
   * PostCSS will use the input source map to detect the original location.
   * If you need the position in the PostCSS input, use `error.input.file`.
   */
  file?: string

  /**
   * Source line of the error.
   *
   * ```js
   * error.line       //=> 2
   * error.input.line //=> 4
   * ```
   *
   * PostCSS will use the input source map to detect the original location.
   * If you need the position in the PostCSS input, use `error.input.line`.
   */
  line?: number

  /**
   * Source column of the error.
   *
   * ```js
   * error.column       //=> 1
   * error.input.column //=> 4
   * ```
   *
   * PostCSS will use the input source map to detect the original location.
   * If you need the position in the PostCSS input, use `error.input.column`.
   */
  column?: number

  /**
   * Source code of the broken file.
   *
   * ```js
   * error.source       //=> 'a { b {} }'
   * error.input.source //=> 'a b { }'
   * ```
   */
  source?: string

  /**
   * Plugin name, if error came from plugin.
   *
   * ```js
   * error.plugin //=> 'postcss-vars'
   * ```
   */
  plugin?: string

  /**
   * Input object with PostCSS internal information
   * about input file. If input has source map
   * from previous tool, PostCSS will use origin
   * (for example, Sass) source. You can use this
   * object to get PostCSS input source.
   *
   * ```js
   * error.input.file //=> 'a.css'
   * error.file       //=> 'a.sass'
   * ```
   */
  input?: FilePosition

  /**
   * Returns error position, message and source code of the broken part.
   *
   * ```js
   * error.toString() //=> "CssSyntaxError: app.css:1:1: Unclosed block
   *                  //    > 1 | a {
   *                  //        | ^"
   * ```
   *
   * @return Error position, message and source code.
   */
  toString(): string

  /**
   * Returns a few lines of CSS source that caused the error.
   *
   * If the CSS has an input source map without `sourceContent`,
   * this method will return an empty string.
   *
   * ```js
   * error.showSourceCode() //=> "  4 | }
   *                        //      5 | a {
   *                        //    > 6 |   bad
   *                        //        |   ^
   *                        //      7 | }
   *                        //      8 | b {"
   * ```
   *
   * @param color Whether arrow will be colored red by terminal
   *              color codes. By default, PostCSS will detect
   *              color support by `process.stdout.isTTY`
   *              and `process.env.NODE_DISABLE_COLORS`.
   * @return Few lines of CSS source that caused the error.
   */
  showSourceCode(color?: boolean): string
}
