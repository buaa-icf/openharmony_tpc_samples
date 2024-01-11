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
import { describe, it, expect } from '@ohos/hypium';

export default function abilityTest() {
    describe('ActsAbilityTest', () => {
        /**
         * @tc.number :protobuf_path_isAbsolute_0001
         * @tc.name   :isAbsolute方法的返回值和预期值相等  返回成功
         * @tc.desc   :[XTS-TEST -PROTOBUF_PATH]
         * @tc.size   :MediumTest
         * @tc.type   :Function
         * @tc.level  :Level2
         */
        it('isAbsolute', 0, () => {
            expect(path.isAbsolute("X:\\some\\path\\file.js")).assertTrue()
            expect(path.isAbsolute("/some/path/file.js")).assertTrue()
            expect(path.isAbsolute("some\\path\\file.js")).assertFalse()
            expect(path.isAbsolute("some/path/file.js")).assertFalse()
        })

        /**
         * @tc.number :protobuf_path_normalize_0001
         * @tc.name   :normalize方法的返回值和预期值相等  返回成功
         * @tc.desc   :[XTS-TEST -PROTOBUF_PATH]
         * @tc.size   :MediumTest
         * @tc.type   :Function
         * @tc.level  :Level2
         */
        it('normalize', 0, () => {
            expect(path.normalize("X:\\some\\..\\.\\path\\\\file.js")).assertEqual("X:/path/file.js")
            expect(path.normalize("/some/.././path//file.js")).assertEqual("/path/file.js")
        })

        /**
         * @tc.number :protobuf_path_resolve_0001
         * @tc.name   :resolve方法的返回值和预期值相等  返回成功
         * @tc.desc   :[XTS-TEST -PROTOBUF_PATH]
         * @tc.size   :MediumTest
         * @tc.type   :Function
         * @tc.level  :Level2
         */
        it('resolve', 0, () => {
            expect(path.resolve("/path/origin.js", "/some/.././path//file.js")).assertEqual("/path/file.js")
            expect(path.resolve("X:/path/origin.js", "path/file.js", true)).assertEqual("X:/path/path/file.js")
        })
    })
}