/*
 * Copyright (C) 2023 Huawei Device Co., Ltd.
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

import DiskUsage from './DiskUsage';
import { Files } from './Files';
import fs from '@ohos.file.fs';
import StorageUtils from '../StorageUtils';
import { LogUtil } from '../LogUtil';
import taskpool from '@ohos.taskpool';

// 定义文件大小计算结果接口
interface FileSizeResult {
  totalSize: number;
  totalCount: number;
  fileSizes: number[];
}

// 并发函数，用于在taskpool中执行文件删除操作
@Concurrent
function performFileCleanup(filesToDelete: string[]): void {
  try {
    for (let i = 0; i < filesToDelete.length; i++) {
      let currentFile: string = filesToDelete[i];
      try {
        if (fs.accessSync(currentFile)) {
          fs.unlinkSync(currentFile);
        }
      } catch (deleteError) {
        LogUtil.error(`performFileCleanup: Failed to delete ${currentFile}: ${deleteError}`);
      }
    }
  } catch (error) {
    LogUtil.error(`performFileCleanup error: ${error}`);
  }
}

// 并发函数，用于在taskpool中计算文件总大小
@Concurrent
function calculateTotalSize(files: string[]): FileSizeResult {
  let totalSize = 0;
  let totalCount = files.length;
  let fileSizes: number[] = [];

  try {
    for (let i = 0; i < files.length; i++) {
      let singleFile = files[i];
      try {
        if (fs.accessSync(singleFile)) {
          let fileSize = fs.statSync(singleFile).size;
          totalSize += fileSize;
          fileSizes.push(fileSize);
        } else {
          fileSizes.push(0);
        }
      } catch (statError) {
        LogUtil.error(`calculateTotalSize: 无法获取文件大小: ${singleFile}, error: ${statError}`);
        fileSizes.push(0);
      }
    }
  } catch (error) {
    LogUtil.error(`calculateTotalSize error: ${error}`);
  }

  let result: FileSizeResult = {
    totalSize: totalSize,
    totalCount: totalCount,
    fileSizes: fileSizes
  };
  return result;
}

export default class LruDiskUsage implements DiskUsage {

  touch(filePath: string): void {
    if (!filePath || !filePath.startsWith(StorageUtils.DEFAULT_DIR)) {
      return;
    }

    try {
      Files.setLastModifiedNow(filePath);
      let last = filePath.lastIndexOf("/");
      let directory: string = filePath.substring(0, last);
      let filesArray = Files.getLruListFilesArray(directory);

      // 使用taskpool异步计算文件总大小，避免阻塞主线程
      let task = new taskpool.Task(calculateTotalSize, filesArray);
      taskpool.execute(task).then((result: Object) => {
        let fileSizeResult = result as FileSizeResult;
        this.processLruLogic(filesArray, fileSizeResult.totalSize, fileSizeResult.totalCount, fileSizeResult.fileSizes);
      }).catch((error: Error) => {
        LogUtil.error(`LruDiskUsage.touch: 文件大小计算失败: ${error}`);
      });

    } catch (error) {
      LogUtil.error(`LruDiskUsage.touch error: ${error}`);
    }
  }

  // LRU逻辑
  private processLruLogic(files: string[], totalSize: number, totalCount: number, fileSizes: number[]): void {
    try {
      // 在主线程中实现LRU逻辑，决定哪些文件需要删除
      let filesToDelete: string[] = [];
      let currentTotalSize = totalSize;
      let currentTotalCount = totalCount;

      // 确保至少保留一个当前正在播放的文件，如果只有一个文件则不删除任何文件
      if (files.length > 1) {
        for (let i = 0; i < files.length; i++) {
          let currentFile: string = files[i];
          let accepted = this.accept(currentFile, currentTotalSize, currentTotalCount);

          if (!accepted) {
            // 检查删除后是否还有文件剩余，确保至少保留一个文件
            if (filesToDelete.length < files.length - 1) {
              filesToDelete.push(currentFile);
              // 更新统计信息（使用预计算的文件大小）
              let fileSize = fileSizes[i] || 0;
              currentTotalCount--;
              currentTotalSize -= fileSize;
            } else {
              LogUtil.info(`touch file, 已达到最大删除数量，保留文件: ${currentFile}`);
              break;
            }
          }
        }
      }

      // 如果有文件需要删除，使用taskpool异步执行删除操作
      if (filesToDelete.length > 0) {
        LogUtil.info(`LruDiskUsage.touch: 准备删除 ${filesToDelete.length} 个文件`);
        let task = new taskpool.Task(performFileCleanup, filesToDelete);
        taskpool.execute(task).then(() => {
          LogUtil.info(`LruDiskUsage.touch: 文件清理任务完成，删除了 ${filesToDelete.length} 个文件`);
        }).catch((error: Error) => {
          LogUtil.error(`LruDiskUsage.touch: 文件清理任务失败: ${error}`);
        });
      } else {
        LogUtil.info(`LruDiskUsage.touch: 无需删除文件`);
      }
    } catch (error) {
      LogUtil.error(`LruDiskUsage.processLruLogic error: ${error}`);
    }
  }

  protected accept(file: string, totalSize: number, totalCount: number): boolean {
    return false;
  }
}