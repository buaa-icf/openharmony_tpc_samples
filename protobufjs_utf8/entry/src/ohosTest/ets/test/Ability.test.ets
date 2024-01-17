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
import utf8 from '@protobufjs/utf8';
import { GlobalContext } from './GlobalContext';
import resmgr from '@ohos.resourceManager';
import buffer from '@ohos.buffer';
import { Utf8ArrayToStr } from './util';


export default function abilityTest() {

    describe('ActsAbilityTest', () => {
        it('length', 0, () => {
            let resourceManager = GlobalContext.getContext()
                .getValue("resManager") as resmgr.ResourceManager
            let data = resourceManager.getMediaContentSync($r('app.media.utf8').id)
            let dataStr = data.toString();
            expect(utf8.length("")).assertEqual(0)
            expect(utf8.length(data.toString())).assertEqual(buffer.byteLength(data.toString()))
        })

        it('read', 0, async () => {
            let resourceManager = GlobalContext.getContext()
                .getValue("resManager") as resmgr.ResourceManager
            let data = resourceManager.getMediaContentSync($r('app.media.utf8').id)
            let result = utf8.read(data, 0, data.byteLength);
            expect(JSON.stringify(result)).assertEqual(JSON.stringify(Utf8ArrayToStr(data)))

            let longData = buffer.concat([data, data, data, data]);
            let result1 = utf8.read(new Uint8Array(longData.buffer), 0, longData.length);
            expect(JSON.stringify(result1)).assertEqual(JSON.stringify(Utf8ArrayToStr(longData)))
        })

        it('write', 0, async () => {
            let resourceManager = GlobalContext.getContext()
                .getValue("resManager") as resmgr.ResourceManager
            let data = resourceManager.getMediaContentSync($r('app.media.utf8').id)
            let len = utf8.length(Utf8ArrayToStr(data));
            let buf = buffer.alloc(len);
            expect(utf8.write(Utf8ArrayToStr(data), new Uint8Array(buf.buffer), 0)).assertEqual(len)
        })
    })
}



