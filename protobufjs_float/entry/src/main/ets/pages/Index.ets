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

import {
    writeFloatBE,
    writeFloatLE,
    writeDoubleLE,
    writeDoubleBE,
    readFloatLE,
    readFloatBE,
    readDoubleLE,
    readDoubleBE
} from "@protobufjs/float"

@Entry
@Component
struct Index {
    @State result: string = '';

    build() {
        Scroll() {
            Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
                Button('writeFloatLE')
                    .fontSize(25)
                    .margin(15)
                    .height(46)
                    .fontWeight(FontWeight.Bold)
                    .onClick(() => {
                        this.result = ""
                        const value = 3.14159;
                        const buffer = new Uint8Array(4)
                        writeFloatLE(value, buffer, 0);
                        this.result = JSON.stringify(buffer)
                    })

                Button('writeFloatBE')
                    .fontSize(25)
                    .margin(15)
                    .height(46)
                    .fontWeight(FontWeight.Bold)
                    .onClick(() => {
                        this.result = ""
                        const value = 3.14159;
                        const buffer = new Uint8Array(4)
                        writeFloatBE(value, buffer, 0);
                        this.result = JSON.stringify(buffer)
                    })
                Button('writeDoubleLE')
                    .fontSize(25)
                    .margin(15)
                    .fontWeight(FontWeight.Bold)
                    .onClick(() => {
                        this.result = ""
                        const value = 1.1754943508222875e-38;
                        const buffer = new Uint8Array(4)
                        writeDoubleLE(value, buffer, 0);
                        this.result = JSON.stringify(buffer)
                    })
                Button('writeDoubleBE')
                    .fontSize(25)
                    .margin(15)
                    .height(46)
                    .fontWeight(FontWeight.Bold)
                    .onClick(() => {
                        this.result = ""
                        const value = 1.1754943508222875e-38;
                        const buffer = new Uint8Array(4)
                        writeDoubleBE(value, buffer, 0);
                        this.result = JSON.stringify(buffer)
                    })
                Button('readFloatLE')
                    .fontSize(25)
                    .margin(15)
                    .height(46)
                    .fontWeight(FontWeight.Bold)
                    .onClick(() => {
                        this.result = ""
                        const value = 2.2250738585072014e-309;
                        const buffer = new Uint8Array(4)
                        writeFloatLE(value, buffer, 0);
                        readFloatLE(buffer, 0);
                        this.result = JSON.stringify(buffer)
                    })
                Button('readFloatBE')
                    .fontSize(25)
                    .margin(15)
                    .height(46)
                    .fontWeight(FontWeight.Bold)
                    .onClick(() => {
                        this.result = ""
                        const value = 2.2250738585072014e-309;
                        const buffer = new Uint8Array(4)
                        writeFloatBE(value, buffer, 0);
                        readFloatBE(buffer, 0);
                        this.result = JSON.stringify(buffer)
                    })

                Button('readDoubleBE')
                    .fontSize(25)
                    .margin(15)
                    .height(46)
                    .fontWeight(FontWeight.Bold)
                    .onClick(() => {
                        this.result = ""
                        const value = 3.4028234663852886e+38;
                        const buffer = new Uint8Array(4)
                        writeDoubleBE(value, buffer, 0);
                        readDoubleBE(buffer, 0);
                        this.result = JSON.stringify(buffer)
                    })

                Button('readDoubleLE')
                    .fontSize(25)
                    .margin(15)
                    .height(46)
                    .fontWeight(FontWeight.Bold)
                    .onClick(() => {
                        this.result = ""
                        const value = 3.4028234663852886e+38;
                        const buffer = new Uint8Array(4)
                        writeDoubleLE(value, buffer, 0);
                        readDoubleLE(buffer, 0);
                        this.result = JSON.stringify(buffer)
                    })

                Text(this.result)
                    .fontSize(18)
            }
            .width('100%')
        }
    }
}