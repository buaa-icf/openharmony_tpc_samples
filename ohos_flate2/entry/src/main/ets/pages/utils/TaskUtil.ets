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

import { fileIo as fs } from '@kit.CoreFileKit'
import { buffer } from '@kit.ArkTS';

// 添加 StringTestResult 接口定义
export interface StringTestResult {
  compressTime: number
  decompressTime: number
  compressionRatio: number
  originalSize: number
  compressedSize: number
}

// 添加接口定义
export interface TestResult {
  time: number
  ratio: number
}

export interface PerformanceResults {
  deflate: TestResult
  deflateRaw: TestResult
  gzip: TestResult
  inflateRaw: Time
  inflate: Time
  ungzip: Time
}

export interface Time {
  time: number
}

export interface DataSize {
  size: string
  name: string
}


export interface GzipTestResult {
  compressTime: number
  decompressTime: number
  compressionRatio: number
}

// 生成测试文件的任务

export function generateTestFileTask(filePath: string, buffer: ArrayBuffer) {
  if (fs.accessSync(filePath)) {
    fs.rmdirSync(filePath)
  }
  const writer = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE)
  fs.writeSync(writer.fd, buffer)
  fs.closeSync(writer)
}

// 从资源文件读取数据
export function readRawFileUint8Array(fileName: string): Uint8Array {
  let data: Uint8Array | undefined = undefined;
  try {
    // 获取资源管理器
    const resourceManager = getContext().resourceManager;

    // 检查文件是否存在
    const fileDescriptor = resourceManager.getRawFdSync(fileName);
    console.log("文件大小：", fileDescriptor.length);
    data = resourceManager.getRawFileContentSync(fileName);

  } catch (error) {
    console.error(`读取文件失败, error `);
  }
  return data!;
}

// 从资源文件读取数据
export function readRawFileString(fileName: string): string {
  try {
    // 获取资源管理器
    const resourceManager = getContext().resourceManager;

    // 检查文件是否存在
    const fileDescriptor = resourceManager.getRawFdSync(fileName);
    console.log("文件大小：", fileDescriptor.length);
    let data: Uint8Array = resourceManager.getRawFileContentSync(fileName);
    let result = buffer.from(data.buffer).toString();
    return result;
  } catch (error) {
    console.error(`读取文件失败, error.`);
    return '';
  }
}