/*
 * Copyright (C) 2025 Huawei Device Co., Ltd.
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

import { Decoder } from './EvaDecoder'
import { EvaAnimPlayer } from '../EvaAnimPlayer'
import { IEvaFileContainer } from '../file/IEvaFileContainer'
import { EvaConstant } from '../util/EvaConstant'
import { ELog } from '../util/ELog'
import { EvaUtil } from '../EvaUtil'
import { emitter } from '@kit.BasicServicesKit'
import {MediaConstant} from '../util/MediaConstant'
import { fileUri } from '@kit.CoreFileKit'
import { collections } from '@kit.ArkTS'

interface LastFrameInterface {
  lastFrame?: boolean;
}

export class EvaHardDecoder extends Decoder {
  public static readonly TAG: string = `${EvaConstant.TAG}.HardDecoder`;

  constructor(playerEva: EvaAnimPlayer) {
    super(playerEva);
  }

  prepareToPlay(evaFileContainer: IEvaFileContainer): void {
    ELog.i(EvaHardDecoder.TAG, 'prepareToPlay');
  }

  play(): void {
    ELog.i(EvaHardDecoder.TAG, 'play');
  }

  start(evaFileContainer: IEvaFileContainer): void {
    ELog.i(EvaHardDecoder.TAG, 'start');
  }

  onFrameAvailable() {
  }

  renderData() {
    ELog.i(EvaHardDecoder.TAG, `renderData `);
  }

  async startPlay(evaFileContainer: IEvaFileContainer) {
    ELog.i(EvaHardDecoder.TAG, `startPlay`);
  }

  decodeEnd(status: number): void {
  }

  async startDecode(): Promise<void> {
    ELog.i(EvaHardDecoder.TAG, `startDecode`);
  }

  release() {
    ELog.i(EvaHardDecoder.TAG, `release `);
  }

  notReleaseLastFrame() {
    ELog.i(EvaHardDecoder.TAG, `notReleaseLastFrame`);
  }

  checkIsHevc(): Boolean {
    return true;
  }

  restart(): void {
    ELog.i(EvaHardDecoder.TAG, 'restart');
  }

  pause(): void {
    ELog.i(EvaHardDecoder.TAG, 'pause');
  }

  resume(): void {
    ELog.i(EvaHardDecoder.TAG, `resume`);
  }

  stop(completeBlock?: ((lastFrame: boolean) => void) | null): void {
    ELog.i(Decoder.TAG, `stop`);
  }

  setSpeed(speed: number): void {
    ELog.i(EvaHardDecoder.TAG, 'setSpeed');
  }

  setMute(flag: boolean): void {
    ELog.i(EvaHardDecoder.TAG, 'setMute');
  }

  destroy(): void {
    ELog.i(EvaHardDecoder.TAG, 'destroy');
  }

  private destroyInner(): void {
    ELog.i(EvaHardDecoder.TAG, 'destroyInner');
  }

  private releaseLastFrame(): void {
    ELog.i(EvaHardDecoder.TAG, `releaseLastFrame `);
  }
}
