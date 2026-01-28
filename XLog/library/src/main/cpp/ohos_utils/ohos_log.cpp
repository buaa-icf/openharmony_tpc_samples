/*
 * Copyright (C) 2026 Huawei Device Co., Ltd.
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
#include <hilog/log.h>
#include <cstdio>
#include <cstdarg>
#include <string>

void OhosLogPrint(enum OhosLogLevel level, const char *tag, const char *fmt, ...)
{
#ifdef OHOS_LOG_ON
    if (level == IL_SILENT) {
        return;
    }
    char buf[OHOS_LOG_BUF_SIZE] = {0};
    va_list arg;
    va_start(arg, fmt);
    std::vsnprintf(buf, OHOS_LOG_BUF_SIZE - 1, fmt, arg);
    va_end(arg);

    switch (level) {
        case IL_INFO:
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, tag, "%{public}s", buf);
            break;
        case IL_DEBUG:
            OH_LOG_Print(LOG_APP, LOG_DEBUG, LOG_DOMAIN, tag, "%{public}s", buf);
            break;
        case IL_WARN:
            OH_LOG_Print(LOG_APP, LOG_WARN, LOG_DOMAIN, tag, "%{public}s", buf);
            break;
        case IL_ERROR:
            OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, tag, "%{public}s", buf);
            break;
        case IL_FATAL:
            OH_LOG_Print(LOG_APP, LOG_FATAL, LOG_DOMAIN, tag, "%{public}s", buf);
            break;
        default:
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, tag, "%{public}s", buf);
            break;
    }
#endif
}

void OhosLogPrintDebug(enum OhosLogLevel level, const char *tag, const char *file, int line, const char *fmt, ...)
{
#ifdef OHOS_LOG_ON
    char buf[OHOS_LOG_BUF_SIZE] = {0};
    va_list arg;
    va_start(arg, fmt);
    std::vsnprintf(buf, OHOS_LOG_BUF_SIZE - 1, fmt, arg);
    va_end(arg);

    switch (level) {
        case IL_INFO:
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, tag, "%{public}s:%{public}d %{public}s", file, line, buf);
            break;
        case IL_DEBUG:
            OH_LOG_Print(LOG_APP, LOG_DEBUG, LOG_DOMAIN, tag, "%{public}s:%{public}d %{public}s", file, line, buf);
            break;
        case IL_WARN:
            OH_LOG_Print(LOG_APP, LOG_WARN, LOG_DOMAIN, tag, "%{public}s:%{public}d %{public}s", file, line, buf);
            break;
        case IL_ERROR:
            OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, tag, "%{public}s:%{public}d %{public}s", file, line, buf);
            break;
        case IL_FATAL:
            OH_LOG_Print(LOG_APP, LOG_FATAL, LOG_DOMAIN, tag, "%{public}s:%{public}d %{public}s", file, line, buf);
            break;
        default:
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, tag, "%{public}s:%{public}d %{public}s", file, line, buf);
            break;
    }
#endif
}
