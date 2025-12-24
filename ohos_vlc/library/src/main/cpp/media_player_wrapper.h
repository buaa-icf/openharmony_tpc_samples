/*
# Copyright (c) 2025 Huawei Device Co., Ltd.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
*/

#pragma once

#include "vlc/vlc.h"
#include "napi/native_api.h"
#include <unordered_map>

class MediaPlayerWrapper {
public:
    static napi_value Export(napi_env env, napi_value exports);
    static napi_value MediaPlayerConstructor(napi_env env, napi_callback_info info);
    static napi_value SetMedia(napi_env env, napi_callback_info info);
    static napi_value SetVideoOut(napi_env env, napi_callback_info info);
    static napi_value Play(napi_env env, napi_callback_info info);
    static napi_value SetEventListener(napi_env env, napi_callback_info info);
    static napi_value Stop(napi_env env, napi_callback_info info);
    static napi_value Pause(napi_env env, napi_callback_info info);
    static napi_value GetLength(napi_env env, napi_callback_info info);
    static napi_value SetVolume(napi_env env, napi_callback_info info);
    static napi_value GetVolume(napi_env env, napi_callback_info info);
    static napi_value AddSlave(napi_env env, napi_callback_info info);
    static napi_value GetState(napi_env env, napi_callback_info info);
    static napi_value SetScale(napi_env env, napi_callback_info info);
    static napi_value IsPlaying(napi_env env, napi_callback_info info);
    static napi_value IsSeekable(napi_env env, napi_callback_info info);
    static napi_value SetTime(napi_env env, napi_callback_info info);
    static napi_value GetTime(napi_env env, napi_callback_info info);
    static napi_value SetPosition(napi_env env, napi_callback_info info);
    static napi_value GetPosition(napi_env env, napi_callback_info info);
    static napi_value GetRate(napi_env env, napi_callback_info info);
    static napi_value SetRate(napi_env env, napi_callback_info info);
    static napi_value SetAudioTrack(napi_env env, napi_callback_info info);
    static napi_value GetAudioTrack(napi_env env, napi_callback_info info);
    static napi_value SetTextTrack(napi_env env, napi_callback_info info);
    static napi_value GetTextTrack(napi_env env, napi_callback_info info);
    static napi_value SetAspectRatio(napi_env env, napi_callback_info info);
    static napi_value GetSize(napi_env env, napi_callback_info info);
    static napi_value GetSpuDescription(napi_env env, napi_callback_info info);
    static napi_value GetAudioDescription(napi_env env, napi_callback_info info);
    
    napi_threadsafe_function tsfn_ { nullptr };
    libvlc_media_player_t *instance_ {nullptr};
    std::unordered_map<libvlc_event_e, napi_ref> listener_;
};