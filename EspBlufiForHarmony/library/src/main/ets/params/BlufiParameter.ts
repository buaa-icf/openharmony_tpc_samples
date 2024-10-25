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

// 控制帧常量
class Ctrl {
  public static readonly PACKAGE_VALUE: number = 0x00;
  public static readonly SUBTYPE_ACK: number = 0x00;
  public static readonly SUBTYPE_SET_SEC_MODE: number = 0x01;
  public static readonly SUBTYPE_SET_OP_MODE: number = 0x02;
  public static readonly SUBTYPE_CONNECT_WIFI: number = 0x03;
  public static readonly SUBTYPE_DISCONNECT_WIFI: number = 0x04;
  public static readonly SUBTYPE_GET_WIFI_STATUS: number = 0x05;
  public static readonly SUBTYPE_DEAUTHENTICATE: number = 0x06;
  public static readonly SUBTYPE_GET_VERSION: number = 0x07;
  public static readonly SUBTYPE_CLOSE_CONNECTION: number = 0x08;
  public static readonly SUBTYPE_GET_WIFI_LIST: number = 0x09;
}

// 数据帧常量
class Data {
  public static readonly PACKAGE_VALUE: number = 0x01;
  public static readonly SUBTYPE_NEG: number = 0x00;
  public static readonly SUBTYPE_STA_WIFI_BSSID: number = 0x01;
  public static readonly SUBTYPE_STA_WIFI_SSID: number = 0x02;
  public static readonly SUBTYPE_STA_WIFI_PASSWORD: number = 0x03;
  public static readonly SUBTYPE_SOFTAP_WIFI_SSID: number = 0x04;
  public static readonly SUBTYPE_SOFTAP_WIFI_PASSWORD: number = 0x05;
  public static readonly SUBTYPE_SOFTAP_MAX_CONNECTION_COUNT: number = 0x06;
  public static readonly SUBTYPE_SOFTAP_AUTH_MODE: number = 0x07;
  public static readonly SUBTYPE_SOFTAP_CHANNEL: number = 0x08;
  public static readonly SUBTYPE_USERNAME: number = 0x09;
  public static readonly SUBTYPE_CA_CERTIFICATION: number = 0x0a;
  public static readonly SUBTYPE_CLIENT_CERTIFICATION: number = 0x0b;
  public static readonly SUBTYPE_SERVER_CERTIFICATION: number = 0x0c;
  public static readonly SUBTYPE_CLIENT_PRIVATE_KEY: number = 0x0d;
  public static readonly SUBTYPE_SERVER_PRIVATE_KEY: number = 0x0e;
  public static readonly SUBTYPE_WIFI_CONNECTION_STATE: number = 0x0f;
  public static readonly SUBTYPE_VERSION: number = 0x10;
  public static readonly SUBTYPE_WIFI_LIST: number = 0x11;
  public static readonly SUBTYPE_ERROR: number = 0x12;
  public static readonly SUBTYPE_CUSTOM_DATA: number = 0x13;
  public static readonly SUBTYPE_WIFI_STA_MAX_CONN_RETRY: number = 0x14;
  public static readonly SUBTYPE_WIFI_STA_CONN_END_REASON: number = 0x15;
  public static readonly SUBTYPE_WIFI_STA_CONN_RSSI: number = 0x16;
}

class Type {
  public static readonly Ctrl = Ctrl
  public static readonly Data = Data
}

// BluFi常用变量
export class BlufiParameter {
  public static readonly UUID_SERVICE: string = "0000FFFF-0000-1000-8000-00805F9B34FB";
  public static readonly UUID_WRITE_CHARACTERISTIC: string = "0000FF01-0000-1000-8000-00805F9B34FB";
  public static readonly UUID_NOTIFICATION_CHARACTERISTIC: string = "0000FF02-0000-1000-8000-00805F9B34FB";
  public static readonly UUID_NOTIFICATION_DESCRIPTOR: string = "00002902-0000-1000-8000-00805F9B34FB";

  public static readonly DIRECTION_OUTPUT: number = 0;
  public static readonly DIRECTION_INPUT: number = 1;

  public static readonly OP_MODE_NULL: number = 0x00;
  public static readonly OP_MODE_STA: number = 0x01;
  public static readonly OP_MODE_SOFTAP: number = 0x02;
  public static readonly OP_MODE_STASOFTAP: number = 0x03;
  public static readonly SOFTAP_SECURITY_OPEN: number = 0x00;
  public static readonly SOFTAP_SECURITY_WEP: number = 0x01;
  public static readonly SOFTAP_SECURITY_WPA: number = 0x02;
  public static readonly SOFTAP_SECURITY_WPA2: number = 0x03;
  public static readonly SOFTAP_SECURITY_WPA_WPA2: number = 0x04;
  public static readonly STA_CONN_SUCCESS: number = 0x00;
  public static readonly STA_CONN_FAIL: number = 0x01;
  public static readonly STA_CONN_CONNECTING: number = 0X02;
  public static readonly STA_CONN_NO_IP: number = 0x03;

  public static readonly WIFI_REASON_4WAY_HANDSHAKE_TIMEOUT: number = 15;
  public static readonly WIFI_REASON_NO_AP_FOUND: number = 201;
  public static readonly WIFI_REASON_HANDSHAKE_TIMEOUT: number = 204;
  public static readonly WIFI_REASON_CONNECTION_FAIL: number = 205;

  public static readonly NEG_SET_SEC_TOTAL_LEN = 0x00;
  public static readonly NEG_SET_SEC_ALL_DATA = 0x01;
  public static readonly SUBTYPE_NEGOTIATION_NEG = 0;

  public static readonly Type = Type
}
