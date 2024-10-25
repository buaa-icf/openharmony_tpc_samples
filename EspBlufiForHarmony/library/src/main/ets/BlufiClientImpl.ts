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
import constant from '@ohos.bluetooth.constant';
import { BusinessError, Callback, } from '@kit.BasicServicesKit';
import { buffer, Queue } from '@kit.ArkTS';
import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { BlufiClient } from './BlufiClient';
import { BlufiNotifyData } from './BlufiNotifyData';
import { BlufiConfigureParams } from './params/BlufiConfigureParams';
import { BlufiScanResult } from './response/BlufiScanResult';
import { BlufiStatusResponse } from './response/BlufiStatusResponse';
import { BlufiVersionResponse } from './response/BlufiVersionResponse';
import { BlufiCallback, BlufiGattCallback, BlufiGattStatus, } from './BlufiCallback';
import { BlufiParameter } from './params/BlufiParameter';
import { FrameCtrlData } from './FrameCtrlData';
import { BlufiUtil } from './BlufiUtil';
import { BlufiMD5 } from './security/BlufiMD5';
import { BlufiCRC } from './security/BlufiCRC';
import { BlufiAES } from './security/BlufiAES';
import { BlufiDH } from './security/BlufiDH';
import LogUtil from './Logger';

const TAG: string = 'BlufiClientImpl';

export class BlufiClientImpl {
  private static readonly NEG_SECURITY_SET_TOTAL_LENGTH: number = 0x00;
  private static readonly NEG_SECURITY_SET_ALL_DATA: number = 0x01;
  private static ENABLE_NOTIFICATION_VALUE_STR: string = '0100';
  private static readonly AES_TRANSFORMATION: string = 'AES128|CBC|PKCS5';
  private readonly DEFAULT_PACKAGE_LENGTH: number = 20;
  private readonly PACKAGE_HEADER_LENGTH: number = 4;
  private readonly MIN_PACKAGE_LENGTH: number = 20;
  private readonly TWO: number = 2;
  private readonly THREE: number = 3;
  private readonly SIX: number = 6;
  private readonly EIGHT: number = 8;
  private readonly TEN: number = 10;
  private readonly ELEVEN: number = 11;
  private readonly SIXTEEN: number = 16;
  private readonly ONE_HUNDRED: number = -100;
  private readonly TWO_HUNDRED_FIFTY_SIX: number = 256;
  private mPrintDebug: Boolean = false;
  private mClient: BlufiClient;
  private mDevice: ble.GattClientDevice;
  private mUserGattCallback: BlufiGattCallback;
  private mUserBlufiCallback: BlufiCallback;

  private mWriteChar: ble.BLECharacteristic;
  private mNotifyChar: ble.BLECharacteristic;
  private mWriteTimeout: number = -1;
  private mPackageLengthLimit: number = -1;
  private mBlufiMTU: number = -1;
  private mSendSequence: number = -1;
  private mReadSequence: number = -1;
  private mAck: Queue<number> = new Queue();
  private mNotifyData: BlufiNotifyData;
  private mAESKey: Uint8Array;
  private mEncrypted: boolean = false;
  private mChecksum: boolean = false;
  private mRequireAck: boolean = false;
  private mConnectState: number = 0;
  private mDevicePublicKeyQueue: Queue<bigint> = new Queue();

  constructor(client: BlufiClient, device: ble.GattClientDevice) {
    this.mDevice = device;
    this.mClient = client;
  }

  /**
   * client 连接
   **/
  public connect(): void {
    try {
      this.mDevice.on('BLEConnectionStateChange', (bleConnectionState) => {
        this.mConnectState = bleConnectionState.state;
        let bleConnectionStateInfo: string = '';
        switch (bleConnectionState.state) {
          case 0:
            bleConnectionStateInfo = 'DISCONNECTED';
            break;
          case 1:
            bleConnectionStateInfo = 'CONNECTING';
            break;
          case this.TWO:
            bleConnectionStateInfo = 'STATE_CONNECTED';
            this.getServices();
            break;
          case this.THREE:
            bleConnectionStateInfo = 'STATE_DISCONNECTING';
            break;
          default:
            bleConnectionStateInfo = 'undefined';
            break;
        }
        if (this.mPrintDebug) {
          LogUtil.info(TAG, 'status: ' + bleConnectionStateInfo);
        }

        if (this.mUserGattCallback !== null && this.mUserGattCallback?.onConnectionStateChange) {
          this.mUserGattCallback.onConnectionStateChange(this.mDevice, bleConnectionState.state, bleConnectionState);
        }
      })
      this.mDevice.connect();
    } catch (err) {
      LogUtil.error(TAG, 'errCode:' + err.code);
    }
  }

  /**
   * 关闭Blufi客户端功能，注销client在协议栈的注册
   **/
  public close(): void {
    try {
      if (this.mDevice !== null) {
        this.bLEBLEMtuChangeOff();
        this.bLECharacteristicChangeOff();
        this.mDevice.close();
      }
      this.mNotifyChar = null;
      this.mWriteChar = null;
      if (this.mAck !== null) {
        this.mAck = null;
      }
      this.mClient = null;
      this.mUserBlufiCallback = null;
      this.mUserGattCallback = null;
      this.mDevice = null;
    } catch (err) {
      LogUtil.error(TAG, '#close# errCode:' + err.code);
    }
  }

  /**
   * 设置监听获取版本、秘钥协商、wifi状态、自定义数据等回调方法
   * @param callback
   **/
  public setBlufiCallback(callback: BlufiCallback): void {
    this.mUserBlufiCallback = callback;
  }

  /**
   * 设置Gatt写操作的超时
   * @param timeout
   **/
  public setGattWriteTimeout(timeout: number): void {
    this.mWriteTimeout = timeout;
  }

  /**
   * 设置debug日志开启状态
   * @param enable
   **/
  public printDebugLog(enable: boolean): void {
    this.mPrintDebug = enable;
  }

  /**
   * 设置Gatt监听相关回调方法
   * @param callback
   **/
  public setGattCallback(callback: BlufiGattCallback): void {
    this.mUserGattCallback = callback;
  }

  /**
   * 设置单个传输数据的最大限制长度
   * @param lengthLimit
   **/
  public setPostPackageLengthLimit(lengthLimit: number): void {
    if (lengthLimit <= 0) {
      this.mPackageLengthLimit = -1;
    } else {
      this.mPackageLengthLimit = Math.max(lengthLimit, this.MIN_PACKAGE_LENGTH);
    }
  }

  /**
   * 请求esp32设备版本号
   **/
  public requestDeviceVersion(): void {
    this.__requestDeviceVersion();
  }

  /**
   * 请求esp32设备Wifi连接相关状态
   **/
  public requestDeviceStatus(): void {
    this.__requestDeviceStatus();
  }

  /**
   * 请求esp32密钥协商
   **/
  public negotiateSecurity(): void {
    this.__negotiateSecurity();
  }

  /**
   * 向esp32发送配网相关参数，进行配网
   **/
  public configure(params: BlufiConfigureParams): void {
    this.__configure(params);
  }

  /**
   * 请求esp32设备扫描附近wifi
   **/
  public requestDeviceWifiScan(): void {
    this.__requestDeviceWifiScan();
  }

  /**
   * 向esp32发送自定义数据
   **/
  public postCustomData(data: Uint8Array): void {
    this.__postCustomData(data);
  }

