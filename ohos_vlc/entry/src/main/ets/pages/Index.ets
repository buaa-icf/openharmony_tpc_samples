import { hilog } from '@kit.PerformanceAnalysisKit';
import { LibVLC, MediaPlayer, Media, MediaPlayerListener, MediaListener } from '@ohos/vlc'
import { ArrayList } from '@kit.ArkTS';

@Entry
@Component
@Preview
struct Index {
  @State message: string = 'Hello World';
  private vlc: LibVLC = new LibVLC(new ArrayList<string>(), '');
  private mediaPlayer: MediaPlayer = new MediaPlayer(this.vlc);
  private path = 'file://' + getContext().resourceDir + '/5.mp4';
  private media: Media = new Media(this.vlc, this.path)
  private xcomponentId = 'myxcomponentid';
  @State private currentTime: number = 0
  @State private totalTime: number = 0
  @State private currentPos: number = 0;
  @State private rate: number = 0;
  @State private rates: number[] = [0, 0.25, 0.5, 1, 1.5, 2, 3, 4];
  rateSelectedIndex: number = 3;
  scaleSelectedIndex: number = 0;
  @State isPlaying: boolean = false;
  timeID: number = 0;
  @State state: number = 0;
  @State volume: number = 0;

  private mediaListener: MediaListener = {
    onMediaParsedChanged: () => {
      this.totalTime = this.media.getDuration();
    }
  }
  private mediaPlayerListener: MediaPlayerListener = {
    onMediaPlayerOpening: () => {
      hilog.info(0x0000, 'vlcdebug', 'from app onMediaPlayerOpening');
    },
    onMediaPlayerBuffering: (para1: number) => {
      hilog.info(0x0000, 'vlcdebug', 'from app onMediaPlayerBuffering para1 %{public}d', para1);
    },
    onMediaPlayerPlaying: () => {
      hilog.info(0x0000, 'vlcdebug', 'from app onMediaPlayerPlaying');
    },
    onMediaPlayerPaused: () => {
      hilog.info(0x0000, 'vlcdebug', 'from app onMediaPlayerPaused');
    },
    onMediaPlayerESDeleted: (para1: number, para2: number) => {
      hilog.info(0x0000, 'testTag', 'from app onMediaPlayerESDeleted para1 %{public}d para2 %{public}d', para1, para2);
    },
    onMediaPlayerESAdded: (para1: number, para2: number) => {
      hilog.info(0x0000, 'testTag', 'from app libvlc_MediaPlayerESAdded para1 %{public}d para2 %{public}d', para1,
        para2);
    },
    onMediaPlayerESSelected: (para1: number, para2: number) => {
      hilog.info(0x0000, 'testTag', 'from app onMediaPlayerESSelected para1 %{public}d para2 %{public}d', para1, para2);
    },
    onMediaPlayerPositionChanged: (para: number) => {
      this.currentPos = para
    },
    onMediaPlayerTimeChanged: (para: number) => {
      this.currentTime = para;
    },
    onMediaPlayerStopped: () => {
      this.mediaPlayer.stop();
    }
  }

  formatTime(ms: number): string {
    if (ms <= 0 || isNaN(ms)) {
      return '00:00';
    }

    let totalSeconds = Math.floor(ms / 1000);
    let hours = Math.floor(totalSeconds / 3600);
    let minutes = Math.floor((totalSeconds % 3600) / 60);
    let seconds = totalSeconds % 60;

    const pad = (n: number) => n < 10 ? '0' + n : '' + n;

    if (hours > 0) {
      return `${hours}:${pad(minutes)}:${pad(seconds)}`;
    } else {
      return `${pad(minutes)}:${pad(seconds)}`;
    }
  }

