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

#include <cstring>
#include <js_native_api.h>
#include <js_native_api_types.h>
#include <node_api.h>
#include "napi/native_api.h"
#include "hilog/log.h"
#include "client_socket.h"
#include "sio_client.h"
#include "sio_message.h"
#include "socketio_context.h"
#include "socketio_module_napi.h"

static constexpr const int MAX_BUF_SIZE = 512;
static constexpr const int CLASSID_BUF_SIZE = 1024;
static constexpr const int OPTION_BUF_SIZE = 2048;
static constexpr const int MAX_MESSAGE_SIZE = 100000;
static constexpr const int ODD_NUMBER = 1;
static constexpr const int EXPECT_NUMBER = 2;

static std::unordered_map<std::string, SocketIOClient*> g_clientMap;
// client相关回调
static napi_ref on_open_call_ref, on_fail_call_ref, on_reconnecting_call_ref, on_reconnect_call_ref;
static napi_ref on_socket_open_call_ref, on_socket_close_call_ref, on_close_call_ref;
// 根据eventname筛选event回调方法
static std::map<std::string, napi_ref> on_event_listener_call_aux_ref_map;
// socket相关回调
static napi_ref on_error_listener_call_ref;
// 根据eventname筛选ack回调方法
static std::map<std::string, napi_ref> on_emit_listener_call_ref_map;
// 全局result
static size_t result = 0;

static constexpr const int ARG_INDEX_0 = 0;
static constexpr const int ARG_INDEX_1 = 1;
static constexpr const int ARG_INDEX_2 = 2;
static constexpr const int ARG_INDEX_3 = 3;
static constexpr const int ARG_INDEX_4 = 4;

static bool g_isOnce = false;

// 处理带有转义字符的字符串
static std::string transfer_characters(const std::string &str)
{
    std::string transChar;
    for (auto ch : str) {
        switch (ch) {
            case '\"':
                transChar += "\\\"";
                break;
            case '\\':
                transChar += "\\\\";
                break;
            case '\b':
                transChar += "\\b";
                break; // 退格
            case '\f':
                transChar += "\\f";
                break; // 换页
            case '\n':
                transChar += "\\n";
                break;
            case '\r':
                transChar += "\\r";
                break;
            case '\t':
                transChar += "\\t";
                break;
            default:
                transChar += ch;
                break; // 其他字符直接添加
        }
    }
    return transChar;
}

static std::string extract_string_from_message(sio::message::ptr const &message)
{
    // 当服务端返回的是json字符串的情况下，无需拼接转义符 \",直接将数据返回拼接即可
    if (message->get_string().size() > 0 && message->get_string()[0] == '{') {
        return message->get_string();
    }
    // 拼接转义符 \" 返回组装 json 串
    return std::string("\"") + transfer_characters(message->get_string()) + "\"";
}

static std::string get_message_value(sio::message::ptr const &message)
{
    std::string message_json;
    std::map<std::string, sio::message::ptr> messageMap;
    std::vector<sio::message::ptr> messageArray;
    
    switch (message->get_flag()) {
        case sio::message::flag_integer:
            return std::to_string(message->get_int());
        case sio::message::flag_double:
            return std::to_string(message->get_double());
        case sio::message::flag_string:
            return extract_string_from_message(message);
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
        case sio::message::flag_array:
            message_json = "[";
            messageArray = message->get_vector();
            for (int i = 0; i < messageArray.size(); i++) {
                message_json += get_message_value(messageArray[i]);
                if (i != (messageArray.size() - 1)) {
                    message_json += std::string(",");
                }
            }
            message_json += "]";
            return message_json;
        case sio::message::flag_boolean:
            return std::to_string(message->get_bool());
        case sio::message::flag_null:
            return std::string("\"\"");
        default:
            return std::string("\"\"");
    }
}

static void handler_event_listener_aux(OHOS::SocketIO::SocketIOContext context, const std::string &name,
                                       sio::message::ptr const &message, bool needAck,
                                       sio::message::list &ack_message)
{
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
        
        std::unique_ptr<ThreadSafeInfo> localThreadSafeInfo = std::make_unique<ThreadSafeInfo>();
        if (localThreadSafeInfo == nullptr) {
            OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, LOG_TAG, "[event_listener]localThreadSafeInfo is null");
            return;
        }
        localThreadSafeInfo->result = message_json;
        context.CallTsFunction(static_cast<void*>(localThreadSafeInfo.release()));
        
        if (g_isOnce) {
            on_event_listener_call_aux_ref_map[name.c_str()] = nullptr;
        }
    }
}

static void handler_binary_event_listener_aux(OHOS::SocketIO::SocketIOContext context,
                                              const std::string &name,
                                              sio::message::ptr const &message,
                                              bool needAck,
                                              sio::message::list &ack_message)
{
    napi_ref on_event_listener_call_aux_ref = on_event_listener_call_aux_ref_map[name.c_str()];
    if (on_event_listener_call_aux_ref != nullptr) {
        if (message->get_flag() == sio::message::flag_binary) {
            auto binary_str = *message->get_binary();
            
            std::unique_ptr<BinaryInfo> localBinaryInfo = std::make_unique<BinaryInfo>();
            if (localBinaryInfo == nullptr) {
                OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, LOG_TAG, "[event_listener]localBinaryInfo is null");
                return;
            }
            localBinaryInfo->result = binary_str;
            context.CallTsFunction(static_cast<void*>(localBinaryInfo.release()));
            
            if (g_isOnce) {
                on_event_listener_call_aux_ref_map[name.c_str()] = nullptr;
            }
        }
    }
}

class ClientSocket {
public:
    ClientSocket() noexcept {}

    void OnOpen()
    {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, "LOG_TAG", "SOCKETIO_TAG_NAPI------> OnOpen 连接成功");
            
