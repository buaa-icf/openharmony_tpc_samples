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

import { Size } from "@kit.ArkUI";
import { bundleManager } from "@kit.AbilityKit";

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

export class LibVLC {
  public constructor(stringArray: string[], homePath: string)
}

export interface MediaListener {
  onMediaEventCallback?: (type: libvlc_event_e) => void
}

export class Media {
  public constructor(vlcInstance: LibVLC, mediaURL: string)
  setEventListener: (cb: MediaListener) => void;
  getDuration: () => number;
  parse: () => number;
}

export interface MediaPlayerListener {
  onEvent: (type: libvlc_event_e, para1: number, para2: number, para3: number) => void;
}

export interface Description {
  id: number;
  name: string;
}

export class MediaPlayer {
  public constructor(vlcInstance: LibVLC);
  setMedia: (vlcMediaInstance: Media) => void
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
  setEventListener: (cb: MediaPlayerListener) => void
  addSlave: (type: number, mediaURL: string, select: boolean) => boolean
  isSeekable: () => boolean;
  setTime: (time: number) => void;
  getTime: () => number;
  setPosition: (pos: number) => void;
  getPosition: () => number;
  getRate: () => number;
  setRate: (rate: number) => number;
  setAudioTrack: (track: number) => number;
  getAudioTrack: () => number;
  setTextTrack: (track: number) => number;
  getTextTrack: () => number;
  setAspectRatio: (aspect: string | null) => void
  getSpuDescription: () => Array<Description>;
  getSize: () => Size;
  getAudioDescription: () => Array<Description>;
}

export enum libvlc_dialog_question_type
{
  LIBVLC_DIALOG_QUESTION_NORMAL,
  LIBVLC_DIALOG_QUESTION_WARNING,
  LIBVLC_DIALOG_QUESTION_CRITICAL,
}

export class QuestionDialog {
  title: string;
  text: string;
  type: libvlc_dialog_question_type;
  cancel: string;
  action1: string;
  action2:string;
  postAction: (action: 1 | 2) => void;
  dismiss: () => void;
}

export class ErrorDialog {
  title: string;
  text: string;
}

export class LoginDialog {
  title: string;
  text: string;
  defaultUsername: string;
  askStore: boolean;
  dismiss: () => void;
  postLogin: (name: string, password: string, store: boolean) => void;
}

export class ProgressDialog {
  title: string;
  text: string;
  indeterminate: boolean;
  position: number;
  cancel: string;
  dismiss: () => void;
  update: (position: number, text: string) => void;
}

export class CanceledDialog {
}

export class UpdateProgressDialog {
  position: number;
  text: string;
}

export interface DialogListener {
  onQuestion: (data: QuestionDialog) => void;
  onError: (data: ErrorDialog) => void;
  onLogin: (data: LoginDialog) => void;
  onProgress: (data: ProgressDialog) => void;
  onCanceled: (data: CanceledDialog) => void;
  onUpdateProgress: (data: UpdateProgressDialog) => void;
}

export class Dialog {
  static setCallbacks: (vlc: LibVLC, cb: DialogListener) => void;
}