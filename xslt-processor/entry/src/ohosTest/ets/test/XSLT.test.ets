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
import { Xslt } from 'xslt-processor/xslt'
import { XDocument, XmlParser } from 'xslt-processor/dom'

export default function xsltTest() {
  describe('XSLTTest', () => {
    const xmlString =
      '<all>' +
      '<item pos="2">A</item>' +
      '<item pos="3">B</item>' +
      '<item pos="1">C</item>' +
      '</all>';

    it('handles_foreach_sort', 0, async () => {
      const xsltForEachSort =
        '<xsl:stylesheet>' +
        '<xsl:template match="/">' +
        '<xsl:for-each select="//item">' +
        '<xsl:sort select="@pos"/>' +
        '<xsl:value-of select="."/>' +
        '</xsl:for-each>' +
        '</xsl:template>' +
        '</xsl:stylesheet>';

      const xsltClass = new Xslt();
      const xmlParser = new XmlParser();
      const xml: XDocument = xmlParser.xmlParse(xmlString);
      const xslt: XDocument = xmlParser.xmlParse(xsltForEachSort);
      const html: string = await xsltClass.xsltProcess(xml, xslt);
      expect("CAB").assertEqual(html);
    })

    it('handles_foreach_sort_ascending', 0, async () => {
      const xsltForEachSortAscending =
        '<xsl:stylesheet>' +
        '<xsl:template match="/">' +
        '<xsl:for-each select="//item">' +
        '<xsl:sort select="." order="ascending"/>' +
        '<xsl:value-of select="."/>' +
        '</xsl:for-each>' +
        '</xsl:template>' +
        '</xsl:stylesheet>';

      const xsltClass = new Xslt();
      const xmlParser = new XmlParser();
      const xml: XDocument = xmlParser.xmlParse(xmlString);
      const xslt: XDocument = xmlParser.xmlParse(xsltForEachSortAscending);
      const html: string = await xsltClass.xsltProcess(xml, xslt);
      expect("ABC").assertEqual(html);
    })

    it('handles_foreach_sort_descending', 0, async () => {
      const xsltForEachSortDescending =
        `<xsl:stylesheet>
            <xsl:template match="/">
            <xsl:for-each select="//item">
              <xsl:sort select="." order="descending"/>
              <xsl:value-of select="."/>
            </xsl:for-each>
          </xsl:template>
        </xsl:stylesheet>`;

      const xsltClass = new Xslt();
      const xmlParser = new XmlParser();
      const xml: XDocument = xmlParser.xmlParse(xmlString);
      const xslt: XDocument = xmlParser.xmlParse(xsltForEachSortDescending);
      const html: string = await xsltClass.xsltProcess(xml, xslt);
      expect("CBA").assertEqual(html);
    })


    it('applies_templates', 0, async () => {
      const xmlApplyTemplates = `<all>
          <item type="X">A</item>
          <item type="Y">B</item>
          <item type="X">C</item>
        </all>`;

      const xsltApplyTemplates = `<xsl:stylesheet>
          <xsl:template match="/">
            <xsl:apply-templates select="//item"/>
          </xsl:template>
          <xsl:template match="item[@type='X']">
            <xsl:value-of select="."/>
          </xsl:template>
          <xsl:template match="item[@type='Y']">
            <xsl:value-of select="."/>
          </xsl:template>
        </xsl:stylesheet>`;

      const xsltClass = new Xslt();
      const xmlParser = new XmlParser();
      const xml: XDocument = xmlParser.xmlParse(xmlApplyTemplates);
      const xslt: XDocument = xmlParser.xmlParse(xsltApplyTemplates);
      const html: string = await xsltClass.xsltProcess(xml, xslt);
      expect("ABC").assertEqual(html);
    })


    it('handles_global_variables', 0, async () => {
      const xsltGlobalVariables = `<xsl:stylesheet>
          <xsl:variable name="x" select="'x'"/>
          <xsl:variable name="y" select="'y'"/>
          <xsl:variable name="z">
            <xsl:text>z</xsl:text>
          </xsl:variable>
          <xsl:template match="/">
            <xsl:value-of select="$x"/>
            <xsl:value-of select="$z"/>
            <xsl:for-each select="//item">
              <xsl:value-of select="$y"/>
            </xsl:for-each>
          </xsl:template>
        </xsl:stylesheet>`;

      const xsltClass = new Xslt();
      const xmlParser = new XmlParser();
      const xml: XDocument = xmlParser.xmlParse(xmlString);
      const xslt: XDocument = xmlParser.xmlParse(xsltGlobalVariables);
      const html: string = await xsltClass.xsltProcess(xml, xslt);
      expect("xzyyy").assertEqual(html);
    })

    it('handles_top_level_output', 0, async () => {
      const xsltTopLevelOutput = `<xsl:stylesheet>
          <xsl:template match="/">
            <xsl:element name="x">
              <xsl:attribute name="y">
                <xsl:text>z</xsl:text>
              </xsl:attribute>
              <xsl:text>k</xsl:text>
            </xsl:element>
          </xsl:template>
        </xsl:stylesheet>`;

      const xsltClass = new Xslt();
      const xmlParser = new XmlParser();
      const xml: XDocument = xmlParser.xmlParse(xmlString);
      const xslt: XDocument = xmlParser.xmlParse(xsltTopLevelOutput);
      const html: string = await xsltClass.xsltProcess(xml, xslt);
      expect('<x y="z">k</x>').assertEqual(html);
    })

    it('handles_copy', 0, async () => {
      const xsltCopy = `<xsl:stylesheet>
          <xsl:template match="/">
            <xsl:for-each select="//item">
              <xsl:copy>
                <xsl:for-each select="@*|node()">
                  <xsl:copy/>
                </xsl:for-each>
              </xsl:copy>
            </xsl:for-each>
          </xsl:template>
        </xsl:stylesheet>`;

      const xsltClass = new Xslt();
      const xmlParser = new XmlParser();
      const xml: XDocument = xmlParser.xmlParse(xmlString);
      const xslt: XDocument = xmlParser.xmlParse(xsltCopy);
      const html: string = await xsltClass.xsltProcess(xml, xslt);
      expect('<item pos="2">A</item>' +
      '<item pos="3">B</item>' +
      '<item pos="1">C</item>').assertEqual(html);
    })
  })
}