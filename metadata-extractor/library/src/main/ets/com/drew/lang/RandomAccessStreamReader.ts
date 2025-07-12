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

import fileio from '@ohos.file.fs';
import RandomAccessReader from './RandomAccessReader'
import LogUtil from '../tools/LogUtils';

const TAG: string = "RandomAccessStreamReader";

class RandomAccessStreamReader extends RandomAccessReader {
  public static readonly MAX_VALUE = 0x7fffffff;
  public static readonly DEFAULT_CHUNK_LENGTH: number = 2 * 1024;
  private _stream: fileio.Stream;
  private _chunkLength: number;
  private _chunks: Array<Int8Array> = new Array<Int8Array>();
  private _isStreamFinished: boolean = false;
  private _streamLength: number= -1;


  public constructor(filePath: string, chunkLength?: number, streamLength?: number) {
    super()
    LogUtil.debug(TAG, `constructor start, filePath: ${filePath},` +
        ` chunkLength: ${chunkLength}, streamLength: ${streamLength}`);
    let stream = fileio.createStreamSync(filePath, "r+")
    if (stream == null) {
      LogUtil.error(TAG, `constructor error: stream is null`);
      throw new Error('stream Null Pointer Exception');
    }
    if (chunkLength == null || chunkLength == undefined) {
      LogUtil.debug(TAG, `chunkLength is null or undefined, setting to DEFAULT_CHUNK_LENGTH`);
      chunkLength = RandomAccessStreamReader.DEFAULT_CHUNK_LENGTH;
    }
    if (chunkLength <= 0) {
      LogUtil.error(TAG, `constructor error: chunkLength must be greater than zero`);
      throw new Error("RandomAccessStreamReader chunkLength must be greater than zero");
    }
    if (streamLength == null || streamLength == undefined) {
      LogUtil.debug(TAG, `streamLength is null or undefined, setting to -1`);
      streamLength = -1
    }
    this._chunkLength = chunkLength;
    this._stream = stream;

    this._streamLength = streamLength;
    LogUtil.debug(TAG, `constructor end`);
  }

  /**
   * Reads to the end of the stream, in order to determine the total number of bytes.
   * In general, this is not a good idea for this implementation of {@link RandomAccessReader}.
   *
   * @return the length of the data source, in bytes.
   */
  public getLength(): number {
    LogUtil.debug(TAG, `getLength start, _streamLength: ${this._streamLength}`);
    if (this._streamLength != -1) {
      return this._streamLength;
    }

    this.isValidIndex(RandomAccessStreamReader.MAX_VALUE, 1);
    LogUtil.debug(TAG, `getLength end`);
    return this._streamLength;
  }

  /**
   * Ensures that the buffered bytes extend to cover the specified index. If not, an attempt is made
   * to read to that point.
   * <p>
   * If the stream ends before the point is reached, a {@link BufferBoundsException} is raised.
   *
   * @param index the index from which the required bytes start
   * @param bytesRequested the number of bytes which are required
   * @throws BufferBoundsException if the stream ends before the required number of bytes are acquired
   */
  protected validateIndex(index: number, bytesRequested: number): void { //0 - validateIndex
    LogUtil.debug(TAG, `validateIndex start, index: ${index}, bytesRequested: ${bytesRequested}`);
    if (index < 0) {
      LogUtil.error(TAG, `validateIndex error: Attempt to read from buffer using a negative index (${index})`);
      throw new Error("Attempt to read from buffer using a negative index (%d)".replace(/%d/, index.toString()));
    } else if (bytesRequested < 0) {
      LogUtil.error(TAG, `validateIndex error: Number of requested bytes cannot be negative (${bytesRequested})`);
      throw new Error("Number of requested bytes must be zero or greater");
    } else if (index + bytesRequested - 1 > RandomAccessStreamReader.MAX_VALUE) {
      LogUtil.error(TAG, `validateIndex error: Number of requested bytes summed with starting index exceed maximum range of signed 32 bit integers (requested index: ${index}, requested count: ${bytesRequested})`);
      throw new Error("Number of requested bytes summed with starting index exceed maximum range of signed 32 bit integers (requested index: %d, requested count: %d)"
        .replace(/%d/, index.toString()).replace(/%d/, bytesRequested.toString()));
    }

    if (!this.isValidIndex(index, bytesRequested)) {
      if (index < 0) {
        LogUtil.error(TAG, `validateIndex error: Attempt to read from buffer using a negative index (${index})`);
        throw new Error("Attempt to read from buffer using a negative index (%d)".replace(/%d/, index.toString()));
      }
      if (bytesRequested < 0) {
        LogUtil.error(TAG, `validateIndex error: Number of requested bytes cannot be negative (${bytesRequested})`);
        throw new Error("Number of requested bytes cannot be negative (%d)".replace(/%d/, bytesRequested.toString()));
      }
      if (index + bytesRequested - 1 > RandomAccessStreamReader.MAX_VALUE) {
        LogUtil.error(TAG, `validateIndex error: Number of requested bytes summed with starting index exceed maximum range of signed 32 bit integers (requested index: ${index}, requested count: ${bytesRequested})`);
        throw new Error("Number of requested bytes summed with starting index exceed maximum range of signed 32 bit integers (requested index: %d, requested count: %d)"
          .replace(/%d/, index.toString()).replace(/%d/, bytesRequested.toString()));
      }
      throw new Error("Attempt to read from beyond end of underlying data source (requested index: %d, requested count: %d, max index: %d)"
        .replace(/%d/, index.toString())
        .replace(/%d/, bytesRequested.toString())
        .replace(/%d/, (this._streamLength - 1).toString()));
    }
    LogUtil.debug(TAG, `validateIndex end`);
  }