        napi_acquire_threadsafe_function(g_tsfnOnOpenCall);
        // 调用主线程函数，传入 Data
        napi_call_threadsafe_function(g_tsfnOnOpenCall, nullptr, napi_tsfn_blocking);
    }

    void OnFail()
    {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, LOG_TAG, "SOCKETIO_TAG------> OnFail ");
            
        napi_acquire_threadsafe_function(g_tsfnFailCall);
        // 调用主线程函数，传入 Data
        napi_call_threadsafe_function(g_tsfnFailCall, nullptr, napi_tsfn_blocking);
    }

    void OnReconnecting()
    {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, LOG_TAG, "SOCKETIO_TAG------> OnReconnecting ");
            
        napi_acquire_threadsafe_function(g_tsfnReconnectingCall);
        // 调用主线程函数，传入 Data
        napi_call_threadsafe_function(g_tsfnReconnectingCall, nullptr, napi_tsfn_blocking);
    }

    // 待回传unsigned两个参数
    void OnReconnect(unsigned, unsigned)
    {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, LOG_TAG, "SOCKETIO_TAG------> OnReconnect ");
            
        napi_acquire_threadsafe_function(g_tsfnReconnectCall);
        // 调用主线程函数，传入 Data
        napi_call_threadsafe_function(g_tsfnReconnectCall, nullptr, napi_tsfn_blocking);
    }

    void on_close(sio::client::close_reason const &reason)
    {
        std::string reasonString = "";
        if (reason == sio::client::close_reason_normal) {
            reasonString = "close_reason_normal";
        } else if (reason == sio::client::close_reason_drop) {
            reasonString = "close_reason_drop";
        }
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, LOG_TAG, "SOCKETIO_TAG------> on_close ");
        
        std::unique_ptr<ThreadSafeInfo> localThreadSafeInfo = std::make_unique<ThreadSafeInfo>();
        if (localThreadSafeInfo == nullptr) {
            OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, LOG_TAG, "[on_close]localThreadSafeInfo is null");
            return;
        }
        localThreadSafeInfo->result = reasonString;
        napi_acquire_threadsafe_function(g_tsfnCloseCall);
        napi_call_threadsafe_function(g_tsfnCloseCall, localThreadSafeInfo.release(), napi_tsfn_blocking);
    }

    void on_socket_open(std::string const &nsp)
    {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, LOG_TAG, "SOCKETIO_TAG------>0 on_socket_open %{public}s",
                     nsp.c_str());
        
        std::unique_ptr<ThreadSafeInfo> localThreadSafeInfo = std::make_unique<ThreadSafeInfo>();
        if (localThreadSafeInfo == nullptr) {
            OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, LOG_TAG, "[on_socket_open]localThreadSafeInfo is null");
            return;
        }
        localThreadSafeInfo->result = nsp;
        napi_acquire_threadsafe_function(g_tsfnOnSocketioOpenCall);
        napi_call_threadsafe_function(g_tsfnOnSocketioOpenCall, localThreadSafeInfo.release(), napi_tsfn_blocking);
    }

    void on_socket_close(std::string const &nsp)
    {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, LOG_TAG, "SOCKETIO_TAG------> on_socket_close ");
        std::unique_ptr<ThreadSafeInfo> localThreadSafeInfo = std::make_unique<ThreadSafeInfo>();
        if (localThreadSafeInfo == nullptr) {
            OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, LOG_TAG, "[on_socket_close]localThreadSafeInfo is null");
            return;
        }
        localThreadSafeInfo->result = nsp;
        napi_acquire_threadsafe_function(g_tsfnOnCloseCall);
        napi_call_threadsafe_function(g_tsfnOnCloseCall, localThreadSafeInfo.release(), napi_tsfn_blocking);
    }

    void on_event_listener_aux(const OHOS::SocketIO::SocketIOContext &context, const std::string &name,
                               sio::message::ptr const &message, bool needAck, sio::message::list &ack_message)
    {
        g_isOnce = false;
        handler_event_listener_aux(context, name, message, needAck,
            ack_message);
    }
    
    void on_binary_event_listener_aux(const OHOS::SocketIO::SocketIOContext &context, const std::string &name,
                               sio::message::ptr const &message, bool needAck, sio::message::list &ack_message)
    {
        g_isOnce = false;
        handler_binary_event_listener_aux(context, name, message, needAck,
            ack_message);
    }

    void once_event_listener_aux(const OHOS::SocketIO::SocketIOContext &context, const std::string &name,
                                 sio::message::ptr const &message, bool needAck, sio::message::list &ack_message)
    {
        g_isOnce = true;
        handler_event_listener_aux(context, name, message, needAck,
            ack_message);
    }

    void on_error_listener(sio::message::ptr const &message)
    {
        std::string error_string = "on error";
        
        std::unique_ptr<ThreadSafeInfo> localThreadSafeInfo = std::make_unique<ThreadSafeInfo>();
        if (localThreadSafeInfo == nullptr) {
            OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, LOG_TAG, "[on_error_listener]localThreadSafeInfo is null");
            return;
        }
        localThreadSafeInfo->result = error_string;
        napi_acquire_threadsafe_function(g_tsfnOnErrorCall);
        napi_call_threadsafe_function(g_tsfnOnErrorCall, localThreadSafeInfo.release(), napi_tsfn_blocking);
    }
    
    std::string handler_message_json(sio::message::list const &list)
    {
        std::string str;
        if (list.at(0)->get_flag() == sio::message::flag_object) {
            std::map<std::string, sio::message::ptr> messageMap = list.at(0)->get_map();
            for (auto it : messageMap) {
                if (messageMap.begin()->first != it.first) {
                    str += std::string(",");
                }
                str += std::string("\"") + it.first.c_str() + "\":" + get_message_value(it.second);
            }
        } else {
            str += std::string("\"") + "message" + "\":" + get_message_value(list.at(0));
        }
        return str;
    }

    void on_emit_callback(std::string const &ack_name, sio::message::list const &list)
    {
        OH_LOG_Print(LOG_APP,   LOG_INFO,   LOG_DOMAIN,   LOG_TAG, "SOCKETIO_TAG------> 0 on_emit_callback -------");
        napi_ref on_emit_listener_call_ref = on_emit_listener_call_ref_map[ack_name.c_str()];
        if (on_emit_listener_call_ref == nullptr) {
            OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, LOG_TAG, "on_emit_listener_call_ref is null");
            return;
        }
        std::string message_json = std::string("{");
        if (list.size() > 0) {
            message_json += handler_message_json(list);
        }
        message_json += "}";
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, LOG_TAG, "SOCKETIO_TAG------> 1 on_emit_callback %{public}s",
                     message_json.c_str());

        std::unique_ptr<ThreadSafeInfo> localThreadSafeInfo = std::make_unique<ThreadSafeInfo>();
        if (localThreadSafeInfo == nullptr) {
            OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, LOG_TAG, "[on_emit_callback]localThreadSafeInfo is null");
            return;
        }
        localThreadSafeInfo->result = message_json;
        napi_acquire_threadsafe_function(g_tsfnEmitCall);
        napi_call_threadsafe_function(g_tsfnEmitCall, localThreadSafeInfo.release(), napi_tsfn_blocking);
    }
    
    void on_emit_callback_binary(std::string const &ack_name, sio::message::list const &list)
    {
        napi_ref on_emit_listener_call_ref = on_emit_listener_call_ref_map[ack_name.c_str()];
        if (on_emit_listener_call_ref == nullptr) {
            OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, LOG_TAG, "on_emit_listener_call_ref is null");
            return;
        }

        if (list.size() > 1) {
            std::unique_ptr<BinaryInfo> localBinaryInfo = std::make_unique<BinaryInfo>();
            if (localBinaryInfo == nullptr) {
                OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, LOG_TAG, "[event_listener]g_threadSafeInfo is null");
                return;
            }
            if (list.at(0)->get_flag() == sio::message::flag_integer) {
                localBinaryInfo->code = list.at(0)->get_int();
            }
            if (list.at(1)->get_flag() == sio::message::flag_binary) {
                auto binary_str = *list.at(1)->get_binary();
                localBinaryInfo->result = binary_str;
            }
            napi_acquire_threadsafe_function(g_tsfnEmitBinaryCall);
            // 调用主线程函数，传入 Data
            napi_call_threadsafe_function(g_tsfnEmitBinaryCall, localBinaryInfo.release(), napi_tsfn_blocking);
        }
    }
};