  build() {
    Column() {
      Column() {
        Row() {
          Row() {
            Radio({ value: 'Radio1', group: 'radioGroup',
              indicatorType:RadioIndicatorType.TICK
            })
              .checked(false)
              .height(30)
              .width(30)
              .onChange((isChecked: boolean) => {
                if (isChecked) {
                  this.mediaPlayer.stop()
                  this.media = new Media(this.vlc, "rtmp://ns8.indexforce.com/home/mystream")
                  this.media.addListener(this.mediaListener);
                  this.media.parse();
                  this.mediaPlayer.setMedia(this.media)
                }
              })
            Text("rtmp视频流")
          }

          Row() {
            Radio({ value: 'Radio2', group: 'radioGroup',
              indicatorType:RadioIndicatorType.TICK
            })
              .checked(false)
              .height(30)
              .width(30)
              .onChange((isChecked: boolean) => {
                if (isChecked) {
                  this.mediaPlayer.stop()
                  this.media = new Media(this.vlc, "file://" + getContext().resourceDir + "/5.mp4")
                  this.media.addListener(this.mediaListener);
                  this.media.parse();
                  this.mediaPlayer.setMedia(this.media)
                }
              })
            Text("本地视频文件")
          }
        }
        .justifyContent(FlexAlign.SpaceAround)
        .width('100%')
        .padding(8)

        Row() {
          Button("play")
            .onClick(() => {
              this.mediaPlayer.play();
            })

          Button("pause")
            .onClick(() => {
              this.mediaPlayer.pause();
            })

          Button("stop")
            .onClick(() => {
              this.mediaPlayer.stop();
            })
        }
        .padding(8)
        .justifyContent(FlexAlign.SpaceAround)
        .width('100%')

        Row() {
          Text("播放速率: ")

          Select(this.rates.map((rate: number): SelectOption => {
            return { value: rate.toString() }
          }))
            .selected(this.rateSelectedIndex)
            .value(this.rates[this.rateSelectedIndex].toString())
            .onSelect((index: number) => {
              this.rateSelectedIndex = index;
            })

          Button("设置速率")
            .onClick(() => {
              this.mediaPlayer.setRate(this.rates[this.rateSelectedIndex])
            })
            .margin({right: 8})
        }
        .padding(8)
        .width('100%')

        Row() {
          Text(`当前状态: ${this.state}`)
            .width('200')

          Button("获取当前状态")
            .onClick(() => {
              this.state = this.mediaPlayer.getState()
            })
            .margin({right: 8})
        }
        .padding(8)
        .width('100%')

        Row() {
          Text("缩放倍率: ")

          Select(this.rates.map((rate: number): SelectOption => {
            if (rate === 0) {
              return { value: '自适应' }
            }
            return { value: rate.toString() }
          }))
            .selected(this.scaleSelectedIndex)
            .value(this.rates[this.scaleSelectedIndex].toString())
            .onSelect((index: number) => {
              this.scaleSelectedIndex = index;
            })

          Button('设置缩放')
            .onClick(() => {
              this.mediaPlayer.setScale(this.rates[this.scaleSelectedIndex])
            })
            .margin({right: 8})
        }
        .padding(8)
        .width('100%')
      }.layoutWeight(1)

      Column() {
        XComponent({ id: this.xcomponentId, type: 'surface', libraryname: 'vlc_napi' })
          .onLoad(() => {
            this.mediaPlayer.addListener(this.mediaPlayerListener);
            this.mediaPlayer.setVideoOut(this.xcomponentId)
          })
          .id('videoXComponent')
          .width('100%')
          .height(300)

        Row() {
          Slider({
            value: this.currentPos * 100,
            min: 0,
            max: 100,
            step: 1
          })
            .layoutWeight(1)
            .margin({ left: 8 })
            .onChange((value: number, mode: SliderChangeMode) => {
              if (!this.mediaPlayer.isPlaying()) {
                return
              }
              if (mode === SliderChangeMode.Click) {
                this.mediaPlayer.pause();
              } else if (mode === SliderChangeMode.End) {
                this.mediaPlayer.setPosition(value / 100);
                this.mediaPlayer.play();
              }
            })

          Text(`${this.formatTime(this.currentTime)} / ${this.formatTime(this.totalTime)}`)
            .margin({ left: 8, right: 8 })
        }.width('100%')
      }
    }
    .height('90%')
  }
}
