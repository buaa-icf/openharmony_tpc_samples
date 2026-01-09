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

import Utils from './Utils';

/**
 * 读取结果接口
 */
export interface ReadResult {
    /** 是否读取完成 */
    done: boolean;
    /** 读取的值 */
    value: string | number;
}

/**
 * 字符读取器接口，用于适配鸿蒙ArkTS环境
 * 替代 Web API 的 ReadableStream，提供字符流读取功能
 */
export interface CharReader {
    /**
     * 读取一个字符
     * @return 返回 ReadResult，done为true表示流结束
     */
    read(): Promise<ReadResult>;
    
    /**
     * 释放读取器锁（可选）
     */
    releaseLock?(): Promise<void>;
}

/**
 * 一个处理ASCII控制字符的读取器类，用于修复XML文档中的控制字符
 */
export class FixASCIIControlsReader {
    /** 起始状态 */
    private static readonly STATE_START: number = 0;
    /** 遇到&符号的状态 */
    private static readonly STATE_AMP: number = 1;
    /** 遇到#符号的状态 */
    private static readonly STATE_HASH: number = 2;
    /** 十六进制数字状态 */
    private static readonly STATE_HEX: number = 3;
    /** 十进制数字状态 */
    private static readonly STATE_DIG1: number = 4;
    /** 错误状态 */
    private static readonly STATE_ERROR: number = 5;
    /** 缓冲区大小 */
    private static readonly BUFFER_SIZE: number = 8;
    
    /** 状态机的当前状态 */
    private state: number = FixASCIIControlsReader.STATE_START;
    /** 转义序列的结果 */
    private control: number = 0;
    /** 序列中的数字计数 */
    private digits: number = 0;
    /** 读取器实例 */
    private readerInstance: CharReader | null = null;
    /** 回退缓冲区 */
    private pushbackBuffer: string = '';
    
    /**
     * 构造函数
     * @param reader 输入读取器，可以是CharReader接口实现，或者具有getReader()方法的对象
     */
    constructor(reader: CharReader | ESObject) {
        // 如果reader有getReader方法（类似ReadableStream），则调用它
        if (reader && typeof (reader as ESObject).getReader === 'function') {
            this.readerInstance = (reader as ESObject).getReader() as CharReader;
        } else {
            // 否则直接使用reader作为CharReader
            this.readerInstance = reader as CharReader;
        }
    }
    
    /**
     * 读取字符到缓冲区
     * @param target 目标字符数组
     * @param offset 起始偏移量
     * @param length 要读取的字符数
     * @return 实际读取的字符数，如果到达流末尾则返回-1
     */
    public async read(target: string[], offset: number = 0, length: number = target.length): Promise<number> {
        let readAhead: number = 0;
        let readCount: number = 0;
        let pos: number = offset;
        const readAheadBuffer: string[] = new Array(FixASCIIControlsReader.BUFFER_SIZE);
        
        let available: boolean = true;
        while (available && readCount < length) {
            let c: string;
            
            // 首先检查回退缓冲区
            if (this.pushbackBuffer.length > 0) {
                c = this.pushbackBuffer.charAt(0);
                this.pushbackBuffer = this.pushbackBuffer.substring(1);
            } else {
                // 从读取器读取字符
                const result: ReadResult = await this.readerInstance!.read();
                if (result.done) {
                    available = false;
                    break;
                }
                c = result.value.toString();
            }
            
            readAheadBuffer[readAhead] = c;
            const processedChar: string = this.processChar(c);
            
            if (this.state === FixASCIIControlsReader.STATE_START) {
                // 替换控制字符为空格
                if (Utils.isControlChar(processedChar)) {
                    target[pos++] = ' ';
                } else {
                    target[pos++] = processedChar;
                }
                readAhead = 0;
                readCount++;
            } else if (this.state === FixASCIIControlsReader.STATE_ERROR) {
                // 将读取的字符放回缓冲区
                for (let i: number = 0; i <= readAhead; i++) {
                    this.pushbackBuffer = readAheadBuffer[i] + this.pushbackBuffer;
                }
                readAhead = 0;
            } else {
                readAhead++;
            }
        }
        
        // 处理文件在转义序列中间结束的情况
        if (!available && readAhead > 0) {
            // 将读取的字符放回缓冲区
            for (let i: number = 0; i < readAhead; i++) {
                this.pushbackBuffer = readAheadBuffer[i] + this.pushbackBuffer;
            }
            this.state = FixASCIIControlsReader.STATE_ERROR;
        }
        
        return readCount > 0 || available ? readCount : -1;
    }
    
