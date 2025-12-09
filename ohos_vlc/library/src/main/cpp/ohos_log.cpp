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
#include <hilog/log.h>
#include "securec.h"

void OhosLogPrint(LogLevel level, const char *tag, const char *fmt, ...)
{
    char buf[OHOS_LOG_BUF_SIZE] = {0};
    va_list arg;
    va_start(arg, fmt);
    if (vsnprintf_s(buf, OHOS_LOG_BUF_SIZE, OHOS_LOG_BUF_SIZE - 1, fmt, arg) == -1) {
        va_end(arg);
        return;
    }
    OH_LOG_Print(LOG_APP, level, LOG_DOMAIN, tag, "%{public}s", buf);
    va_end(arg);
}