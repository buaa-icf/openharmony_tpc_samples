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

#include "napi/native_api.h"
#include "libvlc_wrapper.h"
#include "media_player_wrapper.h"
#include "media_wrapper.h"
#include <ace/xcomponent/native_interface_xcomponent.h>
#include "xcomponent_manager.h"
#include "ohos_log.h"
#include "dialog_wrapper.h"

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    LibVLCWrapper::Export(env, exports);
    MediaPlayerWrapper::Export(env, exports);
    MediaWrapper::Export(env, exports);
    DialogWrapper::Export(env, exports);

    napi_status status;
    napi_value xComponentInstance = nullptr;
    OH_NativeXComponent *nativeXComponent = nullptr;
    status = napi_get_named_property(env, exports, OH_NATIVE_XCOMPONENT_OBJ, &xComponentInstance);
    status = napi_unwrap(env, xComponentInstance, reinterpret_cast<void**>(&nativeXComponent));
    if (status != napi_ok) {
        return exports;
    }

    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;
    uint32_t ret = 0;
    ret = OH_NativeXComponent_GetXComponentId(nativeXComponent, idStr, &idSize);
    if (ret != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        return exports;
    }

    LOGD("SetVideoOut id = %s", idStr);
    std::string strId = std::string(idStr);
    xMgr.AddNativeXcomponent(strId, nativeXComponent);
    xMgr.RegisterCallback(strId);
    return exports;
}
EXTERN_C_END

static napi_module vlc_napi = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "vlc_napi",
    .nm_priv = ((void*)0),
    .reserved = { 0 },
};

extern "C" __attribute__((constructor)) void RegisterLibraryModule(void)
{
    napi_module_register(&vlc_napi);
}
