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

import getPool from "./util"

@Entry
@Component
struct Index {
    private poolSize = 1
    private alloc: ESObject | null = null
    @State pool: string = ""

    build() {
        Scroll() {
            Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
                TextInput({ text: this.poolSize + "", placeholder: $r('app.string.Please_input_the_buffer_pool_size') })
                    .height(60)
                    .fontSize(18)
                    .fontSize(16)
                    .type(InputType.Number)
                    .onChange((value: string) => {
                        this.poolSize = Number.parseInt(value)
                    })

                Button($r('app.string.Generate_a_generic_buffer_pool'))
                    .fontSize(24)
                    .fontWeight(FontWeight.Bold)
                    .margin({ top: 15 })
                    .onClick(() => {
                        if (!!!this.alloc) {
                            this.alloc = getPool()
                        }
                        this.pool = JSON.stringify(this.alloc(this.poolSize))
                    })

                Text(this.pool)
                    .margin({ top: 15 })
                    .fontSize(8)
            }
            .width('100%')
        }
    }
}