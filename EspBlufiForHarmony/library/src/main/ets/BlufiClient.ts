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
import { BlufiClientImpl } from './BlufiClientImpl';
import { BlufiConfigureParams } from './params/BlufiConfigureParams';
import { BlufiCallback, BlufiGattCallback, } from './BlufiCallback';

export class BlufiClient {
  public static VERSION: string = 'BuildConfig.VERSION_NAME';
  private deviceId: string;
  private readonly mImpl: BlufiClientImpl;
  private device: ble.GattClientDevice;

  constructor(deviceId: string) {
    if (deviceId === null || deviceId.length === 0) {
      throw new Error('deviceId not empty.');
    }
    this.deviceId = deviceId;
    if (deviceId) {
      let device: ble.GattClientDevice = ble.createGattClientDevice(this.deviceId);
      this.device = device;
      this.mImpl = new BlufiClientImpl(this, this.device);
    }
  }

  /**
   * Enable or disable print debug log in BlufiClient
   *
   * @param enable true will print debug log and false will not
   */
  public printDebugLog(enable: boolean): void {
    this.mImpl.printDebugLog(enable);
  }

  /**
   * Set BluetoothGattCallback
   *
   * @param callback the BlufiGattCallback
   */
  public setGattCallback(callback: BlufiGattCallback): void {
    this.mImpl.setGattCallback(callback);
  }

  /**
   * Set the callback
   *
   * @param callback the BlufiCallback
   */
  public setBlufiCallback(callback: BlufiCallback): void {
    this.mImpl.setBlufiCallback(callback);
  }

  /**
   * Set the maximum length of each Blufi packet, the excess part will be subcontracted.
   *
   * @param lengthLimit the maximum length
   */
  public setPostPackageLengthLimit(lengthLimit: number): void {
    this.mImpl.setPostPackageLengthLimit(lengthLimit);
  }

  /**
   * Set gatt write timeout.
   * If timeout, {@link BlufiCallback#onError(BlufiClient, number)} will be invoked,
   * the errCode is {@link BlufiCallback#CODE_GATT_WRITE_TIMEOUT}
   *
   * @param timeout in milliseconds
   */
  public setGattWriteTimeout(timeout: number): void {
    this.mImpl.setGattWriteTimeout(timeout);
  }

  /**
   * Establish a BLE connection with BluetoothDevice
   */
  public connect(): void {
    this.mImpl.connect();
  }

  /**
   * Close the client
   */
  public close(): void {
    this.mImpl.close();
  }

  /**
   * Negotiate security with device. The result will be notified in
   * {@link BlufiCallback#onNegotiateSecurityResult(BlufiClient, number)}
   */
  public negotiateSecurity(): void {
    this.mImpl.negotiateSecurity();
  }

  /**
   * Request device to disconnect the BLE connection
   */
  public requestCloseConnection(): void {
    this.mImpl.requestCloseConnection();
  }

  /**
   * Request to get device version. The result will notified in
   * {@link BlufiCallback#onDeviceVersionResponse(BlufiClient, int, BlufiVersionResponse)}
   */
  public requestDeviceVersion(): void {
    this.mImpl.requestDeviceVersion();
  }

  /**
   * Request to get device current status. The result will be notified in
   * {@link BlufiCallback#onDeviceStatusResponse(BlufiClient, int, BlufiStatusResponse)}
   */
  public requestDeviceStatus(): void {
    this.mImpl.requestDeviceStatus();
  }

  /**
   * Request to get wifi list that the device scanned. The wifi list will be notified in
   * {@link BlufiCallback#onDeviceScanResult(BlufiClient, int, List)}
   */
  public requestDeviceWifiScan(): void {
    this.mImpl.requestDeviceWifiScan();
  }

  /**
   * Configure the device to a station or soft AP. The posted result will be notified in
   * {@link BlufiCallback#onPostConfigureParams(BlufiClient, int)}
   *
   * @param params the config parameter
   */
  public configure(params: BlufiConfigureParams): void {
    this.mImpl.configure(params);
  }

  /**
   * Request to post custom data to device. The posted result will be notified in
   * {@link BlufiCallback#onPostCustomDataResult(BlufiClient, int, byte[])}
   *
   * @param data the custom data
   */
  public postCustomData(data: Uint8Array): void {
    this.mImpl.postCustomData(data);
  }
}
