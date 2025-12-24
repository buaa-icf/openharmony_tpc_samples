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

#include "media_player_wrapper.h"
#include <string>
#include "libvlc_wrapper.h"
#include "media_wrapper.h"
#include "ohos_log.h"
#include "xcomponent_manager.h"
#include <map>
#include "common.h"

namespace {
constexpr int32_t PARAM_0 = 0;
constexpr int32_t PARAM_1 = 1;
constexpr int32_t PARAM_2 = 2;
constexpr int32_t PARAM_3 = 3;
constexpr int32_t PARAM_4 = 4;

struct MediaPlayerCallbackCtx {
    int type;
    int64_t para1 = 0;
    int64_t para2 = 0;
    double para3 = 0;
};

void AfterWorkCb(napi_env env, napi_value callback, void* context, void* data)
{
    MediaPlayerCallbackCtx *ctx = (MediaPlayerCallbackCtx*)data;
    napi_value callbackParams[4] = {nullptr};
    napi_create_int32(env, ctx->type, &callbackParams[PARAM_0]);
    napi_create_int64(env, ctx->para1, &callbackParams[PARAM_1]);
    napi_create_int64(env, ctx->para2, &callbackParams[PARAM_2]);
    napi_create_double(env, ctx->para3, &callbackParams[PARAM_3]);
    napi_value result = nullptr;
    napi_call_function(env, nullptr, callback, PARAM_4, callbackParams, &result);
    delete ctx;
}

void NativeEventCallback(const libvlc_event_t *p_ev, void *data)
{
    LOGD("NativeEventCallback type %d", p_ev->type);
    MediaPlayerCallbackCtx *ctx = new MediaPlayerCallbackCtx {
        .type = p_ev->type,
    };

    switch (p_ev->type) {
        case libvlc_MediaPlayerBuffering:
            ctx->para3 = p_ev->u.media_player_buffering.new_cache;
            break;
        case libvlc_MediaPlayerPositionChanged:
            ctx->para3 = p_ev->u.media_player_position_changed.new_position;
            break;
        case libvlc_MediaPlayerTimeChanged:
            ctx->para1 = p_ev->u.media_player_time_changed.new_time;
            break;
        case libvlc_MediaPlayerVout:
            ctx->para1 = p_ev->u.media_player_vout.new_count;
            break;
        case libvlc_MediaPlayerESAdded:
        case libvlc_MediaPlayerESDeleted:
        case libvlc_MediaPlayerESSelected:
            ctx->para1 = p_ev->u.media_player_es_changed.i_type;
            ctx->para2 = p_ev->u.media_player_es_changed.i_id;
            break;
        case libvlc_MediaPlayerSeekableChanged:
            ctx->para1 = p_ev->u.media_player_seekable_changed.new_seekable;
            break;
        case libvlc_MediaPlayerPausableChanged:
            ctx->para1 = p_ev->u.media_player_pausable_changed.new_pausable;
            break;
        case libvlc_MediaPlayerLengthChanged:
            ctx->para1 = p_ev->u.media_player_length_changed.new_length;
            break;
    }
    MediaPlayerWrapper *meidaPlayer = (MediaPlayerWrapper*)data;
    napi_call_threadsafe_function(meidaPlayer->tsfn_, ctx, napi_tsfn_nonblocking);
}
};

napi_value MediaPlayerWrapper::MediaPlayerConstructor(napi_env env, napi_callback_info info)
{
    napi_value arkTSVLCPlayer = nullptr;
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, &arkTSVLCPlayer, nullptr);

    LibVLCWrapper *vlc = nullptr;
    napi_status status = napi_unwrap(env, args[0], reinterpret_cast<void **>(&vlc));
    if (status != napi_ok || vlc == nullptr || vlc->instance_ == nullptr) {
        LOGE("unwrap LibVLCWrapper failed");
        return arkTSVLCPlayer;
    }
    MediaPlayerWrapper* player = new MediaPlayerWrapper();
    player->instance_ = libvlc_media_player_new(vlc->instance_);
    if (player->instance_ == nullptr) {
        LOGE("libvlc_media_player_new failed");
        return arkTSVLCPlayer;
    }
    status = napi_wrap(env, arkTSVLCPlayer, (void *)player,
                       [](napi_env env, void *finalize_data, void *finalize_hint) {
                           MediaPlayerWrapper *player = (MediaPlayerWrapper *)finalize_data;
                           libvlc_event_manager_t *manager = libvlc_media_player_event_manager(player->instance_);
                           libvlc_media_player_stop(player->instance_);
                           for (const auto& [k, v] : g_states) {
                               libvlc_event_detach(manager, v, NativeEventCallback, player);
                           }
                           libvlc_media_player_release(player->instance_);
                           if (player->tsfn_ != nullptr) {
                               napi_release_threadsafe_function(player->tsfn_, napi_tsfn_abort);
                           }
                           delete player;
                       }, nullptr, nullptr);
    if (status != napi_ok) {
        delete player;
    }
    LOGI("MediaPlayerConstructor success");
    return arkTSVLCPlayer;
}