static ClientSocket g_clientSocket;

// client相关napi接口
// 定义一个结构体来包含状态信息
struct ParseState {
    bool inQuotes = false;
    bool escape = false;
    bool readingKey = true;
    std::string key;
    std::string value;
};

// 处理嵌套的对象和数组
void parseNested(const std::string& jsonString, size_t& i, std::string& value, char openChar, char closeChar)
{
    size_t bracketCount = 1;
    value += jsonString[i];
    for (++i; i < jsonString.length(); ++i) {
        if (jsonString[i] == openChar) {
            bracketCount++;
        }
        if (jsonString[i] == closeChar) {
            bracketCount--;
        }
        value += jsonString[i];
        if (bracketCount == 0) {
            break;
        }
    }
}

// 处理转义字符
void handleEscapeCharacter(char currentChar, std::string& value)
{
    switch (currentChar) {
        case '"':
            value += '"';
            break;
        case '\\':
            value += '\\';
            break;
        case 'n':
            value += '\n';
            break;
        case 'r':
            value += '\r';
            break;
        case 't':
            value += '\t';
            break;
        default:
            value += currentChar;
            break;
    }
}

// 处理键值对
void processKeyValuePair(std::map<std::string, std::string>& result, std::string& key, std::string& value)
{
    if (!key.empty() && !value.empty()) {
        result[key] = value;
    }
    key.clear();
    value.clear();
}

// 处理当前字符并处理键值对
bool processCurrentCharAndKeyValuePair(char currentChar, ParseState& state, std::map<std::string, std::string>& result)
{
    if (state.inQuotes) {
        (state.readingKey ? state.key : state.value) += currentChar;
    } else {
        if (currentChar == ':') {
            state.readingKey = false;
        } else if (currentChar == ',') {
            processKeyValuePair(result, state.key, state.value);
            state.readingKey = true;
        } else if (currentChar == '}') {
            processKeyValuePair(result, state.key, state.value);
            state.readingKey = true;
            return true; // 结束标志
        } else {
            (state.readingKey ? state.key : state.value) += currentChar;
        }
    }
    return false;
}

// 标准与非标准的json字符串转map
void stringToMap(const std::string& jsonString, std::map<std::string, std::string>& result)
{
    ParseState state;
    for (size_t i = (jsonString[0] == '{') ? 1 : 0; i < jsonString.length(); i++) {
        char currentChar = jsonString[i];
        if (state.escape) {
            if (state.inQuotes) {
                handleEscapeCharacter(currentChar, state.value);
            }
            state.escape = false;
            continue;
        }
        if (currentChar == '\\') {
            state.escape = true;
            continue;
        }
        if (currentChar == '"') {
            state.inQuotes = !state.inQuotes;
            continue;
        }
        if ((currentChar == '{' || currentChar == '[') && !state.inQuotes) {
            parseNested(jsonString, i, state.value, currentChar,
                        currentChar == '{' ? '}' : ']');
            continue;
        }

        if (processCurrentCharAndKeyValuePair(currentChar, state, result)) {
            break;
        }
    }
    processKeyValuePair(result, state.key, state.value);
}

// 标准与非标准的json字符串转map
static std::map<std::string, std::string> parseConfigString(const std::string& jsonString)
{
    // 定义一个 map 来存储结果
    std::map<std::string, std::string> map;
    
    // 处理 JSON 对象
    stringToMap(jsonString, map);
    return map;
}

SocketIOClient* getClient(std::string classIdStr)
{
    SocketIOClient *client = nullptr;
    auto iter = g_clientMap.find(classIdStr);
    if (iter != g_clientMap.end()) {
        client = g_clientMap[classIdStr];
    }
    return client;
}

napi_value SocketIOClient::set_headers(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    char headers[MAX_BUF_SIZE];
    napi_get_value_string_utf8(env, args[0], headers, MAX_BUF_SIZE, &result);
    
    size_t charLen = 0;
    char classId[CLASSID_BUF_SIZE] = {0};
    napi_get_value_string_utf8(env, args[1], classId, CLASSID_BUF_SIZE, &charLen);
    std::string classIdStr = classId;
    SocketIOClient *client = getClient(classIdStr);
    if (!client) { return nullptr; }
    
    std::string myString(headers);
    client->g_headerMap = parseConfigString(myString);
    
    return 0;
}

napi_value SocketIOClient::get_current_state(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    char classId[CLASSID_BUF_SIZE] = {0};
    size_t charLen = 0;
    napi_get_value_string_utf8(env, args[0], classId, CLASSID_BUF_SIZE, &charLen);
    std::string classIdStr = classId;

    SocketIOClient* client = getClient(classIdStr);
    if (!client) {
        return nullptr;
    }

    napi_value state;
    napi_create_int32(env, static_cast<int32_t>(client->clientInstance.get_current_state()), &state);
    return state;
}

