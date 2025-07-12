/*
Copyright (c) 2022 Huawei Device Co., Ltd.
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

import fileio from '@ohos.fileio';
import SequentialReader from './SequentialReader';
import LogUtil from '../tools/LogUtils';

const TAG: string = "StreamReader";

class StreamReader extends SequentialReader {
  private readonly _stream;
  private _pos: number;
  private fileSize:number =0;

  public getPosition(): number
  {
    return this._pos;
  }

  constructor(filePath: string) {
    super();
    LogUtil.debug(TAG, `StreamReader constructor start, filePath: ${filePath}`);
    let stream = fileio.createStreamSync(filePath, 'r+');
    fileio.stat(filePath).then(stat=>{
      this.fileSize = stat.size
    })
    if (stream == null) {
      LogUtil.error(TAG, `StreamReader constructor error: stream is null, filePath: ${filePath}`);
      throw new Error('StreamReader constructor Error');
    }

    this._stream = stream;
    this._pos = 0;
    LogUtil.debug(TAG, `StreamReader constructor end`);
  }

  public getByte(): number
  {
    let byte = new ArrayBuffer(1);
    this._stream.readSync(byte, { length: 1, position: this._pos });
    this._pos++;
    let arr = new Int8Array(byte);
    return this.numberToByte(arr[0]);
  }
  public numberToByte(b: number): number{
    return Int8Array.from([(b | (0x01 << 8))])[0];
  }
  public getBytes(count: number, buffer?: ArrayBuffer, off?: number): Int8Array
  {
    LogUtil.debug(TAG, `getBytes start, count: ${count}, buffer: ${buffer}, off: ${off}`);
    let arrayBuffer: ArrayBuffer = new ArrayBuffer(count);
    let totalBytesRead = 0;
    if (off == undefined) off = 0;
    while (totalBytesRead != count) {
      // let bytesRead = this._stream.readSync(arrayBuffer,{offset:off + totalBytesRead, length:count - totalBytesRead});
      let bytesRead = this._stream.readSync(arrayBuffer,{offset:totalBytesRead, length:count});
      if (bytesRead == -1) {
        LogUtil.error(TAG, `getBytes error: End of data reached, totalBytesRead: ${totalBytesRead}, count: ${count}`);
        throw new Error("End of data reached.");
      }
      totalBytesRead += bytesRead;
    }
    this._pos += totalBytesRead;
    LogUtil.debug(TAG, `getBytes end`);
    return new Int8Array(arrayBuffer)
  }

  public skip(n: number): void
  {
    LogUtil.debug(TAG, `skip start, n: ${n}`);
    if (n < 0) {
      LogUtil.error(TAG, `skip error: n must be zero or greater, n: ${n}`);
      throw new Error("n must be zero or greater.");
    }

    let skippedCount = this.skipInternal(n);

    if (skippedCount != n) {
      LogUtil.error(TAG, `skip error: Unable to skip the requested number of bytes, skippedCount: ${skippedCount}, n: ${n}`);
      throw new Error("Unable to skip.");
    }
    LogUtil.debug(TAG, `skip end, skippedCount: ${skippedCount}`);
  }

  public trySkip(n: number): boolean
  {
    LogUtil.debug(TAG, `trySkip start, n: ${n}`);
    if (n < 0) {
      LogUtil.error(TAG, `trySkip error: n must be zero or greater, n: ${n}`);
      throw new Error("n must be zero or greater.");
    }

    LogUtil.debug(TAG, `trySkip end, this.skipInternal(n): ${this.skipInternal(n)}, n: ${n}`);
    return this.skipInternal(n) == n;
  }

  private skipInternal(n: number): number
  {
    // It seems that for some streams, such as BufferedInputStream, that skip can return
    // some smaller number than was requested. So loop until we either skip enough, or
    // InputStream.skip returns zero.
    //
    // See http://stackoverflow.com/questions/14057720/robust-skipping-of-data-in-a-java-io-inputstream-and-its-subtypes
    //
    LogUtil.debug(TAG, `skipInternal start, n: ${n}`);
    let skippedTotal = 0;
    while (skippedTotal != n) {
      let skipped = this._stream.readSync(new ArrayBuffer(n), { offset: 0, length: n, position: this._pos });
      skippedTotal += skipped;
      if (skipped == 0)
      break;
    }
    this._pos += skippedTotal;
    LogUtil.debug(TAG, `skipInternal end, skippedTotal: ${skippedTotal}`);
    return skippedTotal;
  }

  public available(): number {
    try {
      let sLength = this._stream.readSync(new ArrayBuffer(1024000));
      return sLength
    } catch (e) {
      LogUtil.error(TAG, `available error: ` + JSON.stringify(e));
      return 0;
    }
  }
}

export default StreamReader
