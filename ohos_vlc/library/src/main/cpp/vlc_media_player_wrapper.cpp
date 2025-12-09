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
#include "vlc_media_player_wrapper.h"
#include "vlc_media_wrapper.h"
#include "vlc_wrapper.h"

#include "vlc/libvlc_media.h"
#include "vlc/libvlc_media_player.h"

#include "ohos_log.h"
#include "xcomponent_manager.h"
#include <multimedia/image_framework/image_pixel_map_mdk.h>

static constexpr int32_t PARAM_0 = 0;
static constexpr int32_t PARAM_1 = 1;
static constexpr int32_t PARAM_2 = 2;
static constexpr int32_t PARAM_3 = 3;
static constexpr int32_t PARAM_4 = 4;

static const libvlc_event_type_t mp_events[] = {
    libvlc_MediaPlayerMediaChanged,
    libvlc_MediaPlayerOpening,
    libvlc_MediaPlayerBuffering,
    libvlc_MediaPlayerPlaying,
    libvlc_MediaPlayerPaused,
    libvlc_MediaPlayerStopped,
    libvlc_MediaPlayerEndReached,
    libvlc_MediaPlayerEncounteredError,
    libvlc_MediaPlayerTimeChanged,
    libvlc_MediaPlayerPositionChanged,
    libvlc_MediaPlayerVout,
    libvlc_MediaPlayerESAdded,
    libvlc_MediaPlayerESDeleted,
    libvlc_MediaPlayerESSelected,
    libvlc_MediaPlayerSeekableChanged,
    libvlc_MediaPlayerPausableChanged,
    libvlc_MediaPlayerLengthChanged,
};

struct MediaPlayerCallbackCtx {
    int type;
    int para1 = 0;
    int para2 = 0;
    double para3 = 0;
    std::string para4 = "";
    VlcMediaPlayerWrapper *context = nullptr;
};

void AfterWorkCb(napi_env env, napi_value js_callback, void* context, void* data)
{
    MediaPlayerCallbackCtx *ctx = (MediaPlayerCallbackCtx*)data;
    napi_value callbackParams[4] = {nullptr};
    napi_create_int32(env, ctx->type, &callbackParams[PARAM_0]);
    napi_create_int32(env, ctx->para1, &callbackParams[PARAM_1]);
    napi_create_int32(env, ctx->para2, &callbackParams[PARAM_2]);
    napi_create_double(env, ctx->para3, &callbackParams[PARAM_3]);
    napi_value result = nullptr;
    napi_call_function(env, nullptr, js_callback, PARAM_4, callbackParams, &result);
    delete ctx;
}

static void NativeEventCallback(const libvlc_event_t *p_ev, void *data)
{
    LOGD("NativeEventCallback type %d", p_ev->type);
    VlcMediaPlayerWrapper *context = (VlcMediaPlayerWrapper*)data;
    MediaPlayerCallbackCtx *ctx = new MediaPlayerCallbackCtx {
        .type = p_ev->type,
        .context = context,
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

    napi_call_threadsafe_function(ctx->context->tsfn_, ctx, napi_tsfn_nonblocking);
}

napi_value VlcMediaPlayerWrapper::VLCMediaPlayerConstructor(napi_env env, napi_callback_info info)
{
    napi_value arkTSVLCPlayer = nullptr;
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, &arkTSVLCPlayer, nullptr);

    VlcWrapper *vlc = nullptr;
    napi_status status = napi_unwrap(env, args[0], reinterpret_cast<void **>(&vlc));
    if (status != napi_ok) {
        LOGE("napi_unwrap failed!");
        return nullptr;
    }
    VlcMediaPlayerWrapper* player = new VlcMediaPlayerWrapper();
    player->instance_ = libvlc_media_player_new(vlc->instance_);
    status = napi_wrap(env, arkTSVLCPlayer, (void *)player,
                       [](napi_env env, void *finalize_data, void *finalize_hint) {
                           VlcMediaPlayerWrapper *player = (VlcMediaPlayerWrapper *)finalize_data;
                           libvlc_event_manager_t *manager = libvlc_media_player_event_manager(player->instance_);
                           libvlc_media_player_stop(player->instance_);
                           for (int i = 0; i < sizeof(mp_events)/sizeof(libvlc_event_type_t); ++i) {
                               libvlc_event_detach(manager, mp_events[i], NativeEventCallback, player);
                           }
                           libvlc_media_player_release(player->instance_);
                           if (player->tsfn_ != nullptr) {
                               napi_release_threadsafe_function(player->tsfn_, napi_tsfn_abort);
                           }
                           delete player;
                       }, nullptr, nullptr);
    if (status != napi_ok) {
        delete player;
        return nullptr;
    }
    return arkTSVLCPlayer;
}

