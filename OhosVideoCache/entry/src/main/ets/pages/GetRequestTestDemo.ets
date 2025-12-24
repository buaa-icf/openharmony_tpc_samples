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

import router from '@ohos.router';
import buffer from '@ohos.buffer';
import GetRequest from '@ohos/video-cache/src/main/ets/GetRequest';

@Entry
@Component
@Preview
struct GetRequestTestDemo {
  @State testResults: string = '';
  @State isRunning: boolean = false;
  @State testCount: number = 0;
  @State passCount: number = 0;
  @State failCount: number = 0;

  aboutToAppear() {
    this.testResults = '点击"运行测试"按钮开始测试\n';
  }

  private runAllTests() {
    this.isRunning = true;
    this.testResults = '开始运行测试...\n\n';
    this.testCount = 0;
    this.passCount = 0;
    this.failCount = 0;

    // 延迟执行，确保UI更新
    setTimeout(() => {
      this.testParseGETRequest();
      this.testParseHEADRequest();
      this.testParseGETRequestWithoutRange();
      this.testParseHEADRequestWithoutRange();
      this.testParseGETRequestWithComplexUrl();
      this.testParseHEADRequestWithComplexUrl();
      this.testParseGETRequestWithRangeHeaderCaseInsensitive();
      this.testParseHEADRequestWithRangeHeaderCaseInsensitive();
      this.testParseGETRequestWithZeroRange();
      this.testParseHEADRequestWithZeroRange();
      this.testInvalidRequest();
      this.testMalformedRequest();

      this.testResults += `\n测试完成！总计: ${this.testCount}, 通过: ${this.passCount}, 失败: ${this.failCount}\n`;
      this.isRunning = false;
    }, 100);
  }

  private addTestResult(testName: string, passed: boolean, details: string = '') {
    this.testCount++;
    if (passed) {
      this.passCount++;
      this.testResults += `✓ ${testName}: 通过\n`;
    } else {
      this.failCount++;
      this.testResults += `✗ ${testName}: 失败 ${details}\n`;
    }
  }

  private testParseGETRequest() {
    try {
      let requestStr = 'GET /test%20url HTTP/1.1\r\nHost: localhost\r\nRange: bytes=1024-\r\n\r\n';
      let requestBuffer = buffer.from(requestStr, 'utf-8').buffer;
      let request = GetRequest.read(requestBuffer);

      let passed = request.method === 'GET' &&
        request.uri === 'test%20url' &&
        request.rangeOffset === 1024 &&
        request.partial === true;

      this.addTestResult('解析GET请求(带Range)', passed,
        passed ? '' : `期望: method=GET, uri=test%20url, rangeOffset=1024, partial=true, 实际: method=${request.method}, uri=${request.uri}, rangeOffset=${request.rangeOffset}, partial=${request.partial}`);
    } catch (err) {
      this.addTestResult('解析GET请求(带Range)', false, `异常: ${err.message}`);
    }
  }

  private testParseHEADRequest() {
    try {
      let requestStr = 'HEAD /test%20url HTTP/1.1\r\nHost: localhost\r\nRange: bytes=2048-\r\n\r\n';
      let requestBuffer = buffer.from(requestStr, 'utf-8').buffer;
      let request = GetRequest.read(requestBuffer);

      let passed = request.method === 'HEAD' &&
        request.uri === 'test%20url' &&
        request.rangeOffset === 2048 &&
        request.partial === true;

      this.addTestResult('解析HEAD请求(带Range)', passed,
        passed ? '' : `期望: method=HEAD, uri=test%20url, rangeOffset=2048, partial=true, 实际: method=${request.method}, uri=${request.uri}, rangeOffset=${request.rangeOffset}, partial=${request.partial}`);
    } catch (err) {
      this.addTestResult('解析HEAD请求(带Range)', false, `异常: ${err.message}`);
    }
  }

  private testParseGETRequestWithoutRange() {
    try {
      let requestStr = 'GET /test%20url HTTP/1.1\r\nHost: localhost\r\n\r\n';
      let requestBuffer = buffer.from(requestStr, 'utf-8').buffer;
      let request = GetRequest.read(requestBuffer);

      let passed = request.method === 'GET' &&
        request.uri === 'test%20url' &&
        request.rangeOffset === 0 &&
        request.partial === false;

      this.addTestResult('解析GET请求(无Range)', passed,
        passed ? '' : `期望: method=GET, uri=test%20url, rangeOffset=0, partial=false, 实际: method=${request.method}, uri=${request.uri}, rangeOffset=${request.rangeOffset}, partial=${request.partial}`);
    } catch (err) {
      this.addTestResult('解析GET请求(无Range)', false, `异常: ${err.message}`);
    }
  }

