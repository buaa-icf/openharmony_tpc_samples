/**
 * MIT License
 *
 * Copyright (C) 2025 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import fs from '@ohos.file.fs';
import { Logger } from './Logger';

export const writeFile = (filePath: string, fileName: string, content: string | ArrayBuffer) => {
  try {
    let fullPath = `${filePath}/${fileName}`;
    let file = fs.openSync(fullPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    fs.writeSync(file.fd, content);
    fs.closeSync(file.fd);
  } catch (e) {
    Logger.info("[mammoth]: write file error, message: " + JSON.stringify(e));
  }
}

export async function deleteFile(fullPath: string) {
  try {
    // 检查文件是否存在
    const isExist = fs.accessSync(fullPath);
    if (isExist) {
      // 删除文件
      fs.unlink(fullPath);
    }
  } catch (error) {

  }
}

export const readFile = (fullPath: string) => {
  try {
    let file = fs.openSync(fullPath, 0o2);
    let stat = fs.lstatSync(fullPath);
    let buf = new ArrayBuffer(stat.size);
    fs.readSync(file.fd, buf);
    fs.fsyncSync(file.fd);
    fs.closeSync(file.fd);
    return buf
  } catch (err) {
    Logger.error(`read file failed with error message message: ${err.message}, code: ${err.code}`);
    return undefined;
  }
}