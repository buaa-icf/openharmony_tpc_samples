/*
 * Copyright (C) 2022 Huawei Device Co., Ltd.
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to all conditions.
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#include "napi/native_api.h"
#include "sio_client.h"
#include "sio_message.h"
#include <js_native_api.h>
#include <js_native_api_types.h>

#include "hilog/log.h"
#define LOG_DOMAIN 0x0201
#define LOG_TAG "CLIENT_SOCKET_C"

#define DECLARE_NAPI_FUNCTION(name, func) \
    { (name), nullptr, (func), nullptr, nullptr, nullptr, napi_default, nullptr }

#define MAX_BUF_SIZE 128

//全局env
napi_env env_global = nullptr;
//client相关回调
napi_ref on_open_call_ref, on_fail_call_ref, on_reconnecting_call_ref, on_reconnect_call_ref, on_close_call_ref, on_socket_open_call_ref, on_socket_close_call_ref;
//根据eventname筛选event回调方法
std::map<std::string, napi_ref> on_event_listener_call_aux_ref_map;
//socket相关回调
napi_ref on_error_listener_call_ref;
//根据eventname筛选ack回调方法
std::map<std::string, napi_ref> on_emit_listener_call_ref_map;
//全局无参回调
napi_value napi_result_void;
//全局result
size_t result = 0;

std::string get_message_value(sio::message::ptr const &message) {
    std::string message_json;
    std::map<std::string, sio::message::ptr> messageMap;
    switch (message->get_flag()) {
    case sio::message::flag_integer:
        return std::to_string(message->get_int());
    case sio::message::flag_double:
        return std::to_string(message->get_double());
    case sio::message::flag_string:
        return std::string("\"") + message->get_string() + "\"";
    case sio::message::flag_binary:
        return std::string("\"") + *message->get_binary() + "\"" + ",\"binary\":true";
    case sio::message::flag_object:
        message_json = "{";
        messageMap = message->get_map();
        for (auto it : messageMap) {
            if (messageMap.begin()->first != it.first) {
                message_json += std::string(",");
            }
            message_json += std::string("\"") + it.first.c_str() + "\":" + get_message_value(it.second);
        }
        message_json += "}";
        return message_json;
    case sio::message::flag_boolean:
        return std::to_string(message->get_bool());
    case sio::message::flag_null:
        return std::string("\"\"");
    default:
        return std::string("\"\"");
    }
}

void handler_event_listener_aux(bool is_once, const std::string &name, sio::message::ptr const &message, bool need_ack, sio::message::list &ack_message) {
    napi_ref on_event_listener_call_aux_ref = on_event_listener_call_aux_ref_map[name.c_str()];
    if (on_event_listener_call_aux_ref != nullptr) {
        std::string message_json = std::string("{") + "\"eventName\":\"" + name + "\"";
        if (message->get_flag() == sio::message::flag_object) {
            std::map<std::string, sio::message::ptr> messageMap = message->get_map();
            for (auto it : messageMap) {
                message_json += std::string(",\"") + it.first.c_str() + "\":" + get_message_value(it.second);
            }
        } else {
            message_json += std::string(",\"") + "message" + "\":" + get_message_value(message);
        }
        message_json += "}";
        napi_value message_json_result;
        napi_create_string_utf8(env_global, message_json.c_str(), message_json.length(), &message_json_result);
        napi_value on_event_listener_call_aux;
        napi_get_reference_value(env_global, on_event_listener_call_aux_ref, &on_event_listener_call_aux);
        napi_call_function(env_global, nullptr, on_event_listener_call_aux, 1, &message_json_result, &napi_result_void);
        if (is_once) {
            on_event_listener_call_aux_ref_map[name.c_str()] = nullptr;
        }
    }
}

class connection_listener {

  public:
    connection_listener() {
    }

    void on_open() {
        if (on_open_call_ref != nullptr) {
            napi_value on_open_call;
            napi_get_reference_value(env_global, on_open_call_ref, &on_open_call);
            napi_call_function(env_global, nullptr, on_open_call, 0, &napi_result_void, &napi_result_void);
        }
    }

    void on_fail() {
        if (on_fail_call_ref != nullptr) {
            napi_value on_fail_call;
            napi_get_reference_value(env_global, on_fail_call_ref, &on_fail_call);
            napi_call_function(env_global, nullptr, on_fail_call, 0, &napi_result_void, &napi_result_void);
        }
    }

    void on_reconnecting() {
        if (on_reconnecting_call_ref != nullptr) {
            napi_value on_reconnecting_call;
            napi_get_reference_value(env_global, on_reconnecting_call_ref, &on_reconnecting_call);
            napi_call_function(env_global, nullptr, on_reconnecting_call, 0, &napi_result_void, &napi_result_void);
        }
    }

    //todo 待回传unsigned两个参数
    void on_reconnect(unsigned, unsigned) {
        if (on_reconnect_call_ref != nullptr) {
            napi_value on_reconnect_call;
            napi_get_reference_value(env_global, on_reconnect_call_ref, &on_reconnect_call);
            napi_call_function(env_global, nullptr, on_reconnect_call, 0, &napi_result_void, &napi_result_void);
        }
    }

    void on_close(sio::client::close_reason const &reason) {
        std::string reasonString = "";
        if (reason == sio::client::close_reason_normal) {
            reasonString = "close_reason_normal";
        } else if (reason == sio::client::close_reason_drop) {
            reasonString = "close_reason_drop";
        }
        napi_value napi_reason;
        napi_create_string_utf8(env_global, reasonString.c_str(), reasonString.length(), &napi_reason);
        if (on_close_call_ref != nullptr) {
            napi_value on_close_call;
            napi_get_reference_value(env_global, on_close_call_ref, &on_close_call);
            napi_call_function(env_global, nullptr, on_close_call, 1, &napi_reason, &napi_result_void);
        }
    }

    void on_socket_open(std::string const &nsp) {
        napi_value napi_nsp;
        napi_create_string_utf8(env_global, nsp.c_str(), nsp.length(), &napi_nsp);
        if (on_socket_open_call_ref != nullptr) {
            napi_value on_socket_open_call;
            napi_get_reference_value(env_global, on_socket_open_call_ref, &on_socket_open_call);
            napi_call_function(env_global, nullptr, on_socket_open_call, 1, &napi_nsp, &napi_result_void);
        }
    }

    void on_socket_close(std::string const &nsp) {
        napi_value napi_nsp;
        napi_create_string_utf8(env_global, nsp.c_str(), nsp.length(), &napi_nsp);
        if (on_socket_close_call_ref != nullptr) {
            napi_value on_socket_close_call;
            napi_get_reference_value(env_global, on_socket_close_call_ref, &on_socket_close_call);
            napi_call_function(env_global, nullptr, on_socket_close_call, 1, &napi_nsp, &napi_result_void);
        }
    }

    void on_event_listener_aux(const std::string &name, sio::message::ptr const &message, bool need_ack, sio::message::list &ack_message) {
        handler_event_listener_aux(false, name, message, need_ack, ack_message);
    }

    void once_event_listener_aux(const std::string &name, sio::message::ptr const &message, bool need_ack, sio::message::list &ack_message) {
        handler_event_listener_aux(true, name, message, need_ack, ack_message);
    }

    void on_error_listener(sio::message::ptr const &message) {
        std::string error_string = "on error";
        napi_value on_error_result;
        napi_create_string_utf8(env_global, error_string.c_str(), error_string.length(), &on_error_result);
        if (on_error_listener_call_ref != nullptr) {
            napi_value on_error_listener_call;
            napi_get_reference_value(env_global, on_error_listener_call_ref, &on_error_listener_call);
            napi_call_function(env_global, nullptr, on_error_listener_call, 1, &on_error_result, &napi_result_void);
        }
    }

    void on_emit_callback(std::string const &ack_name, sio::message::list const &list) {
        napi_ref on_emit_listener_call_ref = on_emit_listener_call_ref_map[ack_name.c_str()];
        if (on_emit_listener_call_ref != nullptr) {
            std::string message_json = std::string("{");
            if (list.at(0)->get_flag() == sio::message::flag_object) {
                std::map<std::string, sio::message::ptr> messageMap = list.at(0)->get_map();
                for (auto it : messageMap) {
                    if (messageMap.begin()->first != it.first) {
                        message_json += std::string(",");
                    }
                    message_json += std::string("\"") + it.first.c_str() + "\":" + get_message_value(it.second);
                }
            } else {
                message_json += std::string("\"") + "message" + "\":" + get_message_value(list.at(0));
            }
            message_json += "}";
            napi_value message_json_result;
            napi_create_string_utf8(env_global, message_json.c_str(), message_json.length(), &message_json_result);
            napi_value on_emit_listener_call;
            napi_get_reference_value(env_global, on_emit_listener_call_ref, &on_emit_listener_call);
            napi_call_function(env_global, nullptr, on_emit_listener_call, 1, &message_json_result, &napi_result_void);
        }
    }
};

static connection_listener l;

static sio::client clientInstance;

static void initEnv(napi_env env) {
    if (env_global == nullptr) {
        env_global = env;
    }
}

//client相关napi接口

static napi_value connect(napi_env env, napi_callback_info info) {
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    char uri[MAX_BUF_SIZE];
    napi_get_value_string_utf8(env, args[0], uri, MAX_BUF_SIZE, &result);
    clientInstance.connect(uri);
    return 0;
}

static napi_value set_open_listener(napi_env env, napi_callback_info info) {
    initEnv(env);
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    napi_value on_open_call = args[0];
    napi_create_reference(env_global, on_open_call, 1, &on_open_call_ref);
    clientInstance.set_open_listener(std::bind(&connection_listener::on_open, &l));
    return 0;
}

static napi_value set_fail_listener(napi_env env, napi_callback_info info) {
    initEnv(env);
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    napi_value on_fail_call = args[0];
    napi_create_reference(env_global, on_fail_call, 1, &on_fail_call_ref);
    clientInstance.set_fail_listener(std::bind(&connection_listener::on_fail, &l));
    return 0;
}

static napi_value set_reconnecting_listener(napi_env env, napi_callback_info info) {
    initEnv(env);
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    napi_value on_reconnecting_call = args[0];
    napi_create_reference(env_global, on_reconnecting_call, 1, &on_reconnecting_call_ref);
    clientInstance.set_reconnecting_listener(std::bind(&connection_listener::on_reconnecting, &l));
    return 0;
}

static napi_value set_reconnect_listener(napi_env env, napi_callback_info info) {
    initEnv(env);
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    napi_value on_reconnect_call = args[0];
    napi_create_reference(env_global, on_reconnect_call, 1, &on_reconnect_call_ref);
    clientInstance.set_reconnect_listener(std::bind(&connection_listener::on_reconnect, &l, std::placeholders::_1, std::placeholders::_2));
    return 0;
}

static napi_value set_close_listener(napi_env env, napi_callback_info info) {
    initEnv(env);
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    napi_value on_close_call = args[0];
    napi_create_reference(env_global, on_close_call, 1, &on_close_call_ref);
    clientInstance.set_close_listener(std::bind(&connection_listener::on_close, &l, std::placeholders::_1));
    return 0;
}

static napi_value set_socket_open_listener(napi_env env, napi_callback_info info) {
    initEnv(env);
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    napi_value on_socket_open_call = args[0];
    napi_create_reference(env_global, on_socket_open_call, 1, &on_socket_open_call_ref);
    clientInstance.set_socket_open_listener(std::bind(&connection_listener::on_socket_open, &l, std::placeholders::_1));
    return 0;
}

static napi_value set_socket_close_listener(napi_env env, napi_callback_info info) {
    initEnv(env);
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    napi_value on_socket_close_call = args[0];
    napi_create_reference(env_global, on_socket_close_call, 1, &on_socket_close_call_ref);
    clientInstance.set_socket_close_listener(std::bind(&connection_listener::on_socket_close, &l, std::placeholders::_1));
    return 0;
}

static napi_value clear_con_listeners(napi_env env, napi_callback_info info) {
    clientInstance.clear_con_listeners();
    return 0;
}

static napi_value clear_socket_listeners(napi_env env, napi_callback_info info) {
    clientInstance.clear_socket_listeners();
    return 0;
}

static napi_value set_reconnect_attempts(napi_env env, napi_callback_info info) {
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    double attempts;
    napi_get_value_double(env, args[0], &attempts);
    clientInstance.set_reconnect_attempts((int)attempts);
    return 0;
}

static napi_value set_reconnect_delay(napi_env env, napi_callback_info info) {
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    double millis;
    napi_get_value_double(env, args[0], &millis);
    clientInstance.set_reconnect_delay((unsigned)millis);
    return 0;
}

static napi_value set_reconnect_delay_max(napi_env env, napi_callback_info info) {
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    double millis;
    napi_get_value_double(env, args[0], &millis);
    clientInstance.set_reconnect_delay_max((unsigned)millis);
    return 0;
}

static napi_value set_logs_default(napi_env env, napi_callback_info info) {
    clientInstance.set_logs_default();
    return 0;
}

static napi_value set_logs_quiet(napi_env env, napi_callback_info info) {
    clientInstance.set_logs_quiet();
    return 0;
}

static napi_value set_logs_verbose(napi_env env, napi_callback_info info) {
    clientInstance.set_logs_verbose();
    return 0;
}

static napi_value close(napi_env env, napi_callback_info info) {
    clientInstance.close();
    return 0;
}

static napi_value sync_close(napi_env env, napi_callback_info info) {
    clientInstance.sync_close();
    return 0;
}

static napi_value set_proxy_basic_auth(napi_env env, napi_callback_info info) {
    size_t argc = 3;
    napi_value args[3] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    char uri[MAX_BUF_SIZE];
    char username[MAX_BUF_SIZE];
    char password[MAX_BUF_SIZE];
    napi_get_value_string_utf8(env, args[0], uri, MAX_BUF_SIZE, &result);
    napi_get_value_string_utf8(env, args[1], username, MAX_BUF_SIZE, &result);
    napi_get_value_string_utf8(env, args[2], password, MAX_BUF_SIZE, &result);
    clientInstance.set_proxy_basic_auth(uri, username, password);
    return 0;
}

static napi_value opened(napi_env env, napi_callback_info info) {
    bool opened = clientInstance.opened();
    napi_value napi_opened;
    napi_get_boolean(env, opened, &napi_opened);
    return napi_opened;
}

static napi_value get_sessionid(napi_env env, napi_callback_info info) {
    std::string sessionid = clientInstance.get_sessionid();
    napi_value napi_sessionid;
    napi_create_string_utf8(env, sessionid.c_str(), MAX_BUF_SIZE, &napi_sessionid);
    return napi_sessionid;
}

//socket相关napi接口

static std::string nsp = "";

static sio::socket::ptr get_socket() {
    if (nsp == "") {
        return clientInstance.socket();
    } else {
        return clientInstance.socket(nsp);
    }
}

static napi_value set_nsp(napi_env env, napi_callback_info info) {
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    char char_nsp[MAX_BUF_SIZE];
    napi_get_value_string_utf8(env, args[0], char_nsp, MAX_BUF_SIZE, &result);
    nsp = char_nsp;
    return 0;
}

static napi_value on(napi_env env, napi_callback_info info) {
    initEnv(env);
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    char event_name[MAX_BUF_SIZE];
    napi_get_value_string_utf8(env, args[0], event_name, MAX_BUF_SIZE, &result);
    napi_value on_event_listener_call_aux = args[1];
    napi_ref on_event_listener_call_aux_ref;
    napi_create_reference(env_global, on_event_listener_call_aux, 1, &on_event_listener_call_aux_ref);
    on_event_listener_call_aux_ref_map.insert({event_name, on_event_listener_call_aux_ref});
    get_socket()->on(event_name, std::bind(&connection_listener::on_event_listener_aux, &l, std::placeholders::_1, std::placeholders::_2, std::placeholders::_3, std::placeholders::_4));
    return 0;
}

static napi_value once(napi_env env, napi_callback_info info) {
    initEnv(env);
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    char event_name[MAX_BUF_SIZE];
    napi_get_value_string_utf8(env, args[0], event_name, MAX_BUF_SIZE, &result);
    napi_value on_event_listener_call_aux = args[1];
    napi_ref on_event_listener_call_aux_ref;
    napi_create_reference(env_global, on_event_listener_call_aux, 1, &on_event_listener_call_aux_ref);
    on_event_listener_call_aux_ref_map.insert({event_name, on_event_listener_call_aux_ref});
    get_socket()->on(event_name, std::bind(&connection_listener::once_event_listener_aux, &l, std::placeholders::_1, std::placeholders::_2, std::placeholders::_3, std::placeholders::_4));
    return 0;
}

static napi_value off(napi_env env, napi_callback_info info) {
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    char event_name[MAX_BUF_SIZE];
    napi_get_value_string_utf8(env, args[0], event_name, MAX_BUF_SIZE, &result);
    get_socket()->off(event_name);
    return 0;
}

static napi_value off_all(napi_env env, napi_callback_info info) {
    get_socket()->off_all();
    return 0;
}

static napi_value socket_close(napi_env env, napi_callback_info info) {
    get_socket()->close();
    return 0;
}
static napi_value on_error(napi_env env, napi_callback_info info) {
    initEnv(env);
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    napi_value on_error_listener_call = args[0];
    napi_create_reference(env_global, on_error_listener_call, 1, &on_error_listener_call_ref);
    get_socket()->on_error(std::bind(&connection_listener::on_error_listener, &l, std::placeholders::_1));
    return 0;
}

static napi_value off_error(napi_env env, napi_callback_info info) {
    get_socket()->off_error();
    return 0;
}

static sio::object_message::ptr get_object_message(napi_env env, napi_value napi_object_value) {
    napi_value keys;
    napi_get_property_names(env, napi_object_value, &keys);
    uint32_t key_length;
    napi_get_array_length(env, keys, &key_length);
    sio::object_message::ptr message_item = sio::object_message::create();
    for (uint32_t i = 0; i < key_length; i++) {
        //获取key
        napi_value napi_key;
        napi_get_element(env, keys, i, &napi_key);
        char char_key[MAX_BUF_SIZE];
        napi_get_value_string_utf8(env, napi_key, char_key, MAX_BUF_SIZE, &result);
        //获取value
        napi_value napi_value;
        napi_get_named_property(env, napi_object_value, char_key, &napi_value);
        napi_valuetype valueType;
        napi_typeof(env, napi_value, &valueType);
        switch (valueType) {
        case napi_string:
            char char_value[MAX_BUF_SIZE];
            napi_get_value_string_utf8(env, napi_value, char_value, MAX_BUF_SIZE, &result);
            ((sio::object_message *)message_item.get())->insert(char_key, std::string(char_value));
            break;
        case napi_number:
            double num_value;
            napi_get_value_double(env, napi_value, &num_value);
            ((sio::object_message *)message_item.get())->insert(char_key, (int64_t)num_value);
            break;
        case napi_boolean:
            bool bool_value;
            napi_get_value_bool(env, napi_value, &bool_value);
            ((sio::object_message *)message_item.get())->insert(char_key, bool_value);
            break;
        case napi_object:
            sio::object_message::ptr message_object = get_object_message(env, napi_value);
            ((sio::object_message *)message_item.get())->insert(char_key, message_object);
            message_object = nullptr;
            break;
        }
    }
    return message_item;
}

static napi_value emit(napi_env env, napi_callback_info info) {
    initEnv(env);
    size_t argc = 4;
    napi_value args[4] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    char event_name[MAX_BUF_SIZE];
    napi_get_value_string_utf8(env, args[0], event_name, MAX_BUF_SIZE, &result);
    napi_valuetype messageType;
    napi_typeof(env, args[1], &messageType);
    napi_value on_emit_listener_call = args[3];
    napi_ref on_emit_listener_call_ref;
    napi_create_reference(env_global, on_emit_listener_call, 1, &on_emit_listener_call_ref);
    on_emit_listener_call_ref_map.insert({event_name, on_emit_listener_call_ref});
    sio::message::list *messageList = new sio::message::list();
    if (messageType == napi_string) {
        char message[MAX_BUF_SIZE];
        napi_get_value_string_utf8(env, args[1], message, MAX_BUF_SIZE, &result);
        bool is_arraybuffer;
        napi_get_value_bool(env, args[2], &is_arraybuffer);
        if (is_arraybuffer) {
            std::shared_ptr<std::string> message_binary = std::make_shared<std::string>(message);
            messageList->push(message_binary);
            message_binary = nullptr;
        } else {
            messageList->push(message);
        }
    } else if (messageType == napi_object) {
        sio::object_message::ptr message_item = get_object_message(env, args[1]);
        messageList->push(message_item);
        message_item = nullptr;
    }
    get_socket()->emit(event_name, *messageList, std::bind(&connection_listener::on_emit_callback, &l, std::placeholders::_1, std::placeholders::_2));
    delete messageList;
    messageList = nullptr;
    return 0;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports) {
    napi_property_descriptor desc[] = {
        DECLARE_NAPI_FUNCTION("connect", connect),
        DECLARE_NAPI_FUNCTION("set_open_listener", set_open_listener),
        DECLARE_NAPI_FUNCTION("set_fail_listener", set_fail_listener),
        DECLARE_NAPI_FUNCTION("set_reconnecting_listener", set_reconnecting_listener),
        DECLARE_NAPI_FUNCTION("set_reconnect_listener", set_reconnect_listener),
        DECLARE_NAPI_FUNCTION("set_close_listener", set_close_listener),
        DECLARE_NAPI_FUNCTION("set_socket_open_listener", set_socket_open_listener),
        DECLARE_NAPI_FUNCTION("set_socket_close_listener", set_socket_close_listener),
        DECLARE_NAPI_FUNCTION("clear_con_listeners", clear_con_listeners),
        DECLARE_NAPI_FUNCTION("clear_socket_listeners", clear_socket_listeners),
        DECLARE_NAPI_FUNCTION("set_reconnect_attempts", set_reconnect_attempts),
        DECLARE_NAPI_FUNCTION("set_reconnect_delay", set_reconnect_delay),
        DECLARE_NAPI_FUNCTION("set_reconnect_delay_max", set_reconnect_delay_max),
        DECLARE_NAPI_FUNCTION("set_logs_default", set_logs_default),
        DECLARE_NAPI_FUNCTION("set_logs_quiet", set_logs_quiet),
        DECLARE_NAPI_FUNCTION("set_logs_verbose", set_logs_verbose),
        DECLARE_NAPI_FUNCTION("close", close),
        DECLARE_NAPI_FUNCTION("sync_close", sync_close),
        DECLARE_NAPI_FUNCTION("set_proxy_basic_auth", set_proxy_basic_auth),
        DECLARE_NAPI_FUNCTION("opened", opened),
        DECLARE_NAPI_FUNCTION("get_sessionid", get_sessionid),
        DECLARE_NAPI_FUNCTION("set_nsp", set_nsp),
        DECLARE_NAPI_FUNCTION("on", on),
        DECLARE_NAPI_FUNCTION("once", once),
        DECLARE_NAPI_FUNCTION("off", off),
        DECLARE_NAPI_FUNCTION("off_all", off_all),
        DECLARE_NAPI_FUNCTION("socket_close", socket_close),
        DECLARE_NAPI_FUNCTION("on_error", on_error),
        DECLARE_NAPI_FUNCTION("off_error", off_error),
        DECLARE_NAPI_FUNCTION("emit", emit),
    };
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}
EXTERN_C_END

static napi_module demoModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "client_socket_c",
    .nm_priv = ((void *)0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterSocketIoModule(void) {
    napi_module_register(&demoModule);
}