  private testParseHEADRequestWithoutRange() {
    try {
      let requestStr = 'HEAD /test%20url HTTP/1.1\r\nHost: localhost\r\n\r\n';
      let requestBuffer = buffer.from(requestStr, 'utf-8').buffer;
      let request = GetRequest.read(requestBuffer);

      let passed = request.method === 'HEAD' &&
        request.uri === 'test%20url' &&
        request.rangeOffset === 0 &&
        request.partial === false;

      this.addTestResult('解析HEAD请求(无Range)', passed,
        passed ? '' : `期望: method=HEAD, uri=test%20url, rangeOffset=0, partial=false, 实际: method=${request.method}, uri=${request.uri}, rangeOffset=${request.rangeOffset}, partial=${request.partial}`);
    } catch (err) {
      this.addTestResult('解析HEAD请求(无Range)', false, `异常: ${err.message}`);
    }
  }

  private testParseGETRequestWithComplexUrl() {
    try {
      let encodedUrl = 'http://127.0.0.1:8080/video.mp4';
      let requestStr = `GET /${encodedUrl} HTTP/1.1\r\nHost: 127.0.0.1\r\nRange: bytes=512-\r\n\r\n`;
      let requestBuffer = buffer.from(requestStr, 'utf-8').buffer;
      let request = GetRequest.read(requestBuffer);

      let passed = request.method === 'GET' &&
        request.uri === encodedUrl &&
        request.rangeOffset === 512 &&
        request.partial === true;

      this.addTestResult('解析GET请求(复杂URL)', passed,
        passed ? '' : `期望: method=GET, uri=${encodedUrl}, rangeOffset=512, partial=true, 实际: method=${request.method}, uri=${request.uri}, rangeOffset=${request.rangeOffset}, partial=${request.partial}`);
    } catch (err) {
      this.addTestResult('解析GET请求(复杂URL)', false, `异常: ${err.message}`);
    }
  }

  private testParseHEADRequestWithComplexUrl() {
    try {
      let encodedUrl = 'http://127.0.0.1:8080/video.mp4';
      let requestStr = `HEAD /${encodedUrl} HTTP/1.1\r\nHost: 127.0.0.1\r\nRange: bytes=1024-\r\n\r\n`;
      let requestBuffer = buffer.from(requestStr, 'utf-8').buffer;
      let request = GetRequest.read(requestBuffer);

      let passed = request.method === 'HEAD' &&
        request.uri === encodedUrl &&
        request.rangeOffset === 1024 &&
        request.partial === true;

      this.addTestResult('解析HEAD请求(复杂URL)', passed,
        passed ? '' : `期望: method=HEAD, uri=${encodedUrl}, rangeOffset=1024, partial=true, 实际: method=${request.method}, uri=${request.uri}, rangeOffset=${request.rangeOffset}, partial=${request.partial}`);
    } catch (err) {
      this.addTestResult('解析HEAD请求(复杂URL)', false, `异常: ${err.message}`);
    }
  }

  private testParseGETRequestWithRangeHeaderCaseInsensitive() {
    try {
      let requestStr = 'GET /test%20url HTTP/1.1\r\nHost: localhost\r\nrange: bytes=256-\r\n\r\n';
      let requestBuffer = buffer.from(requestStr, 'utf-8').buffer;
      let request = GetRequest.read(requestBuffer);

      let passed = request.method === 'GET' &&
        request.uri === 'test%20url' &&
        request.rangeOffset === 256 &&
        request.partial === true;

      this.addTestResult('解析GET请求(Range大小写不敏感)', passed,
        passed ? '' : `期望: method=GET, uri=test%20url, rangeOffset=256, partial=true, 实际: method=${request.method}, uri=${request.uri}, rangeOffset=${request.rangeOffset}, partial=${request.partial}`);
    } catch (err) {
      this.addTestResult('解析GET请求(Range大小写不敏感)', false, `异常: ${err.message}`);
    }
  }

  private testParseHEADRequestWithRangeHeaderCaseInsensitive() {
    try {
      let requestStr = 'HEAD /test%20url HTTP/1.1\r\nHost: localhost\r\nRANGE: bytes=512-\r\n\r\n';
      let requestBuffer = buffer.from(requestStr, 'utf-8').buffer;
      let request = GetRequest.read(requestBuffer);

      let passed = request.method === 'HEAD' &&
        request.uri === 'test%20url' &&
        request.rangeOffset === 512 &&
        request.partial === true;

      this.addTestResult('解析HEAD请求(Range大小写不敏感)', passed,
        passed ? '' : `期望: method=HEAD, uri=test%20url, rangeOffset=512, partial=true, 实际: method=${request.method}, uri=${request.uri}, rangeOffset=${request.rangeOffset}, partial=${request.partial}`);
    } catch (err) {
      this.addTestResult('解析HEAD请求(Range大小写不敏感)', false, `异常: ${err.message}`);
    }
  }

