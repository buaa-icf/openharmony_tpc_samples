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
 * Neither the name of the copyright holder nor the names of its
 * contributors may be used to endorse or promote products derived from this
 * software without specific prior written permission
 *
 * THIS IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS,
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import path from "@protobufjs/path"

@Entry
@Component
struct Index {
    @State result: string = '';
    @State isAbsoluteText: string = 'X:\\some\\path\\file.js';
    @State normalText: string = 'X:\\some\\..\\.\\path\\\\file.js';
    @State resolveText1: string = '/path/origin.js';
    @State resolveText2: string = '/some/.././path//file.js';

    build() {
        Scroll() {
            Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
                TextInput({ text: this.isAbsoluteText, placeholder: 'input your word...' })
                    .placeholderColor(Color.Grey)
                    .placeholderFont({ size: 14, weight: 400 })
                    .caretColor(Color.Blue)
                    .width(200)
                    .height(40)
                    .margin({top:10})
                    .fontSize(16)
                    .textAlign(TextAlign.Center)
                    .fontColor(Color.Black)
                    .onChange((value: string) => {
                        this.isAbsoluteText = value
                    })

                Button('isAbsolute')
                    .fontSize(25)
                    .margin(15)
                    .height(46)
                    .fontWeight(FontWeight.Bold)
                    .onClick(() => {
                        this.result = ""
                        this.result = "" + path.isAbsolute(this.isAbsoluteText)
                    })
                TextInput({ text: this.normalText, placeholder: 'input your word...' })
                    .placeholderColor(Color.Grey)
                    .placeholderFont({ size: 14, weight: 400 })
                    .caretColor(Color.Blue)
                    .width(200)
                    .height(40)
                    .margin({top:10})
                    .fontSize(16)
                    .textAlign(TextAlign.Center)
                    .fontColor(Color.Black)
                    .onChange((value: string) => {
                        this.normalText = value
                    })

                Button('normalize')
                    .fontSize(25)
                    .margin(15)
                    .height(46)
                    .fontWeight(FontWeight.Bold)
                    .onClick(() => {
                        this.result = ""
                        this.result = "" + path.normalize(this.normalText)
                    })
                Divider().vertical(true).height(22).color('#182431').opacity(0.6).margin({ left: 8, right: 8 })
                TextInput({ text: this.resolveText1, placeholder: 'input your word...' })
                    .placeholderColor(Color.Grey)
                    .placeholderFont({ size: 14, weight: 400 })
                    .caretColor(Color.Blue)
                    .width(200)
                    .height(40)
                    .margin({top:10})
                    .fontSize(16)
                    .textAlign(TextAlign.Center)
                    .fontColor(Color.Black)
                    .onChange((value: string) => {
                        this.resolveText1 = value
                    })

                TextInput({ text: this.resolveText2, placeholder: 'input your word...' })
                    .placeholderColor(Color.Grey)
                    .placeholderFont({ size: 14, weight: 400 })
                    .caretColor(Color.Blue)
                    .width(200)
                    .height(40)
                    .margin({top:10})
                    .fontSize(16)
                    .textAlign(TextAlign.Center)
                    .fontColor(Color.Black)
                    .onChange((value: string) => {
                        this.resolveText2 = value
                    })
                Button('resolve')
                    .fontSize(25)
                    .margin(15)
                    .fontWeight(FontWeight.Bold)
                    .onClick(() => {
                        this.result = ""
                        this.result = "" + path.resolve(this.resolveText1, this.resolveText2)
                    })
                Text(this.result)
                    .fontSize(18)
            }
            .width('100%')
        }
    }
}