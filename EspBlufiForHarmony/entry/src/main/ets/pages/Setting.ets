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
import { bundleManager } from '@kit.AbilityKit';
import deviceinfo from '@ohos.deviceInfo';
import { BusinessError } from '@kit.BasicServicesKit';
import { Logger } from '@ohos/espblufiforharmony';
import { EIGHT, FIVE, FOUR, ONE_HUNDRED_AND_SEVENTH, SIXTY, TEN, THIRTY, TWENTY, } from './Magic';

const TAG: string = 'Setting';

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
      Text($r('app.string.Please_enter_the_name_of_the_Bluetooth_device'))
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
          .backgroundColor(0xffffff)
          .fontColor(Color.Black)
          .onClick(() => {
            if (this.controller !== undefined) {
              this.controller.close();
              this.cancel();
            }
          })
        Button($r('app.string.ok'))
          .backgroundColor(0xffffff)
          .fontColor(Color.Red)
          .onClick(() => {
            if (this.controller !== undefined) {
              this.inputValue = this.textValue;
              this.controller.close();
              this.confirm();
            }
          })
      }
      .margin({ bottom: TEN })
    }
    .borderRadius(TEN)
  }
}

@Entry
@Component
struct Setting {
  @State message: string = 'EspBluFi';
  @State textValue: string = '';
  @State inputValue: string = '';
  @State versionCode: string = '';
  @State sdkApiVersionInfo: string = '';
  dialogController: CustomDialogController | null = new CustomDialogController({
    builder: CustomDialogExample({
      cancel: () => {
        this.onCancel();
      },
      confirm: () => {
        this.onAccept();
      },
      textValue: $textValue,
      inputValue: $inputValue
    }),
    cancel: this.exitApp,
    autoCancel: true,
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: -TWENTY },
    gridCount: FOUR,
    customStyle: false,
    cornerRadius: TEN,
  })

  aboutToDisappear() {
    this.dialogController = null;
  }

  onCancel() {
  }

  onAccept() {
  }

  exitApp() {
  }

  aboutToAppear(): void {
    this.getAppVersion();
  }

  getAppVersion(): void {
    try {
      let bundleFlags = bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION;
      bundleManager.getBundleInfoForSelf(bundleFlags, (error, data) => {
        const bundleName: string = data.name;
        this.versionCode = data.versionCode.toString();
        const versionName: string = data.versionName;
        this.sdkApiVersionInfo = deviceinfo.sdkApiVersion.toString();
        Logger.info(TAG, 'the value of the deviceinfo sdkApiVersion is :' + this.sdkApiVersionInfo);
        if (error) {
          Logger.error(TAG, `getBundleInfoForSelf failed: ${error.code}`);
        } else {
          Logger.info(TAG, `get bundleName successfully: ${bundleName}`);
          Logger.info(TAG, `get versionCode successfully: ${this.versionCode}`);
          Logger.info(TAG, `get versionName successfully: ${versionName}`);
          Logger.info(TAG, `getBundleInfoForSelf successfully: ${data}`);
        }
      });
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `getBundleInfoForSelf failed: ${err.code}`);
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
            router.back({
              url: 'pages/Index',
              params: { blufiName: this.inputValue }
            })
          })

          Text($r('app.string.setting'))
            .fontSize(THIRTY)
        }
        .width('100%')
        .height('5.00%')
        .margin({
          top: TWENTY,
          right: '0.00vp',
          bottom: '0.00vp',
          left: '0.00vp'
        })

        Column({ space: FIVE }) {
          Text('BluFi')
            .width('90%')
            .fontColor(Color.Pink)
          Column({ space: FIVE }) {
            Text($r('app.string.BluFi_Device_Filtering'))
              .fontSize(THIRTY)
              .fontWeight(FontWeight.Bold)
              .textAlign(TextAlign.Start)
            Button(this.inputValue)
              .onClick(() => {
                if (this.dialogController !== null) {
                  this.dialogController.open()
                }
              })
              .backgroundColor('#00297bff')
              .width('100%')
              .fontColor(Color.Black)
          }
          .width('90%')
          .height(ONE_HUNDRED_AND_SEVENTH)
          .alignItems(HorizontalAlign.Start)
          .justifyContent(FlexAlign.Center)
          .border({ width: 1 })
          .borderStyle(BorderStyle.Solid)

          Text($r('app.string.version'))
            .width('90%')
            .fontColor(Color.Pink)

          Column() {
            Text($r('app.string.APP_version'))
              .fontSize(TWENTY)
              .fontWeight(FontWeight.Bold)
              .textAlign(TextAlign.Start)
            Text(this.versionCode)
              .fontSize(TWENTY)
              .fontWeight(FontWeight.Bold)
              .textAlign(TextAlign.Start)
          }
          .width('90%')
          .alignItems(HorizontalAlign.Start)
          .justifyContent(FlexAlign.Center)
          .height('10%')
          .border({ width: 1 })

          Column() {
            Text($r('app.string.API_version'))
              .fontSize(TWENTY)
              .fontWeight(FontWeight.Bold)
              .textAlign(TextAlign.Start)
            Text(this.sdkApiVersionInfo)
              .fontSize(TWENTY)
              .fontWeight(FontWeight.Bold)
              .textAlign(TextAlign.Start)
          }
          .width('90%')
          .alignItems(HorizontalAlign.Start)
          .justifyContent(FlexAlign.Center)
          .height('10%')
          .border({ width: 1 })

          Column() {
            Button($r('app.string.check_for_updates'), { type: ButtonType.Normal, stateEffect: true })
              .borderRadius(EIGHT)
              .backgroundColor('#00297bff')
              .fontColor(Color.Black)
              .width('100.00%')
              .onClick(() => {
              })
              .align(Alignment.Start)
          }
          .width('90%')
          .border({ width: 1 })
          .alignItems(HorizontalAlign.Start)
          .justifyContent(FlexAlign.End)
        }
        .width('100%')
      }
      .width('100%')
      .height('100%')
    }
    .height('100%')
    .width('100%')
    .backgroundColor(0xF1F3F5)
    .height('100%')
  }
}


