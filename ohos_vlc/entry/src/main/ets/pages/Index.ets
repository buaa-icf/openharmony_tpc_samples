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

import {
  LibVLC,
  MediaPlayer,
  Media,
  MediaPlayerListener,
  MediaListener,
  libvlc_event_e,
} from '@ohos/vlc'
import fs from '@ohos.file.fs';

@Entry
@Component
@Preview
struct Index {
  @State message: string = 'Hello World';
  private vlc: LibVLC = new LibVLC(["--verbose=4"], '');
  private mediaPlayer: MediaPlayer = new MediaPlayer(this.vlc);
  private path = 'file://' + getContext().resourceDir + '/5.mp4';
  private media: Media = new Media(this.vlc, this.path)
  // dialog!: Dialog;
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
  @State videoWidth: number = 400
  @State videoHeight: number = 300
  private mediaListener: MediaListener = {
    onMediaEventCallback: (type: libvlc_event_e) => {
      console.log(`onMediaEventCallback ${type}`);
      if (type == libvlc_event_e.libvlc_MediaParsedChanged) {
        this.totalTime = this.media.getDuration();
      }
    }
  }
  private mediaPlayerListener: MediaPlayerListener = {
    onEvent: (type: libvlc_event_e, para1: number, para2: number, para3: number) => {
      console.log(`event ${type}, ${para1}, ${para2}, ${para3},`);
      switch (type) {
        case libvlc_event_e.libvlc_MediaPlayerBuffering:
          break;
        case libvlc_event_e.libvlc_MediaPlayerPositionChanged:
          this.currentPos = para3;
          break;
        case libvlc_event_e.libvlc_MediaPlayerTimeChanged:
          this.currentTime = para1;
          break;
        case libvlc_event_e.libvlc_MediaPlayerEndReached:
          console.log(`MMMMMM libvlc_MediaPlayerEndReached`);
          this.mediaPlayer.stop();
          break;
      }
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

  copyRawFileToCache(rawFilePath: string): string {
    let context = getContext();
    let rawFd = context.resourceManager.getRawFdSync(rawFilePath);

    let fileName = rawFilePath.split('/').pop();
    let cachePath = context.cacheDir + '/' + fileName;

    let fileBuffer = new ArrayBuffer(rawFd.length);
    fs.readSync(rawFd.fd, fileBuffer, { offset: rawFd.offset, length: rawFd.length });

    let cacheFile = fs.openSync(cachePath, fs.OpenMode.CREATE | fs.OpenMode.WRITE_ONLY);
    fs.writeSync(cacheFile.fd, fileBuffer);
    fs.closeSync(cacheFile);

    context.resourceManager.closeRawFdSync(rawFilePath);
    return cachePath;
  }

  build() {
    Column() {
      Column() {
        Row() {
          Row() {
            Radio({
              value: 'Radio1', group: 'radioGroup',
              indicatorType: RadioIndicatorType.TICK
            })
              .checked(false)
              .height(30)
              .width(30)
              .onChange((isChecked: boolean) => {
                if (isChecked) {
                  this.mediaPlayer.stop()
                  this.media = new Media(this.vlc, "rtmp://111.231.6.35:1935/live/stream")
                  this.media.setEventListener(this.mediaListener);
                  this.media.parse();
                  this.mediaPlayer.setMedia(this.media)
                }
              })
            Text("rtmp视频流")
          }

          Row() {
            Radio({
              value: 'Radio2', group: 'radioGroup',
              indicatorType: RadioIndicatorType.TICK
            })
              .checked(false)
              .height(30)
              .width(30)
              .onChange(async (isChecked: boolean) => {
                if (isChecked) {
                  this.mediaPlayer.stop()
                  this.media = new Media(this.vlc, "file://" + getContext().resourceDir + "/5.mp4")
                  this.media.setEventListener(this.mediaListener);
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
            .margin({ right: 8 })
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
            .margin({ right: 8 })
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
            .value('自适应')
            .onSelect((index: number) => {
              this.scaleSelectedIndex = index;
            })

          Button('设置缩放')
            .onClick(() => {
              this.mediaPlayer.setScale(this.rates[this.scaleSelectedIndex])
            })
            .margin({ right: 8 })
        }
        .padding(8)
        .width('100%')
      }.layoutWeight(1)

      Column() {
        XComponent({ id: this.xcomponentId, type: 'surface', libraryname: 'vlc_napi' })
          .onLoad(() => {
            this.mediaPlayer.setEventListener(this.mediaPlayerListener);
            this.mediaPlayer.setVideoOut(this.xcomponentId)
          })
          .id('videoXComponent')
          .width(this.videoWidth)
          .height(this.videoHeight)

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
