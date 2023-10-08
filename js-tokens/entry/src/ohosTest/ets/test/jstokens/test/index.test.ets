/*
 * Copyright (C) 2021 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import util from '@ohos.util';
import tokens from "js-tokens"
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { GlobalContext } from './globalThis'
import { getKeys } from './utils'

let jsTokens: RegExp = tokens.default

interface Options {
  closed?: boolean
}

interface Obj {

}

interface Token {
  type: string
  value: boolean
  closed: Options
}

export default function JSTOKENTest() {
  describe('JSTOKENTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    it('is_a_regex', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let that = new util.types();
      let result: boolean = that.isRegExp(jsTokens);
      expect(result).assertTrue()
    })

    it("is_a_function", 0, () => {
      expect(typeof tokens.matchToToken).assertEqual("function")
    })

    it("whitespace", 0, () => {
      let type: string = "whitespace"
      match(type, " ")
      match(type, "    ")
      match(type, " a", " ")
      match(type, "\t")
      match(type, "\t\t\t")
      match(type, "\ta", "\t")
      match(type, "\n")
      match(type, "\n\n\n")
      match(type, "\na", "\n")
      match(type, "\r")
      match(type, "\r\r\r")
      match(type, "\ra", "\r")
      match(type, " \t\n\r \r\n")
      match(type, " \t\n\r \r\n-1", " \t\n\r \r\n")
      match(type, "\f")
      match(type, "\v")

      match(type, "\u00a0")
      match(type, "\u1680")
      match(type, "\u2000")
      match(type, "\u2001")
      match(type, "\u2002")
      match(type, "\u2003")
      match(type, "\u2004")
      match(type, "\u2005")
      match(type, "\u2006")
      match(type, "\u2007")
      match(type, "\u2008")
      match(type, "\u2009")
      match(type, "\u200a")
      match(type, "\u2028")
      match(type, "\u2029")
      match(type, "\u202f")
      match(type, "\u205f")
      match(type, "\u3000")

    })


    it("comment", 0, () => {
      let type: string = "comment"
      match(type, "//")
      match(type, "//comment")
      match(type, "// comment")
      match(type, "//comment ")
      match(type, "///")
      match(type, "//**//")
      match(type, "//comment\n", "//comment")
      match(type, "//comment\r", "//comment")
      match(type, "//comment\u2028", "//comment")
      match(type, "//comment\u2029", "//comment")
      match(type, "//comment\r\n", "//comment")
      match(type, "//comment \n", "//comment ")
      match(type, "//comment\t\n", "//comment\t")

      let options: Options = {
        closed: true
      }
      let options1: Options = {
        closed: false
      }
      match(type, "/**/", options)
      match(type, "/*comment*/", options)
      match(type, "/* comment */", options)
      match(type, "/***/", options)
      match(type, "/*/*/", options)
      match(type, "/*\n\r\u2028\u2029 \r\n*/", options)

      match(type, "/*", options1)
      match(type, "/*/", options1)
      match(type, "/*unclosed", options1)
      match(type, "/*unclosed\nnew Line(this == code ? true : false)", options1)

    })


    it("string", 0, () => {
      let type: string = "string"
      match(type, "''")
      match(type, '""')
      match(type, "``")
      match(type, "'string'")
      match(type, '"string"')
      match(type, "`string`")
      match(type, "'\\''")
      match(type, '"\\""')
      match(type, "`\\``")
      match(type, "'\\\\''", "'\\\\'")
      match(type, '"\\\\""', '"\\\\"')
      match(type, "`\\\\``", "`\\\\`")
      match(type, "'\\\\\\''")
      match(type, '"\\\\\\""')
      match(type, "`\\\\\\``")
      match(type, "'\\u05aF'")
      match(type, '"\\u05aF"')
      match(type, "`\\u05aF`")
      match(type, "'invalid escape sequence is OK: \\u'")
      match(type, '"invalid escape sequence is OK: \\u"')
      match(type, "`invalid escape sequence is OK: \\u`")
      match(type, "'\\\n'")
      match(type, '"\\\n"')
      match(type, "`\\\n`")
      match(type, "'\\\r'")
      match(type, '"\\\r"')
      match(type, "`\\\r`")
      match(type, "'\u2028'")
      match(type, '"\u2028"')
      match(type, "`\u2028`")
      match(type, "'\u2029'")
      match(type, '"\u2029"')
      match(type, "`\u2029`")
      match(type, "'\\\u2028'")
      match(type, '"\\\u2028"')
      match(type, "`\\\u2028`")
      match(type, "'\\\u2029'")
      match(type, '"\\\u2029"')
      match(type, "`\\\u2029`")
      match(type, "'\\\r\n'")
      match(type, '"\\\r\n"')
      match(type, "`\\\r\n`")
      match(type, "'string'code'another string'", "'string'")
      match(type, '"string"code"another string"', '"string"')
      match(type, "`string`code`another string`", "`string`")
      match(type, "'\"'")
      match(type, "'`'")
      match(type, '"\'"')
      match(type, '"`"')
      match(type, "`'`")
      match(type, '`"`')

      let options: Options = {
        closed: false
      }

      match(type, "'", options)
      match(type, '"', options)
      match(type, "`", options)
      match(type, "'unclosed", options)
      match(type, '"unclosed', options)
      match(type, "`unclosed", options)
      match(type, "'\n", "'", options)
      match(type, '"\n', '"', options)
      match(type, "`\n", options)
      match(type, "'\r", "'", options)
      match(type, '"\r', '"', options)
      match(type, "`\r", options)
      match(type, "'\u2028", options)
      match(type, '"\u2028', options)
      match(type, "`\u2028", options)
      match(type, "'\u2029", options)
      match(type, '"\u2029', options)
      match(type, "`\u2029", options)
      match(type, "'\r\n", "'", options)
      match(type, '"\r\n', '"', options)
      match(type, "`\r\n", options)
      match(type, "'\\\n", options)
      match(type, '"\\\n', options)
      match(type, "`\\\n", options)
      match(type, "'\\\r", options)
      match(type, '"\\\r', options)
      match(type, "`\\\r", options)
      match(type, "'\\\u2028", options)
      match(type, '"\\\u2028', options)
      match(type, "`\\\u2028", options)
      match(type, "'\\\u2029", options)
      match(type, '"\\\u2029', options)
      match(type, "`\\\u2029", options)
      match(type, "'\\\r\n", options)
      match(type, '"\\\r\n', options)
      match(type, "`\\\r\n", options)

      match(type, "'${}'")
      match(type, '"${}"')
      match(type, "`${}`")
      match(type, "'${a}'")
      match(type, '"${a}"')
      match(type, "`${a}`")
      match(type, "'a${b}c'")
      match(type, '"a${b}c"')
      match(type, "`a${b}c`")
      match(type, "'${'a'}'", "'${'")
      match(type, '"${"a"}"', '"${"')
      match(type, "`${`a`}`")
      match(type, "`${`${a}`}`")
      match(type, "`${fn({a: b})}`")
      match(type, "`${fn({a: '{'})}`")
      match(type, "`a${}${a}${ `${b\r}` + `${`c`}` } d $${\n(x=>{return x*2})(4)}$`")
      match(type, "`\\${{{}}}a`")

      match(type, "`a ${b c`.length", options)
      match(type, "`a ${`b${c`} d`.length", options)
      match(type, "`a ${ {c:d } e`.length", options)
    })

    it("regex", 0, () => {
      let type: string = "regex"
      match(type, "//", false)
      match(type, "/a/")
      match(type, "/\\//")
      match(type, "/\\\\//", "/\\\\/")
      match(type, "/\\\\\\//")
      match(type, "/[/]/")
      match(type, "/[\\]]/")
      match(type, "/[\\]/]/")
      match(type, "/[\\\\]/]/", "/[\\\\]/")
      match(type, "/[\\\\\\]/]/")
      match(type, "/invalid escape sequence is OK: \\u/")
      match(type, "/?foo/")
      match(type, "/*foo/", false)

      match(type, "/a/g")
      match(type, "/a/m")
      match(type, "/a/i")
      match(type, "/a/y")
      match(type, "/a/u")
      match(type, "/a/s")
      match(type, "/a/gmiyus")
      match(type, "/a/myg")
      match(type, "/a/e", false)
      match(type, "/a/invalidFlags", false)
      match(type, "/a/f00", false)

      match(type, "/\n/", false)
      match(type, "/\r/", false)
      match(type, "/\u2028/", false)
      match(type, "/\u2029/", false)
      match(type, "/\r\n/", false)
      match(type, "/\\\n/", false)
      match(type, "/\\\r/", false)
      match(type, "/\\\u2028/", false)
      match(type, "/\\\u2029/", false)
      match(type, "/\\\r\n/", false)
      match(type, "/[\n]/", false)
      match(type, "/[\r]/", false)
      match(type, "/[\u2028]/", false)
      match(type, "/[\u2029]/", false)
      match(type, "/[\r\n]/", false)
      match(type, "/[\\\n]/", false)
      match(type, "/[\\\r]/", false)
      match(type, "/[\\\u2028]/", false)
      match(type, "/[\\\u2029]/", false)
      match(type, "/[\\\r\n]/", false)

      match(type, "/a/", "/a/")
      match(type, "/a/g", "/a/g")
      match(type, "/a/;", "/a/")
      match(type, "/a/g;", "/a/g")
      match(type, "/a/ ;", "/a/")
      match(type, "/a/g ;", "/a/g")
      match(type, "/a/, b", "/a/")
      match(type, "/a/g, b", "/a/g")
      match(type, "/a/ , b", "/a/")
      match(type, "/a/g , b", "/a/g")
      match(type, "/a/.exec(b)", "/a/")
      match(type, "/a/g.exec(b)", "/a/g")
      match(type, "/a/ .exec(b)", "/a/")
      match(type, "/a/g .exec(b)", "/a/g")
      match(type, "/a/['exec'](b)", "/a/")
      match(type, "/a/g['exec'](b)", "/a/g")
      match(type, "/a/ ['exec'](b)", "/a/")
      match(type, "/a/g ['exec'](b)", "/a/g")
      match(type, "/a/]", "/a/")
      match(type, "/a/g]", "/a/g")
      match(type, "/a/ ]", "/a/")
      match(type, "/a/g ]", "/a/g")
      match(type, "/a/)", "/a/")
      match(type, "/a/g)", "/a/g")
      match(type, "/a/ )", "/a/")
      match(type, "/a/g )", "/a/g")
      match(type, "/a/}", "/a/")
      match(type, "/a/g}", "/a/g")
      match(type, "/a/ }", "/a/")
      match(type, "/a/g }", "/a/g")

      match(type, "/a/+=b", "/a/")
      match(type, "/a/ +=b", "/a/")
      match(type, "/a/-=b", "/a/")
      match(type, "/a/ -=b", "/a/")
      match(type, "/a/*b", "/a/")
      match(type, "/a/ *b", "/a/")
      match(type, "/a/ *=b", "/a/")
      match(type, "/a//b", "/a/")
      match(type, "/a/ /b", "/a/")
      match(type, "/a/ /=b", "/a/")
      match(type, "/a/%b", "/a/")
      match(type, "/a/ %b", "/a/")
      match(type, "/a/%=b", "/a/")
      match(type, "/a/ %=b", "/a/")
      match(type, "/a/&b", "/a/")
      match(type, "/a/ &b", "/a/")
      match(type, "/a/&=b", "/a/")
      match(type, "/a/ &=b", "/a/")
      match(type, "/a/&&b", "/a/")
      match(type, "/a/ &&b", "/a/")
      match(type, "/a/|b", "/a/")
      match(type, "/a/ |b", "/a/")
      match(type, "/a/|=b", "/a/")
      match(type, "/a/ |=b", "/a/")
      match(type, "/a/||b", "/a/")
      match(type, "/a/ ||b", "/a/")
      match(type, "/a/^b", "/a/")
      match(type, "/a/ ^b", "/a/")
      match(type, "/a/^=b", "/a/")
      match(type, "/a/ ^=b", "/a/")
      match(type, "/a/<b", "/a/")
      match(type, "/a/ <b", "/a/")
      match(type, "/a/<=b", "/a/")
      match(type, "/a/ <=b", "/a/")
      match(type, "/a/<<b", "/a/")
      match(type, "/a/ <<b", "/a/")
      match(type, "/a/<<=b", "/a/")
      match(type, "/a/ <<=b", "/a/")
      match(type, "/a/>b", "/a/")
      match(type, "/a/ >b", "/a/")
      match(type, "/a/>=b", "/a/")
      match(type, "/a/ >=b", "/a/")
      match(type, "/a/>>b", "/a/")
      match(type, "/a/ >>b", "/a/")
      match(type, "/a/>>=b", "/a/")
      match(type, "/a/ >>=b", "/a/")
      match(type, "/a/>>>b", "/a/")
      match(type, "/a/ >>>=b", "/a/")
      match(type, "/a/>>>=b", "/a/")
      match(type, "/a/ >>>b", "/a/")
      match(type, "/a/!=b", "/a/")
      match(type, "/a/ !=b", "/a/")
      match(type, "/a/!==b", "/a/")
      match(type, "/a/ !==b", "/a/")
      match(type, "/a/=b", "/a/")
      match(type, "/a/ =b", "/a/")
      match(type, "/a/==b", "/a/")
      match(type, "/a/ ==b", "/a/")
      match(type, "/a/===b", "/a/")
      match(type, "/a/ ===b", "/a/")

      match(type, "/a/?b:c", "/a/")
      match(type, "/a/ ? b : c", "/a/")
      match(type, "/a/:c", "/a/")
      match(type, "/a/g:c", "/a/g")
      match(type, "/a/ : c", "/a/")
      match(type, "/a/g : c", "/a/g")

      match(type, "/a///", "/a/")
      match(type, "/a/g//", "/a/g")
      match(type, "/a/ //", "/a/")
      match(type, "/a/g //", "/a/g")
      match(type, "/a//**/", "/a/")
      match(type, "/a/g/**/", "/a/g")
      match(type, "/a/ /**/", "/a/")
      match(type, "/a/g /**/", "/a/g")

      match(type, "/a/g''", "/a/g")
      match(type, "/a/g ''", "/a/g")

      match(type, '/a/g""', "/a/g")
      match(type, '/a/g ""', "/a/g")

      match(type, "/a//b/", "/a/")
      match(type, "/a/ /b/", "/a/")

      match(type, "/a/g 0", "/a/g")
      match(type, "/a/g 0.1", "/a/g")
      match(type, "/a/g .1", "/a/g")
      match(type, "/a/g 0x1", "/a/g")

      match(type, "/a/g e", "/a/g")
      match(type, "/a/g _", "/a/g")
      match(type, "/a/g $", "/a/g")
      match(type, "/a/g é", "/a/g")
      match(type, "/a/g \\u0080", "/a/g")
    })


    it("number", 0, () => {
      let type: string = "number"
      match(type, "1")
      match(type, "1.")
      match(type, "1..", "1.")
      match(type, "0.1")
      match(type, ".1")
      match(type, "0.1.", "0.1")

      match(type, "-1", false)
      match(type, "-1.", false)
      match(type, "-1..", false)
      match(type, "-0.1", false)
      match(type, "-.1", false)
      match(type, "-0.1.", false)
      match(type, "-", false)

      match(type, "1e1")
      match(type, "1.e1")
      match(type, "1.e1.", "1.e1")
      match(type, "0.1e1")
      match(type, ".1e1")
      match(type, "0.1e1.", "0.1e1")

      match(type, "1e+1")
      match(type, "1e-1")
      match(type, "1e0123")
      match(type, "1e0.123", "1e0")
      match(type, "1e0x123", "1e0")
      match(type, "1E1")
      match(type, "1E+1")
      match(type, "1E-1")
      match(type, "1E0123")
      match(type, "1E0.123", "1E0")
      match(type, "1E0x123", "1E0")
      match(type, "1E0o123", "1E0")
      match(type, "1E0b123", "1E0")

      match(type, "e1", false)
      match(type, "e+1", false)
      match(type, "e-1", false)
      match(type, "E1", false)
      match(type, "E+1", false)
      match(type, "E-1", false)

      match(type, "-e1", false)
      match(type, "-e+1", false)
      match(type, "-e-1", false)
      match(type, "-E1", false)
      match(type, "-E+1", false)
      match(type, "-E-1", false)

      match(type, "0x1")
      match(type, "0xa")
      match(type, "0x015cF")
      match(type, "0x1e1")
      match(type, "0x1E1")
      match(type, "0x1g1", "0x1")

      match(type, "0X1")
      match(type, "0Xa")
      match(type, "0X015cF")
      match(type, "0X1e1")
      match(type, "0X1E1")
      match(type, "0X1g1", "0X1")

      match(type, "-0x1", false)
      match(type, "-0xa", false)
      match(type, "-0x015cF", false)
      match(type, "-0x1e1", false)
      match(type, "-0x1E1", false)
      match(type, "-0x1g1", false)

      match(type, "0x", "0")
      match(type, "1x1", "1")
      match(type, "0x1.", "0x1")
      match(type, "0x1.1", "0x1")
      match(type, "0.0x1", "0.0")
      match(type, ".0x1", ".0")

      match(type, "0o1")
      match(type, "0oa", "0")
      match(type, "0o01574")
      match(type, "0o1e1", "0o1")
      match(type, "0o1E1", "0o1")
      match(type, "0o1g1", "0o1")

      match(type, "0O1")
      match(type, "0Oa", "0")
      match(type, "0O01574")
      match(type, "0O1e1", "0O1")
      match(type, "0O1E1", "0O1")
      match(type, "0O1g1", "0O1")

      match(type, "-0o1", false)
      match(type, "-0oa", false)
      match(type, "-0o01574", false)
      match(type, "-0o1e1", false)
      match(type, "-0o1E1", false)
      match(type, "-0o1g1", false)

      match(type, "0o", "0")
      match(type, "1o1", "1")
      match(type, "0o1.", "0o1")
      match(type, "0o1.1", "0o1")
      match(type, "0.0o1", "0.0")
      match(type, ".0o1", ".0")

      match(type, "0b1")
      match(type, "0ba", "0")
      match(type, "0b01011")
      match(type, "0b1e1", "0b1")
      match(type, "0b1E1", "0b1")
      match(type, "0b1g1", "0b1")

      match(type, "0B1")
      match(type, "0Ba", "0")
      match(type, "0B01011")
      match(type, "0B1e1", "0B1")
      match(type, "0B1E1", "0B1")
      match(type, "0B1g1", "0B1")

      match(type, "-0b1", false)
      match(type, "-0ba", false)
      match(type, "-0b01011", false)
      match(type, "-0b1e1", false)
      match(type, "-0b1E1", false)
      match(type, "-0b1g1", false)

      match(type, "0b", "0")
      match(type, "1b1", "1")
      match(type, "0b1.", "0b1")
      match(type, "0b1.1", "0b1")
      match(type, "0.0b1", "0.0")
      match(type, ".0b1", ".0")

    })


    it("name", 0, () => {
      let type: string = "name"
      match(type, "$")
      match(type, "_")
      match(type, "a")
      match(type, "z")
      match(type, "A")
      match(type, "Z")
      match(type, "å")
      match(type, "π")
      match(type, "0", false)
      match(type, "0a", false)
      match(type, "$0")
      match(type, "_0")
      match(type, "a0")
      match(type, "z0")
      match(type, "A0")
      match(type, "Z0")
      match(type, "å0")
      match(type, "π0")
      match(type, "a_56åπ")
      match(type, "Iñtërnâtiônàlizætiøn☃💩") // The last character is Pile of poo.

      match(type, "a\u00a0", "a")
      match(type, "a\u1680", "a")
      match(type, "a\u2000", "a")
      match(type, "a\u2001", "a")
      match(type, "a\u2002", "a")
      match(type, "a\u2003", "a")
      match(type, "a\u2004", "a")
      match(type, "a\u2005", "a")
      match(type, "a\u2006", "a")
      match(type, "a\u2007", "a")
      match(type, "a\u2008", "a")
      match(type, "a\u2009", "a")
      match(type, "a\u200a", "a")
      match(type, "a\u2028", "a")
      match(type, "a\u2029", "a")
      match(type, "a\u202f", "a")
      match(type, "a\u205f", "a")
      match(type, "a\u3000", "a")

      match(type, "\\u0000")
      match(type, "\\u15cF")
      match(type, "\\u15cG", false)
      match(type, "\\u000", false)
      match(type, "\\u00000")
      match(type, "a\\u0000b")

      match(type, "\\u{0}")
      match(type, "\\u{01}")
      match(type, "\\u{012}")
      match(type, "\\u{0123}")
      match(type, "\\u{01234}")
      match(type, "\\u{012345}")
      match(type, "\\u{0123456}")
      match(type, "\\u{00000000000000a0}")
      match(type, "\\u{15cF}")
      match(type, "\\u{15cG}", false)
      match(type, "a\\u{0000}b")

      match(type, "\\x09", false)
    })


    it("punctuator", 0, () => {
      let type: string = "punctuator"
      match(type, "+")
      match(type, "++")
      match(type, "+=")
      match(type, "++=", "++")
      match(type, "-")
      match(type, "--")
      match(type, "-=")
      match(type, "--=", "--")
      match(type, "*")
      match(type, "**")
      match(type, "*=")
      match(type, "**=")
      match(type, "/")
      match(type, "//", false)
      match(type, "/=")
      match(type, "//=", false)
      match(type, "%")
      match(type, "%%", "%")
      match(type, "%=")
      match(type, "%%=", "%")
      match(type, "&")
      match(type, "&&")
      match(type, "&=")
      match(type, "&&=", "&&")
      match(type, "|")
      match(type, "||")
      match(type, "|=")
      match(type, "||=", "||")
      match(type, "^")
      match(type, "^^", "^")
      match(type, "^=")
      match(type, "^^=", "^")
      match(type, "<")
      match(type, "<<")
      match(type, "<<<", "<<")
      match(type, "<=")
      match(type, "<<=")
      match(type, ">")
      match(type, ">>")
      match(type, ">>>")
      match(type, ">=")
      match(type, ">>=")
      match(type, ">>>=")
      match(type, "!")
      match(type, "!=")
      match(type, "!==")
      match(type, "!===", "!==")
      match(type, "=")
      match(type, "==")
      match(type, "===")

      match(type, "=>")
      match(type, "==>", "==")
      match(type, "=>>", "=>")

      match(type, "...")
      match(type, "..", ".")
      match(type, ".")
      match(type, "....", "...")

      match(type, "?")
      match(type, "~")
      match(type, ".")
      match(type, ",")
      match(type, ":")
      match(type, ";")
      match(type, "[")
      match(type, "]")
      match(type, "(")
      match(type, ")")
      match(type, "{")
      match(type, "}")

      match(type, "/a/()", "/")
      match(type, "/a/g()", "/")
      match(type, "/a/ ()", "/")
      match(type, "/a/g ()", "/")
      match(type, "/a/{}", "/")
      match(type, "/a/g{}", "/")
      match(type, "/a/ {}", "/")
      match(type, "/a/g {}", "/")

      match(type, "/a/+b", "/")
      match(type, "/a/ +b", "/")
      match(type, "/a/++b", "/")
      match(type, "/a/ ++b", "/")
      match(type, "/a/-b", "/")
      match(type, "/a/ -b", "/")
      match(type, "/a/--b", "/")
      match(type, "/a/ --b", "/")
      match(type, "/a/!b", "/")
      match(type, "/a/ !b", "/")
      match(type, "/a/~b", "/")
      match(type, "/a/ ~b", "/")

      match(type, "/a/g+b", "/")
      match(type, "/a/g +b", "/")
      match(type, "/a/g+=b", "/")
      match(type, "/a/g +=b", "/")
      match(type, "/a/g++", "/")
      match(type, "/a/g ++", "/")
      match(type, "/a/g-b", "/")
      match(type, "/a/g -b", "/")
      match(type, "/a/g-=b", "/")
      match(type, "/a/g -=b", "/")
      match(type, "/a/g--", "/")
      match(type, "/a/g --", "/")
      match(type, "/a/g*b", "/")
      match(type, "/a/g *b", "/")
      match(type, "/a/g *=b", "/")
      match(type, "/a/g/b", "/")
      match(type, "/a/g /b", "/")
      match(type, "/a/g /=b", "/")
      match(type, "/a/g%b", "/")
      match(type, "/a/g %b", "/")
      match(type, "/a/g%=b", "/")
      match(type, "/a/g %=b", "/")
      match(type, "/a/g&b", "/")
      match(type, "/a/g &b", "/")
      match(type, "/a/g&=b", "/")
      match(type, "/a/g &=b", "/")
      match(type, "/a/g&&b", "/")
      match(type, "/a/g &&b", "/")
      match(type, "/a/g|b", "/")
      match(type, "/a/g |b", "/")
      match(type, "/a/g|=b", "/")
      match(type, "/a/g |=b", "/")
      match(type, "/a/g||b", "/")
      match(type, "/a/g ||b", "/")
      match(type, "/a/g^b", "/")
      match(type, "/a/g ^b", "/")
      match(type, "/a/g^=b", "/")
      match(type, "/a/g ^=b", "/")
      match(type, "/a/g<b", "/")
      match(type, "/a/g <b", "/")
      match(type, "/a/g<=b", "/")
      match(type, "/a/g <=b", "/")
      match(type, "/a/g<<b", "/")
      match(type, "/a/g <<b", "/")
      match(type, "/a/g<<=b", "/")
      match(type, "/a/g <<=b", "/")
      match(type, "/a/g>b", "/")
      match(type, "/a/g >b", "/")
      match(type, "/a/g>=b", "/")
      match(type, "/a/g >=b", "/")
      match(type, "/a/g>>b", "/")
      match(type, "/a/g >>b", "/")
      match(type, "/a/g>>=b", "/")
      match(type, "/a/g >>=b", "/")
      match(type, "/a/g>>>b", "/")
      match(type, "/a/g >>>=b", "/")
      match(type, "/a/g>>>=b", "/")
      match(type, "/a/g >>>b", "/")
      match(type, "/a/g!=b", "/")
      match(type, "/a/g !=b", "/")
      match(type, "/a/g!==b", "/")
      match(type, "/a/g !==b", "/")
      match(type, "/a/g=b", "/")
      match(type, "/a/g =b", "/")
      match(type, "/a/g==b", "/")
      match(type, "/a/g ==b", "/")
      match(type, "/a/g===b", "/")
      match(type, "/a/g ===b", "/")

      match(type, "/a/g?b:c", "/")
      match(type, "/a/g ? b : c", "/")

      match(type, "/a/''", "/")
      match(type, "/a/ ''", "/")

      match(type, '/a/""', "/")
      match(type, '/a/ ""', "/")

      match(type, "/a/g/b/", "/")
      match(type, "/a/g /b/", "/")

      match(type, "/a/0", "/")
      match(type, "/a/ 0", "/")
      match(type, "/a/0.1", "/")
      match(type, "/a/ 0.1", "/")
      match(type, "/a/.1", "/")
      match(type, "/a/ .1", "/")

      match(type, "/a/e", "/")
      match(type, "/a/ e", "/")
      match(type, "/a/_", "/")
      match(type, "/a/ _", "/")
      match(type, "/a/$", "/")
      match(type, "/a/ $", "/")
      match(type, "/a/é", "/")
      match(type, "/a/ é", "/")
      match(type, "/a/\\u0080", "/")
      match(type, "/a/ \\u0080", "/")

      match(type, "/a/ge", "/")
      match(type, "/a/g_", "/")
      match(type, "/a/g$", "/")
      match(type, "/a/gé", "/")
      match(type, "/a/g0", "/")
      match(type, "/a/g\\u0080", "/")
    })


    it("invalid", 0, () => {
      let type: string = "invalid"
      match(type, "@")
      match(type, "#")
      match(type, "\\")
      match(type, "\\xa9", "\\")
      match(type, "\u0000")
      match(type, "\u007F")
    })

    it("test_base64", 0, () => {
      let gloContext: Context = GlobalContext.getContext().getObject("context") as Context
      gloContext.createModuleContext('entry_test').resourceManager.getMediaContent($r('app.media.base64').id).then(uint8 => {
        let contents = Uint8ArrayToString(uint8);
        let expected = [
          "/*\n * https://github.com/davidchambers/Base64.js\n */", "\n",
          ";", "(", "function", " ", "(", ")", " ", "{", "\n\n  ",

          "var", " ", "object", " ", "=", " ", "typeof", " ", "exports", " ", "!=", " ", "'undefined'", " ", "?", " ", "exports", " ", ":", " ", "this", ";", " ", "// #8: web workers", "\n  ",
          "var", " ", "chars", " ", "=", " ", "'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/='", ";", "\n\n  ",

          "function", " ", "InvalidCharacterError", "(", "message", ")", " ", "{", "\n    ",
          "this", ".", "message", " ", "=", " ", "message", ";", "\n  ",
          "}", "\n  ",
          "InvalidCharacterError", ".", "prototype", " ", "=", " ", "new", " ", "Error", ";", "\n  ",
          "InvalidCharacterError", ".", "prototype", ".", "name", " ", "=", " ", "'InvalidCharacterError'", ";", "\n\n  ",

          "// encoder", "\n  ",
          "// [https://gist.github.com/999166] by [https://github.com/nignag]", "\n  ",
          "object", ".", "btoa", " ", "||", " ", "(", "\n  ",
          "object", ".", "btoa", " ", "=", " ", "function", " ", "(", "input", ")", " ", "{", "\n    ",
          "for", " ", "(", "\n      ",
          "// initialize result and counter", "\n      ",
          "var", " ", "block", ",", " ", "charCode", ",", " ", "idx", " ", "=", " ", "0", ",", " ", "map", " ", "=", " ", "chars", ",", " ", "output", " ", "=", " ", "''", ";", "\n      ",
          "// if the next input index does not exist:", "\n      ",
          "//   change the mapping table to \"=\"", "\n      ",
          "//   check if d has no fractional digits", "\n      ",
          "input", ".", "charAt", "(", "idx", " ", "|", " ", "0", ")", " ", "||", " ", "(", "map", " ", "=", " ", "'='", ",", " ", "idx", " ", "%", " ", "1", ")", ";", "\n      ",
          "// \"8 - idx % 1 * 8\" generates the sequence 2, 4, 6, 8", "\n      ",
          "output", " ", "+=", " ", "map", ".", "charAt", "(", "63", " ", "&", " ", "block", " ", ">>", " ", "8", " ", "-", " ", "idx", " ", "%", " ", "1", " ", "*", " ", "8", ")", "\n    ",
          ")", " ", "{", "\n      ",
          "charCode", " ", "=", " ", "input", ".", "charCodeAt", "(", "idx", " ", "+=", " ", "3", "/", "4", ")", ";", "\n      ",
          "if", " ", "(", "charCode", " ", ">", " ", "0xFF", ")", " ", "{", "\n        ",
          "throw", " ", "new", " ", "InvalidCharacterError", "(", "\"'btoa' failed: The string to be encoded contains characters outside of the Latin1 range.\"", ")", ";", "\n      ",
          "}", "\n      ",
          "block", " ", "=", " ", "block", " ", "<<", " ", "8", " ", "|", " ", "charCode", ";", "\n    ",
          "}", "\n    ",
          "return", " ", "output", ";", "\n  ",
          "}", ")", ";", "\n\n  ",

          "// decoder", "\n  ",
          "// [https://gist.github.com/1020396] by [https://github.com/atk]", "\n  ",
          "object", ".", "atob", " ", "||", " ", "(", "\n  ",
          "object", ".", "atob", " ", "=", " ", "function", " ", "(", "input", ")", " ", "{", "\n    ",
          "input", " ", "=", " ", "input", ".", "replace", "(", "/=+$/", ",", " ", "''", ")", "\n    ",
          "if", " ", "(", "input", ".", "length", " ", "%", " ", "4", " ", "==", " ", "1", ")", " ", "{", "\n      ",
          "throw", " ", "new", " ", "InvalidCharacterError", "(", "\"'atob' failed: The string to be decoded is not correctly encoded.\"", ")", ";", "\n    ",
          "}", "\n    ",
          "for", " ", "(", "\n      ",
          "// initialize result and counters", "\n      ",
          "var", " ", "bc", " ", "=", " ", "0", ",", " ", "bs", ",", " ", "buffer", ",", " ", "idx", " ", "=", " ", "0", ",", " ", "output", " ", "=", " ", "''", ";", "\n      ",
          "// get next character", "\n      ",
          "buffer", " ", "=", " ", "input", ".", "charAt", "(", "idx", "++", ")", ";", "\n      ",
          "// character found in table? initialize bit storage and add its ascii value;", "\n      ",
          "~", "buffer", " ", "&&", " ", "(", "bs", " ", "=", " ", "bc", " ", "%", " ", "4", " ", "?", " ", "bs", " ", "*", " ", "64", " ", "+", " ", "buffer", " ", ":", " ", "buffer", ",", "\n        ",
          "// and if not first of each 4 characters,", "\n        ",
          "// convert the first 8 bits to one ascii character", "\n        ",
          "bc", "++", " ", "%", " ", "4", ")", " ", "?", " ", "output", " ", "+=", " ", "String", ".", "fromCharCode", "(", "255", " ", "&", " ", "bs", " ", ">>", " ", "(", "-", "2", " ", "*", " ", "bc", " ", "&", " ", "6", ")", ")", " ", ":", " ", "0", "\n    ",
          ")", " ", "{", "\n      ",
          "// try to find character in table (0-63, not found => -1)", "\n      ",
          "buffer", " ", "=", " ", "chars", ".", "indexOf", "(", "buffer", ")", ";", "\n    ",
          "}", "\n    ",
          "return", " ", "output", ";", "\n  ",
          "}", ")", ";", "\n\n",

          "}", "(", ")", ")", ";", "\n"
        ]

        let actual = contents.match(jsTokens)
        expect(actual).assertDeepEquals(expected)
        if(actual) {
          expect(actual.join("")).assertEqual(contents)
        }
      })
    })

    it("test_errors", 0, () => {
      let gloContext: Context = GlobalContext.getContext().getObject("context") as Context
      gloContext.createModuleContext('entry_test').resourceManager.getMediaContent($r('app.media.errors').id).then(uint8 => {
        let contents = Uint8ArrayToString(uint8);
        let expected = [
          "var", " ", "multiLineString", " ", "=", " ", "'\\\nWhile I was writing along\\\nI suddenly forgot to", "\n",
          "add", " ", "a", " ", "backslash", " ", "@", " ", "the", " ", "end", " ", "of", " ", "a", " ", "line", "'", "\n\n",

          "var", " ", "unterminatedRegex", " ", "=", " ", "/", "3", "?", "2", ":", "1", "\n\n",

          "#", " ", "Oops", ",", " ", "forgot", " ", "that", " ", "this", " ", "isn’t", " ", "coffee", "-", "script", ".", "\n\n",

          "/* Let’s try a valid JavaScript comment instead\n\nvar string='Pity I forgot to close it, though'\n"
        ]

        let actual = contents.match(jsTokens)
        expect(actual).assertDeepEquals(expected)
        if(actual) {
          expect(actual.join("")).assertEqual(contents)
        }
      })
    })

    it("test_regex", 0, () => {
      let gloContext: Context = GlobalContext.getContext().getObject("context") as Context
      gloContext.createModuleContext('entry_test').resourceManager.getMediaContent($r('app.media.regex').id).then(uint8 => {
        let contents = Uint8ArrayToString(uint8);
        let expected = [
          "foo", "(", "/a/", ")", "\n",
          "foo", "(", "/a/g", ")", "\n",
          "foo", "(", " ", "/a/", " ", ")", "\n",
          "foo", "(", " ", "/a/g", " ", ")", "\n",
          "foo", "(", "/a/", ",", " ", "bar", ")", "\n",
          "foo", "(", "/a/g", ",", " ", "bar", ")", "\n",
          "foo", "(", "/a/", ",", " ", "/a/g", ",", " ", "/b/g", ",", " ", "/b/", ")", "\n\n",

          "arr", " ", "=", " ", "[", "/a/", "]", "\n",
          "arr", " ", "=", " ", "[", "/a/g", "]", "\n",
          "arr", " ", "=", " ", "[", " ", "/a/", " ", "]", "\n",
          "arr", " ", "=", " ", "[", " ", "/a/g", " ", "]", "\n\n",

          "obj", " ", "=", " ", "{", "re", ":", " ", "/a/", "}", "\n",
          "obj", " ", "=", " ", "{", "re", ":", " ", "/a/g", "}", "\n",
          "obj", " ", "=", " ", "{", " ", "re", ":", " ", "/a/", " ", "}", "\n",
          "obj", " ", "=", " ", "{", " ", "re", ":", " ", "/a/g", " ", "}", "\n\n",

          "re", " ", "=", " ", "foo", " ", "?", " ", "/a/", " ", ":", " ", "RegExp", "(", "bar", ")", "\n",
          "re", " ", "=", " ", "foo", " ", "?", " ", "/a/g", " ", ":", " ", "RegExp", "(", "bar", ")", "\n\n",

          "/a/", ".", "exec", "(", "foo", ")", "\n",
          "/a/g", ".", "exec", "(", "foo", ")", "\n\n",

          "foo", " ", "=", " ", "(", "1", "/", "2", ")", " ", "+", " ", "/a/", ".", "exec", "(", "bar", ")", "[", "0", "]", "\n",
          "foo", " ", "=", " ", "(", "1", "/", "2", ")", " ", "+", " ", "/a/g", ".", "exec", "(", "bar", ")", "[", "0", "]", "\n\n",

          "re", " ", "=", " ", "/a/", "// comment", "\n",
          "re", " ", "=", " ", "/a/g", "// comment", "\n",
          "re", " ", "=", " ", "/a/", "/* comment */", "\n",
          "re", " ", "=", " ", "/a/g", "/* comment */", "\n\n",

          "re", " ", "=", " ", "/a/", " ", "// comment", "\n",
          "re", " ", "=", " ", "/a/g", " ", "// comment", "\n",
          "re", " ", "=", " ", "/a/", " ", "/* comment */", "\n",
          "re", " ", "=", " ", "/a/g", " ", "/* comment */", "\n\n",

          "silly", " ", "=", " ", "/a/", " ", "?", " ", "true", " ", ":", " ", "false", "\n",
          "if", " ", "(", "/a/", " ", "==", " ", "\"/a/\"", ")", " ", "{", "}", "\n",
          "if", " ", "(", "/a/", " ", "&&", " ", "foo", ")", " ", "{", "}", "\n",
          "if", " ", "(", "/a/", " ", "||", " ", "foo", ")", " ", "{", "}", "\n"
        ]

        let actual = contents.match(jsTokens)
        expect(actual).assertDeepEquals(expected)
        if(actual) {
          expect(actual.join("")).assertEqual(contents)
        }
      })
    })
    it("test_division", 0, () => {
      let gloContext: Context = GlobalContext.getContext().getObject("context") as Context
      gloContext.createModuleContext('entry_test').resourceManager.getMediaContent($r('app.media.division').id).then(uint8 => {
        let contents = Uint8ArrayToString(uint8);
        let expected = [
          "foo", " ", "=", " ", "1", "/", "a", "/", "2", "\n",
          "foo", " ", "=", " ", "1", "/", "a", "/", "\n  ", "2", "\n",
          "foo", " ", "=", " ", "1", "/", "a", "/", "(", "b", "+", "1", ")", "\n",
          "foo", " ", "=", " ", "1", "/", "a", "/", "~", "bar", ".", "indexOf", "(", "baz", ")", "\n",
          "foo", " ", "=", " ", "1", "/", "a", "/", "+", "str", "\n",
          "foo", " ", "=", " ", "1", "/", "a", "/", "-", "1", "\n",
          "foo", " ", "=", " ", "1", "/", "a", "/", "-", "bar", "\n",
          "foo", " ", "=", " ", "1", "/", "a", "/", "--", "bar", "\n",
          "foo", " ", "=", " ", "1", "/", "a", "/", "\n  ", "--", "bar", "\n",
          "foo", " ", "=", " ", "1", "/", "a", "/", " ", "++", "bar", "\n\n",

          "foo", " ", "=", " ", "1", "/", "a", "/", "g", "+", "1", "\n",
          "foo", " ", "=", " ", "1", "/", "a", "/", "g", " ", "-", " ", "1", "\n",
          "foo", " ", "=", " ", "1", "/", "a", "/", "g", "*", "1", "\n",
          "foo", " ", "=", " ", "1", "/", "a", "/", "g", "/", "1", "\n",
          "foo", " ", "=", " ", "1", "/", "a", "/", "g", "\n  ", "/", "1", "\n\n",

          "if", " ", "(", "1", "/", "a", "/", "g", " ", "&&", " ", "foo", ")", " ", "{", "}", "\n",
          "if", " ", "(", "1", "/", "a", "/", "g", "\n    ", "&&", " ", "foo", ")", " ", "{", "}", "\n",
          "if", " ", "(", "1", "/", "a", "/", "g", " ", "||", " ", "foo", ")", " ", "{", "}", "\n",
          "if", " ", "(", "1", "/", "a", "/", "g", " ", "===", " ", "3", ")", " ", "{", "}", "\n\n",

          "foo", " ", "=", " ", "1", "/", "a", "/", "g", " ", "?", " ", "true", " ", ":", " ", "false", "\n\n",

          "nan", " ", "=", " ", "1", "/", "a", "/", "''", "\n",
          "nan", " ", "=", " ", "1", "/", "a", "/", " ", "\"\"", "\n\n",

          "foo", " ", "=", " ", "1", "/", "a", "/", "goo", "\n",
          "foo", " ", "=", " ", "1", "/", "a", "/", "iff", "\n",
          "foo", " ", "=", " ", "1", "/", "a", "/", "igor", "\n",
          "foo", " ", "=", " ", "1", "/", "a", "/", "moo", "\n",
          "foo", " ", "=", " ", "1", "/", "a", "/", "yüm", "\n",
          "foo", " ", "=", " ", "1", "/", "a", "/", "imgyp", "\n"
        ]
        let actual = contents.match(jsTokens)
        expect(actual).assertDeepEquals(expected)
        if(actual) {
          expect(actual.join("")).assertEqual(contents)
        }
      })
    })
  })
}
function match(type: string, string?: string, expected?: Options | string | boolean, extra?: Options) {
  // let obj: Options = {}
  extra = extra || {}
  if (typeof expected === "object") {
    extra = expected
    expected = undefined
  }
  jsTokens.lastIndex = 0
  if(string){
    let token: Token = tokens.matchToToken(jsTokens.exec(string))
    if (expected === false) {
      expect(token.type).not().assertEqual(type)

    } else {
      expect(token.type).assertEqual(type)
      expect(token.value).assertEqual
      (typeof expected === "string" ? expected : string)
      let objKeys : string[] = getKeys(extra)
      if (objKeys.indexOf("closed") !== -1) {
        expect(token.closed).assertEqual(extra.closed)
      } else if (type === "string") {
        expect(token.closed).assertEqual(true)
      }
    }
  }
}

function Uint8ArrayToString(fileData: Uint8Array) {
  let dataString = "";
  for (let i = 0; i < fileData.length; i++) {
    dataString += String.fromCharCode(fileData[i]);
  }
  return dataString
}

