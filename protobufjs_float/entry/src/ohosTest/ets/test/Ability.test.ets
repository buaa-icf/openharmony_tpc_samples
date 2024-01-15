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

import { describe, expect, it } from '@ohos/hypium';
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


export default function abilityTest() {
    describe('ActsAbilityTest', () => {
        it('writeFloatLE', 0, () => {
            const value = 3.14159;
            const buffer = new Uint8Array(4)
            writeFloatLE(value, buffer, 0);
            expect(JSON.stringify(buffer)).assertEqual("{\"0\":208,\"1\":15,\"2\":73,\"3\":64}")
        })

        it('writeFloatBE', 0, () => {
            const value = 3.14159;
            const buffer = new Uint8Array(4)
            writeFloatBE(value, buffer, 0);
            expect(JSON.stringify(buffer)).assertEqual("{\"0\":64,\"1\":73,\"2\":15,\"3\":208}")
        })

        it('writeDoubleLE', 0, () => {
            const value = 1.1754943508222875e-38;
            const buffer = new Uint8Array(4)
            writeDoubleLE(value, buffer, 0);
            expect(JSON.stringify(buffer)).assertEqual("{\"0\":0,\"1\":0,\"2\":0,\"3\":0}")
        })

        it('writeDoubleBE', 0, () => {
            const value = 1.1754943508222875e-38;
            const buffer = new Uint8Array(4)
            writeDoubleBE(value, buffer, 0);
            expect(JSON.stringify(buffer)).assertEqual("{\"0\":56,\"1\":16,\"2\":0,\"3\":0}")
        })

        it('readFloatLE', 0, () => {
            const value = 2.2250738585072014e-309;
            const buffer = new Uint8Array(4)
            writeFloatLE(value, buffer, 0);
            readFloatLE(buffer, 0);
            expect(JSON.stringify(buffer)).assertEqual("{\"0\":0,\"1\":0,\"2\":0,\"3\":0}")
        })

        it('readFloatBE', 0, () => {
            const value = 2.2250738585072014e-309;
            const buffer = new Uint8Array(4)
            writeFloatBE(value, buffer, 0);
            readFloatBE(buffer, 0);
            expect(JSON.stringify(buffer)).assertEqual("{\"0\":0,\"1\":0,\"2\":0,\"3\":0}")
        })

        it('readDoubleBE', 0, () => {
            const value = 3.4028234663852886e+38;
            const buffer = new Uint8Array(4)
            writeDoubleBE(value, buffer, 0);
            readDoubleBE(buffer, 0);
            expect(JSON.stringify(buffer)).assertEqual("{\"0\":71,\"1\":239,\"2\":255,\"3\":255}")
        })

        it('readDoubleLE', 0, () => {
            const value = 3.4028234663852886e+38;
            const buffer = new Uint8Array(4)
            writeDoubleLE(value, buffer, 0);
            readDoubleLE(buffer, 0);
            expect(JSON.stringify(buffer)).assertEqual("{\"0\":0,\"1\":0,\"2\":0,\"3\":224}")
        })

    })
}