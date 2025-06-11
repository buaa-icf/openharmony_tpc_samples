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
#include "ohos_log.h"
#include <cstdio>
#include <hilog/log.h>
#include <stdio.h>    // 必须包含，声明 vsnprintf

bool g_ohosLogOn = true;
void OhosLogPrint(enum LibsshLogLevel level, const char *tag, const char *fmt, ...)
{
    if (!g_ohosLogOn) {
        return;
    }
    char buf[OHOS_LOG_BUF_SIZE] = {0};
    va_list arg;
    va_start(arg, fmt);
    vsnprintf(buf, OHOS_LOG_BUF_SIZE, fmt, arg);
    if (level == IL_INFO) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, tag, "%{public}s", buf);
    } else if (level == IL_DEBUG) {
        OH_LOG_Print(LOG_APP, LOG_DEBUG, LOG_DOMAIN, tag, "%{public}s", buf);
    } else if (level == LOG_WARN) {
        OH_LOG_Print(LOG_APP, LOG_WARN, LOG_DOMAIN, tag, "%{public}s", buf);
    } else if (level == IL_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, tag, "%{public}s", buf);
    } else if (level == IL_FATAL) {
        OH_LOG_Print(LOG_APP, LOG_FATAL, LOG_DOMAIN, tag, "%{public}s", buf);
    } else {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, tag, "%{public}s", buf);
    }
    va_end(arg);
}