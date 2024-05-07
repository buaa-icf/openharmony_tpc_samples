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

import { Element } from "./Element";

function append(el, child) {
  if (Array.isArray(child)) {
    for (const c of child) append(el, c);
    return;
  }

  if (child === "" || child == null || child === true || child === false) {
    return;
  }

  el.cnode(child);
}

/**
 * JSX compatible API, use this function as pragma
 * https://facebook.github.io/jsx/
 *
 * @param  {string} name  name of the element
 * @param  {object} attrs object of attribute key/value pairs
 * @return {Element}      Element
 */
 function createElement(name, attrs, ...children) {
  if (typeof attrs === "object" && attrs !== null) {
    // __self and __source are added by babel in development
    // https://github.com/facebook/react/pull/4596
    // https://babeljs.io/docs/en/babel-preset-react#development
    // https://babeljs.io/docs/en/babel-plugin-transform-react-jsx-source
    delete attrs.__source;
    delete attrs.__self;

    for (const [key, value] of Object.entries(attrs)) {
      if (value == null) delete attrs[key];
      else attrs[key] = value.toString(10);
    }
  }

  const el = new Element(name, attrs);

  for (const child of children) {
    append(el, child);
  }

  return el;
}
export {createElement}
