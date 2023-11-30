/*
  Copyright (C) 2022 Huawei Device Co., Ltd.

  This software is distributed under a license. The full license
  agreement can be found in the file LICENSE in this distribution.
  This software may not be copied, modified, sold or distributed
  other than expressed in the named license agreement.
  This software is distributed without any warranty.
*/

#include "log.h"
#include <android/log.h>

std::list<std::string> Log::logs(10);

void Log::log(Level level, const char *tag, const char * msg) {
    int logLevel = ANDROID_LOG_VERBOSE;
    switch(level) {
        case VERBOSE:
            logLevel = ANDROID_LOG_VERBOSE;
            break;
        case DEBUG:
            logLevel = ANDROID_LOG_DEBUG;
            break;
        case INFO:
            logLevel = ANDROID_LOG_INFO;
            break;
        case WARN:
            logLevel = ANDROID_LOG_WARN;
            break;
        case ERROR:
            logLevel = ANDROID_LOG_ERROR;
            break;
        case FATAL:
            logLevel = ANDROID_LOG_FATAL;
            break;
    }

    __android_log_write(logLevel, tag, msg);
//    saveLog(msg);
}
