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

#ifndef OHOS_UTILS_LOG_H
#define OHOS_UTILS_LOG_H
#include "hitrace/trace.h"

enum OhosLogLevel { IL_SILENT, IL_INFO, IL_DEBUG, IL_WARN, IL_ERROR, IL_FATAL };

#define LOGI(...) OhosLogPrint(IL_INFO, OHOS_LOG_TAG, __VA_ARGS__)
#define LOGW(...) OhosLogPrint(IL_WARN, OHOS_LOG_TAG, __VA_ARGS__)
#define LOGE(...) OhosLogPrint(IL_ERROR, OHOS_LOG_TAG, __VA_ARGS__)
#define LOGF(...) OhosLogPrint(IL_FATAL, OHOS_LOG_TAG, __VA_ARGS__)
#define LOGD(...) OhosLogPrint(IL_DEBUG, OHOS_LOG_TAG, __VA_ARGS__)

#define OHOS_LOG_BUF_SIZE (4096)
#ifdef __cplusplus
extern "C" {
#endif
void OhosLogPrint(enum OhosLogLevel level, const char *tag, const char *fmt, ...);
void OhosLogPrintDebug(enum OhosLogLevel level, const char *tag, const char *file, int line, const char *fmt, ...);
#ifdef __cplusplus
}
#endif
#endif
