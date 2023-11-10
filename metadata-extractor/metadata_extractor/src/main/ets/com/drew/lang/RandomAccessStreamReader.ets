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

class RandomAccessStreamReader extends RandomAccessReader {
  public static readonly MAX_VALUE = 0x7fffffff;
  public static readonly DEFAULT_CHUNK_LENGTH: number = 1024 * 10;
  private _stream: fileio.Stream;
  private _chunkLength: number;
  private _chunks: Array<Int8Array> = new Array<Int8Array>();
  private _isStreamFinished: boolean = false;
  private _streamLength: number;
  private filePath: string

  //  public RandomAccessStreamReader(@NotNull InputStream stream)
  //  {
  //      this(stream, RandomAccessStreamReader.DEFAULT_CHUNK_LENGTH, -1);
  //  }
  //
  //  public RandomAccessStreamReader(@NotNull InputStream stream, int chunkLength)
  //  {
  //      this(stream, chunkLength, -1);
  //  }

  public constructor(filePath: string, chunkLength?: number, streamLength?: number) {
    super()
    this.filePath = filePath;
    let fd = fileio.openSync(this.filePath);
    let stream = fileio.fdopenStreamSync(fd.fd, "r+")
    if (stream == null)
    throw new Error('Null Pointer Exception');
    if (chunkLength == null || chunkLength == undefined || chunkLength == 0) {
      chunkLength = RandomAccessStreamReader.DEFAULT_CHUNK_LENGTH;
    }
    if (chunkLength <= 0)
    throw new Error("chunkLength must be greater than zero");
    if (streamLength == null || streamLength == undefined) {
      streamLength = -1
    }
    this._chunkLength = chunkLength;
    this._stream = stream;

    this._streamLength = streamLength;

  }

  /**
   * Reads to the end of the stream, in order to determine the total number of bytes.
   * In general, this is not a good idea for this implementation of {@link RandomAccessReader}.
   *
   * @return the length of the data source, in bytes.
   */
  public getLength(): number {
    if (this._streamLength != -1) {
      return this._streamLength;
    }

    this.isValidIndex(RandomAccessStreamReader.MAX_VALUE, 1);
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
  protected validateIndex(index: number, bytesRequested: number): void {//0 - validateIndex
    if (index < 0) {
      throw new Error("Attempt to read from buffer using a negative index (%d)".replace(/%d/, index.toString()));
    } else if (bytesRequested < 0) {
      throw new Error("Number of requested bytes must be zero or greater");
    } else if (index + bytesRequested - 1 > RandomAccessStreamReader.MAX_VALUE) {
      throw new Error("Number of requested bytes summed with starting index exceed maximum range of signed 32 bit integers (requested index: %d, requested count: %d)"
        .replace(/%d/, index.toString()).replace(/%d/, bytesRequested.toString()));
    }

    if (!this.isValidIndex(index, bytesRequested)) {
      // TODO test that can continue using an instance of this type after this exception
      if (index < 0) {
        throw new Error("Attempt to read from buffer using a negative index (%d)".replace(/%d/, index.toString()));
      }
      if (bytesRequested < 0) {
        throw new Error("Number of requested bytes cannot be negative (%d)".replace(/%d/, bytesRequested.toString()));
      }
      if (index + bytesRequested - 1 > RandomAccessStreamReader.MAX_VALUE) {
        throw new Error("Number of requested bytes summed with starting index exceed maximum range of signed 32 bit integers (requested index: %d, requested count: %d)"
          .replace(/%d/, index.toString()).replace(/%d/, bytesRequested.toString()));
      }
      throw new Error("Attempt to read from beyond end of underlying data source (requested index: %d, requested count: %d, max index: %d)"
        .replace(/%d/, index.toString())
        .replace(/%d/, bytesRequested.toString())
        .replace(/%d/, (this._streamLength - 1).toString()));
    }
  }

  protected isValidIndex(index: number, bytesRequested: number): boolean {//0 - 4
    if (index < 0 || bytesRequested < 0) {
      return false;
    }
    let endIndexLong: number = index + bytesRequested - 1;
//    if (endIndexLong > RandomAccessStreamReader.MAX_VALUE) {
//      return false;
//    }
    let endIndex: number = endIndexLong;
//    if (this._isStreamFinished) {
//      return endIndex < this._streamLength;
//    }
    // TODO test loading several chunks for a single request
    let chunk: ArrayBuffer = new ArrayBuffer(1024 * 10); //2048
    if(!this._isStreamFinished){
      let number = this._stream.readSync(chunk)
      this._chunks.push(new Int8Array(chunk));//0
      this._isStreamFinished = true;
      this._streamLength = number
    }
    return true
  }

  public toUnshiftedOffset(localOffset: number): number {
    return localOffset;
  }

  public getByte(index: number): number {
    if (this._chunks.length < 0) return
    try {
      let chunkIndex = Math.floor(index / this._chunkLength);
      let innerIndex: number = index % this._chunkLength;
      let chunk = this._chunks[0][innerIndex]
      return chunk;
    } catch (e) {
    }

  }

  public getBytes(index: number, count: number): Int8Array {

    this.validateIndex(index, count);

    let bytes: Int8Array = new Int8Array(index);
    let remaining: number = count;
    let fromIndex: number = index;
    let toIndex: number = 0;
    while (remaining != 0) {
      let fromChunkIndex: number = Math.floor(fromIndex / this._chunkLength)
      let fromInnerIndex: number = fromIndex % this._chunkLength;
      let length: number = Math.min(remaining, this._chunkLength - fromInnerIndex);
      let chunk = this._chunks[0].slice(fromInnerIndex,length);
//      bytes = chunk.slice(toIndex,length)
      this.copyBuffer(chunk,fromInnerIndex,bytes,toIndex,length)
      remaining -= length;
      fromIndex += length;
      toIndex += length;
    }
    return bytes
  }

  public copyBuffer(srcArray: Int8Array, srcPosition: number, destArray: Int8Array, destPosition: number, length: number): Int8Array {
    let lengthMin = Math.min(srcArray.length, destArray.length);
    if (lengthMin <= 0) {
      return destArray;
    }else {
      for (let i = 0; i < length; i++) {
        destArray[destPosition+i] = srcArray[srcPosition+i];
      }
    }
    return destArray;
  }
}

export default RandomAccessStreamReader