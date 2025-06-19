//
// Created on 2025/2/21.
//
// Node APIs are not fully supported. To solve the compilation error of the interface cannot be found,
// please include "napi/native_api.h".

#include "build_class.h"
#include "DebugLog.h"
#include "napi_helper.h"
#include "pjsip_app.h"
#include <native_window/external_window.h>

static const size_t EVENT_LISTENER_ARGC = 2;

napi_value BuildClass::JsConstructor(napi_env env, napi_callback_info info) {
    napi_value jDemo = nullptr;
    size_t argc = 0;
    napi_get_cb_info(env, info, &argc, nullptr, &jDemo, nullptr);
    pjsip::PjsipApp *cDemo = new pjsip::PjsipApp();
    napi_wrap(
        env, jDemo, cDemo,
        // 定义js对象回收时回调函数，用来销毁C++对象，防止内存泄漏
        [](napi_env env, void *finalize_data, void *finalize_hint) {
            pjsip::PjsipApp *cDemo = (pjsip::PjsipApp *)finalize_data;
            delete cDemo;
            cDemo = nullptr;
        },
        nullptr, nullptr);

    return jDemo;
}

napi_value BuildClass::InitPjsip(napi_env env, napi_callback_info info) {
    size_t argc = 0;
    napi_value jDemo = nullptr;
    napi_get_cb_info(env, info, &argc, nullptr, &jDemo, nullptr);
    pjsip::PjsipApp *cDemo = nullptr;
    // 将ArkTS对象转为c对象
    napi_unwrap(env, jDemo, (void **)&cDemo);
    int cResult = cDemo->initPJSIP();
    napi_value jResult;
    napi_create_int32(env, cResult, &jResult);
    return jResult;
}

napi_value BuildClass::MakeCall(napi_env env, napi_callback_info info) {
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_value jDemo = nullptr;
    napi_get_cb_info(env, info, &argc, args, &jDemo, nullptr);
    pjsip::PjsipApp *cDemo = nullptr;
    // 将ArkTS对象转为c对象
    napi_unwrap(env, jDemo, reinterpret_cast<void **>(&cDemo));

    std::string uri = NapiHelper::GetString(env, args[0]);
    cDemo->make_call(uri);
    return nullptr;
}

napi_value BuildClass::ModifyAccount(napi_env env, napi_callback_info info) {
    size_t argc = 4;
    napi_value args[4] = {nullptr};
    napi_value jDemo = nullptr;
    napi_get_cb_info(env, info, &argc, args, &jDemo, nullptr);
    pjsip::PjsipApp *cDemo = nullptr;
    // 将ArkTS对象转为c对象
    napi_unwrap(env, jDemo, reinterpret_cast<void **>(&cDemo));

    std::string idUri = NapiHelper::GetString(env, args[0]);
    std::string registrarUri = NapiHelper::GetString(env, args[1]);
    std::string userName = NapiHelper::GetString(env, args[2]);
    std::string pwd = NapiHelper::GetString(env, args[3]);
    int cResult = cDemo->modifyAccount(idUri, registrarUri, userName, pwd);
    napi_value jResult;
    napi_create_int32(env, cResult, &jResult);
    return jResult;
}

napi_value BuildClass::AddInCallingListener(napi_env env, napi_callback_info info) {
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_value jDemo = nullptr;
    napi_get_cb_info(env, info, &argc, args, &jDemo, nullptr);
    pjsip::PjsipApp *cDemo = nullptr;
    // 将ArkTS对象转为c对象
    napi_unwrap(env, jDemo, reinterpret_cast<void **>(&cDemo));

    napi_value callback = args[0];
    napi_ref inCallingCallBack;
    napi_create_reference(env, callback, 1, &inCallingCallBack);
    cDemo->SetInCallingCallBack(env, inCallingCallBack);
    return nullptr;
}

