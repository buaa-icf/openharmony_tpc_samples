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

export class BlufiNotifyData {
  private mTypeValue: number;
  private mPkgType: number;
  private mSubType: number;
  private mFrameCtrlValue: number;

  private mDataBuffer: ArrayBuffer;
  private mDataView: DataView;
  private mDataOffset: number;
  private ONE_KB: number = 1024;

  constructor() {

    // 初始化一个较大的缓冲区，根据实际情况调整大小
    this.mDataBuffer = new ArrayBuffer(this.ONE_KB);
    this.mDataView = new DataView(this.mDataBuffer);

    // 记录已写入数据的偏移量
    this.mDataOffset = 0;
  }

  /**
   * 获取esp32的数据格式type
   * @return number
   * */
  public getType(): number {
    return this.mTypeValue;
  }

  /**
   * 设置esp32的数据格式type
   * @return typeValue
   * */
  public setType(typeValue: number): void {
    this.mTypeValue = typeValue;
  }

  /**
   * 获取esp32的数据格式帧pkgType
   * @return number
   * */
  public getPkgType(): number {
    return this.mPkgType;
  }

  /**
   * 设置esp32的数据格式帧pkgType
   * @param pkgType
   * */
  public setPkgType(pkgType: number): void {
    this.mPkgType = pkgType;
  }

  /**
   * 获取esp32的数据格式帧子类型subType
   * @return number
   * */
  public getSubType(): number {
    return this.mSubType;
  }

  /**
   * 设置esp32的数据格式帧子类型subType
   * @param subType
   * */
  public setSubType(subType: number): void {
    this.mSubType = subType;
  }

  /**
   * 获取esp32的数据格式帧控制framectrl
   * @return number
   * */
  public getFrameCtrl(): number {
    return this.mFrameCtrlValue;
  }

  /**
   * 设置esp32的数据格式帧控制framectrl
   * @param frameCtrl
   * */
  public setFrameCtrl(frameCtrl: number): void {
    this.mFrameCtrlValue = frameCtrl;
  }

  /**
   * 设置esp32的数据的数据值
   * @param bytes
   * @param offset
   * */
  public addData(bytes: Uint8Array, offset: number): void {
    const bytesLength: number = bytes.length;
    if (this.mDataOffset + bytesLength > this.mDataBuffer.byteLength) {
      // 如果当前缓冲区不足以存放新数据，可以考虑扩容或处理错误
      throw new Error('Not enough buffer space. Consider resizing the buffer.');
    }
    for (let i = offset; i < bytesLength; i++) {
      this.mDataView.setUint8(this.mDataOffset++, bytes[i]);
    }
  }

  /**
   * 返回esp32的数据的数据值
   * @return Uint8Array
   * */
  public getDataArray(): Uint8Array {
    return new Uint8Array(this.mDataBuffer, 0, this.mDataOffset);
  }
}
