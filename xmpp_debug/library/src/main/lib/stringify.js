/**
 * Copyright (C) 2024 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 * */


import { escapeXML, escapeXMLText } from "@ohos/xmpp_xml/src/main/ltx/escape";

export default function stringify(el, indent, level) {
  if (typeof indent === "number") indent = " ".repeat(indent);
  if (!level) level = 1;
  let s = `<${el.name}`;

  for (const k in el.attrs) {
    const v = el.attrs[k];
    // === null || undefined
    if (v != null) {
      s += ` ${k}="${escapeXML(typeof v === "string" ? v : v.toString(10))}"`;
    }
  }

  if (el.children.length > 0) {
    s += ">";
    for (const child of el.children) {
      if (child == null) continue;
      if (indent) s += "\n" + indent.repeat(level);
      s +=
        typeof child === "string"
          ? escapeXMLText(child)
          : stringify(child, indent, level + 1);
    }
    if (indent) s += "\n" + indent.repeat(level - 1);
    s += `</${el.name}>`;
  } else {
    s += "/>";
  }

  return s;
}
