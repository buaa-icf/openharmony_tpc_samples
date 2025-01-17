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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { CSSParser, postcss } from '@ohos/postcss';
import GlobalContext from './GlobalContext';

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
    it('cssParser01', 0, () => {
      let context = GlobalContext.getContext().getValue('context') as Context;
      let cssStr = context.resourceManager.getRawFileContentSync('parent.css');
      let returnValue = CSSParser.readFile(cssStr);
      expect(returnValue).assertContain('margin');
    })
    it('cssParser02', 0, () => {
      let css: string = `
        .box {
          z-index: 10;
        }
      `;
      let result = postcss().process(css);
      let valueList = CSSParser.getValueByProperty(result.root, 'z-index');
      expect('10').assertEqual(valueList[0]);
    })
    it('cssParser03', 0, () => {
      let css: string = `
        .box {
          z-index: 10;
        }
      `;
      let result = postcss().process(css);
      let selectorList = CSSParser.getSelectorList(result.root);
      expect('.box').assertEqual(selectorList[0]);
    })
    it('cssParser04', 0, () => {
      let css: string = `
        @media print and (max-width: 600px) {
          h6 {
            font-size: 14px;
          }
      }
    `;
      let result = postcss().process(css);
      let mediaList = CSSParser.getMediaList(result.root);
      expect('print and (max-width: 600px)').assertEqual(mediaList[0]);
    })
    it('cssParser05', 0, () => {
      let css: string = `
        body {
          background-color: #f4f4f4;
        }
        h1 {
          margin: 1rem;
          box-sizing: border-box;
        }
      `;
      let cssInsertTest: string = `
        .box {
            z-index: 10;
        }
      `;
      postcss().process(css, {}).then(result => {
        let rule = result.root;
        let rule0 = rule.first;
        rule.insertAfter(rule0, cssInsertTest);
        let index = rule.index(result.root.nodes.length);
        expect(3).assertEqual(index);
        rule.replaceValues(/\d+rem/, {
          fast: 'rem'
        }, string => {
          return 15 * parseInt(string) + 'px'
        })
        let ruleLast = rule.last;
        rule.removeChild(ruleLast);
        let index1 = rule.index(result.root.nodes.length);
        expect(2).assertEqual(index1);
      })
    })
    it('cssParser06', 0, () => {
      let decl = 'width: 10px;';
      let declarationList = CSSParser.getStyleDeclaration(decl);
      expect('width: 10px;').assertEqual(declarationList);
    })
  })
}