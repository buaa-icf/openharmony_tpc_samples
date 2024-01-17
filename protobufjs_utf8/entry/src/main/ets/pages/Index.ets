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

import utf8 from '@protobufjs/utf8';
import { GlobalContext } from './GlobalContext';
import resmgr from '@ohos.resourceManager';
import { Utf8ArrayToStr } from './util';
import buffer from '@ohos.buffer';

@Entry
@Component
struct Index {
    @State message: string = ''
    @State testString: string = ''

    aboutToAppear() {
        let resourceManager = GlobalContext.getContext()
            .getValue("resManager") as resmgr.ResourceManager
        let data = resourceManager.getMediaContentSync($r('app.media.utf8').id)
        this.testString = Utf8ArrayToStr(data)
    }

    build() {
        Scroll() {
            Column() {
                Scroll() {
                    Text(this.testString)
                        .fontSize(16)
                        .padding({ left: 10, right: 10, top: 10 })
                }.height("30%")
                .margin({ top: 10, left: 5, right: 5 })
                .width("95%")
                .backgroundColor("#6cd0c9c9")

                Row(){
                    Button("length")
                        .fontSize(18)
                        .width("30%")
                        .margin({ top: 10 })
                        .fontWeight(FontWeight.Bold)
                        .onClick(event => {
                            this.message = ""
                            let resourceManager = GlobalContext.getContext()
                                .getValue("resManager") as resmgr.ResourceManager
                            let data = resourceManager.getMediaContentSync($r('app.media.utf8').id)
                            this.message = "length:\r\n" + utf8.length(data.toString())
                        })

                    Button("read")
                        .fontSize(18)
                        .fontWeight(FontWeight.Bold)
                        .margin({ top: 10 })
                        .width("30%")
                        .onClick(event => {
                            this.message = ""
                            let resourceManager = GlobalContext.getContext()
                                .getValue("resManager") as resmgr.ResourceManager
                            let data = resourceManager.getMediaContentSync($r('app.media.utf8').id)
                            let result = utf8.read(data, 0, data.byteLength);
                            this.message = "read result:\r\n" + result
                        })

                    Button("write")
                        .fontSize(18)
                        .fontWeight(FontWeight.Bold)
                        .margin({ top: 10 })
                        .width("30%")
                        .onClick(event => {
                            this.message = ""
                            let resourceManager = GlobalContext.getContext()
                                .getValue("resManager") as resmgr.ResourceManager
                            let data = resourceManager.getMediaContentSync($r('app.media.utf8').id)
                            let len = utf8.length(Utf8ArrayToStr(data));
                            let buf = buffer.alloc(len);
                            let uint8=new Uint8Array(buf.buffer)
                            utf8.write(Utf8ArrayToStr(data),uint8, 0)
                            // this.message = "write result:\r\n" +JSON.stringify(uint8)
                            this.message = "write result:\r\n" + utf8.read(uint8, 0, uint8.byteLength);
                        })
                }

                Scroll() {
                    Text(this.message)
                        .fontSize(16)
                        .margin({ top: 50 })
                        .fontWeight(FontWeight.Bold)
                        .padding({ left: 10, right: 10, top: 10 })
                }.height("40%")
                .width("95%")
                .margin({ top: 10, left: 5, right: 5 })
                .backgroundColor("#6cd0c9c9")
            }
            .width('100%')
            .margin({ left: 10, right: 10 })
        }
    }
}