napi_value VlcMediaPlayerWrapper::SetMedia(napi_env env, napi_callback_info info)
{
    napi_value arkTSVLCPlayer = nullptr;
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, &arkTSVLCPlayer, nullptr);

    VlcMediaPlayerWrapper *player = nullptr;
    napi_status status = napi_unwrap(env, arkTSVLCPlayer, reinterpret_cast<void **>(&player));
    if (status != napi_ok) {
        LOGE("SetMedia napi_unwrap VlcMediaPlayerWrapper failed!");
        return nullptr;
    }

    VlcMediaWrapper *media = nullptr;
    status = napi_unwrap(env, args[0], reinterpret_cast<void **>(&media));
    if (status != napi_ok) {
        LOGE("SetMedia napi_unwrap VlcMediaWrapper failed!");
        return nullptr;
    }
    libvlc_media_player_set_media(player->instance_, (libvlc_media_t *)(media->instance_));
    return nullptr;
}

napi_value VlcMediaPlayerWrapper::Play(napi_env env, napi_callback_info info)
{
    napi_value arkTSVLCPlayer = nullptr;
    size_t argc = 0;
    napi_get_cb_info(env, info, &argc, nullptr, &arkTSVLCPlayer, nullptr);

    VlcMediaPlayerWrapper *player = nullptr;
    napi_status status = napi_unwrap(env, arkTSVLCPlayer, reinterpret_cast<void **>(&player));
    if (status != napi_ok) {
        LOGE("napi_unwrap VlcMediaPlayerWrapper failed!");
        return nullptr;
    }
    libvlc_media_player_play(player->instance_);
    return nullptr;
}

napi_value VlcMediaPlayerWrapper::SetVideoOut(napi_env env, napi_callback_info info)
{
    napi_value arkTSVLCPlayer = nullptr;
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, &arkTSVLCPlayer, nullptr);
    
    VlcMediaPlayerWrapper *player = nullptr;
    napi_status status = napi_unwrap(env, arkTSVLCPlayer, reinterpret_cast<void **>(&player));
    if (status != napi_ok) {
        LOGE("napi_unwrap VlcMediaPlayerWrapper failed!");
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

napi_value VlcMediaPlayerWrapper::SetEventCallback(napi_env env, napi_callback_info info)
{
    napi_value arkTSVLCPlayer = nullptr;
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, &arkTSVLCPlayer, nullptr);

    VlcMediaPlayerWrapper *player = nullptr;
    napi_status status = napi_unwrap(env, arkTSVLCPlayer, reinterpret_cast<void **>(&player));
    if (status != napi_ok) {
        LOGE("unwrap VlcMediaPlayerWrapper failed!");
        return nullptr;
    }

    napi_value callbackFun = nullptr;
    napi_get_named_property(env, args[0], "onMediaPlayerEventCallback", &callbackFun);
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
    for (int i = 0; i < sizeof(mp_events)/sizeof(libvlc_event_type_t); ++i) {
        libvlc_event_attach(manager, mp_events[i], NativeEventCallback, player);
    }
    return nullptr;
}

napi_value VlcMediaPlayerWrapper::Stop(napi_env env, napi_callback_info info)
{
    napi_value arkTSVLCPlayer = nullptr;
    napi_get_cb_info(env, info, nullptr, nullptr, &arkTSVLCPlayer, nullptr);

    VlcMediaPlayerWrapper *player = nullptr;
    napi_status status = napi_unwrap(env, arkTSVLCPlayer, reinterpret_cast<void **>(&player));
    if (status != napi_ok) {
        LOGE("unwrap VlcMediaPlayerWrapper failed!");
        return nullptr;
    }
    libvlc_media_player_stop(player->instance_);
    return nullptr;
}