  /**
   * 请求esp32设备断开连接
   **/
  public requestCloseConnection(): void {
    this.__requestCloseConnection();
  }

  /**
   * 读取esp32设备某特征值
   * @param characteristic
   **/
  public readCharacteristicValue(characteristic: ble.BLECharacteristic) {
    try {
      this.mDevice.readCharacteristicValue(characteristic).then(chara => {
        if (this.mUserGattCallback !== null && this.mUserGattCallback.onCharacteristicRead) {
          this.mUserGattCallback.onCharacteristicRead(this.mDevice, chara, BlufiGattStatus.SUCCESS);
        }
      })
    } catch (err) {
      LogUtil.error(TAG, 'errCode:' + (err as BusinessError).code);
      if (this.mUserGattCallback !== null && this.mUserGattCallback.onCharacteristicRead) {
        this.mUserGattCallback.onCharacteristicRead(this.mDevice, characteristic, BlufiGattStatus.FAIL);
      }
    }
  }

  /**
   * 读取esp32设备某特征具体描述值
   * @param descriptor
   **/
  public readDescriptorValue(descriptor: ble.BLEDescriptor) {
    try {
      this.mDevice.readDescriptorValue(descriptor).then((des: ble.BLEDescriptor) => {
        if (this.mUserGattCallback !== null && this.mUserGattCallback.onDescriptorRead) {
          this.mUserGattCallback.onDescriptorRead(this.mDevice, des, BlufiGattStatus.SUCCESS);
        }
      })
    } catch (err) {
      LogUtil.error(TAG, 'errCode:' + (err as BusinessError).code);
      if (this.mUserGattCallback !== null && this.mUserGattCallback.onDescriptorRead) {
        this.mUserGattCallback.onDescriptorRead(this.mDevice, descriptor, BlufiGattStatus.FAIL);
      }
    }
  }

  /**
   * 写入esp32设备某特征具体描述值
   * @param descriptor
   **/
  public writeDescriptorValue(descriptor: ble.BLEDescriptor) {
    try {
      this.mDevice.writeDescriptorValue(descriptor).then(() => {
        if (this.mUserGattCallback !== null && this.mUserGattCallback.onDescriptorRead) {
          this.mUserGattCallback.onDescriptorWrite(this.mDevice, descriptor, BlufiGattStatus.SUCCESS);
        }
      });
    } catch (err) {
      LogUtil.error(TAG, 'writeDescriptorValue-errCode:' + err.code);
      if (this.mUserGattCallback !== null && this.mUserGattCallback.onDescriptorRead) {
        this.mUserGattCallback.onDescriptorWrite(this.mDevice, descriptor, BlufiGattStatus.FAIL);
      }
    }
  }

  private getServices(): Promise<ble.GattService[]> {
    return this.mDevice.getServices().then((result: ble.GattService[]) => {
      if (this.mPrintDebug) {
        LogUtil.info(TAG, 'getServices successfully:' + result);
      }
      if (Array.isArray(result)) {
        let curService: ble.GattService = null;
        curService =
          result.find((service: ble.GattService) => service.serviceUuid.toUpperCase() === BlufiParameter.UUID_SERVICE);
        this.checkCurService(curService, result);

      }
      return result;
    });
  }

  private checkCurService(curService: ble.GattService, result: ble.GattService[]) {
    if (curService) {
      let writeChara: ble.BLECharacteristic;
      let notifyChara: ble.BLECharacteristic;
      if (Array.isArray(curService.characteristics)) {
        curService.characteristics.forEach((bLECharacteristic: ble.BLECharacteristic) => {
          if (bLECharacteristic.characteristicUuid.toUpperCase() === BlufiParameter.UUID_WRITE_CHARACTERISTIC) {
            writeChara = bLECharacteristic;
          }
          if (bLECharacteristic.characteristicUuid.toUpperCase() ===
          BlufiParameter.UUID_NOTIFICATION_CHARACTERISTIC) {

            let descriptors: ble.BLEDescriptor[] = [];
            let arrayBuffer: ArrayBuffer = new ArrayBuffer(this.EIGHT);
            let descV: Uint8Array = new Uint8Array(arrayBuffer);
            descV[0] = this.ELEVEN;
            let ENABLE_NOTIFICATION_VALUE: ArrayBuffer =
              buffer.from(BlufiClientImpl.ENABLE_NOTIFICATION_VALUE_STR, 'utf16le').buffer;

            let descriptor: ble.BLEDescriptor = {
              serviceUuid: bLECharacteristic.serviceUuid,
              characteristicUuid: bLECharacteristic.characteristicUuid,
              descriptorUuid: bLECharacteristic.descriptors[0].descriptorUuid,
              descriptorValue: ENABLE_NOTIFICATION_VALUE
            };
            descriptors[0] = descriptor;
            let characteristic: ble.BLECharacteristic = {
              serviceUuid: bLECharacteristic.serviceUuid,
              characteristicUuid: bLECharacteristic.characteristicUuid,
              characteristicValue: bLECharacteristic.characteristicValue,
              descriptors: []
            };
            this.mDevice.setCharacteristicChangeNotification(characteristic, true).then(res => {
              if (this.mPrintDebug) {
                LogUtil.info(TAG, 'setCharacteristicChangeNotification');
              }

              this.bLECharacteristicChangeOn();
            }).catch(e => {
              if (this.mPrintDebug) {
                LogUtil.error(TAG, 'setCharacteristicChangeNotification-error:' +
                (e as BusinessError).message);
              }
            });

            notifyChara = bLECharacteristic;
          }
        });
      }
      this.mWriteChar = writeChara;
      this.mNotifyChar = notifyChara;

      if (this.mNotifyChar !== null) {
        this.bLEBLEMtuChangeOn();
      }

      if (this.mUserGattCallback !== null && this.mUserGattCallback.onServicesDiscovered) {
        this.mUserGattCallback.onServicesDiscovered(this.mDevice, result);
      }

      if (this.mUserBlufiCallback !== null && this.mUserBlufiCallback.onGattPrepared) {
        this.mUserBlufiCallback.onGattPrepared(this.mClient, this.mDevice, curService, writeChara, notifyChara);
      }

    }
  }

  private bLEBLEMtuChangeOn(callback?: Callback<number>) {
    try {
      this.mDevice.on('BLEMtuChange', (mtu: number) => {
        if (callback !== null) {
          callback(mtu);
        }
        this.mBlufiMTU = mtu - this.PACKAGE_HEADER_LENGTH;
        if (this.mUserGattCallback !== null && this.mUserGattCallback.onMtuChanged) {
          this.mUserGattCallback.onMtuChanged(this.mDevice, mtu, BlufiGattStatus.SUCCESS);
        }
      });
    } catch (err) {
      LogUtil.error(TAG, 'bLEBLEMtuChangeOn:' + err);
      if (this.mUserGattCallback !== null && this.mUserGattCallback.onMtuChanged) {
        this.mUserGattCallback.onMtuChanged(this.mDevice, -1, BlufiGattStatus.FAIL);
      }
    }
  }

  private bLEBLEMtuChangeOff(callback?: Callback<number>) {
    try {
      this.mDevice.off('BLEMtuChange', (mtu: number) => {
        if (callback !== null) {
          callback(mtu);
        }

      });
    } catch (err) {
      LogUtil.error(TAG, 'bLEBLEMtuChangeOff:' + err);
    }
  }