    /**
     * 处理数字转义字符，判断它们是否为控制字符
     * @param ch 字符
     * @return 直接返回字符或作为转义序列的替换
     */
    private processChar(ch: string): string {
        switch (this.state) {
            case FixASCIIControlsReader.STATE_START:
                if (ch === '&') {
                    this.state = FixASCIIControlsReader.STATE_AMP;
                }
                return ch;
                
            case FixASCIIControlsReader.STATE_AMP:
                if (ch === '#') {
                    this.state = FixASCIIControlsReader.STATE_HASH;
                } else {
                    this.state = FixASCIIControlsReader.STATE_ERROR;
                }
                return ch;
                
            case FixASCIIControlsReader.STATE_HASH:
                if (ch === 'x' || ch === 'X') {
                    this.control = 0;
                    this.digits = 0;
                    this.state = FixASCIIControlsReader.STATE_HEX;
                } else if (ch >= '0' && ch <= '9') {
                    this.control = parseInt(ch, 10);
                    this.digits = 1;
                    this.state = FixASCIIControlsReader.STATE_DIG1;
                } else {
                    this.state = FixASCIIControlsReader.STATE_ERROR;
                }
                return ch;
                
            case FixASCIIControlsReader.STATE_DIG1:
                if (ch >= '0' && ch <= '9') {
                    this.control = this.control * 10 + parseInt(ch, 10);
                    this.digits++;
                    if (this.digits <= 5) {
                        this.state = FixASCIIControlsReader.STATE_DIG1;
                    } else {
                        this.state = FixASCIIControlsReader.STATE_ERROR; // 序列太长
                    }
                } else if (ch === ';' && Utils.isControlChar(String.fromCharCode(this.control))) {
                    this.state = FixASCIIControlsReader.STATE_START;
                    return String.fromCharCode(this.control);
                } else {
                    this.state = FixASCIIControlsReader.STATE_ERROR;
                }
                return ch;
                
            case FixASCIIControlsReader.STATE_HEX:
                if ((ch >= '0' && ch <= '9') ||
                    (ch >= 'a' && ch <= 'f') ||
                    (ch >= 'A' && ch <= 'F')) {
                    this.control = this.control * 16 + parseInt(ch, 16);
                    this.digits++;
                    if (this.digits <= 4) {
                        this.state = FixASCIIControlsReader.STATE_HEX;
                    } else {
                        this.state = FixASCIIControlsReader.STATE_ERROR; // 序列太长
                    }
                } else if (ch === ';' && Utils.isControlChar(String.fromCharCode(this.control))) {
                    this.state = FixASCIIControlsReader.STATE_START;
                    return String.fromCharCode(this.control);
                } else {
                    this.state = FixASCIIControlsReader.STATE_ERROR;
                }
                return ch;
                
            case FixASCIIControlsReader.STATE_ERROR:
                this.state = FixASCIIControlsReader.STATE_START;
                return ch;
                
            default:
                // 不可达
                return ch;
        }
    }
    
    /**
     * 关闭读取器
     */
    public async close(): Promise<void> {
        if (this.readerInstance) {
            if (this.readerInstance.releaseLock) {
                await this.readerInstance.releaseLock();
            }
            this.readerInstance = null;
        }
    }
}