napi_value MediaPlayerWrapper::SetMedia(napi_env env, napi_callback_info info)
{
    napi_value arkTSVLCPlayer = nullptr;
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, &arkTSVLCPlayer, nullptr);

    MediaPlayerWrapper *player = nullptr;
    napi_status status = napi_unwrap(env, arkTSVLCPlayer, reinterpret_cast<void **>(&player));
    if (status != napi_ok || player == nullptr || player->instance_ == nullptr) {
        LOGE("SetMedia napi_unwrap MediaPlayerWrapper failed!");
        return nullptr;
    }

    MediaWrapper *media = nullptr;
    status = napi_unwrap(env, args[0], reinterpret_cast<void **>(&media));
    if (status != napi_ok || media == nullptr || media->instance_ == nullptr) {
        LOGE("SetMedia napi_unwrap VlcMediaWrapper failed!");
        return nullptr;
    }
    libvlc_media_player_set_media(player->instance_, media->instance_);
    return nullptr;
}

napi_value MediaPlayerWrapper::Play(napi_env env, napi_callback_info info)
{
    napi_value arkTSVLCPlayer = nullptr;
    size_t argc = 0;
    napi_get_cb_info(env, info, &argc, nullptr, &arkTSVLCPlayer, nullptr);

    MediaPlayerWrapper *player = nullptr;
    napi_status status = napi_unwrap(env, arkTSVLCPlayer, reinterpret_cast<void **>(&player));
    if (status != napi_ok || player == nullptr || player->instance_ == nullptr) {
        LOGE("napi_unwrap MediaPlayerWrapper failed!");
        return nullptr;
    }
    libvlc_media_player_play(player->instance_);
    return nullptr;
}

napi_value MediaPlayerWrapper::SetVideoOut(napi_env env, napi_callback_info info)
{
    napi_value arkTSVLCPlayer = nullptr;
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, &arkTSVLCPlayer, nullptr);
    
    MediaPlayerWrapper *player = nullptr;
    napi_status status = napi_unwrap(env, arkTSVLCPlayer, reinterpret_cast<void **>(&player));
    if (status != napi_ok || player == nullptr || player->instance_ == nullptr) {
        LOGE("napi_unwrap MediaPlayerWrapper failed!");
        return nullptr;
    }

    size_t length;
    status = napi_get_value_string_utf8(env, args[0], nullptr, 0, &length);
    std::string id(length, '\0');
    status = napi_get_value_string_utf8(env, args[0], &id[0], length + 1, &length);
    LOGD("id = %s, component = %p Window = = %p", id.c_str(), xMgr.GetNativeXcomponent(id), xMgr.GetNativeWindow(id));
    libvlc_media_player_set_ohos_nativewindow_ptr(player->instance_, xMgr.GetNativeWindow(id));
    return nullptr;
}

