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

import {
    decode,
    decodeHTML,
    decodeHTMLStrict,
    decodeXML,
    encode,
    encodeHTML,
    encodeNonAsciiHTML,
    encodeXML,
    EntityLevel,
    escapeUTF8,
    decodeHTMLAttribute,
    escapeAttribute,
    escapeText
} from 'entities';
import Prompt from '@system.prompt';

@Entry
@Component
struct Index {
    build() {
        Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start }) {
            List({ initialIndex: 0 }) {
                ListItem() {
                    Button($r('app.string.encode'), { type: ButtonType.Normal })
                        .fontSize(18)
                        .fontColor('#000')
                        .height(50)
                        .width(300)
                        .margin({ top: 10 })
                        .backgroundColor('#ffd0cabe')
                        .onClick(async () => {
                            let result = encode("&#38; ü", EntityLevel.HTML)
                            Prompt.showToast({ message: result, duration: 3000 })
                        })
                }

                ListItem() {
                    Button($r('app.string.encodeNoOptions'), { type: ButtonType.Normal })
                        .fontSize(18)
                        .fontColor('#000')
                        .height(50)
                        .width(300)
                        .margin({ top: 10 })
                        .backgroundColor('#ffd0cabe')
                        .onClick(async () => {
                            let result = encode("&#38; ü")
                            Prompt.showToast({ message: result, duration: 3000 })
                        })
                }

                ListItem() {
                    Button($r('app.string.encodeXML'), { type: ButtonType.Normal })
                        .fontSize(18)
                        .fontColor('#000')
                        .height(50)
                        .width(300)
                        .margin({ top: 10 })
                        .backgroundColor('#ffd0cabe')
                        .onClick(async () => {
                            let result = encodeXML("&#38; ü")
                            Prompt.showToast({ message: result, duration: 3000 })
                        })
                }

                ListItem() {
                    Button($r('app.string.encodeHTML'), { type: ButtonType.Normal })
                        .fontSize(18)
                        .fontColor('#000')
                        .height(50)
                        .width(300)
                        .margin({ top: 10 })
                        .backgroundColor('#ffd0cabe')
                        .onClick(async () => {
                            let result = encodeHTML("&#38; ü")
                            Prompt.showToast({ message: result, duration: 3000 })
                        })
                }

                ListItem() {
                    Button($r('app.string.encodeNonAsciiHTML'), { type: ButtonType.Normal })
                        .fontSize(18)
                        .fontColor('#000')
                        .height(50)
                        .width(300)
                        .margin({ top: 10 })
                        .backgroundColor('#ffd0cabe')
                        .onClick(async () => {
                            let result = encodeNonAsciiHTML("&#38; ü")
                            Prompt.showToast({ message: result, duration: 3000 })
                        })
                }

                ListItem() {
                    Button($r('app.string.decode'), { type: ButtonType.Normal })
                        .fontSize(18)
                        .fontColor('#000')
                        .height(50)
                        .width(300)
                        .margin({ top: 10 })
                        .backgroundColor('#ffd0cabe')
                        .onClick(async () => {
                            let result = decode("asdf &amp; &#xFF; &#xFC; &apos;", EntityLevel.HTML)
                            Prompt.showToast({ message: result, duration: 3000 })
                        })
                }

                ListItem() {
                    Button($r('app.string.decodeHTMLAttribute'), { type: ButtonType.Normal })
                        .fontSize(18)
                        .fontColor('#000')
                        .height(50)
                        .width(300)
                        .margin({ top: 10 })
                        .backgroundColor('#ffd0cabe')
                        .onClick(async () => {
                            let result = decodeHTMLAttribute("asdf &amp; &#xFF; &#xFC; &apos;")
                            Prompt.showToast({ message: result, duration: 3000 })
                        })
                }

                ListItem() {
                    Button($r('app.string.decodeNoOption'), { type: ButtonType.Normal })
                        .fontSize(18)
                        .fontColor('#000')
                        .height(50)
                        .width(300)
                        .margin({ top: 10 })
                        .backgroundColor('#ffd0cabe')
                        .onClick(async () => {
                            let result = decode("asdf &amp; &#xFF; &#xFC; &apos;")
                            Prompt.showToast({ message: result, duration: 3000 })
                        })
                }

                ListItem() {
                    Button($r('app.string.decodeXML'), { type: ButtonType.Normal })
                        .fontSize(18)
                        .fontColor('#000')
                        .height(50)
                        .width(300)
                        .margin({ top: 10 })
                        .backgroundColor('#ffd0cabe')
                        .onClick(async () => {
                            let result = decodeXML("asdf &amp; &#xFF; &#xFC; &apos;")
                            Prompt.showToast({ message: result, duration: 3000 })
                        })
                }

                ListItem() {
                    Button($r('app.string.decodeHTML'), { type: ButtonType.Normal })
                        .fontSize(18)
                        .fontColor('#000')
                        .height(50)
                        .width(300)
                        .margin({ top: 10 })
                        .backgroundColor('#ffd0cabe')
                        .onClick(async () => {
                            let result = decodeHTML("asdf &amp; &#xFF; &#xFC; &apos;")
                            Prompt.showToast({ message: result, duration: 3000 })
                        })
                }

                ListItem() {
                    Button($r('app.string.decodeHTMLStrict'), { type: ButtonType.Normal })
                        .fontSize(18)
                        .fontColor('#000')
                        .height(50)
                        .width(300)
                        .margin({ top: 10 })
                        .backgroundColor('#ffd0cabe')
                        .onClick(async () => {
                            let result = decodeHTMLStrict("asdf &amp; &#xFF")
                            Prompt.showToast({ message: result, duration: 3000 })
                        })
                }

                ListItem() {
                    Button($r('app.string.escapeUTF8'), { type: ButtonType.Normal })
                        .fontSize(18)
                        .fontColor('#000')
                        .height(50)
                        .width(300)
                        .margin({ top: 10 })
                        .backgroundColor('#ffd0cabe')
                        .onClick(async () => {
                            let result = escapeUTF8("(&>)")
                            Prompt.showToast({ message: result, duration: 3000 })
                        })
                }

                ListItem() {
                    Button($r('app.string.escapeAttribute'), { type: ButtonType.Normal })
                        .fontSize(18)
                        .fontColor('#000')
                        .height(50)
                        .width(300)
                        .margin({ top: 10 })
                        .backgroundColor('#ffd0cabe')
                        .onClick(async () => {
                            let result = escapeAttribute("(&>)")
                            Prompt.showToast({ message: result, duration: 3000 })
                        })
                }

                ListItem() {
                    Button($r('app.string.escapeText'), { type: ButtonType.Normal })
                        .fontSize(18)
                        .fontColor('#000')
                        .height(50)
                        .width(300)
                        .margin({ top: 10 })
                        .backgroundColor('#ffd0cabe')
                        .onClick(async () => {
                            let result = escapeText("(&>)")
                            Prompt.showToast({ message: result, duration: 3000 })
                        })
                }
            }
        }
    }
}