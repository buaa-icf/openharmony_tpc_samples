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

#ifndef OHOSXMPPCLIENT_REGISTRATION_H
#define OHOSXMPPCLIENT_REGISTRATION_H

#include <node_api.h>
#include <string>

napi_value workName = nullptr;
napi_threadsafe_function tsfn;

// 定义线程数据结构体
struct ThreadSafeRoomInfo {
    std::string roomInfo;
};

void CallJsFun(napi_env env, napi_value jsCb, void *context, void *data)
{
    napi_value globalThis;
    napi_status globalStatus = napi_get_global(env, &globalThis);
    if (globalStatus != napi_ok) {
        // 这里要抛出异常
        return;
    }
    napi_value ret;

    napi_value argv = nullptr;

    // 解析参数 data
    ThreadSafeRoomInfo *arg = (ThreadSafeRoomInfo *)data;
    if (arg == nullptr) {
        return;
    }
    napi_create_string_utf8(env, (arg->roomInfo).c_str(), NAPI_AUTO_LENGTH, &argv);
    // 调用 js 回调函数
    napi_call_function(env, globalThis, jsCb, 1, &argv, &ret);
}

void NapiCreateThreadsafe(napi_env env, napi_value js_func, napi_threadsafe_function_call_js call_js_cb)
{
    if (workName == nullptr) {
        napi_create_string_utf8(env, "child_thread", NAPI_AUTO_LENGTH, &workName);
    }
    napi_create_threadsafe_function(env, js_func, nullptr, workName, 0, 1, nullptr, nullptr, nullptr, call_js_cb,
                                    &tsfn);
}

void NapiJsCallBack(void* data)
{
    napi_status status = napi_acquire_threadsafe_function(tsfn);
    if (status != napi_ok) {
        return;
    }
    // 调用主线程函数，传入 Data
    napi_status cb_status = napi_call_threadsafe_function(tsfn, data, napi_tsfn_blocking);
    if (cb_status != napi_ok) {
        return;
    }
}

#endif // ohos_smack_napiThreadsafeUtil_H
