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

import taskpool from '@ohos.taskpool';
import { DataSize, PerformanceResults, readRawFileUint8Array } from './utils/TaskUtil';
import { fflateTaskAll } from './utils/fflateTaskAll';

@Entry
@Component
struct Index {
  @State performanceResults: string = ''
  @State isTesting: boolean = false
  @State currentStatus: string = ''
  type: string = 'fflate'


  // 修改 runPerformanceTest 方法
  private async runPerformanceTest(data: Uint8Array, sss: Function) {
    const task = new taskpool.Task(sss, data)
    return await taskpool.execute(task)
  }

  // 执行所有大小的性能测试
  async performanceTest() {
    this.isTesting = true
    this.performanceResults = '开始性能测试...\n'

    const testFiles: DataSize[] = [
      { size: '1MB', name: '1MB.txt' },
      { size: '10MB', name: '10MB.txt' }
    ]

    try {
      let results: string[] = []
      for (const file of testFiles) {
        this.currentStatus = `正在读取 ${file.name} (${file.size})...`
        this.performanceResults = this.currentStatus + '\n'

        // 从资源文件读取数据
        const testData = readRawFileUint8Array(file.name);

        this.currentStatus = `正在测试 ${file.name} 数据...`
        this.performanceResults = this.currentStatus + '\n'
        const result = await this.runPerformanceTest(testData, fflateTaskAll);

        const resultString = `
${file.name} (${file.size}) 测试结果:
deflate:    ${(result as PerformanceResults).deflate.time}ms (压缩率: ${(result as PerformanceResults).deflate.ratio.toFixed(2)}%)
inflate:    ${(result as PerformanceResults).inflate.time}ms
gzip:       ${(result as PerformanceResults).gzip.time}ms (压缩率: ${(result as PerformanceResults).gzip.ratio.toFixed(2)}%)
ungzip:     ${(result as PerformanceResults).ungzip.time}ms
deflateRaw:     ${(result as PerformanceResults).deflateRaw.time}ms (压缩率: ${(result as PerformanceResults).deflateRaw.ratio.toFixed(2)}%)
inflateRaw:     ${(result as PerformanceResults).inflateRaw.time}ms`

        results.push(resultString)
      }

      this.currentStatus = '测试完成'
      this.performanceResults = results.join('\n')
    } catch (error) {
      this.currentStatus = '测试失败'
      this.performanceResults = `测试失败: ${error.message}`
    } finally {
      this.isTesting = false
    }
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start }) {
      Scroll() {
        Column({ space: 12 }) {
          // 添加性能测试按钮
          Button(`${this.type} 性能测试`, { type: ButtonType.Normal })
            .fontSize(18)
            .fontColor('#000')
            .height(60)
            .width(300)
            .margin({ top: 20 })
            .backgroundColor('#12939f')
            .enabled(!this.isTesting)
            .onClick(() => {
              this.performanceTest()
            })

          // 显示当前状态
          if (this.currentStatus) {
            Text(this.currentStatus)
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .margin({ top: 12 })
          }

          // 显示性能测试结果
          if (this.performanceResults) {
            Text(this.performanceResults)
              .fontSize(16)
              .margin({ top: 20, bottom: 20 })
              .padding(16)
              .backgroundColor('#f5f5f5')
              .width('90%')
          }
        }
      }
    }
  }
}