napi_value MediaPlayerWrapper::SetEventListener(napi_env env, napi_callback_info info)
{
    napi_value arkTSVLCPlayer = nullptr;
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, &arkTSVLCPlayer, nullptr);

    MediaPlayerWrapper *player = nullptr;
    napi_status status = napi_unwrap(env, arkTSVLCPlayer, reinterpret_cast<void **>(&player));
    if (status != napi_ok || player == nullptr || player->instance_ == nullptr) {
        LOGE("unwrap MediaPlayerWrapper failed!");
        return nullptr;
    }
    
    napi_value callbackFun = nullptr;
    napi_get_named_property(env, args[0], "onEvent", &callbackFun);
    if (callbackFun == nullptr) {
        return nullptr;
    }
    
    if (player->tsfn_ != nullptr) {
        napi_release_threadsafe_function(player->tsfn_, napi_tsfn_abort);
    }
    napi_value resource_name;
    napi_create_string_utf8(env, "MediaPlayerCallback", NAPI_AUTO_LENGTH, &resource_name);
    napi_create_threadsafe_function(
        env,
        callbackFun,
        nullptr,
        resource_name,
        0,
        1,
        nullptr,
        [](napi_env env, void* finalize_data, void* finalize_hint) {},
        nullptr,
        AfterWorkCb,
        &player->tsfn_);
    libvlc_event_manager_t *manager = libvlc_media_player_event_manager(player->instance_);
    for (const auto& [k, v] : g_states) {
        libvlc_event_attach(manager, v, NativeEventCallback, player);
    }
    return nullptr;
}

napi_value MediaPlayerWrapper::Stop(napi_env env, napi_callback_info info)
{
    napi_value arkTSVLCPlayer = nullptr;
    napi_get_cb_info(env, info, nullptr, nullptr, &arkTSVLCPlayer, nullptr);

    MediaPlayerWrapper *player = nullptr;
    napi_status status = napi_unwrap(env, arkTSVLCPlayer, reinterpret_cast<void **>(&player));
    if (status != napi_ok || player == nullptr || player->instance_ == nullptr) {
        LOGE("unwrap MediaPlayerWrapper failed!");
        return nullptr;
    }
    libvlc_media_player_stop(player->instance_);
    return nullptr;
}

napi_value MediaPlayerWrapper::Pause(napi_env env, napi_callback_info info)
{
    napi_value arkTSVLCPlayer = nullptr;
    napi_get_cb_info(env, info, nullptr, nullptr, &arkTSVLCPlayer, nullptr);

    MediaPlayerWrapper *player = nullptr;
    napi_status status = napi_unwrap(env, arkTSVLCPlayer, reinterpret_cast<void **>(&player));
    if (status != napi_ok || player == nullptr || player->instance_ == nullptr) {
        LOGE("unwrap MediaPlayerWrapper failed!");
        return nullptr;
    }
    libvlc_media_player_set_pause(player->instance_, 1);
    return nullptr;
}

napi_value MediaPlayerWrapper::GetLength(napi_env env, napi_callback_info info)
{
    napi_value arkTSVLCPlayer = nullptr;
    napi_get_cb_info(env, info, nullptr, nullptr, &arkTSVLCPlayer, nullptr);

    MediaPlayerWrapper *player = nullptr;
    napi_status status = napi_unwrap(env, arkTSVLCPlayer, reinterpret_cast<void **>(&player));
    if (status != napi_ok || player == nullptr || player->instance_ == nullptr) {
        LOGE("unwrap MediaPlayerWrapper failed!");
        return nullptr;
    }
    int64_t ret = libvlc_media_player_get_length(player->instance_);
    napi_value length = nullptr;
    napi_create_int64(env, ret, &length);
    return length;
}

napi_value MediaPlayerWrapper::SetVolume(napi_env env, napi_callback_info info)
{
    napi_value arkTSVLCPlayer = nullptr;
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, &arkTSVLCPlayer, nullptr);

    MediaPlayerWrapper *player = nullptr;
    napi_status status = napi_unwrap(env, arkTSVLCPlayer, reinterpret_cast<void **>(&player));
    if (status != napi_ok || player == nullptr || player->instance_ == nullptr) {
        LOGE("unwrap MediaPlayerWrapper failed!");
        return nullptr;
    }
    int32_t volume = 0;
    napi_get_value_int32(env, args[0], &volume);
    
    int32_t ret = libvlc_audio_set_volume(player->instance_, volume);
    napi_value tsRet = nullptr;
    napi_create_int32(env, ret, &tsRet);
    return tsRet;
}