  private bLECharacteristicChangeOn(callback?: Callback<ble.BLECharacteristic>) {
    try {
      this.mDevice.on('BLECharacteristicChange', (characteristicChangeReq: ble.BLECharacteristic) => {

        if (characteristicChangeReq.characteristicUuid === this.mNotifyChar.characteristicUuid &&
          characteristicChangeReq.serviceUuid === this.mNotifyChar.serviceUuid) {
          if (!this.mNotifyData) {
            this.mNotifyData = new BlufiNotifyData();
          }
          let data: ArrayBuffer = characteristicChangeReq.characteristicValue;
          if (this.mPrintDebug) {
            LogUtil.info(TAG, 'Gatt Notification: ' + buffer.from(data).toString());
          }

          // lt 0 is error, eq 0 is complete, gt 0 is continue
          let parse: number = this.parseNotification(new Uint8Array(data), this.mNotifyData);
          if (parse < 0) {
            this.onError(BlufiCallback.CODE_INVALID_NOTIFICATION);
          } else if (parse === 0) {
            this.parseBlufiNotifyData(this.mNotifyData);
            this.mNotifyData = null;
          }
        }
        if (callback !== null) {
          callback(characteristicChangeReq);
        }

        if (this.mUserGattCallback !== null && this.mUserGattCallback.onCharacteristicChanged) {
          this.mUserGattCallback.onCharacteristicChanged(this.mDevice, characteristicChangeReq,
            BlufiGattStatus.SUCCESS);
        }
      });
    } catch (err) {
      LogUtil.error(TAG, 'bLECharacteristicChangeOn:' + err);
    }
  }

  private bLECharacteristicChangeOff(callback?: Callback<ble.BLECharacteristic>) {
    try {
      this.mDevice.off('BLECharacteristicChange', (characteristicChangeReq: ble.BLECharacteristic) => {
        if (callback !== null) {
          callback(characteristicChangeReq);
        }
        if (this.mUserGattCallback !== null && this.mUserGattCallback.onCharacteristicChanged) {
          this.mUserGattCallback.onCharacteristicChanged(this.mDevice, characteristicChangeReq, BlufiGattStatus.OFF);
        }
      });
    } catch (err) {
      LogUtil.error(TAG, 'bLECharacteristicChangeOff:' + err);
    }
  }

  private getTypeValueWithPackageTypeAndSubType(pkgType: number, subType: number): number {
    return (subType << this.TWO) | pkgType;
  }

  private getTypeValueWithValue(typeValue: number): number {
    return typeValue & 0b11;
  }

  private getSubTypeValueWithValue(typeValue: number): number {
    return ((typeValue & 0b11111100) >> this.TWO);
  }

  private generateSendSequence(): number {
    this.mSendSequence += 1;
    return this.mSendSequence % this.TWO_HUNDRED_FIFTY_SIX;
  }

  private generateReadSequence(): number {
    this.mReadSequence += 1;
    return this.mReadSequence % this.TWO_HUNDRED_FIFTY_SIX;
  }

  private generateAESIV(sequence: number): ArrayBuffer {
    let result: ArrayBuffer = new ArrayBuffer(this.SIXTEEN);
    result[0] = sequence;

    return result;
  }

  private isConnected(): boolean {
    return this.mConnectState === constant.ProfileConnectionState.STATE_CONNECTED;
  }

  private gattWrite(data: ArrayBuffer): Promise<boolean> {
    let characteristic: ble.BLECharacteristic = this.mWriteChar;
    if (!this.isConnected() || !characteristic) {
      return new Promise((resolve) => {
        resolve(false);
      });
    }
    if (this.mPrintDebug) {
      LogUtil.info(TAG, 'gattWrite= ' + new Uint8Array(data).toLocaleString());
    }

    let newCharact: ble.BLECharacteristic = {
      serviceUuid: characteristic.serviceUuid,
      characteristicUuid: characteristic.characteristicUuid,
      characteristicValue: data,
      descriptors: [],
    }

    let promiseRaces: Promise<any>[] = [];
    let normalPromise: Promise<Boolean> = new Promise((resolve, reject) => {
      this.mDevice.writeCharacteristicValue(newCharact, ble.GattWriteType.WRITE).then(() => {
        if (this.mUserGattCallback !== null && this.mUserGattCallback.onCharacteristicWrite) {
          this.mUserGattCallback.onCharacteristicWrite(this.mDevice, newCharact, BlufiGattStatus.SUCCESS);
        }
        resolve(true);
      }).catch(err => {
        LogUtil.error(TAG, 'writeCharacteristicValue--error', 'code:' + (err as BusinessError).code);
        if (this.mUserGattCallback !== null && this.mUserGattCallback.onCharacteristicWrite) {
          this.mUserGattCallback.onCharacteristicWrite(this.mDevice, newCharact, BlufiGattStatus.FAIL);
        }
        reject(err);
      });
    });
    promiseRaces.push(normalPromise);

    if (this.mWriteTimeout > 0) {
      let timeoutPromise: Promise<any> = new Promise((reject) => {
        setTimeout(() => {
          this.onError(BlufiCallback.CODE_GATT_WRITE_TIMEOUT);
          let error: BusinessError = {
            code: BlufiCallback.CODE_GATT_WRITE_TIMEOUT,
            name: 'CODE_GATT_WRITE_TIMEOUT',
            message: 'CODE_GATT_WRITE_TIMEOUT'
          };
          reject(error);
        }, this.mWriteTimeout);
      })
      promiseRaces.push(timeoutPromise);
    }
    return Promise.race(promiseRaces);
  }

  private receiveAck(expectAck: number): boolean {
    let ack: number = this.mAck.pop();
    return true;
  }

  private post(encrypt: boolean, checksum: boolean, requireAck: boolean, type: number,
    data: Uint8Array): Promise<boolean> {
    if (!data) {
      return this.postNonData(encrypt, checksum, requireAck, type);
    } else {
      return this.postContainData(encrypt, checksum, requireAck, type, data);
    }
  }

  private async postNonData(encrypt: boolean, checksum: boolean, requireAck: boolean, type: number): Promise<boolean> {

    let sequence: number = this.generateSendSequence();
    let postBytes: ArrayBuffer = this.getPostBytes(type, encrypt, checksum, requireAck, false, sequence, null);
    return this.gattWrite(postBytes).then(posted => {
      let status: boolean = posted && (!requireAck || this.receiveAck(sequence));
      return status;
    });
  }

