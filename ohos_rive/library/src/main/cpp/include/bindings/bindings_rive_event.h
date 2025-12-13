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

#ifndef OHOS_RIVE_BINDINGS_RIVE_EVENT_H
#define OHOS_RIVE_BINDINGS_RIVE_EVENT_H
#include "rive/event.hpp"
#include <napi/native_api.h>

namespace ohos_rive {
napi_value GetProperties(napi_env env, rive::Event *event);
napi_value RiveOpenURLEventURL(napi_env env, napi_callback_info info);
napi_value RiveOpenURLEventTarget(napi_env env, napi_callback_info info);
napi_value RiveEventName(napi_env env, napi_callback_info info);
napi_value RiveEventType(napi_env env, napi_callback_info info);
napi_value RiveEventProperties(napi_env env, napi_callback_info info);
napi_value RiveEventData(napi_env env, napi_callback_info info);
} // namespace ohos_rive

#endif // OHOS_RIVE_BINDINGS_RIVE_EVENT_H

