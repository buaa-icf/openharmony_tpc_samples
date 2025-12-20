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

#ifndef OHOS_RIVE_BINDINGS_COMMAND_QUEUE_EGL_H
#define OHOS_RIVE_BINDINGS_COMMAND_QUEUE_EGL_H
#include "helpers/exception_handler.h"
#include "helpers/factories.h"
#include "helpers/resource.h"
#include "rive/animation/state_machine_instance.hpp"
#include "rive/command_queue.hpp"
#include "rive/command_server.hpp"
#include "rive/file.hpp"
#include <string>

namespace ohos_rive {
napi_value CommandQueueCreateEglContext(napi_env env, napi_callback_info info);
napi_value CommandQueueDeleteEglContext(napi_env env, napi_callback_info info);
napi_value CommandQueueGetEglDisplay(napi_env env, napi_callback_info info);
napi_value CommandQueueCreateEglSurface(napi_env env, napi_callback_info info);
napi_value CommandQueueConstructor(napi_env env, napi_callback_info info);
napi_value CommandQueueDelete(napi_env env, napi_callback_info info);
napi_value CommandQueueLoadFile(napi_env env, napi_callback_info info);
napi_value CommandQueueDeleteFile(napi_env env, napi_callback_info info);
napi_value CommandQueueGetArtboardNames(napi_env env, napi_callback_info info);
napi_value CommandQueueGetStateMachineNames(napi_env env, napi_callback_info info);
napi_value CommandQueueGetViewModelNames(napi_env env, napi_callback_info info);
napi_value CommandQueueGetViewModelInstanceNames(napi_env env, napi_callback_info info);
} // namespace ohos_rive

#endif // OHOS_RIVE_BINDINGS_COMMAND_QUEUE_EGL_H