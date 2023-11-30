/*
  Copyright (C) 2022 Huawei Device Co., Ltd.

  This software is distributed under a license. The full license
  agreement can be found in the file LICENSE in this distribution.
  This software may not be copied, modified, sold or distributed
  other than expressed in the named license agreement.
  This software is distributed without any warranty.
*/

#ifndef __FILE_LOG_H__
#define __FILE_LOG_H__

#include <stdarg.h>
#include <stdio.h>
#include <list>
#include <string>

#ifndef LOG_TAG
    #define LOG_TAG "MYTAG"
#endif

#define LOGV(...) ((void)Log::v(LOG_TAG, __VA_ARGS__))
#define LOGI(...) ((void)Log::i(LOG_TAG, __VA_ARGS__))
#define LOGD(...) ((void)Log::d(LOG_TAG, __VA_ARGS__))
#define LOGW(...) ((void)Log::w(LOG_TAG, __VA_ARGS__))
#define LOGE(...) ((void)Log::e(LOG_TAG, __VA_ARGS__))
#define LOGF(...) ((void)Log::f(LOG_TAG, __VA_ARGS__))

#define FMT_MSG(fmt) \
    char msg[5*1024]; \
    va_list args; \
    va_start(args, fmt); \
    vsprintf(msg, fmt, args); \
    va_end(args);

class Log {
public:
    static inline void v(const char *tag, const char *fmt, ...) {
        FMT_MSG(fmt);
        log(VERBOSE, tag, msg);
    }

    static inline void d(const char *tag, const char *fmt, ...) {
        FMT_MSG(fmt);
        log(DEBUG, tag, msg);
    }

    static inline void i(const char *tag, const char *fmt, ...) {
        FMT_MSG(fmt);
        log(INFO, tag, msg);
    }

    static inline void w(const char *tag, const char *fmt, ...) {
        FMT_MSG(fmt);
        log(WARN, tag, msg);
    }

    static inline void e(const char *tag, const char *fmt, ...) {
        FMT_MSG(fmt);
        log(ERROR, tag, msg);
    }

    static inline void f(const char *tag, const char *fmt, ...) {
        FMT_MSG(fmt);
        log(FATAL, tag, msg);
    }

    static inline const std::list<std::string> &getLogs() {
        return logs;
    }

    static inline void saveLog(const char *log) {
        while(logs.size()>=logs.max_size()) {
            logs.pop_front();
        }
        logs.push_back(log);
    }

private:
    enum Level {
        VERBOSE,
        INFO,
        DEBUG,
        WARN,
        ERROR,
        FATAL
    };

    static void log(Level level, const char *tag, const char *msg);

    static std::list<std::string> logs;
};

#undef FMT_MSG

#endif //__FILE_LOG_H__