napi_value VlcMediaPlayerWrapper::Pause(napi_env env, napi_callback_info info)
{
    napi_value arkTSVLCPlayer = nullptr;
    napi_get_cb_info(env, info, nullptr, nullptr, &arkTSVLCPlayer, nullptr);

    VlcMediaPlayerWrapper *player = nullptr;
    napi_status status = napi_unwrap(env, arkTSVLCPlayer, reinterpret_cast<void **>(&player));
    if (status != napi_ok) {
        LOGE("unwrap VlcMediaPlayerWrapper failed!");
        return nullptr;
    }
    libvlc_media_player_set_pause(player->instance_, 1);
    return nullptr;
}

napi_value VlcMediaPlayerWrapper::GetLength(napi_env env, napi_callback_info info)
{
    napi_value arkTSVLCPlayer = nullptr;
    napi_get_cb_info(env, info, nullptr, nullptr, &arkTSVLCPlayer, nullptr);

    VlcMediaPlayerWrapper *player = nullptr;
    napi_status status = napi_unwrap(env, arkTSVLCPlayer, reinterpret_cast<void **>(&player));
    if (status != napi_ok) {
        LOGE("unwrap VlcMediaPlayerWrapper failed!");
        return nullptr;
    }
    int64_t ret = libvlc_media_player_get_length(player->instance_);
    napi_value length = nullptr;
    napi_create_int64(env, ret, &length);
    return length;
}

napi_value VlcMediaPlayerWrapper::SetVolume(napi_env env, napi_callback_info info)
{
    napi_value arkTSVLCPlayer = nullptr;
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, &arkTSVLCPlayer, nullptr);

    VlcMediaPlayerWrapper *player = nullptr;
    napi_status status = napi_unwrap(env, arkTSVLCPlayer, reinterpret_cast<void **>(&player));
    if (status != napi_ok) {
        LOGE("unwrap VlcMediaPlayerWrapper failed!");
        return nullptr;
    }
    int32_t volume = 0;
    napi_get_value_int32(env, args[0], &volume);
    
    int32_t ret = libvlc_audio_set_volume(player->instance_, volume);
    napi_value tsRet = nullptr;
    napi_create_int32(env, ret, &tsRet);
    return tsRet;
}

napi_value VlcMediaPlayerWrapper::GetVolume(napi_env env, napi_callback_info info)
{
    napi_value arkTSVLCPlayer = nullptr;
    napi_get_cb_info(env, info, nullptr, nullptr, &arkTSVLCPlayer, nullptr);

    VlcMediaPlayerWrapper *player = nullptr;
    napi_status status = napi_unwrap(env, arkTSVLCPlayer, reinterpret_cast<void **>(&player));
    if (status != napi_ok) {
        LOGE("unwrap VlcMediaPlayerWrapper failed!");
        return nullptr;
    }
    int32_t ret = libvlc_audio_get_volume(player->instance_);
    napi_value tsRet = nullptr;
    napi_create_int32(env, ret, &tsRet);
    return tsRet;
}

napi_value VlcMediaPlayerWrapper::AddSlave(napi_env env, napi_callback_info info)
{
    napi_value arkTSVLCPlayer = nullptr;
    size_t argc = 3;
    napi_value args[3] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, &arkTSVLCPlayer, nullptr);

    VlcMediaPlayerWrapper *player = nullptr;
    napi_status status = napi_unwrap(env, arkTSVLCPlayer, reinterpret_cast<void **>(&player));
    if (status != napi_ok) {
        LOGE("unwrap VlcMediaPlayerWrapper failed!");
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

napi_value VlcMediaPlayerWrapper::GetState(napi_env env, napi_callback_info info)
{
    napi_value arkTSVLCPlayer = nullptr;
    napi_get_cb_info(env, info, nullptr, nullptr, &arkTSVLCPlayer, nullptr);

    VlcMediaPlayerWrapper *player = nullptr;
    napi_status status = napi_unwrap(env, arkTSVLCPlayer, reinterpret_cast<void **>(&player));
    if (status != napi_ok) {
        LOGE("unwrap VlcMediaPlayerWrapper failed!");
        return nullptr;
    }
    
    int ret = libvlc_media_player_get_state(player->instance_);
    napi_value tsRet = nullptr;
    napi_create_int32(env, ret, &tsRet);
    return tsRet;
}

napi_value VlcMediaPlayerWrapper::SetScale(napi_env env, napi_callback_info info)
{
    napi_value arkTSVLCPlayer = nullptr;
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, &arkTSVLCPlayer, nullptr);

    VlcMediaPlayerWrapper *player = nullptr;
    napi_status status = napi_unwrap(env, arkTSVLCPlayer, reinterpret_cast<void **>(&player));
    if (status != napi_ok) {
        LOGE("unwrap VlcMediaPlayerWrapper failed!");
        return nullptr;
    }
    double factor = 0;
    napi_get_value_double(env, args[0], &factor);
    libvlc_video_set_scale(player->instance_, factor);\
    return nullptr;
}

