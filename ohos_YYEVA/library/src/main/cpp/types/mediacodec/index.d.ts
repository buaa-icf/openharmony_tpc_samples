/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { media } from '@kit.MediaKit'
import { image } from "@kit.ImageKit";
import { ThreadTask } from '../libyyeva_napi';

export interface CodeInfoAttr {
  pts: number,
  flags: number,
  frameIndex: number,
  image?: image.PixelMap
}

export class MediaFormat {
  constructor();
  getString(key: string): string;
  getInteger(key: string): number;
  getLong(key: string): number;
  getFloat(key: string): number;
  setInteger(key: string, value: number): void;
}

export class MediaCodec {
  constructor(mine: string);
  /**
   * 绑定extractor
   * @param extractor
   * @param callback
   */
  bind(extractor: MediaExtractor, callback: (status: number, codecInfo: CodeInfoAttr) => void): void;
  configure(colorFormat?: number, surface?: SurfaceTexture): void;
  start(): Promise<void>;
  restart(): Promise<void>;
  stop(): Promise<void>;
  flush(): void;
  resume(): Promise<void>;
  pause(): Promise<void>;
  release(): Promise<void>;
  getState(): number;
  setSpeed(speed: number): void;
  setVolume(volume: number): void;
  setMute(mute: boolean): void;
  releaseOutputBuffer(frameIndex: number): void;
}

export class MediaExtractor {
  constructor();
  setMediaSource(fdSrc: media.AVFileDescriptor): void;
  setMediaUrl(url: string): void;
  getTrackCount(): number;
  getTrackFormat(index: number): MediaFormat;
  // type: 'Audio' or 'Video'
  selectTrack(type: string, index: number): void;
  getTrackIndex(type: string): number;
  isSupportCodec(codec: string): boolean;
  seekTo(start: number, type: number): void;
  advance(): void;
  getSampleTime(): number;
  release(): void;
}

export class SurfaceTexture {
  constructor(surfaceId: number);
  updateTexImage(): void;
  setOnFrameAvailableListener(onFrameAvailable: () => void): void;
  setDefaultBufferSize(width: number, height: number): void;
  onAttachToWindow(): void;
  onDetachFromWindow(): void;
  attachThread(thread: ThreadTask): void;
  release(): void;
}