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

import { router } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import wifiManager from '@ohos.wifiManager';
import { Logger } from '@ohos/espblufiforharmony';
import {
  FIVE,
  FIVE_HUNDRED,
  FOUR_HUNDRED,
  SIXTEEN,
  TEN,
  THIRTY,
  THREE_HUNDRED,
  TWENTY_FOUR,
  TWO_HUNDRED
} from './Magic';

const TAG: string = 'DistributionNetwork';

@Entry
@Component
struct DistributionNetwork {
  @State @Watch('onTextDeviceUpdated') textDevice: string = 'Station';
  @State @Watch('onTextSoftAPUpdated') textSoftAP: string = 'Open';
  @State textSoftAPChannel: string = '1';
  @State textSoftAPConnect: string = '1';
  @State index: number = -1;
  @State arrowPosition: ArrowPosition = ArrowPosition.END;
  @State select: number = 0;
  @State softAPSelectVisibility: Visibility = Visibility.None;
  @State softAPSelectChannelVisibility: Visibility = Visibility.None;
  @State softAPSelectConnectVisibility: Visibility = Visibility.None;
  @State softAPSSIDVisibility: Visibility = Visibility.None;
  @State softAPPasswordVisibility: Visibility = Visibility.None;
  @State selectWifiVisibility: Visibility = Visibility.Visible;
  @State softAPSSID: string = '';
  @State softAPPassword: string = '';
  @State wifiSSID: string = '';
  @State wifiPassword: string = '';
  private wifiSSIDList: string[] = [''];
  private wifiBSSIDList: string[] = [''];

  onTextDeviceUpdated() {
    this.selected();
  }

  onTextSoftAPUpdated() {
    this.selected();
  }

  wifi() {
    try {
      let isWifiActive: boolean = wifiManager.isWifiActive();
      if (isWifiActive === true) {
        this.wifiScan();
      } else {
        isWifiActive = true;
        this.wifiScan();
      }
      Logger.info(TAG, 'isWifiActive:' + isWifiActive);
    } catch (error) {
      let code: number = (error as BusinessError).code;
      Logger.error(TAG, 'failed:' + `Code is ${code}`);
    }

    // 获取扫描结果
    this.getWifiResult();
    TextPickerDialog.show({
      range: this.wifiSSIDList,
      selected: this.select,
      onAccept: (value: TextPickerResult) => {
        this.select = value.index as number;
        Logger.info(TAG, 'TextPickerDialog:onAccept()' + value);
        this.wifiSSID = value.value as string;
      },
      onCancel: () => {
        Logger.info(TAG, 'TextPickerDialog:onCancel()');
      },
      onChange: (value: TextPickerResult) => {
        Logger.info(TAG, 'TextPickerDialog:onChange()' + value);
      }
    })
  }

  wifiScan() {
    try {
      wifiManager.scan();
    } catch (error) {
      let code: number = (error as BusinessError).code;
      Logger.error(TAG, 'wifiScan:failed:' + `Code is ${code}`);
    }
  }

  getWifiResult() {
    try {
      let scanInfoList: wifiManager.WifiScanInfo[] = wifiManager.getScanInfoList();
      Logger.info(TAG, 'scanInfoList:' + scanInfoList);
      let len: number = scanInfoList.length;
      Logger.info(TAG, 'wifi received scan info: ' + len);
      if (len > 0) {
        scanInfoList.forEach((scanInfo) => {
          this.wifiSSIDList.push(scanInfo.ssid);
        });
      }
    } catch (error) {
      let code: number = (error as BusinessError).code;
      Logger.error(TAG, 'failed:' + `Code is ${code}`);
    }
  }

  selected() {
    if (this.textDevice === 'Station') {
      this.selectWifiVisibility = Visibility.Visible;
      this.softAPSelectVisibility = Visibility.None;
      this.softAPSelectChannelVisibility = Visibility.None;
      this.softAPSelectConnectVisibility = Visibility.None;
      this.softAPSSIDVisibility = Visibility.None;
      this.softAPPasswordVisibility = Visibility.None;
    }
  }

