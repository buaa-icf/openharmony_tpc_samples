import { VAPPlayer, FitType, MixData } from '@ohos/vap'
import { LogUtil } from '../common/LogUtil'
import { util } from '@kit.ArkTS'

@Entry
@Component
struct AsyncStopDemo {
  private vapPlayer: VAPPlayer | undefined = undefined;
  @State stopStatus: string = 'Ready';
  @State stopStatusColor: Color = Color.Black;
  @State isPlaying: boolean = false;
  @State testResults: Map<string, string> = new Map();
  @State currentTest: string = '';
  @State testStartTime: number = 0;
  @State testDuration: number = 0;
  @State timeoutInput: string = '';
  private xComponentId: string = 'xcomponentId_' + util.generateRandomUUID();
  @State private lastOperationTime: number = 0;
  @State private isProcessing: boolean = false;
  @State private isStopping: boolean = false;

  recordTestResult(testName: string, result: string, duration?: number) {
    this.testResults.set(testName, result);
    this.currentTest = testName;
    if (duration !== undefined) {
      this.testDuration = duration;
    }
  }

  startTestTimer() {
    this.testStartTime = Date.now();
  }

  endTestTimer(): number {
    const duration = Date.now() - this.testStartTime;
    this.testDuration = duration;
    return duration;
  }

  getTestStatus(testName: string): string {
    const result = this.testResults.get(testName);
    if (!result) {
      return '未测试';
    }
    return result;
  }

  getTestResultColor(testName: string): Color {
    const result = this.testResults.get(testName);
    if (!result) {
      return Color.Gray;
    }
    if (result.includes('失败') || result.includes('错误') || result.includes('Error')) {
      return Color.Red;
    }
    if (result.includes('完成') || result.includes('成功')) {
      return Color.Green;
    }
    if (result.includes('中') || result.includes('进行')) {
      return Color.Blue;
    }
    return Color.Black;
  }

  startPlay() {
    const now = Date.now();
    if (now - this.lastOperationTime < 500 || this.isProcessing || this.isPlaying) {
      LogUtil.info("快速点击拦截：播放操作过于频繁或状态不允许");
      return;
    }
    this.lastOperationTime = now;
    this.isProcessing = true;

    try {
      this.stopStatus = 'Playing...';
      this.isPlaying = true;
      this.recordTestResult('基础播放', '播放中...');

      if (!this.vapPlayer) {
        this.stopStatus = 'VAP播放器未初始化';
        this.isPlaying = false;
        this.recordTestResult('基础播放', '失败: VAP播放器未初始化');
        LogUtil.error('VAP播放器未初始化');
        return;
      }

      const videoPath = getContext(this).filesDir + "/vapx.mp4";
      LogUtil.info(`尝试播放视频: ${videoPath}`);
      this.vapPlayer.setFitType(FitType.FIT_CENTER);
      let opts: Array<MixData> = new Array();

      this.vapPlayer.play(videoPath, opts, () => {
        this.stopStatus = '播放完成';
        this.isPlaying = false;
        this.recordTestResult('基础播放', '播放完成');
      });
      LogUtil.info('视频播放命令已发送');
      this.recordTestResult('基础播放', '播放命令已发送');
    } catch (error) {
      this.stopStatus = `播放失败: ${error}`;
      this.isPlaying = false;
      this.recordTestResult('基础播放', `失败: ${error}`);
      LogUtil.error(`播放错误: ${JSON.stringify(error)}`);
    } finally {
      this.isProcessing = false;
    }
  }