  private async postContainData(encrypt: boolean, checksum: boolean, requireAck: boolean, type: number,
    data: Uint8Array): Promise<boolean> {

    try {
      let dataIS: Uint8Array = data;
      let dataContent: Uint8Array = new Uint8Array();
      let total: number = dataIS.length;

      let pkgLengthLimit: number = this.mPackageLengthLimit > 0 ? this.mPackageLengthLimit :
        (this.mBlufiMTU > 0 ? this.mBlufiMTU : this.DEFAULT_PACKAGE_LENGTH);
      let postDataLengthLimit: number = pkgLengthLimit - this.PACKAGE_HEADER_LENGTH;
      postDataLengthLimit -= this.TWO;
      if (checksum) {
        postDataLengthLimit -= this.TWO;
      }

      while (dataIS !== null && dataIS.length > 0) {
        if (!dataIS) {
          break;
        }
        let frag: boolean = dataIS.length > postDataLengthLimit;
        dataContent = dataIS.slice(0, postDataLengthLimit);
        dataIS = dataIS.slice(postDataLengthLimit);

        if (frag) {
          let tempData: Uint8Array = new Uint8Array(dataContent);
          dataContent = new Uint8Array(new ArrayBuffer(this.TWO + tempData.length));
          let len1: number = (total >> this.EIGHT) & 0xff;
          let len2: number = total & 0xff;
          let mlen: number = -1;
          mlen = mlen + 1;
          dataContent[0] = len2;
          mlen = mlen + 1;
          dataContent[1] = len1;
          mlen = mlen + 1;
          dataContent.set(tempData, mlen);
        }
        let sequence: number = this.generateSendSequence();

        let postBytes: ArrayBuffer =
          this.getPostBytes(type, encrypt, checksum, requireAck, frag, sequence, dataContent);
        let posted: boolean = await this.gattWrite(postBytes);
        if (!posted) {
          return false;
        }
        if (frag) {
          if (requireAck && !this.receiveAck(sequence)) {
            return false;
          }

          // 阻塞10us
          await BlufiUtil.sleep(this.TEN);
        } else {
          return !requireAck || this.receiveAck(sequence);
        }
      }
    } catch (e) {
      return false;
    }

  }

  private getPostBytes(type: number, encrypt: boolean, checksum: boolean, requireAck: boolean, hasFrag: boolean,
    sequence: number, data: Uint8Array): ArrayBuffer {
    let byteOS: number[] = [];
    let dataLength: number = data === null ? 0 : data.length;
    let frameCtrl: number =
      FrameCtrlData.getFrameCTRLValue(encrypt, checksum, BlufiParameter.DIRECTION_OUTPUT, requireAck, hasFrag);

    byteOS.push(type);
    byteOS.push(frameCtrl);
    byteOS.push(sequence);
    byteOS.push(dataLength);

    let checksumBytes: number[] = null;
    if (checksum) {
      let willCheckBytes: Uint8Array = new Uint8Array(new ArrayBuffer(this.EIGHT));
      willCheckBytes[0] = (sequence);
      willCheckBytes[1] = (dataLength);
      let crc: number = BlufiCRC.calculateCRC(0, willCheckBytes);
      if (dataLength > 0) {
        crc = BlufiCRC.calculateCRC(crc, new Uint8Array(data));
      }
      let checksumByte1: number = crc & 0xff;
      let checksumByte2: number = (crc >> this.EIGHT) & 0xff;
      checksumBytes = [checksumByte1, checksumByte2];
    }

    if (encrypt && data !== null && data.length > 0) {
      let sequenceU8Arr: Uint8Array = new Uint8Array(this.generateAESIV(sequence));
      let sequenceDataBlob: cryptoFramework.DataBlob = { data: sequenceU8Arr };
      let aesTool: BlufiAES =
        new BlufiAES(this.mAESKey, BlufiClientImpl.AES_TRANSFORMATION,
          { iv: sequenceDataBlob, algName: 'IvParamsSpec' });
      let encodeData: cryptoFramework.DataBlob = aesTool.encryptSync({ data: new Uint8Array(data) });
      if (encodeData?.data) {
        data = encodeData?.data;
      }
    }
    if (data !== null) {
      data.forEach((value) => {
        byteOS.push(value)
      })
    }

    if (checksumBytes !== null) {
      byteOS.push(checksumBytes[0]);
      byteOS.push(checksumBytes[1]);
    }
    let byteOSBuffer = new Uint8Array(byteOS);
    return byteOSBuffer.buffer;
  }


  private parseNotification(response: Uint8Array, notification: BlufiNotifyData): number {
    if (!response) {
      LogUtil.error(TAG, 'parseNotification null data');
      return -1;
    }
    if (this.mPrintDebug) {
      LogUtil.info(TAG, 'parseNotification Notification= ', response.toString());
    }

    if (response.length < this.PACKAGE_HEADER_LENGTH) {
      LogUtil.error(TAG, 'parseNotification data length less than 4');
      return -this.TWO;
    }

    let sequence: number = BlufiUtil.toInt(response[this.TWO]);
    if (sequence !== (this.generateReadSequence())) {
      LogUtil.error(TAG, 'parseNotification read sequence wrong');
      return -this.THREE;
    }

    let type: number = BlufiUtil.toInt(response[0]);
    let pkgType: number = this.getTypeValueWithValue(type);
    let subType: number = this.getSubTypeValueWithValue(type);
    notification.setType(type);
    notification.setPkgType(pkgType);
    notification.setSubType(subType);

    let frameCtrl: number = BlufiUtil.toInt(response[1]);
    notification.setFrameCtrl(frameCtrl);
    let frameCtrlData: FrameCtrlData = new FrameCtrlData(frameCtrl);

    let dataLen: number = BlufiUtil.toInt(response[3]);
    let dataBytes: ArrayBuffer = new ArrayBuffer(dataLen);
    let dataBytesFromUnit8Array: Uint8Array;
    let dataOffset: number = 4;
    try {
      let data = response.slice(dataOffset, dataLen + dataOffset);
      dataBytesFromUnit8Array = data;
    } catch (e) {
      LogUtil.error(TAG, e);
      return this.ONE_HUNDRED;
    }

    if (frameCtrlData.isEncrypted()) {
      let sequenceU8Arr: Uint8Array = new Uint8Array(this.generateAESIV(sequence));
      let sequenceDataBlob: cryptoFramework.DataBlob = { data: sequenceU8Arr };
      let aesTool: BlufiAES =
        new BlufiAES(this.mAESKey, BlufiClientImpl.AES_TRANSFORMATION,
          { iv: sequenceDataBlob, algName: 'IvParamsSpec' });
      let decryptdata: cryptoFramework.DataBlob = aesTool.decryptSync({ data: dataBytesFromUnit8Array });
      dataBytes = decryptdata?.data.buffer;
      dataBytesFromUnit8Array = new Uint8Array(dataBytes);
    }

    if (frameCtrlData.isChecksum()) {
      let respChecksum1: number = BlufiUtil.toInt(response[response.length - 1]);
      let respChecksum2: number = BlufiUtil.toInt(response[response.length - this.TWO]);
      let byteSq: Uint8Array = new Uint8Array(new ArrayBuffer(this.TWO));
      byteSq[0] = sequence;
      byteSq[1] = dataLen;
      let crc: number = BlufiCRC.calculateCRC(0, byteSq);
      crc = BlufiCRC.calculateCRC(crc, dataBytesFromUnit8Array);
      let calcChecksum1: number = crc >> this.EIGHT & 0xff;
      let calcChecksum2: number = crc & 0xff;

      if (respChecksum1 !== calcChecksum1 || respChecksum2 !== calcChecksum2) {
        if (this.mPrintDebug) {
          LogUtil.debug(TAG, 'expect checksum: ' + respChecksum1 + ', ' + respChecksum2);
          LogUtil.debug(TAG, 'expect checksum: ' + calcChecksum1 + ', ' + calcChecksum2);
        }
        return -this.PACKAGE_HEADER_LENGTH;
      }
    }

    if (frameCtrlData.hasFrag()) {
      dataOffset = this.TWO;
    } else {
      dataOffset = 0;
    }
    notification.addData(dataBytesFromUnit8Array, dataOffset);
    return frameCtrlData.hasFrag() ? 1 : 0;
  }

