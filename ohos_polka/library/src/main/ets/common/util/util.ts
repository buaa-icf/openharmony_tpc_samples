/**
 * MIT License
 *
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the 'Software'), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to all conditions.
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

/**
 * @description 在输入的字符串中找到HTTP头部的结束位置
 * @param inputStream
 * @param rlen
 * @returns
 */
export function findHeaderEnd(inputStream: string, rlen: number): number {

  // 定义一个变量splitByte，初始值为0 这个变量可能用于后续的字节分割操作,用于记录当前检查到的位置
  let splitByte: number = 0;
  const NUMBER2 = 2;
  const NUMBER3 = 3;
  const NUMBER4 = 4;
  while (splitByte + 1 < rlen) {

    /*
     * 这是根据RFC2616（HTTP 1.1协议的官方文档）中的规定，头部的结束是由两个'\r\n'组成的
     * 首先检查splitByte位置的字符串和splitByte + 1位置的字符串是否为“\r”和“\n”，同时splitByte + 2和splitByte + 3位置的字符串
     * 是否也是为“\r”和“\n”，如果都是那么返回splitByte + 4，表示找到了头部的结束位置。
     */
    const firstCase = inputStream[splitByte] === '\r' && inputStream[splitByte + 1] === '\n';
    const lessThan = splitByte + NUMBER3 < rlen;
    const secondCase = inputStream[splitByte + NUMBER2] === '\r' && inputStream[splitByte + NUMBER3] === '\n';

    if (firstCase && lessThan && secondCase) {
      return splitByte + NUMBER4;
    }

    /*
     * 为了兼容某些不完全符合RFC2616的情况， tolerance
     * 检查splitByte位置的字符串和splitByte + 1位置的字符串是否为两个“\n”，如果是，那么返回splitByte + 2，表示找到了头部结束的位置
     */
    if (inputStream[splitByte] === '\n' && inputStream[splitByte + 1] === '\n') {
      return splitByte + NUMBER2;
    }

    // 如果上述两个条件都不满足，那么splitByte加1，继续检查下一个位置
    splitByte++;
  }

  // 如果循环结束都没有找到头部的结束位置，那么返回0，表示没有找到头部的结束
  return 0;
}