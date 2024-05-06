/**
 * ISC License
 * Copyright (C) 2024 Huawei Device Co., Ltd.
 *
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
 * REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
 * INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
 * LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE
 * OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
 * PERFORMANCE OF THIS SOFTWARE.
 * */

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import xml from '@ohos/xmpp_xml';
import
{ Parser,
  Element,
  createElement,
  escapeXML,
  unescapeXML,
  escapeXMLText,
  unescapeXMLText } from '@ohos/xmpp_xml'


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
    it('stream_parser', 0, () => {
      let parser: ESObject = new Parser()
      let startElement:Element;
      parser.on("start", (el:Element) => {
        expect(el.toString()).assertEqual("<foo/>");
        startElement = el;
      });

      parser.on("element", (el:Element) => {
        expect(el.parent).assertDeepEquals(startElement);
        expect(startElement.children.length).assertEqual(0);
        expect(el.toString()).assertEqual("<bar>hello</bar>");
      });

      parser.on("end", (el:Element) => {
        expect(el.toString()).assertEqual("<foo/>");
      });

      parser.write("<foo><bar>hello</bar></foo>");
    });


    it('xml', 0, () => {
     let xmlStr= xml('presence', { to: 'xx.xx.xx.xx:xxx', type: 'subscribed' })
      expect(xmlStr.toString()).assertEqual('<presence to="xx.xx.xx.xx:xxx" type="subscribed"/>')
    });

    it('createElement', 0, () => {
      expect(typeof createElement).assertEqual('function')
    });

    it('escapeXML', 0, () => {
      expect(typeof escapeXML).assertEqual('function')
    });

    it('escapeXMLText', 0, () => {
      expect(typeof escapeXMLText).assertEqual('function')
    });

    it('unescapeXML', 0, () => {
      expect(typeof unescapeXML).assertEqual('function')
    });

    it('unescapeXMLText', 0, () => {
      expect(typeof unescapeXMLText).assertEqual('function')
    });

    it('createElement_test',0, () => {
      const element = createElement('message', { to: 'user@example.com' }, 'Hello');
      expect(element.toString()).assertEqual('<message to="user@example.com">Hello</message>');
    });

    it('escapeXML_test',0, () => {
      const escaped = escapeXML('<body>Hello</body>');
      expect(escaped).assertEqual('&lt;body&gt;Hello&lt;/body&gt;');
    });

    it('unescapeXML_test', 0,() => {
      const unescaped = unescapeXML('&lt;message&gt;Hello&lt;/message&gt;');
      expect(unescaped).assertEqual('<message>Hello</message>');
    });

    it('escapeXMLText_test',0, () => {
      const escapedText = escapeXMLText('This is <b>bold</b>');
      expect(escapedText).assertEqual('This is &lt;b&gt;bold&lt;/b&gt;');
    });

    it('unescapeXMLText_test',0, () => {
      const unescapedText = unescapeXMLText('This is &lt;b&gt;bold&lt;/b&gt;');
      expect(unescapedText).assertEqual('This is <b>bold</b>');
    });

  })
}