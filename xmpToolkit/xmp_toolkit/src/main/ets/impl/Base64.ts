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
 * 一个工具类，用于执行RFC-1521中指定的base64编码和解码。另请参见RFC 1421。
 */
export default class Base64 {
    /** 无效字节的标记 */
    private static readonly INVALID: number = -1;
    /** 接受的空白字节的标记 */
    private static readonly WHITESPACE: number = -2;
    /** 等号的标记 */
    private static readonly EQUAL: number = -3;
    
    /** base64编码表 */
    private static base64: number[] = [
        'A'.charCodeAt(0), 'B'.charCodeAt(0), 'C'.charCodeAt(0), 'D'.charCodeAt(0),   //  0 to  3
        'E'.charCodeAt(0), 'F'.charCodeAt(0), 'G'.charCodeAt(0), 'H'.charCodeAt(0),   //  4 to  7
        'I'.charCodeAt(0), 'J'.charCodeAt(0), 'K'.charCodeAt(0), 'L'.charCodeAt(0),   //  8 to 11
        'M'.charCodeAt(0), 'N'.charCodeAt(0), 'O'.charCodeAt(0), 'P'.charCodeAt(0),   // 11 to 15
        'Q'.charCodeAt(0), 'R'.charCodeAt(0), 'S'.charCodeAt(0), 'T'.charCodeAt(0),   // 16 to 19
        'U'.charCodeAt(0), 'V'.charCodeAt(0), 'W'.charCodeAt(0), 'X'.charCodeAt(0),   // 20 to 23
        'Y'.charCodeAt(0), 'Z'.charCodeAt(0), 'a'.charCodeAt(0), 'b'.charCodeAt(0),   // 24 to 27
        'c'.charCodeAt(0), 'd'.charCodeAt(0), 'e'.charCodeAt(0), 'f'.charCodeAt(0),   // 28 to 31
        'g'.charCodeAt(0), 'h'.charCodeAt(0), 'i'.charCodeAt(0), 'j'.charCodeAt(0),   // 32 to 35
        'k'.charCodeAt(0), 'l'.charCodeAt(0), 'm'.charCodeAt(0), 'n'.charCodeAt(0),   // 36 to 39
        'o'.charCodeAt(0), 'p'.charCodeAt(0), 'q'.charCodeAt(0), 'r'.charCodeAt(0),   // 40 to 43
        's'.charCodeAt(0), 't'.charCodeAt(0), 'u'.charCodeAt(0), 'v'.charCodeAt(0),   // 44 to 47
        'w'.charCodeAt(0), 'x'.charCodeAt(0), 'y'.charCodeAt(0), 'z'.charCodeAt(0),   // 48 to 51
        '0'.charCodeAt(0), '1'.charCodeAt(0), '2'.charCodeAt(0), '3'.charCodeAt(0),   // 52 to 55
        '4'.charCodeAt(0), '5'.charCodeAt(0), '6'.charCodeAt(0), '7'.charCodeAt(0),   // 56 to 59
        '8'.charCodeAt(0), '9'.charCodeAt(0), '+'.charCodeAt(0), '/'.charCodeAt(0)    // 60 to 63
    ];
    
    /** ASCII到base64索引的映射表 */
    private static ascii: number[] = new Array<number>(255);
    
    /** 静态初始化 */
    static {
        // 初始化所有字节为无效
        for (let idx: number = 0; idx < 255; idx++) {
            Base64.ascii[idx] = Base64.INVALID;
        }
        
        // 设置有效字节
        for (let idx: number = 0; idx < Base64.base64.length; idx++) {
            Base64.ascii[Base64.base64[idx]] = idx;
        }
        
        // 设置空白字符
        Base64.ascii[0x09] = Base64.WHITESPACE; // TAB
        Base64.ascii[0x0A] = Base64.WHITESPACE; // LF
        Base64.ascii[0x0D] = Base64.WHITESPACE; // CR
        Base64.ascii[0x20] = Base64.WHITESPACE; // SPACE
        
        // 设置等号
        Base64.ascii[0x3d] = Base64.EQUAL; // =
    }
    
    /**
     * 私有构造函数
     */
    private constructor() {
        // 空构造函数
    }
    
    /**
     * 对给定的字节数组进行编码
     * 
     * @param src 源字节数组
     * @return base64编码的数据
     */
    public static encode(src: number[]): number[] {
        return Base64.encodeWithLineFeed(src, 0);
    }
    
