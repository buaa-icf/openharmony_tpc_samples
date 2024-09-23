/**
 * ISC License
 * Copyright (C) 2024 Huawei Device Co., Ltd.
 *
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
 * REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
 * INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
 * LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE
 * OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
 * PERFORMANCE OF THIS SOFTWARE.
 * */


import {Parser,Element} from "@ohos/xmpp_xml"
@Entry
@Component
struct Index {
  @State start: string = '';
  @State element: string = '';
  @State end: string = '';

  getResourceString(res: Resource) {
    return getContext().resourceManager.getStringSync(res.id)
  }
  private parser:ESObject =new Parser();
  build() {
    Row() {
      Column() {
        Text(this.getResourceString($r('app.string.Analyze_start'))+this.start)
          .fontSize(30)
        Text(this.getResourceString($r('app.string.Analyze_element'))+this.element)
          .fontSize(30)
        Text(this.getResourceString($r('app.string.Analyze_end'))+this.end)
          .fontSize(30)
        Button($r('app.string.Analyze'))
          .fontSize(40)
          .fontWeight(FontWeight.Bold)
          .onClick(()=>{
            this.parser.on("start",(el:Element)=>{
                this.start = el.toString()
              })
            this.parser.on("element",(el:Element)=>{
              this.element = el.toString()
            })
            this.parser.on("end",(el:Element)=>{
              this.end=el.toString()
            })
            this.parser.write("<foo><bar>hello</bar></foo>");
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}