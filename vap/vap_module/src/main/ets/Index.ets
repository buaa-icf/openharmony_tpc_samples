/*
 * Copyright (C) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { util } from '@kit.ArkTS';
import {
  AnimConfig,
  FitType,
  MixData,
  SrcInfo,
  VideoInfo,
  XComponentContext,
  VAPColor,
  VAPTextAlign,
  VAPFontWeight,
  DownloadData,
  VapState
} from './DataDeclare';
import { LogUtil } from './LogUtil';
import { downloadFile } from './HttpReq'

class MaPosition {
  public width: number = 200
  public height: number = 30
  public top: number = 0
  public left: number = 0
}

export class MixInputDataBean implements MixData {
  tag: string;
  txt?: string;
  imgUri?: string;
  color?: VAPColor
  fontWeight?: VAPFontWeight
  textAlign?: VAPTextAlign

  constructor(tag: string) {
    this.tag = tag
  }
}

export class VideoInfoBean implements VideoInfo {
  srcInfos: SrcInfo[] = [];
  width: number = 0;
  height: number = 0;
  totalFrames: number = 0;
  fps: number = 0;
}
;

export class VideoSize {
  width?: number = undefined;
  height?: number = undefined;
}
;

@Component
export struct VAPComponent {
  private vapContext: XComponentContext | null = null;
  public loops: number = 1;
  private jsCbfn?: () => void;
  private uri = ''
  private mixData: Array<MixData> = new Array
  private fitType: FitType = FitType.FIT_XY
  private videoSize: VideoInfoBean = new VideoInfoBean
  public sandDir = '' // 使用网络资源需要设置该属性
  public mCmpController: VAPComponentController | null = null;
  @State isRunning: boolean = false;
  @State containerWidth: number = 0;
  @State containerHeight: number = 0
  @State vapPosition: MaPosition = new MaPosition
  private downloadTimeout: number = 60000; // ms
  private downloadCallback: (data: DownloadData) => void = (data: DownloadData) => {};

  private isStopping: boolean = false;
  private stopCompleteCallback?: () => void;
  private stopAsyncResolve?: () => void;
  private stopAsyncReject?: (error: Error) => void;

  aboutToDisappear() {
    LogUtil.info('[lifeCycle] VAPComponent aboutToDisappear')
  }

  setFitType(fitType: FitType) {
    LogUtil.info(' setFitType ' + this.fitType + '  ' + fitType)
    if (fitType != this.fitType) {
      this.fitType = fitType
      this.vapContext?.setFitType(fitType);
    }
  }

  aboutToAppear() {
    LogUtil.info('[lifeCycle] VAPComponent aboutToAppear')
    if (this.mCmpController) {
      this.mCmpController.attach(this); // 绑定控制器
    }

    this.vapContext?.on('stateChange', (state?: string | VapState) => {
      if (state === VapState.COMPLETE && this.isStopping) {
        const shouldProcess = this.isStopping;

        if (shouldProcess) {
          this.isRunning = false;
          this.isStopping = false;
          this.loops = 1;

          if (this.stopCompleteCallback) {
            this.stopCompleteCallback();
            this.stopCompleteCallback = undefined;
          }

          if (this.stopAsyncResolve) {
            this.stopAsyncResolve();
            this.stopAsyncResolve = undefined;
            this.stopAsyncReject = undefined;
          }
        }
      }
    });
  }

  setDownloadAttribute(dTime: number, downloadProgress?: (data: DownloadData) => void) {
    this.downloadTimeout = dTime;
    if (downloadProgress) {
      this.downloadCallback = downloadProgress;
    }
  }

  async play(uri: string, mixData?: Array<MixData>, cbFn?: () => void) {
    if (this.isRunning || this.isStopping) {
      return;
    }
    this.isRunning = true;
    this.isStopping = false;

    this.uri = await downloadFile(uri, this.downloadTimeout ,this.sandDir, this.downloadCallback)
    if (mixData) {
      for (let element of mixData) {
        if (element.imgUri && (typeof element.imgUri === "string")) {
          element.imgUri = await downloadFile(element.imgUri, this.downloadTimeout, this.sandDir, this.downloadCallback)
        }
        this.mixData.push(element)
      }
    }

    this.jsCbfn = cbFn
    this.vapContext?.play(this.uri, this.mixData, this.doneFn);
  }

  doneFn = () => {
    LogUtil.log('enter doneFn loops ' + this.loops)
    this.isRunning = false;
    this.loops--;
    if (this.loops > 0) {
      this.isRunning = true;
      this.vapContext?.play(this.uri, this.mixData, this.doneFn);
      LogUtil.log('loops ' + this.loops)
    } else {
      this.loops = 1
      this.jsCbfn ? this.jsCbfn() : ''
    }
  }

  pause() {
    if (!this.isRunning) {
      return
    }
    this.vapContext?.pause();
  }

  getVideoInfo(uri: string) {
    return this.vapContext?.getVideoInfo(uri);
  }

  async stopAsync(callback?: () => void, timeoutMs: number = 3000): Promise<void> {
    if (this.isStopping) {
      return;
    }

    if (!this.isRunning) {
      return;
    }

    this.isStopping = true;

    if (callback) {
      this.stopCompleteCallback = callback;
    }

    const TIMEOUT_MS = Math.max(100, Math.min(6000, timeoutMs));

    return new Promise<void>((resolve, reject) => {
      const timeoutId = setTimeout(() => {

        this.stopAsyncResolve = undefined;
        this.stopAsyncReject = undefined;

        try {
          this.vapContext?.stop();
          this.isRunning = false;
          this.isStopping = false;
          this.loops = 1;

          if (this.stopCompleteCallback) {
            this.stopCompleteCallback();
            this.stopCompleteCallback = undefined;
          }

          reject(new Error("stopAsync timeout after " + TIMEOUT_MS + "ms"));
        } catch (error) {
          this.isStopping = false;
          reject(new Error("stopAsync timeout and force sync stop failed: " + error));
        }
      }, TIMEOUT_MS);

      try {
        this.stopAsyncResolve = resolve;
        this.stopAsyncReject = reject;

        this.vapContext?.stopAsync();

      } catch (error) {
        clearTimeout(timeoutId);

        this.stopAsyncResolve = undefined;
        this.stopAsyncReject = undefined;

        this.isStopping = false;
        reject(error);
      }
    });
  }

  stop() {
    if (!this.isRunning) {
      return
    }
    this.vapContext?.stop();
    this.loops = 1;
    this.isRunning = false;
  }

  setLoop(loops: number): void {
    this.loops = loops
  }

  on(type: string, callback: (state?: number | string, ret?: number | AnimConfig) => void) {
    this.vapContext?.on(type, callback);
  }

  private fitXy() {
    this.vapPosition.width = this.containerWidth
    this.vapPosition.height = this.containerHeight
    this.vapPosition.top = 0
    this.vapPosition.left = 0
  }

  private changeArea() {
    this.fitXy()
    LogUtil.log("vapPosition " + JSON.stringify(this.vapPosition))
  }

  build() {
    Stack() {
      XComponent({
        id: 'XComponentId_' + util.generateRandomUUID(),
        type: 'surface',
        libraryname: 'vap'
      })
        .onLoad((context?: object) => {
          if (context) {
            this.vapContext = context as XComponentContext;
          }
        })
        .backgroundColor(Color.Transparent)
        .width(this.vapPosition.width)
        .height(this.vapPosition.height)
        .visibility(this.isRunning ? Visibility.Visible : Visibility.Hidden)
        .onAreaChange((old, new1) => {
          LogUtil.info('XComponent onAreaChange newWidth ' + old.width + ' newHeight ' + old.height +
            ' width ' + new1.width + ' height ' + new1.height)
        })
    }
    .height('100%')
    .width('100%')
    .onAreaChange((old, new1) => {
      LogUtil.info('onAreaChange newWidth ' + old.width + ' newHeight ' + old.height +
        ' width ' + new1.width + ' height ' + new1.height)
      this.containerWidth = new1.width as number
      this.containerHeight = new1.height as number
      if (this.videoSize) {
        this.changeArea()
      }
    })
  }
}

export class VAPComponentController {
  private mComponent: VAPComponent | null = null;

  attach(component: VAPComponent) {
    this.mComponent = component;
  }

  play(uri: string, mixData?: Array<MixData>, cbFn?: () => void): void {
    if (this.mComponent) {
      this.mComponent.play(uri, mixData, cbFn);
    }
  }

  pause(): void {
    if (this.mComponent) {
      return this.mComponent.pause();
    }
  }

  async stopAsync(timeoutMs: number = 3000, _id?: string): Promise<void> {
    if (this.mComponent) {
      return await this.mComponent.stopAsync(undefined, timeoutMs);
    } else {
    }
  }

  stop(): void {
    if (this.mComponent) {
      return this.mComponent.stop();
    }
  }

  setFitType(fitType: FitType): void {
    if (this.mComponent) {
      return this.mComponent.setFitType(fitType);
    }
  }

  getVideoInfo(uri: string): VideoInfo | undefined {
    if (this.mComponent) {
      return this.mComponent.getVideoInfo(uri);
    }
    return undefined
  }
}