napi_value MediaPlayerWrapper::GetVolume(napi_env env, napi_callback_info info)
{
    napi_value arkTSVLCPlayer = nullptr;
    napi_get_cb_info(env, info, nullptr, nullptr, &arkTSVLCPlayer, nullptr);

    MediaPlayerWrapper *player = nullptr;
    napi_status status = napi_unwrap(env, arkTSVLCPlayer, reinterpret_cast<void **>(&player));
    if (status != napi_ok || player == nullptr || player->instance_ == nullptr) {
        LOGE("unwrap MediaPlayerWrapper failed!");
        return nullptr;
    }
    int32_t ret = libvlc_audio_get_volume(player->instance_);
    napi_value tsRet = nullptr;
    napi_create_int32(env, ret, &tsRet);
    return tsRet;
}

napi_value MediaPlayerWrapper::AddSlave(napi_env env, napi_callback_info info)
{
    napi_value arkTSVLCPlayer = nullptr;
    size_t argc = 3;
    napi_value args[3] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, &arkTSVLCPlayer, nullptr);

    MediaPlayerWrapper *player = nullptr;
    napi_status status = napi_unwrap(env, arkTSVLCPlayer, reinterpret_cast<void **>(&player));
    if (status != napi_ok || player == nullptr || player->instance_ == nullptr) {
        LOGE("unwrap MediaPlayerWrapper failed!");
        return nullptr;
    }
    
    int32_t type = 0;
    napi_get_value_int32(env, args[0], &type);
    
    size_t length;
    napi_get_value_string_utf8(env, args[1], nullptr, 0, &length);
    std::string mrl(length, '\0');
    napi_get_value_string_utf8(env, args[1], &mrl[0], length + 1, &length);
    bool select = false;
    napi_get_value_bool(env, args[PARAM_2], &select);
    
    bool ret =
        libvlc_media_player_add_slave(player->instance_, (libvlc_media_slave_type_t)type, mrl.c_str(), select) == 0;
    napi_value tsRet = nullptr;
    napi_get_boolean(env, ret, &tsRet);
    return tsRet;
}

napi_value MediaPlayerWrapper::GetState(napi_env env, napi_callback_info info)
{
    napi_value arkTSVLCPlayer = nullptr;
    napi_get_cb_info(env, info, nullptr, nullptr, &arkTSVLCPlayer, nullptr);

    MediaPlayerWrapper *player = nullptr;
    napi_status status = napi_unwrap(env, arkTSVLCPlayer, reinterpret_cast<void **>(&player));
    if (status != napi_ok || player == nullptr || player->instance_ == nullptr) {
        LOGE("unwrap MediaPlayerWrapper failed!");
        return nullptr;
    }
    
    int ret = libvlc_media_player_get_state(player->instance_);
    napi_value tsRet = nullptr;
    napi_create_int32(env, ret, &tsRet);
    return tsRet;
}

napi_value MediaPlayerWrapper::SetScale(napi_env env, napi_callback_info info)
{
    napi_value arkTSVLCPlayer = nullptr;
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, &arkTSVLCPlayer, nullptr);

    MediaPlayerWrapper *player = nullptr;
    napi_status status = napi_unwrap(env, arkTSVLCPlayer, reinterpret_cast<void **>(&player));
    if (status != napi_ok || player == nullptr || player->instance_ == nullptr) {
        LOGE("unwrap MediaPlayerWrapper failed!");
        return nullptr;
    }
    double factor = 0;
    napi_get_value_double(env, args[0], &factor);
    libvlc_video_set_scale(player->instance_, factor);\
    return nullptr;
}

napi_value MediaPlayerWrapper::IsPlaying(napi_env env, napi_callback_info info)
{
    napi_value arkTSVLCPlayer = nullptr;
    napi_get_cb_info(env, info, nullptr, nullptr, &arkTSVLCPlayer, nullptr);

    MediaPlayerWrapper *player = nullptr;
    napi_status status = napi_unwrap(env, arkTSVLCPlayer, reinterpret_cast<void **>(&player));
    if (status != napi_ok || player == nullptr || player->instance_ == nullptr) {
        LOGE("unwrap MediaPlayerWrapper failed!");
        return nullptr;
    }
    
    bool ret = !!libvlc_media_player_is_playing(player->instance_);
    napi_value tsRet = nullptr;
    napi_get_boolean(env, ret, &tsRet);
    return tsRet;
}

