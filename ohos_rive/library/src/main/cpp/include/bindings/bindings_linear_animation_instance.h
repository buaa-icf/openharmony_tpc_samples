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

#ifndef OHOS_RIVE_BINDINGS_LINEAR_ANIMATION_INSTANCE_H
#define OHOS_RIVE_BINDINGS_LINEAR_ANIMATION_INSTANCE_H
#include <napi/native_api.h>

EXTERN_C_START

namespace ohos_rive {
napi_value Advance(napi_env env, napi_callback_info info);
napi_value AdvanceAndGetResult(napi_env env, napi_callback_info info);
napi_value Apply(napi_env env, napi_callback_info info);
napi_value GetTime(napi_env env, napi_callback_info info);
napi_value SetTime(napi_env env, napi_callback_info info);
napi_value SetDirection(napi_env env, napi_callback_info info);
napi_value GetDirection(napi_env env, napi_callback_info info);
napi_value GetLoop(napi_env env, napi_callback_info info);
napi_value SetLoop(napi_env env, napi_callback_info info);
napi_value Name(napi_env env, napi_callback_info info);
napi_value Duration(napi_env env, napi_callback_info info);
napi_value Fps(napi_env env, napi_callback_info info);
napi_value WorkStart(napi_env env, napi_callback_info info);
napi_value WorkEnd(napi_env env, napi_callback_info info);
napi_value Delete(napi_env env, napi_callback_info info);
} // namespace ohos_rive

EXTERN_C_END

#endif // OHOS_RIVE_BINDINGS_LINEAR_ANIMATION_INSTANCE_H
