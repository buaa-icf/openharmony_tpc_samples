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
#include <stdbool.h>
#ifndef OHOS_UTILS_LOG_H
#define OHOS_UTILS_LOG_H
#include "hitrace/trace.h"

enum OhosLogLevel { IL_INFO, IL_DEBUG, IL_WARN, IL_ERROR, IL_FATAL };

#define LOGI(...) __ohos_log_print(IL_INFO, OHOS_LOG_TAG, __VA_ARGS__)
#define LOGW(...) __ohos_log_print(IL_WARN, OHOS_LOG_TAG, __VA_ARGS__)
#define LOGE(...) __ohos_log_print(IL_ERROR, OHOS_LOG_TAG, __VA_ARGS__)
#define LOGF(...) __ohos_log_print(IL_FATAL, OHOS_LOG_TAG, __VA_ARGS__)
#define LOGD(...) __ohos_log_print(IL_DEBUG, OHOS_LOG_TAG, __VA_ARGS__)

#define OHOS_LOG_BUF_SIZE (4096)
#if RELEASE_MODE
// Release模式 直接执行接口
#define HITRACE_NO_RET(tag, exe)                                                                                       \
    do {                                                                                                               \
        exe;                                                                                                           \
    } while (0)
#define HITRACE_RET(tag, exe, ret)                                                                                     \
    do {                                                                                                               \
        ret = exe;                                                                                                     \
    } while (0)
#else
// 无返回值场景
#define HITRACE_NO_RET(tag, exe)                                                                                       \
    do {                                                                                                               \
        static int32_t s_taskId_no_ret = 0;                                                                            \
        int32_t taskId = __sync_fetch_and_add(&s_taskId_no_ret, 1);                                                    \
        OH_HiTrace_StartAsyncTrace(tag, taskId);                                                                       \
        exe;                                                                                                           \
        OH_HiTrace_FinishAsyncTrace(tag, taskId);                                                                      \
    } while (0)

// 带返回值场景
#define HITRACE_RET(tag, exe, ret)                                                                                     \
    do {                                                                                                               \
        static int32_t s_taskId_ret = 0;                                                                               \
        int32_t taskId = __sync_fetch_and_add(&s_taskId_ret, 1);                                                       \
        OH_HiTrace_StartAsyncTrace(tag, taskId);                                                                       \
        ret = exe;                                                                                                     \
        OH_HiTrace_FinishAsyncTrace(tag, taskId);                                                                      \
    } while (0)
#endif
#ifdef __cplusplus
extern "C" {
#endif
void __ohos_log_print(enum OhosLogLevel level, const char *tag, const char *fmt, ...);
void __ohos_log_print_debug(enum OhosLogLevel level, const char *tag, const char *file, int line, const char *fmt, ...);
#ifdef __cplusplus
}
#endif
#endif
