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
#include "xlog_napi_napi.h"
#include <string>

#define LONGTHREADID2INT(a) (((a) >> 32) ^ (((a) & 0xFFFF)))

#define CHECK_LOG_INSTANCE(log_instance, ret)              \
    if ((log_instance) <= 0) {                             \
        LOGE("log instance is illegal, %d", log_instance); \
        return ret;                                        \
    }

XLoggerInfo Xlog_napiNapi::ParseXLoggerInfo(napi_env env, const napi_value &obj)
{
    NapiHandler napiHandler(env);
    XLoggerInfo result;
    result.level = (TLogLevel)napiHandler.GetObjectProp<int32_t>(obj, "level");
    result.tag = strdup(napiHandler.GetObjectProp<std::string>(obj, "tag").c_str());
    result.filename = strdup(napiHandler.GetObjectProp<std::string>(obj, "filename").c_str());
    result.func_name = strdup(napiHandler.GetObjectProp<std::string>(obj, "funcname").c_str());
    result.line = napiHandler.GetObjectProp<int32_t>(obj, "line");
    result.pid = napiHandler.GetObjectProp<int32_t>(obj, "pid");
    result.tid = LONGTHREADID2INT(napiHandler.GetObjectProp<int32_t>(obj, "tid"));
    result.maintid = LONGTHREADID2INT(napiHandler.GetObjectProp<int32_t>(obj, "maintid"));
    return result;
}

NapiXlogConfig Xlog_napiNapi::ParseXLogConfig(napi_env env, const napi_value &obj)
{
    NapiHandler napiHandler(env);
    NapiXlogConfig result;
    result.level = (TLogLevel)napiHandler.GetObjectProp<int32_t>(obj, "level");
    result.config.mode_ = (mars::xlog::TAppenderMode)napiHandler.GetObjectProp<int32_t>(obj, "mode");
    result.config.logdir_ = napiHandler.GetObjectProp<std::string>(obj, "logdir");
    result.config.nameprefix_ = napiHandler.GetObjectProp<std::string>(obj, "nameprefix");
    result.config.pub_key_ = napiHandler.GetObjectProp<std::string>(obj, "pubkey");
    result.config.compress_mode_ = (mars::xlog::TCompressMode)napiHandler.GetObjectProp<int32_t>(obj, "compressmode");
    result.config.compress_level_ = napiHandler.GetObjectProp<int32_t>(obj, "compresslevel");
    result.config.cachedir_ = napiHandler.GetObjectProp<std::string>(obj, "cachedir");
    result.config.cache_days_ = napiHandler.GetObjectProp<int32_t>(obj, "cachedays");
    return result;
}

napi_value Xlog_napiNapi::native_logWrite(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_2);
    XLoggerInfo logInfo =
        napiHandler.ParseArgAs<XLoggerInfo>(INDEX_0, [&](const napi_env env, const napi_value &obj) -> XLoggerInfo {
            return Xlog_napiNapi::ParseXLoggerInfo(env, obj);
        });
    std::string log = napiHandler.ParseArgAs<std::string>(INDEX_1);
    bool ret = false;
    if (xlogger_IsEnabledFor((TLogLevel)logInfo.level)) {
        gettimeofday(&logInfo.timeval, NULL);
        xlogger_Write(&logInfo, log.c_str());
        ret = true;
    }

    if (logInfo.filename) {
        free((void *)logInfo.filename);
    }
    if (logInfo.func_name) {
        free((void *)logInfo.func_name);
    }
    if (logInfo.tag) {
        free((void *)logInfo.tag);
    }
    return napiHandler.GetNapiValue<bool>(ret);
}

