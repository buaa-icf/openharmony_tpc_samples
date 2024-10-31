/**
 *
 * This software is distributed under a license. The full license
 * agreement can be found in the file LICENSE in this distribution.
 * This software may not be copied, modified, sold or distributed
 * other than expressed in the named license agreement.
 *
 * This software is distributed without any warranty.
 */

#ifndef SOCKETIO_MODULE_H
#define SOCKETIO_MODULE_H

#include "napi/native_api.h"
#include "sio_client.h"
#include <string>

typedef void (*Finalizer)(napi_env, void *data, void *);
class SocketIOClient {
public:
    
    ~SocketIOClient() {}

    static napi_value JsConstructor(napi_env env, napi_callback_info info);
    static napi_value set_headers(napi_env env, napi_callback_info info);
    static napi_value set_option(napi_env env, napi_callback_info info);
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
    static napi_value emitAckBinary(napi_env env, napi_callback_info info);
    
    std::string classIdStr;
    std::string nsp = "";
    std::map<std::string, std::string> g_headerMap = {};
    std::map<std::string, std::string> g_optionMap = {};
    sio::client clientInstance;
};

#endif // SOCKETIO_MODULE_H