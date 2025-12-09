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

#include "vlc_media_wrapper.h"
#include "vlc_wrapper.h"
#include "ohos_log.h"
#include <string>
#include "vlc/libvlc_media.h"

napi_value VlcMediaWrapper::VLCMediaConstructor(napi_env env, napi_callback_info info)
{
    napi_value arkTS = nullptr;
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, &arkTS, nullptr);

    VlcWrapper *vlc = nullptr;
    napi_status status = napi_unwrap(env, args[0], reinterpret_cast<void **>(&vlc));
    if (status != napi_ok) {
        LOGE("unwrap failed");
        return nullptr;
    }
    size_t length = 0;
    status = napi_get_value_string_utf8(env, args[1], nullptr, 0, &length);
    std::string buffer(length, '\0');
    status = napi_get_value_string_utf8(env, args[1], &buffer[0], length + 1, &length);
    LOGD("buffer = %s", buffer.c_str());

    VlcMediaWrapper* vlcMedia = new VlcMediaWrapper();
    vlcMedia->instance_ = libvlc_media_new_location(vlc->instance_, buffer.c_str());
    if (vlcMedia->instance_ == nullptr) {
        LOGE("libvlc_media_new_location failed");
        delete vlcMedia;
        return nullptr;
    }
    status = napi_wrap(env, arkTS, (void *)vlcMedia,
                       [](napi_env env, void *finalize_data, void *finalize_hint) {
                           VlcMediaWrapper *media = (VlcMediaWrapper *)finalize_data;
                           libvlc_media_release(media->instance_);
                           if (media->tsfn_ != nullptr) {
                               napi_release_threadsafe_function(media->tsfn_, napi_tsfn_abort);
                           }
                           delete media;
                       },
                       nullptr, nullptr);
        if (status != napi_ok) {
        delete vlc;
        return nullptr;
    }
    return arkTS;
}

napi_value VlcMediaWrapper::Parse(napi_env env, napi_callback_info info)
{
    napi_value arkTSMedia = nullptr;
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, &arkTSMedia, nullptr);
    VlcMediaWrapper *media = nullptr;
    napi_status status = napi_unwrap(env, arkTSMedia, reinterpret_cast<void **>(&media));
    if (status != napi_ok) {
        LOGE("unwrap VlcMediaPlayerWrapper failed!");
        return nullptr;
    }
    int32_t flag = libvlc_media_parse_local;
    napi_get_value_int32(env, args[0], &flag);
    int32_t ret = libvlc_media_parse_with_options(media->instance_, (libvlc_media_parse_flag_t)flag, 0);
    napi_value tsRet = nullptr;
    napi_create_int32(env, ret, &tsRet);
    return tsRet;
}
napi_value VlcMediaWrapper::GetDuration(napi_env env, napi_callback_info info)
{
    napi_value arkTSMedia = nullptr;
    napi_get_cb_info(env, info, nullptr, nullptr, &arkTSMedia, nullptr);
    VlcMediaWrapper *media = nullptr;
    napi_status status = napi_unwrap(env, arkTSMedia, reinterpret_cast<void **>(&media));
    if (status != napi_ok) {
        LOGE("unwrap VlcMediaPlayerWrapper failed!");
        return nullptr;
    }
    
    int64_t ret = libvlc_media_get_duration(media->instance_);
    napi_value tsRet = nullptr;
    napi_create_int64(env, ret, &tsRet);
    return tsRet;
}

struct MediaCallbackCtx {
    VlcMediaWrapper* media = nullptr;
    int type = 0;
};

static void CompleteWork(napi_env env, napi_value js_callback, void* context, void* data)
{
    MediaCallbackCtx* ctx = (MediaCallbackCtx*)data;
    napi_value argv[1];
    napi_create_int32(env, ctx->type, &argv[0]);
    napi_call_function(env, nullptr, js_callback, 1, argv, nullptr);
    delete ctx;
}

static void MediaParsedCallback(const libvlc_event_t *event, void *userdata)
{
    VlcMediaWrapper* media = (VlcMediaWrapper*)userdata;
    LOGD("type: %d", event->type);
    MediaCallbackCtx* ctx = new MediaCallbackCtx {
        .media = media,
        .type = event->type,
    };
    napi_call_threadsafe_function(ctx->media->tsfn_, ctx, napi_tsfn_nonblocking);
}

napi_value VlcMediaWrapper::AddListener(napi_env env, napi_callback_info info)
{
    napi_value arkTSMedia = nullptr;
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, &arkTSMedia, nullptr);
    VlcMediaWrapper *media = nullptr;
    napi_status status = napi_unwrap(env, arkTSMedia, reinterpret_cast<void **>(&media));
    if (status != napi_ok) {
        LOGE("unwrap VlcMediaPlayerWrapper failed!");
        return nullptr;
    }
    
    napi_value callbackFun = nullptr;
    napi_get_named_property(env, args[0], "onMediaEventCallback", &callbackFun);
    if (callbackFun == nullptr) {
        return nullptr;
    }
    if (media->tsfn_ != nullptr) {
        napi_release_threadsafe_function(media->tsfn_, napi_tsfn_abort);
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
        CompleteWork,
        &media->tsfn_);

    libvlc_event_manager_t *em = libvlc_media_event_manager(media->instance_);
    libvlc_event_attach(em, libvlc_MediaParsedChanged, MediaParsedCallback, media);
    return nullptr;
}

napi_value VlcMediaWrapper::Export(napi_env env, napi_value exports)
{
    napi_property_descriptor classProp[] = {
        {"addListener", nullptr, VlcMediaWrapper::AddListener, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"parse", nullptr, VlcMediaWrapper::Parse, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getDuration", nullptr, VlcMediaWrapper::GetDuration, nullptr, nullptr, nullptr, napi_default, nullptr},
    };
    napi_value arkTSVLC = nullptr;
    const char *arkTSname = "VlcMedia";
    napi_define_class(env, arkTSname, sizeof(arkTSname), VlcMediaWrapper::VLCMediaConstructor, nullptr,
                      sizeof(classProp) / sizeof(classProp[0]), classProp, &arkTSVLC);
    napi_set_named_property(env, exports, arkTSname, arkTSVLC);
    return exports;
}
