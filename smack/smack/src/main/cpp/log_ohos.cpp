/*
  Copyright (C) 2022 Huawei Device Co., Ltd.

  This software is distributed under a license. The full license
  agreement can be found in the file LICENSE in this distribution.
  This software may not be copied, modified, sold or distributed
  other than expressed in the named license agreement.
  This software is distributed without any warranty.
*/

#include "log.h"

#define LOG_DOMAIN 0x0201
#include <hilog/log.h>

std::list<std::string> Log::logs(65535);

void Log::log(Level level, const char *tag, const char * msg) {
    LogLevel logLevel = LOG_DEBUG;
    switch(level) {
        case VERBOSE:
        case DEBUG:
            logLevel = LOG_DEBUG;
            break;
        case INFO:
            logLevel = LOG_INFO;
            break;
        case WARN:
            logLevel = LOG_WARN;
            break;
        case ERROR:
            logLevel = LOG_ERROR;
            break;
        case FATAL:
            logLevel = LOG_FATAL;
            break;
    }

    OH_LOG_Print(LOG_APP, logLevel, LOG_DOMAIN, tag, msg, 0);
//    saveLog(msg);
}
