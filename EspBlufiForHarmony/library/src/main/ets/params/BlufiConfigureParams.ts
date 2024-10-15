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

export class BlufiConfigureParams {
  private mOpMode: number;
  private mStaBSSID: string;
  private mStaSSIDBytes: Uint8Array | null;
  private mStaPassword: string;
  private mSoftAPSecurity: number;
  private mSoftAPSSID: string;
  private mSoftAPPassword: string;
  private mSoftAPChannel: number;
  private mSoftAPMaxConnection: number;

  /**
   * 获取OP模式
   * @return number
   */
  public getOpMode(): number {
    return this.mOpMode;
  };

  /**
   * 设置OP模式
   * @param mode 配网模式
   */
  public setOpMode(mode: number): void {
    this.mOpMode = mode;
  };

  /**
   * 获取STA模式的BSSID
   * @return string
   */
  public getStaBSSID(): string {
    return this.mStaBSSID;
  };

  /**
   * 设置STA模式的BSSID
   * @param bssid
   */
  public setStaBSSID(bssid: string): void {
    this.mStaBSSID = bssid;
  };

  /**
   * 设置STA模式的BSSID二进制数据
   * @param staSSIDBytes
   */
  public setStaSSIDBytes(staSSIDBytes: Uint8Array | null): void {
    this.mStaSSIDBytes = staSSIDBytes;
  };

  /**
   * 获取STA模式的BSSID二进制数据
   * @return Uint8Array | null
   */
  public getStaSSIDBytes(): Uint8Array | null {
    return this.mStaSSIDBytes;
  };

  /**
   * 获取STA模式的password
   * @return string
   */
  public getStaPassword(): string {
    return this.mStaPassword;
  };

  /**
   * 设置STA模式的password
   * @param password 密码
   */
  public setStaPassword(password: string): void {
    this.mStaPassword = password;
  };

  /**
   * 获取SoftAP模式的security
   * @return number
   */
  public getSoftAPSecurity(): number {
    return this.mSoftAPSecurity;
  };

  /**
   * 设置SoftAP模式的security
   * @param security
   */
  public setSoftAPSecurity(security: number): void {
    this.mSoftAPSecurity = security;
  };

  /**
   * 获取SoftAP模式的ssid
   * @return string
   */
  public getSoftAPSSID(): string {
    return this.mSoftAPSSID;
  };

  /**
   * 设置SoftAP模式的ssid
   * @param ssid
   */
  public setSoftAPSSID(ssid: string): void {
    this.mSoftAPSSID = ssid;
  };

  /**
   * 获取SoftAP模式的password
   * @return string
   */
  public getSoftAPPassword(): string {
    return this.mSoftAPPassword;
  };

  /**
   * 设置SoftAP模式的password
   * @param password
   */
  public setSoftAPPassword(password: string): void {
    this.mSoftAPPassword = password;
  };

  /**
   * 获取SoftAP模式的channel
   * @return number
   */
  public getSoftAPChannel(): number {
    return this.mSoftAPChannel;
  };

  /**
   * 设置SoftAP模式的channel
   * @param channel
   */
  public setSoftAPChannel(channel: number): void {
    this.mSoftAPChannel = channel;
  };

  /**
   * 获取SoftAP模式的maxConnection
   * @return number
   */
  public getSoftAPMaxConnection(): number {
    return this.mSoftAPMaxConnection;
  };

  /**
   * 设置SoftAP模式的maxConnection
   * @param connectionCount
   */
  public setSoftAPMaxConnection(connectionCount: number): void {
    this.mSoftAPMaxConnection = connectionCount;
  };

  /**
   * 获取BlufiConfigureParams类支持ToString
   * @return string
   */
  public toString(): string {
    const staSSID: string | null = this.mStaSSIDBytes === null ? null : `${this.mStaSSIDBytes}`;
    return `op mode = ${this.mOpMode},
            sta bssid = ${this.mStaBSSID},
            sta ssid = ${staSSID},
            sta password = ${this.mStaPassword},
            softap security = ${this.mSoftAPSecurity},
            softap ssid = ${this.mSoftAPSSID},
            softap password = ${this.mSoftAPPassword},
            softap channel = ${this.mSoftAPChannel},
            softap max connection = ${this.mSoftAPMaxConnection}`;
  }
}