  private parseBlufiNotifyData(data: BlufiNotifyData) {
    let pkgType: number = data.getPkgType();
    let subType: number = data.getSubType();
    let dataBytes: Uint8Array = data.getDataArray();

    if (this.mUserBlufiCallback !== null && this.mUserBlufiCallback.onGattNotification) {
      let complete: boolean = this.mUserBlufiCallback.onGattNotification(this.mClient, pkgType, subType, dataBytes);
      if (complete) {
        return;
      }
    }
    switch (pkgType) {
      case BlufiParameter.Type.Ctrl.PACKAGE_VALUE:
        this.parseCtrlData(subType, dataBytes);
        break;
      case BlufiParameter.Type.Data.PACKAGE_VALUE:
        this.parseDataData(subType, dataBytes);
        break;
    }
  }

  private parseCtrlData(subType: number, data: Uint8Array) {
    if (subType === BlufiParameter.Type.Ctrl.SUBTYPE_ACK) {
      this.parseAck(data);
    }
  }

  private parseDataData(subType: number, data: Uint8Array) {

    switch (subType) {
      case BlufiParameter.Type.Data.SUBTYPE_NEG:
        this.onReceiveDevicePublicKey(data);
        if (this.mPrintDebug) {
          LogUtil.info(TAG, 'SUBTYPE_NEG--onReceiveDevicePublicKey--' + data.toLocaleString());
        }
        break;
      case BlufiParameter.Type.Data.SUBTYPE_VERSION:
        this.parseVersion(data);
        break;
      case BlufiParameter.Type.Data.SUBTYPE_WIFI_CONNECTION_STATE:
        this.parseWifiState(data);
        break;
      case BlufiParameter.Type.Data.SUBTYPE_WIFI_LIST:
        this.parseWifiScanList(data);
        break;
      case BlufiParameter.Type.Data.SUBTYPE_CUSTOM_DATA:
        this.onReceiveCustomData(data);
        break;
      case BlufiParameter.Type.Data.SUBTYPE_ERROR:
        let errCode = data.length > 0 ? (data[0] & 0xff) : 0xff;
        this.onError(errCode);
        break;
    }
  }

  private onReceiveDevicePublicKey(data: Uint8Array) {
    let keyStr: string = BlufiUtil.uint8ArrayToHex(data);
    try {
      keyStr = '0x' + keyStr;
      let devicePublicValue: bigint = BigInt(keyStr);
      this.mDevicePublicKeyQueue.add(devicePublicValue);
    } catch (e) {
      LogUtil.error(TAG, 'onReceiveDevicePublicKey: NumberFormatException -> ' + keyStr);
      this.mDevicePublicKeyQueue.add(BigInt('0'));
    }
  }

  private parseAck(data: Uint8Array) {
    let ack: number = 0x100;
    if (data.length > 0) {
      ack = data[0] & 0xff;
    }
    this.mAck.add(ack);
  }

  private parseVersion(data: Uint8Array) {
    if (data.length !== this.TWO) {
      this.onVersionResponse(BlufiCallback.CODE_INVALID_DATA, null);
    }

    let response: BlufiVersionResponse = new BlufiVersionResponse();
    response.setVersionValues(BlufiUtil.toInt(data[0]), BlufiUtil.toInt(data[1]));
    this.onVersionResponse(BlufiCallback.STATUS_SUCCESS, response);
  }

  private parseWifiState(data: Uint8Array) {
    if (data.length < this.THREE) {
      this.onStatusResponse(BlufiCallback.CODE_INVALID_DATA, null);
      return;
    }

    let response: BlufiStatusResponse = new BlufiStatusResponse();

    let dataIS: Uint8Array = (data);

    let dIx: number = -1;

    let opMode: number = dataIS[++dIx] & 0xff;
    response.setOpMode(opMode);

    let staConn: number = dataIS[++dIx] & 0xff;
    response.setStaConnectionStatus(staConn);

    let softAPConn: number = dataIS[++dIx] & 0xff;
    response.setSoftAPConnectionCount(softAPConn);

    dataIS = dataIS.slice(dIx + 1);
    dIx = -1;
    let callbackStatus: number = BlufiCallback.STATUS_SUCCESS;
    while (dataIS.length > 0) {
      let infoType: number = dataIS[++dIx] & 0xff;
      let len: number = dataIS[++dIx] & 0xff;
      let stateBytesBuffer: ArrayBuffer = new ArrayBuffer(len);
      let stateBytes: Uint8Array = new Uint8Array(stateBytesBuffer);

      let inVal: number = dataIS.length - (++dIx) - len;

      dataIS.forEach((value, index) => {
        if (index >= dIx) {
          stateBytes[index - dIx] = value;
        }
      });

      if (inVal < 0) {
        callbackStatus = BlufiCallback.CODE_INVALID_DATA;
        break;
      }
      this.parseWifiStateData(response, infoType, stateBytes);
      dataIS = dataIS.slice(dIx + len);
      dIx = -1;
    }

    this.onStatusResponse(callbackStatus, response);
  }

  private parseWifiStateData(response: BlufiStatusResponse, infoType: number, data: Uint8Array) {
    switch (infoType) {
      case BlufiParameter.Type.Data.SUBTYPE_STA_WIFI_BSSID:
        let staBssid: string = BlufiUtil.uint8ArrayToHex(data);
        response.setStaBSSID(staBssid);
        break;
      case BlufiParameter.Type.Data.SUBTYPE_STA_WIFI_SSID:
        let staSsid: string = BlufiUtil.uint8ArrayToString(data);
        response.setStaSSID(staSsid);
        break;
      case BlufiParameter.Type.Data.SUBTYPE_STA_WIFI_PASSWORD:
        let staPassword: string = BlufiUtil.uint8ArrayToString(data);
        response.setStaPassword(staPassword);
        break;
      case BlufiParameter.Type.Data.SUBTYPE_SOFTAP_AUTH_MODE:
        let authMode: number = BlufiUtil.toInt(data[0]);
        response.setSoftAPSecurity(authMode);
        break;
      case BlufiParameter.Type.Data.SUBTYPE_SOFTAP_CHANNEL:
        let softAPChannel: number = BlufiUtil.toInt(data[0]);
        response.setSoftAPChannel(softAPChannel);
        break;
      case BlufiParameter.Type.Data.SUBTYPE_SOFTAP_MAX_CONNECTION_COUNT:
        let softAPMaxConnCount: number = BlufiUtil.toInt(data[0]);
        response.setSoftAPMaxConnectionCount(softAPMaxConnCount);
        break;
      case BlufiParameter.Type.Data.SUBTYPE_SOFTAP_WIFI_PASSWORD:
        let softapPassword: string = BlufiUtil.uint8ArrayToString(data);
        response.setSoftAPPassword(softapPassword);
        break;
      case BlufiParameter.Type.Data.SUBTYPE_SOFTAP_WIFI_SSID:
        let softapSSID: string = BlufiUtil.uint8ArrayToString(data);
        response.setSoftAPSSID(softapSSID);
        break;
      case BlufiParameter.Type.Data.SUBTYPE_WIFI_STA_MAX_CONN_RETRY:
        let maxRetry: number = BlufiUtil.toInt(data[0]);
        response.setMaxRetry(maxRetry);
        break;
      case BlufiParameter.Type.Data.SUBTYPE_WIFI_STA_CONN_END_REASON:
        let endReason: number = BlufiUtil.toInt(data[0]);
        response.setEndReason(endReason);
        break;
      case BlufiParameter.Type.Data.SUBTYPE_WIFI_STA_CONN_RSSI:
        let rssi: number = data[0];
        response.setRssi(rssi);
        break;

    }
  }