napi_value MediaPlayerWrapper::IsSeekable(napi_env env, napi_callback_info info)
{
    napi_value arkTSVLCPlayer = nullptr;
    napi_get_cb_info(env, info, nullptr, nullptr, &arkTSVLCPlayer, nullptr);
    MediaPlayerWrapper *player = nullptr;
    napi_status status = napi_unwrap(env, arkTSVLCPlayer, reinterpret_cast<void **>(&player));
    if (status != napi_ok || player == nullptr || player->instance_ == nullptr) {
        LOGE("unwrap MediaPlayerWrapper failed!");
        return nullptr;
    }
    
    bool ret = !!libvlc_media_player_is_seekable(player->instance_);
    napi_value tsRet = nullptr;
    napi_get_boolean(env, ret, &tsRet);
    return tsRet;
}

napi_value MediaPlayerWrapper::SetTime(napi_env env, napi_callback_info info)
{
    napi_value arkTSVLCPlayer = nullptr;
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, &arkTSVLCPlayer, nullptr);

    MediaPlayerWrapper *player = nullptr;
    napi_status status = napi_unwrap(env, arkTSVLCPlayer, reinterpret_cast<void **>(&player));
    if (status != napi_ok || player == nullptr || player->instance_ == nullptr) {
        LOGE("unwrap MediaPlayerWrapper failed!");
        return nullptr;
    }
    
    uint64_t time = 0;
    napi_get_value_bigint_uint64(env, args[0], &time, nullptr);
    libvlc_media_player_set_time(player->instance_, time);
    return nullptr;
}

napi_value MediaPlayerWrapper::GetTime(napi_env env, napi_callback_info info)
{
    napi_value arkTSVLCPlayer = nullptr;
    napi_get_cb_info(env, info, nullptr, nullptr, &arkTSVLCPlayer, nullptr);
    MediaPlayerWrapper *player = nullptr;
    napi_status status = napi_unwrap(env, arkTSVLCPlayer, reinterpret_cast<void **>(&player));
    if (status != napi_ok || player == nullptr || player->instance_ == nullptr) {
        LOGE("unwrap MediaPlayerWrapper failed!");
        return nullptr;
    }
    int64_t time = libvlc_media_player_get_time(player->instance_);
    napi_value tsRet = nullptr;
    napi_create_int64(env, time, &tsRet);
    return tsRet;
}

napi_value MediaPlayerWrapper::SetPosition(napi_env env, napi_callback_info info)
{
    napi_value arkTSVLCPlayer = nullptr;
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, &arkTSVLCPlayer, nullptr);

    MediaPlayerWrapper *player = nullptr;
    napi_status status = napi_unwrap(env, arkTSVLCPlayer, reinterpret_cast<void **>(&player));
    if (status != napi_ok || player == nullptr || player->instance_ == nullptr) {
        LOGE("unwrap MediaPlayerWrapper failed!");
        return nullptr;
    }
    
    double pos = 0;
    napi_get_value_double(env, args[0], &pos);
    libvlc_media_player_set_position(player->instance_, pos);
    return nullptr;
}

napi_value MediaPlayerWrapper::GetPosition(napi_env env, napi_callback_info info)
{
    napi_value arkTSVLCPlayer = nullptr;
    napi_get_cb_info(env, info, nullptr, nullptr, &arkTSVLCPlayer, nullptr);
    MediaPlayerWrapper *player = nullptr;
    napi_status status = napi_unwrap(env, arkTSVLCPlayer, reinterpret_cast<void **>(&player));
    if (status != napi_ok || player == nullptr || player->instance_ == nullptr) {
        LOGE("unwrap MediaPlayerWrapper failed!");
        return nullptr;
    }
    float pos = libvlc_media_player_get_position(player->instance_);
    napi_value tsRet = nullptr;
    napi_create_double(env, pos, &tsRet);
    return tsRet;
}

napi_value MediaPlayerWrapper::GetRate(napi_env env, napi_callback_info info)
{
    napi_value arkTSVLCPlayer = nullptr;
    napi_get_cb_info(env, info, nullptr, nullptr, &arkTSVLCPlayer, nullptr);
    MediaPlayerWrapper *player = nullptr;
    napi_status status = napi_unwrap(env, arkTSVLCPlayer, reinterpret_cast<void **>(&player));
    if (status != napi_ok || player == nullptr || player->instance_ == nullptr) {
        LOGE("unwrap MediaPlayerWrapper failed!");
        return nullptr;
    }
    float rate = libvlc_media_player_get_rate(player->instance_);
    napi_value tsRet = nullptr;
    napi_create_double(env, rate, &tsRet);
    return tsRet;
}

