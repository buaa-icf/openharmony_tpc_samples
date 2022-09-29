/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import ByteBuffer from 'bytebuffer'

export default function writerReaderTest() {
    describe('ActsWriterReaderTest', function () {
        it('TestWriteInt64',0, function () {
            var byteBufferInt64 = new ByteBuffer()
                .writeInt64(188888888,1)
                .flip();
            expect(byteBufferInt64.readInt64(1)).assertContain("188888888");
        })
        it('TestWriteUint64',0, function () {
            var byteBufferUint64 = new ByteBuffer()
                .writeUint64(366,2)
                .flip();
            expect(byteBufferUint64.readUint64(2)).assertContain(366);
        })
        it('TestWriteDouble',0, function () {
            var byteBufferDouble = new ByteBuffer()
                .writeDouble(1.344,6)
                .flip();
            expect(byteBufferDouble.readDouble(6)+"").assertContain(1.344+"");
        })
        it('TestWriteString',0, function () {
            var byteBufferString = new ByteBuffer()
                .writeIString("hello world")
                .flip();
            expect(byteBufferString.readIString()).assertContain("hello world");
        })
    })
}