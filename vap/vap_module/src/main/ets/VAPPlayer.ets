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
import { AnimConfig, FitType, MixData,
  VAPSpeed,
  VapState, VideoInfo, VideoMode, XComponentContext, DownloadData } from './DataDeclare';

import { downloadFile } from './HttpReq';
import { image } from '@kit.ImageKit';

export class VAPPlayer implements XComponentContext {
  private vapContext: XComponentContext | null = null;
  private loops: number = 1;
  private jsCbfn?: () => void;
  private uri = ''
  private mixData: Array<MixData> = []
  public sandDir = ''
  private id: string = ''
  private downloadTimeout: number = 60000; // ms
  private downloadCallback: (data: DownloadData) => void = (data: DownloadData) => {};
  private isRunning: boolean = false;
  private isStopping: boolean = false;
  private stopCompleteCallback?: () => void;
  private stopAsyncResolve?: () => void;
  private stopAsyncReject?: (error: Error) => void;
  private stopAsyncTimeoutId?: number;

  constructor(id: string) {
    this.id = id
  }

  setContext(context: object): void {
    this.vapContext = context as XComponentContext;
    this.setupStateChangeListener()
  }

  private setupStateChangeListener(): void {
    this.vapContext?.on('stateChange', (state?: string | VapState) => {
      if (state === VapState.COMPLETE && this.isStopping) {
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
        this.cleanupTimeout()
      }
    }, this.id);
  }

  getVideoInfo(uri: string): VideoInfo | undefined {
    if (this.vapContext) {
      return this.vapContext.getVideoInfo(uri, this.id);
    }
    return undefined
  }

  async getVideoInfoAsync(uri: string): Promise<VideoInfo | undefined> {
    if (!this.vapContext) {
      return;
    }
    uri = await downloadFile(uri, this.downloadTimeout, this.sandDir, this.downloadCallback)
    return this.vapContext.getVideoInfo(uri, this.id);
  }

  doneFn = () => {
    console.log('enter doneFn loops ' + this.loops)
    this.loops--;
    if (this.loops > 0) {
      this.vapContext?.play(this.uri, this.mixData, this.doneFn, this.id);
      console.log('loops ' + this.loops)
    } else {
      this.loops = 1
      this.jsCbfn ? this.jsCbfn() : ''
      this.isRunning = false;
    }
  }

  setDownloadAttribute(dTime: number, downloadProgress?: (data: DownloadData) => void) {
    this.downloadTimeout = dTime;
    if (downloadProgress) {
      this.downloadCallback = downloadProgress;
    }
  }

  async play(uri: string, mixData?: Array<MixData>, cbFn?: () => void): Promise<void> {
    if (this.isStopping) {
      console.warn("[VAPPlayer] Cannot play while stopping in progress");
      this.isStopping = false;
    }

    if (this.isRunning) {
      return;
    }

    this.isRunning = true;

    if (mixData) {
      this.mixData = []
      for (let element of mixData) {
        if (typeof element.imgUri === 'string') {
          element.imgUri = await downloadFile(element.imgUri, this.downloadTimeout, this.sandDir, this.downloadCallback)
        }
        this.mixData.push(element)
      }
    }
    this.uri = await downloadFile(uri, this.downloadTimeout, this.sandDir, this.downloadCallback)

    this.jsCbfn = cbFn
    console.log('mPlayOption ' + JSON.stringify(this.mixData))
    this.vapContext?.play(this.uri, this.mixData, this.doneFn, this.id);
  }

  on(type: string, callback: (state?: VapState | string, ret?: number | AnimConfig | undefined) => void) {
    this.vapContext?.on(type, callback, this.id);
  }

  off(type: string) {
    this.vapContext?.off(type, this.id)
  }

  pause(): void {
    this.vapContext?.pause(this.id);
  }

  async stopAsync(id?: string, timeoutMs: number = 3000): Promise<void> {
    if (this.isStopping) {
      return;
    }

    if (!this.isRunning) {
      return;
    }
    this.isStopping = true;

    const TIMEOUT_MS = Math.max(100, Math.min(6000, timeoutMs));
    const targetId = id || this.id;

    return new Promise<void>((resolve, reject) => {
      this.stopAsyncTimeoutId = setTimeout(() => {
        if (!this.isStopping) {
          return;
        }
        console.error("[VAPPlayer] stopAsync timeout after " + TIMEOUT_MS + "ms, forcing sync stop");
        this.stopAsyncResolve = undefined;
        this.stopAsyncReject = undefined;
        try {
          this.vapContext?.stop(targetId);
          this.cleanupSyncStop();
          reject(new Error("stopAsync timeout after " + TIMEOUT_MS + "ms"));
        } catch (error) {
          this.isStopping = false;
          console.error("[VAPPlayer] Force sync stop failed:", error);
          reject(new Error("stopAsync timeout and force sync stop failed: " + error));
        }
      }, TIMEOUT_MS);

      try {
        if (this.vapContext && this.vapContext.stopAsync) {
          try {
            this.stopAsyncResolve = resolve;
            this.stopAsyncReject = reject;

            this.vapContext.stopAsync(targetId);

          } catch (nativeError) {
            this.cleanupTimeout();
            this.vapContext?.stop(targetId);
            this.cleanupSyncStop();
            resolve();
          }
        } else {
          this.cleanupTimeout();
          this.vapContext?.stop(targetId);
          this.cleanupSyncStop();
          resolve();
        }
      } catch (error) {
        this.cleanupTimeout();
        this.isStopping = false;
        console.error("[VAPPlayer] stopAsync error:", error);
        reject(error);
      }
    });
  }

  private cleanupSyncStop(): void {
    this.isRunning = false;
    this.isStopping = false;
    this.loops = 1;

    if (this.stopCompleteCallback) {
      this.stopCompleteCallback();
      this.stopCompleteCallback = undefined;
    }
  }

  private cleanupTimeout(): void {
    if (this.stopAsyncTimeoutId) {
      clearTimeout(this.stopAsyncTimeoutId);
      this.stopAsyncTimeoutId = undefined;
    }
  }

  stop(): void {
    if (!this.isRunning) {
      return;
    }

    this.vapContext?.stop(this.id);
    this.loops = 1;
    this.isRunning = false;
  }

  setStopCompleteCallback(callback: () => void): void {
    this.stopCompleteCallback = callback;
  }

  setLoop(loops: number): void {
    this.loops = loops
  }

  setFitType(fitType: FitType): void {
    this.vapContext?.setFitType(fitType, this.id);
  }

  setVideoMode(videoMode: VideoMode): void {
    this.vapContext?.setVideoMode(videoMode, this.id);
  }

  setSpeed(speed: VAPSpeed): void {
    this.vapContext?.setSpeed(speed, this.id);
  }
}