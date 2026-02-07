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
#include "ohos_utils/napi_handler.h"
#include "xlog_napi_napi.h"

#include <cstdio>
#include <string>
#include <hilog/log.h>

#include "mars/comm/xlogger/xloggerbase.h"
#include "mars/comm/xlogger/loginfo_extract.h"
#include "mars/comm/autobuffer.h"

namespace mars {
namespace xlog {
void ConsoleLog(const XLoggerInfo *info, const char *log)
{
    if (info) {
        const char *filename = ExtractFileName(info->filename);
        const char *strFuncName = NULL == info->func_name ? "" : info->func_name;

        LogLevel level = LOG_INFO;
        switch (info->level) {
            case kLevelDebug:
                level = LOG_DEBUG;
                break;
            case kLevelWarn:
                level = LOG_WARN;
                break;
            case kLevelError:
                level = LOG_ERROR;
                break;
            case kLevelFatal:
                level = LOG_FATAL;
                break;
            case kLevelNone:
            case kLevelVerbose:
            case kLevelInfo:
                level = LOG_INFO;
                break;
        }
        OH_LOG_Print(
            LOG_APP, level, LOG_DOMAIN, info->tag ? info->tag : "xlog",
            "[%{public}s:%{public}d, %{public}s]:%{public}s", filename, info->line, strFuncName,
            log ? log : "NULL==log!!!");
    } else {
        OH_LOG_Print(LOG_APP, LOG_WARN, LOG_DOMAIN, "xlog", "%{public}s", log ? log : "NULL==log!!!");
    }
}

} // namespace xlog
} // namespace mars

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    NapiModuleHandler::AddModule("Xlog_napi", new Xlog_napiNapi(env, exports));
    return exports;
}
EXTERN_C_END
static napi_module demoModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "xlog_napi",
    .nm_priv = ((void *)0)};
extern "C" __attribute__((constructor)) void RegisterModule(void)
{
    napi_module_register(&demoModule);
}
