import { VAPPlayer, FitType, MixData } from '@ohos/vap'
import { LogUtil } from '../common/LogUtil'
import { util } from '@kit.ArkTS'

@Entry
@Component
struct AsyncStopDemo {
  private vapPlayer: VAPPlayer | undefined = undefined;
  @State isPlaying: boolean = false;
  private xComponentId: string = 'xcomponentId_' + util.generateRandomUUID();
  @State private lastOperationTime: number = 0;
  @State private isProcessing: boolean = false;

  startPlay() {
    const now = Date.now();
    if (now - this.lastOperationTime < 400 || this.isProcessing || this.isPlaying) {
      LogUtil.info("快速点击拦截：播放操作过于频繁或状态不允许");
      return;
    }
    this.lastOperationTime = now;
    this.isProcessing = true;

    try {
      this.isPlaying = true;

      if (!this.vapPlayer) {
        this.isPlaying = false;
        LogUtil.error('VAP播放器未初始化');
        return;
      }

      const videoPath = getContext(this).filesDir + "/vapx.mp4";
      LogUtil.info(`尝试播放视频: ${videoPath}`);
      this.vapPlayer.setFitType(FitType.FIT_CENTER);
      let opts: Array<MixData> = new Array();

      this.vapPlayer.play(videoPath, opts, () => {
        this.isPlaying = false;
      });
      LogUtil.info('视频播放命令已发送');
    } catch (error) {
      this.isPlaying = false;
      LogUtil.error(`播放错误: ${JSON.stringify(error)}`);
    } finally {
      this.isProcessing = false;
    }
  }

  build() {
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
        .height('70%')
        .visibility(Visibility.Visible)

      Column() {
        Row({ space: 20 }) {
          Button('play')
            .width('40%')
            .height(50)
            .fontSize(18)
            .fontWeight(700)
            .fontColor(Color.White)
            .borderRadius(25)
            .enabled(!this.isPlaying)
            .onClick(() => {
              this.startPlay();
            })

          Button('stopAsync')
            .width('40%')
            .height(50)
            .fontSize(18)
            .fontWeight(700)
            .fontColor(Color.White)
            .borderRadius(25)
            .onClick(async () => {
              const now = Date.now();
              if (now - this.lastOperationTime < 400 || this.isProcessing || !this.isPlaying) {
                LogUtil.info("快速点击拦截：异步停止操作过于频繁或状态不允许");
                return;
              }

              if (!this.vapPlayer || !this.isPlaying) {
                return;
              }

              this.lastOperationTime = now;
              this.isProcessing = true;

              try {
                await this.vapPlayer?.stopAsync();
                this.isPlaying = false;
              } catch (error) {
                this.isPlaying = false;
              } finally {
                this.isProcessing = false;
              }
            })
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .padding({ bottom: 40, left: 20, right: 20 })
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.End)
      .alignItems(HorizontalAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundImage($r('app.media.bg'))
    .backgroundImageSize(ImageSize.FILL)
  }
}