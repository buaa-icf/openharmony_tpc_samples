import { VAPPlayer, FitType, MixData } from '@ohos/vap'
import { LogUtil } from '../common/LogUtil'
import { util } from '@kit.ArkTS'

interface VideoPlayer {
  id: string;
  vapPlayer: VAPPlayer | undefined;
  xComponentId: string;
  isPlaying: boolean;
  stopStatus: string;
  stopStatusColor: Color;
  testResult: string;
  lastOperationTime: number;
  isProcessing: boolean;
  isStopping: boolean;
}

@Entry
@Component
struct ParallelStopDemo {
  @State videoPlayers: VideoPlayer[] = [];
  @State overallStatus: string = 'Ready';
  @State overallStatusColor: Color = Color.Black;
  @State parallelCount: number = 6;
  @State isAllPlaying: boolean = false;
  @State isAllStopping: boolean = false;
  @State isPlayCompleted: boolean = true;

  aboutToAppear() {
    this.parallelCount = 10;
    this.initializePlayers();
  }

  aboutToDisappear(): void {
    LogUtil.info('页面即将消失，停止所有视频');
    this.videoPlayers.forEach((player, index) => {
      if (player.vapPlayer && player.isPlaying) {
        try {
          player.vapPlayer.stopAsync().then(() => {
            player.isPlaying = false;
            player.stopStatus = '已停止';
            player.testResult = '页面离开停止';
            LogUtil.info(`播放器${index + 1}已停止`);
          }).catch((error: Error) => {
            LogUtil.error(`播放器${index + 1}停止失败: ${error.message}`);
          });
        } catch (error) {
          LogUtil.error(`播放器${index + 1}停止异常: ${JSON.stringify(error)}`);
        }
      }
    });
    this.isAllPlaying = false;
  }

  initializePlayers() {
    this.videoPlayers = [];
    for (let i = 0; i < this.parallelCount; i++) {
      const player: VideoPlayer = {
        id: `player_${i + 1}`,
        vapPlayer: undefined,
        xComponentId: `xcomponent_${util.generateRandomUUID()}`,
        isPlaying: false,
        stopStatus: 'Ready',
        stopStatusColor: Color.Black,
        testResult: 'Not Tested',
        lastOperationTime: 0,
        isProcessing: false,
        isStopping: false
      };
      this.videoPlayers.push(player);
    }
    this.overallStatus = `${this.parallelCount} players initialized`;
  }

  startAllPlay() {
    const now = Date.now();
    if (now - this.videoPlayers[0]?.lastOperationTime < 500 || this.isAllPlaying) {
      LogUtil.info("Fast click blocked: play operation too frequent or status not allowed");
      return;
    }

    this.isAllPlaying = true;
    this.isPlayCompleted = false;
    this.overallStatus = 'Playing...';

    let completedCount = 0;
    let errorCount = 0;

    this.videoPlayers.forEach((player, index) => {
      player.lastOperationTime = now;
      player.isProcessing = true;

      try {
        player.stopStatus = '播放中...';
        player.isPlaying = true;
        player.testResult = '播放中...';

        if (!player.vapPlayer) {
          player.stopStatus = 'VAP播放器未初始化';
          player.isPlaying = false;
          player.testResult = '失败: VAP播放器未初始化';
          errorCount++;
          LogUtil.error(`播放器${index + 1}未初始化`);
          return;
        }

        const videoPath = getContext(this).filesDir + "/vapx.mp4";
        LogUtil.info(`播放器${index + 1}尝试播放视频: ${videoPath}`);
        player.vapPlayer.setFitType(FitType.FIT_CENTER);
        let opts: Array<MixData> = new Array();

        player.vapPlayer.play(videoPath, opts, () => {
          player.stopStatus = '播放完成';
          player.isPlaying = false;
          player.testResult = '播放完成';
          completedCount++;

          if (completedCount + errorCount === this.parallelCount) {
            this.isAllPlaying = false;
            this.isPlayCompleted = true;
            this.overallStatus = `并行播放完成 (成功: ${completedCount}/${this.parallelCount})`;
          }
        });

        LogUtil.info(`播放器${index + 1}视频播放命令已发送`);
        player.testResult = '播放命令已发送';
      } catch (error) {
        player.stopStatus = `播放失败: ${error}`;
        player.isPlaying = false;
        player.testResult = `失败: ${error}`;
        errorCount++;
        LogUtil.error(`播放器${index + 1}播放错误: ${JSON.stringify(error)}`);
      } finally {
        player.isProcessing = false;
      }
    });
  }

