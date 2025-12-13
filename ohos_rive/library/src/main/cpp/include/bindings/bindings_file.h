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

#ifndef OHOS_RIVE_BINDINGS_FILE_H
#define OHOS_RIVE_BINDINGS_FILE_H
#include <napi/native_api.h>

namespace ohos_rive {
napi_value Napi_File_import(napi_env env, napi_callback_info info);
napi_value Napi_File_cppEnums(napi_env env, napi_callback_info info);
napi_value FileCppArtboardByName(napi_env env, napi_callback_info info);
napi_value FileCppDelete(napi_env env, napi_callback_info info);
napi_value FileCppArtboardCount(napi_env env, napi_callback_info info);
napi_value FileCppArtboardByIndex(napi_env env, napi_callback_info info);
napi_value FileCppArtboardNameByIndex(napi_env env, napi_callback_info info);
napi_value FileCppCreateBindableArtboardByName(napi_env env, napi_callback_info info);
napi_value FileCppCreateDefaultBindableArtboard(napi_env env, napi_callback_info info);
napi_value FileCppViewModelCount(napi_env env, napi_callback_info info);
napi_value FileCppViewModelByIndex(napi_env env, napi_callback_info info);
napi_value FileCppViewModelByName(napi_env env, napi_callback_info info);
napi_value FileCppDefaultViewModelForArtboard(napi_env env, napi_callback_info info);
} // namespace ohos_rive

#endif // OHOS_RIVE_BINDINGS_FILE_H

