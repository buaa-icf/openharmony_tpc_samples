/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
#include "socketio_module_napi.h"
#include <hilog/log.h>

EXTERN_C_START

static napi_property_descriptor classProp[] = {
    {"set_headers", nullptr, SocketIOClient::set_headers, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"set_option", nullptr, SocketIOClient::set_option, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"connect", nullptr, SocketIOClient::connect, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"set_open_listener", nullptr, SocketIOClient::set_open_listener, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"set_fail_listener", nullptr, SocketIOClient::set_fail_listener, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"set_reconnecting_listener", nullptr, SocketIOClient::set_reconnecting_listener, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"set_reconnect_listener", nullptr, SocketIOClient::set_reconnect_listener, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"set_close_listener", nullptr, SocketIOClient::set_close_listener, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"set_socket_open_listener", nullptr, SocketIOClient::set_socket_open_listener, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"set_socket_close_listener", nullptr, SocketIOClient::set_socket_close_listener, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"clear_con_listeners", nullptr, SocketIOClient::clear_con_listeners, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"clear_socket_listeners", nullptr, SocketIOClient::clear_socket_listeners, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"set_reconnect_attempts", nullptr, SocketIOClient::set_reconnect_attempts, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"set_reconnect_delay", nullptr, SocketIOClient::set_reconnect_delay, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"set_reconnect_delay_max", nullptr, SocketIOClient::set_reconnect_delay_max, nullptr, nullptr, nullptr,
     napi_default, nullptr},
    {"set_logs_default", nullptr, SocketIOClient::set_logs_default, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"set_logs_quiet", nullptr, SocketIOClient::set_logs_quiet, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"set_logs_verbose", nullptr, SocketIOClient::set_logs_verbose, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"close", nullptr, SocketIOClient::close, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"sync_close", nullptr, SocketIOClient::sync_close, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"set_proxy_basic_auth", nullptr, SocketIOClient::set_proxy_basic_auth, nullptr, nullptr, nullptr, napi_default,
     nullptr},
    {"opened", nullptr, SocketIOClient::opened, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"get_sessionid", nullptr, SocketIOClient::get_sessionid, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"set_nsp", nullptr, SocketIOClient::set_nsp, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"on", nullptr, SocketIOClient::on, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"on_binary", nullptr, SocketIOClient::on_binary, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"once", nullptr, SocketIOClient::once, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"off", nullptr, SocketIOClient::off, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"off_all", nullptr, SocketIOClient::off_all, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"socket_close", nullptr, SocketIOClient::socket_close, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"on_error", nullptr, SocketIOClient::on_error, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"off_error", nullptr, SocketIOClient::off_error, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"emit", nullptr, SocketIOClient::emit, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"emitAckBinary", nullptr, SocketIOClient::emitAckBinary, nullptr, nullptr, nullptr, napi_default, nullptr},
};

static napi_value Init(napi_env env, napi_value exports)
{
    napi_value client = nullptr;
    const char *classBindName = "client";
    int methodSize = std::end(classProp) - std::begin(classProp);
    napi_define_class(env, classBindName, strlen(classBindName), SocketIOClient::JsConstructor, nullptr, methodSize,
                      classProp, &client);
    napi_set_named_property(env, exports, "newSocketIOClient", client);
    napi_define_properties(env, exports, sizeof(classProp) / sizeof(classProp[0]), classProp);
    
    return exports;
}
EXTERN_C_END

/*
 * Module define
 */
static napi_module coapModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "client_socket_c",
    .nm_priv = ((void *)0),
    .reserved = {0},
};

/*
 * Module register function
 */
extern "C" __attribute__((constructor)) void RegisterModule(void)
{
    napi_module_register(&coapModule);
}