napi_value SocketIOClient::set_option(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    // option 有时候可能设置的内容比较长
    char option[OPTION_BUF_SIZE];
    napi_get_value_string_utf8(env, args[0], option, OPTION_BUF_SIZE, &result);
    
    size_t charLen = 0;
    char classId[CLASSID_BUF_SIZE] = {0};
    napi_get_value_string_utf8(env, args[1], classId, CLASSID_BUF_SIZE, &charLen);
    std::string classIdStr = classId;
    SocketIOClient *client = getClient(classIdStr);
    if (!client) { return nullptr; }
    
    std::string myString(option);
    client->g_optionMap = parseConfigString(myString);
    
    return 0;
}

napi_value SocketIOClient::connect(napi_env env, napi_callback_info info)
{
    size_t charLen = 0;
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    char uri[MAX_BUF_SIZE];
    napi_get_value_string_utf8(env, args[0], uri, MAX_BUF_SIZE, &result);
    
    char classId[CLASSID_BUF_SIZE] = {0};
    napi_get_value_string_utf8(env, args[1], classId, CLASSID_BUF_SIZE, &charLen);
    std::string classIdStr = classId;
    SocketIOClient *client = getClient(classIdStr);
    if (!client) { return nullptr; }
    client->clientInstance.connect(uri, client->g_optionMap, client->g_headerMap);
    return 0;
}
napi_value SocketIOClient::set_open_listener(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    napi_value on_open_call = args[0];
    napi_create_reference(env, on_open_call, 1, &on_open_call_ref);
    
    NapiCreateThreadsafe(env, on_open_call, CallJsNoParames, &g_tsfnOnOpenCall);
    
    size_t charLen = 0;
    char classId[CLASSID_BUF_SIZE] = {0};
    napi_get_value_string_utf8(env, args[1], classId, CLASSID_BUF_SIZE, &charLen);
    std::string classIdStr = classId;
    SocketIOClient *client = getClient(classIdStr);
    if (!client) { return nullptr; }
    client->clientInstance.set_open_listener(std::bind(&ClientSocket::OnOpen, &g_clientSocket));
    
    return 0;
}

napi_value SocketIOClient::set_fail_listener(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    napi_value on_fail_call = args[0];
    napi_create_reference(env, on_fail_call, 1, &on_fail_call_ref);
    
    NapiCreateThreadsafe(env, on_fail_call, CallJsNoParames, &g_tsfnFailCall);
    
    size_t charLen = 0;
    char classId[CLASSID_BUF_SIZE] = {0};
    napi_get_value_string_utf8(env, args[1], classId, CLASSID_BUF_SIZE, &charLen);
    std::string classIdStr = classId;
    SocketIOClient *client = getClient(classIdStr);
    if (!client) { return nullptr; }
    client->clientInstance.set_fail_listener(std::bind(&ClientSocket::OnFail, &g_clientSocket));
    return 0;
}

napi_value SocketIOClient::set_reconnecting_listener(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    napi_value on_reconnecting_call = args[0];
    napi_create_reference(env, on_reconnecting_call, 1, &on_reconnecting_call_ref);
    
    NapiCreateThreadsafe(env, on_reconnecting_call, CallJsNoParames, &g_tsfnReconnectingCall);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, LOG_TAG, "SOCKETIO_TAG------> set_reconnecting_listener ");
    
    size_t charLen = 0;
    char classId[CLASSID_BUF_SIZE] = {0};
    napi_get_value_string_utf8(env, args[1], classId, CLASSID_BUF_SIZE, &charLen);
    std::string classIdStr = classId;
    SocketIOClient *client = getClient(classIdStr);
    if (!client) { return nullptr; }
    client->clientInstance.set_reconnecting_listener(std::bind(&ClientSocket::OnReconnecting, &g_clientSocket));
    return 0;
}

napi_value SocketIOClient::set_reconnect_listener(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    napi_value on_reconnect_call = args[0];
    napi_create_reference(env, on_reconnect_call, 1, &on_reconnect_call_ref);
    
    NapiCreateThreadsafe(env, on_reconnect_call, CallJsNoParames, &g_tsfnReconnectCall);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, LOG_TAG, "SOCKETIO_TAG------> set_reconnect_listener ");

    size_t charLen = 0;
    char classId[CLASSID_BUF_SIZE] = {0};
    napi_get_value_string_utf8(env, args[1], classId, CLASSID_BUF_SIZE, &charLen);
    std::string classIdStr = classId;
    SocketIOClient *client = getClient(classIdStr);
    if (!client) {
        return nullptr;
    }
    client->clientInstance.set_reconnect_listener(std::bind(&ClientSocket::OnReconnect, &g_clientSocket,
        std::placeholders::_1, std::placeholders::_2));
    return 0;
}

napi_value SocketIOClient::set_close_listener(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    napi_value on_close_call = args[0];
    napi_create_reference(env, on_close_call, 1, &on_close_call_ref);
    
    NapiCreateThreadsafe(env, on_close_call, CallJsEmit, &g_tsfnCloseCall);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, LOG_TAG, "SOCKETIO_TAG------> set_close_listener ");

    size_t charLen = 0;
    char classId[CLASSID_BUF_SIZE] = {0};
    napi_get_value_string_utf8(env, args[1], classId, CLASSID_BUF_SIZE, &charLen);
    std::string classIdStr = classId;
    SocketIOClient *client = getClient(classIdStr);
    if (!client) { return nullptr; }
    client->clientInstance.set_close_listener(
        std::bind(&ClientSocket::on_close, &g_clientSocket, std::placeholders::_1));
    return 0;
}

napi_value SocketIOClient::set_socket_open_listener(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    napi_value on_socket_open_call = args[0];
    
    NapiCreateThreadsafe(env, on_socket_open_call, CallJsEmit, &g_tsfnOnSocketioOpenCall);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, LOG_TAG, "SOCKETIO_TAG------> set_socket_open_listener ");
        
    size_t charLen = 0;
    char classId[CLASSID_BUF_SIZE] = {0};
    napi_get_value_string_utf8(env, args[1], classId, CLASSID_BUF_SIZE, &charLen);
    std::string classIdStr = classId;
    SocketIOClient *client = getClient(classIdStr);
    if (!client) {
        return nullptr;
    }
    client->clientInstance.set_socket_open_listener(std::bind(&ClientSocket::on_socket_open, &g_clientSocket,
        std::placeholders::_1));
    return 0;
}

