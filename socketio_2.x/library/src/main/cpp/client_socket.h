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

#ifndef OHOSXMPPCLIENT_ROOM_H
#define OHOSXMPPCLIENT_ROOM_H

#include <node_api.h>
#include <string>
#include "boundscheck/third_party_bounds_checking_function/include/securec.h"
#include "hilog/log.h"

// 全局无参回调
napi_value napi_result_void;

napi_threadsafe_function g_tsfnOnOpenCall;
napi_threadsafe_function g_tsfnOnCloseCall;
napi_threadsafe_function g_tsfnOnSocketioOpenCall;
napi_threadsafe_function g_tsfnEmitCall;
napi_threadsafe_function g_tsfnOnErrorCall;
napi_threadsafe_function g_tsfnFailCall;
napi_threadsafe_function g_tsfnReconnectingCall;
napi_threadsafe_function g_tsfnReconnectCall;
napi_threadsafe_function g_tsfnCloseCall;

napi_value workName = nullptr;

struct ThreadSafeInfo {
    std::string result;
};

struct BinaryInfo {
    std::string result;
};

void NapiCreateThreadsafe(napi_env env, napi_value js_func, napi_threadsafe_function_call_js call_js_cb,
                          napi_threadsafe_function* result)
{
    if (workName == nullptr) {
        napi_create_string_utf8(env, "main_thread", NAPI_AUTO_LENGTH, &workName);
    }
    napi_create_threadsafe_function(env, js_func, nullptr, workName, 0, 1, nullptr, nullptr, nullptr,
                                    call_js_cb, result);
}

void CallJsNoParames(napi_env env, napi_value jsCb, void *context, void *data)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, LOG_TAG, "SOCKETIO_TAG------> 0 CallJsOpen ");
    napi_value undefined;
    napi_status undefinedStatus = napi_get_undefined(env, &undefined);
    if (undefinedStatus != napi_ok) {
        return;
    }

    napi_value argv;
    napi_status nullStatus = napi_get_null(env, &argv);
    if (nullStatus != napi_ok) {
        return;
    }

    // 调用 js 回调函数
    napi_status status = napi_call_function(env, undefined, jsCb, 0, &argv, &napi_result_void);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, LOG_TAG, "SOCKETIO_TAG------> 1 CallJsOpen %{public}d", status);
}

void CallJsEmit(napi_env env, napi_value jsCb, void *context, void *data)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, LOG_TAG, "SOCKETIO_TAG------> 0 CallJsEmit ");
    napi_value undefined;
    napi_status undefinedStatus = napi_get_undefined(env, &undefined);
    if (undefinedStatus != napi_ok) {
        return;
    }
    napi_value ret;
    napi_value argv;
    
    std::unique_ptr<ThreadSafeInfo> arg(static_cast<ThreadSafeInfo*>(data));
    if (arg == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, LOG_TAG, "[CallJsEmit]ThreadSafeInfo is null");
        return;
    }

    napi_create_string_utf8(env, (arg->result).c_str(), NAPI_AUTO_LENGTH, &argv);
    
    // 调用 js 回调函数
    napi_status status = napi_call_function(env, undefined, jsCb, 1, &argv, &ret);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, "LOG_TAG", "SOCKETIO_TAG------> 2 CallJsEmit %{public}d", status);
}

void CallJsBinary(napi_env env, napi_value jsCb, void *context, void *data)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, LOG_TAG, "SOCKETIO_TAG------> 0 CallJsEmit ");
    napi_value undefined;
    napi_status undefinedStatus = napi_get_undefined(env, &undefined);
    if (undefinedStatus != napi_ok) {
        return;
    }
    napi_value ret;
    napi_value argv;
    
    std::unique_ptr<BinaryInfo> arg(static_cast<BinaryInfo*>(data));
    if (arg == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, LOG_TAG, "[CallJsBinary]BinaryInfo is null");
        return;
    }
    size_t length = arg->result.size();
    
    void *nativePtr = nullptr;
    // 创建一个新的 ArrayBuffer，长度等于字符串的长度
    napi_value arrayBuffer;
    napi_create_arraybuffer(env, length, &nativePtr, &arrayBuffer);
    if (memcpy_s(nativePtr, length, arg->result.data(), length) != EOK) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, "socket.io-client-cpp", "[CallJsBinary]memcpy_s is error");
        return;
    }
    
    napi_typedarray_type arrayType = static_cast<napi_typedarray_type>(napi_uint8_array);
    napi_value typedArray = nullptr;
    napi_create_typedarray(env, arrayType, length, arrayBuffer, 0, &typedArray);
    
    // 调用 js 回调函数
    napi_status status = napi_call_function(env, undefined, jsCb, 1, &typedArray, &ret);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, LOG_TAG, "SOCKETIO_TAG------> 2 CallJsBinary %{public}d", status);
}

#endif // ohosXmppClient_room_H