napi_value MediaPlayerWrapper::SetRate(napi_env env, napi_callback_info info)
{
    napi_value arkTSVLCPlayer = nullptr;
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, &arkTSVLCPlayer, nullptr);

    MediaPlayerWrapper *player = nullptr;
    napi_status status = napi_unwrap(env, arkTSVLCPlayer, reinterpret_cast<void **>(&player));
    if (status != napi_ok || player == nullptr || player->instance_ == nullptr) {
        LOGE("unwrap MediaPlayerWrapper failed!");
        return nullptr;
    }
    
    double rate = 0;
    napi_get_value_double(env, args[0], &rate);
    int ret = libvlc_media_player_set_rate(player->instance_, rate);
    napi_value tsRet = nullptr;
    napi_create_int32(env, ret, &tsRet);
    return tsRet;
}

napi_value MediaPlayerWrapper::SetAudioTrack(napi_env env, napi_callback_info info)
{
    napi_value arkTSVLCPlayer = nullptr;
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, &arkTSVLCPlayer, nullptr);

    MediaPlayerWrapper *player = nullptr;
    napi_status status = napi_unwrap(env, arkTSVLCPlayer, reinterpret_cast<void **>(&player));
    if (status != napi_ok || player == nullptr || player->instance_ == nullptr) {
        LOGE("unwrap MediaPlayerWrapper failed!");
        return nullptr;
    }
    
    int32_t track = 0;
    napi_get_value_int32(env, args[0], &track);
    int ret = libvlc_audio_set_track(player->instance_, track);
    napi_value tsRet = nullptr;
    napi_create_int32(env, ret, &tsRet);
    return tsRet;
}

napi_value MediaPlayerWrapper::GetAudioTrack(napi_env env, napi_callback_info info)
{
    napi_value arkTSVLCPlayer = nullptr;
    napi_get_cb_info(env, info, nullptr, nullptr, &arkTSVLCPlayer, nullptr);
    MediaPlayerWrapper *player = nullptr;
    napi_status status = napi_unwrap(env, arkTSVLCPlayer, reinterpret_cast<void **>(&player));
    if (status != napi_ok || player == nullptr || player->instance_ == nullptr) {
        LOGE("unwrap MediaPlayerWrapper failed!");
        return nullptr;
    }

    int track = libvlc_audio_get_track(player->instance_);
    napi_value tsRet = nullptr;
    napi_create_int32(env, track, &tsRet);
    return tsRet;
}

napi_value MediaPlayerWrapper::SetTextTrack(napi_env env, napi_callback_info info)
{
    napi_value arkTSVLCPlayer = nullptr;
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, &arkTSVLCPlayer, nullptr);

    MediaPlayerWrapper *player = nullptr;
    napi_status status = napi_unwrap(env, arkTSVLCPlayer, reinterpret_cast<void **>(&player));
    if (status != napi_ok || player == nullptr || player->instance_ == nullptr) {
        LOGE("unwrap MediaPlayerWrapper failed!");
        return nullptr;
    }
    
    int32_t track = 0;
    napi_get_value_int32(env, args[0], &track);
    int ret = libvlc_video_set_spu(player->instance_, track);
    napi_value tsRet = nullptr;
    napi_create_int32(env, ret, &tsRet);
    return tsRet;
}

napi_value MediaPlayerWrapper::GetTextTrack(napi_env env, napi_callback_info info)
{
    napi_value arkTSVLCPlayer = nullptr;
    napi_get_cb_info(env, info, nullptr, nullptr, &arkTSVLCPlayer, nullptr);
    MediaPlayerWrapper *player = nullptr;
    napi_status status = napi_unwrap(env, arkTSVLCPlayer, reinterpret_cast<void **>(&player));
    if (status != napi_ok || player == nullptr || player->instance_ == nullptr) {
        LOGE("unwrap MediaPlayerWrapper failed!");
        return nullptr;
    }

    int track = libvlc_audio_get_track(player->instance_);
    napi_value tsRet = nullptr;
    napi_create_int32(env, track, &tsRet);
    return tsRet;
}

