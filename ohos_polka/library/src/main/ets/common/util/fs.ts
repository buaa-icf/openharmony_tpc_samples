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

import fs from '@ohos.file.fs';
import type { ReadOptions } from '@ohos.file.fs';
import buffer from '@ohos.buffer';

// 创建一个大小为1024字节的ArrayBuffer，这将用于存储从文件中读取的数据
let arrayBuffer: ArrayBuffer = new ArrayBuffer(1024);
/**
 * @description 从指定的文件中获取内容
 * @param name 打开的文件的路径
 * @returns 返回从文件中读取的数据
 */
export function getFile(name: string): string {

  // 打开指定名称的文件，并获取文件描述符（同步读取） 两个参数分别表示：
  // name：打开的文件的路径
  // fs.OpenMode.READ_WRITE: 打开文件的模式，这里是读写模式
  let file = fs.openSync(name, fs.OpenMode.READ_WRITE);

  // 创建一个ReadOptions对象, 用于指定从文件中读取数据的位置（从文件的开头开始）和数据的长度（读取的数据不会超过ArrayBuffer的大小）
  let readOptions: ReadOptions = {
    offset: 0,
    length: arrayBuffer.byteLength,
  };

  // 从文件中读取数据，并返回实际读取的数据的长度。（同步读取）
  let readLen = fs.readSync(file.fd, arrayBuffer, readOptions);

  // 关闭文件
  fs.closeSync(file);

  // 使用buffer.from函数将ArrayBuffer转换为Buffer对象，并只保留实际读取的数据。
  let buf = buffer.from(arrayBuffer, 0, readLen);

  // 返回文件读取的数据
  return buf.toString();
}

/**
 * @description 实现文件的创建、写入和读取操作
 * @param filesDir 要创建的文件目录
 * @param name 要创建的文件名
 * @param content 要写入到文件中的内容
 * @returns 读取到的文件内容的字符串形式
 */
export function createFile(filesDir: string, name: string, content: string | ArrayBuffer): number {

  // 打开或创建一个新的文件，打开文件的方法 fs.openSync 需要两个参数（参数1：是文件路径，参数2：是打开文件的模式）
  // 这里使用了fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE, 表示以读写模式打开文件，如果文件不存在则创建新文件
  let file = fs.openSync(`${filesDir}/${name}`, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);

  // 把指定的内容写入到文件中，该方法需要两个参数（参数1：文件的描述符，参数2：要写入的内容）
  let writeLen = fs.writeSync(file.fd, content);

  // 返回文件读取的数据
  return writeLen;
}

/**
 * @description 获取指定目录下的所有文件和子目录
 * @param filesDir 要获取的文件夹路径
 * @returns 指定目录下的所有文件和子目录
 */
export function getListFile(filesDir: string): FileAndDirectory {

  // 获取指定目录下的所有文件和子目录
  let files = fs.listFileSync(filesDir);
  let res = {files: [], directories: []};
  for (let i = 0; i < files.length; i++) {
    const isExits = Boolean(fs.statSync(`${filesDir}/${files[i]}`).isDirectory());
    if (isExits) {
      res.directories.push(files[i]);
    } else {
      res.files.push(files[i]);
    }
  }

  return res;
}

interface FileAndDirectory {
  files: string[];
  directories: string[];
}