napi_value VlcMediaPlayerWrapper::IsPlaying(napi_env env, napi_callback_info info)
{
    napi_value arkTSVLCPlayer = nullptr;
    napi_get_cb_info(env, info, nullptr, nullptr, &arkTSVLCPlayer, nullptr);

    VlcMediaPlayerWrapper *player = nullptr;
    napi_status status = napi_unwrap(env, arkTSVLCPlayer, reinterpret_cast<void **>(&player));
    if (status != napi_ok) {
        LOGE("unwrap VlcMediaPlayerWrapper failed!");
        return nullptr;
    }
    
    bool ret = !!libvlc_media_player_is_playing(player->instance_);
    napi_value tsRet = nullptr;
    napi_get_boolean(env, ret, &tsRet);
    return tsRet;
}

napi_value VlcMediaPlayerWrapper::IsSeekable(napi_env env, napi_callback_info info)
{
    napi_value arkTSVLCPlayer = nullptr;
    napi_get_cb_info(env, info, nullptr, nullptr, &arkTSVLCPlayer, nullptr);
    VlcMediaPlayerWrapper *player = nullptr;
    napi_status status = napi_unwrap(env, arkTSVLCPlayer, reinterpret_cast<void **>(&player));
    if (status != napi_ok) {
        LOGE("unwrap VlcMediaPlayerWrapper failed!");
        return nullptr;
    }
    
    bool ret = !!libvlc_media_player_is_seekable(player->instance_);
    napi_value tsRet = nullptr;
    napi_get_boolean(env, ret, &tsRet);
    return tsRet;
}

napi_value VlcMediaPlayerWrapper::SetTime(napi_env env, napi_callback_info info)
{
    napi_value arkTSVLCPlayer = nullptr;
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, &arkTSVLCPlayer, nullptr);

    VlcMediaPlayerWrapper *player = nullptr;
    napi_status status = napi_unwrap(env, arkTSVLCPlayer, reinterpret_cast<void **>(&player));
    if (status != napi_ok) {
        LOGE("unwrap VlcMediaPlayerWrapper failed!");
        return nullptr;
    }
    
    uint64_t time = 0;
    napi_get_value_bigint_uint64(env, args[0], &time, nullptr);
    libvlc_media_player_set_time(player->instance_, time);
    return nullptr;
}

napi_value VlcMediaPlayerWrapper::GetTime(napi_env env, napi_callback_info info)
{
    napi_value arkTSVLCPlayer = nullptr;
    napi_get_cb_info(env, info, nullptr, nullptr, &arkTSVLCPlayer, nullptr);
    VlcMediaPlayerWrapper *player = nullptr;
    napi_status status = napi_unwrap(env, arkTSVLCPlayer, reinterpret_cast<void **>(&player));
    if (status != napi_ok) {
        LOGE("unwrap VlcMediaPlayerWrapper failed!");
        return nullptr;
    }
    uint64_t time = libvlc_media_player_get_time(player->instance_);
    napi_value tsRet = nullptr;
    napi_create_bigint_uint64(env, time, &tsRet);
    return tsRet;
}

napi_value VlcMediaPlayerWrapper::SetPosition(napi_env env, napi_callback_info info)
{
    napi_value arkTSVLCPlayer = nullptr;
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, &arkTSVLCPlayer, nullptr);

    VlcMediaPlayerWrapper *player = nullptr;
    napi_status status = napi_unwrap(env, arkTSVLCPlayer, reinterpret_cast<void **>(&player));
    if (status != napi_ok) {
        LOGE("unwrap VlcMediaPlayerWrapper failed!");
        return nullptr;
    }
    
    double pos = 0;
    napi_get_value_double(env, args[0], &pos);
    libvlc_media_player_set_position(player->instance_, pos);
    return nullptr;
}

