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

import { BlufiParameter } from '../params/BlufiParameter';

class StringBuilder {
  private parts: string[] = [];

  /**
   * 给字符串数据添加字符串
   * @param str
   * */
  public append(str: string): this {
    this.parts.push(str);
    return this;
  }

  /**
   * 获取字符串数组字符串
   * @return str
   * */
  public toString(): string {
    return this.parts.join('');
  }
}

export class BlufiStatusResponse {
  TWENTY_FOUR: number = 24;
  FIFTY_THREE: number = 53;
  TWO_HUNDRED: number = 200;
  TWO_HUNDRED_AND_SEVEN: number = 207;
  MIN_RSSI: number = -128;
  MAX_RSSI: number = 127;
  private mOpMode: number = -1;
  private mSoftAPSecurity: number = -1;
  private mSoftAPConnCount: number = -1;
  private mSoftAPMaxConnCount: number = -1;
  private mSoftAPChannel: number = -1;
  private mSoftAPPassword: string | null = null;
  private mSoftAPSSID: string | null = null;
  private mStaConnectionStatus: number = -1;
  private mStaBSSID: string | null = null;
  private mStaSSID: string | null = null;
  private mStaPassword: string | null = null;
  private readonly mConnectionRssiLimit: number = -60;
  private mConnectionMaxRetry: number = -1;
  private mConnectionEndReason: number = -1;
  private mConnectionRssi: number = -128;

  /**
   * 获取OP模式
   * @return number
   * */
  public getOpMode(): number {
    return this.mOpMode;
  }

  /**
   * 设置OP模式
   * @param mode
   * */
  public setOpMode(mode: number): void {
    this.mOpMode = mode;
  }

  /**
   * 获取SoftAP模式的ConnectionCount
   * @return number
   * */
  public getSoftAPConnectionCount(): number {
    return this.mSoftAPConnCount;
  }

  /**
   * 获取SoftAP模式的ConnectionCount
   * @return number
   * */
  public setSoftAPConnectionCount(count: number): void {
    this.mSoftAPConnCount = count;
  }

  /**
   * 获取SoftAP模式的maxConnection
   * @return number
   * */
  public getSoftAPMaxConnectionCount(): number {
    return this.mSoftAPMaxConnCount;
  }

  /**
   * 获取SoftAP模式的maxConnection
   * @return number
   * */
  public setSoftAPMaxConnectionCount(maxCount: number): void {
    this.mSoftAPMaxConnCount = maxCount;
  }

  /**
   * 获取SoftAP模式的security
   * @return number
   * */
  public getSoftAPSecurity(): number {
    return this.mSoftAPSecurity;
  }

  /**
   * 设置SoftAP模式的security
   * @param security
   * */
  public setSoftAPSecurity(security: number): void {
    this.mSoftAPSecurity = security;
  }

  /**
   * 获取SoftAP模式的channel
   * @return number
   * */
  public getSoftAPChannel(): number {
    return this.mSoftAPChannel;
  }

  /**
   * 设置SoftAP模式的channel
   * @param channel
   * */
  public setSoftAPChannel(channel: number): void {
    this.mSoftAPChannel = channel;
  }

  /**
   * 获取SoftAP模式的password
   * @return string
   * */
  public getSoftAPPassword(): string {
    return this.mSoftAPPassword;
  }

  /**
   * 设置SoftAP模式的password
   * @param password
   * */
  public setSoftAPPassword(password: string): void {
    this.mSoftAPPassword = password;
  }

  /**
   * 获取SoftAP模式的ssid
   * @return string
   * */
  public getSoftAPSSID(): string {
    return this.mSoftAPSSID;
  }

  /**
   * 设置SoftAP模式的ssid
   * @param ssid
   * */
  public setSoftAPSSID(ssid: string): void {
    this.mSoftAPSSID = ssid;
  }

  /**
   * 获取STA模式的连接状态
   * @return number
   * */
  public getStaConnectionStatus(): number {
    return this.mStaConnectionStatus;
  }

