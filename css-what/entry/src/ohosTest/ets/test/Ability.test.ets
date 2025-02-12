/**
 *
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 *
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice,this
 * list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS,
 *
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import { isTraversal, parse, stringify } from 'css-what';

function test_valid_selector(
  selector: string,
  serialized: string | string[] = selector,
) {
  const result = stringify(parse(selector));
  if (Array.isArray(serialized)) {
    // Should be a part of the array
    expect(serialized).assertContain(result);
  } else {
    expect(result).assertEqual(serialized);
  }
}

function test_invalid_selector(selector: string) {
  expect(() => parse(selector)).assertThrowError(Error);
}

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
    it ("isTraversal",0,() => {
      const expected = isTraversal(parse("<")[0][0])
      expect(expected).assertEqual(true);
      const expected2 = isTraversal(parse("[att]")[0][0])
      expect(expected2).assertEqual(false);
    })
    it("Attribute_selectors", 0, () => {
      // Attribute presence and value selectors
      test_valid_selector("[att]");
      test_valid_selector("[att=val]", '[att="val"]');
      test_valid_selector("[att~=val]", '[att~="val"]');
      test_valid_selector("[att|=val]", '[att|="val"]');
      test_valid_selector("h1[title]");
      test_valid_selector("span[class='example']", 'span[class="example"]');
      test_valid_selector("a[hreflang=fr]", 'a[hreflang="fr"]');
      test_valid_selector("a[hreflang|='en']", 'a[hreflang|="en"]');

      // Substring matching attribute selectors
      test_valid_selector("[att^=val]", '[att^="val"]');
      test_valid_selector("[att$=val]", '[att$="val"]');
      test_valid_selector("[att*=val]", '[att*="val"]');
      test_valid_selector('object[type^="image/"]');
      test_valid_selector('a[href$=".html"]');
      test_valid_selector('p[title*="hello"]');

      // From Attribute selectors and namespaces examples in spec:
      test_valid_selector("[*|att]");
      test_valid_selector("[|att]", "[att]");
    });

    it("Child_combinators", 0, () => {
      test_valid_selector("body > p");
      test_valid_selector("div ol>li p", "div ol > li p");
    });

    it("Class_selectors", 0, () => {
      test_valid_selector("*.pastoral", ["*.pastoral", ".pastoral"]);
      test_valid_selector(".pastoral", ["*.pastoral", ".pastoral"]);
      test_valid_selector("h1.pastoral");
      test_valid_selector("p.pastoral.marine");
    });

    it("Descendant_combinator", 0, () => {
      test_valid_selector("h1 em");
      test_valid_selector("div * p");
      test_valid_selector("div p *[href]", ["div p *[href]", "div p [href]"]);
    });

    it("focus_visible_pseudo_class", 0, () => {
      test_valid_selector(":focus-visible");
      test_valid_selector("a:focus-visible");
      test_valid_selector(":focus:not(:focus-visible)");
    });

    it("The_relational_pseudo_class", 0, () => {
      test_valid_selector(":has(a)");
      test_valid_selector(":has(#a)");
      test_valid_selector(":has(.a)");
      test_valid_selector(":has([a])");
      test_valid_selector(':has([a="b"])');
      test_valid_selector(':has([a|="b"])');
      test_valid_selector(":has(:hover)");
      test_valid_selector("*:has(.a)", ["*:has(.a)", ":has(.a)"]);
      test_valid_selector(".a:has(.b)");
      test_valid_selector(".a:has(> .b)");
      test_valid_selector(".a:has(~ .b)");
      test_valid_selector(".a:has(+ .b)");
      test_valid_selector(".a:has(.b) .c");
      test_valid_selector(".a .b:has(.c)");
      test_valid_selector(".a .b:has(.c .d)");
      test_valid_selector(".a .b:has(.c .d) .e");
      test_valid_selector(".a:has(.b:has(.c))");
      test_valid_selector(".a:has(.b:is(.c .d))");
      test_valid_selector(".a:has(.b:is(.c:has(.d) .e))");
      test_valid_selector(".a:is(.b:has(.c) .d)");
      test_valid_selector(".a:not(:has(.b))");
      test_valid_selector(".a:has(:not(.b))");
      test_valid_selector(".a:has(.b):has(.c)");
      test_valid_selector("*|*:has(*)", ":has(*)");
      test_valid_selector(":has(*|*)");
      test_invalid_selector(".a:has()");
    });

    it("ID_selectors", 0, () => {
      test_valid_selector("h1#chapter1");
      test_valid_selector("#chapter1");
      test_valid_selector("*#z98y", ["*#z98y", "#z98y"]);
    });

    it("The_Matches_Any_Pseudo_class_is", 0, () => {
      test_valid_selector(
        ":is(ul,ol,.list) > [hidden]",
        ":is(ul, ol, .list) > [hidden]",
      );
      test_valid_selector(":is(:hover,:focus)", ":is(:hover, :focus)");
      test_valid_selector("a:is(:not(:hover))");

      test_valid_selector(":is(#a)");
      test_valid_selector(".a.b ~ :is(.c.d ~ .e.f)");
      test_valid_selector(".a.b ~ .c.d:is(span.e + .f, .g.h > .i.j .k)");
    });

    it("The_negation_pseudo_class", 0, () => {
      test_valid_selector("button:not([disabled])");
      test_valid_selector("*:not(foo)", ["*:not(foo)", ":not(foo)"]);
      test_valid_selector(":not(:link):not(:visited)");
      test_valid_selector("*|*:not(*)", ":not(*)");
      test_valid_selector(":not(:hover)");
      test_valid_selector(":not(*|*)");
      test_valid_selector("foo:not(bar)");
      test_valid_selector(":not(:not(foo))");
      test_valid_selector(":not(.a .b)");
      test_valid_selector(":not(.a + .b)");
      test_valid_selector(":not(.a .b ~ c)");
      test_valid_selector(":not(span.a, div.b)");
      test_valid_selector(":not(.a .b ~ c, .d .e)");
      test_valid_selector(":not(:host)");
      test_valid_selector(":not(:host(.a))");
      test_valid_selector(":host(:not(.a))");
      test_valid_selector(":not(:host(:not(.a)))");
      test_valid_selector(
        ":not([disabled][selected])",
        ":not([disabled][selected])",
      );
      test_valid_selector(
        ":not([disabled],[selected])",
        ":not([disabled], [selected])",
      );

      test_invalid_selector(":not()");
      test_invalid_selector(":not(:not())");
    });

    it("Sibling_combinators", 0, () => {
      test_valid_selector("math + p");
      test_valid_selector("h1.opener + h2");
      test_valid_selector("h1 ~ pre");
    });

    it("Universal_selector", 0, () => {
      test_valid_selector("*");
      test_valid_selector("div :first-child", [
        "div *:first-child",
        "div :first-child",
      ]);
      test_valid_selector("div *:first-child", [
        "div *:first-child",
        "div :first-child",
      ]);
    });

    it("where", 0, () => {
      test_valid_selector(
        ":where(ul,ol,.list) > [hidden]",
        ":where(ul, ol, .list) > [hidden]",
      );
      test_valid_selector(":where(:hover,:focus)", ":where(:hover, :focus)");
      test_valid_selector("a:where(:not(:hover))");

      test_valid_selector(":where(#a)");
      test_valid_selector(".a.b ~ :where(.c.d ~ .e.f)");
      test_valid_selector(".a.b ~ .c.d:where(span.e + .f, .g.h > .i.j .k)");
    });


  })
}