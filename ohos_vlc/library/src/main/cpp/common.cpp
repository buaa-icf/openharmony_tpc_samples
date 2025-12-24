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

#include "common.h"

std::map<std::string, libvlc_event_e> g_states = {
    {"libvlc_MediaPlayerMediaChanged", libvlc_MediaPlayerMediaChanged},
    {"libvlc_MediaPlayerOpening", libvlc_MediaPlayerOpening},
    {"libvlc_MediaPlayerBuffering", libvlc_MediaPlayerBuffering},
    {"libvlc_MediaPlayerPlaying", libvlc_MediaPlayerPlaying},
    {"libvlc_MediaPlayerPaused", libvlc_MediaPlayerPaused},
    {"libvlc_MediaPlayerStopped", libvlc_MediaPlayerStopped},
    {"libvlc_MediaPlayerEndReached", libvlc_MediaPlayerEndReached},
    {"libvlc_MediaPlayerEncounteredError", libvlc_MediaPlayerEncounteredError},
    {"libvlc_MediaPlayerTimeChanged", libvlc_MediaPlayerTimeChanged},
    {"libvlc_MediaPlayerPositionChanged", libvlc_MediaPlayerPositionChanged},
    {"libvlc_MediaPlayerVout", libvlc_MediaPlayerVout},
    {"libvlc_MediaPlayerESAdded", libvlc_MediaPlayerESAdded},
    {"libvlc_MediaPlayerESDeleted", libvlc_MediaPlayerESDeleted},
    {"libvlc_MediaPlayerESSelected", libvlc_MediaPlayerESSelected},
    {"libvlc_MediaPlayerSeekableChanged", libvlc_MediaPlayerSeekableChanged},
    {"libvlc_MediaPlayerPausableChanged", libvlc_MediaPlayerPausableChanged},
    {"libvlc_MediaPlayerLengthChanged", libvlc_MediaPlayerLengthChanged},
    {"libvlc_MediaMetaChanged", libvlc_MediaMetaChanged},
    {"libvlc_MediaSubItemAdded", libvlc_MediaSubItemAdded},
    {"libvlc_MediaDurationChanged", libvlc_MediaDurationChanged},
    {"libvlc_MediaStateChanged", libvlc_MediaStateChanged},
    {"libvlc_MediaParsedChanged", libvlc_MediaParsedChanged},
    {"libvlc_MediaSubItemTreeAdded", libvlc_MediaSubItemTreeAdded},
};