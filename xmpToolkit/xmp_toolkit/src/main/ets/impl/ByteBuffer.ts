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
 * 字节缓冲区容器，包括有效数据的长度
 */
export default class ByteBuffer {
    /** 内部字节数组 */
    private buffer: number[] = [];
    /** 有效数据长度 */
    private length: number = 0;
    /** 编码格式 */
    private encoding: string | null = null;
    
    /**
     * 使用初始容量创建ByteBuffer
     * @param initialCapacity 缓冲区的初始容量
     */
    constructor(initialCapacity: number);
    /**
     * 使用现有字节数组创建ByteBuffer
     * @param buffer 要包装的字节数组
     */
    constructor(buffer: number[]);
    /**
     * 使用指定长度的字节数组创建ByteBuffer
     * @param buffer 要包装的字节数组
     * @param length 数组中有效字节的长度
     */
    constructor(buffer: number[], length: number);
    /**
     * 使用偏移量和长度创建ByteBuffer
     * @param buffer 源字节数组
     * @param offset 偏移量
     * @param length 有效长度
     */
    constructor(buffer: number[], offset: number, length: number);
    
    /**
     * 构造函数实现
     */
    constructor(...args: ESObject[]) {
        if (args.length === 1) {
            if (typeof args[0] === 'number') {
                // 使用初始容量创建
                this.buffer = new Array<number>(args[0]);
                this.length = 0;
            } else if (Array.isArray(args[0])) {
                // 使用字节数组创建
                this.buffer = args[0];
                this.length = args[0].length;
            }
        } else if (args.length === 2 && Array.isArray(args[0]) && typeof args[1] === 'number') {
            // 使用指定长度的字节数组创建
            if (args[1] > args[0].length) {
                throw new Error("Valid length exceeds the buffer length.");
            }
            this.buffer = args[0];
            this.length = args[1];
        } else if (args.length === 3 && Array.isArray(args[0]) && typeof args[1] === 'number' && typeof args[2] === 'number') {
            // 使用偏移量和长度创建
            if (args[2] > args[0].length - args[1]) {
                throw new Error("Valid length exceeds the buffer length.");
            }
            this.buffer = new Array<number>(args[2]);
            for (let i = 0; i < args[2]; i++) {
                this.buffer[i] = args[0][args[1] + i];
            }
            this.length = args[2];
        }
    }
    
    /**
     * 获取有效字节数
     * @return 返回缓冲区中有效字节的数量
     */
    public getLength(): number {
        return this.length;
    }
    
    /**
     * 获取指定索引处的字节
     * @param index 要检索的字节的索引
     * @return 返回缓冲区中的字节
     */
    public byteAt(index: number): number {
        if (index < this.length) {
            return this.buffer[index];
        } else {
            throw new Error("The index exceeds the valid buffer area");
        }
    }
    
    /**
     * 获取指定索引处的字节作为int或char
     * @param index 要检索的字节的索引
     * @return 返回缓冲区中的字节（0-255范围）
     */
    public charAt(index: number): number {
        if (index < this.length) {
            return this.buffer[index] & 0xFF;
        } else {
            throw new Error("The index exceeds the valid buffer area");
        }
    }
    
    /**
     * 向缓冲区追加一个字节
     * @param b 要追加的字节
     */
    public appendByte(b: number): void {
        this.ensureCapacity(this.length + 1);
        this.buffer[this.length++] = b;
    }
    
    /**
     * 向缓冲区追加字节数组或其一部分
     * @param bytes 字节数组
     * @param offset 偏移量
     * @param len 长度
     */
    public appendBytes(bytes: number[], offset: number, len: number): void {
        this.ensureCapacity(this.length + len);
        for (let i = 0; i < len; i++) {
            this.buffer[this.length + i] = bytes[offset + i];
        }
        this.length += len;
    }
    
    /**
     * 向缓冲区追加整个字节数组
     * @param bytes 字节数组
     */
    public appendBytearray(bytes: number[]): void {
        this.appendBytes(bytes, 0, bytes.length);
    }
    
    /**
     * 向此缓冲区追加另一个缓冲区
     * @param anotherBuffer 另一个ByteBuffer
     */
    public appendBuffer(anotherBuffer: ByteBuffer): void {
        this.appendBytes(anotherBuffer.buffer, 0, anotherBuffer.length);
    }
    
    /**
     * 检测字节缓冲区的编码，存储并返回它
     * 仅识别UTF-8、UTF-16LE/BE和UTF-32LE/BE
     * @return 返回编码字符串
     */
    public getEncoding(): string {
        if (this.encoding == null) {
            // 最多需要四个字节来确定编码
            if (this.length < 2) {
                // 只有一个字节长度必须是UTF-8
                this.encoding = "UTF-8";
            } else if (this.buffer[0] === 0) {
                // 这些情况是：
                //   00 nn -- -- - Big endian UTF-16
                //   00 00 00 nn - Big endian UTF-32
                //   00 00 FE FF - Big endian UTF 32
                
                if (this.length < 4 || this.buffer[1] !== 0) {
                    this.encoding = "UTF-16BE";
                } else if ((this.buffer[2] & 0xFF) === 0xFE && (this.buffer[3] & 0xFF) === 0xFF) {
                    this.encoding = "UTF-32BE";
                } else {
                    this.encoding = "UTF-32";
                }
            } else if ((this.buffer[0] & 0xFF) < 0x80) {
                // 这些情况是：
                //   nn mm -- -- - UTF-8，包括EF BB BF情况
                //   nn 00 -- -- - Little endian UTF-16
                
                if (this.buffer[1] !== 0) {
                    this.encoding = "UTF-8";
                } else if (this.length < 4 || this.buffer[2] !== 0) {
                    this.encoding = "UTF-16LE";
                } else {
                    this.encoding = "UTF-32LE";
                }
            } else {
                // 这些情况是：
                //   EF BB BF -- - UTF-8
                //   FE FF -- -- - Big endian UTF-16
                //   FF FE 00 00 - Little endian UTF-32
                //   FF FE -- -- - Little endian UTF-16
                
                if ((this.buffer[0] & 0xFF) === 0xEF) {
                    this.encoding = "UTF-8";
                } else if ((this.buffer[0] & 0xFF) === 0xFE) {
                    this.encoding = "UTF-16"; // 实际上是BE
                } else if (this.length < 4 || this.buffer[2] !== 0) {
                    this.encoding = "UTF-16"; // 实际上是LE
                } else {
                    this.encoding = "UTF-32"; // 实际上是LE
                }
            }
        }
        
        return this.encoding;
    }
    
    /**
     * 通过在超出当前长度时增加缓冲区大小来确保请求的容量
     * @param requestedLength 请求的新缓冲区长度
     */
    private ensureCapacity(requestedLength: number): void {
        while (requestedLength > this.buffer.length) {
            let oldBuf: number[] = this.buffer;
            this.buffer = new Array<number>(oldBuf.length * 2);
            for (let i = 0; i < oldBuf.length; i++) {
                this.buffer[i] = oldBuf[i];
            }
        }
    }
}