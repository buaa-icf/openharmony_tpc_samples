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

export class BlufiScanResult {
  public static readonly TYPE_WIFI: number = 0x01;

  private mType: number;
  private mSsid: string;
  private mRssi: number;

  constructor(type?: number, ssid?: string, rssi?: number) {
    this.mType = type || 0;
    this.mSsid = ssid || '';
    this.mRssi = rssi || 0;
  }

  /**
   * 设置扫描结果的类型
   * @param type
   * */
  public setType(type: number): void {
    this.mType = type;
  }

  /**
   * 获取扫描结果的类型
   * @return number
   * */
  public getType(): number {
    return this.mType;
  }

  /**
   * 设置扫描结果的ssid
   * @param ssid
   * */
  public setSsid(ssid: string): void {
    this.mSsid = ssid;
  }

  /**
   * 获取扫描结果的ssid
   * @return string
   * */
  public getSsid(): string {
    return this.mSsid;
  }

  /**
   * 设置扫描结果的rssi
   * @param rssi
   * */
  public setRssi(rssi: number): void {
    this.mRssi = rssi;
  }

  /**
   * 获取扫描结果的rssi
   * @return number
   * */
  public getRssi(): number {
    return this.mRssi;
  }

  /**
   * 获取扫描结果的打印ssid与rssi
   * @return string
   * */
  public toString(): string {
    return `ssid: ${this.mSsid}, rssi: ${this.mRssi}`;
  }
}