napi_value SocketIOClient::set_socket_close_listener(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    napi_value on_socket_close_call = args[0];
    napi_create_reference(env, on_socket_close_call, 1, &on_socket_close_call_ref);
    
    NapiCreateThreadsafe(env, on_socket_close_call, CallJsEmit, &g_tsfnOnCloseCall);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, LOG_TAG, "SOCKETIO_TAG------> set_socket_close_listener ");
         
    size_t charLen = 0;
    char classId[CLASSID_BUF_SIZE] = {0};
    napi_get_value_string_utf8(env, args[1], classId, CLASSID_BUF_SIZE, &charLen);
    std::string classIdStr = classId;
    SocketIOClient *client = getClient(classIdStr);
    if (!client) {
        return nullptr;
    }
    client->clientInstance.set_socket_close_listener(std::bind(&ClientSocket::on_socket_close, &g_clientSocket,
        std::placeholders::_1));
    return 0;
}

napi_value SocketIOClient::clear_con_listeners(napi_env env, napi_callback_info info)
{
    size_t charLen = 0;
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    char classId[CLASSID_BUF_SIZE] = {0};
    napi_get_value_string_utf8(env, args[0], classId, CLASSID_BUF_SIZE, &charLen);
    std::string classIdStr = classId;
    SocketIOClient *client = getClient(classIdStr);
    if (!client) {
        return nullptr;
    }
    client->clientInstance.clear_con_listeners();
    return 0;
}

napi_value SocketIOClient::clear_socket_listeners(napi_env env, napi_callback_info info)
{
    size_t charLen = 0;
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    char classId[CLASSID_BUF_SIZE] = {0};
    napi_get_value_string_utf8(env, args[0], classId, CLASSID_BUF_SIZE, &charLen);
    std::string classIdStr = classId;
    SocketIOClient *client = getClient(classIdStr);
    if (!client) {
        return nullptr;
    }
    client->clientInstance.clear_socket_listeners();
    return 0;
}

napi_value SocketIOClient::set_reconnect_attempts(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    double attempts;
    napi_get_value_double(env, args[0], &attempts);
    size_t charLen = 0;
    char classId[CLASSID_BUF_SIZE] = {0};
    napi_get_value_string_utf8(env, args[1], classId, CLASSID_BUF_SIZE, &charLen);
    std::string classIdStr = classId;
    SocketIOClient *client = getClient(classIdStr);
    if (!client) {
        return nullptr;
    }
    client->clientInstance.set_reconnect_attempts(static_cast<int>(attempts));
    return 0;
}

napi_value SocketIOClient::set_reconnect_delay(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    double millis;
    napi_get_value_double(env, args[0], &millis);
    
    size_t charLen = 0;
    char classId[CLASSID_BUF_SIZE] = {0};
    napi_get_value_string_utf8(env, args[1], classId, CLASSID_BUF_SIZE, &charLen);
    std::string classIdStr = classId;
    SocketIOClient *client = getClient(classIdStr);
    if (!client) {
        return nullptr;
    }
    client->clientInstance.set_reconnect_delay(static_cast<unsigned>(millis));
    return 0;
}

napi_value SocketIOClient::set_reconnect_delay_max(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    double millis;
    napi_get_value_double(env, args[0], &millis);
    
    size_t charLen = 0;
    char classId[CLASSID_BUF_SIZE] = {0};
    napi_get_value_string_utf8(env, args[1], classId, CLASSID_BUF_SIZE, &charLen);
    std::string classIdStr = classId;
    SocketIOClient *client = getClient(classIdStr);
    if (!client) {
        return nullptr;
    }
    client->clientInstance.set_reconnect_delay_max(static_cast<unsigned>(millis));
    return 0;
}

napi_value SocketIOClient::set_logs_default(napi_env env, napi_callback_info info)
{
    size_t charLen = 0;
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    char classId[CLASSID_BUF_SIZE] = {0};
    napi_get_value_string_utf8(env, args[0], classId, CLASSID_BUF_SIZE, &charLen);
    std::string classIdStr = classId;
    SocketIOClient *client = getClient(classIdStr);
    if (!client) {
        return nullptr;
    }
    client->clientInstance.set_logs_default();
    return 0;
}

napi_value SocketIOClient::set_logs_quiet(napi_env env, napi_callback_info info)
{
    size_t charLen = 0;
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    char classId[CLASSID_BUF_SIZE] = {0};
    napi_get_value_string_utf8(env, args[0], classId, CLASSID_BUF_SIZE, &charLen);
    std::string classIdStr = classId;
    SocketIOClient *client = getClient(classIdStr);
    if (!client) {
        return nullptr;
    }
    client->clientInstance.set_logs_quiet();
    return 0;
}

napi_value SocketIOClient::set_logs_verbose(napi_env env, napi_callback_info info)
{
    size_t charLen = 0;
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    char classId[CLASSID_BUF_SIZE] = {0};
    napi_get_value_string_utf8(env, args[0], classId, CLASSID_BUF_SIZE, &charLen);
    std::string classIdStr = classId;
    SocketIOClient *client = getClient(classIdStr);
    if (!client) {
        return nullptr;
    }
    client->clientInstance.set_logs_verbose();
    return 0;
}

napi_value SocketIOClient::close(napi_env env, napi_callback_info info)
{
    size_t charLen = 0;
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    char classId[CLASSID_BUF_SIZE] = {0};
    napi_get_value_string_utf8(env, args[0], classId, CLASSID_BUF_SIZE, &charLen);
    std::string classIdStr = classId;
    SocketIOClient *client = getClient(classIdStr);
    if (!client) {
        return nullptr;
    }
    client->clientInstance.close();
    return 0;
}

napi_value SocketIOClient::sync_close(napi_env env, napi_callback_info info)
{
    size_t charLen = 0;
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    char classId[CLASSID_BUF_SIZE] = {0};
    napi_get_value_string_utf8(env, args[0], classId, CLASSID_BUF_SIZE, &charLen);
    std::string classIdStr = classId;
    SocketIOClient *client = getClient(classIdStr);
    if (!client) {
        return nullptr;
    }
    client->clientInstance.sync_close();
    return 0;
}