  private parseWifiScanList(data: Uint8Array) {
    let resultList: BlufiScanResult[] = [];
    let leafData: Uint8Array = data;

    while (leafData.byteLength > 0) {
      let index: number = -1;
      let length: number = leafData[index++] & 0xff;
      if (length < 1) {
        LogUtil.error(TAG, 'Parse WifiScan invalid length');
        break;
      }
      let rssi: number = leafData[index++];
      let ssidArrBuff: ArrayBuffer = new ArrayBuffer(length - 1);
      let ssidBytes: Uint8Array = new Uint8Array(ssidArrBuff);
      let datalen: number = index + length - 1;
      let ssidRead: Uint8Array = leafData.slice(index, datalen);
      if (ssidRead.length !== (length - 1)) {
        LogUtil.error(TAG, 'Parse WifiScan parse ssid failed');
        break;
      }

      let sr: BlufiScanResult = new BlufiScanResult();
      sr.setType(BlufiScanResult.TYPE_WIFI);
      sr.setRssi(rssi);
      let ssid = BlufiUtil.uint8ArrayToString(ssidRead);
      sr.setSsid(ssid);
      resultList.push(sr);
      leafData = leafData.slice(datalen);
    }
    this.onDeviceScanResult(BlufiCallback.STATUS_SUCCESS, resultList);
  }


  private onError(errCode: number): void {
    if (this.mUserBlufiCallback !== null && this.mUserBlufiCallback.onError) {
      this.mUserBlufiCallback?.onError(this.mClient, errCode);
    }
  }

  private async __negotiateSecurity(): Promise<void> {
    let espDH: BlufiDH = await this.postNegotiateSecurity();
    if (!espDH) {
      if (this.mPrintDebug) {
        LogUtil.debug(TAG, 'negotiateSecurity postNegotiateSecurity failed');
      }
      this.onNegotiateSecurityResult(BlufiCallback.CODE_NEG_POST_FAILED);
      return;
    }

    let devicePublicKey: bigint;
    try {
      devicePublicKey = this.mDevicePublicKeyQueue.pop();
      if (devicePublicKey.toString().length === 0) {
        this.onNegotiateSecurityResult(BlufiCallback.CODE_NEG_ERR_DEV_KEY);
        return;
      }
    } catch (e) {
      LogUtil.error(TAG, 'Take device public key interrupted');
      return;
    }

    try {
      let devicePubU8: Uint8Array = BlufiUtil.stringToUint8Array(devicePublicKey.toString(this.SIXTEEN));
      espDH.generateSecretKey({ data: devicePubU8 });
      if (!espDH.getSecretKey()) {
        this.onNegotiateSecurityResult(BlufiCallback.CODE_NEG_ERR_SECURITY);
        return;
      }
      this.mAESKey = await BlufiMD5.getMD5Bytes(espDH.getSecretKey());
    } catch (e) {
      LogUtil.error(TAG, 'Take device public key getMD5Bytes interrupted', e);
      this.onNegotiateSecurityResult(BlufiCallback.CODE_NEG_ERR_SECURITY);
      return;
    }

    let setSecurity: boolean = false;
    try {
      setSecurity = await this.postSetSecurity(false, false, true, true);
    } catch (e) {
      LogUtil.error(TAG, 'postSetSecurity interrupted', e);
    }

    if (setSecurity) {
      this.mEncrypted = true;
      this.mChecksum = true;
      this.onNegotiateSecurityResult(BlufiCallback.STATUS_SUCCESS);
    } else {
      this.mEncrypted = false;
      this.mChecksum = false;
      this.onNegotiateSecurityResult(BlufiCallback.CODE_NEG_ERR_SET_SECURITY);
    }
  }

  private onNegotiateSecurityResult(status: number): void {
    if (this.mUserBlufiCallback !== null && this.mUserBlufiCallback.onNegotiateSecurityResult) {
      this.mUserBlufiCallback.onNegotiateSecurityResult(this.mClient, status);
    }
  }

  private async postNegotiateSecurity(): Promise<BlufiDH> {
    let type: number = this.getTypeValueWithPackageTypeAndSubType(BlufiParameter.Type.Data.PACKAGE_VALUE,
      BlufiParameter.Type.Data.SUBTYPE_NEG);

    let radix: number = 16;
    let blufiDH: BlufiDH;
    let p: string;
    let g: string;
    let k: string;
    do {
      blufiDH = new BlufiDH();
      p = blufiDH.getP().toString(radix);
      g = blufiDH.getG().toString(radix);
      k = this.getPublicValue(blufiDH);
    } while (k.length === 0);

    let pBytes: number[] = BlufiUtil.hexToIntArray(p);
    let gBytes: number[] = BlufiUtil.hexToIntArray(g);
    let kBytes: number[] = BlufiUtil.hexToIntArray(k);
    let dataOS: number[] = [];
    let pgkLength: number = pBytes.length + gBytes.length + kBytes.length + this.SIX;
    let pgkLen1: number = (pgkLength >> this.EIGHT) & 0xff;
    let pgkLen2: number = pgkLength & 0xff;
    dataOS.push(BlufiClientImpl.NEG_SECURITY_SET_TOTAL_LENGTH);
    dataOS.push(pgkLen1);
    dataOS.push(pgkLen2);
    try {
      let data: Uint8Array = new Uint8Array(dataOS);
      let postLength: boolean = await this.post(false, false, this.mRequireAck, type, data);
      if (!postLength) {
        return null;
      }
    } catch (e) {
      LogUtil.error(TAG, 'postNegotiateSecurity: pgk length interrupted');
      return null;
    }

    await BlufiUtil.sleep(this.TEN);

    dataOS = [];
    dataOS.push(BlufiClientImpl.NEG_SECURITY_SET_ALL_DATA);

    let pLength: number = pBytes.length;
    let pLen1: number = (pLength >> this.EIGHT) & 0xff;
    let pLen2: number = pLength & 0xff;
    dataOS.push(pLen1);
    dataOS.push(pLen2);

    if (pBytes.length > 0) {
      pBytes.forEach((val: number) => {
        dataOS.push(val);
      });
    }

    let gLength: number = gBytes.length;
    let gLen1: number = (gLength >> this.EIGHT) & 0xff;
    let gLen2: number = gLength & 0xff;
    dataOS.push(gLen1);
    dataOS.push(gLen2);
    if (gBytes.length > 0) {
      gBytes.forEach((val: number) => {
        dataOS.push(val);
      });
    }

    let kLength: number = kBytes.length;
    let kLen1: number = (kLength >> this.EIGHT) & 0xff;
    let kLen2: number = kLength & 0xff;
    dataOS.push(kLen1);
    dataOS.push(kLen2);
    if (kBytes.length > 0) {
      kBytes.forEach((val: number) => {
        dataOS.push(val);
      });
    }
    try {
      let data: Uint8Array = new Uint8Array(dataOS);
      let postPGK: boolean = await this.post(false, false, this.mRequireAck, type, data);
      if (!postPGK) {
        return null;
      }
    } catch (e) {
      LogUtil.error(TAG, 'postNegotiateSecurity: PGK interrupted');
      return null;
    }
    dataOS = [];
    return blufiDH;
  }