  async stopAllAsync() {
    const now = Date.now();
    if (now - this.videoPlayers[0]?.lastOperationTime < 500 || this.isAllStopping) {
      LogUtil.info("快速点击拦截：并行停止操作过于频繁或状态不允许");
      return;
    }
    this.isAllStopping = true;
    this.overallStatus = '并行异步停止中...';

    let completedCount = 0;
    let errorCount = 0;

    const promises: Promise<void>[] = [];

    this.videoPlayers.forEach((player, index) => {
      player.lastOperationTime = now;
      player.isProcessing = true;
      player.isStopping = true;

      if (!player.vapPlayer || !player.isPlaying) {
        player.stopStatus = '播放器未运行，无法停止';
        player.testResult = '失败: 播放器未运行';
        errorCount++;
        return;
      }

      player.stopStatus = '异步停止中...';
      player.testResult = '异步停止中...';

      const promise = player.vapPlayer?.stopAsync()
        .then(() => {
          player.stopStatus = 'Async stop completed';
          player.isPlaying = false;
          completedCount++;
        })
        .catch((error: Error) => {
          player.stopStatus = `Async stop failed: ${error.message}`;
          player.isPlaying = false;
          errorCount++;
          throw error;
        })
        .finally(() => {
          player.isStopping = false;
          player.isProcessing = false;
        });

      promises.push(promise);
    });

    try {
      await Promise.allSettled(promises);

      this.isAllStopping = false;
      this.isAllPlaying = false;

      if (errorCount === 0) {
        this.overallStatus = `Async stop completed (Success: ${completedCount}/${this.parallelCount})`;
      } else {
        this.overallStatus = `Async stop partially failed (Success: ${completedCount}/${this.parallelCount}, Failed: ${errorCount}/${this.parallelCount})`;
      }
    } catch (error) {
      this.overallStatus = `Async stop error: ${error}`;
      this.isAllStopping = false;
    }
  }

  getGridRowsTemplate(): string {
    const rows = Math.ceil(this.parallelCount / 3);
    return '1fr '.repeat(rows).trim();
  }

  getGridHeight(): string {
    const rows = Math.ceil(this.parallelCount / 3);
    const rowHeight = 400;
    return `${rows * rowHeight}px`;
  }

  isAnyPlayerProcessing(): boolean {
    return this.videoPlayers.some(player => player.isProcessing || player.isStopping);
  }

  build() {
    Column() {
      Text('Parallel Async Stop Demo')
        .fontSize(24)
        .fontWeight(700)
        .fontColor(Color.Blue)
        .margin({ bottom: 10 })

      Text(`Overall Status: ${this.overallStatus}`)
        .fontSize(16)
        .fontWeight(500)
        .fontColor(this.overallStatusColor)
        .margin({ bottom: 15 })

      Row({ space: 10 }) {
        Button('Play All')
          .width('30%')
          .backgroundColor(this.isAllPlaying ? Color.Green : Color.Blue)
          .fontColor(Color.White)
          .enabled(!this.isAllPlaying && !this.isAllStopping && this.isPlayCompleted)
          .onClick(() => {
            this.startAllPlay();
          })

        Button('Async Stop All')
          .width('30%')
          .backgroundColor(this.isAllStopping ? Color.Orange : Color.Red)
          .fontColor(Color.White)
          .enabled(this.isAllPlaying && !this.isAllStopping)
          .onClick(() => {
            this.stopAllAsync();
          })
      }
      .margin({ bottom: 20 })

      Scroll() {
        Grid() {
          ForEach(this.videoPlayers, (player: VideoPlayer, index: number) => {
            GridItem() {
              Column({ space: 8 }) {
                Stack() {
                  XComponent({
                    id: player.xComponentId,
                    type: 'surface',
                    libraryname: 'vap'
                  })
                    .onLoad((context?: object) => {
                      if (context) {
                        player.vapPlayer = new VAPPlayer(player.xComponentId);
                        player.vapPlayer.setContext(context);
                      }
                    })
                    .backgroundColor(Color.Transparent)
                    .width('100%')
                    .height('100%')
                }
                .backgroundImage($r('app.media.bg'))
                .backgroundImageSize(ImageSize.FILL)
                .height('200px')
                .width('100%')
                .border({ width: 2, color: player.isPlaying ? Color.Green : Color.Gray })

                Text(`Player ${index + 1}`)
                  .fontSize(12)
                  .fontWeight(500)

                Text(`Status: ${player.stopStatus}`)
                  .fontSize(10)
                  .fontColor(player.stopStatusColor)
              }
              .padding(5)
              .backgroundColor(Color.White)
              .borderRadius(8)
              .border({ width: 1, color: Color.Gray })
              .width('100%')
            }
          })
        }
        .columnsTemplate('1fr 1fr 1fr')
        .rowsTemplate(this.getGridRowsTemplate())
        .columnsGap(10)
        .rowsGap(10)
        .height(this.getGridHeight())
        .width('100%')
      }
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Auto)
    }
    .padding(15)
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f5f5')
  }
}