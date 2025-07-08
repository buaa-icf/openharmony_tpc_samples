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

export default function JSXTokenTest() {
  describe('JSXTokenTest', () => {
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

    it("JSXInvalid001", 0, () => {
      let type: string = "JSXInvalid";
      match(type, ["<", "a"], "<", false);
    });

    it("JSXInvalid002", 0, () => {
      let type: string = "JSXInvalid";
      match(type, ["<"], ">", false);
      match(type, ["<"], "{", false);
      match(type, ["<"], "}", false);
      match(type, ["<"], "1");
      match(type, ["<"], "`");
      match(type, ["<"], "+");
      match(type, ["<"], ",");
      match(type, ["<"], "@");
      match(type, ["<"], "#");
      match(type, ["<"], "\\");
      match(type, ["<"], "\\xa9", "\\");
      match(type, ["<"], "\u0000");
      match(type, ["<"], "\u007F");
      match(type, ["<"], "☃");
      match(type, ["<"], "💩");
      match(type, ["<"], "\ud83d"); // First half of 💩
    });

    it("JSXInvalid003", 0, () => {
      let type: string = "JSXInvalid";
      match(type, ["<", ">"], "<", false);
      match(type, ["<", ">"], ">");
      match(type, ["<", ">"], "{", false);
      match(type, ["<", ">"], "}");
      match(type, ["<", ">"], "1", false);
      match(type, ["<", ">"], "`", false);
      match(type, ["<", ">"], "+", false);
      match(type, ["<", ">"], ",", false);
      match(type, ["<", ">"], "@", false);
      match(type, ["<", ">"], "#", false);
      match(type, ["<", ">"], "\\", false);
      match(type, ["<", ">"], "\\xa9", false);
      match(type, ["<", ">"], "\u0000", false);
      match(type, ["<", ">"], "\u007F", false);
      match(type, ["<", ">"], "☃", false);
      match(type, ["<", ">"], "💩", false);
      match(type, ["<", ">"], "\ud83d", false); // First half of 💩
    });

    it("JSXString", 0, () => {
      let type: string = "JSXString";
      match(type, ["<"], "''");
      match(type, ["<"], '""');
      match(type, ["<"], "'string'");
      match(type, ["<"], '"string"');
      match(type, ["<"], "'\\''", "'\\'");
      match(type, ["<"], '"\\""', '"\\"');
      match(type, ["<"], "'\\\\''", "'\\\\'");
      match(type, ["<"], '"\\\\""', '"\\\\"');
      match(type, ["<"], "'\n'");
      match(type, ["<"], '"\n"');
      match(type, ["<"], "'\r'");
      match(type, ["<"], '"\r"');
      match(type, ["<"], "'\u2028'");
      match(type, ["<"], '"\u2028"');
      match(type, ["<"], "'\u2029'");
      match(type, ["<"], '"\u2029"');
      match(type, ["<"], "'\r\n'");
      match(type, ["<"], '"\r\n"');
      match(type, ["<"], "'string'code'another string'", "'string'");
      match(type, ["<"], '"string"code"another string"', '"string"');
      match(type, ["<"], "'\"'");
      match(type, ["<"], "'`'");
      match(type, ["<"], '"\'"');
      match(type, ["<"], '"`"');

      match(type, ["<"], "'", {
        closed: false
      });
      match(type, ["<"], '"', {
        closed: false
      });
      match(type, ["<"], "'unclosed", {
        closed: false
      });
      match(type, ["<"], '"unclosed', {
        closed: false
      });
      match(type, ["<"], "'\n", {
        closed: false
      });
      match(type, ["<"], '"\n', {
        closed: false
      });
      match(type, ["<"], "'\r", {
        closed: false
      });
      match(type, ["<"], '"\r', {
        closed: false
      });
      match(type, ["<"], "'\u2028", {
        closed: false
      });
      match(type, ["<"], '"\u2028', {
        closed: false
      });
      match(type, ["<"], "'\u2029", {
        closed: false
      });
      match(type, ["<"], '"\u2029', {
        closed: false
      });
      match(type, ["<"], "'\r\n", {
        closed: false
      });
      match(type, ["<"], '"\r\n', {
        closed: false
      });
    });

    it("JSXText", 0, () => {
      let type: string = "JSXText";
      match(type, ["<", ">"], "  /**///\n\t/+?.& some text Iñtërnâtiônàlizætiøn");
      match(type, ["<", ">"], "1<5", "1");
      match(type, ["<", ">"], "2>1", "2");
      match(type, ["<", ">"], "a{1}", "a");
      match(type, ["<", ">"], "a}", "a");
    });

    it("JSXPunctuator001", 0, () => {
      let type: string = "JSXPunctuator";
      match(type, ["<", "a"], "<");
      match(type, ["<", "a"], "=");
    });

    it("JSXPunctuator002", 0, () => {
      let type: string = "JSXPunctuator";
      match(type, ["<"], ">");
      match(type, ["<"], "/");
      match(type, ["<"], ".");
      match(type, ["<"], ":");
      match(type, ["<"], "{");
      match(type, ["<"], "}");

      match(type, ["<"], "+", false);
      match(type, ["<"], "-", false);
      match(type, ["<"], "*", false);
      match(type, ["<"], "^", false);
      match(type, ["<"], "~", false);
      match(type, ["<"], "(", false);
      match(type, ["<"], ")", false);
      match(type, ["<"], "[", false);
      match(type, ["<"], "]", false);
      match(type, ["<"], "!", false);
      match(type, ["<"], "?", false);
      match(type, ["<"], ",", false);
      match(type, ["<"], ";", false);
    });

    it("JSXPunctuator003", 0, () => {
      let type: string = "JSXPunctuator";
      match(type, ["<", ">"], "<");
      match(type, ["<", ">"], ">", false);
      match(type, ["<", ">"], "{");
      match(type, ["<", ">"], "}", false);
    });

    it("JSXIdentifier001", 0, () => {
      let type: string = "JSXIdentifier";
      match(type, ["<"], "#div", false);
      match(type, ["<"], "div");
      match(type, ["<"], "class");
      match(type, ["<"], "xml");
      match(type, ["<"], "x-element");
      match(type, ["<"], "x------");
      match(type, ["<"], "$htm1_element");
      match(type, ["<"], "ಠ_ಠ");
      match(type, ["<"], "-", false);
      match(type, ["<"], "-f--", ["-", "f--"]);

      match(type, ["<"], "#", false);
      match(type, ["<"], "$");
      match(type, ["<"], "_");
      match(type, ["<"], "a");
      match(type, ["<"], "z");
      match(type, ["<"], "A");
      match(type, ["<"], "Z");
      match(type, ["<"], "å");
      match(type, ["<"], "π");
      match(type, ["<"], "0", false);
      match(type, ["<"], "0a", false);
      match(type, ["<"], "$0");
      match(type, ["<"], "_0");
      match(type, ["<"], "a0");
      match(type, ["<"], "z0");
      match(type, ["<"], "A0");
      match(type, ["<"], "Z0");
      match(type, ["<"], "å0");
      match(type, ["<"], "π0");
      match(type, ["<"], "a_56åπ");
      match(type, ["<"], "℮");
      match(type, ["<"], "℘");
      match(type, ["<"], "゛");
      match(type, ["<"], "゜");
      match(type, ["<"], "℮℘");
      match(type, ["<"], "·", false);
      match(type, ["<"], "℮·");
      match(type, ["<"], "·", false);
      match(type, ["<"], "℮·");
      match(type, ["<"], "᧚", false);
      match(type, ["<"], "℮᧚");
      match(type, ["<"], "Iñtërnâtiônàlizætiøn");
    });

    it("JSXIdentifier002", 0, () => {
      let type: string = "JSXIdentifier";
      match(type, ["<", ">"], "div", false);
    });
  })
}