  private getPublicValue(espDH: BlufiDH): string {
    let publicKey: Uint8Array = espDH.getPublicKey();
    if (publicKey !== null) {
      let keyStr: string = BlufiUtil.uint8ArrayToHex(publicKey);
      while (keyStr.length < this.TWO_HUNDRED_FIFTY_SIX) {
        keyStr = '0' + keyStr;
      }
      return keyStr;
    }
    return null;
  }

  private postSetSecurity(ctrlEncrypted: boolean, ctrlChecksum: boolean, dataEncrypted: boolean,
    dataChecksum: boolean): Promise<boolean> {
    let type: number = this.getTypeValueWithPackageTypeAndSubType(BlufiParameter.Type.Ctrl.PACKAGE_VALUE,
      BlufiParameter.Type.Ctrl.SUBTYPE_SET_SEC_MODE);
    let data: number = 0;
    if (dataChecksum) {
      data = data | 1;
    }
    if (dataEncrypted) {
      data = data | 0b10;
    }
    if (ctrlChecksum) {
      data = data | 0b10000;
    }
    if (ctrlEncrypted) {
      data = data | 0b100000;
    }

    let postData: Uint8Array = new Uint8Array(new ArrayBuffer(1));
    postData[0] = data;

    try {
      return this.post(false, true, this.mRequireAck, type, postData);
    } catch (e) {
      LogUtil.error(TAG, 'postSetSecurity interrupted');
      return Promise.resolve(false);
    }
  }

  private async __configure(params: BlufiConfigureParams): Promise<void> {
    let opMode: number = params.getOpMode();
    switch (opMode) {
      case BlufiParameter.OP_MODE_NULL: {
        this.postDeviceMode(opMode).then(status => {
          let statusCode: number = status ? BlufiCallback.STATUS_SUCCESS : BlufiCallback.CODE_CONF_ERR_SET_OPMODE;
          this.onPostConfigureParams(statusCode);
        })
        return;
      }
      case BlufiParameter.OP_MODE_STA: {
        this.postDeviceMode(opMode).then(status => {
          if (!status) {
            this.onPostConfigureParams(BlufiCallback.CODE_CONF_ERR_SET_OPMODE);
          } else {
            this.postStaWifiInfo(params).then(wifiInfoStatus => {
              let statusCode: number =
                wifiInfoStatus ? BlufiCallback.STATUS_SUCCESS : BlufiCallback.CODE_CONF_ERR_POST_STA;
              this.onPostConfigureParams(statusCode);
            })
          }
        });
        return;
      }
      case BlufiParameter.OP_MODE_SOFTAP: {
        this.postDeviceMode(opMode).then(status => {
          if (!status) {
            this.onPostConfigureParams(BlufiCallback.CODE_CONF_ERR_SET_OPMODE);
          } else {
            this.postSoftAPInfo(params).then(wifiInfoStatus => {
              let statusCode: number =
                wifiInfoStatus ? BlufiCallback.STATUS_SUCCESS : BlufiCallback.CODE_CONF_ERR_POST_SOFTAP;
              this.onPostConfigureParams(statusCode);
            })
          }
        });
        return;
      }
      case BlufiParameter.OP_MODE_STASOFTAP: {
        let opPostStatus: boolean = await this.postDeviceMode(opMode);
        if (!opPostStatus) {
          this.onPostConfigureParams(BlufiCallback.CODE_CONF_ERR_SET_OPMODE);
          return;
        }
        let staWifiInoPostStatus: boolean = await this.postStaWifiInfo(params);
        if (!staWifiInoPostStatus) {
          this.onPostConfigureParams(BlufiCallback.CODE_CONF_ERR_POST_STA);
          return;
        }
        let softApPostStatus: boolean = await this.postSoftAPInfo(params);
        if (!softApPostStatus) {
          this.onPostConfigureParams(BlufiCallback.CODE_CONF_ERR_POST_SOFTAP);
          return;
        }
        this.onPostConfigureParams(BlufiCallback.STATUS_SUCCESS);
        break;
      }
      default: {
        this.onPostConfigureParams(BlufiCallback.CODE_CONF_INVALID_OPMODE);
        break;
      }
    }
  }


  private async postDeviceMode(deviceMode: number): Promise<boolean> {
    let type: number = this.getTypeValueWithPackageTypeAndSubType(BlufiParameter.Type.Ctrl.PACKAGE_VALUE,
      BlufiParameter.Type.Ctrl.SUBTYPE_SET_OP_MODE);
    let data: Uint8Array = new Uint8Array(new ArrayBuffer(1));
    data[0] = deviceMode & 0xff;
    return this.post(this.mEncrypted, this.mChecksum, true, type, data).then(status => {
      return status;
    }).catch(e => {
      LogUtil.error(TAG, 'postDeviceMode interrupted', e);
      return false;
    })
  }

  private onPostConfigureParams(status: number) {
    if (this.mUserBlufiCallback !== null && this.mUserBlufiCallback.onPostConfigureParams) {
      this.mUserBlufiCallback.onPostConfigureParams(this.mClient, status);
    }
  }

  private async postStaWifiInfo(params: BlufiConfigureParams): Promise<boolean> {
    try {
      let ssidType: number = this.getTypeValueWithPackageTypeAndSubType(BlufiParameter.Type.Data.PACKAGE_VALUE,
        BlufiParameter.Type.Data.SUBTYPE_STA_WIFI_SSID);
      let ssidBytes: Uint8Array = params.getStaSSIDBytes();
      let ssidStatus: boolean = await this.post(this.mEncrypted, this.mChecksum, this.mRequireAck, ssidType, ssidBytes);
      if (!ssidStatus) {
        return false;
      }
      await BlufiUtil.sleep(this.TEN);

      let pwdType: number = this.getTypeValueWithPackageTypeAndSubType(BlufiParameter.Type.Data.PACKAGE_VALUE,
        BlufiParameter.Type.Data.SUBTYPE_STA_WIFI_PASSWORD);
      let pwdStr: string = params.getStaPassword();
      let pwdU8: Uint8Array = BlufiUtil.stringToUint8Array(pwdStr);
      let pwdStatus: boolean = await this.post(this.mEncrypted, this.mChecksum, this.mRequireAck, pwdType, pwdU8);
      if (!pwdStatus) {
        return false;
      }
      await BlufiUtil.sleep(this.TEN);

      let comfirmType: number = this.getTypeValueWithPackageTypeAndSubType(BlufiParameter.Type.Ctrl.PACKAGE_VALUE,
        BlufiParameter.Type.Ctrl.SUBTYPE_CONNECT_WIFI);
      let status: boolean = await this.post(false, false, this.mRequireAck, comfirmType, null);

      return status;

    } catch (e) {
      LogUtil.error(TAG, 'postStaWifiInfo: interrupted');
      return false;
    }
  }