  /**
   * 获取STA模式的wifi是否连接
   * @return boolean
   * */
  public isStaConnectWifi(): boolean {
    return this.mStaConnectionStatus === 0;
  }

  /**
   * 设置STA模式的连接状态
   * @param status
   * */
  public setStaConnectionStatus(status: number): void {
    this.mStaConnectionStatus = status;
  }

  /**
   * 获取STA模式的BSSID
   * @return string
   * */
  public getStaBSSID(): string {
    return this.mStaBSSID;
  }

  /**
   * 设置STA模式的BSSID
   * @param bssid
   * */
  public setStaBSSID(bssid: string) {
    this.mStaBSSID = bssid;
  }

  /**
   * 获取STA模式的SSID
   * @return string
   * */
  public getStaSSID(): string {
    return this.mStaSSID;
  }

  /**
   * 设置STA模式的SSID
   * @param ssid
   * */
  public setStaSSID(ssid: string): void {
    this.mStaSSID = ssid;
  }

  /**
   * 获取STA模式的password
   * @return string
   * */
  public getStaPassword(): string {
    return this.mStaPassword;
  }

  /**
   * 设置STA模式的password
   * @param password
   * */
  public setStaPassword(password: string): void {
    this.mStaPassword = password;
  }

  /**
   * 设置MaxRetry
   * @param maxRetry
   * */
  public setMaxRetry(maxRetry: number): void {
    this.mConnectionMaxRetry = maxRetry;
  }

  /**
   * 设置EndReason
   * @param reason
   * */
  public setEndReason(reason: number): void {
    this.mConnectionEndReason = reason;
  }

  /**
   * 设置rssi
   * @param rssi
   * */
  public setRssi(rssi: number): void {
    this.mConnectionRssi = rssi;
  }

  /**
   * 获取状态结果类有效信息
   * @return string
   * */
  public generateValidInfo(): string {
    let info: StringBuilder = new StringBuilder();
    info.append('OpMode: ');
    switch (this.mOpMode) {
      case BlufiParameter.OP_MODE_NULL:
        info.append('NULL');
        break;
      case BlufiParameter.OP_MODE_STA:
        info.append('Station');
        break;
      case BlufiParameter.OP_MODE_SOFTAP:
        info.append('SoftAP');
        break;
      case BlufiParameter.OP_MODE_STASOFTAP:
        info.append('Station/SoftAP');
        break;
    }
    info.append('\n');

    switch (this.mOpMode) {
      case BlufiParameter.OP_MODE_STA:
      case BlufiParameter.OP_MODE_STASOFTAP:
        this.checkStationData(info);
        break;
    }

    switch (this.mOpMode) {
      case BlufiParameter.OP_MODE_SOFTAP:
      case BlufiParameter.OP_MODE_STASOFTAP:
        this.checkSoftAPData(info);
        break;
    }
    return info.toString();
  }

  private checkSoftAPData(info: StringBuilder) {
    switch (this.mSoftAPSecurity) {
      case BlufiParameter.SOFTAP_SECURITY_OPEN:
        info.append('SoftAP security: ').append('OPEN').append('\n');
        break;
      case BlufiParameter.SOFTAP_SECURITY_WEP:
        info.append('SoftAP security: ').append('WEP').append('\n');
        break;
      case BlufiParameter.SOFTAP_SECURITY_WPA:
        info.append('SoftAP security: ').append('WPA').append('\n');
        break;
      case BlufiParameter.SOFTAP_SECURITY_WPA2:
        info.append('SoftAP security: ').append('WPA2').append('\n');
        break;
      case BlufiParameter.SOFTAP_SECURITY_WPA_WPA2:
        info.append('SoftAP security: ').append('WPA/WPA2').append('\n');
        break;
    }
    if (this.mSoftAPSSID != null) {
      info.append('SoftAP ssid: ').append(this.mSoftAPSSID).append('\n');
    }
    if (this.mSoftAPPassword != null) {
      info.append('SoftAP password: ').append(this.mSoftAPPassword).append('\n');
    }
    if (this.mSoftAPChannel >= 0) {
      info.append('SoftAP channel: ').append(this.mSoftAPChannel.toString()).append('\n');
    }
    if (this.mSoftAPMaxConnCount > 0) {
      info.append('SoftAP max connection: ').append(this.mSoftAPMaxConnCount.toString()).append('\n');
    }
    if (this.mSoftAPConnCount >= 0) {
      info.append('SoftAP current connection: ').append(this.mSoftAPConnCount.toString()).append('\n');
    }
  }

