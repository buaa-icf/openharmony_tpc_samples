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

#include <deque>
#include <map>
#include <node_api.h>
#include <string>
#include "boundscheck/third_party_bounds_checking_function/include/securec.h"
#include "hilog/log.h"
#include "sio_client.h"

// 全局无参回调
napi_value napi_result_void;

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
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, LOG_TAG, "SOCKETIO_TAG------> 2 CallJsEmit %{public}d", status);
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

typedef void (*Finalizer)(napi_env, void *data, void *);
class SocketIOClient {
public:
    SocketIOClient(): clientInstance(nullptr) {};
    ~SocketIOClient() {
        if (clientInstance) {
            delete clientInstance;
            clientInstance = nullptr;
        }
    }
    static napi_value JsConstructor(napi_env env, napi_callback_info info);
    static napi_value set_headers(napi_env env, napi_callback_info info);
    static napi_value set_option(napi_env env, napi_callback_info info);
    static napi_value set_path(napi_env env, napi_callback_info info);
    static napi_value connect(napi_env env, napi_callback_info info);
    static napi_value set_open_listener(napi_env env, napi_callback_info info);
    static napi_value set_fail_listener(napi_env env, napi_callback_info info);
    static napi_value set_reconnecting_listener(napi_env env, napi_callback_info info);
    static napi_value set_reconnect_listener(napi_env env, napi_callback_info info);
    static napi_value set_close_listener(napi_env env, napi_callback_info info);
    static napi_value set_socket_open_listener(napi_env env, napi_callback_info info);
    static napi_value set_socket_close_listener(napi_env env, napi_callback_info info);
    static napi_value clear_con_listeners(napi_env env, napi_callback_info info);
    static napi_value clear_socket_listeners(napi_env env, napi_callback_info info);
    static napi_value set_reconnect_attempts(napi_env env, napi_callback_info info);
    static napi_value set_reconnect_delay(napi_env env, napi_callback_info info);
    static napi_value set_reconnect_delay_max(napi_env env, napi_callback_info info);
    static napi_value set_logs_default(napi_env env, napi_callback_info info);
    static napi_value set_logs_quiet(napi_env env, napi_callback_info info);
    static napi_value set_logs_verbose(napi_env env, napi_callback_info info);
    static napi_value close(napi_env env, napi_callback_info info);
    static napi_value sync_close(napi_env env, napi_callback_info info);
    static napi_value set_proxy_basic_auth(napi_env env, napi_callback_info info);
    static napi_value opened(napi_env env, napi_callback_info info);
    static napi_value get_sessionid(napi_env env, napi_callback_info info);
    static napi_value set_nsp(napi_env env, napi_callback_info info);
    static napi_value on(napi_env env, napi_callback_info info);
    static napi_value on_binary(napi_env env, napi_callback_info info);
    static napi_value once(napi_env env, napi_callback_info info);
    static napi_value off(napi_env env, napi_callback_info info);
    static napi_value off_all(napi_env env, napi_callback_info info);
    static napi_value socket_close(napi_env env, napi_callback_info info);
    static napi_value on_error(napi_env env, napi_callback_info info);
    static napi_value off_error(napi_env env, napi_callback_info info);
    static napi_value emit(napi_env env, napi_callback_info info);
    static napi_value set_connection_mode(napi_env env, napi_callback_info info);
    static napi_value get_current_state(napi_env env, napi_callback_info info);
    static napi_value on_multi(napi_env env, napi_callback_info info);
    sio::socket::ptr get_socket(const std::string& classIdStr) const;

    std::string classIdStr;
    std::string nsp = "";
    std::string path = "";
    std::map<std::string, std::string> headerMap = {};
    std::map<std::string, std::string> optionMap = {};
    sio::client* clientInstance;

    // 实例级别的回调引用
    napi_ref on_open_call_ref = nullptr;
    napi_ref on_fail_call_ref = nullptr; 
    napi_ref on_reconnecting_call_ref = nullptr;
    napi_ref on_reconnect_call_ref = nullptr;
    napi_ref on_socket_open_call_ref = nullptr;
    napi_ref on_socket_close_call_ref = nullptr;
    napi_ref on_close_call_ref = nullptr;
    napi_ref on_error_listener_call_ref = nullptr;

    // 实例级别的TSFN，避免全局TSFN被覆盖
    napi_threadsafe_function tsfnOnOpenCall = nullptr;
    napi_threadsafe_function tsfnFailCall = nullptr;
    napi_threadsafe_function tsfnReconnectingCall = nullptr;
    napi_threadsafe_function tsfnReconnectCall = nullptr;
    napi_threadsafe_function tsfnCloseCall = nullptr;
    napi_threadsafe_function tsfnOnSocketioOpenCall = nullptr;
    napi_threadsafe_function tsfnOnCloseCall = nullptr;
    napi_threadsafe_function tsfnOnErrorCall = nullptr;

    // 实例级别的事件回调映射
    std::map<std::string, napi_ref> on_event_listener_call_aux_ref_map;
    std::map<std::string, napi_ref> on_emit_listener_call_ref_map;
    std::map<std::string, std::deque<napi_threadsafe_function>> on_emit_tsfn_map;

    // 实例级别的once标志
    bool isOnce = false;
};
#endif // ohosXmppClient_room_H