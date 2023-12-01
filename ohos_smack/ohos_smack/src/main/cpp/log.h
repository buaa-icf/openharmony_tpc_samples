/**
 * Copyright (C) 2023 Huawei Device Co., Ltd.
 *
 * This software is distributed under a license. The full license
 * agreement can be found in the file LICENSE in this distribution.
 * This software may not be copied, modified, sold or distributed
 * other than expressed in the named license agreement.
 *
 * This software is distributed without any warranty.
 */

#ifndef __FILE_LOG_H__
#define __FILE_LOG_H__

#include <list>
#include <sstream>

#define LOGV(...) ((void)Log::v("MYTAG", __VA_ARGS__))
#define LOGI(...) ((void)Log::i("MYTAG", __VA_ARGS__))
#define LOGD(...) ((void)Log::d("MYTAG", __VA_ARGS__))
#define LOGW(...) ((void)Log::w("MYTAG", __VA_ARGS__))
#define LOGE(...) ((void)Log::e("MYTAG", __VA_ARGS__))
#define LOGF(...) ((void)Log::f("MYTAG", __VA_ARGS__))

void handleSubscriptionCall(const std::string &resultStr);
void message_received(const std::string &id, const std::string &msg);
void handleMUCInvitationListener(const std::string &v0);
void message_received_group(const std::string &id, const std::string &msg);
void handleMUCParticipantPresenceListener(const std::string &nike, const std::string &presenceType);

enum class Level {
    VERBOSE,
    INFO,
    DEBUG,
    WARN,
    ERROR,
    FATAL
};

class Log {
public:
    template <typename... Args>
    static inline void v(const char* tag, const char* fmt, Args&&... args)
    {
        std::ostringstream oss;
        ((oss << std::forward<Args>(args)), ...);
        std::string msg = oss.str();
        log(Level::VERBOSE, tag, msg.c_str());
    }

    template <typename... Args>
    static inline void d(const char* tag, const char* fmt, Args&&... args)
    {
        std::ostringstream oss;
        ((oss << std::forward<Args>(args)), ...);
        std::string msg = oss.str();
        log(Level::DEBUG, tag, msg.c_str());
    }

    template <typename... Args>
    static inline void i(const char* tag, const char* fmt, Args&&... args)
    {
        std::ostringstream oss;
        ((oss << std::forward<Args>(args)), ...);
        std::string msg = oss.str();
        log(Level::INFO, tag, msg.c_str());
    }

    template <typename... Args>
    static inline void w(const char* tag, const char* fmt, Args&&... args)
    {
        std::ostringstream oss;
        ((oss << std::forward<Args>(args)), ...);
        std::string msg = oss.str();
        log(Level::WARN, tag, msg.c_str());
    }

    template <typename... Args>
    static inline void e(const char* tag, const char* fmt, Args&&... args)
    {
        std::ostringstream oss;
        ((oss << std::forward<Args>(args)), ...);
        std::string msg = oss.str();
        log(Level::ERROR, tag, msg.c_str());
    }

    template <typename... Args>
    static inline void f(const char* tag, const char* fmt, Args&&... args)
    {
        std::ostringstream oss;
        ((oss << std::forward<Args>(args)), ...);
        std::string msg = oss.str();
        log(Level::FATAL, tag, msg.c_str());
    }

    static inline const std::list<std::string> &getLogs()
    {
        return logs;
    }

    static inline void saveLog(const char *log)
    {
        while (logs.size()>=logs.max_size()) {
            logs.pop_front();
        }
        logs.push_back(log);
    }

private:

    static void log(Level level, const char *tag, const char *msg);

    static std::list<std::string> logs;
};

#endif // __FILE_LOG_H__
