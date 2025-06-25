//
// Created on 2025/2/17.
//
// Node APIs are not fully supported. To solve the compilation error of the interface cannot be found,
// please include "napi/native_api.h".
#include "DebugLog.h"
#include "pjsip_app.h"
#include "pjsua2/endpoint.hpp"

#ifndef OHOS_PJSIP_PROJECT_PJSIP_LOG_WRITER_H
#define OHOS_PJSIP_PROJECT_PJSIP_LOG_WRITER_H

class PJSIP_Writer : public pj::LogWriter {
public:
    PJSIP_Writer(){};
    ~PJSIP_Writer(){};
    void write(const pj::LogEntry &entry) override { LOGI("%{public}s", entry.msg.c_str()); }
};

#endif // OHOS_PJSIP_PROJECT_PJSIP_LOG_WRITER_H