napi_value VlcMediaPlayerWrapper::GetPosition(napi_env env, napi_callback_info info)
{
    napi_value arkTSVLCPlayer = nullptr;
    napi_get_cb_info(env, info, nullptr, nullptr, &arkTSVLCPlayer, nullptr);
    VlcMediaPlayerWrapper *player = nullptr;
    napi_status status = napi_unwrap(env, arkTSVLCPlayer, reinterpret_cast<void **>(&player));
    if (status != napi_ok) {
        LOGE("unwrap VlcMediaPlayerWrapper failed!");
        return nullptr;
    }
    float pos = libvlc_media_player_get_position(player->instance_);
    napi_value tsRet = nullptr;
    napi_create_double(env, pos, &tsRet);
    return tsRet;
}

napi_value VlcMediaPlayerWrapper::GetRate(napi_env env, napi_callback_info info)
{
    napi_value arkTSVLCPlayer = nullptr;
    napi_get_cb_info(env, info, nullptr, nullptr, &arkTSVLCPlayer, nullptr);
    VlcMediaPlayerWrapper *player = nullptr;
    napi_status status = napi_unwrap(env, arkTSVLCPlayer, reinterpret_cast<void **>(&player));
    if (status != napi_ok) {
        LOGE("unwrap VlcMediaPlayerWrapper failed!");
        return nullptr;
    }
    float rate = libvlc_media_player_get_rate(player->instance_);
    napi_value tsRet = nullptr;
    napi_create_double(env, rate, &tsRet);
    return tsRet;
}

napi_value VlcMediaPlayerWrapper::SetRate(napi_env env, napi_callback_info info)
{
    napi_value arkTSVLCPlayer = nullptr;
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, &arkTSVLCPlayer, nullptr);

    VlcMediaPlayerWrapper *player = nullptr;
    napi_status status = napi_unwrap(env, arkTSVLCPlayer, reinterpret_cast<void **>(&player));
    if (status != napi_ok) {
        LOGE("unwrap VlcMediaPlayerWrapper failed!");
        return nullptr;
    }
    
    double rate = 0;
    napi_get_value_double(env, args[0], &rate);
    int ret = libvlc_media_player_set_rate(player->instance_, rate);
    napi_value tsRet = nullptr;
    napi_create_int32(env, ret, &tsRet);
    return tsRet;
}

napi_value VlcMediaPlayerWrapper::Export(napi_env env, napi_value exports)
{
    napi_property_descriptor classProp[] = {
        {"setMedia", nullptr, VlcMediaPlayerWrapper::SetMedia, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setVideoOut", nullptr, VlcMediaPlayerWrapper::SetVideoOut, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"play", nullptr, VlcMediaPlayerWrapper::Play, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setEventCallback", nullptr, VlcMediaPlayerWrapper::SetEventCallback,
            nullptr, nullptr, nullptr, napi_default, nullptr},
        {"stop", nullptr, VlcMediaPlayerWrapper::Stop, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"pause", nullptr, VlcMediaPlayerWrapper::Pause, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getLength", nullptr, VlcMediaPlayerWrapper::GetLength, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setVolume", nullptr, VlcMediaPlayerWrapper::SetVolume, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getVolume", nullptr, VlcMediaPlayerWrapper::GetVolume, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"addSlave", nullptr, VlcMediaPlayerWrapper::AddSlave, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getState", nullptr, VlcMediaPlayerWrapper::GetState, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setScale", nullptr, VlcMediaPlayerWrapper::SetScale, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"isPlaying", nullptr, VlcMediaPlayerWrapper::IsPlaying, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"isSeekable", nullptr, VlcMediaPlayerWrapper::IsSeekable, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setTime", nullptr, VlcMediaPlayerWrapper::SetTime, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getTime", nullptr, VlcMediaPlayerWrapper::GetTime, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setPosition", nullptr, VlcMediaPlayerWrapper::SetPosition, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getPosition", nullptr, VlcMediaPlayerWrapper::GetPosition, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getRate", nullptr, VlcMediaPlayerWrapper::GetRate, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setRate", nullptr, VlcMediaPlayerWrapper::SetRate, nullptr, nullptr, nullptr, napi_default, nullptr},
    };
    napi_value arkTS = nullptr;
    const char *arkTSName = "VlcMediaPlayer";
    napi_define_class(env, arkTSName, sizeof(arkTSName), VlcMediaPlayerWrapper::VLCMediaPlayerConstructor, nullptr,
                      sizeof(classProp) / sizeof(classProp[0]), classProp, &arkTS);
    napi_set_named_property(env, exports, arkTSName, arkTS);
    return exports;
}