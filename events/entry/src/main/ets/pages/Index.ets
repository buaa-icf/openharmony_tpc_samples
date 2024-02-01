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

import * as events from 'events/'

@Entry
@Component
struct Index {
  @State message: string = 'Hello World'
  count: number = 0
  messageCb = (text: string) => {
    this.message = 'message监听到的消息：' + text
  }

  event:ESObject

  aboutToAppear(){
    this.event = new events.EventEmitter();
  }




  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(25)

        Button('监听message消息')
          .fontSize(25)
          .onClick(() => {
            this.event.on('message', this.messageCb)
          })
        Button('向message发送一个消息')
          .fontSize(25)
          .onClick(() => {
            this.event.emit('message', '一个消息' + this.count)
            this.count++
          })
        Button('取消监听message消息 ')
          .fontSize(25)
          .onClick(() => {
            this.event.off('message', this.messageCb)
          })


      }
      .width('100%')
    }
    .height('100%')
  }
}