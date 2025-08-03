/*
 * MIT License
 *
 * Copyright (C) 2025 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { Expression } from "@ohos/expr-parser";

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
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

    it('exprParser_parse_normal', 0, () => {
      let expr: Function = new Expression('"\\u2605haha"').parse();
      expect(expr({})).assertEqual('★haha');

      expr = new Expression('"\\n\\r\\f\\t\\v\\s"').parse();
      expect(expr({})).assertEqual('\n\r\f\t\v\s');

      expr = new Expression('2e3').parse();
      expect(expr({})).assertEqual(2000);

      expr = new Expression('2e-3').parse();
      expect(expr({})).assertEqual(0.002);

      expr = new Expression('+"123"').parse();
      expect(expr({})).assertEqual('123');

      expr = new Expression('-123').parse();
      expect(expr({})).assertEqual(-123);

      expr = new Expression('a.b.c.d').parse();
      class B {
        b: null = null;
      }
      expect(expr({ a: { b: null } as B })).assertNull();

      expr = new Expression('{ a: {}, b: [] }').parse();
      expect(expr({})).assertDeepEquals({ a: {}, b: [] });

      expr = new Expression(']123').parse();
      expect(expr({})).assertEqual(undefined);
    })

    it('exprParser_parseConstants', 0, () => {
      let expr: Function = new Expression('a === null').parse();
      expect(expr({ a: null })).assertEqual(true);
      expect(expr({ a: 1 })).assertEqual(false);

      expr = new Expression('a === undefined').parse();
      expect(expr({ a: undefined })).assertEqual(true);
      expect(expr({ a: 1 })).assertEqual(false);

      expr = new Expression('a === true').parse();
      expect(expr({ a: true })).assertEqual(true);
      expect(expr({ a: 1 })).assertEqual(false);

      expr = new Expression('a === false').parse();
      expect(expr({ a: false })).assertEqual(true);
      expect(expr({ a: 1 })).assertEqual(false);
    })

    it('exprParser_parseOperators', 0, () => {
      let expr: Function = new Expression('a.value + 12 - (2 * 14 / 4)').parse();
      class Val {
        value: number = 0;
      }
      expect(expr({ a: { value: 1 } as Val })).assertEqual(6);
      expect(expr({ a: { value: 3 } as Val })).assertEqual(8);

      expr = new Expression('a && b || c && ( d || e )').parse();
      expect(expr({ a: true, b: false, c: true, d: false, e: true })).assertEqual(true);
      expect(expr({ a: false, b: true, c: false, d: true, e: false })).assertEqual(false);

      expr = new Expression('a === b && a !== c').parse();
      expect(expr({ a: 1, b: 1, c: '1' })).assertEqual(true);
      expect(expr({ a: 1, b: 1, c: 1 })).assertEqual(false);

      expr = new Expression('a > 3 && b < 10').parse();
      expect(expr({ a: 4, b: 5 })).assertEqual(true);
      expect(expr({ a: 3, b: 5 })).assertEqual(false);
      expect(expr({ a: 4, b: 11 })).assertEqual(false);

      expr = new Expression('a.list[i + 1]').parse();
      class List {
        list: number[] = [];
      }
      expect(expr({ a: { list: [0, 5, 10] } as List, i: 1 })).assertEqual(10);
      expect(expr({ a: { list: [0, 5, 10] } as List, i: 0 })).assertEqual(5);

      expr = new Expression('a > b ? b : a').parse();
      expect(expr({ a: 2, b: 1 })).assertEqual(1);
      expect(expr({ a: 2, b: 3 })).assertEqual(2);

      expr = new Expression('a % b == 1 && c % d == 2 && e % f != 1').parse();
      expect(expr({ a: 21, b: 2, c: 8, d: 3, e: 3, f: 3 })).assertEqual(true);

      expr = new Expression('a == b').parse();
      expect(expr({ a: 10, b: 10 })).assertEqual(true);
      expect(expr({ a: 10, b: '10' })).assertEqual(true);
      expect(expr({ a: 10, b: '110' })).assertEqual(false);

      expr = new Expression('a != b').parse();
      expect(expr({ a: 10, b: 10 })).assertEqual(false);
      expect(expr({ a: 10, b: '10' })).assertEqual(false);
      expect(expr({ a: 10, b: '110' })).assertEqual(true);

      expr = new Expression('a >= b && c <= d').parse();
      expect(expr({ a: 2, b: 2, c: 3, d: 3 })).assertEqual(true);
      expect(expr({ a: 3, b: 2, c: 3, d: 4 })).assertEqual(true);
      expect(expr({ a: 2, b: 2, c: 3, d: 2 })).assertEqual(false);
      expect(expr({ a: 1, b: 2, c: 3, d: 3 })).assertEqual(false);

      expr = new Expression('!a').parse();
      expect(expr({ a: 1 })).assertEqual(false);
      expect(expr({ a: 0 })).assertEqual(true);
    })

    it('exprParser_parseObjectArrayFunction', 0, () => {
      let expr: Function = new Expression('a["b"].c + a.d["e"]').parse();
      class NumC {
        c: number = 0;
      }
      class NumE {
        e: number = 0;
      }
      class NumA {
        b: NumC = { c : 0 };
        d: NumE = { e : 0 };
      }
      expect(expr({ a: { b: { c: 1 } as NumC, d: { e: 2 } as NumE } as NumA })).assertEqual(3);

      expr = new Expression('{ a: { b: { "c": null }, d: { e: 2 }, } }').parse();
      expect(expr({})).assertDeepEquals({ a: { b: { c: null }, d: { e: 2 } } });

      expr = new Expression('a(1, 2)').parse();
      expect(expr({ a: (num1: number, num2: number): number => num1 + num2 })).assertEqual(3);

      expr = new Expression('[1, 2, 3, ][2]').parse();
      expect(expr({})).assertEqual(3);
    })
    it('error', 0, () => {
      expect(getErr('')).assertEqual('invalid expression');
      expect(getErr('{ ;a: 123 }')).assertEqual('parse expression error: { ;a: 123 }');
      expect(getErr(';')).assertEqual('parse expression error: ;');
      expect(getErr('\\')).assertEqual('invalid expression: \\');
      expect(getErr('"" || "\\uzzzz"')).assertEqual('invalid expression: "" || "\\uzzzz", invalid unicode escape [\\uzzzz]');
      expect(getErr('"')).assertEqual('invalid expression: "');
      expect(getErr('2e-a')).assertEqual('invalid expression: 2e-a');
      expect(getErr('1 === 1 ? true')).assertEqual('parse expression error: 1 === 1 ? true');
      expect(getErr('1 === 1 ? true ;')).assertEqual('parse expression error: 1 === 1 ? true ;');
    })
  })
}

function getErr(str: string): string {
  let catchErr: string = '';
  try {
    new Expression(str).parse();
  } catch (err) {
    catchErr = err.message;
  }
  return catchErr;
}
