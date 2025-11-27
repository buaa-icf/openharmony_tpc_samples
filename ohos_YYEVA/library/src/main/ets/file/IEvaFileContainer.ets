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

import { media } from '@kit.MediaKit';

/**
 * YYEVA 文件容器接口
 * 定义文件操作的基本功能
 */
export interface IEvaFileContainer {

  /**
   * 初始化资源文件
   * @returns
   */
  init(): Promise<boolean>

  /**
   * 获取资源文件信息
   */
  getAVFileDescriptor(): Promise<media.AVFileDescriptor | null>

  /**
   * 开始随机读取
   */
  startRandomRead(): Promise<void>

  /**
   * 读取数据
   */
  read(buffer: Uint8Array, offset: number, length: number): Promise<number>

  /**
   * 跳过位置
   */
  skip(position: number): void

  /**
   * 关闭随机读取
   */
  closeRandomRead(): void

  /**
   * 关闭文件
   */
  close(): void

  /**
   * 获取文件路径
   */
  getFile(): string | null

  /**
   * 获取文件MD5
   */
  getMd5(): Promise<string>

  /**
   * 设置EVA JSON配置
   */
  setEvaJson(json: string): void

  /**
   * 获取EVA JSON配置
   */
  getEvaJson(): Promise<string | null>

  /**
   * 设置EVA MP4类型
   */
  setEvaMp4Type(type: number): void

  /**
   * 获取EVA MP4类型
   */
  getEvaMp4Type(): Promise<number>
}