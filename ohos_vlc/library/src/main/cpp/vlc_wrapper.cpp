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

#include "vlc_wrapper.h"
#include "ohos_log.h"
#include <hilog/log.h>
#include <string>
#include <map>

void CreateEnum(napi_env env, napi_value exports)
{
    napi_value eventEnum;
    napi_create_object(env, &eventEnum);
    std::map<std::string, libvlc_event_e> states = {
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

    for (const auto& [k, v] : states) {
        napi_value num = nullptr;
        napi_create_int32(env, v, &num);
        napi_set_named_property(env, eventEnum, k.c_str(), num);
    }
    napi_set_named_property(env, exports, "libvlc_event_e", eventEnum);
}


napi_value VlcWrapper::VLCConstructor(napi_env env, napi_callback_info info)
{
    napi_value arkTSVLC = nullptr;
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, &arkTSVLC, nullptr);

    size_t length;
    napi_get_value_string_utf8(env, args[1], nullptr, 0, &length);
    std::string homePath(length, '\0');
    napi_get_value_string_utf8(env, args[1], &homePath[0], length + 1, &length);
    if (!homePath.empty()) {
        setenv("HOME", homePath.c_str(), 1);
    }
    setenv("VLC_DATA_PATH", "/system/usr/share", 1);
    const char **argv = nullptr;
    uint32_t arrayLength = 0;
    napi_get_array_length(env, args[0], &arrayLength);

    if (arrayLength > 0 && arrayLength <= (SIZE_MAX / sizeof(const char *))) {
        argv = (const char **)malloc(arrayLength * sizeof(const char *));
        if (argv == nullptr) {
            return nullptr;
        }
        for (uint32_t i = 0; i < arrayLength; i++) {
            napi_value element;
            napi_get_element(env, args[0], i, &element);
            size_t strLen = 0;
            napi_get_value_string_utf8(env, element, NULL, 0, &strLen);
            if (strLen == 0 || strLen > (SIZE_MAX - 1)) {
                return nullptr;
            }
            char *buf = (char *)malloc(strLen + 1);
            napi_get_value_string_utf8(env, element, buf, strLen + 1, &strLen);
            argv[i] = buf;
        }
    }
    CreateVlcWrapper(argv, arrayLength, env, arkTSVLC);
    return arkTSVLC;
}

void VlcWrapper::CreateVlcWrapper(const char **argv, uint32_t arrayLength, napi_env env, napi_value arkTSVLC)
{
    VlcWrapper* vlc = new VlcWrapper();
    vlc->instance_ = libvlc_new(arrayLength, argv);
    if (argv != nullptr) {
        for (uint32_t i = 0; i < arrayLength; i++) {
            free((const_cast<char*>(argv[i])));
        }
        free(argv);
    }
    if (vlc->instance_ == nullptr) {
        LOGE("libvlc_new failed");
        return;
    }

    napi_status status = napi_wrap(env, arkTSVLC, (void *)vlc,
        [](napi_env env, void *finalize_data, void *finalize_hint) {
            VlcWrapper *cClass = (VlcWrapper *)finalize_data;
            libvlc_release(cClass->instance_);
            delete cClass;
        },
        nullptr, nullptr);
    if (status != napi_ok) {
        delete vlc;
    }
}

napi_value VlcWrapper::Export(napi_env env, napi_value exports)
{
    napi_property_descriptor classProp[] = {};
    napi_value arkTSVLC = nullptr;
    const char *arkTSVLCName = "Vlc";
    napi_define_class(env, arkTSVLCName, sizeof(arkTSVLCName), VlcWrapper::VLCConstructor, nullptr,
                      sizeof(classProp) / sizeof(classProp[0]), classProp, &arkTSVLC);
    napi_set_named_property(env, exports, arkTSVLCName, arkTSVLC);
    CreateEnum(env, exports);
    return exports;
}


