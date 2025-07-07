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

import { BusinessError } from '@kit.BasicServicesKit';
import { ble, constant, } from '@kit.ConnectivityKit';
import { router } from '@kit.ArkUI';
import { util } from '@kit.ArkTS';
import {
  BlufiClient,
  BlufiCallback,
  BlufiGattCallback,
  BlufiConfigureParams,
  BlufiParameter,
  BlufiUtil,
  BlufiVersionResponse,
  BlufiStatusResponse,
  BlufiScanResult,
  Logger
} from '@ohos/espblufiforharmony';
import {
  EIGHT,
  FIVE,
  FORTY,
  FOUR,
  FRICTION_NUMBER,
  ONE_THOUSAND,
  SIXTEEN,
  SIXTY,
  TEN,
  THIRTY,
  THREE,
  TWENTY,
  TWO,
} from './Magic';


const TAG: string = 'ConfigureOptions';

@CustomDialog
struct CustomDialogExample {
  @Link textValue: string;
  @Link inputValue: string;
  controller?: CustomDialogController;
  cancel: () => void = () => {
  }
  confirm: () => void = () => {
  }

  build() {
    Column() {
      Text($r('app.string.string_Enter_user_defined_data'))
        .fontSize(TWENTY)
        .margin({ top: TEN, bottom: TEN })
      TextInput({ placeholder: '', text: this.textValue })
        .height(SIXTY)
        .width('90%')
        .onChange((value: string) => {
          this.textValue = value;
        })
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button($r('app.string.cancel'))
          .onClick(() => {
            if (this.controller !== undefined) {
              this.controller.close();
              this.cancel();
            }
          })
          .backgroundColor(0xffffff)
          .fontColor(Color.Black)
        Button($r('app.string.ok'))
          .onClick(() => {
            if (this.controller !== undefined) {
              this.inputValue = this.textValue;
              this.controller.close();
              this.confirm();
            }
          })
          .backgroundColor(0xffffff)
          .fontColor(Color.Red)
      }
      .margin({ bottom: TEN })
    }.borderRadius(TEN)
  }
}