  private async postSoftAPInfo(params: BlufiConfigureParams): Promise<boolean> {
    try {
      let ssidType: number = this.getTypeValueWithPackageTypeAndSubType(BlufiParameter.Type.Data.PACKAGE_VALUE,
        BlufiParameter.Type.Data.SUBTYPE_SOFTAP_WIFI_SSID);
      let ssidBytes: string = params.getSoftAPSSID();
      if (!BlufiUtil.isEmpty(ssidBytes)) {
        let ssidBuff: Uint8Array = BlufiUtil.stringToUint8Array(params.getSoftAPSSID());
        if (await!this.post(this.mEncrypted, this.mChecksum, this.mRequireAck, ssidType, ssidBuff)) {
          return false;
        }
        BlufiUtil.sleep(this.TEN);
      }

      let pwdStr: string = params.getSoftAPPassword();
      if (!BlufiUtil.isEmpty(pwdStr)) {
        let pwdBuff: Uint8Array = BlufiUtil.stringToUint8Array(params.getSoftAPPassword());
        let pwdType: number = this.getTypeValueWithPackageTypeAndSubType(BlufiParameter.Type.Data.PACKAGE_VALUE,
          BlufiParameter.Type.Data.SUBTYPE_SOFTAP_WIFI_PASSWORD);
        if (await!this.post(this.mEncrypted, this.mChecksum, this.mRequireAck, pwdType, pwdBuff)) {
          return false;
        }
        BlufiUtil.sleep(this.TEN);
      }

      let channel: number = params.getSoftAPChannel();
      if (channel > 0) {
        let channelBuff: Uint8Array = BlufiUtil.stringToUint8Array(channel.toString());
        let channelType: number = this.getTypeValueWithPackageTypeAndSubType(BlufiParameter.Type.Data.PACKAGE_VALUE,
          BlufiParameter.Type.Data.SUBTYPE_SOFTAP_CHANNEL);
        if (await!this.post(this.mEncrypted, this.mChecksum, this.mRequireAck, channelType, channelBuff)) {
          return false;
        }
        BlufiUtil.sleep(this.TEN);
      }

      let maxConn: number = params.getSoftAPMaxConnection();
      if (maxConn > 0) {
        let maxConnBuff: Uint8Array = BlufiUtil.stringToUint8Array(maxConn.toString());
        let maxConnType: number = this.getTypeValueWithPackageTypeAndSubType(BlufiParameter.Type.Data.PACKAGE_VALUE,
          BlufiParameter.Type.Data.SUBTYPE_SOFTAP_MAX_CONNECTION_COUNT);
        if (await!this.post(this.mEncrypted, this.mChecksum, this.mRequireAck, maxConnType, maxConnBuff)) {
          return false;
        }
        BlufiUtil.sleep(this.TEN);
      }

      let securityType: number = this.getTypeValueWithPackageTypeAndSubType(BlufiParameter.Type.Data.PACKAGE_VALUE,
        BlufiParameter.Type.Data.SUBTYPE_SOFTAP_AUTH_MODE);
      let status: boolean = await this.post(this.mEncrypted, this.mChecksum, this.mRequireAck, securityType, null);
      return status;
    } catch (e) {
      LogUtil.error(TAG, 'postSoftAPInfo: interrupted');
      return false;
    }
  }

  private async __requestDeviceVersion() {
    let type: number = this.getTypeValueWithPackageTypeAndSubType(BlufiParameter.Type.Ctrl.PACKAGE_VALUE,
      BlufiParameter.Type.Ctrl.SUBTYPE_GET_VERSION);
    this.post(this.mEncrypted, this.mChecksum, false, type, null).then((request: boolean) => {
      if (!request) {
        this.onVersionResponse(BlufiCallback.CODE_WRITE_DATA_FAILED, null);
      }
    }).catch(e => {
      LogUtil.error(TAG, 'post requestDeviceVersion interrupted:' + e);
      this.onVersionResponse(BlufiCallback.CODE_WRITE_DATA_FAILED, null);
    })
  }

  private onVersionResponse(status: number, response: BlufiVersionResponse) {
    if (this.mUserBlufiCallback !== null && this.mUserBlufiCallback.onDeviceVersionResponse) {
      this.mUserBlufiCallback.onDeviceVersionResponse(this.mClient, status, response);
    }
  }

  private async __requestDeviceStatus() {
    let type: number = this.getTypeValueWithPackageTypeAndSubType(BlufiParameter.Type.Ctrl.PACKAGE_VALUE,
      BlufiParameter.Type.Ctrl.SUBTYPE_GET_WIFI_STATUS);

    this.post(this.mEncrypted, this.mChecksum, false, type, null).then((request: boolean) => {
      if (!request) {
        this.onStatusResponse(BlufiCallback.CODE_WRITE_DATA_FAILED, null);
      }
    }).catch((e: Error) => {
      LogUtil.error(TAG, 'post requestDeviceStatus interrupted:' + e);
      this.onStatusResponse(BlufiCallback.CODE_WRITE_DATA_FAILED, null);
    })

  }


  private onStatusResponse(status: number, response: BlufiStatusResponse) {
    if (this.mUserBlufiCallback !== null && this.mUserBlufiCallback.onDeviceStatusResponse) {
      this.mUserBlufiCallback.onDeviceStatusResponse(this.mClient, status, response);
    }
  }

  private async __requestDeviceWifiScan() {
    let type: number = this.getTypeValueWithPackageTypeAndSubType(BlufiParameter.Type.Ctrl.PACKAGE_VALUE,
      BlufiParameter.Type.Ctrl.SUBTYPE_GET_WIFI_LIST);

    this.post(this.mEncrypted, this.mChecksum, this.mRequireAck, type, null).then((request: boolean) => {
      if (!request) {
        this.onDeviceScanResult(BlufiCallback.CODE_WRITE_DATA_FAILED, []);
      }
    }).catch((e: Error) => {
      LogUtil.error(TAG, 'post requestDeviceWifiScan interrupted:' + e);
      this.onDeviceScanResult(BlufiCallback.CODE_WRITE_DATA_FAILED, []);
    });

  }

  private onDeviceScanResult(status: number, results: BlufiScanResult[]) {
    if (this.mUserBlufiCallback !== null && this.mUserBlufiCallback.onDeviceScanResult) {
      this.mUserBlufiCallback.onDeviceScanResult(this.mClient, status, results);
    }
  }

  private async __postCustomData(data: Uint8Array) {
    let type: number = this.getTypeValueWithPackageTypeAndSubType(BlufiParameter.Type.Data.PACKAGE_VALUE,
      BlufiParameter.Type.Data.SUBTYPE_CUSTOM_DATA);

    this.post(this.mEncrypted, this.mChecksum, this.mRequireAck, type, data).then(suc => {
      let status: number = suc ? BlufiCallback.STATUS_SUCCESS : BlufiCallback.CODE_WRITE_DATA_FAILED;
      this.onPostCustomDataResult(status, data);
    }).catch(e => {
      LogUtil.error(TAG, 'post postCustomData interrupted:' + e);
      this.onPostCustomDataResult(BlufiCallback.CODE_WRITE_DATA_FAILED, null);
    })
  }

  private onPostCustomDataResult(status: number, data: Uint8Array) {
    if (this.mUserBlufiCallback !== null && this.mUserBlufiCallback.onPostCustomDataResult) {
      this.mUserBlufiCallback.onPostCustomDataResult(this.mClient, status, data);
    }
  }

  private onReceiveCustomData(data: Uint8Array): void {
    if (this.mUserBlufiCallback !== null && this.mUserBlufiCallback.onReceiveCustomData) {
      this.mUserBlufiCallback.onReceiveCustomData(this.mClient, BlufiCallback.STATUS_SUCCESS, data);
    }
  }

  private __requestCloseConnection(): void {
    let type: number = this.getTypeValueWithPackageTypeAndSubType(BlufiParameter.Type.Ctrl.PACKAGE_VALUE,
      BlufiParameter.Type.Ctrl.SUBTYPE_CLOSE_CONNECTION);
    try {
      this.post(false, false, false, type, null);
    } catch (e) {
      LogUtil.error(TAG, 'post requestCloseConnection interrupted');
    }
  }
}
