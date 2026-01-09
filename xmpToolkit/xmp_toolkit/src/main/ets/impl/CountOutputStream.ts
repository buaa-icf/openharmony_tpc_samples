/*
Copyright (c) 2026 Huawei Device Co., Ltd.
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

/**
 * An OutputStream wrapper that counts the written bytes.
 * This is the ArkTS implementation of the Java CountOutputStream.
 */
export default class CountOutputStream {
    /** the decorated output stream */
    private out: ESObject;
    /** the byte counter */
    private bytesWritten: number = 0;

    /**
     * Constructor with providing the output stream to decorate.
     * @param out an OutputStream-like object
     */
    constructor(out: ESObject) {
        this.out = out;
    }

    /**
     * Counts the written bytes.
     * @param buf byte array to write
     * @param off offset in the array
     * @param len number of bytes to write
     */
    write(buf: Uint8Array | number, off?: number, len?: number): void {
        if (off !== undefined && len !== undefined) {
            this.out.write(buf, off, len);
            this.bytesWritten += len;
        } else {
            if (buf instanceof Uint8Array) {
                this.out.write(buf);
                this.bytesWritten += buf.length;
            } else if (typeof buf === 'number') {
                this.out.write(buf);
                this.bytesWritten++;
            }
        }
    }

    /**
     * @return the number of bytes written
     */
    getBytesWritten(): number {
        return this.bytesWritten;
    }
}