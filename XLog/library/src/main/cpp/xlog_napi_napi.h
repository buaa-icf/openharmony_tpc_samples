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
#ifndef XLOG_NAPI_XLOG_NAPI_NAPI_H
#define XLOG_NAPI_XLOG_NAPI_NAPI_H
#include <ohos_utils/napi_handler.h>
#include <ohos_utils/napi_module_handler.h>
#include "mars/comm/xlogger/xlogger.h"
#include "mars/comm/xlogger/xloggerbase.h"
#include "mars/log/xlogger_interface.h"

typedef struct {
    int32_t level;
    mars::xlog::XLogConfig config;
} NapiXlogConfig;

class Xlog_napiNapi : public NapiModuleHandler {
public:
    Xlog_napiNapi(napi_env env, napi_value exports) : NapiModuleHandler(env, exports) {}
    void ExportStub() override;
    static XLoggerInfo ParseXLoggerInfo(napi_env env, const napi_value &obj);
    static NapiXlogConfig ParseXLogConfig(napi_env env, const napi_value &obj);
    static napi_value native_logWrite(napi_env env, napi_callback_info info);
    static napi_value native_logWrite2(napi_env env, napi_callback_info info);
    static napi_value native_setLogLevel(napi_env env, napi_callback_info info);
    static napi_value native_getLogLevel(napi_env env, napi_callback_info info);
    static napi_value native_setAppenderMode(napi_env env, napi_callback_info info);
    static napi_value native_getXlogInstance(napi_env env, napi_callback_info info);
    static napi_value native_releaseXlogInstance(napi_env env, napi_callback_info info);
    static napi_value native_newXlogInstance(napi_env env, napi_callback_info info);
    static napi_value native_setConsoleLogOpen(napi_env env, napi_callback_info info);
    static napi_value native_appenderOpen(napi_env env, napi_callback_info info);
    static napi_value native_appenderClose(napi_env env, napi_callback_info info);
    static napi_value native_setMaxFileSize(napi_env env, napi_callback_info info);
    static napi_value native_appenderFlush(napi_env env, napi_callback_info info);
    static napi_value native_setMaxAliveTime(napi_env env, napi_callback_info info);
};
#endif
