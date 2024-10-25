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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, } from '@ohos/hypium'
import { util } from '@kit.ArkTS'
import { ble, constant } from '@kit.ConnectivityKit'
import {
  BlufiClient,
  BlufiVersionResponse,
  BlufiStatusResponse,
  BlufiScanResult,
  BlufiCallback,
  BlufiGattCallback,
  BlufiGattStatus,
  Logger as LogUtil,
  BlufiConfigureParams,
  BlufiParameter,
  BlufiUtil
} from '@ohos/espblufiforharmony'


const TAG: string = 'BlufiClientTest';

export default function BlufiClientTest() {
  describe('BlufiClientTest', () => {

    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {

      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {

      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {

      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {

      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    it('BlufiClient', 0, async () => {

      try {
        let errorDeviceClient: BlufiClient = new BlufiClient('');
      } catch (e) {
      }

      let deviceId: string = '9C:DD:1F:07:29:49';
      let SLEEP_DURATION: number = 50;
      let SET_GATT_WRITE_TIMEOUT: number = 500000;
      let SET_POST_PACKAGE_LENGTH_LIMIT: number = 512;
      let ONE_THOUSAND: number = 1000;
      let TWO: number = 2;
      let client = new BlufiClient(deviceId);

      expect(client !== null).assertTrue();

      client.printDebugLog(true);

      let gattCk: BlufiGattCallback = {
        onConnectionStateChange: (device: ble.GattClientDevice, state: constant.ProfileConnectionState,
          bleConnectionState: ble.BLEConnectionChangeState) => {
          LogUtil.info(TAG, 'onConnectionStateChange：' + state);
          let status = state == constant.ProfileConnectionState.STATE_CONNECTED;
        },
        onServicesDiscovered: (device: ble.GattClientDevice, services: ble.GattService[]) => {
          LogUtil.info(TAG, 'onServicesDiscovered：' + services.toLocaleString());
        },

        /*
         * Callback invoked after BlufiGattCallback receive onCharacteristicWrite
         */
        onCharacteristicWrite: (device: ble.GattClientDevice, characteristic: ble.BLECharacteristic,
          status: BlufiGattStatus) => {
          LogUtil.info(TAG, 'onCharacteristicWrite：' + status);
        },

        /*
         * Callback invoked after BlufiGattCallback receive readCharacteristicValue
         */
        onCharacteristicRead: (device: ble.GattClientDevice, characteristic: ble.BLECharacteristic,
          status: BlufiGattStatus) => {
          LogUtil.info(TAG, 'onCharacteristicRead：' + status);
        },

        /*
         * Callback invoked after BlufiGattCallback receive readDescriptorValue
         */
        onDescriptorRead: (device: ble.GattClientDevice, descriptor: ble.BLEDescriptor, status: BlufiGattStatus) => {
          LogUtil.info(TAG, 'onDescriptorRead：' + status);
        },

        /*
         * Callback invoked after BlufiGattCallback receive writeDescriptorValue
         */
        onDescriptorWrite: (device: ble.GattClientDevice, descriptor: ble.BLEDescriptor, status: BlufiGattStatus) => {
          LogUtil.info(TAG, 'onDescriptorWrite：' + status);
        },

        /*
         * Callback invoked after BlufiGattCallback receive BLEMtuChange
         */
        onMtuChanged: (device: ble.GattClientDevice, mtu: number, status: BlufiGattStatus) => {
          LogUtil.info(TAG, 'onMtuChanged：' + status);
        },
      }
      let blueCk: BlufiCallback = {
        onGattPrepared: (client: BlufiClient, device: ble.GattClientDevice, service: ble.GattService,
          writeChar: ble.BLECharacteristic, notifyChar: ble.BLECharacteristic): void => {
          LogUtil.info(TAG, 'onGattPrepared');
        },
        onError: (client: BlufiClient, errCode: number): void => {
          LogUtil.info(TAG, 'BlufiCallback-onError：' + errCode);

        },
        onGattNotification: (client: BlufiClient, pkgType: number, subType: number, data: Uint8Array): boolean => {
          LogUtil.info(TAG, 'onGattNotification：' +
          util.format('pkgtype:%s,subType:%s,data:%s', pkgType, subType, data.toLocaleString()))
          return false;
        },
        onNegotiateSecurityResult: (client: BlufiClient, status: number) => {
          LogUtil.info(TAG, 'onNegotiateSecurityResult：' + status);
        },
        onPostConfigureParams: (client: BlufiClient, status: number) => {
          LogUtil.info(TAG, 'onPostConfigureParams：' + status);
        },
        onDeviceVersionResponse: (client: BlufiClient, status: number, response: BlufiVersionResponse) => {
          LogUtil.info(TAG, 'onPostConfigureParams：' + status + 'version:' + response.getVersionString());
        },
        onDeviceStatusResponse: (client: BlufiClient, status: number, response: BlufiStatusResponse) => {
          LogUtil.info(TAG, 'onDeviceStatusResponse:' + status + 'info_:' + response.generateValidInfo());
        },
        onDeviceScanResult: (client: BlufiClient, status: number, results: BlufiScanResult[]) => {
          LogUtil.info(TAG, 'onDeviceScanResult:' + status + 'resultlen:' + results.length);
        },
        onPostCustomDataResult: (client: BlufiClient, status: number, data: Uint8Array) => {
          LogUtil.info(TAG, 'onPostCustomDataResult:' + status + 'data:' + data.toLocaleString());
        },
        onReceiveCustomData: (client: BlufiClient, status: number, data: Uint8Array) => {
          LogUtil.info(TAG, 'onReceiveCustomData:' + status + 'data:' + data.toLocaleString());
        }
      }
      client.setGattCallback(gattCk);
      client.setBlufiCallback(blueCk);

      client.setGattWriteTimeout(SET_GATT_WRITE_TIMEOUT);

      client.setPostPackageLengthLimit(SET_POST_PACKAGE_LENGTH_LIMIT);

      client.connect();

      await BlufiUtil.sleep(SLEEP_DURATION);
      client.negotiateSecurity();

      await BlufiUtil.sleep(SLEEP_DURATION);
      client.requestDeviceVersion();

      await BlufiUtil.sleep(SLEEP_DURATION);
      client.requestDeviceStatus();

      await BlufiUtil.sleep(SLEEP_DURATION);
      client.requestDeviceWifiScan();

      await BlufiUtil.sleep(SLEEP_DURATION);
      client.postCustomData(new Uint8Array([1, TWO]));

      await BlufiUtil.sleep(SLEEP_DURATION);
      let params = new BlufiConfigureParams();
      params.setOpMode(BlufiParameter.OP_MODE_STA);
      let ssid: string = 'she saying';
      let ssidByte: Uint8Array = BlufiUtil.stringToUint8Array(ssid);
      let ssidUint8Stry: string = new util.Base64Helper().encodeToStringSync(ssidByte);
      params.setStaSSIDBytes(BlufiUtil.stringToUint8Array(ssidUint8Stry));
      let pwd: string = '1234567890';
      let timestamp: number = new Date().getTime() / ONE_THOUSAND;
      let userid: string = 'ae:49cb1518f2c5692154c251f0deaeac0f';
      let stringP: string = 'v1#' + pwd + '#' + userid + '#' + timestamp.toFixed(0) + '#';
      params.setStaPassword(stringP);
      client.configure(params);

      await BlufiUtil.sleep(SLEEP_DURATION);
      client.requestCloseConnection();

      await BlufiUtil.sleep(SLEEP_DURATION);
      client.close();

    });

  })
}