  protected isValidIndex(index: number, bytesRequested: number): boolean { //0 - 4
    LogUtil.debug(TAG, `isValidIndex start, index: ${index}, bytesRequested: ${bytesRequested}`);
    if (index < 0 || bytesRequested < 0) {
      return false;
    }
    //41832+57737 = 99569
    let endIndexLong: number = index + bytesRequested - 1;
    if (endIndexLong > RandomAccessStreamReader.MAX_VALUE) {
      LogUtil.error(TAG, `isValidIndex error: Number of requested bytes summed with starting index exceed maximum range of signed 32 bit integers (requested index: ${index}, requested count: ${bytesRequested})`);
      return false;
    }
    let endIndex: number = endIndexLong;
    if (this._isStreamFinished) {
      LogUtil.debug(TAG, `isValidIndex end, _isStreamFinished is true, endIndex: ${endIndex}, _streamLength: ${this._streamLength}`);
      return endIndex < this._streamLength;
    }
    //
    let chunkIndex = Math.floor(endIndex / this._chunkLength);

    while (chunkIndex >= this._chunks.length) {

      let chunk = new ArrayBuffer(this._chunkLength);
      let totalBytesRead = 0;
      while (!this._isStreamFinished && totalBytesRead != this._chunkLength) {
        let bytesRead = this._stream.readSync(chunk, {
          offset: totalBytesRead,
          length: this._chunkLength - totalBytesRead
        });
        if (bytesRead == -1) {
          // the stream has ended, which may be ok
          this._isStreamFinished = true;
          let observedStreamLength = this._chunks.length * this._chunkLength + totalBytesRead;
          if (this._streamLength == -1) {
            this._streamLength = observedStreamLength;
          } else if (this._streamLength != observedStreamLength) {
            LogUtil.error(TAG, `RandomAccessStreamReader _streamLength !=observedStreamLength`);
          }

          // check we have enough bytes for the requested index
          if (endIndex >= this._streamLength) {
            let source=new Int8Array(chunk);
            this._chunks.push(source);
            LogUtil.debug(TAG, `isValidIndex end, endIndex: ${endIndex}, _streamLength: ${this._streamLength}`);
            return false;
          }
        } else {
          totalBytesRead += bytesRead;
        }
      }
      this._chunks.push(new Int8Array(chunk));

    }
    LogUtil.debug(TAG, `isValidIndex end`);
    return true
  }

  public toUnshiftedOffset(localOffset: number): number {
    return localOffset;
  }

  public getByte(index: number): number {
    if (this._chunks.length < 0) {
      LogUtil.error(TAG, `getByte error: _chunks is empty`);
      return 0;
    }
    try {
      let chunkIndex = Math.floor(index / this._chunkLength);
      let innerIndex: number = index % this._chunkLength;
      let chunk = this._chunks[chunkIndex]
      return chunk[innerIndex];
    } catch (e) {
      LogUtil.error(TAG, `getByte error: ${JSON.stringify(e)}`);
      console.error("RandomAccessStreamReader getByte error")
    }

  }

  public getBytes(index: number, count: number): Int8Array {
    LogUtil.debug(TAG, `getBytes start, index: ${index}, count: ${count}`);
    this.validateIndex(index, count);
    let bytes: Int8Array = new Int8Array(count);
    let remaining: number = count;
    let fromIndex: number = index;
    let toIndex: number = 0;
    while (remaining != 0) {
      let fromChunkIndex: number = Math.floor(fromIndex / this._chunkLength)

      let fromInnerIndex: number = fromIndex % this._chunkLength;
      let length: number = Math.min(remaining, this._chunkLength - fromInnerIndex);
      let chunk = this._chunks[fromChunkIndex];
      this.copyBuffer(chunk,fromInnerIndex, bytes, toIndex, length)

      remaining -= length;
      fromIndex += length;
      toIndex += length;
    }
    LogUtil.debug(TAG, `getBytes end, bytes: ${bytes}`);
    return bytes
  }
  public copyBuffer(srcArray: Int8Array, srcPosition: number, destArray: Int8Array, destPosition: number, length: number): Int8Array {
    for (let i = 0; i < length; i++) {
      destArray[destPosition+i] = srcArray[srcPosition+i];
    }
    return destArray;
  }
}

export default RandomAccessStreamReader