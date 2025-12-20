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

#ifndef OHOS_RIVE_GENERAL_H
#define OHOS_RIVE_GENERAL_H

#include "helpers/render_type.h"
#include "rive/factory.hpp"
#include "rive/file_asset_loader.hpp"
#include <hilog/log.h>
#include <napi/native_api.h>
#include <uv.h>

namespace ohos_rive {

// Print only on debug builds.
#if defined(DEBUG) || defined(LOG)
[[noreturn]] void LogThread();
void CheckEglError(const char *, int);
#endif

// Print only on debug builds.
#if defined(DEBUG) || defined(LOG)
#define RIVE_LOG_TAG "OHOS_RIVE"
#define RIVE_LOG_DOMAIN 0xD0115B0
#define LOGE(...) OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, "OHOS_RIVE", __VA_ARGS__)
#define LOGW(...) OH_LOG_Print(LOG_APP, LOG_WARN, LOG_DOMAIN, "OHOS_RIVE", __VA_ARGS__)
#define LOGD(...) OH_LOG_Print(LOG_APP, LOG_DEBUG, LOG_DOMAIN, "OHOS_RIVE", __VA_ARGS__)
#define LOGI(...) OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, "OHOS_RIVE", __VA_ARGS__)
inline void EGL_ERR_CHECK() { CheckEglError(__FILE__, __LINE__); }
#else
#define LOGE(...)
#define LOGW(...)
#define LOGD(...)
#define LOGI(...)
inline void EGL_ERR_CHECK() {}
#endif

uint64_t Import(napi_env env,
                uint8_t *data,
                int32_t length,
                RendererType rendererType = RendererType::RIVE,
                rive::FileAssetLoader *assetLoader = nullptr);

rive::Alignment GetAlignment(napi_env env, napi_value jsAlignment);
rive::Fit GetFit(napi_env env, napi_value jsFit);
rive::Factory *GetFactory(RendererType rendererType);

std::string NapiStringToString(napi_env env, napi_value jsString);
int32_t SizeTToInt(size_t value);
size_t NapiIntToSizeT(napi_env env, napi_value jsValue);
} // namespace ohos_rive
#endif // OHOS_RIVE_GENERAL_H