  build() {
    Row() {
      Column() {
        Row() {
          Button() {
            Image($r("app.media.ic_public_back"))
              .width(THIRTY)
              .height(THIRTY)
          }
          .width('20%')
          .height('100%')
          .backgroundColor(0xF1F3F5)
          .onClick(() => {
            try {
              router.back({
                url: 'pages/ConfigureOptions'
              })
              Logger.info(TAG, 'Succeeded in returning to the first page.')
            } catch (error) {
              let code: number = (error as BusinessError).code;
              Logger.error(TAG, `Failed to return to the first page.Code is ${code}`);
            }
          })

          Text($r('app.string.deviceName'))
            .fontSize(TWENTY_FOUR)
        }
        .width('100%')
        .height('5.00%')
        .margin({
          top: '0.00vp',
          right: '0.00vp',
          bottom: '0.00vp',
          left: '0.00vp'
        })

        // 选择设备模式
        Column() {
          Text($r('app.string.Select_Device_Mode'))
            .width('90%')
            .fontColor(Color.Black)
            .padding(TEN)
          Select([{ value: 'Station' }
          ])
            .selected(this.index)
            .value(this.textDevice)
            .font({ size: SIXTEEN, weight: FIVE_HUNDRED })
            .fontColor('#182431')
            .selectedOptionFont({ size: SIXTEEN, weight: FOUR_HUNDRED })
            .optionFont({ size: SIXTEEN, weight: FOUR_HUNDRED })
            .arrowPosition(this.arrowPosition)
            .menuAlign(MenuAlignType.START, { dx: 0, dy: 0 })
            .optionWidth(TWO_HUNDRED)
            .optionHeight(THREE_HUNDRED)
            .width('80%')
            .onSelect((index: number, text?: string | undefined) => {
              this.index = index;
              if (text) {
                this.textDevice = text;
              }
            })
        }

        // SoftAP 加密
        Column() {
          Text($r('app.string.SoftAP_encryption'))
            .width('90%')
            .fontColor(Color.Black)
            .padding(TEN)
          Select([{ value: 'Open' },
            { value: 'WPA PSK' },
            { value: 'WPA2 PSK' },
            { value: 'WPA WAP2 PSK' }])
            .selected(this.index)
            .value(this.textSoftAP)
            .font({ size: SIXTEEN, weight: FIVE_HUNDRED })
            .fontColor('#182431')
            .selectedOptionFont({ size: SIXTEEN, weight: FOUR_HUNDRED })
            .optionFont({ size: SIXTEEN, weight: FOUR_HUNDRED })
            .arrowPosition(this.arrowPosition)
            .menuAlign(MenuAlignType.START, { dx: 0, dy: 0 })
            .optionWidth(TWO_HUNDRED)
            .optionHeight(THREE_HUNDRED)
            .width('80%')
            .onSelect((index: number, text?: string | undefined) => {
              this.index = index;
              if (text) {
                this.textSoftAP = text;
              }
            })
        }
        .visibility(this.softAPSelectVisibility)

        Row() {

          // SoftAP 信道
          Column() {
            Text($r('app.string.SoftAP_channel'))
              .width('40%')
              .fontColor(Color.Black)
              .padding(TEN)
            Select([{ value: '1' },
              { value: '2' },
              { value: '3' },
              { value: '4' },
              { value: '5' },
              { value: '6' },
              { value: '7' },
              { value: '8' },
              { value: '9' },
              { value: '10' },
              { value: '11' },
              { value: '12' },
              { value: '13' }])
              .selected(this.index)
              .value(this.textSoftAPChannel)
              .font({ size: SIXTEEN, weight: FIVE_HUNDRED })
              .fontColor('#182431')
              .selectedOptionFont({ size: SIXTEEN, weight: FOUR_HUNDRED })
              .optionFont({ size: SIXTEEN, weight: FOUR_HUNDRED })
              .arrowPosition(this.arrowPosition)
              .menuAlign(MenuAlignType.START, { dx: 0, dy: 0 })
              .optionWidth(TWO_HUNDRED)
              .optionHeight(THREE_HUNDRED)
              .width('40%')
              .onSelect((index: number, text?: string | undefined) => {
                this.index = index;
                if (text) {
                  this.textSoftAPChannel = text;
                }
              })
          }
          .visibility(this.softAPSelectChannelVisibility)

          // SoftAP 最大连接数
          Column() {
            Text($r('app.string.SoftAP_max_connect'))
              .width('FIVE0%')
              .fontColor(Color.Black)
              .padding(TEN)
            Select([{ value: '1' },
              { value: '2' },
              { value: '3' },
              { value: '4' }])
              .selected(this.index)
              .value(this.textSoftAPConnect)
              .font({ size: SIXTEEN, weight: FIVE_HUNDRED })
              .fontColor('#182431')
              .selectedOptionFont({ size: SIXTEEN, weight: FOUR_HUNDRED })
              .optionFont({ size: SIXTEEN, weight: FOUR_HUNDRED })
              .arrowPosition(this.arrowPosition)
              .menuAlign(MenuAlignType.START, { dx: 0, dy: 0 })
              .optionWidth(TWO_HUNDRED)
              .optionHeight(THREE_HUNDRED)
              .width('40%')
              .onSelect((index: number, text?: string | undefined) => {
                this.index = index;
                if (text) {
                  this.textSoftAPConnect = text;
                }
              })
          }
          .visibility(this.softAPSelectConnectVisibility)
        }

        // SoftAP ssid
        Column() {
          TextInput({ placeholder: 'SoftAP ssid', text: this.wifiSSID })
            .visibility(this.softAPSSIDVisibility)
            .margin({ top: FIVE })
            .width('90%')
            .onChange((inputSoftAPSSID: string) => {
              this.softAPSSID = inputSoftAPSSID;
            })
            .onSubmit((EnterKeyType) => {
            })
        }

        // SoftAP 密码
        Column() {
          TextInput({ placeholder: $r('app.string.SoftAP_password') })
            .visibility(this.softAPPasswordVisibility)
            .type(InputType.Password)
            .margin({ top: TEN })
            .width('90%')
            .onChange((inputSoftAPPassword: string) => {
              this.softAPPassword = inputSoftAPPassword;
            })
            .onSubmit((EnterKeyType) => {
            })
        }

        // 选择WiFi
        Column() {
          Text($r('app.string.select_wifi'))
            .width('90%')
            .fontColor(Color.Black)
            .padding(FIVE)
          Row() {
            TextInput({ placeholder: 'WiFi ssid', text: this.wifiSSID })
              .margin({ top: FIVE })
              .width('80%')
              .onChange((inputWiFiSSID: string) => {
                this.wifiSSID = inputWiFiSSID;
              })
              .onSubmit((EnterKeyType) => {
              })
            Image($r('app.media.ic_public_rotate'))
              .width(TWENTY_FOUR)
              .height(TWENTY_FOUR)
              .margin({ left: TEN })
              .onClick(() => {
                this.wifi();
              })
          }

          TextInput({ placeholder: $r('app.string.wifi_password') })
            .type(InputType.Password)
            .margin({ top: TEN })
            .width('90%')
            .onChange((password: string) => {
              this.wifiPassword = password;
            })
            .onSubmit((EnterKeyType) => {
            })

        }
        .visibility(this.selectWifiVisibility)
        .padding(FIVE)

        Button($r('app.string.ok'))
          .width('50%')
          .margin({ top: TEN })
          .enabled(this.wifiSSID.length != 0 && this.wifiPassword.length != 0)
          .onClick(() => {
            try {
              if (this.wifiSSID.length != 0 && this.wifiPassword.length != 0) {
                router.back({
                  url: 'pages/ConfigureOptions',
                  params: {
                    deviceOpMode: this.textDevice,
                    ssid: this.wifiSSID,
                    password: this.wifiPassword
                  }
                })
              }
              Logger.info(TAG, 'Succeeded in returning to the first page.');
            } catch (error) {
              let code: number = (error as BusinessError).code;
              Logger.error(TAG, `Failed to return to the first page.Code is ${code}`);
            }
          })

      }
      .width('100%')
      .height('100%')
    }
    .backgroundColor(0xF1F3F5)
    .height('100%')
  }
}