napi_value MediaPlayerWrapper::SetAspectRatio(napi_env env, napi_callback_info info)
{
    napi_value arkTSVLCPlayer = nullptr;
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, &arkTSVLCPlayer, nullptr);

    MediaPlayerWrapper *player = nullptr;
    napi_status status = napi_unwrap(env, arkTSVLCPlayer, reinterpret_cast<void **>(&player));
    if (status != napi_ok || player == nullptr || player->instance_ == nullptr) {
        LOGE("unwrap MediaPlayerWrapper failed!");
        return nullptr;
    }
    
    napi_valuetype type;
    napi_typeof(env, args[0], &type);
    if (type == napi_null || type == napi_undefined) {
        libvlc_video_set_aspect_ratio(player->instance_, NULL);
        return nullptr;
    }

    size_t length = 0;
    napi_get_value_string_utf8(env, args[0], nullptr, 0, &length);
    std::string aspect(length, '\0');
    napi_get_value_string_utf8(env, args[0], &aspect[0], length + 1, &length);
    libvlc_video_set_aspect_ratio(player->instance_, aspect.c_str());
    return nullptr;
}

napi_value MediaPlayerWrapper::GetSize(napi_env env, napi_callback_info info)
{
    napi_value arkTSVLCPlayer = nullptr;
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, &arkTSVLCPlayer, nullptr);
    MediaPlayerWrapper *player = nullptr;
    napi_status status = napi_unwrap(env, arkTSVLCPlayer, reinterpret_cast<void **>(&player));
    if (status != napi_ok || player == nullptr || player->instance_ == nullptr) {
        LOGE("unwrap MediaPlayerWrapper failed!");
        return nullptr;
    }
    
    int32_t num = 0;
    napi_get_value_int32(env, args[0], &num);
    
    
    unsigned px = 0;
    unsigned py = 0;
    int ret = libvlc_video_get_size(player->instance_, num, &px, &py);
    if (ret != 0) {
        LOGE("get size fail");
        return nullptr;
    }
    napi_value res = nullptr;
    napi_create_object(env, &res);
    napi_value arkPX = 0;
    napi_create_uint32(env, px, &arkPX);
    napi_set_named_property(env, res, "width", arkPX);

    napi_value arkPY = 0;
    napi_create_uint32(env, py, &arkPY);
    napi_set_named_property(env, res, "height", arkPY);
    LOGD("size height: %d width: %d", px, py);
    return res;
}

napi_value MediaPlayerWrapper::GetSpuDescription(napi_env env, napi_callback_info info)
{
    napi_value arkTSVLCPlayer = nullptr;
    napi_get_cb_info(env, info, nullptr, nullptr, &arkTSVLCPlayer, nullptr);
    MediaPlayerWrapper *player = nullptr;
    napi_status status = napi_unwrap(env, arkTSVLCPlayer, reinterpret_cast<void **>(&player));
    if (status != napi_ok || player == nullptr || player->instance_ == nullptr) {
        LOGE("unwrap MediaPlayerWrapper failed!");
        return nullptr;
    }
    libvlc_track_description_t* des = libvlc_video_get_spu_description(player->instance_);
    napi_value descriptions = nullptr;
    napi_create_array(env, &descriptions);
    int i = 0;
    while (des != nullptr) {
        LOGI("id: %d, name: %s", des->i_id, des->psz_name);
        napi_value res = nullptr;
        napi_create_object(env, &res);
        napi_value id = 0;
        napi_create_int32(env, des->i_id, &id);
        napi_value name = 0;
        napi_create_string_utf8(env, des->psz_name, NAPI_AUTO_LENGTH, &name);
        
        napi_set_named_property(env, res, "id", id);
        napi_set_named_property(env, res, "name", name);
        napi_set_element(env, descriptions, i, res);
        ++i;
        des = des->p_next;
    }
    return descriptions;
}

