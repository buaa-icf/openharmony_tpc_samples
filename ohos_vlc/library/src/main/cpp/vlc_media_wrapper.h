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

#ifndef VLC_MEDIA_WRAPPER_H
#define VLC_MEDIA_WRAPPER_H

#include "vlc_wrapper.h"
#include "vlc/vlc.h"

class VlcMediaWrapper {
public:
    static napi_value Export(napi_env env, napi_value exports);
    static napi_value VLCMediaConstructor(napi_env env, napi_callback_info info);
    static napi_value Parse(napi_env env, napi_callback_info info);
    static napi_value GetDuration(napi_env env, napi_callback_info info);
    static napi_value AddListener(napi_env env, napi_callback_info info);
    
    libvlc_media_t *instance_ {nullptr};
    napi_threadsafe_function tsfn_ { nullptr };
};

#endif // VLC_MEDIA_WRAPPER_H
