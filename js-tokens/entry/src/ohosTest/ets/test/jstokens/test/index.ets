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
// @ts-ignore
import tokens from "js-tokens"

var jsTokens = tokens.default
var matchToToken = tokens.matchToToken

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'

export default function JSTOKENTest() {
  describe('JSTOKENTest', function () {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(function () {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(function () {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(function () {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(function () {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    it('is_a_regex', 0, function () {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      var that = new util.types();
      var result = that.isRegExp(jsTokens);
      expect(result).assertTrue()
    })


    it("is_a_function", 0, function () {
      expect(typeof matchToToken).assertEqual("function")
    })

    function matchHelper(type, string, expected, extra) {
      extra = extra || {}
      if (typeof expected === "object") {
        extra = expected
        expected = undefined
      }
      jsTokens.lastIndex = 0
      var token = matchToToken(jsTokens.exec(string))


      if (expected === false) {
        expect(token.type).not().assertEqual(type)

      } else {
        expect(token.type).assertEqual(type)
        expect(token.value).assertEqual
        (typeof expected === "string" ? expected : string)
        if ("closed" in extra) {
          expect(token.closed).assertEqual(extra.closed)
        } else if (type === "string") {
          expect(token.closed).assertEqual(true)
        }
      }

    }


    function token(name, fn) {
      it(name, 0, fn.bind(null, matchHelper.bind(null, name)))
    }


    token("whitespace", function (match) {

      match(" ")
      match("    ")
      match(" a", " ")
      match("\t")
      match("\t\t\t")
      match("\ta", "\t")
      match("\n")
      match("\n\n\n")
      match("\na", "\n")
      match("\r")
      match("\r\r\r")
      match("\ra", "\r")
      match(" \t\n\r \r\n")
      match(" \t\n\r \r\n-1", " \t\n\r \r\n")
      match("\f")
      match("\v")

      match("\u00a0")
      match("\u1680")
      match("\u2000")
      match("\u2001")
      match("\u2002")
      match("\u2003")
      match("\u2004")
      match("\u2005")
      match("\u2006")
      match("\u2007")
      match("\u2008")
      match("\u2009")
      match("\u200a")
      match("\u2028")
      match("\u2029")
      match("\u202f")
      match("\u205f")
      match("\u3000")

    })


    token("comment", function (match) {

      match("//")
      match("//comment")
      match("// comment")
      match("//comment ")
      match("///")
      match("//**//")
      match("//comment\n", "//comment")
      match("//comment\r", "//comment")
      match("//comment\u2028", "//comment")
      match("//comment\u2029", "//comment")
      match("//comment\r\n", "//comment")
      match("//comment \n", "//comment ")
      match("//comment\t\n", "//comment\t")

      match("/**/", {
        closed: true
      })
      match("/*comment*/", {
        closed: true
      })
      match("/* comment */", {
        closed: true
      })
      match("/***/", {
        closed: true
      })
      match("/*/*/", {
        closed: true
      })
      match("/*\n\r\u2028\u2029 \r\n*/", {
        closed: true
      })

      match("/*", {
        closed: false
      })
      match("/*/", {
        closed: false
      })
      match("/*unclosed", {
        closed: false
      })
      match("/*unclosed\nnew Line(this == code ? true : false)", {
        closed: false
      })

    })


    token("string", function (match) {

      match("''")
      match('""')
      match("``")
      match("'string'")
      match('"string"')
      match("`string`")
      match("'\\''")
      match('"\\""')
      match("`\\``")
      match("'\\\\''", "'\\\\'")
      match('"\\\\""', '"\\\\"')
      match("`\\\\``", "`\\\\`")
      match("'\\\\\\''")
      match('"\\\\\\""')
      match("`\\\\\\``")
      match("'\\u05aF'")
      match('"\\u05aF"')
      match("`\\u05aF`")
      match("'invalid escape sequence is OK: \\u'")
      match('"invalid escape sequence is OK: \\u"')
      match("`invalid escape sequence is OK: \\u`")
      match("'\\\n'")
      match('"\\\n"')
      match("`\\\n`")
      match("'\\\r'")
      match('"\\\r"')
      match("`\\\r`")
      match("'\u2028'")
      match('"\u2028"')
      match("`\u2028`")
      match("'\u2029'")
      match('"\u2029"')
      match("`\u2029`")
      match("'\\\u2028'")
      match('"\\\u2028"')
      match("`\\\u2028`")
      match("'\\\u2029'")
      match('"\\\u2029"')
      match("`\\\u2029`")
      match("'\\\r\n'")
      match('"\\\r\n"')
      match("`\\\r\n`")
      match("'string'code'another string'", "'string'")
      match('"string"code"another string"', '"string"')
      match("`string`code`another string`", "`string`")
      match("'\"'")
      match("'`'")
      match('"\'"')
      match('"`"')
      match("`'`")
      match('`"`')

      match("'", {
        closed: false
      })
      match('"', {
        closed: false
      })
      match("`", {
        closed: false
      })
      match("'unclosed", {
        closed: false
      })
      match('"unclosed', {
        closed: false
      })
      match("`unclosed", {
        closed: false
      })
      match("'\n", "'", {
        closed: false
      })
      match('"\n', '"', {
        closed: false
      })
      match("`\n", {
        closed: false
      })
      match("'\r", "'", {
        closed: false
      })
      match('"\r', '"', {
        closed: false
      })
      match("`\r", {
        closed: false
      })
      match("'\u2028", {
        closed: false
      })
      match('"\u2028', {
        closed: false
      })
      match("`\u2028", {
        closed: false
      })
      match("'\u2029", {
        closed: false
      })
      match('"\u2029', {
        closed: false
      })
      match("`\u2029", {
        closed: false
      })
      match("'\r\n", "'", {
        closed: false
      })
      match('"\r\n', '"', {
        closed: false
      })
      match("`\r\n", {
        closed: false
      })
      match("'\\\n", {
        closed: false
      })
      match('"\\\n', {
        closed: false
      })
      match("`\\\n", {
        closed: false
      })
      match("'\\\r", {
        closed: false
      })
      match('"\\\r', {
        closed: false
      })
      match("`\\\r", {
        closed: false
      })
      match("'\\\u2028", {
        closed: false
      })
      match('"\\\u2028', {
        closed: false
      })
      match("`\\\u2028", {
        closed: false
      })
      match("'\\\u2029", {
        closed: false
      })
      match('"\\\u2029', {
        closed: false
      })
      match("`\\\u2029", {
        closed: false
      })
      match("'\\\r\n", {
        closed: false
      })
      match('"\\\r\n', {
        closed: false
      })
      match("`\\\r\n", {
        closed: false
      })

      match("'${}'")
      match('"${}"')
      match("`${}`")
      match("'${a}'")
      match('"${a}"')
      match("`${a}`")
      match("'a${b}c'")
      match('"a${b}c"')
      match("`a${b}c`")
      match("'${'a'}'", "'${'")
      match('"${"a"}"', '"${"')
      match("`${`a`}`")
      match("`${`${a}`}`")
      match("`${fn({a: b})}`")
      match("`${fn({a: '{'})}`")
      match("`a${}${a}${ `${b\r}` + `${`c`}` } d $${\n(x=>{return x*2})(4)}$`")
      match("`\\${{{}}}a`")

      match("`a ${b c`.length", {
        closed: false
      })
      match("`a ${`b${c`} d`.length", {
        closed: false
      })
      match("`a ${ {c:d } e`.length", {
        closed: false
      })
    })

    token("regex", function (match) {
      match("//", false)
      match("/a/")
      match("/\\//")
      match("/\\\\//", "/\\\\/")
      match("/\\\\\\//")
      match("/[/]/")
      match("/[\\]]/")
      match("/[\\]/]/")
      match("/[\\\\]/]/", "/[\\\\]/")
      match("/[\\\\\\]/]/")
      match("/invalid escape sequence is OK: \\u/")
      match("/?foo/")
      match("/*foo/", false)

      match("/a/g")
      match("/a/m")
      match("/a/i")
      match("/a/y")
      match("/a/u")
      match("/a/s")
      match("/a/gmiyus")
      match("/a/myg")
      match("/a/e", false)
      match("/a/invalidFlags", false)
      match("/a/f00", false)

      match("/\n/", false)
      match("/\r/", false)
      match("/\u2028/", false)
      match("/\u2029/", false)
      match("/\r\n/", false)
      match("/\\\n/", false)
      match("/\\\r/", false)
      match("/\\\u2028/", false)
      match("/\\\u2029/", false)
      match("/\\\r\n/", false)
      match("/[\n]/", false)
      match("/[\r]/", false)
      match("/[\u2028]/", false)
      match("/[\u2029]/", false)
      match("/[\r\n]/", false)
      match("/[\\\n]/", false)
      match("/[\\\r]/", false)
      match("/[\\\u2028]/", false)
      match("/[\\\u2029]/", false)
      match("/[\\\r\n]/", false)

      match("/a/", "/a/")
      match("/a/g", "/a/g")
      match("/a/;", "/a/")
      match("/a/g;", "/a/g")
      match("/a/ ;", "/a/")
      match("/a/g ;", "/a/g")
      match("/a/, b", "/a/")
      match("/a/g, b", "/a/g")
      match("/a/ , b", "/a/")
      match("/a/g , b", "/a/g")
      match("/a/.exec(b)", "/a/")
      match("/a/g.exec(b)", "/a/g")
      match("/a/ .exec(b)", "/a/")
      match("/a/g .exec(b)", "/a/g")
      match("/a/['exec'](b)", "/a/")
      match("/a/g['exec'](b)", "/a/g")
      match("/a/ ['exec'](b)", "/a/")
      match("/a/g ['exec'](b)", "/a/g")
      match("/a/]", "/a/")
      match("/a/g]", "/a/g")
      match("/a/ ]", "/a/")
      match("/a/g ]", "/a/g")
      match("/a/)", "/a/")
      match("/a/g)", "/a/g")
      match("/a/ )", "/a/")
      match("/a/g )", "/a/g")
      match("/a/}", "/a/")
      match("/a/g}", "/a/g")
      match("/a/ }", "/a/")
      match("/a/g }", "/a/g")

      match("/a/+=b", "/a/")
      match("/a/ +=b", "/a/")
      match("/a/-=b", "/a/")
      match("/a/ -=b", "/a/")
      match("/a/*b", "/a/")
      match("/a/ *b", "/a/")
      match("/a/ *=b", "/a/")
      match("/a//b", "/a/")
      match("/a/ /b", "/a/")
      match("/a/ /=b", "/a/")
      match("/a/%b", "/a/")
      match("/a/ %b", "/a/")
      match("/a/%=b", "/a/")
      match("/a/ %=b", "/a/")
      match("/a/&b", "/a/")
      match("/a/ &b", "/a/")
      match("/a/&=b", "/a/")
      match("/a/ &=b", "/a/")
      match("/a/&&b", "/a/")
      match("/a/ &&b", "/a/")
      match("/a/|b", "/a/")
      match("/a/ |b", "/a/")
      match("/a/|=b", "/a/")
      match("/a/ |=b", "/a/")
      match("/a/||b", "/a/")
      match("/a/ ||b", "/a/")
      match("/a/^b", "/a/")
      match("/a/ ^b", "/a/")
      match("/a/^=b", "/a/")
      match("/a/ ^=b", "/a/")
      match("/a/<b", "/a/")
      match("/a/ <b", "/a/")
      match("/a/<=b", "/a/")
      match("/a/ <=b", "/a/")
      match("/a/<<b", "/a/")
      match("/a/ <<b", "/a/")
      match("/a/<<=b", "/a/")
      match("/a/ <<=b", "/a/")
      match("/a/>b", "/a/")
      match("/a/ >b", "/a/")
      match("/a/>=b", "/a/")
      match("/a/ >=b", "/a/")
      match("/a/>>b", "/a/")
      match("/a/ >>b", "/a/")
      match("/a/>>=b", "/a/")
      match("/a/ >>=b", "/a/")
      match("/a/>>>b", "/a/")
      match("/a/ >>>=b", "/a/")
      match("/a/>>>=b", "/a/")
      match("/a/ >>>b", "/a/")
      match("/a/!=b", "/a/")
      match("/a/ !=b", "/a/")
      match("/a/!==b", "/a/")
      match("/a/ !==b", "/a/")
      match("/a/=b", "/a/")
      match("/a/ =b", "/a/")
      match("/a/==b", "/a/")
      match("/a/ ==b", "/a/")
      match("/a/===b", "/a/")
      match("/a/ ===b", "/a/")

      match("/a/?b:c", "/a/")
      match("/a/ ? b : c", "/a/")
      match("/a/:c", "/a/")
      match("/a/g:c", "/a/g")
      match("/a/ : c", "/a/")
      match("/a/g : c", "/a/g")

      match("/a///", "/a/")
      match("/a/g//", "/a/g")
      match("/a/ //", "/a/")
      match("/a/g //", "/a/g")
      match("/a//**/", "/a/")
      match("/a/g/**/", "/a/g")
      match("/a/ /**/", "/a/")
      match("/a/g /**/", "/a/g")

      match("/a/g''", "/a/g")
      match("/a/g ''", "/a/g")

      match('/a/g""', "/a/g")
      match('/a/g ""', "/a/g")

      match("/a//b/", "/a/")
      match("/a/ /b/", "/a/")

      match("/a/g 0", "/a/g")
      match("/a/g 0.1", "/a/g")
      match("/a/g .1", "/a/g")
      match("/a/g 0x1", "/a/g")

      match("/a/g e", "/a/g")
      match("/a/g _", "/a/g")
      match("/a/g $", "/a/g")
      match("/a/g é", "/a/g")
      match("/a/g \\u0080", "/a/g")
    })


    token("number", function (match) {
      match("1")
      match("1.")
      match("1..", "1.")
      match("0.1")
      match(".1")
      match("0.1.", "0.1")

      match("-1", false)
      match("-1.", false)
      match("-1..", false)
      match("-0.1", false)
      match("-.1", false)
      match("-0.1.", false)
      match("-", false)

      match("1e1")
      match("1.e1")
      match("1.e1.", "1.e1")
      match("0.1e1")
      match(".1e1")
      match("0.1e1.", "0.1e1")

      match("1e+1")
      match("1e-1")
      match("1e0123")
      match("1e0.123", "1e0")
      match("1e0x123", "1e0")
      match("1E1")
      match("1E+1")
      match("1E-1")
      match("1E0123")
      match("1E0.123", "1E0")
      match("1E0x123", "1E0")
      match("1E0o123", "1E0")
      match("1E0b123", "1E0")

      match("e1", false)
      match("e+1", false)
      match("e-1", false)
      match("E1", false)
      match("E+1", false)
      match("E-1", false)

      match("-e1", false)
      match("-e+1", false)
      match("-e-1", false)
      match("-E1", false)
      match("-E+1", false)
      match("-E-1", false)

      match("0x1")
      match("0xa")
      match("0x015cF")
      match("0x1e1")
      match("0x1E1")
      match("0x1g1", "0x1")

      match("0X1")
      match("0Xa")
      match("0X015cF")
      match("0X1e1")
      match("0X1E1")
      match("0X1g1", "0X1")

      match("-0x1", false)
      match("-0xa", false)
      match("-0x015cF", false)
      match("-0x1e1", false)
      match("-0x1E1", false)
      match("-0x1g1", false)

      match("0x", "0")
      match("1x1", "1")
      match("0x1.", "0x1")
      match("0x1.1", "0x1")
      match("0.0x1", "0.0")
      match(".0x1", ".0")

      match("0o1")
      match("0oa", "0")
      match("0o01574")
      match("0o1e1", "0o1")
      match("0o1E1", "0o1")
      match("0o1g1", "0o1")

      match("0O1")
      match("0Oa", "0")
      match("0O01574")
      match("0O1e1", "0O1")
      match("0O1E1", "0O1")
      match("0O1g1", "0O1")

      match("-0o1", false)
      match("-0oa", false)
      match("-0o01574", false)
      match("-0o1e1", false)
      match("-0o1E1", false)
      match("-0o1g1", false)

      match("0o", "0")
      match("1o1", "1")
      match("0o1.", "0o1")
      match("0o1.1", "0o1")
      match("0.0o1", "0.0")
      match(".0o1", ".0")

      match("0b1")
      match("0ba", "0")
      match("0b01011")
      match("0b1e1", "0b1")
      match("0b1E1", "0b1")
      match("0b1g1", "0b1")

      match("0B1")
      match("0Ba", "0")
      match("0B01011")
      match("0B1e1", "0B1")
      match("0B1E1", "0B1")
      match("0B1g1", "0B1")

      match("-0b1", false)
      match("-0ba", false)
      match("-0b01011", false)
      match("-0b1e1", false)
      match("-0b1E1", false)
      match("-0b1g1", false)

      match("0b", "0")
      match("1b1", "1")
      match("0b1.", "0b1")
      match("0b1.1", "0b1")
      match("0.0b1", "0.0")
      match(".0b1", ".0")

    })


    token("name", function (match) {
      match("$")
      match("_")
      match("a")
      match("z")
      match("A")
      match("Z")
      match("å")
      match("π")
      match("0", false)
      match("0a", false)
      match("$0")
      match("_0")
      match("a0")
      match("z0")
      match("A0")
      match("Z0")
      match("å0")
      match("π0")
      match("a_56åπ")
      match("Iñtërnâtiônàlizætiøn☃💩") // The last character is Pile of poo.

      match("a\u00a0", "a")
      match("a\u1680", "a")
      match("a\u2000", "a")
      match("a\u2001", "a")
      match("a\u2002", "a")
      match("a\u2003", "a")
      match("a\u2004", "a")
      match("a\u2005", "a")
      match("a\u2006", "a")
      match("a\u2007", "a")
      match("a\u2008", "a")
      match("a\u2009", "a")
      match("a\u200a", "a")
      match("a\u2028", "a")
      match("a\u2029", "a")
      match("a\u202f", "a")
      match("a\u205f", "a")
      match("a\u3000", "a")

      match("\\u0000")
      match("\\u15cF")
      match("\\u15cG", false)
      match("\\u000", false)
      match("\\u00000")
      match("a\\u0000b")

      match("\\u{0}")
      match("\\u{01}")
      match("\\u{012}")
      match("\\u{0123}")
      match("\\u{01234}")
      match("\\u{012345}")
      match("\\u{0123456}")
      match("\\u{00000000000000a0}")
      match("\\u{15cF}")
      match("\\u{15cG}", false)
      match("a\\u{0000}b")

      match("\\x09", false)
    })


    token("punctuator", function (match) {
      match("+")
      match("++")
      match("+=")
      match("++=", "++")
      match("-")
      match("--")
      match("-=")
      match("--=", "--")
      match("*")
      match("**")
      match("*=")
      match("**=")
      match("/")
      match("//", false)
      match("/=")
      match("//=", false)
      match("%")
      match("%%", "%")
      match("%=")
      match("%%=", "%")
      match("&")
      match("&&")
      match("&=")
      match("&&=", "&&")
      match("|")
      match("||")
      match("|=")
      match("||=", "||")
      match("^")
      match("^^", "^")
      match("^=")
      match("^^=", "^")
      match("<")
      match("<<")
      match("<<<", "<<")
      match("<=")
      match("<<=")
      match(">")
      match(">>")
      match(">>>")
      match(">=")
      match(">>=")
      match(">>>=")
      match("!")
      match("!=")
      match("!==")
      match("!===", "!==")
      match("=")
      match("==")
      match("===")

      match("=>")
      match("==>", "==")
      match("=>>", "=>")

      match("...")
      match("..", ".")
      match(".")
      match("....", "...")

      match("?")
      match("~")
      match(".")
      match(",")
      match(":")
      match(";")
      match("[")
      match("]")
      match("(")
      match(")")
      match("{")
      match("}")

      match("/a/()", "/")
      match("/a/g()", "/")
      match("/a/ ()", "/")
      match("/a/g ()", "/")
      match("/a/{}", "/")
      match("/a/g{}", "/")
      match("/a/ {}", "/")
      match("/a/g {}", "/")

      match("/a/+b", "/")
      match("/a/ +b", "/")
      match("/a/++b", "/")
      match("/a/ ++b", "/")
      match("/a/-b", "/")
      match("/a/ -b", "/")
      match("/a/--b", "/")
      match("/a/ --b", "/")
      match("/a/!b", "/")
      match("/a/ !b", "/")
      match("/a/~b", "/")
      match("/a/ ~b", "/")

      match("/a/g+b", "/")
      match("/a/g +b", "/")
      match("/a/g+=b", "/")
      match("/a/g +=b", "/")
      match("/a/g++", "/")
      match("/a/g ++", "/")
      match("/a/g-b", "/")
      match("/a/g -b", "/")
      match("/a/g-=b", "/")
      match("/a/g -=b", "/")
      match("/a/g--", "/")
      match("/a/g --", "/")
      match("/a/g*b", "/")
      match("/a/g *b", "/")
      match("/a/g *=b", "/")
      match("/a/g/b", "/")
      match("/a/g /b", "/")
      match("/a/g /=b", "/")
      match("/a/g%b", "/")
      match("/a/g %b", "/")
      match("/a/g%=b", "/")
      match("/a/g %=b", "/")
      match("/a/g&b", "/")
      match("/a/g &b", "/")
      match("/a/g&=b", "/")
      match("/a/g &=b", "/")
      match("/a/g&&b", "/")
      match("/a/g &&b", "/")
      match("/a/g|b", "/")
      match("/a/g |b", "/")
      match("/a/g|=b", "/")
      match("/a/g |=b", "/")
      match("/a/g||b", "/")
      match("/a/g ||b", "/")
      match("/a/g^b", "/")
      match("/a/g ^b", "/")
      match("/a/g^=b", "/")
      match("/a/g ^=b", "/")
      match("/a/g<b", "/")
      match("/a/g <b", "/")
      match("/a/g<=b", "/")
      match("/a/g <=b", "/")
      match("/a/g<<b", "/")
      match("/a/g <<b", "/")
      match("/a/g<<=b", "/")
      match("/a/g <<=b", "/")
      match("/a/g>b", "/")
      match("/a/g >b", "/")
      match("/a/g>=b", "/")
      match("/a/g >=b", "/")
      match("/a/g>>b", "/")
      match("/a/g >>b", "/")
      match("/a/g>>=b", "/")
      match("/a/g >>=b", "/")
      match("/a/g>>>b", "/")
      match("/a/g >>>=b", "/")
      match("/a/g>>>=b", "/")
      match("/a/g >>>b", "/")
      match("/a/g!=b", "/")
      match("/a/g !=b", "/")
      match("/a/g!==b", "/")
      match("/a/g !==b", "/")
      match("/a/g=b", "/")
      match("/a/g =b", "/")
      match("/a/g==b", "/")
      match("/a/g ==b", "/")
      match("/a/g===b", "/")
      match("/a/g ===b", "/")

      match("/a/g?b:c", "/")
      match("/a/g ? b : c", "/")

      match("/a/''", "/")
      match("/a/ ''", "/")

      match('/a/""', "/")
      match('/a/ ""', "/")

      match("/a/g/b/", "/")
      match("/a/g /b/", "/")

      match("/a/0", "/")
      match("/a/ 0", "/")
      match("/a/0.1", "/")
      match("/a/ 0.1", "/")
      match("/a/.1", "/")
      match("/a/ .1", "/")

      match("/a/e", "/")
      match("/a/ e", "/")
      match("/a/_", "/")
      match("/a/ _", "/")
      match("/a/$", "/")
      match("/a/ $", "/")
      match("/a/é", "/")
      match("/a/ é", "/")
      match("/a/\\u0080", "/")
      match("/a/ \\u0080", "/")

      match("/a/ge", "/")
      match("/a/g_", "/")
      match("/a/g$", "/")
      match("/a/gé", "/")
      match("/a/g0", "/")
      match("/a/g\\u0080", "/")
    })


    token("invalid", function (match) {
      match("@")
      match("#")
      match("\\")
      match("\\xa9", "\\")
      match("\u0000")
      match("\u007F")
    })

    function Uint8ArrayToString(fileData) {
      var dataString = "";
      for (var i = 0; i < fileData.length; i++) {
        dataString += String.fromCharCode(fileData[i]);
      }
      return dataString
    }

    it("test_base64", 0, function () {
      globalThis.res.getMediaContent($r('app.media.base64').id).then(uint8 => {
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

        var actual = contents.match(jsTokens)
        expect(actual).assertDeepEquals(expected)
        expect(actual.join("")).assertEqual(contents)
      })
    })

    it("test_errors", 0, function () {
      globalThis.res.getMediaContent($r('app.media.errors').id).then(uint8 => {
        let contents = Uint8ArrayToString(uint8);
        let expected = [
          "var", " ", "multiLineString", " ", "=", " ", "'\\\nWhile I was writing along\\\nI suddenly forgot to", "\n",
          "add", " ", "a", " ", "backslash", " ", "@", " ", "the", " ", "end", " ", "of", " ", "a", " ", "line", "'", "\n\n",

          "var", " ", "unterminatedRegex", " ", "=", " ", "/", "3", "?", "2", ":", "1", "\n\n",

          "#", " ", "Oops", ",", " ", "forgot", " ", "that", " ", "this", " ", "isn’t", " ", "coffee", "-", "script", ".", "\n\n",

          "/* Let’s try a valid JavaScript comment instead\n\nvar string='Pity I forgot to close it, though'\n"
        ]

        var actual = contents.match(jsTokens)
        expect(actual).assertDeepEquals(expected)
        expect(actual.join("")).assertEqual(contents)
      })
    })

    it("test_regex", 0, function () {
      globalThis.res.getMediaContent($r('app.media.regex').id).then(uint8 => {
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

        var actual = contents.match(jsTokens)
        expect(actual).assertDeepEquals(expected)
        expect(actual.join("")).assertEqual(contents)
      })
    })
    it("test_division", 0, function () {
      globalThis.res.getMediaContent($r('app.media.division').id).then(uint8 => {
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
        var actual = contents.match(jsTokens)
        expect(actual).assertDeepEquals(expected)
        expect(actual.join("")).assertEqual(contents)
      })
    })
  })
}


