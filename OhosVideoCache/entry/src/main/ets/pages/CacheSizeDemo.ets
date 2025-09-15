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

import router from '@ohos.router';
import { HttpProxyCacheServer, StorageUtils } from '@ohos/video-cache';
import Logger from '../Logger';

@Entry
@Component
@Preview
struct CacheSizeDemo {
  @State cacheSize: string = '计算中...';
  @State totalBytes: number = 0;
  @State fileCount: number = 0;
  @State isLoading: boolean = true;
  @State cacheDirectory: string = '';
  private proxyServer: HttpProxyCacheServer | null = null;

  aboutToAppear() {
    this.initProxyServer();
    this.calculateCacheSize();
  }

  private initProxyServer() {
    try {
      // 创建 HttpProxyCacheServer 实例
      let context = getContext(this) as Context;
      this.proxyServer = new HttpProxyCacheServer(context);
      this.cacheDirectory = StorageUtils.DEFAULT_DIR;
      Logger.info(`Cache directory: ${this.cacheDirectory}`);
    } catch (err) {
      Logger.error(`Error initializing proxy server: ${JSON.stringify(err)}`);
    }
  }

  private calculateCacheSize() {
    this.isLoading = true;
    this.cacheSize = '计算中...';
    
    try {
      if (this.proxyServer) {
        // 使用 HttpProxyCacheServer 获取缓存大小和文件数量
        this.totalBytes = this.proxyServer.getCacheSize();
        this.cacheSize = this.formatFileSize(this.totalBytes);
        
        this.isLoading = false;
        Logger.info(`Cache size calculated: ${this.cacheSize}, Files: ${this.fileCount}`);
      } else {
        this.cacheSize = '服务器未初始化';
        this.isLoading = false;
      }
    } catch (err) {
      Logger.error(`Error calculating cache size: ${JSON.stringify(err)}`);
      this.cacheSize = '计算失败';
      this.isLoading = false;
    }
  }


  private refreshCacheSize() {
    this.calculateCacheSize();
  }

  /**
   * 格式化文件大小
   * @param bytes 字节数
   * @returns 格式化的大小字符串
   */
  private formatFileSize(bytes: number): string {
    if (bytes === 0) return '0 B';
    
    const units = ['B', 'KB', 'MB', 'GB', 'TB'];
    const k = 1024;
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    
    return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + units[i];
  }

  build() {
    Column() {
      // 标题栏
      Row() {
        Image($r('app.media.ic_video_back'))
          .fillColor(Color.Black)
          .width(24)
          .height(24)
          .onClick(() => {
            router.back();
          })
        
        Text('视频缓存大小')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 16 })
        
        Blank()
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#F5F5F5')

      // 主要内容
      Column() {
        // 缓存大小显示卡片
        Column() {
          if (this.isLoading) {
            LoadingProgress()
              .width(40)
              .height(40)
              .color('#007DFF')
          } else {
            Text(this.cacheSize)
              .fontSize(32)
              .fontWeight(FontWeight.Bold)
              .fontColor('#007DFF')
          }
          
          Text('总缓存大小')
            .fontSize(16)
            .fontColor('#666666')
            .margin({ top: 8 })
        }
        .width('100%')
        .height(120)
        .justifyContent(FlexAlign.Center)
        .backgroundColor('#FFFFFF')
        .borderRadius(12)
        .margin({ bottom: 16 })

        // 详细信息卡片
        Column() {
          Row() {
            Text('缓存目录')
              .fontSize(14)
              .fontColor('#666666')
            Blank()
            Text(this.cacheDirectory)
              .fontSize(14)
              .fontColor('#333333')
              .maxLines(3)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .layoutWeight(1)
              .textAlign(TextAlign.End)
          }
          .margin({ bottom: 12 })

          Row() {
            Text('字节大小')
              .fontSize(14)
              .fontColor('#666666')
            Blank()
            Text(`${this.totalBytes.toLocaleString()} 字节`)
              .fontSize(14)
              .fontColor('#333333')
          }
          .width('100%')
        }
        .width('100%')
        .padding(16)
        .backgroundColor('#FFFFFF')
        .borderRadius(12)
        .margin({ bottom: 24 })
      }
      .width('100%')
      .padding(16)
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}
