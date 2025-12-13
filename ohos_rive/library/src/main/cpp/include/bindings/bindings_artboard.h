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

#ifndef OHOS_RIVE_BINDINGS_ARTBOARD_H
#define OHOS_RIVE_BINDINGS_ARTBOARD_H

#include "rive/bindable_artboard.hpp"
#include <napi/native_api.h>
namespace ohos_rive {
#ifdef __cplusplus
extern "C" {
#endif

napi_value ArtboardCppName(napi_env env, napi_callback_info info);
napi_value ArtboardAnimationNameByIndex(napi_env env, napi_callback_info info);
napi_value ArtboardStateMachineNameByIndex(napi_env env, napi_callback_info info);
napi_value ArtboardAnimationByIndex(napi_env env, napi_callback_info info);
napi_value ArtboardAnimationByName(napi_env env, napi_callback_info info);
napi_value ArtboardAnimationCount(napi_env env, napi_callback_info info);
napi_value ArtboardStateMachineByIndex(napi_env env, napi_callback_info info);
napi_value ArtboardStateMachineByName(napi_env env, napi_callback_info info);
napi_value ArtboardStateMachineCount(napi_env env, napi_callback_info info);
napi_value ArtboardInputByNameAtPath(napi_env env, napi_callback_info info);
napi_value ArtboardGetVolume(napi_env env, napi_callback_info info);
napi_value ArtboardSetVolume(napi_env env, napi_callback_info info);
napi_value ArtboardFindTextValueRun(napi_env env, napi_callback_info info);
napi_value ArtboardFindValueOfTextValueRun(napi_env env, napi_callback_info info);
napi_value ArtboardSetValueOfTextValueRun(napi_env env, napi_callback_info info);
napi_value ArtboardFindTextValueRunAtPath(napi_env env, napi_callback_info info);
napi_value ArtboardFindValueOfTextValueRunAtPath(napi_env env, napi_callback_info info);
napi_value ArtboardSetValueOfTextValueRunAtPath(napi_env env, napi_callback_info info);
napi_value ArtboardAdvance(napi_env env, napi_callback_info info);
napi_value ArtboardBounds(napi_env env, napi_callback_info info);
napi_value ArtboardResetArtboardSize(napi_env env, napi_callback_info info);
napi_value ArtboardGetArtboardWidth(napi_env env, napi_callback_info info);
napi_value ArtboardSetArtboardWidth(napi_env env, napi_callback_info info);
napi_value ArtboardGetArtboardHeight(napi_env env, napi_callback_info info);
napi_value ArtboardSetArtboardHeight(napi_env env, napi_callback_info info);
napi_value ArtboardSetViewModelInstance(napi_env env, napi_callback_info info);
napi_value ArtboardDraw(napi_env env, napi_callback_info info);
napi_value ArtboardDrawAligned(napi_env env, napi_callback_info info);
napi_value ArtboardDelete(napi_env env, napi_callback_info info);

#ifdef __cplusplus
}
#endif
} // namespace ohos_rive
#endif // OHOS_RIVE_BINDINGS_ARTBOARD_H