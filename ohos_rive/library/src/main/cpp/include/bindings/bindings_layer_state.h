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

#ifndef OHOS_RIVE_BINDINGS_LAYER_STATE_H
#define OHOS_RIVE_BINDINGS_LAYER_STATE_H
#include <napi/native_api.h>

EXTERN_C_START

namespace ohos_rive {
napi_value LayerStateIsExitState(napi_env env, napi_callback_info info);
napi_value LayerStateIsAnyState(napi_env env, napi_callback_info info);
napi_value LayerStateIsEntryState(napi_env env, napi_callback_info info);
napi_value LayerStateIsAnimationState(napi_env env, napi_callback_info info);
napi_value LayerStateIsBlendState(napi_env env, napi_callback_info info);
napi_value LayerStateIsBlendState1D(napi_env env, napi_callback_info info);
napi_value LayerStateIsBlendStateDirect(napi_env env, napi_callback_info info);
napi_value AnimationStateName(napi_env env, napi_callback_info info);
} // namespace ohos_rive

EXTERN_C_END

#endif // OHOS_RIVE_BINDINGS_LAYER_STATE_H
