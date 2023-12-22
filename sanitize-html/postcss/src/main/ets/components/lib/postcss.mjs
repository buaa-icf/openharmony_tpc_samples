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
import postcss from './postcss.js'

export default postcss

export const stringify = postcss.stringify
export const fromJSON = postcss.fromJSON
export const plugin = postcss.plugin
export const parse = postcss.parse
export const list = postcss.list

export const document = postcss.document
export const comment = postcss.comment
export const atRule = postcss.atRule
export const rule = postcss.rule
export const decl = postcss.decl
export const root = postcss.root

export const CssSyntaxError = postcss.CssSyntaxError
export const Declaration = postcss.Declaration
export const Container = postcss.Container
export const Document = postcss.Document
export const Comment = postcss.Comment
export const Warning = postcss.Warning
export const AtRule = postcss.AtRule
export const Result = postcss.Result
export const Input = postcss.Input
export const Rule = postcss.Rule
export const Root = postcss.Root
export const Node = postcss.Node