napi_value SocketIOClient::set_proxy_basic_auth(napi_env env, napi_callback_info info)
{
    size_t argc = 4;
    napi_value args[4] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    char uri[MAX_BUF_SIZE];
    char username[MAX_BUF_SIZE];
    char keywords[MAX_BUF_SIZE];
    napi_get_value_string_utf8(env, args[ARG_INDEX_0], uri, MAX_BUF_SIZE, &result);
    napi_get_value_string_utf8(env, args[ARG_INDEX_1], username, MAX_BUF_SIZE, &result);
    napi_get_value_string_utf8(env, args[ARG_INDEX_2], keywords, MAX_BUF_SIZE, &result);
    
    size_t charLen = 0;
    char classId[CLASSID_BUF_SIZE] = {0};
    napi_get_value_string_utf8(env, args[ARG_INDEX_3], classId, CLASSID_BUF_SIZE, &charLen);
    std::string classIdStr = classId;
    SocketIOClient *client = getClient(classIdStr);
    if (!client) {
        return nullptr;
    }
    client->clientInstance.set_proxy_basic_auth(uri, username, keywords);
    return 0;
}

napi_value SocketIOClient::opened(napi_env env, napi_callback_info info)
{
    size_t charLen = 0;
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    char classId[CLASSID_BUF_SIZE] = {0};
    napi_get_value_string_utf8(env, args[0], classId, CLASSID_BUF_SIZE, &charLen);
    std::string classIdStr = classId;
    SocketIOClient *client = getClient(classIdStr);
    if (!client) { return nullptr; }
    bool opened = client->clientInstance.opened();
    napi_value napi_opened;
    napi_get_boolean(env, opened, &napi_opened);
    return napi_opened;
}

napi_value SocketIOClient::get_sessionid(napi_env env, napi_callback_info info)
{
    size_t charLen = 0;
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    char classId[CLASSID_BUF_SIZE] = {0};
    napi_get_value_string_utf8(env, args[0], classId, CLASSID_BUF_SIZE, &charLen);
    std::string classIdStr = classId;
    SocketIOClient *client = getClient(classIdStr);
    if (!client) { return nullptr; }
    std::string sessionid = client->clientInstance.get_sessionid();
    napi_value napi_sessionid;
    napi_create_string_utf8(env, sessionid.c_str(), MAX_BUF_SIZE, &napi_sessionid);
    return napi_sessionid;
}

// socket相关napi接口
static sio::socket::ptr get_socket(std::string classIdStr)
{
    SocketIOClient *client = getClient(classIdStr);
    if (!client) { return nullptr; }
    
    if (client->nsp == "") {
        return client->clientInstance.socket();
    } else {
        return client->clientInstance.socket(client->nsp);
    }
}

napi_value SocketIOClient::set_nsp(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    char charNsp[MAX_BUF_SIZE];
    napi_get_value_string_utf8(env, args[0], charNsp, MAX_BUF_SIZE, &result);
    
    size_t charLen = 0;
    char classId[CLASSID_BUF_SIZE] = {0};
    napi_get_value_string_utf8(env, args[1], classId, CLASSID_BUF_SIZE, &charLen);
    std::string classIdStr = classId;
    SocketIOClient *client = getClient(classIdStr);
    if (!client) { return nullptr; }
    client->nsp = charNsp;
    return 0;
}

napi_value SocketIOClient::on(napi_env env, napi_callback_info info)
{
    size_t argc = 3;
    napi_value args[3] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    char eventName[MAX_BUF_SIZE];
    napi_get_value_string_utf8(env, args[0], eventName, MAX_BUF_SIZE, &result);
    napi_value on_event_listener_call_aux = args[1];
    napi_ref on_event_listener_call_aux_ref;
    napi_create_reference(env, on_event_listener_call_aux, 1, &on_event_listener_call_aux_ref);
    on_event_listener_call_aux_ref_map.insert(
        {eventName, on_event_listener_call_aux_ref});
    
    size_t charLen = 0;
    char classId[CLASSID_BUF_SIZE] = {0};
    napi_get_value_string_utf8(env, args[ARG_INDEX_2], classId, CLASSID_BUF_SIZE, &charLen);
    std::string classIdStr = classId;
    
    auto tsfunc_context = new OHOS::SocketIO::SocketIOContext(env);
    
    tsfunc_context->CreateTsFunction(on_event_listener_call_aux, "on", tsfunc_context, CallJsEmit);

    get_socket(classIdStr)
        ->on(eventName, *tsfunc_context,
             std::bind(&ClientSocket::on_event_listener_aux, &g_clientSocket, std::placeholders::_1,
                       std::placeholders::_2, std::placeholders::_3, std::placeholders::_4, std::placeholders::_5));
    return 0;
}

napi_value SocketIOClient::on_binary(napi_env env, napi_callback_info info)
{
    size_t argc = 3;
    napi_value args[3] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    char eventName[MAX_BUF_SIZE];
    napi_get_value_string_utf8(env, args[0], eventName, MAX_BUF_SIZE, &result);
    napi_value on_event_listener_call_aux = args[1];
    napi_ref on_event_listener_call_aux_ref;
    napi_create_reference(env, on_event_listener_call_aux, 1, &on_event_listener_call_aux_ref);
    on_event_listener_call_aux_ref_map.insert(
        {eventName, on_event_listener_call_aux_ref});
    
    size_t charLen = 0;
    char classId[CLASSID_BUF_SIZE] = {0};
    napi_get_value_string_utf8(env, args[ARG_INDEX_2], classId, CLASSID_BUF_SIZE, &charLen);
    std::string classIdStr = classId;
    
    auto tsfunc_context = new OHOS::SocketIO::SocketIOContext(env);
    
    tsfunc_context->CreateTsFunction(on_event_listener_call_aux, "on_binary", tsfunc_context, CallJsBinary);

    get_socket(classIdStr)
        ->on(eventName, *tsfunc_context,
             std::bind(&ClientSocket::on_binary_event_listener_aux, &g_clientSocket, std::placeholders::_1,
                       std::placeholders::_2, std::placeholders::_3, std::placeholders::_4, std::placeholders::_5));
    return 0;
}

