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

import RandomAccessReader from './RandomAccessReader'
import LogUtil from '../tools/LogUtils';

const TAG: string = "ByteArrayReader";

class ByteArrayReader extends RandomAccessReader {
  public static readonly MAX_VALUE = 0x7fffffff;
  private readonly _buffer: Int8Array;
  private readonly _baseOffset: number = 0;

  public constructor(buffer?: Int8Array, baseOffset?: number) {
    super();
    LogUtil.debug(TAG, `ByteArrayReader constructor, buffer: ${buffer}, baseOffset: ${baseOffset}`);
    if (baseOffset == null || baseOffset == undefined) {
      baseOffset = 0;
    }
    if (buffer == null)
    if (baseOffset < 0)
    throw new Error("Must be zero or greater");
    this._buffer = buffer;
    this._baseOffset = baseOffset;
    LogUtil.debug(TAG, `ByteArrayReader constructor end, _buffer: ${this._buffer}, _baseOffset: ${this._baseOffset}`);
  }

  public toUnshiftedOffset(localOffset: number): number {
    return localOffset + this._baseOffset;
  }

  public getLength(): number {
    return this._buffer.byteLength - this._baseOffset;
  }

  public getByte(index: number): number {
    this.validateIndex(index, 1);
    return this._buffer[index + this._baseOffset];
  }

  protected validateIndex(index: number, bytesRequested: number): void {
    LogUtil.debug(TAG, `validateIndex start, index: ${index}, bytesRequested: ${bytesRequested}`);
    if (!this.isValidIndex(index, bytesRequested)) {
      let offset: number = this.toUnshiftedOffset(index)
      if (offset < 0) {
        throw new Error("Attempt to read from buffer using a negative index (%d)".replace(/%d/, offset.toString()));
      }
      if (bytesRequested < 0) {
        throw new Error("Number of requested bytes cannot be negative (%d)".replace(/%d/, bytesRequested.toString()));
      }
      if (index + bytesRequested - 1 > ByteArrayReader.MAX_VALUE) {
        throw new Error("Number of requested bytes summed with starting index exceed maximum range of signed 32 bit integers (requested index: %d, requested count: %d)"
          .replace(/%d/, offset.toString()).replace(/%d/, bytesRequested.toString()));
      }
      throw new Error("Attempt to read from beyond end of underlying data source (requested index: %d, requested count: %d, max index: %d)"
        .replace(/%d/, offset.toString())
        .replace(/%d/, bytesRequested.toString())
        .replace(/%d/, (this._buffer.byteLength - 1).toString()));
    }
    LogUtil.debug(TAG, `validateIndex end`);
  }

  protected isValidIndex(index: number, bytesRequested: number): boolean {
    return bytesRequested >= 0
    && index >= 0
    && index + bytesRequested - 1 < this.getLength();
  }

  public getBytes(index: number, count: number): Int8Array {
    LogUtil.debug(TAG, `getBytes start, index: ${index}, count: ${count}`);
    this.validateIndex(index, count);
    let bytes: Int8Array = new Int8Array(count)
    let startIndex: number = index + this._baseOffset;
    bytes = this._buffer.slice(startIndex, startIndex + count);
    LogUtil.debug(TAG, `getBytes end, bytes: ${bytes}`);
    return bytes;
  }
}

export default ByteArrayReader