    /**
     * 对给定的字节数组进行编码，支持添加换行符
     * 
     * @param src 源字节数组
     * @param lineFeed 在<code>linefeed</code>字符后添加换行符；必须能被4整除；0表示不添加换行符
     * @return base64编码的数据
     */
    public static encodeWithLineFeed(src: number[], lineFeed: number): number[] {
        // 空数组直接返回空数组
        if (src.length === 0) {
            return [];
        }
        
        // linefeed必须能被4整除
        lineFeed = lineFeed / 4 * 4;
        if (lineFeed < 0) {
            lineFeed = 0;
        }
        
        // 确定编码长度（使用 Math.floor 确保整数）
        let codeLength: number = Math.floor((src.length + 2) / 3) * 4;
        if (lineFeed > 0) {
            codeLength += Math.floor((codeLength - 1) / lineFeed);
        }
        
        let dst: number[] = new Array<number>(codeLength);
        let bits24: number;
        let bits6: number;
        
        // 执行3字节到4字节的转换 + 0-63到ASCII可打印字符的转换
        let didx: number = 0;
        let sidx: number = 0;
        let lf: number = 0;
        
        while (sidx + 3 <= src.length) {
            bits24  = (src[sidx++] & 0xFF) << 16;
            bits24 |= (src[sidx++] & 0xFF) << 8;
            bits24 |= (src[sidx++] & 0xFF) << 0;
            
            bits6 = (bits24 & 0x00FC0000) >> 18;
            dst[didx++] = Base64.base64[bits6];
            
            bits6 = (bits24 & 0x0003F000) >> 12;
            dst[didx++] = Base64.base64[bits6];
            
            bits6 = (bits24 & 0x00000FC0) >> 6;
            dst[didx++] = Base64.base64[bits6];
            
            bits6 = (bits24 & 0x0000003F);
            dst[didx++] = Base64.base64[bits6];
            
            lf += 4;
            if (didx < codeLength && lineFeed > 0 && lf % lineFeed === 0) {
                dst[didx++] = 0x0A; // LF
            }
        }
        
        if (src.length - sidx === 2) {
            bits24  = (src[sidx] & 0xFF) << 16;
            bits24 |= (src[sidx + 1] & 0xFF) << 8;
            
            bits6 = (bits24 & 0x00FC0000) >> 18;
            dst[didx++] = Base64.base64[bits6];
            
            bits6 = (bits24 & 0x0003F000) >> 12;
            dst[didx++] = Base64.base64[bits6];
            
            bits6 = (bits24 & 0x00000FC0) >> 6;
            dst[didx++] = Base64.base64[bits6];
            
            dst[didx++] = '='.charCodeAt(0);
        } else if (src.length - sidx === 1) {
            bits24 = (src[sidx] & 0xFF) << 16;
            
            bits6 = (bits24 & 0x00FC0000) >> 18;
            dst[didx++] = Base64.base64[bits6];
            
            bits6 = (bits24 & 0x0003F000) >> 12;
            dst[didx++] = Base64.base64[bits6];
            
            dst[didx++] = '='.charCodeAt(0);
            dst[didx++] = '='.charCodeAt(0);
        }
        
        return dst;
    }
    
    /**
     * 对给定的字符串进行编码
     * @param src 源字符串
     * @return base64编码的字符串
     */
    public static encodeString(src: string): string {
        // 将字符串转换为字节数组
        let srcBytes: number[] = [];
        for (let i: number = 0; i < src.length; i++) {
            srcBytes.push(src.charCodeAt(i));
        }
        
        let encodedBytes: number[] = Base64.encode(srcBytes);
        
        // 将字节数组转换回字符串
        let result: string = '';
        for (let i: number = 0; i < encodedBytes.length; i++) {
            result += String.fromCharCode(encodedBytes[i]);
        }
        
        return result;
    }
    
    /**
     * 解码给定的字节数组
     * 
     * @param src base64编码的数据
     * @return 解码后的数据
     * @throws Error 如果base64字符串包含无效字符（除了base64字符、LF、CR、制表符和空格之外的字符）
     */
    public static decode(src: number[]): number[] {
        // 执行ASCII可打印字符到0-63的转换
        let sidx: number;
        let srcLen: number = 0;
        let tempSrc: number[] = new Array<number>(src.length);
        
        for (sidx = 0; sidx < src.length; sidx++) {
            // 检查索引是否在有效范围内（0-254）
            if (src[sidx] < 0 || src[sidx] >= Base64.ascii.length) {
                throw new Error("Invalid base 64 string");
            }
            let val: number = Base64.ascii[src[sidx]];
            if (val >= 0) {
                tempSrc[srcLen++] = val;
            } else if (val === Base64.INVALID) {
                throw new Error("Invalid base 64 string");
            }
        }
        
        // 修剪任何填充
        while (srcLen > 0 && tempSrc[srcLen - 1] === Base64.EQUAL) {
            srcLen--;
        }
        
        // 使用 Math.floor 确保数组长度是整数
        let dst: number[] = new Array<number>(Math.floor(srcLen * 3 / 4));
        
        // 执行4字节到3字节的转换
        let didx: number;
        for (sidx = 0, didx = 0; didx < dst.length - 2; sidx += 4, didx += 3) {
            dst[didx] = (((tempSrc[sidx] << 2) & 0xFF) | ((tempSrc[sidx + 1] >>> 4) & 0x03));
            dst[didx + 1] = (((tempSrc[sidx + 1] << 4) & 0xFF) | ((tempSrc[sidx + 2] >>> 2) & 0x0F));
            dst[didx + 2] = (((tempSrc[sidx + 2] << 6) & 0xFF) | ((tempSrc[sidx + 3]) & 0x3F));
        }
        
        if (didx < dst.length) {
            dst[didx] = (((tempSrc[sidx] << 2) & 0xFF) | ((tempSrc[sidx + 1] >>> 4) & 0x03));
        }
        
        if (++didx < dst.length) {
            dst[didx] = (((tempSrc[sidx + 1] << 4) & 0xFF) | ((tempSrc[sidx + 2] >>> 2) & 0x0F));
        }
        
        return dst;
    }
    
    /**
     * 解码给定的字符串
     * 
     * @param src base64编码的字符串
     * @return 解码后的字符串
     */
    public static decodeString(src: string): string {
        // 将字符串转换为字节数组
        let srcBytes: number[] = [];
        for (let i: number = 0; i < src.length; i++) {
            srcBytes.push(src.charCodeAt(i));
        }
        
        let decodedBytes: number[] = Base64.decode(srcBytes);
        
        // 将字节数组转换回字符串
        let result: string = '';
        for (let i: number = 0; i < decodedBytes.length; i++) {
            result += String.fromCharCode(decodedBytes[i]);
        }
        
        return result;
    }
}