napi_value SocketIOClient::once(napi_env env, napi_callback_info info)
{
    size_t argc = 3;
    napi_value args[3] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    char eventName[MAX_BUF_SIZE];
    napi_get_value_string_utf8(env, args[0], eventName, MAX_BUF_SIZE, &result);
    napi_value on_event_listener_call_aux = args[1];
    napi_ref on_event_listener_call_aux_ref;
    napi_create_reference(env, on_event_listener_call_aux, 1, &on_event_listener_call_aux_ref);
    on_event_listener_call_aux_ref_map.insert(
        {eventName, on_event_listener_call_aux_ref});
    
    size_t charLen = 0;
    char classId[CLASSID_BUF_SIZE] = {0};
    napi_get_value_string_utf8(env, args[ARG_INDEX_2], classId, CLASSID_BUF_SIZE, &charLen);
    std::string classIdStr = classId;
    
    auto tsfunc_context = new OHOS::SocketIO::SocketIOContext(env);
    
    tsfunc_context->CreateTsFunction(on_event_listener_call_aux, "once", tsfunc_context, CallJsEmit);

    get_socket(classIdStr)
        ->on(eventName, *tsfunc_context,
             std::bind(&ClientSocket::once_event_listener_aux, &g_clientSocket, std::placeholders::_1,
                       std::placeholders::_2, std::placeholders::_3, std::placeholders::_4, std::placeholders::_5));
    return 0;
}

napi_value SocketIOClient::off(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    char eventName[MAX_BUF_SIZE];
    napi_get_value_string_utf8(env, args[0], eventName, MAX_BUF_SIZE, &result);

    size_t charLen = 0;
    char classId[CLASSID_BUF_SIZE] = {0};
    napi_get_value_string_utf8(env, args[1], classId, CLASSID_BUF_SIZE, &charLen);
    std::string classIdStr = classId;
    get_socket(classIdStr)->off(eventName);
    return 0;
}

napi_value SocketIOClient::off_all(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    size_t charLen = 0;
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    char classId[CLASSID_BUF_SIZE] = {0};
    napi_get_value_string_utf8(env, args[0], classId, CLASSID_BUF_SIZE, &charLen);
    std::string classIdStr = classId;
    get_socket(classIdStr)->off_all();
    return 0;
}

napi_value SocketIOClient::socket_close(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    size_t charLen = 0;
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    char classId[CLASSID_BUF_SIZE] = {0};
    napi_get_value_string_utf8(env, args[0], classId, CLASSID_BUF_SIZE, &charLen);
    std::string classIdStr = classId;
    get_socket(classIdStr)->close();
    return 0;
}
napi_value SocketIOClient::on_error(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    napi_value on_error_listener_call = args[0];
    napi_create_reference(env, on_error_listener_call, 1, &on_error_listener_call_ref);
    
    size_t charLen = 0;
    char classId[CLASSID_BUF_SIZE] = {0};
    napi_get_value_string_utf8(env, args[1], classId, CLASSID_BUF_SIZE, &charLen);
    std::string classIdStr = classId;
    
    NapiCreateThreadsafe(env, on_error_listener_call, CallJsEmit, &g_tsfnOnErrorCall);

    get_socket(classIdStr)
        ->on_error(std::bind(&ClientSocket::on_error_listener, &g_clientSocket, std::placeholders::_1));
    return 0;
}

napi_value SocketIOClient::off_error(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    size_t charLen = 0;
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    char classId[CLASSID_BUF_SIZE] = {0};
    napi_get_value_string_utf8(env, args[0], classId, CLASSID_BUF_SIZE, &charLen);
    std::string classIdStr = classId;
    get_socket(classIdStr)->off_error();
    return 0;
}

uint32_t get_length(napi_env env, napi_value value)
{
    uint32_t length;
    napi_get_array_length(env, value, &length);
    return length;
}

napi_value get_property(napi_env env, napi_value value)
{
    napi_value keys;
    napi_get_property_names(env, value, &keys);
    return keys;
}

napi_value get_element(napi_env env, napi_value value, uint32_t index)
{
    napi_value key;
    napi_get_element(env, value, index, &key);
    return key;
}

sio::message::ptr handle_array_value(napi_env env, napi_value value);

static sio::object_message::ptr get_object_message(napi_env env, napi_value napi_object_value)
{
    napi_value keys = get_property(env, napi_object_value);
    uint32_t key_length = get_length(env, keys);
    sio::object_message::ptr message_item = sio::object_message::create();
    for (uint32_t i = 0; i < key_length; i++) {
        // 获取key
        napi_value napi_key = get_element(env, keys, i);
        char char_key[MAX_BUF_SIZE];
        napi_get_value_string_utf8(env, napi_key, char_key, MAX_BUF_SIZE, &result);
        // 获取value
        napi_value value;
        napi_get_named_property(env, napi_object_value, char_key, &value);
        napi_valuetype valueType;
        napi_typeof(env, value, &valueType);
        switch (valueType) {
            case napi_string:
                char char_value[MAX_MESSAGE_SIZE];
                napi_get_value_string_utf8(env, value, char_value, MAX_MESSAGE_SIZE, &result);
                ((sio::object_message *)message_item.get())->insert(char_key, std::string(char_value));
                break;
            case napi_number:
                double num_value;
                napi_get_value_double(env, value, &num_value);
                ((sio::object_message *)message_item.get())->insert(char_key, (int64_t)num_value);
                break;
            case napi_boolean:
                bool bool_value;
                napi_get_value_bool(env, value, &bool_value);
                ((sio::object_message *)message_item.get())->insert(char_key, bool_value);
                break;
            case napi_object:
                bool isArray;
                napi_is_array(env, value, &isArray);
                if (!isArray) {
                    sio::object_message::ptr message_object = get_object_message(env, value);
                    ((sio::object_message *)message_item.get())->insert(char_key, message_object);
                    message_object = nullptr;
                    break;
                }

                sio::message::ptr array = handle_array_value(env, value);
                ((sio::object_message *)message_item.get())->insert(char_key, array);
                break;
        }
    }
    return message_item;
}