  private checkStationData(info: StringBuilder) {
    if (this.isStaConnectWifi()) {
      info.append('Station connect Wi-Fi now, got IP\n');
    } else if (this.getStaConnectionStatus() == BlufiParameter.STA_CONN_NO_IP) {
      info.append('Station connect Wi-Fi now, no IP found\n');
    } else if (this.getStaConnectionStatus() == BlufiParameter.STA_CONN_FAIL) {
      info.append('Station disconnect Wi-Fi now\n');
      info.append(this.getEndInfo());
    } else {
      info.append('Station is connecting WiFi now\n');
      info.append(this.getConnectingInfo());
    }
    if (this.mStaBSSID != null) {
      info.append('Station connect Wi-Fi bssid: ').append(this.mStaBSSID).append('\n');
    }
    if (this.mStaSSID != null) {
      info.append('Station connect Wi-Fi ssid: ').append(this.mStaSSID).append('\n');
    }
    if (this.mStaPassword != null) {
      info.append('Station connect Wi-Fi password: ').append(this.mStaPassword).append('\n');
    }
  }

  private isReasonValid(reason: number): boolean {
    return ((reason >= 0 && reason <= this.TWENTY_FOUR) || (reason === this.FIFTY_THREE) ||
      (reason >= this.TWO_HUNDRED && reason <=
      this.TWO_HUNDRED_AND_SEVEN));
  }

  private isRssiValid(rssi: number): boolean {

    /* define rssi -128 as N/A */
    return (rssi > -this.MIN_RSSI && rssi <= this.MAX_RSSI);
  }

  private getEndInfo(): string {
    let msg: StringBuilder = new StringBuilder();
    msg.append('Reason code: ')
      .append(this.isReasonValid(this.mConnectionEndReason) ? String(this.mConnectionEndReason) : 'N/A').append(', ');
    msg.append('Rssi: ').append(this.isRssiValid(this.mConnectionRssi) ? String(this.mConnectionRssi) : 'N/A')
      .append('\n');
    if (this.mConnectionEndReason === BlufiParameter.WIFI_REASON_NO_AP_FOUND) {
      msg.append('NO AP FOUND').append('\n');
    } else if (this.mConnectionEndReason === BlufiParameter.WIFI_REASON_CONNECTION_FAIL) {
      msg.append('AP IN BLACKLIST, PLEASE RETRY').append('\n');
    } else if (this.isRssiValid(this.mConnectionRssi)) {
      if (this.mConnectionRssi < this.mConnectionRssiLimit) {
        msg.append('RSSI IS TOO LOW').append('\n');
      } else if (this.mConnectionEndReason === BlufiParameter.WIFI_REASON_4WAY_HANDSHAKE_TIMEOUT ||
        this.mConnectionEndReason === BlufiParameter.WIFI_REASON_HANDSHAKE_TIMEOUT) {
        msg.append('WRONG PASSWORD').append('\n');
      }
    }

    return msg.toString();
  }

  private getConnectingInfo(): string {
    let msg: StringBuilder = new StringBuilder();
    msg.append('Max Retry is ');
    if (this.mConnectionMaxRetry === -1) {
      msg.append('N/A\n');
    } else {
      msg.append(this.mConnectionMaxRetry.toString()).append('\n');
    }
    return msg.toString();
  }
}
