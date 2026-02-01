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
#ifdef __cpp_lib_format
#include <format>
#endif

void OhosLogPrint(enum OhosLogLevel level, const char *tag, const char *fmt, ...)
{
#ifdef OHOS_LOG_ON
    if (level == IL_SILENT) {
        return;
    }
    std::string buf;
#ifndef __cpp_lib_format
    return;
#else
    va_list args;
    va_start(args, fmt);
    buf = std::vformat(fmt, std::make_format_args(args));
    va_end(args);
#endif

    switch (level) {
        case IL_INFO:
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, tag, "%{public}s", buf.c_str());
            break;
        case IL_DEBUG:
            OH_LOG_Print(LOG_APP, LOG_DEBUG, LOG_DOMAIN, tag, "%{public}s", buf.c_str());
            break;
        case IL_WARN:
            OH_LOG_Print(LOG_APP, LOG_WARN, LOG_DOMAIN, tag, "%{public}s", buf.c_str());
            break;
        case IL_ERROR:
            OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, tag, "%{public}s", buf.c_str());
            break;
        case IL_FATAL:
            OH_LOG_Print(LOG_APP, LOG_FATAL, LOG_DOMAIN, tag, "%{public}s", buf.c_str());
            break;
        default:
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, tag, "%{public}s", buf.c_str());
            break;
    }
#endif
}

void OhosLogPrintDebug(enum OhosLogLevel level, const char *tag, const char *file, int line, const char *fmt, ...)
{
#ifdef OHOS_LOG_ON
    std::string buf;
#ifndef __cpp_lib_format
    return;
#else
    va_list args;
    va_start(args, fmt);
    buf = std::vformat(fmt, std::make_format_args(args));
    va_end(args);
#endif

    switch (level) {
        case IL_INFO:
            OH_LOG_Print(
                LOG_APP, LOG_INFO, LOG_DOMAIN, tag, "%{public}s:%{public}d %{public}s", file, line, buf.c_str());
            break;
        case IL_DEBUG:
            OH_LOG_Print(
                LOG_APP, LOG_DEBUG, LOG_DOMAIN, tag, "%{public}s:%{public}d %{public}s", file, line, buf.c_str());
            break;
        case IL_WARN:
            OH_LOG_Print(
                LOG_APP, LOG_WARN, LOG_DOMAIN, tag, "%{public}s:%{public}d %{public}s", file, line, buf.c_str());
            break;
        case IL_ERROR:
            OH_LOG_Print(
                LOG_APP, LOG_ERROR, LOG_DOMAIN, tag, "%{public}s:%{public}d %{public}s", file, line, buf.c_str());
            break;
        case IL_FATAL:
            OH_LOG_Print(
                LOG_APP, LOG_FATAL, LOG_DOMAIN, tag, "%{public}s:%{public}d %{public}s", file, line, buf.c_str());
            break;
        default:
            OH_LOG_Print(
                LOG_APP, LOG_INFO, LOG_DOMAIN, tag, "%{public}s:%{public}d %{public}s", file, line, buf.c_str());
            break;
    }
#endif
}
