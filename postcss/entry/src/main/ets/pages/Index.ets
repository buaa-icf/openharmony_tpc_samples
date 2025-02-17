/**
 * MIT License
 *
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the 'Software'), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to all conditions.
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import { postcss, CSSParser } from '@ohos/postcss';
import common from '@ohos.app.ability.common';

@Entry
@Component
struct Index {
  @State cssFileContent: string = 'CSS File Content';
  @State propertyValueMessage: string = 'PropertyValue';
  @State selectorMessage: string = 'Selector';
  @State mediaMessage: string = 'Media';
  @State ruleMessage: string = 'Rule Message';
  @State declarationMessage: string = 'Declaration';
  @State parentSheetMessage: string = 'Get Parent Sheet';
  @State setParentSheetMessage: string = 'Set Parent Sheet Message';
  @State getParentSheetMessage: string = 'Get Parent Sheet Message';
  @State cssStyle: string = `
      body {
        background-color: '#fff';
        color: black;
      }
      @media screen and (max-width: 768px) {
          .container {
              width: 100%;
          }
          aside {
              width: 80%;
              float: none;
          }
      }
      @media print and (max-width: 600px) {
        h6 {
          font-size: 14px;
        }
     }
     .root{
        font-size: 1rem;
        margin: 2rem;
        padding: 0.5rem;
        border-radius: 50%;
      }
       #bar{
        color: red;
        border-radius: 5px;
      }
    `;
  @State cssInsertTest: string = `
      .box {
        z-index: 10;
      }
    `;

  build() {
    List() {
      ListItem() {
        Button('parseStyleSheet')
          .fontSize(16)
          .width(180)
          .onClick((e: ClickEvent) => {
            this.cssFileContent = this.readFile("style.css");
          })

      }

      ListItem() {
        TextArea({ text: this.cssFileContent })
          .fontSize(20)
          .padding(10)
          .width('100%')
          .height(100)
      }

      ListItem() {
        Button('propertyValue')
          .fontSize(16)
          .width(180)
          .onClick((e: ClickEvent) => {
            this.propertyValueMessage = this.propertyValueTest();
          })

      }

      ListItem() {
        TextArea({ text: this.propertyValueMessage })
          .fontSize(20)
          .padding(10)
          .height(50)
      }

      ListItem() {
        Button('selector')
          .fontSize(16)
          .width(180)
          .onClick((e: ClickEvent) => {
            this.selectorMessage = this.selectorTest();
          })
      }

      ListItem() {
        TextArea({ text: this.selectorMessage })
          .fontSize(20)
          .padding(10)
          .height(100)
      }

      ListItem() {
        Button('media')
          .fontSize(16)
          .width(180)
          .onClick((e: ClickEvent) => {
            this.mediaMessage = this.mediaTest();
          })
      }

      ListItem() {
        TextArea({ text: this.mediaMessage })
          .fontSize(20)
          .padding(10)
          .height(100)
      }

      ListItem() {
        Button('Rule')
          .fontSize(16)
          .width(180)
          .onClick((e: ClickEvent) => {
            this.RuleTest();
          })
      }

      ListItem() {
        TextArea({ text: this.ruleMessage })
          .fontSize(20)
          .padding(10)
          .height(100)
      }

      ListItem() {
        Button('Declaration')
          .fontSize(16)
          .width(180)
          .onClick((e: ClickEvent) => {
            this.declarationTest();
          })
      }

      ListItem() {
        TextArea({ text: this.declarationMessage })
          .fontSize(20)
          .padding(10)
          .height(100)
      }

      ListItem() {
        Button('SetParentStyleSheet')
          .fontSize(16)
          .width(180)
          .onClick((e: ClickEvent) => {
            this.setParentSheet(this.cssStyle);
          })
      }

      ListItem() {
        TextArea({ text: this.setParentSheetMessage })
          .fontSize(20)
          .padding(10)
          .height(100)
      }

      ListItem() {
        Button('GetParentStyleSheet')
          .fontSize(16)
          .width(180)
          .onClick((e: ClickEvent) => {
            this.getParentSheet();
          })
      }

      ListItem() {
        TextArea({ text: this.getParentSheetMessage })
          .fontSize(20)
          .padding(10)
          .height(100)
      }
    }
    .height('100%')
    .width('100%')

  }

  readFile(path: string) {
    let context = getContext(this) as common.UIAbilityContext;
    let cssStr = context.resourceManager.getRawFileContentSync(path);
    let retStr = CSSParser.readFile(cssStr);
    return retStr
  }

  propertyValueTest(): string {
    let result = postcss().process(this.cssStyle);
    let valueList = CSSParser.getValueByProperty(result.root, 'width');
    this.propertyValueMessage = `prop: width; valueList: ${valueList}`
    return this.propertyValueMessage;
  }

  selectorTest(): string {
    let result = postcss().process(this.cssStyle);
    let selectorList = CSSParser.getSelectorList(result.root);
    this.selectorMessage = `selectorList: ${selectorList}`
    return this.selectorMessage;
  }

  mediaTest(): string {
    let result = postcss().process(this.cssStyle);
    let mediaList = CSSParser.getMediaList(result.root);
    this.mediaMessage = `mediaList: ${mediaList}`
    return this.mediaMessage;
  }

  RuleTest() {
    postcss().process(this.cssStyle, {}).then(result => {
      let rule = result.root;
      let rule0 = rule.first;
      let insertAfterRule = rule.insertAfter(rule0, this.cssInsertTest);
      let index = rule.index(result.root.nodes.length);
      let replaceValuesRule = rule.replaceValues(/\d+rem/, { fast: 'rem' }, string => {
        return 15 * parseInt(string) + 'px'
      })
      let ruleLast = rule.last;
      let pushRule = rule.removeChild(ruleLast);

      this.ruleMessage =
        `---first rule---: ${'\n'} ${rule0} ${'\n'} ---index---: ${'\n'} ${index} ${'\n'} ---insertAfter---: ${'\n'} ${insertAfterRule} ${'\n'}
      ---replaceValues---: ${'\n'} ${replaceValuesRule} ${'\n'} ---pushRule---: ${'\n'} ${pushRule}`
      return this.ruleMessage;
    })
  }

  declarationTest() {
    let decl = 'width: 10px;'
    let declarationList = CSSParser.getStyleDeclaration(decl);
    this.declarationMessage = `declarationList: ${declarationList}`
    return this.declarationMessage;
  }

  setParentSheet(parentStyleSheet: string) {
    CSSParser.setParentStyleSheet(parentStyleSheet);
    this.setParentSheetMessage = parentStyleSheet;
    return this.setParentSheetMessage;
  }

  getParentSheet() {
    this.getParentSheetMessage = CSSParser.getParentStyleSheet();
    return this.getParentSheetMessage;
  }
}

