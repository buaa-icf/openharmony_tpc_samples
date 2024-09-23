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

import { ExprContext, xmlParse, xpathParse, xsltProcess } from 'xslt-processor'
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
        Button('xmlParse:null')
          .width('90%')
          .height('100px')
          .onClick(() => {
            try {
              xmlParse(null);
            } catch (error) {
              this.printLog(this.getResourceString('Please_check_the_input_characters_and_catch_an_exception') + error);
            }
          })

        Button('xmlParse:undefined')
          .width('90%')
          .height('100px')
          .onClick(() => {
            try {
              xmlParse(undefined);
            } catch (error) {
              this.printLog(this.getResourceString('Please_check_the_input_characters_and_catch_an_exception') + error);
            }
          })

        Button($r('app.string.Special_characters'))
          .width('90%')
          .height('100px')
          .onClick(() => {
            try {
              xmlParse(this.getResourceString('The_content_contains_special_characters'));
            } catch (error) {
              this.printLog(this.getResourceString('Please_check_the_input_characters_and_catch_an_exception') + error);
            }
          })

        Button('xsltProcess:null')
          .width('90%')
          .height('100px')
          .onClick(() => {
            try {
              xsltProcess(null);
            } catch (error) {
              this.printLog(this.getResourceString('Please_check_the_input_characters_and_catch_an_exception') + error);
            }
          })

        Button('xsltProcess:undefined')
          .width('90%')
          .height('100px')
          .onClick(() => {
            try {
              xsltProcess(undefined);
            } catch (error) {
              this.printLog(this.getResourceString('Please_check_the_input_characters_and_catch_an_exception') + error);
            }
          })

        Button($r('app.string.XSLT_Process_Special_Characters'))
          .width('90%')
          .height('100px')
          .onClick(() => {
            try {
              xsltProcess(this.getResourceString('The_content_contains_special_characters'));
            } catch (error) {
              this.printLog(this.getResourceString('Please_check_the_input_characters_and_catch_an_exception') + error);
            }
          })

        Button('xpathParse:null')
          .width('90%')
          .height('100px')
          .onClick(() => {
            try {
              xpathParse(null);
            } catch (error) {
              this.printLog(this.getResourceString('Please_check_the_input_characters_and_catch_an_exception') + error);
            }
          })

        Button('xpathParse:undefined')
          .width('90%')
          .height('100px')
          .onClick(() => {
            try {
              xpathParse(undefined);
            } catch (error) {
              this.printLog(this.getResourceString('Please_check_the_input_characters_and_catch_an_exception') + error);
            }
          })

        Button($r('app.string.xpathParse'))
          .width('90%')
          .height('100px')
          .onClick(() => {
            try {
              xpathParse(this.getResourceString('The_content_contains'));
            } catch (error) {
              this.printLog(this.getResourceString('Please_check_the_input_characters_and_catch_an_exception') + error);
            }
          })

        Button($r('app.string.parse_xml'))
          .width('90%')
          .height('100px')
          .onClick(() => {
            const originXMLObj:xmlParse = xmlParse(this.originTextXML);
            this.printLog(this.getResourceString('The_original_XML_root_node_contains') + originXMLObj.childNodes[0].childNodes.length + this.getResourceString('Child_nodes'));
          })

        Button($r('app.string.XSLT_Transform_Text'))
          .width('90%')
          .height('100px')
          .onClick(() => {
            const originXMLObj:xmlParse = xmlParse(this.originTextXML);
            const originXSLObj:xmlParse = xmlParse(this.originTextXSL);
            const text:xsltProcess = xsltProcess(originXMLObj, originXSLObj);
            this.printLog(text);
          })

        Button($r('app.string.XSLT_Transform_HTML'))
          .width('90%')
          .height('100px')
          .onClick(() => {
            const originXMLObj:xmlParse = xmlParse(this.originHTMLXML);
            const originXSLObj:xmlParse = xmlParse(this.originHTMLXSL);
            const html:xsltProcess = xsltProcess(originXMLObj, originXSLObj);
            this.printLog(html);
          })

        Button($r('app.string.XSLT_transformation_with_parameters'))
          .width('90%')
          .height('100px')
          .onClick(() => {
            const xmlString =
              `<root>
                <test name="test1"/>
               </root> `;
            const xml1:xmlParse = xmlParse(xmlString);
            const xml2:xmlParse = xmlParse(this.variablesXSLTString);
            const outXmlString:xsltProcess = xsltProcess(xml1, xml2,
              {
                test: "hugo"
              }
            );
            this.printLog(outXmlString);
          })

        Button($r('app.string.Xpath_calculation_expression_page'))
          .width('90%')
          .height('100px')
          .onClick(() => {
            const xpathExpr = '/page'
            const expr1:xpathParse = xpathParse(xpathExpr);
            const ctx:ExprContext = new ExprContext(xmlParse(this.xpathXML));
            const e:xpathParse = expr1.evaluate(ctx);
            const nodeSet:xpathParse = e.nodeSetValue();
            this.printLog(this.getResourceString('The_number_of_page_nodes_in_the_XML_document_is') + nodeSet.length);
          })

        Button($r('app.string.Xpath_calculation_expression_page_location_lat'))
          .width('90%')
          .height('100px')
          .onClick(() => {
            const locationParam = 'location'
            const latParam = 'lat'
            const xpathExpr = `/page/${locationParam}/@${latParam}`
            const expr1:xpathParse = xpathParse(xpathExpr);
            const ctx:ExprContext = new ExprContext(xmlParse(this.xpathXML));
            const result:xpathParse = expr1.evaluate(ctx);
            const nodeSet:xpathParse = result.nodeSetValue();
            this.printLog(this.getResourceString('The_current_node_attribute_is') + nodeSet[0].nodeName + "=" + nodeSet[0].nodeValue);
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