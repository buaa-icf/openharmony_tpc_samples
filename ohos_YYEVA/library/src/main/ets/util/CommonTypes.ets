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

/**
 * 通用类型定义
 * 用于替代 any 类型和对象字面量
 */

/**
 * 上下文接口
 */
export interface Context {
  // abilityInfo?: {
  //   bundleName?: string
  //   label?: string
  //   versionName?: string
  //   versionCode?: number
  //   installTime?: number
  //   updateTime?: number
  //   signature?: string
  //   permissions?: string[]
  // }
}

/**
 * 触摸事件接口
 */
export interface TouchEvent {
  x: number
  y: number
  action: number
  pointerId: number
  timestamp: number
}

/**
 * 文件接口
 */
export interface FileInfo {
  path: string
  size: number
  exists: boolean
}

/**
 * 资源接口
 */
export interface ResourceInfo {
  id: string
  type: string
  data: object | null
}

/**
 * 媒体格式接口
 */
export interface MediaFormat {
  mime: string
  width?: number
  height?: number
  sampleRate?: number
  channelCount?: number
  bitRate?: number
}

/**
 * 缓冲区信息接口
 */
export interface BufferInfo {
  offset: number
  size: number
  presentationTimeUs: number
  flags: number
}

/**
 * 线程接口
 */
export interface ThreadInfo {
  isAlive: boolean
  handler: object | null
}

/**
 * 表面纹理监听器接口
 */
export interface SurfaceTextureListener {
  onSurfaceTextureAvailable(surface: object, width: number, height: number): void
  onSurfaceTextureSizeChanged(surface: object, width: number, height: number): void
  onSurfaceTextureDestroyed(surface: object): boolean
  onSurfaceTextureUpdated(surface: object): void
}

/**
 * 日志接口
 */
export interface LogInterface {
  i(tag: string, msg: string): void
  e(tag: string, msg: string): void
  d(tag: string, msg: string): void
  w(tag: string, msg: string): void
}

/**
 * 缩放类型接口
 */
export interface ScaleTypeInterface {
  getLayoutParam(
    layoutWidth: number,
    layoutHeight: number,
    videoWidth: number,
    videoHeight: number,
    layoutParams: object
  ): object
  getRealSize(): Size
}

/**
 * 资源请求接口
 */
export interface ResourceRequest {
  setImage(resource: object, callback: (bitmap: object | null, fitType: string) => void): void
  setText(resource: object, callback: (result: object) => void): void
}

/**
 * 媒体录制器接口
 */
export interface MediaRecorderInterface {
  setInputSurface(surface: object): void
  setOutputFormat(format: number): void
  setAudioEncoder(encoder: number): void
  setVideoEncoder(encoder: number): void
  setVideoSize(width: number, height: number): void
  setOutputFile(path: string): void
  prepare(): void
  start(): void
  stop(): void
  release(): void
}

/**
 * 媒体提取器接口
 */
export interface MediaExtractorInterface {
  setDataSource(source: object): void
  setDataSource(fd: number, offset: number, length: number): void
  setDataSource(path: string): void
  readSampleData(buffer: Uint8Array, offset: number): number
  getSampleTime(): number
  advance(): boolean
  release(): void
  getTrackCount(): number
  getTrackFormat(index: number): MediaFormat
  selectTrack(index: number): void
  unselectTrack(index: number): void
}

/**
 * 音频轨道接口
 */
export interface AudioTrackInterface {
  play(): void
  stop(): void
  write(data: Uint8Array, offset: number, length: number): number
  release(): void
}

/**
 * 解码器接口
 */
export interface DecoderInterface {
  dequeueInputBuffer(timeoutUs: number): number
  getInputBuffer(index: number): Uint8Array | null
  queueInputBuffer(index: number, offset: number, size: number, presentationTimeUs: number, flags: number): void
  dequeueOutputBuffer(bufferInfo: BufferInfo, timeoutUs: number): number
  getOutputBuffer(index: number): Uint8Array | null
  releaseOutputBuffer(index: number, render: boolean): void
  stop(): void
  release(): void
}

/**
 * 媒体混合器接口
 */
export interface MediaMuxerInterface {
  addTrack(format: MediaFormat): number
  start(): void
  writeSampleData(trackIndex: number, byteBuf: Uint8Array, bufferInfo: BufferInfo): void
  stop(): void
  release(): void
}

/**
 * 随机访问文件接口
 */
export interface RandomAccessFileInterface {
  read(buffer: Uint8Array, offset: number, length: number): number
  skipBytes(n: number): void
  close(): void
}

/**
 * 资源流接口
 */
export interface AssetInputStreamInterface {
  read(buffer: Uint8Array, offset: number, length: number): number
  skip(n: number): number
  close(): void
}

/**
 * 资源文件描述符接口
 */
export interface AssetFileDescriptorInterface {
  fileDescriptor: number
  startOffset: number
  declaredLength: number
  close(): void
}