napi_value MediaPlayerWrapper::GetAudioDescription(napi_env env, napi_callback_info info)
{
    napi_value arkTSVLCPlayer = nullptr;
    napi_get_cb_info(env, info, nullptr, nullptr, &arkTSVLCPlayer, nullptr);
    MediaPlayerWrapper *player = nullptr;
    napi_status status = napi_unwrap(env, arkTSVLCPlayer, reinterpret_cast<void **>(&player));
    if (status != napi_ok || player == nullptr || player->instance_ == nullptr) {
        LOGE("unwrap MediaPlayerWrapper failed!");
        return nullptr;
    }
    libvlc_track_description_t* des = libvlc_audio_get_track_description(player->instance_);
    napi_value descriptions = nullptr;
    napi_create_array(env, &descriptions);
    int i = 0;
    while (des != nullptr) {
        LOGI("id: %d, name: %s", des->i_id, des->psz_name);
        napi_value res = nullptr;
        napi_create_object(env, &res);
        napi_value id = 0;
        napi_create_int32(env, des->i_id, &id);
        napi_value name = 0;
        napi_create_string_utf8(env, des->psz_name, NAPI_AUTO_LENGTH, &name);
        
        napi_set_named_property(env, res, "id", id);
        napi_set_named_property(env, res, "name", name);
        napi_set_element(env, descriptions, i, res);
        ++i;
        des = des->p_next;
    }
    return descriptions;
}

napi_value MediaPlayerWrapper::Export(napi_env env, napi_value exports)
{
    napi_property_descriptor classProp[] = {
        {"setMedia", nullptr, MediaPlayerWrapper::SetMedia, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setVideoOut", nullptr, MediaPlayerWrapper::SetVideoOut, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"play", nullptr, MediaPlayerWrapper::Play, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setEventListener", nullptr, MediaPlayerWrapper::SetEventListener,
            nullptr, nullptr, nullptr, napi_default, nullptr},
        {"stop", nullptr, MediaPlayerWrapper::Stop, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"pause", nullptr, MediaPlayerWrapper::Pause, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getLength", nullptr, MediaPlayerWrapper::GetLength, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setVolume", nullptr, MediaPlayerWrapper::SetVolume, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getVolume", nullptr, MediaPlayerWrapper::GetVolume, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"addSlave", nullptr, MediaPlayerWrapper::AddSlave, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getState", nullptr, MediaPlayerWrapper::GetState, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setScale", nullptr, MediaPlayerWrapper::SetScale, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"isPlaying", nullptr, MediaPlayerWrapper::IsPlaying, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"isSeekable", nullptr, MediaPlayerWrapper::IsSeekable, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setTime", nullptr, MediaPlayerWrapper::SetTime, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getTime", nullptr, MediaPlayerWrapper::GetTime, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setPosition", nullptr, MediaPlayerWrapper::SetPosition, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getPosition", nullptr, MediaPlayerWrapper::GetPosition, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getRate", nullptr, MediaPlayerWrapper::GetRate, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setRate", nullptr, MediaPlayerWrapper::SetRate, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setAudioTrack", nullptr, MediaPlayerWrapper::SetAudioTrack, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getAudioTrack", nullptr, MediaPlayerWrapper::GetAudioTrack, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setTextTrack", nullptr, MediaPlayerWrapper::SetTextTrack, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getTextTrack", nullptr, MediaPlayerWrapper::GetTextTrack, nullptr, nullptr, nullptr, napi_default, nullptr},
        {
            "setAspectRatio", nullptr,
            MediaPlayerWrapper::SetAspectRatio, nullptr, nullptr, nullptr, napi_default, nullptr
        },
        {
            "getSpuDescription", nullptr,
            MediaPlayerWrapper::GetSpuDescription, nullptr, nullptr, nullptr, napi_default, nullptr
        },
        {"getSize", nullptr, MediaPlayerWrapper::GetSize, nullptr, nullptr, nullptr, napi_default, nullptr},
        {
            "getAudioDescription", nullptr,
            MediaPlayerWrapper::GetAudioDescription, nullptr, nullptr, nullptr, napi_default, nullptr
        },
    };
    napi_value arkTS = nullptr;
    const char *arkTSName = "MediaPlayer";
    napi_define_class(env, arkTSName, NAPI_AUTO_LENGTH, MediaPlayerWrapper::MediaPlayerConstructor, nullptr,
                      sizeof(classProp) / sizeof(classProp[0]), classProp, &arkTS);
    napi_set_named_property(env, exports, arkTSName, arkTS);
    return exports;
}