/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef OHOS_LUAARKTS_NAPI_COMMON_H
#define OHOS_LUAARKTS_NAPI_COMMON_H
#include <string>
#include <hilog/log.h>
#include "napi/native_api.h"

extern bool g_bLog; // 日志是否显示

namespace Ohos_LuaArkts {
// 自定义日志
#define DLOGINFOVOID(tag)                                                                                       \
    if (g_bLog) OH_LOG_Print(LOG_APP, LOG_INFO, 0, tag, "func=%{public}s,line=%{public}d,file=%{public}s", \
                __FUNCTION__, __LINE__, \
                GetFileName(__FILE__).c_str())
#define DLOGINFO(tag, content, ...)                                                                                  \
    if (g_bLog) OH_LOG_Print(LOG_APP, LOG_INFO, 0, tag, content ",func=%{public}s,line=%{public}d,file=%{public}s", \
                __VA_ARGS__,   \
                __FUNCTION__, __LINE__, GetFileName(__FILE__).c_str())
#define DLOGINFOCONTENT(tag, content)                                                                                \
    if (g_bLog)  OH_LOG_Print(LOG_APP, LOG_INFO, 0, tag, content ",func=%{public}s,line=%{public}d,file=%{public}s", \
                __FUNCTION__,  \
                __LINE__, GetFileName(__FILE__).c_str())

#define DLOGERROR(tag, content, ...)                                                                                 \
    if (g_bLog)                                                                                                      \
        OH_LOG_Print(LOG_APP, LOG_Error, 0, tag, content ",func=%{public}s,line=%{public}d,file=%{public}s",         \
                     __VA_ARGS__, __FUNCTION__, __LINE__, GetFileName(__FILE__).c_str())

std::string GetFileName(std::string path);
} // namespace Ohos_LuaArkts
#endif // OHOS_LUAARKTS_NAPI_COMMON_H
