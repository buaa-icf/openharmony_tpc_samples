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

import ByteBuffer from './ByteBuffer';
import { util } from '@kit.ArkTS';

/**
 * Latin1转换器，用于处理包含混合UTF-8和Latin-1/Cp1252字符的字节缓冲区
 * 将无效的UTF-8字符转换为有效的UTF-8编码
 */
export default class Latin1Converter {
  /** 开始状态 */
  private static readonly STATE_START: number = 0;
  /** UTF-8字符状态 */
  private static readonly STATE_UTF8CHAR: number = 11;

  /**
   * 私有构造函数，防止实例化
   */
  private constructor() {
    // 防止实例化
  }

  /**
   * 处理包含混合UTF-8和Latin-1/Cp1252字符的字节缓冲区
   * 结果是一个只包含有效UTF-8字符的缓冲区
   *
   * @param buffer 字节缓冲区
   * @return 返回一个新的包含有效UTF-8的缓冲区
   */
  public static convert(buffer: ByteBuffer): ByteBuffer {
    if (buffer.getEncoding() === 'UTF-8') {
      // 用于存储读取的字节（最多8字节，UTF-8字符的最大长度）
      const readAheadBuffer: number[] = new Array(8);
      // 已读取的字节数
      let readAhead: number = 0;
      // 期望的UTF-8后续字节数
      let expectedBytes: number = 0;
      // 输出缓冲区，大小估计为原缓冲区的4/3倍
      const out: ByteBuffer = new ByteBuffer(Math.floor(buffer.getLength() * 4 / 3));

      let state: number = Latin1Converter.STATE_START;
      for (let i: number = 0; i < buffer.getLength(); i++) {
        const b: number = buffer.charAt(i);
        switch (state) {
          case Latin1Converter.STATE_UTF8CHAR:
            if (expectedBytes > 0 && (b & 0xC0) === 0x80) {
              // 有效的UTF-8后续字符
              readAheadBuffer[readAhead++] = b;
              expectedBytes--;

              if (expectedBytes === 0) {
                // 完成一个UTF-8字符，添加到输出
                // 将readAheadBuffer的前readAhead个字节转换为number数组
                const utf8Bytes: number[] = [];
                for (let j: number = 0; j < readAhead; j++) {
                  utf8Bytes[j] = readAheadBuffer[j];
                }
                out.appendBytes(utf8Bytes, 0, readAhead);
                readAhead = 0;
                state = Latin1Converter.STATE_START;
              }
            } else {
              // 无效的UTF-8字符：
              // 1. 将序列的第一个字节转换为UTF-8
              const utf8: Uint8Array = Latin1Converter.convertToUTF8(readAheadBuffer[0]);
              // 将Uint8Array转换为number数组
              const utf8Bytes: number[] = Array.from(utf8);
              out.appendBytes(utf8Bytes, 0, utf8Bytes.length);

              // 2. 从序列的第二个字节继续处理
              i = i - readAhead;
              readAhead = 0;
              state = Latin1Converter.STATE_START;
            }
            break;

          case Latin1Converter.STATE_START:

          default:
            if (b < 0x7F) {
              // ASCII字符，直接添加
              out.appendByte(b);
            } else if (b >= 0xC0) {
              // UTF-8序列的开始
              expectedBytes = -1;
              let test: number = b;
              for (; expectedBytes < 8 && (test & 0x80) === 0x80; test = test << 1) {
                expectedBytes++;
              }
              readAheadBuffer[readAhead++] = b;
              state = Latin1Converter.STATE_UTF8CHAR;
            } else {
              // 无效的UTF-8起始字符，假设为Latin-1
              const utf8: Uint8Array = Latin1Converter.convertToUTF8(b);
              // 将Uint8Array转换为number数组
              const utf8Bytes: number[] = Array.from(utf8);
              out.appendBytes(utf8Bytes, 0, utf8Bytes.length);
            }
            break;
        }
      }

      // 处理循环结束时的"不完整"UTF-8字符，假设这些字节是Latin-1
      if (state === Latin1Converter.STATE_UTF8CHAR) {
        for (let j: number = 0; j < readAhead; j++) {
          const b: number = readAheadBuffer[j];
          const utf8: Uint8Array = Latin1Converter.convertToUTF8(b);
          // 将Uint8Array转换为number数组
          const utf8Bytes: number[] = Array.from(utf8);
          out.appendBytes(utf8Bytes, 0, utf8Bytes.length);
        }
      }

      return out;
    } else {
      // Latin-1修复只适用于UTF-8编码
      return buffer;
    }
  }

  /**
   * 将Cp1252字符（包含所有0x80以上的Latin-1字符）转换为UTF-8字节序列
   * 字节0x81、0x8D、0x8F、0x90和0x9D在Windows 1252中正式未定义，因此替换为空格（0x20）
   *
   * @param ch Cp1252 / Latin-1字节
   * @return 返回包含UTF-8字节序列的字节数组
   */
  private static convertToUTF8(ch: number): Uint8Array {
    const c: number = ch & 0xFF;

    if (c >= 0x80) {
      // 检查Windows 1252中未定义的字符
      if (c === 0x81 || c === 0x8D || c === 0x8F || c === 0x90 || c === 0x9D) {
        return new Uint8Array([0x20]); // 用空格替换未定义字符
      }

      try {
        // 在JavaScript中，我们可以使用String.fromCharCode将Latin-1值转换为字符
        // 然后使用TextEncoder将字符转换为UTF-8字节
        // 根据 HarmonyOS API: encodeInto(src) 直接返回 Uint8Array
        const encoder: util.TextEncoder = new util.TextEncoder();
        const str = String.fromCharCode(c);
        return encoder.encodeInto(str);
      } catch (e) {
        // 如果发生错误，返回原始字节
        return new Uint8Array([ch]);
      }
    }

    return new Uint8Array([ch]);
  }
}