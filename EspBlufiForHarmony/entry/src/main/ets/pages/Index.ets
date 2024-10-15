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

import abilityAccessCtrl, { PermissionRequestResult, Permissions } from '@ohos.abilityAccessCtrl';
import common from '@ohos.app.ability.common';
import { BusinessError } from '@ohos.base';
import { bundleManager } from '@kit.AbilityKit';
import { access, ble } from '@kit.ConnectivityKit';
import { router } from '@kit.ArkUI';
import { Logger } from '@ohos/espblufiforharmony';
import { BLUFI_SCAN_SLEEP_TIME, EIGHT, FIVE_HUNDRED, NINETY, TEN, TWELVE, TWENTY, } from './Magic';

const TAG: string = 'Index';

@Entry
@Component
struct Index {
  @State deviceName: string = '';
  @State deviceId: string = '';
  @State deviceRSSI: number = 0;
  @State scanFilterInputName: string = ''
  @State status: boolean = true;
  permissions: Permissions[] =
    ['ohos.permission.ACCESS_BLUETOOTH', 'ohos.permission.USE_BLUETOOTH', 'ohos.permission.GET_WIFI_INFO'];
  private devices: ble.ScanResult[] = [];

  // 校验当前是否已经授权了
  async checkAccessToken(permission: Permissions): Promise<abilityAccessCtrl.GrantStatus> {
    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    let grantStatus: abilityAccessCtrl.GrantStatus = abilityAccessCtrl.GrantStatus.PERMISSION_DENIED;

    // 获取应用程序的accessTokenID
    let tokenId: number = 0;
    try {
      let bundleInfo: bundleManager.BundleInfo =
        await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
      let appInfo: bundleManager.ApplicationInfo = bundleInfo.appInfo;
      tokenId = appInfo.accessTokenId;
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `Failed to get bundle info for self. Code is ${err.code}`);
    }

    // 校验应用是否被授予权限
    try {
      grantStatus = await atManager.checkAccessToken(tokenId, permission);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `Failed to check access token. Code is ${err.code}`);
    }
    return grantStatus;
  }

  async checkPermissions(context: common.UIAbilityContext): Promise<void> {
    try {
      let grantStatus: abilityAccessCtrl.GrantStatus = await this.checkAccessToken(this.permissions[0]);
      if (grantStatus === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
      } else {
        this.reqPermissionsFromUser(this.permissions, context);
      }
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, 'checkPermissions' + `Code is ${err.code}`);
    }
  }

  reqPermissionsFromUser(permissions: Permissions[], context: common.UIAbilityContext): void {
    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    atManager.requestPermissionsFromUser(context, permissions).then((data: PermissionRequestResult) => {
      Logger.info(TAG, 'data:' + data);
      Logger.info(TAG, 'data permissions:' + data.permissions);
      Logger.info(TAG, 'data authResults:' + data.authResults);
      Logger.info(TAG, 'data dialogShownResults:' + data.dialogShownResults);
    }).catch((error: BusinessError) => {
      Logger.error(TAG, `Failed to request permissions from user. Code is ${error.code}`);
    })
  }

  Scan() {
    let routerParams: object = router.getParams();
    let scanFilterArr: ble.ScanFilter[] = [];
    if (routerParams) {
      this.scanFilterInputName = routerParams['blufiName'] as string;
      let scanFilterThree: ble.ScanFilter = {
        name: this.scanFilterInputName
      };
      scanFilterArr.push(scanFilterThree);
    }
    let scanOptions: ble.ScanOptions = {
      interval: FIVE_HUNDRED,
      dutyMode: ble.ScanDuty.SCAN_MODE_LOW_POWER,
      matchMode: ble.MatchMode.MATCH_MODE_AGGRESSIVE
    }
    if (scanFilterArr.length !== 0) {
      ble.startBLEScan(scanFilterArr, scanOptions);
      Logger.info('startBleScan success')
    }
    ble.on('BLEDeviceFind', (data) => {
      if (Array.isArray(data) && data.length && this.devices.length === 0) {
        ble.stopBLEScan();
        this.devices = data;
        this.deviceName = this.devices[0].deviceName;
        this.deviceId = this.devices[0].deviceId;
        this.deviceRSSI = this.devices[0].rssi;
      }
    });
    setTimeout(() => {
      try {
        ble.stopBLEScan();
        Logger.info('stopBleScan success');
      } catch (e) {
        Logger.error(TAG, `Failed to stopBLEScan. Code is ${(e as BusinessError).code}`);
      }
    }, BLUFI_SCAN_SLEEP_TIME)
  }

  aboutToAppear(): void {
    const context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
    this.checkPermissions(context);
  }

  scanBtnAction() {
    this.status = !this.status
    setTimeout(() => {
      this.status = !this.status
    }, BLUFI_SCAN_SLEEP_TIME)
    let bleState = access.getState().toString()
    if (bleState === '2') {
      this.Scan();
    } else {
      try {
        access.enableBluetooth();
      } catch (e) {
        Logger.error(TAG, `Failed to enableBluetooth. Code is ${(e as BusinessError).code}`);
      }
      this.Scan();
    }
  }

  build() {
    Column() {
      Row() {
        Text('EspBluFi')
          .backgroundImageSize({ width: '', height: '' })
        Button(this.status ? $r('app.string.scan') : $r('app.string.scanning'))
          .onClick(this.scanBtnAction.bind(this))
          .enabled(this.status)
          .backgroundColor(0x317aff)
          .borderRadius(EIGHT)
          .width(NINETY)
        Button($r('app.string.setting'))
          .backgroundColor(0x317aff)
          .borderRadius(EIGHT)
          .width(NINETY)
          .onClick(() => {
            router.pushUrl({
              url: 'pages/Setting'
            }, router.RouterMode.Standard, (error) => {
              if (error) {
                Logger.error(`Invoke pushUrl failed, code is ${error.code}`);
                return;
              }
            });
          })

      }
      .justifyContent(FlexAlign.SpaceAround)
      .width('100%')
      .margin({ bottom: TEN })
      .backgroundColor(Color.Pink)

      Column() {
        Row() {
          Text($r('app.string.deviceName'))
            .fontSize(TWENTY)
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Start)
            .onClick(() => {
              this.pageTo();
            })
          Text(this.deviceName)
            .fontSize(TWENTY)
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Start)
            .onClick(() => {
              this.pageTo();
            })
        }

        Row() {
          Text($r('app.string.deviceID'))
            .fontSize(TWENTY)
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Start)
            .onClick(() => {
              this.pageTo();
            })
          Text(this.deviceId)
            .fontSize(TWENTY)
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Start)
            .onClick(() => {
              this.pageTo();
            })
        }

        Row() {
          Text($r('app.string.deviceRSSI'))
            .fontSize(TWENTY)
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Start)
            .onClick(() => {
              this.pageTo();
            })
          Text(`${this.deviceRSSI}`)
            .fontSize(TWENTY)
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Start)
            .onClick(() => {
              this.pageTo();
            })
        }

      }
      .alignItems(HorizontalAlign.Start)
      .width('100%')
      .backgroundColor(0xF5DEB3)
      .margin({ bottom: TEN })
      .padding(TWELVE)
      .height('100%')
      .backgroundColor(0xF1F3F5)
    }
    .height('100%')
    .justifyContent(FlexAlign.Start)
    .padding(TEN)
  }

  private pageTo() {
    if (this.deviceId !== null && this.deviceName !== null && this.deviceRSSI !== 0) {
      router.pushUrl({
        url: 'pages/ConfigureOptions',
        params: { deviceId: this.deviceId }
      })
    }
  }
}

