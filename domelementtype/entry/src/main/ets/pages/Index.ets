/**
 *
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { ElementType, isTag } from 'domelementtype'

@Entry
@Component
struct Index {
    private elementTypeTextList = ["ElementType.Root", "ElementType.Text", "ElementType.Directive",
        "ElementType.Comment", "ElementType.Script", "ElementType.Style",
        "ElementType.Tag", "ElementType.CDATA", "ElementType.Doctype"]
    private elementTypeList = [ElementType.Root, ElementType.Text, ElementType.Directive,
    ElementType.Comment, ElementType.Script, ElementType.Style,
    ElementType.Tag, ElementType.CDATA, ElementType.Doctype]
    private selectIndex = 0
    @State private result: string = ""
    getResourceString(res:Resource){
        return getContext().resourceManager.getStringSync(res.id)
    }
    build() {
        Row() {
            Column() {
                TextPicker({ range: this.elementTypeTextList, selected: this.selectIndex })
                    .height("40%")
                    .width("50%")
                    .onChange((value: ESObject, index: ESObject) => {
                        if (this.selectIndex == index) {
                            return
                        }
                        this.selectIndex = index
                    })

                Button($r('app.string.Check_if'))
                    .fontSize(20)
                    .margin({ top: "80px" })
                    .fontWeight(FontWeight.Bold)
                    .onClick(event => {
                        let result = isTag({ type:
                        this.elementTypeList[this.selectIndex] })
                        this.result = result + ""

                    })

                Text(this.getResourceString($r('app.string.result')) + this.result)
                    .fontSize(20)
                    .fontWeight(FontWeight.Bold)
                    .margin({ top: "30px" })
            }
            .width('100%')
        }
        .height('100%')
    }
}