napi_value Xlog_napiNapi::native_logWrite2(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_3);
    int64_t logInstancePtr = napiHandler.ParseArgAs<int64_t>(INDEX_0);
    CHECK_LOG_INSTANCE(logInstancePtr, napiHandler.GetNapiValue<bool>(false));

    XLoggerInfo logInfo =
        napiHandler.ParseArgAs<XLoggerInfo>(INDEX_1, [&](const napi_env env, const napi_value &obj) -> XLoggerInfo {
            return Xlog_napiNapi::ParseXLoggerInfo(env, obj);
        });
    gettimeofday(&logInfo.timeval, NULL);
    std::string log = napiHandler.ParseArgAs<std::string>(INDEX_2);
    bool ret = false;
    if (mars::xlog::IsEnabledFor(logInstancePtr, (TLogLevel)logInfo.level)) {
        ret = true;
        mars::xlog::XloggerWrite(logInstancePtr, &logInfo, log == "" ? "NULL == log" : log.c_str());
    }
    if (logInfo.filename) {
        free((void *)logInfo.filename);
    }
    if (logInfo.func_name) {
        free((void *)logInfo.func_name);
    }
    if (logInfo.tag) {
        free((void *)logInfo.tag);
    }
    return napiHandler.GetNapiValue<bool>(ret);
}

napi_value Xlog_napiNapi::native_setLogLevel(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_2);
    int64_t logInstancePtr = napiHandler.ParseArgAs<int64_t>(INDEX_0);
    int32_t level = napiHandler.ParseArgAs<int32_t>(INDEX_1);

    CHECK_LOG_INSTANCE(logInstancePtr, napiHandler.GetNapiValue<bool>(false));
    mars::xlog::SetLevel(logInstancePtr, (TLogLevel)level);
    return napiHandler.GetNapiValue<bool>(true);
    ;
}

napi_value Xlog_napiNapi::native_getLogLevel(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_1);
    int64_t logInstancePtr = napiHandler.ParseArgAs<int64_t>(INDEX_0);

    CHECK_LOG_INSTANCE(logInstancePtr, napiHandler.GetNapiValue<int32_t>(0));
    int32_t level = mars::xlog::GetLevel(logInstancePtr);
    return napiHandler.GetNapiValue<int32_t>(level);
}

napi_value Xlog_napiNapi::native_setAppenderMode(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_2);
    int64_t logInstancePtr = napiHandler.ParseArgAs<int64_t>(INDEX_0);
    int32_t mode = napiHandler.ParseArgAs<int32_t>(INDEX_1);

    CHECK_LOG_INSTANCE(logInstancePtr, napiHandler.GetNapiValue<bool>(false));
    mars::xlog::SetAppenderMode(logInstancePtr, (mars::xlog::TAppenderMode)mode);
    return napiHandler.GetNapiValue<bool>(true);
}

napi_value Xlog_napiNapi::native_getXlogInstance(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_1);
    std::string nameprefix = napiHandler.ParseArgAs<std::string>(INDEX_0);

    mars::comm::XloggerCategory *category = mars::xlog::GetXloggerInstance(nameprefix.c_str());
    if (nullptr == category) {
        return napiHandler.GetNapiValue<int64_t>(-1);
    }
    return napiHandler.GetNapiValue<uint64_t>(reinterpret_cast<uintptr_t>(category));
}

napi_value Xlog_napiNapi::native_releaseXlogInstance(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_1);
    std::string nameprefix = napiHandler.ParseArgAs<std::string>(INDEX_0);
    mars::xlog::ReleaseXloggerInstance(nameprefix.c_str());
    return napiHandler.GetNapiValue<bool>(true);
}

napi_value Xlog_napiNapi::native_newXlogInstance(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_1);
    NapiXlogConfig logConfig = napiHandler.ParseArgAs<NapiXlogConfig>(
        INDEX_0, [](const napi_env env, const napi_value &obj) -> NapiXlogConfig {
            return Xlog_napiNapi::ParseXLogConfig(env, obj);
        });

    mars::comm::XloggerCategory *category =
        mars::xlog::NewXloggerInstance(logConfig.config, (TLogLevel)logConfig.level);
    if (nullptr == category) {
        LOGE("NewXloggerInstance failed");
        return napiHandler.GetNapiValue<int64_t>(-1);
    }
    return napiHandler.GetNapiValue<uint64_t>(reinterpret_cast<uintptr_t>(category));
}

napi_value Xlog_napiNapi::native_setConsoleLogOpen(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_2);
    int64_t logInstancePtr = napiHandler.ParseArgAs<int64_t>(INDEX_0);
    bool isOpen = napiHandler.ParseArgAs<bool>(INDEX_1);

    CHECK_LOG_INSTANCE(logInstancePtr, napiHandler.GetNapiValue<bool>(false));
    mars::xlog::SetConsoleLogOpen(logInstancePtr, isOpen);

    return napiHandler.GetNapiValue<bool>(true);
}

