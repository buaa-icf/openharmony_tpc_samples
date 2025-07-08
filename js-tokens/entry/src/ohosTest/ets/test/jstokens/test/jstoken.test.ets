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

import jsTokens, { Token } from 'js-tokens'
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { getKeys } from './utils'

interface Options {
  closed?: boolean
}

function match(
  type: string,
  preceding: string[],
  string: string,
  expected: string | string[] | boolean | Options = string,
  extra: Options = {}
): void {
  if (typeof expected === 'object' && !Array.isArray(expected)) {
    extra = expected;
    expected = string;
  }

  const titleParts: (string | undefined)[] = [
    printInvisibles(string),
    (expected === string) ? undefined : JSON.stringify(expected)
  ];
  const title: string = (titleParts.filter(Boolean) as string[]).join(" → ");

  it(title, 0, () => {
    const fullInput: string = preceding.join("") + string;
    const tokens = Array.from(
      jsTokens(fullInput, { jsx: type.startsWith("JSX") })
    );

    expect(tokens.length).assertLargerOrEqual(preceding.length + 1);
    expect(
      tokens.slice(0, preceding.length).map((token) => token.value)
    ).assertDeepEquals(preceding);

    const token = tokens[preceding.length];

    if (expected === false) {
      expect(token.type).not().assertEqual(type);
    } else {
      if (Array.isArray(expected)) {
        expect(tokens.map((token2) => token2.value)).assertDeepEquals(
          preceding.concat(expected as string[])
        );
      } else {
        expect(token.type).assertEqual(type);
        expect(token.value).assertEqual(expected as string);

        if (expected === string) {
          expect(tokens.length).assertEqual(preceding.length + 1);
        }

        for (let i of getKeys(token)) {
          if (i == "closed") {
            const closed = extra?.closed ?? true;
            expect(token[i]).assertEqual(closed);
          }
        }
      }
    }
  });
}

const escapeTable: Record<string, string> = {
  "\b": "\\b",
  "\f": "\\f",
  "\n": "\\n",
  "\r": "\\r",
  "\t": "\\t",
  "\v": "\\v",
  " ": "\\x20",
};

function printInvisibles(string: string): string {
  if (string === "") {
    return "(empty string)";
  }

  if (new RegExp('\\S').test(string)) {
    return string
      .replace(new RegExp('\\r', 'g'), "␍")
      .replace(new RegExp('\\n', 'g'), "␊")
      .replace(
        new RegExp('[\\x00-\\x1f]', 'g'),
        (char: string) =>
        `\\x${char.charCodeAt(0).toString(16).padStart(2, "0").toUpperCase()}`
      );
  }

  return string
    .split("")
    .map(
      (char: string) =>
      escapeTable[char] ||
        `\\u${char.charCodeAt(0).toString(16).padStart(4, "0").toUpperCase()}`
    )
    .join("");
}

