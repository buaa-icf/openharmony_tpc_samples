/*
 * MIT License
 *
 * Copyright (C) 2024 Huawei Device Co., Ltd.
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

let tempValue:string

export function setData(value: string, controller: CustomDialogController) {
  tempValue = value
  controller.open()
}

@CustomDialog
export struct CustomDialogExample {
  controller?: CustomDialogController

  build() {
    Column() {
      Text('测试结果').fontSize(20).margin({ top: 10, bottom: 10 })
      Text(tempValue).fontSize(20).margin({ top: 10, bottom: 10 })
      Button('确定')
        .onClick(() => {
          if (this.controller != undefined) {
            this.controller.close()
          }
        })
        .backgroundColor(0xffffff)
        .fontSize(20)
        .fontColor(Color.Red)
        .margin({ bottom: 10 })
    }
  }
}