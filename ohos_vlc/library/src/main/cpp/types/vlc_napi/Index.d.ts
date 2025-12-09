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

import { ArrayList } from "@kit.ArkTS"

export class Vlc {
  public constructor(stringArray: ArrayList<string>, homePath: string)
}

export interface MediaEventCB {
  onMediaEventCallback?: (type: number) => void
}

export class VlcMedia {
  public constructor(vlcInstance: Vlc, mediaURL: string)
  addListener(cb: MediaEventCB)
  getDuration: () => number;
  parse: () => number;
}

export interface MediaPlayerEventCB {
  onMediaPlayerEventCallback?: (type: number, para1: number, para2: number, para3: number) => void
}

export class VlcMediaPlayer {
  public constructor(vlcInstance: Vlc);
  setMedia: (vlcMediaInstance: VlcMedia) => void
  play: () => void
  stop: () => void
  pause: () => void
  getState: () => number
  getLength: () => number
  getVolume: () => number
  setScale: (factor: number) => void
  setVolume: (volume: number) => number
  isPlaying: () => boolean
  setVideoOut: (id: string) => void
  setEventCallback: (cb: MediaPlayerEventCB) => void
  addSlave: (type: number, mediaURL: string, select: boolean) => boolean
  isSeekable: () => boolean;
  setTime: (time: number) => void;
  getTime: () => number;
  setPosition: (pos: number) => void;
  getPosition: () => number;
  getRate: () => number;
  setRate: (rate: number) => number;
}

export enum libvlc_event_e {
  libvlc_MediaMetaChanged = 0,
  libvlc_MediaSubItemAdded = 1,
  libvlc_MediaDurationChanged = 2,
  libvlc_MediaParsedChanged = 3,
  libvlc_MediaStateChanged = 5,
  libvlc_MediaSubItemTreeAdded = 6,
  libvlc_MediaPlayerMediaChanged = 256,
  libvlc_MediaPlayerOpening = 258,
  libvlc_MediaPlayerBuffering = 259,
  libvlc_MediaPlayerPlaying = 260,
  libvlc_MediaPlayerPaused = 261,
  libvlc_MediaPlayerStopped = 262,
  libvlc_MediaPlayerEndReached = 265,
  libvlc_MediaPlayerEncounteredError = 266,
  libvlc_MediaPlayerTimeChanged = 267,
  libvlc_MediaPlayerPositionChanged = 268,
  libvlc_MediaPlayerSeekableChanged = 269,
  libvlc_MediaPlayerPausableChanged = 270,
  libvlc_MediaPlayerLengthChanged = 273,
  libvlc_MediaPlayerVout = 274,
  libvlc_MediaPlayerESAdded = 276,
  libvlc_MediaPlayerESDeleted = 277,
  libvlc_MediaPlayerESSelected = 278,
}