export default function JSTokenTest() {
  describe('JSTokenTest', () => {
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

    it("is_a_function", 0, () => {
      expect(typeof jsTokens).assertEqual("function");
    })

    it("empty_string", 0, () => {
      expect(Array.from(jsTokens(""))).assertDeepEquals([]);
    })

    it("succeeds_for_any_single_character", 0, () => {
      for (let c = 0; c <= 0xffff; c++) {
        expect(() => jsTokens(String.fromCharCode(c))).not().assertThrowError();
      }
    });

    it("Invalid", 0, () => {
      let type: string = "Invalid";
      match(type, [], "@");
      match(type, [], "#");
      match(type, [], "\\");
      match(type, [], "\\xa9", "\\");
      match(type, [], "\u0000");
      match(type, [], "\u007F");
      match(type, [], "☃");
      match(type, [], "💩");
      match(type, [], "\ud83d"); // First half of 💩
    })

    it("WhiteSpace", 0, () => {
      let type: string = "WhiteSpace";
      match(type, [], " ");
      match(type, [], "    ");
      match(type, [], " a", " ");
      match(type, [], "\t");
      match(type, [], "\t\t\t");
      match(type, [], "\ta", "\t");
      match(type, [], "\f");
      match(type, [], "\v");

      match(type, [], "\u00a0");
      match(type, [], "\u1680");
      match(type, [], "\u2000");
      match(type, [], "\u2001");
      match(type, [], "\u2002");
      match(type, [], "\u2003");
      match(type, [], "\u2004");
      match(type, [], "\u2005");
      match(type, [], "\u2006");
      match(type, [], "\u2007");
      match(type, [], "\u2008");
      match(type, [], "\u2009");
      match(type, [], "\u200a");
      match(type, [], "\u202f");
      match(type, [], "\u205f");
      match(type, [], "\u3000");
    });

    it("LineTerminatorSequence", 0, () => {
      let type: string = "LineTerminatorSequence";
      match(type, [], "\n");
      match(type, [], "\n\n\n", ["\n", "\n", "\n"]);
      match(type, [], "\na", "\n");
      match(type, [], "\r");
      match(type, [], "\r\r\r", ["\r", "\r", "\r"]);
      match(type, [], "\ra", "\r");
      match(type, [], "\r\n");
      match(type, [], "\r\n\r\n\r\n", ["\r\n", "\r\n", "\r\n"]);
      match(type, [], "\r\na", "\r\n");
      match(type, [], "\u2028");
      match(type, [], "\u2029");
      match(type, [], " \t\n\r \r\n", [" \t", "\n", "\r", " ", "\r\n"]);
      match(type, [], " \t\n\r \r\n-1", [" \t", "\n", "\r", " ", "\r\n", "-", "1"]);
    });

    it("SingleLineComment", 0, () => {
      let type: string = "SingleLineComment";
      match(type, [], "//");
      match(type, [], "//comment");
      match(type, [], "// comment");
      match(type, [], "//comment ");
      match(type, [], "///");
      match(type, [], "//**//");
      match(type, [], "//comment\n", "//comment");
      match(type, [], "//comment\r", "//comment");
      match(type, [], "//comment\u2028", "//comment");
      match(type, [], "//comment\u2029", "//comment");
      match(type, [], "//comment\r\n", "//comment");
      match(type, [], "//comment \n", "//comment ");
      match(type, [], "//comment\t\n", "//comment\t");
    });

    it("MultiLineComment", 0, () => {
      let type: string = "MultiLineComment";
      match(type, [], "/**/");
      match(type, [], "/*comment*/");
      match(type, [], "/* comment */");
      match(type, [], "/***/");
      match(type, [], "/*/*/");
      match(type, [], "/*\n\r\u2028\u2029 \r\n*/");

      match(type, [], "/*", {
        closed: false
      });
      match(type, [], "/*/", {
        closed: false
      });
      match(type, [], "/*unclosed", {
        closed: false
      });
      match(type, [], "/*unclosed\nnew Line(this == code ? true : false)", {
        closed: false,
      });
    });

    it("StringLiteral", 0, () => {
      let type: string = "StringLiteral";
      match(type, [], "''");
      match(type, [], '""');
      match(type, [], "'string'");
      match(type, [], '"string"');
      match(type, [], "'\\''");
      match(type, [], '"\\""');
      match(type, [], "'\\\\''", "'\\\\'");
      match(type, [], '"\\\\""', '"\\\\"');
      match(type, [], "'\\\\\\''");
      match(type, [], '"\\\\\\""');
      match(type, [], "'\\u05aF'");
      match(type, [], '"\\u05aF"');
      match(type, [], "'invalid escape sequence is OK: \\u'");
      match(type, [], '"invalid escape sequence is OK: \\u"');
      match(type, [], "'\\\n'");
      match(type, [], '"\\\n"');
      match(type, [], "'\\\r'");
      match(type, [], '"\\\r"');
      match(type, [], "'\u2028'");
      match(type, [], '"\u2028"');
      match(type, [], "'\u2029'");
      match(type, [], '"\u2029"');
      match(type, [], "'\\\u2028'");
      match(type, [], '"\\\u2028"');
      match(type, [], "'\\\u2029'");
      match(type, [], '"\\\u2029"');
      match(type, [], "'\\\r\n'");
      match(type, [], '"\\\r\n"');
      match(type, [], "'string'code'another string'", "'string'");
      match(type, [], '"string"code"another string"', '"string"');
      match(type, [], "'\"'");
      match(type, [], "'`'");
      match(type, [], '"\'"');
      match(type, [], '"`"');

      match(type, [], "'", {
        closed: false
      });
      match(type, [], '"', {
        closed: false
      });
      match(type, [], "'unclosed", {
        closed: false
      });
      match(type, [], '"unclosed', {
        closed: false
      });
      match(type, [], "'\n", "'", {
        closed: false
      });
      match(type, [], '"\n', '"', {
        closed: false
      });
      match(type, [], "'\r", "'", {
        closed: false
      });
      match(type, [], '"\r', '"', {
        closed: false
      });
      match(type, [], "'\u2028", {
        closed: false
      });
      match(type, [], '"\u2028', {
        closed: false
      });
      match(type, [], "'\u2029", {
        closed: false
      });
      match(type, [], '"\u2029', {
        closed: false
      });
      match(type, [], "'\r\n", "'", {
        closed: false
      });
      match(type, [], '"\r\n', '"', {
        closed: false
      });
      match(type, [], "'\\\n", {
        closed: false
      });
      match(type, [], '"\\\n', {
        closed: false
      });
      match(type, [], "'\\\r", {
        closed: false
      });
      match(type, [], '"\\\r', {
        closed: false
      });
      match(type, [], "'\\\u2028", {
        closed: false
      });
      match(type, [], '"\\\u2028', {
        closed: false
      });
      match(type, [], "'\\\u2029", {
        closed: false
      });
      match(type, [], '"\\\u2029', {
        closed: false
      });
      match(type, [], "'\\\r\n", {
        closed: false
      });
      match(type, [], '"\\\r\n', {
        closed: false
      });

      match(type, [], "'${}'");
      match(type, [], '"${}"');
      match(type, [], "'${a}'");
      match(type, [], '"${a}"');
      match(type, [], "'a${b}c'");
      match(type, [], '"a${b}c"');
      match(type, [], "'${'a'}'", "'${'");
      match(type, [], '"${"a"}"', '"${"');
    });

    it("NoSubstitutionTemplate", 0, () => {
      let type: string = "NoSubstitutionTemplate";
      match(type, [], "``");
      match(type, [], "`string`");
      match(type, [], "`\\``");
      match(type, [], "`\\\\``", "`\\\\`");
      match(type, [], "`\\\\\\``");
      match(type, [], "`\\u05aF`");
      match(type, [], "`invalid escape sequence is OK: \\u`");
      match(type, [], "`\\\n`");
      match(type, [], "`\\\r`");
      match(type, [], "`\u2028`");
      match(type, [], "`\u2029`");
      match(type, [], "`\\\u2028`");
      match(type, [], "`\\\u2029`");
      match(type, [], "`\\\r\n`");
      match(type, [], "`string`code`another string`", "`string`");
      match(type, [], "`'`");
      match(type, [], '`"`');

      match(type, [], "`", {
        closed: false
      });
      match(type, [], "`unclosed", {
        closed: false
      });
      match(type, [], "`\n", {
        closed: false
      });
      match(type, [], "`\r", {
        closed: false
      });
      match(type, [], "`\u2028", {
        closed: false
      });
      match(type, [], "`\u2029", {
        closed: false
      });
      match(type, [], "`\r\n", {
        closed: false
      });
      match(type, [], "`\\\n", {
        closed: false
      });
      match(type, [], "`\\\r", {
        closed: false
      });
      match(type, [], "`\\\u2028", {
        closed: false
      });
      match(type, [], "`\\\u2029", {
        closed: false
      });
      match(type, [], "`\\\r\n", {
        closed: false
      });

      match(type, [], "`${}`", ["`${", "}`"]);
      match(type, [], "`${a}`", ["`${", "a", "}`"]);
      match(type, [], "`a${b}c`", ["`a${", "b", "}c`"]);
      match(type, [], "`${`a`}`", ["`${", "`a`", "}`"]);
      match(type, [], "`${`${a}`}`", ["`${", "`${", "a", "}`", "}`"]);
      match(type, [], "`${fn({a: b})}`", [
        "`${",
        "fn",
        "(",
        "{",
        "a",
        ":",
        " ",
        "b",
        "}",
        ")",
        "}`",
      ]);
      match(type, [], "`${fn({a: '{'})}`", [
        "`${",
        "fn",
        "(",
        "{",
        "a",
        ":",
        " ",
        "'{'",
        "}",
        ")",
        "}`",
      ]);
      match(type, [], "`\\${{{}}}a`");
      match(type, [], "`${}", ["`${", "}"]);
    });

    it("NumericLiteral", 0, () => {
      let type: string = "NumericLiteral";
      match(type, [], "0");
      match(type, [], "0n");
      match(type, [], "000");
      match(type, [], "000n", "000");
      match(type, [], "1000");
      match(type, [], "1000n");
      match(type, [], "0001");
      match(type, [], "0008");
      match(type, [], "00090");
      match(type, [], "1");
      match(type, [], "1n");
      match(type, [], "1.");
      match(type, [], "0.");
      match(type, [], "00.", "00");
      match(type, [], "07.", "07");
      match(type, [], "08.", "08.");
      match(type, [], "09.", "09.");
      match(type, [], "00.0", "00");
      match(type, [], "07.0", "07");
      match(type, [], "08.0", "08.0");
      match(type, [], "09.5", "09.5");
      match(type, [], "019.5", "019.5");
      match(type, [], "1n.", "1n");
      match(type, [], "1.n", "1.");
      match(type, [], "1..", "1.");
      match(type, [], "0.1");
      match(type, [], "0.1n", "0.1");
      match(type, [], ".1");
      match(type, [], ".1n", ".1");
      match(type, [], "0.1.", "0.1");

      match(type, [], "-1", false);
      match(type, [], "-1.", false);
      match(type, [], "-1..", false);
      match(type, [], "-0.1", false);
      match(type, [], "-.1", false);
      match(type, [], "-0.1.", false);
      match(type, [], "-", false);

      match(type, [], "1e1");
      match(type, [], "1ne1", "1n");
      match(type, [], "1e1n", "1e1");
      match(type, [], "1.e1");
      match(type, [], "1.e1.", "1.e1");
      match(type, [], "0.1e1");
      match(type, [], ".1e1");
      match(type, [], "0.1e1.", "0.1e1");

      match(type, [], "1e+1");
      match(type, [], "1e-1");
      match(type, [], "1e0123");
      match(type, [], "1e0.123", "1e0");
      match(type, [], "1e0x123", "1e0");
      match(type, [], "1E1");
      match(type, [], "1E+1");
      match(type, [], "1E-1");
      match(type, [], "1E0123");
      match(type, [], "1E0.123", "1E0");
      match(type, [], "1E0x123", "1E0");
      match(type, [], "1E0o123", "1E0");
      match(type, [], "1E0b123", "1E0");
      match(type, [], "08e1");
      match(type, [], "07e1", "07");
      match(type, [], "00e1", "00");

      match(type, [], "e1", false);
      match(type, [], "e+1", false);
      match(type, [], "e-1", false);
      match(type, [], "E1", false);
      match(type, [], "E+1", false);
      match(type, [], "E-1", false);

      match(type, [], "-e1", false);
      match(type, [], "-e+1", false);
      match(type, [], "-e-1", false);
      match(type, [], "-E1", false);
      match(type, [], "-E+1", false);
      match(type, [], "-E-1", false);

      match(type, [], "0x1");
      match(type, [], "0x1n");
      match(type, [], "0xa");
      match(type, [], "0xan");
      match(type, [], "0x015cF");
      match(type, [], "0x015cFn");
      match(type, [], "0x1e1");
      match(type, [], "0x1e1n");
      match(type, [], "0x1E1");
      match(type, [], "0x1E1n");
      match(type, [], "0x1g1", "0x1");
      match(type, [], "0x1g1n", "0x1");

      match(type, [], "0X1");
      match(type, [], "0X1n");
      match(type, [], "0Xa");
      match(type, [], "0Xan");
      match(type, [], "0X015cF");
      match(type, [], "0X015cFn");
      match(type, [], "0X1e1");
      match(type, [], "0X1e1n");
      match(type, [], "0X1E1");
      match(type, [], "0X1E1n");
      match(type, [], "0X1g1", "0X1");
      match(type, [], "0X1g1n", "0X1");

      match(type, [], "-0x1", false);
      match(type, [], "-0xa", false);
      match(type, [], "-0x015cF", false);
      match(type, [], "-0x1e1", false);
      match(type, [], "-0x1E1", false);
      match(type, [], "-0x1g1", false);

      match(type, [], "0x", "0");
      match(type, [], "1x1", "1");
      match(type, [], "0x1.", "0x1");
      match(type, [], "0x1.1", "0x1");
      match(type, [], "0.0x1", "0.0");
      match(type, [], ".0x1", ".0");

      match(type, [], "0o1");
      match(type, [], "0o1n");
      match(type, [], "0oa", "0");
      match(type, [], "0oan", "0");
      match(type, [], "0o01574");
      match(type, [], "0o01574n");
      match(type, [], "0o1e1", "0o1");
      match(type, [], "0o1e1n", "0o1");
      match(type, [], "0o1E1", "0o1");
      match(type, [], "0o1E1n", "0o1");
      match(type, [], "0o1g1", "0o1");
      match(type, [], "0o1g1n", "0o1");

      match(type, [], "0O1");
      match(type, [], "0O1n");
      match(type, [], "0Oa", "0");
      match(type, [], "0Oan", "0");
      match(type, [], "0O01574");
      match(type, [], "0O01574n");
      match(type, [], "0O1e1", "0O1");
      match(type, [], "0O1e1n", "0O1");
      match(type, [], "0O1E1", "0O1");
      match(type, [], "0O1E1n", "0O1");
      match(type, [], "0O1g1", "0O1");
      match(type, [], "0O1g1n", "0O1");

      match(type, [], "-0o1", false);
      match(type, [], "-0oa", false);
      match(type, [], "-0o01574", false);
      match(type, [], "-0o1e1", false);
      match(type, [], "-0o1E1", false);
      match(type, [], "-0o1g1", false);

      match(type, [], "0o", "0");
      match(type, [], "1o1", "1");
      match(type, [], "0o1.", "0o1");
      match(type, [], "0o1.1", "0o1");
      match(type, [], "0.0o1", "0.0");
      match(type, [], ".0o1", ".0");

      match(type, [], "0b1");
      match(type, [], "0b1n");
      match(type, [], "0ba", "0");
      match(type, [], "0ban", "0");
      match(type, [], "0b01011");
      match(type, [], "0b01011n");
      match(type, [], "0b1e1", "0b1");
      match(type, [], "0b1e1n", "0b1");
      match(type, [], "0b1E1", "0b1");
      match(type, [], "0b1E1n", "0b1");
      match(type, [], "0b1g1", "0b1");
      match(type, [], "0b1g1n", "0b1");

      match(type, [], "0B1");
      match(type, [], "0B1n");
      match(type, [], "0Ba", "0");
      match(type, [], "0Ban", "0");
      match(type, [], "0B01011");
      match(type, [], "0B01011n");
      match(type, [], "0B1e1", "0B1");
      match(type, [], "0B1e1n", "0B1");
      match(type, [], "0B1E1", "0B1");
      match(type, [], "0B1E1n", "0B1");
      match(type, [], "0B1g1", "0B1");
      match(type, [], "0B1g1m", "0B1");

      match(type, [], "-0b1", false);
      match(type, [], "-0ba", false);
      match(type, [], "-0b01011", false);
      match(type, [], "-0b1e1", false);
      match(type, [], "-0b1E1", false);
      match(type, [], "-0b1g1", false);

      match(type, [], "0b", "0");
      match(type, [], "1b1", "1");
      match(type, [], "0b1.", "0b1");
      match(type, [], "0b1.1", "0b1");
      match(type, [], "0.0b1", "0.0");
      match(type, [], ".0b1", ".0");

      match(type, [], "_0", false);
      match(type, [], "_0n", false);
      match(type, [], "_.0", false);
      match(type, [], "_0.0", false);
      match(type, [], "_0e0", false);
      match(type, [], "_0x0", false);
      match(type, [], "_0x0n", false);
      match(type, [], "_0o0", false);
      match(type, [], "_0o0n", false);
      match(type, [], "_0b0", false);
      match(type, [], "_0b0n", false);

      match(type, [], "0_", "0");
      match(type, [], "0n_", "0n");
      match(type, [], ".0_", ".0");
      match(type, [], "0.0_", "0.0");
      match(type, [], "0e0_", "0e0");
      match(type, [], "0x0_", "0x0");
      match(type, [], "0o0_", "0o0");
      match(type, [], "0b0_", "0b0");

      match(type, [], "0_n", "0");
      match(type, [], "1_n", "1");
      match(type, [], "0_.0", "0");
      match(type, [], "1_.0", "1");
      match(type, [], "0_e0", "0");
      match(type, [], "1_e0", "1");
      match(type, [], "0_x0", "0");
      match(type, [], "0_x0n", "0");
      match(type, [], "0_o0", "0");
      match(type, [], "0_o0n", "0");
      match(type, [], "0_b0", "0");
      match(type, [], "0_b0n", "0");

      match(type, [], "0._0", "0.");
      match(type, [], "0e_0", "0");
      match(type, [], "0x_0", "0");
      match(type, [], "0x_0n", "0");
      match(type, [], "0o_0", "0");
      match(type, [], "0o_0n", "0");
      match(type, [], "0b_0", "0");
      match(type, [], "0b_0n", "0");

      match(type, [], "0_0", "0");
      match(type, [], "0_0n", "0");
      match(type, [], "1_0");
      match(type, [], "1_0n");
      match(type, [], ".0_0");
      match(type, [], "0.0_0");
      match(type, [], "0e0_0");
      match(type, [], "0x0_0");
      match(type, [], "0x0_0n");
      match(type, [], "0o0_0");
      match(type, [], "0o0_0n");
      match(type, [], "0b0_0");
      match(type, [], "0b0_0n");

      match(type, [], "1__0", "1");
      match(type, [], "1__0n", "1");
      match(type, [], "1__0.0", "1");
      match(type, [], ".0__0", ".0");
      match(type, [], "0.0__0", "0.0");
      match(type, [], "1__0e0", "1");
      match(type, [], "0e0__0", "0e0");
      match(type, [], "0x0__0", "0x0");
      match(type, [], "0x0__0n", "0x0");
      match(type, [], "0o0__0", "0o0");
      match(type, [], "0o0__0n", "0o0");
      match(type, [], "0b0__0", "0b0");
      match(type, [], "0b0__0n", "0b0");

      match(type, [], "0x0_fg", "0x0_f");
      match(type, [], "0o0_78", "0o0_7");
      match(type, [], "0b0_12", "0b0_1");

      match(type, [], "1_2_3_4_5_6_7_8_9_0");
      match(type, [], "1_2_3_4_5_6_7_8_9_0n");
      match(type, [], ".0_1_2_3_4_5_6_7_8_9");
      match(type, [], "1_2_3_4_5_6_7_8_9_0.0_1_2_3_4_5_6_7_8_9");
      match(type, [], "1_2_3_4_5_6_7_8_9_0.0_1_2_3_4_5_6_7_8_9e+0_1_2_3_4_5_6_7_8_9");
      match(type, [], "0x0_1_2_3_4_5_6_7_8_9_a_b_c_d_e_f");
      match(type, [], "0X0_1_2_3_4_5_6_7_8_9_a_b_c_d_e_f");
      match(type, [], "0x0_1_2_3_4_5_6_7_8_9_a_b_c_d_e_fn");
      match(type, [], "0X0_1_2_3_4_5_6_7_8_9_a_b_c_d_e_fn");
      match(type, [], "0o0_1_2_3_4_5_6_7");
      match(type, [], "0O0_1_2_3_4_5_6_7");
      match(type, [], "0o0_1_2_3_4_5_6_7n");
      match(type, [], "0O0_1_2_3_4_5_6_7n");
      match(type, [], "0b0_1_1_0");
      match(type, [], "0B0_1_1_0");
      match(type, [], "0b0_1_1_0n");
      match(type, [], "0B0_1_1_0n");

      match(type, [], "1_335_000");
      match(type, [], "0b111_111_000");
      match(type, [], "0b1111_10101011_11110000_00001101");
      match(type, [], "0xFAB_F00D");
      match(type, [], "9.109_383_56e-31");
      match(type, [], "1e1_2");
    });

    it("IdentifierName", 0, () => {
      let type: string = "IdentifierName";
      match(type, [], "$");
      match(type, [], "_");
      match(type, [], "a");
      match(type, [], "z");
      match(type, [], "A");
      match(type, [], "Z");
      match(type, [], "å");
      match(type, [], "π");
      match(type, [], "0", false);
      match(type, [], "0a", false);
      match(type, [], "$0");
      match(type, [], "_0");
      match(type, [], "a0");
      match(type, [], "z0");
      match(type, [], "A0");
      match(type, [], "Z0");
      match(type, [], "å0");
      match(type, [], "π0");
      match(type, [], "a_56åπ");
      match(type, [], "℮");
      match(type, [], "℘");
      match(type, [], "゛");
      match(type, [], "゜");
      match(type, [], "℮℘");
      match(type, [], "·", false);
      match(type, [], "℮·");
      match(type, [], "·", false);
      match(type, [], "℮·");
      match(type, [], "᧚", false);
      match(type, [], "℮᧚");
      match(type, [], "Iñtërnâtiônàlizætiøn");

      match(type, [], "a\u00a0", "a");
      match(type, [], "a\u1680", "a");
      match(type, [], "a\u2000", "a");
      match(type, [], "a\u2001", "a");
      match(type, [], "a\u2002", "a");
      match(type, [], "a\u2003", "a");
      match(type, [], "a\u2004", "a");
      match(type, [], "a\u2005", "a");
      match(type, [], "a\u2006", "a");
      match(type, [], "a\u2007", "a");
      match(type, [], "a\u2008", "a");
      match(type, [], "a\u2009", "a");
      match(type, [], "a\u200a", "a");
      match(type, [], "a\u2028", "a");
      match(type, [], "a\u2029", "a");
      match(type, [], "a\u202f", "a");
      match(type, [], "a\u205f", "a");
      match(type, [], "a\u3000", "a");

      match(type, [], "\\u0000");
      match(type, [], "\\u15cF");
      match(type, [], "\\u15cG", false);
      match(type, [], "\\u000", false);
      match(type, [], "\\u00000");
      match(type, [], "a\\u0000b");

      match(type, [], "\\u{0}");
      match(type, [], "\\u{01}");
      match(type, [], "\\u{012}");
      match(type, [], "\\u{0123}");
      match(type, [], "\\u{01234}");
      match(type, [], "\\u{012345}");
      match(type, [], "\\u{0123456}");
      match(type, [], "\\u{00000000000000a0}");
      match(type, [], "\\u{15cF}");
      match(type, [], "\\u{15cG}", false);
      match(type, [], "a\\u{0000}b");

      match(type, [], "\\x09", false);
    });

    it("PrivateIdentifier", 0, () => {
      let type: string = "PrivateIdentifier";
      match(type, [], "#", false);
      match(type, [], "#$");
      match(type, [], "#_");
      match(type, [], "#a");
      match(type, [], "#z");
      match(type, [], "#A");
      match(type, [], "#Z");
      match(type, [], "#å");
      match(type, [], "#π");
      match(type, [], "#0", false);
      match(type, [], "#0a", false);
      match(type, [], "#$0");
      match(type, [], "#_0");
      match(type, [], "#a0");
      match(type, [], "#z0");
      match(type, [], "#A0");
      match(type, [], "#Z0");
      match(type, [], "#å0");
      match(type, [], "#π0");
      match(type, [], "#a_56åπ");
      match(type, [], "#℮");
      match(type, [], "#℘");
      match(type, [], "#゛");
      match(type, [], "#゜");
      match(type, [], "#℮℘");
      match(type, [], "#·", false);
      match(type, [], "#℮·");
      match(type, [], "#·", false);
      match(type, [], "#℮·");
      match(type, [], "#᧚", false);
      match(type, [], "#℮᧚");
      match(type, [], "#Iñtërnâtiônàlizætiøn");

      match(type, [], "#a\u00a0", "#a");
      match(type, [], "#a\u1680", "#a");
      match(type, [], "#a\u2000", "#a");
      match(type, [], "#a\u2001", "#a");
      match(type, [], "#a\u2002", "#a");
      match(type, [], "#a\u2003", "#a");
      match(type, [], "#a\u2004", "#a");
      match(type, [], "#a\u2005", "#a");
      match(type, [], "#a\u2006", "#a");
      match(type, [], "#a\u2007", "#a");
      match(type, [], "#a\u2008", "#a");
      match(type, [], "#a\u2009", "#a");
      match(type, [], "#a\u200a", "#a");
      match(type, [], "#a\u2028", "#a");
      match(type, [], "#a\u2029", "#a");
      match(type, [], "#a\u202f", "#a");
      match(type, [], "#a\u205f", "#a");
      match(type, [], "#a\u3000", "#a");

      match(type, [], "#\\u0000");
      match(type, [], "#\\u15cF");
      match(type, [], "#\\u15cG", false);
      match(type, [], "#\\u000", false);
      match(type, [], "#\\u00000");
      match(type, [], "#a\\u0000b");

      match(type, [], "#\\u{0}");
      match(type, [], "#\\u{01}");
      match(type, [], "#\\u{012}");
      match(type, [], "#\\u{0123}");
      match(type, [], "#\\u{01234}");
      match(type, [], "#\\u{012345}");
      match(type, [], "#\\u{0123456}");
      match(type, [], "#\\u{00000000000000a0}");
      match(type, [], "#\\u{15cF}");
      match(type, [], "#\\u{15cG}", false);
      match(type, [], "#a\\u{0000}b");

      match(type, [], "#\\x09", false);
    });

    it("RegularExpressionLiteral", 0, () => {
      let type: string = "RegularExpressionLiteral";
      match(type, [], "//", false);
      match(type, [], "/a/");
      match(type, [], "/\\//");
      match(type, [], "/\\\\//", "/\\\\/");
      match(type, [], "/\\\\\\//");
      match(type, [], "/[/]/");
      match(type, [], "/[\\]]/");
      match(type, [], "/[\\]/]/");
      match(type, [], "/[\\\\]/]/", "/[\\\\]/");
      match(type, [], "/[\\\\\\]/]/");
      match(type, [], "/abc]xyz/", "/abc]xyz/");
      match(type, [], "/\\u05aF/");
      match(type, [], "/invalid escape sequence is OK: \\u/");
      match(type, [], "/?foo/");
      match(type, [], "/*foo/", false);

      match(type, [], "/a/d");
      match(type, [], "/a/g");
      match(type, [], "/a/m");
      match(type, [], "/a/i");
      match(type, [], "/a/y");
      match(type, [], "/a/u");
      match(type, [], "/a/s");
      match(type, [], "/a/dgmiyus");
      match(type, [], "/a/myg");
      match(type, [], "/a/e");
      match(type, [], "/a/E");
      match(type, [], "/a/invalidFlags");
      match(type, [], "/a/f00", "/a/f00");

      match(type, [], "/\n/", "/", {
        closed: false
      });
      match(type, [], "/\r/", "/", {
        closed: false
      });
      match(type, [], "/\u2028/", "/", {
        closed: false
      });
      match(type, [], "/\u2029/", "/", {
        closed: false
      });
      match(type, [], "/\r\n/", "/", {
        closed: false
      });
      match(type, [], "/\\\n/", "/\\", {
        closed: false
      });
      match(type, [], "/\\\r/", "/\\", {
        closed: false
      });
      match(type, [], "/\\\u2028/", "/\\", {
        closed: false
      });
      match(type, [], "/\\\u2029/", "/\\", {
        closed: false
      });
      match(type, [], "/\\\r\n/", "/\\", {
        closed: false
      });
      match(type, [], "/[\n]/", "/[", {
        closed: false
      });
      match(type, [], "/[\r]/", "/[", {
        closed: false
      });
      match(type, [], "/[\u2028]/", "/[", {
        closed: false
      });
      match(type, [], "/[\u2029]/", "/[", {
        closed: false
      });
      match(type, [], "/[\r\n]/", "/[", {
        closed: false
      });
      match(type, [], "/[\\\n]/", "/[\\", {
        closed: false
      });
      match(type, [], "/[\\\r]/", "/[\\", {
        closed: false
      });
      match(type, [], "/[\\\u2028]/", "/[\\", {
        closed: false
      });
      match(type, [], "/[\\\u2029]/", "/[\\", {
        closed: false
      });
      match(type, [], "/[\\\r\n]/", "/[\\", {
        closed: false
      });

      match(type, [], "/a/", "/a/");
      match(type, [], "/a/g", "/a/g");
      match(type, [], "/a///", "/a/");
      match(type, [], "/a/g//", "/a/g");
      match(type, [], "/a/ //", "/a/");
      match(type, [], "/a/g //", "/a/g");
      match(type, [], "/a//**/", "/a/");
      match(type, [], "/a/g/**/", "/a/g");
      match(type, [], "/a/ /**/", "/a/");
      match(type, [], "/a/g /**/", "/a/g");
      match(type, [], "/a/**/", ["/a/", "**", "/"]);

      match(type, [], "/a/g0", "/a/g0");
      match(type, [], "/a/g0.1", "/a/g0");
      match(type, [], "/a/g.1", "/a/g");
      match(type, [], "/a/g0x1", "/a/g0x1");

      match(type, [], "/a/ge", "/a/ge");
      match(type, [], "/a/g_", "/a/g_");
      match(type, [], "/a/g$", "/a/g$");
      match(type, [], "/a/gé", "/a/gé");

      match(type, [], "{}/a/g", ["{", "}", "/a/g"]);
      match(type, [], "function x(){}\n/a/g", [
        "function",
        " ",
        "x",
        "(",
        ")",
        "{",
        "}",
        "\n",
        "/a/g",
      ]);
    });

    it("Punctuator", 0, () => {
      let type: string = "Punctuator";
      match(type, [], "+");
      match(type, [], "++");
      match(type, [], "+=");
      match(type, [], "++=", "++");
      match(type, [], "-");
      match(type, [], "--");
      match(type, [], "-=");
      match(type, [], "--=", "--");
      match(type, [], "*");
      match(type, [], "**");
      match(type, [], "*=");
      match(type, [], "**=");
      match(type, [], "1/2", ["1", "/", "2"]);
      match(type, [], "//", false);
      match(type, [], "x/=2", ["x", "/=", "2"]);
      match(type, [], "//=", false);
      match(type, [], "%");
      match(type, [], "%%", "%");
      match(type, [], "%=");
      match(type, [], "%%=", "%");
      match(type, [], "&");
      match(type, [], "&&");
      match(type, [], "&=");
      match(type, [], "&&=");
      match(type, [], "|");
      match(type, [], "||");
      match(type, [], "|=");
      match(type, [], "||=");
      match(type, [], "??");
      match(type, [], "??=");
      match(type, [], "^");
      match(type, [], "^^", "^");
      match(type, [], "^=");
      match(type, [], "^^=", "^");
      match(type, [], "<");
      match(type, [], "<<");
      match(type, [], "<<<", "<<");
      match(type, [], "<=");
      match(type, [], "<<=");
      match(type, [], ">");
      match(type, [], ">>");
      match(type, [], ">>>");
      match(type, [], ">=");
      match(type, [], ">>=");
      match(type, [], ">>>=");
      match(type, [], "!");
      match(type, [], "!=");
      match(type, [], "!==");
      match(type, [], "!===", "!==");
      match(type, [], "=");
      match(type, [], "==");
      match(type, [], "===");

      match(type, [], "=>");
      match(type, [], "==>", "==");
      match(type, [], "=>>", "=>");

      match(type, [], "...");
      match(type, [], "..", ".");
      match(type, [], ".");
      match(type, [], "....", "...");

      match(type, [], "?.");
      match(type, [], "x?.a", ["x", "?.", "a"]);
      match(type, [], "x?.0:1", ["x", "?", ".0", ":", "1"]);

      match(type, [], "?");
      match(type, [], "~");
      match(type, [], ".");
      match(type, [], ",");
      match(type, [], ":");
      match(type, [], ";");
      match(type, [], "[");
      match(type, [], "]");
      match(type, [], "(");
      match(type, [], ")");
      match(type, [], "{");
      match(type, [], "}");

      match(type, [], "+{}/a/g", ["+", "{", "}", "/", "a", "/", "g"]);
      match(type, [], "-{}/a/g", ["-", "{", "}", "/", "a", "/", "g"]);
      match(type, [], "++{}/a/g", ["++", "{", "}", "/", "a", "/", "g"]);
      match(type, [], "--{}/a/g", ["--", "{", "}", "/", "a", "/", "g"]);
      match(type, [], "+{}++/a/g", ["+", "{", "}", "++", "/", "a", "/", "g"]);
      match(type, [], "+{}--/a/g", ["+", "{", "}", "--", "/", "a", "/", "g"]);
    });
  })
}