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

import postcss from "./postcss";
import { util } from '@kit.ArkTS';

class CSSParser {
  static parentStyleSheet_: string;

  constructor() {

  }

  static readFile(cssStr: Uint8Array) {
    let textDecoderOptions: util.TextDecoderOptions = {
      fatal: false,
      ignoreBOM: true
    }
    let decodeToStringOptions: util.DecodeWithStreamOptions = {
      stream: false
    }
    let textDecoder = util.TextDecoder.create('utf-8', textDecoderOptions);
    let retStr = textDecoder.decode(cssStr, { stream: false });
    return retStr;
  }

  static getValueByProperty(root: postcss.Document | postcss.Root, prop): Array<string> {
    let valueList = [];
    root.walkRules(rule => {
      rule.walkDecls(decl => {
        if (decl.prop == prop) {
          valueList.push(decl.value);
        }
      });
    });
    return valueList;
  }

  static getMediaList(root: postcss.Document | postcss.Root): Array<string> {
    let mediaList = [];
    root.walkAtRules('media', (rule) => {
      mediaList.push(rule.params);
    });
    return mediaList;
  }

  static getSelectorList(root: postcss.Document | postcss.Root): Array<string> {
    let selectorList = [];
    root.walkRules((rule: postcss.Rule) => {
      selectorList.push(rule.selector);
    });
    return selectorList;
  }

  static getStyleDeclaration(declaration): postcss.Declaration {
    let decl: postcss.Declaration;
    decl = declaration;
    return decl;
  }

  static setParentStyleSheet(parentStyleSheet){
    this.parentStyleSheet_ = parentStyleSheet;
  }
  static getParentStyleSheet(): string {
    return this.parentStyleSheet_;
  }
}

export { CSSParser }

export default CSSParser