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

import timers from 'timers/'

@Entry
@Component
struct Index {
  @State message: string = 'Hello World'
  testObj:ESObject= timers.every('1000ms')

  private getResourceString(res:Resource){
    return getContext().resourceManager.getStringSync(res.id)
  }

  build() {
    Row() {
      Column({space:20}) {
        Text(this.message)
          .fontSize(30)
          .fontWeight(FontWeight.Bold)

        Button($r("app.string.Test_the_many_interfaces"))
          .fontSize(30)
          .onClick(() => {
            this.message = JSON.stringify(timers.every('10h').time)
          })

        Button($r("app.string.Test_the_DO_interface"))
          .fontSize(30)
          .onClick(() => {
            clearInterval(0)
            this.testObj.stop()
            let count: number = 0
            this.message = this.getResourceString($r("app.string.Callbacks_every_second"))
            this.testObj.do(() => {
              count++
              this.message = this.getResourceString($r("app.string.The_do_interface_callback_called_section")) + count + this.getResourceString($r("app.string.times"))
            })
          })

        Button($r("app.string.Test_the_stop_interface"))
          .fontSize(30)
          .onClick(() => {
            clearInterval(0)
            this.testObj.stop()
            this.message = this.getResourceString($r("app.string.The_do_interface_has_stopped"))
          })


      }
      .width('100%')
    }
    .height('100%')
  }
}