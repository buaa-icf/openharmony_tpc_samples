/*
 * Copyright (C) 2023 Huawei Device Co., Ltd.
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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium'
import { XDocument, XmlParser, XNode, xmlText } from 'xslt-processor/dom'
import he from 'he'
import { DOM_ATTRIBUTE_NODE } from 'xslt-processor/constants';

export default function domTest() {
  describe('DomTest', () => {
    let xmlParser: XmlParser;

    beforeAll(() => {
      xmlParser = new XmlParser();
    });

    const doTestXmlParse = (dom1: XDocument, dom2: XDocument) => {

      expect(xmlText(dom1)).assertEqual(xmlText(dom2))

      expect(dom1.nodeName).assertEqual(dom2.nodeName)


      expect(dom1.documentElement).assertEqual(dom1.firstChild);
      expect(dom2.documentElement).assertEqual(dom2.firstChild);

      expect(dom1.parentNode).assertEqual(null);
      expect(dom2.parentNode).assertEqual(null);

      expect(dom1.documentElement.parentNode).assertEqual(dom1);
      expect(dom2.documentElement.parentNode).assertEqual(dom2);

      expect(dom1.documentElement.nodeName).assertEqual(dom2.documentElement.nodeName);
      expect(dom1.childNodes.length).assertEqual(dom2.childNodes.length);
      expect(dom1.childNodes.length).assertEqual(dom2.childNodes.length);
      expect(dom1.firstChild.childNodes.length).assertEqual(dom2.firstChild.childNodes.length);
      expect(dom1.firstChild.childNodes.length).assertEqual(dom2.firstChild.childNodes.length);

    }
    it('can_parse_xml', 0, () => {
      const xml = '<page>' +
      '<request>' +
      '<q id="q">new york</q>' +
      '</request>' +
      '<location lat="100" lon="200"/>' +
      '</page>';

      const dom1 = xmlParser.xmlParse(`<?xml version="1.0"?>${xml}`);
      const dom2 = xmlParser.xmlParse(`<?xml version='1.1'?>${xml}`);

      doTestXmlParse(dom1, dom2);

      const dom1Attributes = dom1.firstChild.childNodes[1].childNodes.filter(n => n.nodeType === DOM_ATTRIBUTE_NODE);
      const dom2Attributes = dom2.firstChild.childNodes[1].childNodes.filter(n => n.nodeType === DOM_ATTRIBUTE_NODE);

      expect(dom1Attributes.length).assertEqual(dom2Attributes.length);

      const tag = 'q';
      const byTag: ESObject[] = dom1.getElementsByTagName(tag);
      expect(1).assertEqual(byTag.length);
      expect(tag).assertEqual(byTag[0].nodeName);

      const id = 'q';
      const byId: ESObject = dom1.getElementById(id);
      expect(id).assertEqual(byId.getAttributeValue('id'));

    })

    it('can_parse_weird_xml', 0, () => {
      const xml = [
        '<_>',
        '<_.:->',
        '<:>!"#$%&\'()*+,-./:;&lt;=&gt;?[\\]^_`{|}~</:>',
        '</_.:->',
        '<:-_. _=".-" :="-."/>',
        '</_>'
      ].join('');

      const dom1 = xmlParser.xmlParse(`<?xml version="1.0"?>${xml}`);
      const dom2 = xmlParser.xmlParse(`<?xml version='1.1'?>${xml}`);
      doTestXmlParse(dom1, dom2);
    })

    it('can_parse_Japanese_xml', 0, () => {
      const xml = [
        '<\u30da\u30fc\u30b8>',
        '<\u30ea\u30af\u30a8\u30b9\u30c8>',
        '<\u30af\u30a8\u30ea>\u6771\u4eac</\u30af\u30a8\u30ea>',
        '</\u30ea\u30af\u30a8\u30b9\u30c8>',
        '<\u4f4d\u7f6e \u7def\u5ea6="\u4e09\u5341\u4e94" ',
        "\u7d4c\u5ea6='\u767e\u56db\u5341'/>",
        '</\u30da\u30fc\u30b8>'
      ].join('');

      const dom1 = xmlParser.xmlParse(`<?xml version="1.0"?>${xml}`);
      const dom2 = xmlParser.xmlParse(`<?xml version='1.1'?>${xml}`);
      doTestXmlParse(dom1, dom2);
    })

    it('can_resolve_entities', 0, () => {
      expect('";"').assertEqual(he.decode('&quot;;&quot;'));
    })
  })
}