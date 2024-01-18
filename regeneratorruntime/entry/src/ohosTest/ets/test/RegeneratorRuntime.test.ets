/**
 * MIT License
 *
 * Copyright (c) 2023 Huawei Device Co., Ltd. All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:

 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.

 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import regeneratorRuntime from "regenerator-runtime";

import { describe, expect, it } from '@ohos/hypium'
import {next,normalFun,foo} from "./Utils.test"

export default function RegeneratorRuntime() {
  describe("regeneratorRuntime", () => {

    it("should_have", 0, () => {
      expect(regeneratorRuntime.wrap instanceof Function).assertTrue()
    });

    it("mark_method", 0, () => {
      expect(regeneratorRuntime.mark instanceof Function).assertTrue();
    });

    it("isGeneratorFunction", 0, () => {
      let genFun2: undefined | Function = next().value;
      expect(!regeneratorRuntime.isGeneratorFunction(foo())).assertTrue();
    })

    it("normalFun", 0, () => {
      let genFun2: undefined | Function = next().value;
      expect(regeneratorRuntime.isGeneratorFunction(normalFun())).assertFalse()
    })

    it("values", 0, () => {
      let arrayDelegate:Number[] = [3, 4];
      let getProto = Object.getPrototypeOf
      let arrayDelegateNew:ESObject = getProto(getProto(regeneratorRuntime.values(arrayDelegate)))
      expect(arrayDelegateNew.return instanceof Function).assertTrue();
    })

    it("next", 0, () => {
      let arrayDelegate:Number[] = [];
      let getProto = Object.getPrototypeOf
      let arrayDelegateNew:ESObject = getProto(getProto(regeneratorRuntime.values(arrayDelegate)))
      expect(arrayDelegateNew.next instanceof Function).assertTrue();
    })

  })

}

