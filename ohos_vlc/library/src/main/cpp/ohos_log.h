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

#pragma once

#include <hilog/log.h>

#define OHOS_LOG_TAG    "ohos_vlc"

#define LOGI(fmt, ...) OhosLogPrint(LOG_INFO, OHOS_LOG_TAG, "[%s:%d] " fmt, __FUNCTION__, __LINE__, ##__VA_ARGS__)
#define LOGW(fmt, ...) OhosLogPrint(LOG_WARN, OHOS_LOG_TAG, "[%s:%d] " fmt, __FUNCTION__, __LINE__, ##__VA_ARGS__)
#define LOGE(fmt, ...) OhosLogPrint(LOG_ERROR, OHOS_LOG_TAG, "[%s:%d] " fmt, __FUNCTION__, __LINE__, ##__VA_ARGS__)
#define LOGF(fmt, ...) OhosLogPrint(LOG_FATAL, OHOS_LOG_TAG, "[%s:%d] " fmt, __FUNCTION__, __LINE__, ##__VA_ARGS__)
#define LOGD(fmt, ...) OhosLogPrint(LOG_DEBUG, OHOS_LOG_TAG, "[%s:%d] " fmt, __FUNCTION__, __LINE__, ##__VA_ARGS__)

#define OHOS_LOG_BUF_SIZE (4096)
void OhosLogPrint(LogLevel level, const char* tag, const char* fmt, ...);