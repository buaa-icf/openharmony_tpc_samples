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

import * as CSSselect from 'css-select';
import { parseDOM } from '@ohos/htmlparser2';
import type { Element } from 'domhandler';
import boolbase from 'boolbase';
import { AttributeAction, parse, SelectorType } from 'css-what';

const dom = parseDOM("<div id=foo><p>foo</p></div>") as Element[];
const notYet = "not yet supported by css-select";

function Compile(): string {
  try {
    CSSselect.compile("[foo|bar]")
  } catch (e) {
    return e.message;
  }
  return "[foo|bar]";
}

@Entry
@Component
struct Index {
  getResourceString(res: Resource) {
    return getContext().resourceManager.getStringSync(res.id)
  }

  build() {
    RelativeContainer() {
      Column() {
        Text((this.getResourceString($r('app.string.selectAll'))) + CSSselect.selectAll(":matches(> p)", dom)[0].name)
          .fontSize(20)
        Text((this.getResourceString($r('app.string.selectOne'))) +
          CSSselect.selectOne(":contains(foo)", [dom[0]], { quirksMode: true })?.name)
          .fontSize(20)
        Text((this.getResourceString($r('app.string.compile'))) + Compile() + " == " + notYet)
          .fontSize(20)
        Text((this.getResourceString($r('app.string.is'))) +
        CSSselect.is(dom[0], (elem) => elem.attribs["id"] === "foo"))
          .fontSize(20)
        Text((this.getResourceString($r('app.string.is'))) +
        CSSselect.is(dom[0], [
          [
            {
              type: SelectorType.Attribute,
              action: AttributeAction.Equals,
              ignoreCase: false,
              name: "id",
              namespace: null,
              value: "213",
            },
          ],
        ]))
          .fontSize(20)
      }
    }
    .height('100%')
    .width('100%')
  }
}