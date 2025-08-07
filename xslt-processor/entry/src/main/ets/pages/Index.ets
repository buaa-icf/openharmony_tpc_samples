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

import { ExprContext, XmlParser, Xslt } from 'xslt-processor'
import promptAction from '@ohos.promptAction';
import hilog from '@ohos.hilog';

@Entry
@Component
struct Index {
  private tag: string = 'xslt-processor demo';
  private originTextXML: string =
    '<all>' +
    '<item pos="2">A 三方库组件 Ba bộ phận thư viện</item>' +
    '<item pos="3">B مكونات مستودع ثلاثية</item>' +
    '<item pos="1">C ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789</item>' +
    '</all>';
  private originTextXSL: string =
    '<xsl:stylesheet>' +
    '<xsl:template match="/">' +
    '<xsl:for-each select="//item">' +
    '<xsl:sort select="@pos"/>' +
    '<xsl:value-of select="."/>' +
    '</xsl:for-each>' +
    '</xsl:template>' +
    '</xsl:stylesheet>';
  private originHTMLXML: string =
    ` <?xml version="1.0" encoding="ISO-8859-1"?>
     <?xml-stylesheet type="text/xsl" href="cdcatalog.xsl"?>
     <catalog>
     <cd>
     <title>Empire Burlesque 三方库组件 Ba bộ phận thư viện</title>
     <artist>Bob Dylan مكونات مستودع ثلاثية ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789</artist>
     <country>USA</country>
     <company>Columbia</company>
     <price>10.90</price>
     <year>1985</year>
     </cd>
     .
     .
     </catalog>`;
  private originHTMLXSL: string =
    ` <?xml version="1.0" encoding="ISO-8859-1"?>

    <xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:template match="/">
    <html>
    <body>
    <h2>My CD Collection</h2>
    <table border="1">
    <tr bgcolor="#9acd32">
    <th>Title</th>
    <th>Artist</th>
    </tr>
    <xsl:for-each select="catalog/cd">
    <tr>
    <td><xsl:value-of select="title"/></td>
    <td><xsl:value-of select="artist"/></td>
    </tr>
    </xsl:for-each>
    </table>
    </body>
    </html>
    </xsl:template>

    </xsl:stylesheet> `;
  private variablesXSLTString = `<?xml version="1.0"?>
      <xsl:stylesheet version="1.0">
        <xsl:template match="test">
          <span> <xsl:value-of select="$test" /> </span>
        </xsl:template>
        <xsl:template match="root">
          <xsl:element name="{local-name()}">
            <xsl:apply-templates select="test"/>
          </xsl:element>
        </xsl:template>
        <xsl:template match="/">
          <xsl:apply-templates select="root"/>
        </xsl:template>
      </xsl:stylesheet>`;
  private xpathXML = [
    '<page>',
    '<request>',
    '<q>new york</q>',
    '</request>',
    '<location lat="100" lon="200"/>',
    '</page>'
  ].join('');

  build() {
    Row() {
      Column({ space: 5 }) {
        Button($r('app.string.XSLT_Transform_Text'))
          .width('90%')
          .height('100px')
          .onClick(async () => {
            let xslt: Xslt = new Xslt();
            let xmlParser: XmlParser = new XmlParser();
            const outXmlString = await xslt.xsltProcess(
              xmlParser.xmlParse(this.originTextXML),
              xmlParser.xmlParse(this.originTextXSL)
            );
            this.printLog(outXmlString);
          })

        Button($r('app.string.XSLT_Transform_HTML'))
          .width('90%')
          .height('100px')
          .onClick(async () => {
            let xslt: Xslt = new Xslt();
            let xmlParser: XmlParser = new XmlParser();
            const outXmlString = await xslt.xsltProcess(
              xmlParser.xmlParse(this.originHTMLXML),
              xmlParser.xmlParse(this.originHTMLXSL)
            );
            this.printLog(outXmlString);
          })
      }
      .width('100%')
    }
    .height('100%')
  }

  private printLog(msg: string) {
    hilog.info(0x0000, this.tag, '%{public}s', msg);
    promptAction.showToast({ message: msg })
  }

  getResourceString(resourceName:string) {
    return getContext().resourceManager.getStringByNameSync(resourceName)
  }
}