  private testParseGETRequestWithZeroRange() {
    try {
      let requestStr = 'GET /test%20url HTTP/1.1\r\nHost: localhost\r\nRange: bytes=0-\r\n\r\n';
      let requestBuffer = buffer.from(requestStr, 'utf-8').buffer;
      let request = GetRequest.read(requestBuffer);

      let passed = request.method === 'GET' &&
        request.uri === 'test%20url' &&
        request.rangeOffset === 0 &&
        request.partial === true;

      this.addTestResult('解析GET请求(Range=0)', passed,
        passed ? '' : `期望: method=GET, uri=test%20url, rangeOffset=0, partial=true, 实际: method=${request.method}, uri=${request.uri}, rangeOffset=${request.rangeOffset}, partial=${request.partial}`);
    } catch (err) {
      this.addTestResult('解析GET请求(Range=0)', false, `异常: ${err.message}`);
    }
  }

  private testParseHEADRequestWithZeroRange() {
    try {
      let requestStr = 'HEAD /test%20url HTTP/1.1\r\nHost: localhost\r\nRange: bytes=0-\r\n\r\n';
      let requestBuffer = buffer.from(requestStr, 'utf-8').buffer;
      let request = GetRequest.read(requestBuffer);

      let passed = request.method === 'HEAD' &&
        request.uri === 'test%20url' &&
        request.rangeOffset === 0 &&
        request.partial === true;

      this.addTestResult('解析HEAD请求(Range=0)', passed,
        passed ? '' : `期望: method=HEAD, uri=test%20url, rangeOffset=0, partial=true, 实际: method=${request.method}, uri=${request.uri}, rangeOffset=${request.rangeOffset}, partial=${request.partial}`);
    } catch (err) {
      this.addTestResult('解析HEAD请求(Range=0)', false, `异常: ${err.message}`);
    }
  }

  private testInvalidRequest() {
    try {
      let requestStr = 'POST /test%20url HTTP/1.1\r\nHost: localhost\r\n\r\n';
      let requestBuffer = buffer.from(requestStr, 'utf-8').buffer;
      let request = GetRequest.read(requestBuffer);
      // POST 方法不被支持，应该返回空字符串
      let passed = request.method === '' || request.uri === '';
      this.addTestResult('无效请求(POST)应返回空method或uri', passed,
        passed ? '' : `期望: method或uri为空, 实际: method=${request.method}, uri=${request.uri}`);
    } catch (err) {
      this.addTestResult('无效请求(POST)应返回空method或uri', false, `异常: ${err.message}`);
    }
  }

  private testMalformedRequest() {
    try {
      let requestStr = 'INVALID REQUEST\r\n\r\n';
      let requestBuffer = buffer.from(requestStr, 'utf-8').buffer;
      let request = GetRequest.read(requestBuffer);
      // 格式错误的请求应该返回空字符串
      let passed = request.method === '' || request.uri === '';
      this.addTestResult('格式错误请求应返回空method或uri', passed,
        passed ? '' : `期望: method或uri为空, 实际: method=${request.method}, uri=${request.uri}`);
    } catch (err) {
      this.addTestResult('格式错误请求应返回空method或uri', false, `异常: ${err.message}`);
    }
  }

  private clearResults() {
    this.testResults = '测试结果已清空\n';
    this.testCount = 0;
    this.passCount = 0;
    this.failCount = 0;
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

        Text('GET/HEAD请求测试')
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
        // 统计信息卡片
        Row() {
          Column() {
            Text(`${this.testCount}`)
              .fontSize(24)
              .fontWeight(FontWeight.Bold)
              .fontColor('#333333')
            Text('总计')
              .fontSize(12)
              .fontColor('#666666')
              .margin({ top: 4 })
          }
          .layoutWeight(1)

          Column() {
            Text(`${this.passCount}`)
              .fontSize(24)
              .fontWeight(FontWeight.Bold)
              .fontColor('#00AA00')
            Text('通过')
              .fontSize(12)
              .fontColor('#666666')
              .margin({ top: 4 })
          }
          .layoutWeight(1)

          Column() {
            Text(`${this.failCount}`)
              .fontSize(24)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FF4444')
            Text('失败')
              .fontSize(12)
              .fontColor('#666666')
              .margin({ top: 4 })
          }
          .layoutWeight(1)
        }
        .width('100%')
        .height(80)
        .padding(16)
        .backgroundColor('#FFFFFF')
        .borderRadius(12)
        .margin({ bottom: 16 })

        // 测试结果区域
        Scroll() {
          Text(this.testResults)
            .fontSize(14)
            .fontColor('#333333')
            .fontFamily('monospace')
            .width('100%')
            .padding(12)
        }
        .layoutWeight(1)
        .width('100%')
        .backgroundColor('#FFFFFF')
        .borderRadius(12)
        .margin({ bottom: 16 })

        // 操作按钮
        Row() {
          Button('清空结果')
            .width('30%')
            .height(44)
            .fontSize(16)
            .backgroundColor('#F0F0F0')
            .fontColor('#333333')
            .enabled(!this.isRunning)
            .onClick(() => {
              this.clearResults();
            })

          Button('运行测试')
            .width('65%')
            .height(44)
            .fontSize(16)
            .backgroundColor('#007DFF')
            .fontColor('#FFFFFF')
            .enabled(!this.isRunning)
            .onClick(() => {
              this.runAllTests();
            })
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
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