napi_value Xlog_napiNapi::native_appenderOpen(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_1);
    NapiXlogConfig logConfig = napiHandler.ParseArgAs<NapiXlogConfig>(
        INDEX_0, [](const napi_env env, const napi_value &obj) -> NapiXlogConfig {
            return Xlog_napiNapi::ParseXLogConfig(env, obj);
        });
    appender_open(logConfig.config);
    xlogger_SetLevel((TLogLevel)logConfig.level);
    return napiHandler.GetNapiValue<bool>(true);
}

napi_value Xlog_napiNapi::native_appenderClose(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_0);
    mars::xlog::appender_close();
    return napiHandler.GetVoidValue();
}

napi_value Xlog_napiNapi::native_setMaxFileSize(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_2);
    int64_t logInstancePtr = napiHandler.ParseArgAs<int64_t>(INDEX_0);
    int32_t aliveSeconds = napiHandler.ParseArgAs<int32_t>(INDEX_1);

    CHECK_LOG_INSTANCE(logInstancePtr, napiHandler.GetNapiValue<bool>(false));
    mars::xlog::SetMaxFileSize(logInstancePtr, aliveSeconds);
    return napiHandler.GetNapiValue<bool>(true);
}

napi_value Xlog_napiNapi::native_appenderFlush(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_2);
    int64_t logInstancePtr = napiHandler.ParseArgAs<int64_t>(INDEX_0);
    bool isSync = napiHandler.ParseArgAs<bool>(INDEX_1);

    CHECK_LOG_INSTANCE(logInstancePtr, napiHandler.GetNapiValue<bool>(false));
    mars::xlog::Flush(logInstancePtr, isSync);

    return napiHandler.GetNapiValue<bool>(true);
}

napi_value Xlog_napiNapi::native_setMaxAliveTime(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_2);
    int64_t logInstancePtr = napiHandler.ParseArgAs<int64_t>(INDEX_0);
    int32_t aliveSeconds = napiHandler.ParseArgAs<int32_t>(INDEX_1);
    CHECK_LOG_INSTANCE(logInstancePtr, napiHandler.GetNapiValue<bool>(false));
    mars::xlog::SetMaxAliveTime(logInstancePtr, aliveSeconds);

    return napiHandler.GetNapiValue<bool>(false);
}

void Xlog_napiNapi::ExportStub()
{
    std::vector<napi_property_descriptor> desc = {
        DECLARE_NAPI_FUNCTION("native_logWrite", Xlog_napiNapi::native_logWrite),
        DECLARE_NAPI_FUNCTION("native_logWrite2", Xlog_napiNapi::native_logWrite2),
        DECLARE_NAPI_FUNCTION("native_setLogLevel", Xlog_napiNapi::native_setLogLevel),
        DECLARE_NAPI_FUNCTION("native_getLogLevel", Xlog_napiNapi::native_getLogLevel),
        DECLARE_NAPI_FUNCTION("native_setAppenderMode", Xlog_napiNapi::native_setAppenderMode),
        DECLARE_NAPI_FUNCTION("native_getXlogInstance", Xlog_napiNapi::native_getXlogInstance),
        DECLARE_NAPI_FUNCTION("native_releaseXlogInstance", Xlog_napiNapi::native_releaseXlogInstance),
        DECLARE_NAPI_FUNCTION("native_newXlogInstance", Xlog_napiNapi::native_newXlogInstance),
        DECLARE_NAPI_FUNCTION("native_setConsoleLogOpen", Xlog_napiNapi::native_setConsoleLogOpen),
        DECLARE_NAPI_FUNCTION("native_appenderOpen", Xlog_napiNapi::native_appenderOpen),
        DECLARE_NAPI_FUNCTION("native_appenderClose", Xlog_napiNapi::native_appenderClose),
        DECLARE_NAPI_FUNCTION("native_setMaxFileSize", Xlog_napiNapi::native_setMaxFileSize),
        DECLARE_NAPI_FUNCTION("native_appenderFlush", Xlog_napiNapi::native_appenderFlush),
        DECLARE_NAPI_FUNCTION("native_setMaxAliveTime", Xlog_napiNapi::native_setMaxAliveTime),
    };
    ExportProperties(desc);
}