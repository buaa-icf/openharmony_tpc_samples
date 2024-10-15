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

import ble from '@ohos.bluetooth.ble';
import { constant } from '@kit.ConnectivityKit';
import { BlufiClient } from './BlufiClient';
import { BlufiScanResult } from './response/BlufiScanResult';
import { BlufiStatusResponse } from './response/BlufiStatusResponse';
import { BlufiVersionResponse } from './response/BlufiVersionResponse';

export enum BlufiGattStatus {
  SUCCESS = 0,
  FAIL,
  OFF,
}

export class BlufiGattCallback {
  /*
   * Callback invoked after BlufiGattCallback receive onConnectionStateChange
   */
  onConnectionStateChange: (device: ble.GattClientDevice, state: constant.ProfileConnectionState,
    bleConnectionState: ble.BLEConnectionChangeState) => void;
  /*
   * Callback invoked after BlufiGattCallback receive onServicesDiscovered
   */
  onServicesDiscovered?: (device: ble.GattClientDevice, services: ble.GattService[]) => void;
  /*
   * Callback invoked after BlufiGattCallback receive writeCharacteristicValue
   */
  onCharacteristicChanged?: (device: ble.GattClientDevice, characteristic: ble.BLECharacteristic,
    status: BlufiGattStatus) => void;
  /*
   * Callback invoked after BlufiGattCallback receive onCharacteristicWrite
   */
  onCharacteristicWrite?: (device: ble.GattClientDevice, characteristic: ble.BLECharacteristic,
    status: BlufiGattStatus) => void;
  /*
   * Callback invoked after BlufiGattCallback receive readCharacteristicValue
   */
  onCharacteristicRead?: (device: ble.GattClientDevice, characteristic: ble.BLECharacteristic,
    status: BlufiGattStatus) => void;
  /*
   * Callback invoked after BlufiGattCallback receive readDescriptorValue
   */
  onDescriptorRead?: (device: ble.GattClientDevice, descriptor: ble.BLEDescriptor, status: BlufiGattStatus) => void;
  /*
   * Callback invoked after BlufiGattCallback receive writeDescriptorValue
   */
  onDescriptorWrite?: (device: ble.GattClientDevice, descriptor: ble.BLEDescriptor, status: BlufiGattStatus) => void;
  /*
   * Callback invoked after BlufiGattCallback receive BLEMtuChange
   */
  onMtuChanged?: (device: ble.GattClientDevice, mtu: number, status: BlufiGattStatus) => void;
}

export class BlufiCallback {
  // STATUS_SUCCESS code
  public static STATUS_SUCCESS: number = 0;

  // invalid notification code
  public static CODE_INVALID_NOTIFICATION: number = -1000;

  // catch exception code
  public static CODE_CATCH_EXCEPTION: number = -1001;

  // write data failed code
  public static CODE_WRITE_DATA_FAILED: number = -1002;

  // invalid data code
  public static CODE_INVALID_DATA: number = -1003;

  // neg post failed code
  public static CODE_NEG_POST_FAILED: number = -2000;

  // neg public key create error code
  public static CODE_NEG_ERR_DEV_KEY: number = -2001;

  // neg sercurity key error code
  public static CODE_NEG_ERR_SECURITY: number = -2002;

  // neg set error code
  public static CODE_NEG_ERR_SET_SECURITY: number = -2003;

  // set opmode invalid code
  public static CODE_CONF_INVALID_OPMODE: number = -3000;

  // set opmode error code
  public static CODE_CONF_ERR_SET_OPMODE: number = -3001;

  // set STA mode error code
  public static CODE_CONF_ERR_POST_STA: number = -3002;

  // set SOFTAP mode error code
  public static CODE_CONF_ERR_POST_SOFTAP: number = -3003;

  // GATT write timeout code
  public static CODE_GATT_WRITE_TIMEOUT: number = -4000;

  // wifi scan failed code
  public static CODE_WIFI_SCAN_FAIL: number = 11;

  /**
   * Callback invoked after BluetoothGattCallback receive onServicesDiscovered
   * User can post Blufi packet now.
   *
   * @param client BlufiClient
   * @param device GattClientDevice
   * @param service null if discover Blufi GattService failed
   * @param writeChar null if discover Blufi write BLECharacteristic failed
   * @param notifyChar null if discover Blufi notify BLECharacteristic failed
   */
  public onGattPrepared: (client: BlufiClient, device: ble.GattClientDevice, service: ble.GattService,
    writeChar: ble.BLECharacteristic, notifyChar: ble.BLECharacteristic) => void;

  /**
   * Callback invoked when receive Gatt notification
   *
   * @param client BlufiClient
   * @param pkgType Blufi package type
   * @param subType Blufi subtype
   * @param data Blufi data
   * @return true if the callback consumed the notification, false otherwise.
   */
  public onGattNotification?: (client: BlufiClient, pkgType: number, subType: number, data: Uint8Array) => boolean;

  /**
   * Callback invoked when received error code from device
   *
   * @param client BlufiClient
   * @param errCode received
   */
  public onError: (client: BlufiClient, errCode: number) => void;

  /**
   * Callback invoked when negotiate security over with device
   *
   * @param client BlufiClient
   * @param status {@link #STATUS_SUCCESS} means negotiate security success
   */
  public onNegotiateSecurityResult?: (client: BlufiClient, status: number) => void;

  /**
   * @deprecated use {@link #onPostConfigureParams(BlufiClient, int)}
   */

  // @Deprecated
  public onConfigureResult?: (client: BlufiClient, status: number) => void;

  /**
   * Callback invoked when post config data over
   *
   * @param client BlufiClient
   * @param status {@link #STATUS_SUCCESS} means post data success
   */
  public onPostConfigureParams?: (client: BlufiClient, status: number) => void;

  /**
   * Callback invoked when received device version
   *
   * @param client BlufiClient
   * @param status {@link #STATUS_SUCCESS} means response is valid
   * @param response BlufiVersionResponse
   */
  public onDeviceVersionResponse?: (client: BlufiClient, status: number, response: BlufiVersionResponse) => void;

  /**
   * Callback invoked when received device status
   *
   * @param client BlufiClient
   * @param status {@link #STATUS_SUCCESS} means response is valid
   * @param response BlufiStatusResponse
   */
  public onDeviceStatusResponse?: (client: BlufiClient, status: number, response: BlufiStatusResponse) => void;

  /**
   * Callback invoked when received device scan results
   *
   * @param client BlufiClient
   * @param status {@link #STATUS_SUCCESS} means response is valid
   * @param results scan result list
   */
  public onDeviceScanResult?: (client: BlufiClient, status: number, results: BlufiScanResult[]) => void;

  /**
   * Callback invoked when post custom data over
   *
   * @param client BlufiClient
   * @param status {@link #STATUS_SUCCESS} means post data success
   * @param data posted
   */
  public onPostCustomDataResult?: (client: BlufiClient, status: number, data: Uint8Array) => void;

  /**
   * Callback invoked when received custom data from device
   *
   * @param client BlufiClient
   * @param status {@link #STATUS_SUCCESS} means receive data success
   * @param data received
   */
  public onReceiveCustomData?: (client: BlufiClient, status: number, data: Uint8Array) => void;
}