sio::message::ptr handle_array_value(napi_env env, napi_value value)
{
    sio::message::ptr array = sio::array_message::create();
    // 获取数组的长度
    uint32_t length = get_length(env, value);
    for (size_t i = 0; i < length; i++) {
        napi_value element = get_element(env, value, i);
        napi_valuetype valueType;
        napi_typeof(env, element, &valueType);
        switch (valueType) {
            case napi_number:
                double num_value;
                napi_get_value_double(env, element, &num_value);
                array->get_vector().push_back(sio::double_message::create(num_value));
                break;
            case napi_string:
                char char_value[MAX_BUF_SIZE];
                napi_get_value_string_utf8(env, element, char_value, MAX_BUF_SIZE, &result);
                array->get_vector().push_back(sio::string_message::create(char_value));
                break;
            case napi_object:
                sio::object_message::ptr message_object = get_object_message(env, element);
                array->get_vector().push_back(message_object);
                break;
        }
    }
    return array;
}

napi_value SocketIOClient::emit(napi_env env, napi_callback_info info)
{
    // 四个参数: eventName, message, callback, classId
    size_t argc = 4;
    napi_value args[4] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    // 获取参数1: 事件名称
    char eventName[MAX_BUF_SIZE];
    napi_get_value_string_utf8(env, args[0], eventName, MAX_BUF_SIZE, &result);

    // 获取参数3: 回调函数
    napi_value on_emit_listener_call = args[2];
    napi_ref on_emit_listener_call_ref;
    napi_create_reference(env, on_emit_listener_call, 1, &on_emit_listener_call_ref);
    on_emit_listener_call_ref_map.insert({eventName, on_emit_listener_call_ref});

    sio::message::list *messageList = new sio::message::list();

    // 检测参数2是否为TypedArray(二进制数据)
    bool is_arraybuffer;
    napi_is_typedarray(env, args[1], &is_arraybuffer);

    // 处理消息数据
    if (is_arraybuffer) {
        // TypedArray二进制数据处理
        void* data;
        size_t byte_length;
        napi_typedarray_type type;
        napi_value array_buffer;
        size_t offset;
        napi_get_typedarray_info(env, args[1], &type, &byte_length, &data, &array_buffer, &offset);

        // 将TypedArray数据转换为std::string
        std::string uint8Array_str(static_cast<char*>(data), byte_length);
        std::shared_ptr<std::string> message_binary = std::make_shared<std::string>(uint8Array_str);
        messageList->push(message_binary);
        message_binary = nullptr;
    } else {
        // 非二进制数据处理
        napi_valuetype messageType;
        napi_typeof(env, args[1], &messageType);

        if (messageType == napi_string) {
            char message[MAX_MESSAGE_SIZE];
            napi_get_value_string_utf8(env, args[1], message, MAX_MESSAGE_SIZE, &result);
            messageList->push(message);
        } else if (messageType == napi_object) {
            sio::object_message::ptr message_item = get_object_message(env, args[1]);
            messageList->push(message_item);
            message_item = nullptr;
        }
    }

    // 获取参数4: classId
    size_t charLen = 0;
    char classId[CLASSID_BUF_SIZE] = {0};
    napi_get_value_string_utf8(env, args[3], classId, CLASSID_BUF_SIZE, &charLen);
    std::string classIdStr = classId;

    // 创建线程安全回调
    NapiCreateThreadsafe(env, on_emit_listener_call, CallJsEmit, &g_tsfnEmitCall);

    // 通过classId获取socket并发送消息
    get_socket(classIdStr)->emit(
        eventName,
        *messageList,
        std::bind(&ClientSocket::on_emit_callback, &g_clientSocket, std::placeholders::_1, std::placeholders::_2)
    );

    delete messageList;
    messageList = nullptr;
    return 0;
}

napi_value SocketIOClient::emitAckBinary(napi_env env, napi_callback_info info)
{
    size_t argc = 5;
    napi_value args[5] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    char eventName[MAX_BUF_SIZE];
    napi_get_value_string_utf8(env, args[0], eventName, MAX_BUF_SIZE, &result);
    napi_valuetype messageType;
    napi_typeof(env, args[1], &messageType);
    napi_value on_emit_listener_call = args[3];
    napi_ref on_emit_listener_call_ref;
    napi_create_reference(env, on_emit_listener_call, 1, &on_emit_listener_call_ref);
    on_emit_listener_call_ref_map.insert(
        {eventName, on_emit_listener_call_ref});
    sio::message::list *messageList = new sio::message::list();
    if (messageType == napi_string) {
        char message[MAX_MESSAGE_SIZE];
        napi_get_value_string_utf8(env, args[1], message, MAX_MESSAGE_SIZE, &result);
        bool isArraybuffer;
        napi_get_value_bool(env, args[ARG_INDEX_2], &isArraybuffer);
        if (isArraybuffer) {
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
    
    NapiCreateThreadsafe(env, on_emit_listener_call, CallJsAckBinary, &g_tsfnEmitBinaryCall);
    
    size_t charLen = 0;
    char classId[CLASSID_BUF_SIZE] = {0};
    napi_get_value_string_utf8(env, args[ARG_INDEX_4], classId, CLASSID_BUF_SIZE, &charLen);
    std::string classIdStr = classId;

    get_socket(classIdStr)
        ->emit(eventName, *messageList,
               std::bind(&ClientSocket::on_emit_callback_binary, &g_clientSocket, std::placeholders::_1,
                         std::placeholders::_2));
    delete messageList;
    messageList = nullptr;
    return 0;
}

napi_value SocketIOClient::JsConstructor(napi_env env, napi_callback_info info)
{
    napi_value targetObj = nullptr;
    void *data = nullptr;
    size_t argsNum = 0;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argsNum, args, &targetObj, &data);

    SocketIOClient *classBind = new SocketIOClient();
    uintptr_t classId = reinterpret_cast<uintptr_t>(classBind);
    std::string classIdStrTemp = std::to_string(classId);
    classBind->classIdStr = classIdStrTemp;

    napi_value napiClassId;
    napi_create_string_utf8(env, classIdStrTemp.c_str(), classIdStrTemp.length(), &napiClassId);
    napi_set_named_property(env, targetObj, "classId", napiClassId);
    g_clientMap.insert(std::pair<std::string, SocketIOClient *>(classIdStrTemp, classBind));

    napi_wrap(
        env, nullptr, classBind,
        [](napi_env env, void *data, void *hint) {
            SocketIOClient *bind = (SocketIOClient *)data;
            delete bind;
            bind = nullptr;
            g_clientMap.erase(bind->classIdStr);
        },
        nullptr, nullptr);
    return targetObj;
}
