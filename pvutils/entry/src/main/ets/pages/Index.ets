/**
 *  MIT License
 *
 *  Copyright (c) 2024 Huawei Device Co., Ltd.
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in all
 *  copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 *  SOFTWARE.
 */

import { utilConcatView, bufferToHexCodes,
  arrayBufferToString,
  getUTCDate,
  getParametersValue,
  checkBufferParams,
  LocalBaseBlock,
  utilFromBase,
  utilToBase,
  padNumber,
  utilEncodeTC,
  toBase64,
  fromBase64,
  nearestPowerOf2,
  isEqualBuffer,
  utilConcatBuf } from "pvutils"

@Entry
@Component
struct Index {
  @State message: string = '';
  private scrollerForScroll: Scroller = new Scroller()
  private  data = new Uint8Array([0x2A, 0x05, 0x4D, 0x07, 0x6A, 0x6B, 0x7E]);

  build() {
    Scroll(this.scrollerForScroll) {
      Column() {
        Text('显示结果：' + this.message)
          .fontSize(16)
        Button("arrayBuffer转字符串")
          .width(200)
          .onClick((event: ClickEvent) => {
            this.message = arrayBufferToString(this.data.buffer);
            console.log("arrayBuffer转字符串'：" + this.message)
          }).margin(5)
        Button("ArrayBuffer转16进制字符串")
          .onClick((event: ClickEvent) => {
            this.message = bufferToHexCodes(this.data.buffer, 0, 5, false);
            console.log("ArrayBuffer转16进制字符串'：" + this.message)
          }).margin(5)
        Button("本地时间转世界时间")
          .onClick((event: ClickEvent) => {
            let data = new Date();
            this.message = getUTCDate(data).toString();
            console.log("本地时间转世界时间'：" + this.message)
          }).margin(5)
        Button("获取指定属性值")
          .onClick((event: ClickEvent) => {
            let data: Record<string, string> = { 'name': 'Parame', 'key': '2' }
            this.message = getParametersValue(data, 'name', '').toString();
            console.log("获取指定属性值：'name''：" + this.message)
          }).margin(5)
        Button("buffer参数合法性检测")
          .onClick((event: ClickEvent) => {
            let data: LocalBaseBlock = {};
            this.message = checkBufferParams(data, this.data.buffer, 12, 6).toString();
            console.log("buffer参数合法性检测：" + this.message)
          }).margin(5)
        Button("2^base 转换为 2^10")
          .onClick((event: ClickEvent) => {
            let inputBuffer = new Uint8Array(this.data.buffer);
            inputBuffer[0] = 130;
            this.message = utilFromBase(inputBuffer, 8).toString();
            console.log(" 2^base 转换为 2^10 ：" + this.message)
          }).margin(5)
        Button("2^10 转换为 2^base再转16进制")
          .onClick((event: ClickEvent) => {
            this.message = bufferToHexCodes(utilToBase(16513, 7));
            console.log(" 2^10 转换为 2^base再转16进制 ：" + this.message)
          }).margin(5)
        Button("将多个 ArrayBuffer 以16进制的形式连接在一起")
          .onClick((event: ClickEvent) => {
            this.message = bufferToHexCodes(utilConcatBuf(...[this.data.buffer, this.data.buffer]));
            console.log(" 将多个 ArrayBuffer 以16进制的形式连接在一起 ：" + this.message)
          }).margin(5)
        Button("将多个 Uint8Array 连接在一起")
          .onClick((event: ClickEvent) => {
            this.message = JSON.stringify(utilConcatView(this.data));
            console.log(" 将多个 Uint8Array 连接在一起 ：" + this.message)
          }).margin(5)
        Button("将整数值编码成“补码”格式以16进制的形式输出")
          .onClick((event: ClickEvent) => {
            this.message = bufferToHexCodes(utilEncodeTC(10));
            console.log(" 将整数值编码成“补码”格式以16进制的形式输出 ：" + this.message)
          }).margin(5)
        Button("ArrayBuffer相等判断")
          .onClick((event: ClickEvent) => {
            let data2 = new Uint8Array([0x2A, 0x05, 0x4D, 0x07, 0x08, 0x09, 0x0A]);
            this.message = JSON.stringify(isEqualBuffer(this.data.buffer, data2.buffer));
            console.log(" ArrayBuffer相等判断 ：" + this.message)
          }).margin(5)
        Button("数字前面添加前导零")
          .onClick((event: ClickEvent) => {
            this.message = JSON.stringify(padNumber(10, 3));
            console.log(" 数字前面添加前导零 ：" + this.message)
          }).margin(5)
        Button("将字符串编码成BASE64格式")
          .onClick((event: ClickEvent) => {
            this.message = toBase64('hello BASE64');
            console.log(" 将字符串编码成BASE64格式' hello BASE64' ：" + this.message)
          }).margin(5)
        Button(" BASE64字符串解码成普通字符串")
          .onClick((event: ClickEvent) => {
            this.message = fromBase64('aGVsbG8gQkFTRTY0');
            console.log(" BASE64字符串解码成普通字符串 'aGVsbG8gQkFTRTY0'：" + this.message)
          }).margin(5)
        Button(" 计算离输入长度最近的2的幂次方")
          .onClick((event: ClickEvent) => {
            this.message = nearestPowerOf2(3).toString();
            console.log(" 计算离输入长度最近的2的幂次方：" + this.message)
          }).margin(5)
      }
    }.width('100%')
    .height('100%')
  }
}