@Entry
@Component
struct ConfigureOptions {
  blufiClientInstance: null | BlufiClient = null;
  @State deviceId: string = '';
  @State ssid: string = '';
  @State password: string = '';
  @State bssid: string = '';
  @State deviceOpMode: string = '';
  @State softAP: string = '';
  @State softAPChannel: string = '';
  @State softAPConnect: string = '';
  @State softAPSSID: string = '';
  @State softAPPassword: string = '';
  @State itemArray: string[] = [];
  @State textValue: string = '';
  @State inputValue: string = '';
  @State connectStateSuccess: number = TWO;
  @State btnEnabled: boolean = false;
  @State disconnectBtnEnables: boolean = false;
  @State encryptionBtnEnables: boolean = false;
  @State scanBtnEnables: boolean = false;
  dialogController: CustomDialogController | null = new CustomDialogController({
    builder: CustomDialogExample({
      cancel: () => {
        this.onCancel();
      },
      confirm: () => {
        this.onAccept();
      },
      textValue: $textValue,
      inputValue: $inputValue,
    }),
    cancel: this.exitApp,
    autoCancel: true,
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: -TWENTY },
    gridCount: FOUR,
    customStyle: false,
    cornerRadius: TEN,
  })
  @State connectState: constant.ProfileConnectionState = 0;

  aboutToDisappear() {
    this.dialogController = null;
  }

  getSingleClient(): BlufiClient {
    if (this.blufiClientInstance === null) {
      this.blufiClientInstance = new BlufiClient(this.deviceId) as BlufiClient;
    }
    return this.blufiClientInstance;
  }

  onCancel() {
  }

  onAccept() {
    let data: Uint8Array = BlufiUtil.stringToUint8Array(this.inputValue);
    if (this.deviceId.length !== 0) {
      this.getSingleClient().postCustomData(data);
    }
  }

  exitApp() {
  }

  aboutToAppear(): void {
    const routerParams: object = this.getUIContext().getRouter().getParams();
    this.deviceId = routerParams['deviceId'] as string;
    const test: BlufiClient = this.getSingleClient();
    let gattCk = this.gattCallback();
    let blufiCk = this.blufiCallback();
    test.setGattCallback(gattCk);
    test.setBlufiCallback(blufiCk);
    this.getSingleClient().printDebugLog(true);
  }

  gattCallback(): BlufiGattCallback {
    let gattCk: BlufiGattCallback = {
      onConnectionStateChange: (device: ble.GattClientDevice, state: constant.ProfileConnectionState,
        bleConnectionState: ble.BLEConnectionChangeState) => {
        Logger.info(TAG, 'onConnectionStateChange', state.toString());
        this.connectState = state;
        let status: boolean = state == constant.ProfileConnectionState.STATE_CONNECTED;
        this.btnEnabled = status;
        this.disconnectBtnEnables = this.btnEnabled;
        this.encryptionBtnEnables = this.btnEnabled;
        this.scanBtnEnables = this.btnEnabled;
        if (this.connectState === this.connectStateSuccess) {
          this.itemArray.push('Connected ' + this.deviceId);
          this.itemArray.push('Discover service and characteristics success');
          this.itemArray.push('Set notification enable complete');
        } else if (this.connectState === THREE) {
          this.itemArray.push('Disconnected ' + this.deviceId);
        }
      },
      onServicesDiscovered: (device: ble.GattClientDevice, services: ble.GattService[]) => {
        Logger.info(TAG, 'onServicesDiscovered', services.toLocaleString());
      },
    }
    return gattCk;
  }

  blufiCallback(): BlufiCallback {
    let blufiCk: BlufiCallback = {
      onGattPrepared: (client: BlufiClient, device: ble.GattClientDevice, service: ble.GattService,
        writeChar: ble.BLECharacteristic, notifyChar: ble.BLECharacteristic): void => {
        throw new Error('Function not implemented.');
      },

      onError: (client: BlufiClient, errCode: number): void => {
        Logger.info(TAG, 'BlufiCallback-onError', errCode.toString());
        this.itemArray.push('Receive error code ' + errCode);
      },

      // esp32给手机发送原始数据
      onGattNotification: (client: BlufiClient, pkgType: number, subType: number, data: Uint8Array): boolean => {
        return false;
      },

      // 密钥协商发送状态
      onNegotiateSecurityResult: (client: BlufiClient, status: number): void => {
        if (status === BlufiCallback.STATUS_SUCCESS) {
          this.itemArray.push('Negotiate security complete');
        } else {
          this.itemArray.push('Negotiate security failed， code=' + status);
        }
        Logger.info(TAG, 'onNegotiateSecurityResult', status.toString());
      },

      // 配网参数发送状态
      onPostConfigureParams: (client: BlufiClient, status: number): void => {
        if (status === BlufiCallback.STATUS_SUCCESS) {
          this.itemArray.push('Post configure params complete');
        } else {
          this.itemArray.push('Post configure params failed, code=' + status);
        }
        Logger.info(TAG, 'onPostConfigureParams', status.toString());
      },

      // 获取设备版本
      onDeviceVersionResponse: (client: BlufiClient, status: number, response: BlufiVersionResponse): void => {
        if (status === BlufiCallback.STATUS_SUCCESS) {
          this.itemArray.push('Receive device version: ' + response.getVersionString());
        } else {
          this.itemArray.push('Device version error, code=' + status);
        }
        Logger.info(TAG, 'onDeviceVersionResponse', status.toString(), response.getVersionString());
      },

      // wifi连接状态
      onDeviceStatusResponse: (client: BlufiClient, status: number, response: BlufiStatusResponse): void => {
        if (status === BlufiCallback.STATUS_SUCCESS) {
          this.itemArray.push('Receive device status response: ' + response.generateValidInfo());
          this.itemArray.push('Station is connecting WiFi now' + response.generateValidInfo());
          this.itemArray.push('Station connect Wi-Fi ssid: ' + this.ssid);
          this.itemArray.push('Receive device status response: ' + status);
        } else {
          this.itemArray.push('Device status response error, code=' + status);
          this.itemArray.push('Station disconnect Wi-Fi now');
        }
        Logger.info(TAG, 'onDeviceStatusResponse', status.toString(), response.generateValidInfo());
      },

      // 扫描
      onDeviceScanResult: (client: BlufiClient, status: number, results: BlufiScanResult[]): void => {
        if (status === BlufiCallback.STATUS_SUCCESS) {
          this.itemArray.push('Receive device scan result: ' + results.toLocaleString());
        } else {
          this.itemArray.push('Device scan result error, code = ' + status);
        }
        Logger.info(TAG, 'onDeviceScanResult', status.toString(), results.length.toString());
      },

      // 自定义消息发送状态
      onPostCustomDataResult: (client: BlufiClient, status: number, data: Uint8Array): void => {
        if (status === BlufiCallback.STATUS_SUCCESS) {
          this.itemArray.push(util.format('Post data ' + status + data.toLocaleString() + 'complete'));
        } else {
          this.itemArray.push(util.format('Post data ' + status + data.toLocaleString() + 'failed'));
        }
      },

      // 接受esp32给手机的自定义消息回执
      onReceiveCustomData: (client: BlufiClient, status: number, data: Uint8Array): void => {
        if (status === BlufiCallback.STATUS_SUCCESS) {
          this.itemArray.push(util.format('Receive custom data:' + data.toLocaleString()));
        } else {
          this.itemArray.push('Receive custom data error, code=' + status);
        }
        Logger.info(TAG, 'onReceiveCustomData', status.toString(), data.toLocaleString());
      }

    }
    return blufiCk;
  }

  onPageShow(): void {
    const routerParams: object = this.getUIContext().getRouter().getParams();
    if (routerParams) {
      this.deviceOpMode = routerParams['deviceOpMode'] as string;
      this.ssid = routerParams['ssid'] as string;
      this.password = routerParams['password'] as string;
    }
    this.checkInfo();
  }

  checkInfo(): BlufiConfigureParams | null {
    let params: BlufiConfigureParams = new BlufiConfigureParams();
    const deviceMode: string = this.deviceOpMode;

    switch (deviceMode) {
      case '':
        return params;
      case 'Station':
        if (this.checkStation(params)) {
          return params;
        } else {
          return null;
        }
    }
    return null;
  }

  // Station
  checkStation(params: BlufiConfigureParams): boolean {
    if (this.ssid !== null && this.password !== null) {
      params.setOpMode(BlufiParameter.OP_MODE_STA);
      let ssid: string = this.ssid;
      let ssidByte: Uint8Array = BlufiUtil.stringToUint8Array(ssid);
      let ssidUint8: Uint8Array = new util.Base64Helper().encodeSync(ssidByte, TWO);
      let ssidUint8Stry: string = new util.Base64Helper().encodeToStringSync(ssidByte);
      Logger.info(TAG, 'checkStation-base64-ssidUint8', ssidUint8Stry);
      params.setStaSSIDBytes(BlufiUtil.stringToUint8Array(ssidUint8Stry));
      let pwd: string = this.password;
      let timestamp: number = new Date().getTime() / ONE_THOUSAND;
      let userid: string = 'ae:49cb1518f2c5692154c251f0deaeac0f';
      let stringP: string = 'v1#' + pwd + '#' + userid + '#' + timestamp.toFixed(0) + '#';
      params.setStaPassword(stringP);
      Logger.info(TAG, 'checkStation-stringP-', stringP + 'checkStation-ssid:' + ssidUint8.toString());
      this.getSingleClient().configure(params);
      this.ssid = '';
      this.password = '';
    }
    return true;
  }

  // SoftAP
  checkSoftAP(params: BlufiConfigureParams): boolean {
    if (this.softAPSSID !== null && this.softAPPassword !== null) {
      let channel: number = new Number(this.softAPChannel) as number;
      params.setSoftAPChannel(channel);
      let connect: number = new Number(this.softAPConnect) as number;
      params.setSoftAPMaxConnection(connect);
      let ssid: string = this.softAPSSID;
      let ssidByte: Uint8Array = BlufiUtil.stringToUint8Array(ssid);
      let ssidUint8: Uint8Array = new util.Base64Helper().encodeSync(ssidByte, TWO);
      let ssidUint8Stry: string = new util.Base64Helper().encodeToStringSync(ssidByte);
      Logger.info(TAG, 'checkSoftAP-base64-ssidUint8', ssidUint8Stry);
      params.setStaSSIDBytes(BlufiUtil.stringToUint8Array(ssidUint8Stry));
      let pwd: string = this.softAPPassword;
      let timestamp: number = new Date().getTime() / ONE_THOUSAND;
      let userid: string = 'ae:49cb1518f2c5692154c251f0deaeac0f';
      let stringP: string = 'v1#' + pwd + '#' + userid + '#' + timestamp.toFixed(0) + '#';
      params.setSoftAPPassword(stringP);
      Logger.info(TAG, 'checkSoftAP-stringP-', stringP + 'checkSoftAP-ssid:' + ssidUint8.toString());
      let softAp: string = this.softAP;
      switch (softAp) {
        case 'Open':
          return true;
        case 'WPA PSK':
        case 'WPA2 PSK':
        case 'WPA WAP2 PSK':
          if (this.softAPPassword === null || this.softAPPassword.length < EIGHT) {
            return false;
          }
          return true;
      }
      this.getSingleClient().configure(params);
    }
    return true;
  }

  // 连接
  deviceConnectBtn() {
    this.getSingleClient().connect();
  }

  // 断开
  deviceDisconnectBtn() {
    if (this.deviceId.length !== 0) {
      this.getSingleClient().requestCloseConnection();
      this.disconnectBtnEnables = false;
    }
  }

  // 配网
  wifiNetworkBtn() {
    if (this.deviceId.length !== 0) {
      if (this.connectState === constant.ProfileConnectionState.STATE_DISCONNECTED) {
        this.getSingleClient().connect();
      }
      this.getUIContext().getRouter().pushUrl({ url: 'pages/DistributionNetwork' }).then(() => {
        Logger.info(TAG, 'wifiNetworkBtn-Succeeded in jumping to the second page.');
      }).catch((err: BusinessError) => {
        Logger.error(TAG,
          `wifiNetworkBtn-Failed to jump to the second page.Code is ${err.code}`);
      })
    }
  }

  // 加密
  encryptionBtn() {
    if (this.deviceId.length !== 0) {
      this.getSingleClient().negotiateSecurity();
      this.encryptionBtnEnables = false;
    }
  }

  // 版本
  versionBtn() {
    if (this.deviceId.length !== 0) {
      this.getSingleClient().requestDeviceVersion();
    }
  }

  // 扫描
  scanBtn() {
    if (this.deviceId.length !== 0) {
      this.getSingleClient().requestDeviceWifiScan();
      this.scanBtnEnables = false;
    }
  }

  // 状态
  statusBtn() {
    if (this.deviceId.length !== 0) {
      if (true) {
        this.getSingleClient().requestDeviceStatus();
      }
    }
  }

  build() {
    Row() {
      Column() {
        Row() {
          Button() {
            Image($r('app.media.ic_public_back'))
              .width(THIRTY)
              .height(THIRTY)
          }
          .width('20%')
          .height('100%')
          .backgroundColor(0xF1F3F5)
          .onClick(() => {
            this.getUIContext().getRouter().back({
              url: 'pages/Index'
            })
          })

          Text($r('app.string.deviceName'))
            .fontSize(THIRTY)
        }
        .width('100%')
        .height('5.00%')
        .margin({
          top: '0.00vp',
          right: '0.00vp',
          bottom: '0.00vp',
          left: '0.00vp'
        })

        Column() {
          List({ space: TWENTY, initialIndex: 0 }) {
            ForEach(this.itemArray, (item: string) => {
              ListItem() {
                Text('' + item)
                  .width('100%')
                  .height(FORTY)
                  .fontSize(SIXTEEN)
                  .textAlign(TextAlign.Start)
                  .borderRadius(THREE)
                  .backgroundColor(0xFFFFFF)
              }
            }, (item: string, index: number) => `${index}`)
          }
          .listDirection(Axis.Vertical)
          .scrollBar(BarState.Off)
          .friction(FRICTION_NUMBER)
          .divider({
            strokeWidth: 1,
            color: 0xFFFFFF,
            startMargin: TWENTY,
            endMargin: TWENTY
          })
          .edgeEffect(EdgeEffect.Spring)
          .onScrollIndex((firstIndex: number, lastIndex: number, centerIndex: number) => {
          })
          .onDidScroll((scrollOffset: number, scrollState: ScrollState) => {
            Logger.info(TAG, `onScroll scrollState = ScrollState` + scrollState + `, scrollOffset = ` + scrollOffset);
          })
          .width('90%')
          .height('100%')
        }
        .width('100%')
        .height('80%')
        .backgroundColor(0xDCDCDC)
        .padding({ top: FIVE })

        Column() {
          Flex({
            justifyContent: FlexAlign.SpaceEvenly,
            alignContent: FlexAlign.SpaceEvenly,
            wrap: FlexWrap.Wrap
          }) {
            Button($r('app.string.connect'), { type: ButtonType.Normal, stateEffect: true })
              .enabled(this.deviceId.length !== 0)
              .borderRadius(EIGHT)
              .backgroundColor(0x317aff)
              .width('20%')
              .margin({ right: TWO, bottom: TEN })
              .onClick(() => {
                this.deviceConnectBtn();
              })
              .backgroundImagePosition({ x: '0', y: 0 })
            Button($r('app.string.disconnect'), { type: ButtonType.Normal, stateEffect: true })
              .enabled(this.disconnectBtnEnables)
              .borderRadius(EIGHT)
              .backgroundColor(0x317aff)
              .width('20%')
              .onClick(() => {
                this.deviceDisconnectBtn();
              })
              .backgroundImageSize(ImageSize.Auto)
              .backgroundImagePosition({ x: '0', y: 0 })
            Button($r('app.string.encryption'), { type: ButtonType.Normal, stateEffect: true })
              .enabled(this.encryptionBtnEnables)
              .borderRadius(EIGHT)
              .backgroundColor(0x317aff)
              .width('20%')
              .onClick(() => {
                this.encryptionBtn();
              })
            Button($r('app.string.version'), { type: ButtonType.Normal, stateEffect: true })
              .enabled(this.btnEnabled)
              .borderRadius(EIGHT)
              .backgroundColor(0x317aff)
              .width('20%')
              .onClick(() => {
                this.versionBtn();
              })
            Button($r('app.string.wifiNetwork'), { type: ButtonType.Normal, stateEffect: true })
              .enabled(this.btnEnabled)
              .borderRadius(EIGHT)
              .backgroundColor(0x317aff)
              .width('20%')
              .onClick(() => {
                this.wifiNetworkBtn();
              })
            Button($r('app.string.status'), { type: ButtonType.Normal, stateEffect: true })
              .enabled(this.btnEnabled)
              .borderRadius(EIGHT)
              .backgroundColor(0x317aff)
              .width('20%')
              .onClick(() => {
                this.statusBtn();
              })
            Button($r('app.string.scan'), { type: ButtonType.Normal, stateEffect: true })
              .enabled(this.scanBtnEnables)
              .borderRadius(EIGHT)
              .backgroundColor(0x317aff)
              .width('20%')
              .onClick(() => {
                this.scanBtn();
              })
            Button($r('app.string.widgets'), { type: ButtonType.Normal, stateEffect: true })
              .enabled(this.btnEnabled)
              .borderRadius(EIGHT)
              .backgroundColor(0x317aff)
              .width('20%')
              .onClick(() => {
                if (this.dialogController != null) {
                  this.dialogController.open();
                }
              })
          }
          .width('100%')
          .padding({
            top: TEN,
            bottom: TEN,
            left: TEN,
            right: TEN
          })
          .backgroundColor(0xAFEEEE)
        }
        .justifyContent(FlexAlign.End)

      }
      .width('100%')
      .height('100%')
    }
    .backgroundColor(0xF1F3F5)
    .height('100%')
  }
}