  build() {
    Column(){
      Stack() {
        XComponent({
          id: this.xComponentId,
          type: 'surface',
          libraryname: 'vap'
        })
          .onLoad((context?: object) => {
            if (context) {
              this.vapPlayer = new VAPPlayer(this.xComponentId);
              this.vapPlayer.setContext(context);
            }
          })
          .backgroundColor(Color.Transparent)
          .width('100%')
          .height('100%')
          .visibility(Visibility.Visible)
      }
      .backgroundImage($r('app.media.bg'))
      .backgroundImageSize(ImageSize.FILL)
      .height('30%')
      .width('100%')
      Scroll() {
        Column({ space: 15 }) {
          Text('异步停止功能全面测试Demo')
            .fontSize(24)
            .fontWeight(700)
            .fontColor(Color.Blue)

          Text(`播放器状态: ${this.stopStatus}`)
            .fontSize(16)
            .fontWeight(500)
            .fontColor(this.stopStatus.includes('Error') ? Color.Red : Color.Black)

          Text('测试结果')
            .fontSize(18)
            .fontWeight(600)
            .fontColor(Color.Blue)
            .margin({ top: 10 })

          Column({ space: 8 }) {
            Row() {
              Text('基础播放:')
                .fontSize(14)
                .fontWeight(500)
                .width('40%')
              Text(this.getTestStatus('基础播放'))
                .fontSize(14)
                .fontColor(this.getTestResultColor('基础播放'))
                .width('60%')
            }

            Row() {
              Text('同步停止:')
                .fontSize(14)
                .fontWeight(500)
                .width('40%')
              Text(this.getTestStatus('同步停止'))
                .fontSize(14)
                .fontColor(this.getTestResultColor('同步停止'))
                .width('60%')
            }

            Row() {
              Text('异步停止(Promise):')
                .fontSize(14)
                .fontWeight(500)
                .width('40%')
              Text(this.getTestStatus('异步停止(Promise)'))
                .fontSize(14)
                .fontColor(this.getTestResultColor('异步停止(Promise)'))
                .width('60%')
            }

            Row() {
              Text('异步停止(回调):')
                .fontSize(14)
                .fontWeight(500)
                .fontColor(this.stopStatusColor)
                .width('40%')
              Text(this.getTestStatus('异步停止(回调)'))
                .fontSize(14)
                .fontColor(this.getTestResultColor('异步停止(回调)'))
                .width('60%')
            }

            Row() {
              Text('并发停止测试:')
                .fontSize(14)
                .fontWeight(500)
                .width('40%')
              Text(this.getTestStatus('并发停止测试'))
                .fontSize(14)
                .fontColor(this.getTestResultColor('并发停止测试'))
                .width('60%')
            }

            Row() {
              Text('异步停止超时测试:')
                .fontSize(14)
                .fontWeight(500)
                .width('40%')
              Text(this.getTestStatus('异步停止超时测试'))
                .fontSize(14)
                .fontColor(this.getTestResultColor('异步停止超时测试'))
                .width('60%')
            }
          }
          .padding(10)
          .backgroundColor(Color.White)
          .borderRadius(8)
          .border({ width: 1, color: Color.Gray })
          .width('100%')

          Divider().strokeWidth(1).color(Color.Gray)

          Text('基础功能测试').fontSize(18).fontWeight(600)

          Row({ space: 10 }) {
            Button('开始播放')
              .width('40%')
              .onClick(() => {
                this.startPlay();
              })

            Button('同步停止')
              .width('40%')
              .onClick(() => {
                this.startTestTimer();
                if (!this.vapPlayer || !this.isPlaying) {
                  this.stopStatus = '播放器未运行，无法同步停止';
                  this.recordTestResult('同步停止', '失败: 播放器未运行');
                  return;
                }
                this.vapPlayer?.stop();
                this.stopStatus = 'Stopped (Sync)';
                this.isPlaying = false;
                const duration = this.endTestTimer();
                this.recordTestResult('同步停止', `同步停止完成 (${duration}ms)`, duration);
              })
          }

          Text('异步停止功能测试').fontSize(18).fontWeight(600)

          Row({ space: 10 }) {
            Button('异步停止(Promise)')
              .width('45%')
              .onClick(async () => {
                const now = Date.now();
                if (now - this.lastOperationTime < 500 || this.isProcessing || this.isStopping) {
                  LogUtil.info("快速点击拦截：异步停止(Promise)操作过于频繁或状态不允许");
                  return;
                }

                if (!this.vapPlayer || !this.isPlaying) {
                  this.stopStatus = '播放器未运行，无法异步停止';
                  this.recordTestResult('异步停止(Promise)', '失败: 播放器未运行');
                  return;
                }

                this.lastOperationTime = now;
                this.isProcessing = true;
                this.isStopping = true;

                try {
                  this.startTestTimer();
                  this.stopStatus = '异步停止中(Promise)...';
                  this.recordTestResult('异步停止(Promise)', '异步停止中...');

                  await this.vapPlayer?.stopAsync();

                  this.stopStatus = '异步停止完成(Promise)';
                  this.isPlaying = false;
                  const duration = this.endTestTimer();
                  this.recordTestResult('异步停止(Promise)', `异步停止完成 (${duration}ms) - 通过Promise`, duration);
                } catch (error) {
                  this.stopStatus = `异步停止错误: ${error}`;
                  this.isPlaying = false;
                  const duration = this.endTestTimer();
                  this.recordTestResult('异步停止(Promise)', `失败: ${error} (${duration}ms) - 点击过快运行超时`, duration);
                } finally {
                  this.isStopping = false;
                  this.isProcessing = false;
                }
              })

            Button('异步停止(回调)')
              .width('45%')
              .onClick(() => {
                const now = Date.now();
                if (now - this.lastOperationTime < 500 || this.isProcessing || this.isStopping) {
                  LogUtil.info("快速点击拦截：异步停止(回调)操作过于频繁或状态不允许");
                  return;
                }

                if (!this.vapPlayer || !this.isPlaying) {
                  this.stopStatus = '播放器未运行，无法异步停止';
                  this.recordTestResult('异步停止(回调)', '失败: 播放器未运行');
                  return;
                }

                this.lastOperationTime = now;
                this.isProcessing = true;
                this.isStopping = true;

                this.startTestTimer();
                this.stopStatus = '异步停止中(回调)...';
                this.recordTestResult('异步停止(回调)', '异步停止中...');

                this.vapPlayer?.setStopCompleteCallback(() => {
                  this.stopStatus = '异步停止完成(回调)';
                  this.isPlaying = false;
                  const duration = this.endTestTimer();
                  this.recordTestResult('异步停止(回调)', `异步停止完成 (${duration}ms) - 回调设置字体颜色`, duration);
                  this.stopStatusColor=Color.Orange
                  this.isStopping = false;
                  this.isProcessing = false;
                });

                this.vapPlayer?.stopAsync().catch((error:Error) => {
                  this.stopStatus = `异步停止错误: ${error}`;
                  this.isPlaying = false;
                  const duration = this.endTestTimer();
                  this.recordTestResult('异步停止(回调)', `失败: ${error} (${duration}ms) - 点击过快运行超时`, duration);
                  this.stopStatusColor=Color.Black
                  this.isStopping = false;
                  this.isProcessing = false;
                });
              })
          }

          Divider().strokeWidth(1).color(Color.Gray)

          Text('高级功能测试').fontSize(18).fontWeight(600)

          Row({ space: 10 }) {
            Button('并发停止测试')
              .width('45%')
              .onClick(async () => {
                this.startTestTimer();
                this.stopStatus = '并发停止测试中...';
                this.recordTestResult('并发停止测试', '测试中...');

                if (!this.vapPlayer || !this.isPlaying) {
                  this.stopStatus = '播放器未运行，无法并发停止';
                  this.recordTestResult('并发停止测试', '失败: 播放器未运行');
                  return;
                }

                try {
                  let completedCount = 0;
                  let errorCount = 0;
                  const totalCalls = 3;

                  const promises: Promise<void>[] = [];

                  for (let i = 0; i < totalCalls; i++) {
                    const promise = new Promise<void>((resolve, reject) => {
                      setTimeout(() => {
                        this.vapPlayer?.stopAsync()
                          .then(() => {
                            completedCount++;
                            console.log(`[并发测试] 第${i+1}次调用完成`);
                            resolve();
                          })
                          .catch((error: Error) => {
                            errorCount++;
                            console.log(`[并发测试] 第${i+1}次调用失败:`, error);
                            reject(error);
                          });
                      }, 10);
                    });
                    promises.push(promise);
                  }

                  await Promise.allSettled(promises);

                  const duration = this.endTestTimer();

                  if (errorCount === 0) {
                    this.stopStatus = `并发停止测试完成 (成功: ${completedCount}/${totalCalls})`;
                    this.isPlaying = false;
                    this.recordTestResult('并发停止测试', `并发测试成功 - 所有${totalCalls}次调用都成功 (${duration}ms)`, duration);

                    AlertDialog.show({
                      title: '并发停止测试完成',
                      message: `并发停止测试成功！\n耗时: ${duration}ms\n成功调用: ${completedCount}/${totalCalls}\n`,
                      primaryButton: {
                        value: '确定',
                        action: () => {
                          console.log('并发测试弹窗确认');
                        }
                      },
                      autoCancel: true
                    });
                  } else {
                    this.stopStatus = `并发停止测试部分失败 (成功: ${completedCount}/${totalCalls}, 失败: ${errorCount}/${totalCalls})`;
                    this.isPlaying = false;
                    this.recordTestResult('并发停止测试', `并发测试部分失败 - 成功: ${completedCount}, 失败: ${errorCount} (${duration}ms)`, duration);

                    AlertDialog.show({
                      title: '并发停止测试结果',
                      message: `并发停止测试完成！\n耗时: ${duration}ms\n成功调用: ${completedCount}/${totalCalls}\n失败调用: ${errorCount}/${totalCalls}\n`,
                      primaryButton: {
                        value: '确定',
                        action: () => {
                          console.log('并发测试弹窗确认');
                        }
                      },
                      autoCancel: true
                    });
                  }
                } catch (error) {
                  const duration = this.endTestTimer();
                  this.stopStatus = `并发停止测试错误: ${error}`;
                  this.recordTestResult('并发停止测试', `失败: ${error} (${duration}ms)`, duration);
                }
              })
          }

          Text('异步停止超时测试（可输入超时时间）').fontSize(16).fontWeight(500)

          Row({ space: 10 }) {
            TextInput({ placeholder: '输入超时时间(ms)', text: this.timeoutInput })
              .width('30%')
              .type(InputType.Number)
              .onChange((value: string) => {
                this.timeoutInput = value;
              })

            Button('测试')
              .width('20%')
              .onClick(async () => {
                this.startTestTimer();
                let timeoutMs: number = 3000;
                if (this.timeoutInput && this.timeoutInput.trim() !== '') {
                  const inputValue = parseInt(this.timeoutInput.trim());
                  if (!isNaN(inputValue) && inputValue > 0) {
                    timeoutMs = inputValue;
                  }
                }

                const actualTimeoutMs = Math.max(100, Math.min(6000, timeoutMs));
                this.stopStatus = `异步停止超时测试中... (设置: ${timeoutMs}ms, 实际: ${actualTimeoutMs}ms)`;
                this.recordTestResult('异步停止超时测试', `测试中... (设置: ${timeoutMs}ms, 实际: ${actualTimeoutMs}ms)`);

                try {
                  if (!this.vapPlayer || !this.isPlaying) {
                    this.stopStatus = '播放器未运行，无法异步停止';
                    this.recordTestResult('异步停止超时测试', '失败: 播放器未运行');
                    return;
                  }
                  await this.vapPlayer?.stopAsync(undefined, timeoutMs);
                  this.stopStatus = `异步停止完成（未超时） (设置: ${timeoutMs}ms, 实际: ${actualTimeoutMs}ms)`;
                  this.isPlaying = false;
                  const duration = this.endTestTimer();
                  this.recordTestResult('异步停止超时测试', `正常完成 (${duration}ms) - 设置: ${timeoutMs}ms, 实际: ${actualTimeoutMs}ms`, duration);
                } catch (error) {
                  const errorMessage = error instanceof Error ? error.message : String(error);
                  this.stopStatus = `异步停止超时测试错误: ${errorMessage} (设置: ${timeoutMs}ms, 实际: ${actualTimeoutMs}ms)`;
                  this.isPlaying = false;
                  const duration = this.endTestTimer();

                  const isTimeoutError = errorMessage.includes('timeout') ||
                  errorMessage.includes('超时') ||
                  errorMessage.includes('Timeout') ||
                  errorMessage.includes('timed out');

                  if (isTimeoutError) {
                    this.recordTestResult('异步停止超时测试', `超时测试成功 - ${errorMessage} (${duration}ms) - 设置: ${timeoutMs}ms, 实际: ${actualTimeoutMs}ms`, duration);
                  } else {
                    this.recordTestResult('异步停止超时测试', `其他错误: ${errorMessage} (${duration}ms) - 设置: ${timeoutMs}ms, 实际: ${actualTimeoutMs}ms`, duration);
                  }
                }
              })
          }
        }
        .padding(15)
        .width('100%')
      }
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Auto)
      .width('100%')
      .layoutWeight(1)
    }
  }
}