napi_value BuildClass::AcceptCall(napi_env env, napi_callback_info info) {
    LOGI("onIncomingCall ------->AcceptCall start");
    size_t argc = 0;
    napi_value jDemo = nullptr;
    napi_get_cb_info(env, info, &argc, nullptr, &jDemo, nullptr);
    pjsip::PjsipApp *cDemo = nullptr;
    // 将ArkTS对象转为c对象
    napi_unwrap(env, jDemo, (void **)&cDemo);
    cDemo->accept_call();
    return nullptr;
}

napi_value BuildClass::HandUpCall(napi_env env, napi_callback_info info) {
    LOGI("onIncomingCall ------->HandUpCall start");
    size_t argc = 0;
    napi_value jDemo = nullptr;
    napi_get_cb_info(env, info, &argc, nullptr, &jDemo, nullptr);
    pjsip::PjsipApp *cDemo = nullptr;
    // 将ArkTS对象转为c对象
    napi_unwrap(env, jDemo, (void **)&cDemo);
    cDemo->handUp_call();
    return nullptr;
}

napi_value BuildClass::SetSurfaceID(napi_env env, napi_callback_info info) {
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_value jDemo = nullptr;
    napi_get_cb_info(env, info, &argc, args, &jDemo, nullptr);
    pjsip::PjsipApp *cDemo = nullptr;
    // 将ArkTS对象转为c对象
    napi_unwrap(env, jDemo, reinterpret_cast<void **>(&cDemo));

    std::string surfaceID = NapiHelper::GetString(env, args[0]);
    cDemo->setRemoteSurfaceId(surfaceID);
    return nullptr;
}

napi_value BuildClass::Destroy(napi_env env, napi_callback_info info) {
    LOGI("pjsip ------->Destroy");
    size_t argc = 0;
    napi_value jDemo = nullptr;
    napi_get_cb_info(env, info, &argc, nullptr, &jDemo, nullptr);
    pjsip::PjsipApp *cDemo = nullptr;
    // 将ArkTS对象转为c对象
    napi_unwrap(env, jDemo, (void **)&cDemo);
    cDemo->destroy();
    return nullptr;
}

napi_value BuildClass::AddInCallStateListener(napi_env env, napi_callback_info info) {
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_value jDemo = nullptr;
    napi_get_cb_info(env, info, &argc, args, &jDemo, nullptr);
    pjsip::PjsipApp *cDemo = nullptr;
    // 将ArkTS对象转为c对象
    napi_unwrap(env, jDemo, reinterpret_cast<void **>(&cDemo));

    napi_value callback = args[0];
    napi_ref inCallStateCallBack;
    napi_create_reference(env, callback, 1, &inCallStateCallBack);
    cDemo->SetInCallStateCallBack(env, inCallStateCallBack);
    return nullptr;
}

napi_value BuildClass::Export(napi_env env, napi_value exports) {
    napi_property_descriptor classProp[] = {
        {"init", nullptr, BuildClass::InitPjsip, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"modifyAccount", nullptr, BuildClass::ModifyAccount, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"acceptCall", nullptr, BuildClass::AcceptCall, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"handUpCall", nullptr, BuildClass::HandUpCall, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"makeCall", nullptr, BuildClass::MakeCall, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"addInCallingListener", nullptr, BuildClass::AddInCallingListener, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"addInCallStateListener", nullptr, BuildClass::AddInCallStateListener, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"setSurfaceId", nullptr, BuildClass::SetSurfaceID, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"destroy", nullptr, BuildClass::Destroy, nullptr, nullptr, nullptr, napi_default, nullptr},

    };
    napi_value jDemo = nullptr;
    const char *jDemoName = "PjsipApp";
    napi_define_class(env, jDemoName, sizeof(jDemoName), BuildClass::JsConstructor, nullptr,
                      sizeof(classProp) / sizeof(classProp[0]), classProp, &jDemo);
    napi_set_named_property(env, exports, jDemoName, jDemo);

    return exports;
}