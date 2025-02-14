/*
 * MIT License
 *
 * Copyright (C) 2025 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

import Expression from "expr-parser";
import hilog from '@ohos.hilog';

@Entry
@Component
struct Index {
  private getErr(str: string): string {
    let msg: string = '';
    try {
      new Expression(str).parse();
    } catch (err) {
      msg = err.message;
    }
    return msg;
  }

  build() {
    RelativeContainer() {
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
        Button($r('app.string.parseOperators'), { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .width("60%")
          .height("10%")
          .margin({
            left: "20%",
            right: "20%",
            top: "2%",
            bottom: "2%"
          })
          .onClick(() => {
            let expr: Function = new Expression('a.value + 12 - (2 * 14 / 4)').parse();
            class Num {
              value: number = 0;
            }
            let res1: number = expr({ a: { value: 1 } as Num }); // 6
            let res2: number = expr({ a: { value: 3 } as Num }); // 8
            hilog.info(0x0001, "expr-parser TEST:", "value = 1 result: %{public}d", res1);
            hilog.info(0x0001, "expr-parser TEST:", "value = 3 result: %{public}d", res2);
          })
        Button($r('app.string.parseArray'), { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .width("60%")
          .height("10%")
          .margin({
            left: "20%",
            right: "20%",
            top: "2%",
            bottom: "2%"
          })
          .onClick(() => {
            let expr: Function = new Expression('a.list[i + 1]').parse();
            class List {
              list: number[] = [];
            }
            let res1: number = expr({ a: { list: [0, 5, 10] } as List, i: 1 }); // 10
            let res2: number = expr({ a: { list: [0, 5, 10] } as List, i: 0 }); // 5
            hilog.info(0x0001, "expr-parser TEST:", "result1: %{public}d", res1);
            hilog.info(0x0001, "expr-parser TEST:", "result2: %{public}d", res2);
          })
        Button($r('app.string.parseBool'), { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .width("60%")
          .height("10%")
          .margin({
            left: "20%",
            right: "20%",
            top: "2%",
            bottom: "2%"
          })
          .onClick(() => {
            let expr: Function = new Expression('a % b == 1 && c % d == 2 && e % f != 1').parse();
            let res: number = expr({ a: 21, b: 2, c: 8, d: 3, e: 3, f: 3 }); // true
            hilog.info(0x0001, "expr-parser TEST:", "result: %{public}s", res);
          })
        Button($r('app.string.parseNomal'), { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .width("60%")
          .height("10%")
          .margin({
            left: "20%",
            right: "20%",
            top: "2%",
            bottom: "2%"
          })
          .onClick(() => {
            let expr: Function = new Expression('"\\u2605haha"').parse();
            hilog.info(0x0001, "expr-parser TEST:", "result: %{public}s", expr({}));
          })
        Button($r('app.string.error'), { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .width("60%")
          .height("10%")
          .margin({
            left: "20%",
            right: "20%",
            top: "2%",
            bottom: "2%"
          })
          .onClick(() => {
            let res1 = this.getErr('{ ;a: 123 }'); // parse expression error: { ;a: 123 }
            let res2 = this.getErr(';'); // parse expression error: ;
            hilog.info(0x0001, "expr-parser TEST:", "value = 1 result: %{public}s", res1);
            hilog.info(0x0001, "expr-parser TEST:", "value = 1 result: %{public}s", res2);
          })
      }
    }
    .height('100%')
    .width('100%')
  }
}