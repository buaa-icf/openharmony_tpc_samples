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
import getPool from "./util"

export default function abilityTest() {
    describe('ActsAbilityTest', () => {
        it('pool', 0, () => {
            let alloc = getPool()
            let buf1: Uint8Array = alloc(0);
            expect(buf1.length).assertEqual(0)

            let buf2 = alloc(1);
            expect(buf2.length).assertEqual(1)
            expect(buf2.buffer === buf1.buffer).assertFalse()
            expect(buf2.byteOffset).assertEqual(0)

            buf1 = alloc(1);
            expect(buf1.buffer).assertDeepEquals(buf2.buffer)
            expect(buf1.byteOffset).assertEqual(8)

            let buf3 = alloc(4097);
            expect(buf3.buffer === buf2.buffer).assertFalse()

            buf2 = alloc(4096);
            expect(buf2.buffer === buf1.buffer).assertTrue()

            buf1 = alloc(4096);
            expect(buf1.buffer === buf2.buffer).assertFalse()
        })
    })
}