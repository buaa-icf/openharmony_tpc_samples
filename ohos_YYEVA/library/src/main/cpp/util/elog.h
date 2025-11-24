//
// Created by Cangwang on 2024/4/12.
//

#pragma once
#ifdef __OHOS__
#include <ohos/napi_handler.h>
#else
#include <jni.h>
#endif
#include <string>
#include <cstdarg> // 用于va_list, va_start, va_end等宏
#include <mutex>

using namespace std;
namespace yyeva {
class ELog {
public:
    ~ELog();

#ifdef __OHOS__
    void setNapiVM(napi_env env)
    {
        napiHandler = NapiHandler(env);
    }

    void setELog(napi_value &_elog)
    {
        elog = napiHandler.ParseArg<napi_ref>(_elog);
    }
#else
    void setJavaVM(JavaVM *_javaVm)
    {
        javaVM = _javaVm;
    };

    void setELog(jobject &_elog)
    {
        elog = _elog;
    };
#endif

    void i(string tagName, char *format, ...);

    void d(string tagName, char *format, ...);

    void e(string tagName, char *format, ...);

    static ELog *get();

    mutex mtx;

private:
    int BUF_MAX_SIZE = 2048;
#ifdef __OHOS__
    ELog(): napiHandler(nullptr) {};
    NapiHandler napiHandler;
    napi_ref elog = nullptr;
#else
    ELog() : javaVM(nullptr) {};
    JavaVM *javaVM;
    jobject elog = nullptr;
#endif

    void log(string level, string tagName, char *format, va_list args);

    void log(string level, string tagName, string msg);

#ifndef __OHOS__
    bool attachCurrentThread(JNIEnv *&env, bool &isNeedDetach);
#endif
};
static once_flag s_init_instance_flag;
static ELog *controller;
} // namespace yyeva
