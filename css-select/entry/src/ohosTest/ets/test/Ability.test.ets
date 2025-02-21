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

import * as CSSselect from 'css-select';
import { parseDocument, parseDOM } from '@ohos/htmlparser2';
import * as boolbase from 'boolbase';
import type { Element } from 'domhandler';
import { AttributeAction, SelectorType } from 'css-what';
import AdapterClass from './adapter';

const dom = parseDOM("<div id=foo><p>foo</p></div>") as Element[];
const notYet = "not yet supported by css-select";

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

    it("between_identical_trees", 0, () => {
      expect((CSSselect.selectAll("div", dom)).length).assertEqual(1);
    });

    it("subset", 0, () => {
      expect(CSSselect.selectAll("p", dom).length).assertEqual(1);
    });

    it("function_in_is", 0, () => {
      expect(
        CSSselect.is(dom[0], (elem) => elem.attribs["id"] === "foo"),
      ).assertDeepEquals(true);
    });

    it("parsed_selector_in_is", 0, () => {
      expect(
        CSSselect.is(dom[0], [
          [
            {
              type: SelectorType.Attribute,
              action: AttributeAction.Equals,
              ignoreCase: false,
              name: "id",
              namespace: null,
              value: "foo",
            },
          ],
        ]),
      ).assertEqual(true);
    });

    it("should_throw_with_attribute_namespace", 0, () => {
      expect(() => CSSselect.compile("[foo|bar]")).assertThrowError(notYet);
      expect(() => CSSselect.compile("[*|bar]")).assertThrowError(notYet);
    });

    it("in_not", 0, () => {
      expect(CSSselect._compileUnsafe(":not(*)")).assertEqual(
        boolbase.falseFunc,
      );
      expect(CSSselect._compileUnsafe(":not(:nth-child(-1n-1))")).assertEqual(
        boolbase.trueFunc,
      );
      expect(CSSselect._compileUnsafe(":not(:not(:not(*)))")).assertEqual(
        boolbase.falseFunc,
      );
    });

    it("should_throw_if_no_parameter_is_supplied_for_pseudo", 0, () => {
      expect(() => AdapterClass.adapterfunc().compile(":foovalue")).assertThrowError(
        "requires an argument",
      );
      CSSselect.aliases["foovalue"] = "foo";
      expect(CSSselect.aliases["foovalue"]).assertEqual("foo");
    });

    it("should_throw_if_parameter_is_supplied_for_user_provided_pseudo", 0, () => {
      expect(() =>
      CSSselect.compile(":foovalue(boo)", {
        pseudos: {
          foovalue: "tag"
        },
      }),
      ).assertThrowError("doesn't have any arguments")
    });

    it("should_support_traversals", 0, () => {
      let matches = CSSselect.selectAll(":matches(div p)", dom);
      expect(matches.length).assertEqual(1);
      expect(matches[0].name).assertContain("p");

      matches = CSSselect.selectAll(":matches(div > p)", dom);
      expect(matches.length).assertEqual(1);
      expect(matches[0].name).assertContain("p");

      matches = CSSselect.selectAll(":matches(p < div)", dom);
      expect(matches.length).assertEqual(1);
      expect(matches[0].name).assertContain("div");

      matches = CSSselect.selectAll(":matches(> p)", dom);
      expect(matches.length).assertEqual(1);
      expect(matches[0].name).assertContain("p");

      matches = CSSselect.selectAll("div:has(:is(:scope p))", dom);
      expect(matches.length).assertEqual(1);
      expect(matches[0].name).assertContain("div");

      const multiLevelDom = parseDOM("<a><b><c><d>") as Element[];
      matches = CSSselect.selectAll(":is(* c)", multiLevelDom[0]);
      expect(matches.length).assertEqual(1);
      expect(matches[0].name).assertContain("c");
    });

    it("should_support_alias_is", 0, () => {
      let matches = CSSselect.selectAll(":is(p, div)", dom);
      expect(matches.length).assertEqual(2);
      matches = CSSselect.selectAll(":is(div, :not(div))", dom);
      expect(matches.length).assertEqual(2);
      matches = CSSselect.selectAll(
        ":is(boo, baa, tag, div, foo, bar, baz)",
        dom,
      );
      expect(matches.length).assertEqual(1);
      expect(matches[0].firstChild).assertEqual(dom[0].firstChild);
    });


    it("should_support_alias_where", 0, () => {
      let matches = CSSselect.selectAll(":where(p, div)", dom);
      expect(matches.length).assertEqual(2);
      matches = CSSselect.selectAll(":where(div, :not(div))", dom);
      expect(matches.length).assertEqual(2);
      matches = CSSselect.selectAll(
        ":where(boo, baa, tag, div, foo, bar, baz)",
        dom,
      );
      expect(matches.length).assertEqual(1);
      expect(matches[0].firstChild).assertEqual(dom[0].firstChild);
    });

    it("should_select_elements_in_traversal_order", 0, () => {
      expect(CSSselect.selectOne("p", [dom[0]])).assertEqual(dom[0].firstChild);
      expect(CSSselect.selectOne(":contains(foo)", [dom[0]])).assertEqual(dom[0]);
      expect(CSSselect.selectOne(":contains(foo)", [dom[0]], {
        relativeSelector: false,
      })).assertEqual(dom[0]);
    });

    it("should_support_pseudos_led_by_a_traversal", 0, () => {
      const dom = parseDOM(
        '<div><div class="foo">a</div><div class="bar">b</div></div>',
      ) as Element[];
      const a = CSSselect.selectAll(".foo:has(+.bar)", dom, {
        quirksMode: true
      });
      expect(a.length).assertEqual(1);
      expect(a[0]).assertEqual(dom[0].firstChild);
    });

    it("selectOne_options", 0, () => {
      const doc = parseDocument(`
                <div class="parent">
                    <div class="one"><p class="p1"></p></div>
                    <div class="two"><p class="p2"></p></div>
                    <div class="three"><p class="p3"></p></div>
                </div>`);
      const two = CSSselect.selectOne(".two", doc);
      expect(
        CSSselect.selectOne(".parent .two .p3", two, {
          relativeSelector: false,
        })).assertNull();
    });

    it("should_recognize_contexts", 0, () => {
      const div = CSSselect.selectAll("div", dom);
      const p = CSSselect.selectAll("p", dom);
      expect(CSSselect.selectOne("div", div, {
        context: p
      })).assertNull();
    });

    it("should_not_crash_when_siblings_repeat", 0, () => {
      const dom = parseDOM(`<div></div>`.repeat(51)) as Element[];
      expect(
        CSSselect.selectAll("+div", dom, {
          context: dom
        }).length).assertEqual(50);
    });


    it("should_pass_options_to_sub_selectors", 0, () => {
      expect(
        CSSselect.selectAll("div:is(DiV#FOO):not([ID]):foo", dom, {
          xmlMode: true,
          lowerCaseTags: true,
          quirksMode: true,
          pseudos: {
            foo: "#fOO"
          },
        }).length,
      ).assertEqual(1);
    });

    it("should_accept_document_root_nodes", 0, () => {
      const doc = parseDocument("<div id=foo><p>foo</p></div>");
      expect(CSSselect.selectAll(":contains(foo)", doc).length).assertEqual(2);
    });

    it("should_throw_if_parameter_is_supplied_for_pseudo", 0, () => {
      expect(() => CSSselect.compile(":any-link(test)")).assertThrowError(
        "doesn't have any arguments",
      );

      expect(() => CSSselect.compile(":only-child(test)")).assertThrowError(
        "doesn't have any arguments",
      );
    });

    it("should_not_match_any_elements_if_isHovered_is_not_defined", 0, () => {
      const dom = parseDOM(`${"<p>foo".repeat(10)}`);
      expect(CSSselect.selectAll("p:hover", dom).length).assertEqual(0);
    });
  })
}