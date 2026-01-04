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

#include <sstream>
#include <cstring>
#include <deque>
#include <js_native_api.h>
#include <js_native_api_types.h>
#include <node_api.h>
#include "napi/native_api.h"
#include "hilog/log.h"

#include "sio_client.h"
#include "sio_message.h"
#include "socketio_context.h"
#include "client_socket.h"
#include <mutex>

static constexpr const int MAX_BUF_SIZE = 2048;
static constexpr const int CLASSID_BUF_SIZE = 1024;
static constexpr const int OPTION_BUF_SIZE = 2048;
static constexpr const int MAX_MESSAGE_SIZE = 100000;
static constexpr const int ODD_NUMBER = 1;
static constexpr const int EXPECT_NUMBER = 2;
static constexpr const int EMIT_ARGC_MAX_NUM = 64;
static constexpr const int EMIT_CALLBACK_INDEX = 2;

// 全局SocketIOClient映射
static std::unordered_map<std::string, SocketIOClient*> g_clientMap;

// 保护g_clientMap的互斥锁
static std::mutex g_clientMapMutex;

// 全局result
static size_t result = 0;

static constexpr const int ARG_INDEX_0 = 0;
static constexpr const int ARG_INDEX_1 = 1;
static constexpr const int ARG_INDEX_2 = 2;
static constexpr const int ARG_INDEX_3 = 3;
static constexpr const int ARG_INDEX_4 = 4;


// UTF-8编码位掩码
static constexpr const unsigned char UTF8_2BYTES_MASK = 0xE0;   // 用于检测2字节UTF-8序列的第一个字节
static constexpr const unsigned char UTF8_2BYTES_PREFIX = 0xC0; // 2字节UTF-8序列的第一个字节特征值
static constexpr const unsigned char UTF8_3BYTES_MASK = 0xF0;   // 用于检测3字节UTF-8序列的第一个字节
static constexpr const unsigned char UTF8_3BYTES_PREFIX = 0xE0; // 3字节UTF-8序列的第一个字节特征值
static constexpr const unsigned char UTF8_4BYTES_MASK = 0xF8;   // 用于检测4字节UTF-8序列的第一个字节
static constexpr const unsigned char UTF8_4BYTES_PREFIX = 0xF0; // 4字节UTF-8序列的第一个字节特征值
static constexpr const unsigned char UTF8_CONT_MASK = 0xC0;     // 用于检测UTF-8后续字节
static constexpr const unsigned char UTF8_CONT_PREFIX = 0x80;   // UTF-8后续字节特征值

// 字符相关常量
static constexpr const unsigned char ASCII_PRINTABLE_START = 32;   // 可打印ASCII字符的起始值
static constexpr const unsigned char ASCII_PRINTABLE_END = 127;    // 可打印ASCII字符的结束值
static constexpr const unsigned char ASCII_DEL = 127;              // ASCII删除字符

// 格式化相关常量
static constexpr const int UTF8_ESCAPE_BUF_SIZE = 7;  // \uXXXX\0 需要7个字节
static constexpr const int HEX_DIGITS = 4;           // 十六进制转义序列的位数

static std::string BinaryToString(std::string &binary)
{
    std::string binaryStr;
    std::string binaryMsg = binary;
    binaryStr += "[";
    std::stringstream binaryTmp;
    for (size_t i = 0; i < binaryMsg.size(); i++) {
        binaryTmp.str("");
        binaryTmp << (static_cast<int32_t>(binaryMsg[i]) & 0xff);
        binaryStr += binaryTmp.str();
        if (i < binaryMsg.size() - 1) {
            binaryStr += ",";
        }
    }
    binaryStr += "]";
    return binaryStr;
}

//  处理 UTF-8 多字节序列
static std::string handle_utf8_sequence(const std::string &str, size_t &i)
{
    std::string result;
    unsigned char ch = static_cast<unsigned char>(str[i]);

    // 检查是否是有效的UTF-8序列
    if ((ch & UTF8_2BYTES_MASK) == UTF8_2BYTES_PREFIX && i + 1 < str.length() &&
        (str[i + 1] & UTF8_CONT_MASK) == UTF8_CONT_PREFIX) {
        // 2字节UTF-8序列
        result += ch;
        result += str[++i];
        i++;
    } else if ((ch & UTF8_3BYTES_MASK) == UTF8_3BYTES_PREFIX && i + 2 < str.length() &&
               (str[i + 1] & UTF8_CONT_MASK) == UTF8_CONT_PREFIX &&
               (str[i + 2] & UTF8_CONT_MASK) == UTF8_CONT_PREFIX) {
        // 3字节UTF-8序列 (大多数汉字)
        result += ch;
        result += str[++i];
        result += str[++i];
        i++;
    } else if ((ch & UTF8_4BYTES_MASK) == UTF8_4BYTES_PREFIX && i + 3 < str.length() &&
               (str[i + 1] & UTF8_CONT_MASK) == UTF8_CONT_PREFIX &&
               (str[i + 2] & UTF8_CONT_MASK) == UTF8_CONT_PREFIX &&
               (str[i + 3] & UTF8_CONT_MASK) == UTF8_CONT_PREFIX) {
        // 4字节UTF-8序列
        result += ch;
        result += str[++i];
        result += str[++i];
        result += str[++i];
        i++;
    } else {
        // 无效UTF-8或二进制数据，使用十六进制转义序列
        char buf[UTF8_ESCAPE_BUF_SIZE];
        snprintf(buf, sizeof(buf), "\\u%04x", (unsigned int)ch);
        result += buf;
        i++;
    }

    return result;
}

// 处理带有转义字符的字符串，保留汉字等UTF-8字符
static std::string transfer_characters(const std::string &str)
{
    std::string transChar;
    size_t i = 0;

    while (i < str.length()) {
        unsigned char ch = static_cast<unsigned char>(str[i]);

        if (ch >= ASCII_PRINTABLE_START && ch < ASCII_PRINTABLE_END) { // 可打印ASCII字符
            switch (ch) {
            case '\"':
                transChar += "\\\"";
                break;
            case '\\':
                transChar += "\\\\";
                break;
            default:
                transChar += ch;
                break;
            }
            i++;
        } else if (ch < ASCII_PRINTABLE_START || ch == ASCII_DEL) { // 控制字符
            // 特殊控制字符单独处理
            switch (ch) {
            case '\b':
                transChar += "\\b";
                break;
            case '\f':
                transChar += "\\f";
                break;
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
                // 使用十六进制转义序列表示其他控制字符
                char buf[UTF8_ESCAPE_BUF_SIZE];
                snprintf(buf, sizeof(buf), "\\u%04x", (unsigned int)ch);
                transChar += buf;
                break;
            }
            i++;
        } else { // UTF-8多字节序列或二进制数据
            // 将 UTF-8 处理委托给专门的函数
            transChar += handle_utf8_sequence(str, i);
        }
    }

    return transChar;
}

static std::string extract_string_from_message(sio::message::ptr const &message)
{
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
                                       sio::message::list const &message, bool needAck,
                                       sio::message::list &ack_message, SocketIOClient* client)
{
    if (!client) {
        return;
    }

    napi_ref on_event_listener_call_aux_ref = client->on_event_listener_call_aux_ref_map[name.c_str()];
    if (on_event_listener_call_aux_ref == nullptr) {
        return;
    }
    std::string messageJson;
    if (message.size() == 1) {
        messageJson += std::string("{") + "\"eventName\":\"" + name + "\"";
        if (message.at(0)->get_flag() == sio::message::flag_object) {
            std::map<std::string, sio::message::ptr> messageMap = message.at(0)->get_map();
            for (auto it : messageMap) {
                messageJson += std::string(",\"") + it.first.c_str() + "\":" + get_message_value(it.second);
            }
        } else {
            messageJson += std::string(",\"") + "message" + "\":" + get_message_value(message.at(0));
        }
        messageJson += "}";
    } else {
        messageJson += "[";
        for (int16_t index = 0; index < message.size(); index++) {
            std::string tmp;
            if ((message.at(index)->get_flag() == sio::message::flag_binary)) {
                tmp = std::string("\"") + *(message.at(index)->get_binary()) + "\"";
            } else {
                tmp = get_message_value(message.at(index));
            }
            messageJson += tmp;
            if (index < message.size() - 1) {
                messageJson += ",";
            }
        }
        messageJson += "]";
    }

    std::unique_ptr<ThreadSafeInfo> localThreadSafeInfo = std::make_unique<ThreadSafeInfo>();
    if (!localThreadSafeInfo) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, LOG_TAG, "[event_listener]localThreadSafeInfo is null");
        return;
    }
    localThreadSafeInfo->result = messageJson;
    context.CallTsFunction(static_cast<void*>(localThreadSafeInfo.release()));
    
    // 使用实例级别的once状态
    if (client->isOnce) {
        client->on_event_listener_call_aux_ref_map[name.c_str()] = nullptr;
    }
}

static void handler_binary_event_listener_aux(OHOS::SocketIO::SocketIOContext context, const std::string &name,
                                              sio::message::list const &message, bool needAck,
                                              sio::message::list &ack_message, SocketIOClient* client)
{
    if (!client) {
        return;
    }

    napi_ref on_event_listener_call_aux_ref = client->on_event_listener_call_aux_ref_map[name.c_str()];
    if (on_event_listener_call_aux_ref != nullptr) {
        return;
    }
    if (message.size() == 1) {
        if (message.at(0)->get_flag() == sio::message::flag_binary) {
            auto binary_str = *(message.at(0)->get_binary());
            
            std::unique_ptr<BinaryInfo> localBinaryInfo = std::make_unique<BinaryInfo>();
            if (!localBinaryInfo) {
                OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, LOG_TAG, "[event_listener]localBinaryInfo is null");
                return;
            }
            localBinaryInfo->result = binary_str;
            context.CallTsFunction(static_cast<void*>(localBinaryInfo.release()));
            
            // 使用实例级别的once状态
            if (client->isOnce) {
                client->on_event_listener_call_aux_ref_map[name.c_str()] = nullptr;
            }
        }
    }
}

static void handler_multi_event_listener_aux(OHOS::SocketIO::SocketIOContext context, const std::string &name,
                                             sio::message::list const &message, bool needAck,
                                             sio::message::list &ack_message, SocketIOClient* client)
{
    if (!client) {
        return;
    }

    napi_ref on_event_listener_call_aux_ref =  client->on_event_listener_call_aux_ref_map[name.c_str()];
    std::string messageJson;
    if (on_event_listener_call_aux_ref == nullptr) {
        return;
    }
    messageJson += "[";
    std::string tmp;
    for (int16_t index = 0; index < message.size(); index++) {
        if (message.at(index)->get_flag() == sio::message::flag_binary) {
            std::string binaryMsg = *(message.at(index)->get_binary());
            tmp = BinaryToString(binaryMsg);
        } else {
            tmp = get_message_value(message.at(index));
        }
        messageJson += tmp;
        if (index < message.size() -1) {
            messageJson += ",";
        }
    }
    messageJson += "]";
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, "LOG_TAG", "SOCKETIO_TAG_NAPI------>messageJson %{public}s",
        messageJson.c_str());
    std::unique_ptr<ThreadSafeInfo> localThreadSafeInfo = std::make_unique<ThreadSafeInfo>();
    if (localThreadSafeInfo == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, LOG_TAG, "[event_listener]localThreadSafeInfo is null");
        return;
    }
    localThreadSafeInfo->result = messageJson;
    context.CallTsFunction(static_cast<void *>(localThreadSafeInfo.release()));

    if (client->isOnce) {
        client->on_event_listener_call_aux_ref_map[name.c_str()] = nullptr;
    }
}

class ClientSocket {
public:
    ClientSocket() noexcept {}

    void OnOpen(SocketIOClient* client)
    {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, LOG_TAG, "SOCKETIO_TAG------> OnOpen classId: %{public}s", 
                     client ? client->classIdStr.c_str() : "null");
            
        if (client && client->tsfnOnOpenCall) {
            napi_acquire_threadsafe_function(client->tsfnOnOpenCall);
            napi_call_threadsafe_function(client->tsfnOnOpenCall, nullptr, napi_tsfn_blocking);
        }
    }

    void OnFail(SocketIOClient* client)
    {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, LOG_TAG, "SOCKETIO_TAG------> OnFail classId: %{public}s", 
                     client ? client->classIdStr.c_str() : "null");
            
        if (client && client->tsfnFailCall) {
            napi_acquire_threadsafe_function(client->tsfnFailCall);
            napi_call_threadsafe_function(client->tsfnFailCall, nullptr, napi_tsfn_blocking);
        }
    }

    void OnReconnecting(SocketIOClient* client)
    {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, LOG_TAG, "SOCKETIO_TAG------> OnReconnecting classId: %{public}s", 
                     client ? client->classIdStr.c_str() : "null");
            
        if (client && client->tsfnReconnectingCall) {
            napi_acquire_threadsafe_function(client->tsfnReconnectingCall);
            napi_call_threadsafe_function(client->tsfnReconnectingCall, nullptr, napi_tsfn_blocking);
        }
    }

    // 待回传unsigned两个参数
    void OnReconnect(unsigned attempts, unsigned delay, SocketIOClient* client)
    {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, LOG_TAG, "SOCKETIO_TAG------> OnReconnect classId: %{public}s", 
                     client ? client->classIdStr.c_str() : "null");
            
        if (client && client->tsfnReconnectCall) {
            napi_acquire_threadsafe_function(client->tsfnReconnectCall);
            napi_call_threadsafe_function(client->tsfnReconnectCall, nullptr, napi_tsfn_blocking);
        }
    }

    void on_close(sio::client::close_reason const &reason, SocketIOClient* client)
    {
        std::string reasonString = "";
        if (reason == sio::client::close_reason_normal) {
            reasonString = "close_reason_normal";
        } else if (reason == sio::client::close_reason_drop) {
            reasonString = "close_reason_drop";
        }
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, LOG_TAG, "SOCKETIO_TAG------> on_close classId: %{public}s", 
                     client ? client->classIdStr.c_str() : "null");
        
        if (client && client->tsfnCloseCall) {
            std::unique_ptr<ThreadSafeInfo> localThreadSafeInfo = std::make_unique<ThreadSafeInfo>();
            if (!localThreadSafeInfo) {
                OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, LOG_TAG, "[on_close]localThreadSafeInfo is null");
                return;
            }
            localThreadSafeInfo->result = reasonString;
            
            napi_acquire_threadsafe_function(client->tsfnCloseCall);
            napi_call_threadsafe_function(client->tsfnCloseCall, localThreadSafeInfo.release(), napi_tsfn_blocking);
        }
    }

    void on_socket_open(std::string const &nsp, SocketIOClient* client)
    {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, LOG_TAG, "SOCKETIO_TAG------>0 on_socket_open %{public}s classId: %{public}s",
                     nsp.c_str(), client ? client->classIdStr.c_str() : "null");
        
        if (client && client->tsfnOnSocketioOpenCall) {
            std::unique_ptr<ThreadSafeInfo> localThreadSafeInfo = std::make_unique<ThreadSafeInfo>();
            if (!localThreadSafeInfo) {
                OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, LOG_TAG, "[on_socket_open]localThreadSafeInfo is null");
                return;
            }
            localThreadSafeInfo->result = nsp;
            
            napi_acquire_threadsafe_function(client->tsfnOnSocketioOpenCall);
            napi_call_threadsafe_function(client->tsfnOnSocketioOpenCall, localThreadSafeInfo.release(), napi_tsfn_blocking);
        }
    }

    void on_socket_close(std::string const &nsp, SocketIOClient* client)
    {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, LOG_TAG, "SOCKETIO_TAG------> on_socket_close classId: %{public}s", 
                     client ? client->classIdStr.c_str() : "null");
        
        if (client && client->tsfnOnCloseCall) {
            std::unique_ptr<ThreadSafeInfo> localThreadSafeInfo = std::make_unique<ThreadSafeInfo>();
            if (!localThreadSafeInfo) {
                OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, LOG_TAG, "[on_socket_close]localThreadSafeInfo is null");
                return;
            }
            localThreadSafeInfo->result = nsp;

            napi_acquire_threadsafe_function(client->tsfnOnCloseCall);
            napi_call_threadsafe_function(client->tsfnOnCloseCall, localThreadSafeInfo.release(), napi_tsfn_blocking);
        }
    }

    void on_event_listener_aux(const OHOS::SocketIO::SocketIOContext &context, const std::string &name,
                               sio::message::list const &message, bool needAck, sio::message::list &ack_message,
                               SocketIOClient* client)
    {
        client->isOnce = false;
        handler_event_listener_aux(context, name, message, needAck,
            ack_message, client);
    }
    
    void on_binary_event_listener_aux(const OHOS::SocketIO::SocketIOContext &context, const std::string &name,
                               sio::message::list const &message, bool needAck, sio::message::list &ack_message,
                               SocketIOClient* client)
    {
        client->isOnce = false;
        handler_binary_event_listener_aux(context, name, message, needAck,
            ack_message, client);
    }

    void once_event_listener_aux(const OHOS::SocketIO::SocketIOContext &context, const std::string &name,
                                 sio::message::list const &message, bool needAck, sio::message::list &ack_message,
                                 SocketIOClient* client)
    {
        client->isOnce = true;
        handler_event_listener_aux(context, name, message, needAck,
            ack_message, client);
    }

    void on_multi_event_listener_aux(const OHOS::SocketIO::SocketIOContext &context, const std::string &name,
                                    sio::message::list const &message, bool needAck, sio::message::list &ack_message,
                                    SocketIOClient* client)
    {
        client->isOnce = false;
        handler_multi_event_listener_aux(context, name, message, needAck, ack_message, client);
    }

    void on_error_listener(sio::message::ptr const &message, SocketIOClient* client)
    {
        std::string error_string = "on error";
        
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, LOG_TAG, "SOCKETIO_TAG------> on_error_listener classId: %{public}s", 
                     client ? client->classIdStr.c_str() : "null");
        
        if (client && client->tsfnOnErrorCall) {
            std::unique_ptr<ThreadSafeInfo> localThreadSafeInfo = std::make_unique<ThreadSafeInfo>();
            if (!localThreadSafeInfo) {
                OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, LOG_TAG, "[on_error_listener]localThreadSafeInfo is null");
                return;
            }
            localThreadSafeInfo->result = error_string;
            
            napi_acquire_threadsafe_function(client->tsfnOnErrorCall);
            napi_call_threadsafe_function(client->tsfnOnErrorCall, localThreadSafeInfo.release(), napi_tsfn_blocking);
        }
    }

    std::string build_emit_message_json_old(sio::message::list const &list)
    {
        std::string str;
        str += "{";
        if (list.at(0)->get_flag() == sio::message::flag_object) {
            std::map<std::string, sio::message::ptr> messageMap = list.at(0)->get_map();
            for (auto it : messageMap) {
                if (messageMap.begin()->first != it.first) {
                    str += ",";
                }
                str += "\"" + it.first + "\":" + get_message_value(it.second);
            }
        } else {
            str += "\"message\":" + get_message_value(list.at(0));
        }
        str += "}";
        return str;
    }

    std::string build_emit_message_json(sio::message::list const &list)
    {
        std::string str;
        if (list.size() == 1) {
            str = build_emit_message_json_old(list);
        } else {
            str += "[";
            for (int16_t index = 0; index < list.size(); index++) {
                std::string tmp;
                if ((list.at(index)->get_flag() == sio::message::flag_binary)) {
                    tmp = std::string("\"") + *(list.at(index)->get_binary()) + "\"";
                } else {
                    tmp = get_message_value(list.at(index));
                }
                str += tmp;
                if (index < list.size() - 1) {
                    str += ",";
                }
            }
            str += "]";
        }
        return str;
    }

    void on_emit_callback(SocketIOClient* client, std::string const &ackName, sio::message::list const &list)
    {
        OH_LOG_Print(LOG_APP,   LOG_INFO,   LOG_DOMAIN,   LOG_TAG, "SOCKETIO_TAG------> 0 on_emit_callback -------");

        if (!client) {
            OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, LOG_TAG, "client not found for emit callback");
            return;
        }
        
        napi_ref on_emit_listener_call_ref = client->on_emit_listener_call_ref_map[ackName.c_str()];
        if (on_emit_listener_call_ref == nullptr) {
            OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, LOG_TAG, "on_emit_listener_call_ref is null");
            return;
        }
        std::string messageJson = build_emit_message_json(list);
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, LOG_TAG, "SOCKETIO_TAG------> 1 on_emit_callback %{public}s",
                     messageJson.c_str());

        std::unique_ptr<ThreadSafeInfo> localThreadSafeInfo = std::make_unique<ThreadSafeInfo>();
        if (!localThreadSafeInfo) {
            OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, LOG_TAG, "[on_emit_callback]localThreadSafeInfo is null");
            return;
        }
        localThreadSafeInfo->result = messageJson;

        // 使用与该事件名绑定的 TSFN（队列 FIFO 出队），确保同名并发 emit 分别回调
        auto qIt = client->on_emit_tsfn_map.find(ackName);
        if (qIt == client->on_emit_tsfn_map.end() || qIt->second.empty()) {
            OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, LOG_TAG, "[on_emit_callback] tsfn queue empty for event");
            return;
        }
        napi_threadsafe_function tsfn = qIt->second.front();
        qIt->second.pop_front();
        if (qIt->second.empty()) {
            client->on_emit_tsfn_map.erase(qIt);
        }

        napi_acquire_threadsafe_function(tsfn);
        napi_call_threadsafe_function(tsfn, localThreadSafeInfo.release(), napi_tsfn_blocking);
        napi_release_threadsafe_function(tsfn, napi_tsfn_release);
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
    std::lock_guard<std::mutex> lock(g_clientMapMutex);
    SocketIOClient *client = nullptr;
    auto iter = g_clientMap.find(classIdStr);
    if (iter != g_clientMap.end()) {
        client = g_clientMap[classIdStr];
        return client;
    } 
    return nullptr;
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
    client->headerMap = parseConfigString(myString);

    return 0;
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
    client->optionMap = parseConfigString(myString);

    return 0;
}

napi_value SocketIOClient::set_path(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = { nullptr };
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    char path[MAX_BUF_SIZE];
    napi_get_value_string_utf8(env, args[0], path, MAX_BUF_SIZE, &result);

    size_t charLen = 0;
    char classId[CLASSID_BUF_SIZE] = { 0 };
    napi_get_value_string_utf8(env, args[1], classId, CLASSID_BUF_SIZE, &charLen);
    std::string classIdStr = classId;
    SocketIOClient* client = getClient(classIdStr);
    if (!client) { return nullptr; }

    std::string inputPath(path);
    // 去除开头和结尾的 '/'
    size_t start = 0;
    size_t end = inputPath.length();

    if (!inputPath.empty() && inputPath.front() == '/') {
        start = 1;
    }
    if (!inputPath.empty() && inputPath.back() == '/') {
        end -= 1;
    }
    if (start < end) {
        inputPath = inputPath.substr(start, end - start);
    } else {
        inputPath = "";
    }
    client->path = inputPath;
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
    if (!client) { return nullptr; };

    std::string uriString(uri);
    // 检查并拼接路径
    if (!client->path.empty()) {
        // 规范化 uriString，确保以 '/' 结尾
        if (!uriString.empty() && uriString.back() != '/') {
            uriString += '/';
        }
        // 拼接路径，确保最终以 '/' 结尾
        uriString += client->path + '/';
    } else {
        // 如果不拼接路径，确保 uriString 以 '/' 结尾
        if (!uriString.empty() && uriString.back() != '/') {
            uriString += '/';
        }
    }
    // 调用 connect，使用拼接后的url
    client->clientInstance->connect(uriString, client->optionMap, client->headerMap);
    return 0;
}

napi_value SocketIOClient::set_open_listener(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    napi_value on_open_call = args[0];

    size_t charLen = 0;
    char classId[CLASSID_BUF_SIZE] = {0};
    napi_get_value_string_utf8(env, args[1], classId, CLASSID_BUF_SIZE, &charLen);
    std::string classIdStr = classId;
    SocketIOClient *client = getClient(classIdStr);
    if (!client) { return nullptr; }

    // 使用实例级别的引用
    napi_create_reference(env, on_open_call, 1, &client->on_open_call_ref);
    
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, LOG_TAG, "SOCKETIO_TAG------> 1 set_open_listener classId: %{public}s", 
                 classIdStr.c_str());
    
    // 为此实例创建专用的TSFN
    NapiCreateThreadsafe(env, on_open_call, CallJsNoParames, &(client->tsfnOnOpenCall));

    // 绑定回调时传递client实例
    client->clientInstance->set_open_listener([client]() {
        g_clientSocket.OnOpen(client);
    });

    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, LOG_TAG, "SOCKETIO_TAG------> 2 set_open_listener ");
    return 0;
}

napi_value SocketIOClient::set_fail_listener(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    napi_value on_fail_call = args[0];

    size_t charLen = 0;
    char classId[CLASSID_BUF_SIZE] = {0};
    napi_get_value_string_utf8(env, args[1], classId, CLASSID_BUF_SIZE, &charLen);
    std::string classIdStr = classId;
    SocketIOClient *client = getClient(classIdStr);
    if (!client) { return nullptr; }
    
    // 使用实例级别的引用
    napi_create_reference(env, on_fail_call, 1, &client->on_fail_call_ref);

    // 为此实例创建专用的TSFN
    NapiCreateThreadsafe(env, on_fail_call, CallJsNoParames, &(client->tsfnFailCall));

    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, LOG_TAG, "SOCKETIO_TAG------> set_fail_listener classId: %{public}s", 
                 classIdStr.c_str());

    // 绑定回调时传递client实例
    client->clientInstance->set_fail_listener([client]() {
        g_clientSocket.OnFail(client);
    });
    return 0;
}

napi_value SocketIOClient::set_reconnecting_listener(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    napi_value on_reconnecting_call = args[0];

    size_t charLen = 0;
    char classId[CLASSID_BUF_SIZE] = {0};
    napi_get_value_string_utf8(env, args[1], classId, CLASSID_BUF_SIZE, &charLen);
    std::string classIdStr = classId;
    SocketIOClient *client = getClient(classIdStr);
    if (!client) { return nullptr; }

    // 使用实例级别的引用
    napi_create_reference(env, on_reconnecting_call, 1, &client->on_reconnecting_call_ref);

    // 为此实例创建专用的TSFN
    NapiCreateThreadsafe(env, on_reconnecting_call, CallJsNoParames, &(client->tsfnReconnectingCall));
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, LOG_TAG, "SOCKETIO_TAG------> set_reconnecting_listener classId: %{public}s", 
                 classIdStr.c_str());

    // 绑定回调时传递client实例
    client->clientInstance->set_reconnecting_listener([client]() {
        g_clientSocket.OnReconnecting(client);
    });
    return 0;
}

napi_value SocketIOClient::set_reconnect_listener(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    napi_value on_reconnect_call = args[0];

    size_t charLen = 0;
    char classId[CLASSID_BUF_SIZE] = {0};
    napi_get_value_string_utf8(env, args[1], classId, CLASSID_BUF_SIZE, &charLen);
    std::string classIdStr = classId;
    SocketIOClient *client = getClient(classIdStr);
    if (!client) { return nullptr; }

    // 使用实例级别的引用
    napi_create_reference(env, on_reconnect_call, 1, &client->on_reconnect_call_ref);
    
    // 为此实例创建专用的TSFN
    NapiCreateThreadsafe(env, on_reconnect_call, CallJsNoParames, &(client->tsfnReconnectCall));
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, LOG_TAG, "SOCKETIO_TAG------> set_reconnect_listener classId: %{public}s", 
                 classIdStr.c_str());

    // 绑定回调时传递client实例
    client->clientInstance->set_reconnect_listener([client](unsigned attempts, unsigned delay) {
        g_clientSocket.OnReconnect(attempts, delay, client);
    });
    return 0;
}

napi_value SocketIOClient::set_close_listener(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    napi_value on_close_call = args[0];

    size_t charLen = 0;
    char classId[CLASSID_BUF_SIZE] = {0};
    napi_get_value_string_utf8(env, args[1], classId, CLASSID_BUF_SIZE, &charLen);
    std::string classIdStr = classId;
    SocketIOClient *client = getClient(classIdStr);
    if (!client) { return nullptr; }
    
    // 使用实例级别的引用
    napi_create_reference(env, on_close_call, 1, &client->on_close_call_ref);

    // 为此实例创建专用的TSFN
    NapiCreateThreadsafe(env, on_close_call, CallJsEmit, &(client->tsfnCloseCall));
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, LOG_TAG, "SOCKETIO_TAG------> set_close_listener classId: %{public}s", 
                 classIdStr.c_str());

    // 绑定回调时传递client实例
    client->clientInstance->set_close_listener([client](sio::client::close_reason const &reason) {
        g_clientSocket.on_close(reason, client);
    });
    return 0;
}

napi_value SocketIOClient::set_socket_open_listener(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    napi_value on_socket_open_call = args[0];

    size_t charLen = 0;
    char classId[CLASSID_BUF_SIZE] = {0};
    napi_get_value_string_utf8(env, args[1], classId, CLASSID_BUF_SIZE, &charLen);
    std::string classIdStr = classId;
    SocketIOClient *client = getClient(classIdStr);
    if (!client) { return nullptr; }

    // 为此实例创建专用的TSFN
    NapiCreateThreadsafe(env, on_socket_open_call, CallJsEmit, &(client->tsfnOnSocketioOpenCall));
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, LOG_TAG, "SOCKETIO_TAG------> set_socket_open_listener classId: %{public}s", 
                 classIdStr.c_str());

    // 绑定回调时传递client实例
    client->clientInstance->set_socket_open_listener([client](std::string const &nsp) {
        g_clientSocket.on_socket_open(nsp, client);
    });
    return 0;
}

napi_value SocketIOClient::set_socket_close_listener(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    napi_value on_socket_close_call = args[0];

    size_t charLen = 0;
    char classId[CLASSID_BUF_SIZE] = {0};
    napi_get_value_string_utf8(env, args[1], classId, CLASSID_BUF_SIZE, &charLen);
    std::string classIdStr = classId;
    SocketIOClient *client = getClient(classIdStr);
    if (!client) { return nullptr; }

    // 使用实例级别的引用
    napi_create_reference(env, on_socket_close_call, 1, &client->on_socket_close_call_ref);

    // 为此实例创建专用的TSFN
    NapiCreateThreadsafe(env, on_socket_close_call, CallJsEmit, &(client->tsfnOnCloseCall));
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, LOG_TAG, "SOCKETIO_TAG------> set_socket_close_listener classId: %{public}s", 
                 classIdStr.c_str());

    // 绑定回调时传递client实例
    client->clientInstance->set_socket_close_listener([client](std::string const &nsp) {
        g_clientSocket.on_socket_close(nsp, client);
    });
    return 0;
}

napi_value SocketIOClient::clear_con_listeners(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    size_t charLen = 0;
    char classId[CLASSID_BUF_SIZE] = {0};
    napi_get_value_string_utf8(env, args[0], classId, CLASSID_BUF_SIZE, &charLen);
    std::string classIdStr = classId;
    SocketIOClient *client = getClient(classIdStr);
    if (!client) { return nullptr; }

    client->clientInstance->clear_con_listeners();
    return 0;
}

napi_value SocketIOClient::clear_socket_listeners(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    size_t charLen = 0;
    char classId[CLASSID_BUF_SIZE] = {0};
    napi_get_value_string_utf8(env, args[0], classId, CLASSID_BUF_SIZE, &charLen);
    std::string classIdStr = classId;
    SocketIOClient *client = getClient(classIdStr);
    if (!client) { return nullptr; }

    client->clientInstance->clear_socket_listeners();
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
    if (!client) { return nullptr; }

    client->clientInstance->set_reconnect_attempts((int)attempts);
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
    if (!client) { return nullptr; }

    client->clientInstance->set_reconnect_delay((unsigned)millis);
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
    if (!client) { return nullptr; }

    client->clientInstance->set_reconnect_delay_max((unsigned)millis);
    return 0;
}

napi_value SocketIOClient::set_logs_default(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    // classId 参数 - 可以忽略，因为这个函数是空的
    return 0;
}

napi_value SocketIOClient::set_logs_quiet(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    // classId 参数 - 可以忽略，因为这个函数是空的
    return 0;
}

napi_value SocketIOClient::set_logs_verbose(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    // classId 参数 - 可以忽略，因为这个函数是空的
    return 0;
}

napi_value SocketIOClient::close(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    size_t charLen = 0;
    char classId[CLASSID_BUF_SIZE] = {0};
    napi_get_value_string_utf8(env, args[0], classId, CLASSID_BUF_SIZE, &charLen);
    std::string classIdStr = classId;
    SocketIOClient *client = getClient(classIdStr);
    if (!client) { return nullptr; }

    client->clientInstance->close();
    return 0;
}

napi_value SocketIOClient::sync_close(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    size_t charLen = 0;
    char classId[CLASSID_BUF_SIZE] = {0};
    napi_get_value_string_utf8(env, args[0], classId, CLASSID_BUF_SIZE, &charLen);
    std::string classIdStr = classId;
    SocketIOClient *client = getClient(classIdStr);
    if (!client) { return nullptr; }

    client->clientInstance->sync_close();
    return 0;
}

napi_value SocketIOClient::set_proxy_basic_auth(napi_env env, napi_callback_info info)
{
    // Note: This function currently does nothing with the proxy settings
    return 0;
}

napi_value SocketIOClient::opened(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    size_t charLen = 0;
    char classId[CLASSID_BUF_SIZE] = {0};
    napi_get_value_string_utf8(env, args[0], classId, CLASSID_BUF_SIZE, &charLen);
    std::string classIdStr = classId;
    SocketIOClient *client = getClient(classIdStr);
    if (!client) { 
        napi_value napi_opened;
        napi_get_boolean(env, false, &napi_opened);
        return napi_opened;
    }

    bool opened = client->clientInstance->opened();
    napi_value napi_opened;
    napi_get_boolean(env, opened, &napi_opened);
    return napi_opened;
}

napi_value SocketIOClient::get_sessionid(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    size_t charLen = 0;
    char classId[CLASSID_BUF_SIZE] = {0};
    napi_get_value_string_utf8(env, args[0], classId, CLASSID_BUF_SIZE, &charLen);
    std::string classIdStr = classId;
    SocketIOClient *client = getClient(classIdStr);
    if (!client) {
        napi_value napi_sessionid;
        napi_create_string_utf8(env, "", 0, &napi_sessionid);
        return napi_sessionid;
    }

    std::string sessionid = client->clientInstance->get_sessionid();
    napi_value napi_sessionid;
    napi_create_string_utf8(env, sessionid.c_str(), sessionid.length(), &napi_sessionid);
    return napi_sessionid;
}

// socket相关napi接口

sio::socket::ptr SocketIOClient::get_socket(const std::string& classIdStr) const
{
    SocketIOClient *client = getClient(classIdStr);
    if (!client) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, LOG_TAG, "get_socket: 未找到对应的 client");
        return nullptr;
    }
    if (client->nsp.empty()) {
        return client->clientInstance->socket();
    } else {
        return client->clientInstance->socket(client->nsp);
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

    size_t charLen = 0;
    char classId[CLASSID_BUF_SIZE] = {0};
    napi_get_value_string_utf8(env, args[2], classId, CLASSID_BUF_SIZE, &charLen);
    std::string classIdStr = classId;
    SocketIOClient *client = getClient(classIdStr);
    if (!client) { return nullptr; }

    napi_ref on_event_listener_call_aux_ref;
    napi_create_reference(env, on_event_listener_call_aux, 1, &on_event_listener_call_aux_ref);
    client->on_event_listener_call_aux_ref_map.insert(
        {eventName, on_event_listener_call_aux_ref});

    auto tsfunc_context = new OHOS::SocketIO::SocketIOContext(env);

    tsfunc_context->CreateTsFunction(on_event_listener_call_aux, "on", tsfunc_context, CallJsEmit);

    auto socket = client->get_socket(classIdStr);
    if (socket) {
        socket->on(eventName, *tsfunc_context,
                     std::bind(&ClientSocket::on_event_listener_aux, &g_clientSocket, std::placeholders::_1,
                               std::placeholders::_2, std::placeholders::_3, std::placeholders::_4,
                               std::placeholders::_5, client));
    }
    return 0;
}

napi_value SocketIOClient::once(napi_env env, napi_callback_info info)
{
    size_t argc = 3;
    napi_value args[3] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    char eventName[MAX_BUF_SIZE];
    napi_get_value_string_utf8(env, args[0], eventName, MAX_BUF_SIZE, &result);

    // 获取classId参数
    char classIdStr[CLASSID_BUF_SIZE];
    napi_get_value_string_utf8(env, args[2], classIdStr, CLASSID_BUF_SIZE, &result);

    // 获取对应的client实例
    SocketIOClient* client = getClient(std::string(classIdStr));
    if (!client) {
        return nullptr;
    }

    napi_value on_event_listener_call_aux = args[1];
    napi_ref on_event_listener_call_aux_ref;
    napi_create_reference(env, on_event_listener_call_aux, 1, &on_event_listener_call_aux_ref);
    client->on_event_listener_call_aux_ref_map.insert(
        {eventName, on_event_listener_call_aux_ref});
    auto tsfunc_context = new OHOS::SocketIO::SocketIOContext(env);

    tsfunc_context->CreateTsFunction(on_event_listener_call_aux, "once", tsfunc_context, CallJsEmit);

    auto socket = client->get_socket(std::string(classIdStr));
    if (socket) {
        socket->on(eventName, *tsfunc_context,
                         std::bind(&ClientSocket::once_event_listener_aux, &g_clientSocket, std::placeholders::_1,
                                   std::placeholders::_2, std::placeholders::_3, std::placeholders::_4,
                                   std::placeholders::_5, client));
    }
    return 0;
}

napi_value SocketIOClient::on_binary(napi_env env, napi_callback_info info)
{
    size_t argc = 3;
    napi_value args[3] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    char eventName[MAX_BUF_SIZE];
    napi_get_value_string_utf8(env, args[0], eventName, MAX_BUF_SIZE, &result);

    // 获取classId参数
    char classIdStr[CLASSID_BUF_SIZE];
    napi_get_value_string_utf8(env, args[2], classIdStr, CLASSID_BUF_SIZE, &result);

    // 获取对应的client实例
    SocketIOClient* client = getClient(std::string(classIdStr));
    if (!client) {
        return nullptr;
    }

    napi_value on_event_listener_call_aux = args[1];
    napi_ref on_event_listener_call_aux_ref;
    napi_create_reference(env, on_event_listener_call_aux, 1, &on_event_listener_call_aux_ref);
    client->on_event_listener_call_aux_ref_map.insert(
        {eventName, on_event_listener_call_aux_ref});

    auto tsfunc_context = new OHOS::SocketIO::SocketIOContext(env);

    tsfunc_context->CreateTsFunction(on_event_listener_call_aux, "on_binary", tsfunc_context, CallJsBinary);

    auto socket = client->get_socket(std::string(classIdStr));
    if (socket) {
        socket->on(eventName, *tsfunc_context,
                         std::bind(&ClientSocket::on_binary_event_listener_aux, &g_clientSocket, std::placeholders::_1,
                                   std::placeholders::_2, std::placeholders::_3, std::placeholders::_4,
                                   std::placeholders::_5, client));
    }
    return 0;
}

napi_value SocketIOClient::on_multi(napi_env env, napi_callback_info info)
{
    size_t argc = 3;
    napi_value args[3] = {nullptr};
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, "LOG_TAG", "SOCKETIO_TAG_NAPI------>on_multi %{public}d");
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    char eventName[MAX_BUF_SIZE];
    napi_get_value_string_utf8(env, args[0], eventName, MAX_BUF_SIZE, &result);

    size_t charLen = 0;
    char classId[CLASSID_BUF_SIZE] = {0};
    napi_get_value_string_utf8(env, args[ARG_INDEX_2], classId, CLASSID_BUF_SIZE, &charLen);

    // 获取对应的client实例
    SocketIOClient* client = getClient(std::string(classId));
    if (!client) {
        return nullptr;
    }

    napi_value on_event_listener_call_aux = args[1];
    napi_ref on_event_listener_call_aux_ref;
    napi_create_reference(env, on_event_listener_call_aux, 1, &on_event_listener_call_aux_ref);
    client->on_event_listener_call_aux_ref_map.insert({eventName, on_event_listener_call_aux_ref});

    auto tsfunc_context = new OHOS::SocketIO::SocketIOContext(env);

    tsfunc_context->CreateTsFunction(on_event_listener_call_aux, "on_multi", tsfunc_context, CallJsEmit);

    client->get_socket(std::string(classId))
        ->on(eventName, *tsfunc_context,
             std::bind(&ClientSocket::on_multi_event_listener_aux, &g_clientSocket, std::placeholders::_1,
                       std::placeholders::_2, std::placeholders::_3, std::placeholders::_4,
                       std::placeholders::_5, client));
    return 0;
}

napi_value SocketIOClient::off(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    char eventName[MAX_BUF_SIZE];
    napi_get_value_string_utf8(env, args[0], eventName, MAX_BUF_SIZE, &result);

    // 获取classId参数
    char classIdStr[CLASSID_BUF_SIZE];
    napi_get_value_string_utf8(env, args[1], classIdStr, CLASSID_BUF_SIZE, &result);

    // 获取对应的client实例
    SocketIOClient* client = getClient(std::string(classIdStr));
    if (!client) {
        return nullptr;
    }

    auto socket = client->get_socket(std::string(classIdStr));
    if (socket) {
        socket->off(eventName);
    }
    return 0;
}

napi_value SocketIOClient::off_all(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    // 获取classId参数
    char classIdStr[CLASSID_BUF_SIZE];
    napi_get_value_string_utf8(env, args[0], classIdStr, CLASSID_BUF_SIZE, &result);

    // 获取对应的client实例
    SocketIOClient* client = getClient(std::string(classIdStr));
    if (!client) {
        return nullptr;
    }

    auto socket = client->get_socket(std::string(classIdStr));
    if (socket) {
        socket->off_all();
    }
    return 0;
}

napi_value SocketIOClient::socket_close(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    // 获取classId参数
    char classIdStr[CLASSID_BUF_SIZE];
    napi_get_value_string_utf8(env, args[0], classIdStr, CLASSID_BUF_SIZE, &result);

    // 获取对应的client实例
    SocketIOClient* client = getClient(std::string(classIdStr));
    if (!client) {
        return nullptr;
    }

    auto socket = client->get_socket(std::string(classIdStr));
    if (socket) {
        socket->close();
    }
    return 0;
}
napi_value SocketIOClient::on_error(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    // 获取classId参数
    char classIdStr[CLASSID_BUF_SIZE];
    napi_get_value_string_utf8(env, args[1], classIdStr, CLASSID_BUF_SIZE, &result);

    // 获取对应的client实例
    SocketIOClient* client = getClient(std::string(classIdStr));
    if (!client) {
        return nullptr;
    }

    napi_value on_error_listener_call = args[0];
    napi_create_reference(env, on_error_listener_call, 1, &client->on_error_listener_call_ref);

    // 为此实例创建专用的TSFN
    NapiCreateThreadsafe(env, on_error_listener_call, CallJsEmit, &(client->tsfnOnErrorCall));

    auto socket = client->get_socket(std::string(classIdStr));
    if (socket) {
        // 绑定回调时传递client实例
        socket->on_error([client](sio::message::ptr const& message) {
            g_clientSocket.on_error_listener(message, client);
        });
    }
    return 0;
}

napi_value SocketIOClient::off_error(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    // 获取classId参数
    char classIdStr[CLASSID_BUF_SIZE];
    napi_get_value_string_utf8(env, args[0], classIdStr, CLASSID_BUF_SIZE, &result);

    // 获取对应的client实例
    SocketIOClient* client = getClient(std::string(classIdStr));
    if (!client) {
        return nullptr;
    }

    auto socket = client->get_socket(std::string(classIdStr));
    if (socket) {
        socket->off_error();
    }
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

static std::string GetClassId(napi_env env, napi_value val)
{
    size_t charLen = 0;
    char classId[CLASSID_BUF_SIZE] = {0};
    napi_get_value_string_utf8(env, val, classId, CLASSID_BUF_SIZE, &charLen);
    std::string classIdStr = classId;
    return classIdStr;
}

static void SetMessageList(napi_env env, napi_value *pArgs, size_t cnt, sio::message::list *messageList)
{
    for (int index = 0; index < cnt; index++) {
        // 获取参数 2 的数据类型是否是 Uint8Array 类型
        bool isArraybuffer;
        napi_is_typedarray(env, pArgs[index], &isArraybuffer);
        // 客户端发送一般消息和二进制消息处理逻辑
        if (isArraybuffer) {
            // 获取 Uint8Array 信息
            void* data;
            size_t byteLength;
            napi_typedarray_type type;
            napi_value array_buffer;
            size_t offset;
            napi_get_typedarray_info(env, pArgs[index], &type, &byteLength, &data, &array_buffer, &offset);

            // 将 Uint8Array 数据转化为 std::string 用于底层库
            std::string uint8ArrayStr(static_cast<char*>(data), byteLength);

            std::shared_ptr<std::string> message_binary = std::make_shared<std::string>(uint8ArrayStr);
            messageList->push(message_binary);
            message_binary = nullptr;
        } else {
            // 客户端发送非二进制消息处理逻辑，备注：这里只支持object,string。
            napi_valuetype messageType;
            napi_typeof(env, pArgs[index], &messageType);

            if (messageType == napi_string) {
                char message[MAX_MESSAGE_SIZE] = {};
                size_t messageLength;
                napi_get_value_string_utf8(env, pArgs[index], message, MAX_MESSAGE_SIZE, &messageLength);
                messageList->push(message);
            } else if (messageType == napi_object) {
                sio::object_message::ptr message_item = get_object_message(env, pArgs[index]);
                messageList->push(message_item);
                message_item = nullptr;
            }
        }
    }
}

napi_value SocketIOClient::emit(napi_env env, napi_callback_info info)
{
    size_t argc = EMIT_ARGC_MAX_NUM;
    napi_value args[EMIT_ARGC_MAX_NUM] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    // 获取参数 1 事件名称
    char eventName[MAX_MESSAGE_SIZE];
    napi_get_value_string_utf8(env, args[0], eventName, MAX_MESSAGE_SIZE, &result);
    // 获取classId参数
    std::string id = GetClassId(env, args[argc-1]);
    // 获取对应的client实例
    SocketIOClient* client = getClient(id);
    if (!client) {
        return nullptr;
    }
    // 获取参数 3 callback
    napi_value on_emit_listener_call = args[argc-EMIT_CALLBACK_INDEX];
    napi_ref on_emit_listener_call_ref;
    napi_create_reference(env, on_emit_listener_call, 1, &on_emit_listener_call_ref);
    client->on_emit_listener_call_ref_map[eventName] = on_emit_listener_call_ref;
    sio::message::list *messageList = new sio::message::list();
    SetMessageList(env, &args[1], argc-EMIT_CALLBACK_INDEX, messageList);
    // 为当前事件创建独立 TSFN，避免并发 emit 时全局 TSFN 被覆盖
    napi_threadsafe_function tsfn_for_event;
    NapiCreateThreadsafe(env, on_emit_listener_call, CallJsEmit, &tsfn_for_event);
    client->on_emit_tsfn_map[eventName].push_back(tsfn_for_event);
    auto socket = client->get_socket(id);
    if (socket) {
        socket->emit(eventName, *messageList, std::bind(&ClientSocket::on_emit_callback, &g_clientSocket,
            client, std::placeholders::_1, std::placeholders::_2));
    }
    delete messageList;
    messageList = nullptr;
    return 0;
}

napi_value SocketIOClient::set_connection_mode(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    char charUrip[MAX_BUF_SIZE];
    napi_get_value_string_utf8(env, args[0], charUrip, MAX_BUF_SIZE, &result);

    size_t charLen = 0;
    char classId[CLASSID_BUF_SIZE] = {0};
    napi_get_value_string_utf8(env, args[1], classId, CLASSID_BUF_SIZE, &charLen);
    std::string classIdStr = classId;
    SocketIOClient* client = getClient(classIdStr);
    if (!client) { return nullptr; }
    client->clientInstance = new sio::client(charUrip);
    return 0;
}

napi_value SocketIOClient::get_current_state(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    size_t charLen = 0;
    char classId[CLASSID_BUF_SIZE] = {0};
    napi_get_value_string_utf8(env, args[0], classId, CLASSID_BUF_SIZE, &charLen);
    std::string classIdStr = classId;
    SocketIOClient *client = getClient(classIdStr);
    if (!client) {
        napi_value napi_state;
        napi_create_int32(env, 0, &napi_state);
        return napi_state;
    }

    auto state = client->clientInstance->get_current_state();
    napi_value napi_state;
    napi_create_int32(env, static_cast<int32_t>(state), &napi_state);
    return napi_state;
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
    OH_LOG_Print(LOG_APP, LOG_DEBUG, LOG_DOMAIN, LOG_TAG, "ss.str() JsConstructor classIdStr: %{public}s",
                 classIdStrTemp.data());

    napi_value napiClassId;
    napi_create_string_utf8(env, classIdStrTemp.c_str(), classIdStrTemp.length(), &napiClassId);
    napi_set_named_property(env, targetObj, "classId", napiClassId);
    
    // 使用锁保护全局映射的并发访问
    {
        std::lock_guard<std::mutex> lock(g_clientMapMutex);
        g_clientMap.insert(std::pair<std::string, SocketIOClient *>(classIdStrTemp, classBind));
    }

    napi_wrap(
        env, nullptr, classBind,
        [](napi_env env, void *data, void *hint) {
            SocketIOClient *bind = static_cast<SocketIOClient *>(data);
            if (bind == nullptr) {
                return;
            }
            // 先获取 key，避免 delete 后解引用
            std::string id = bind->classIdStr;
            {
                std::lock_guard<std::mutex> lock(g_clientMapMutex);
                g_clientMap.erase(id);
            }
            delete bind;
        },
        nullptr, nullptr);
    return targetObj;
}

EXTERN_C_START

static napi_property_descriptor classProp[] = {
        {"set_headers", nullptr, SocketIOClient::set_headers, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"set_option", nullptr, SocketIOClient::set_option, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"set_path", nullptr, SocketIOClient::set_path, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"connect", nullptr, SocketIOClient::connect, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"set_open_listener", nullptr, SocketIOClient::set_open_listener, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"set_fail_listener", nullptr, SocketIOClient::set_fail_listener, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"set_reconnecting_listener", nullptr, SocketIOClient::set_reconnecting_listener, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"set_reconnect_listener", nullptr, SocketIOClient::set_reconnect_listener, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"set_close_listener", nullptr, SocketIOClient::set_close_listener, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"set_socket_open_listener", nullptr, SocketIOClient::set_socket_open_listener, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"set_socket_close_listener", nullptr, SocketIOClient::set_socket_close_listener, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"clear_con_listeners", nullptr, SocketIOClient::clear_con_listeners, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"clear_socket_listeners", nullptr, SocketIOClient::clear_socket_listeners, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"set_reconnect_attempts", nullptr, SocketIOClient::set_reconnect_attempts, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"set_reconnect_delay", nullptr, SocketIOClient::set_reconnect_delay, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"set_reconnect_delay_max", nullptr, SocketIOClient::set_reconnect_delay_max, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"set_logs_default", nullptr, SocketIOClient::set_logs_default, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"set_logs_quiet", nullptr, SocketIOClient::set_logs_quiet, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"set_logs_verbose", nullptr, SocketIOClient::set_logs_verbose, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"close", nullptr, SocketIOClient::close, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"sync_close", nullptr, SocketIOClient::sync_close, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"set_proxy_basic_auth", nullptr, SocketIOClient::set_proxy_basic_auth, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"opened", nullptr, SocketIOClient::opened, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"get_sessionid", nullptr, SocketIOClient::get_sessionid, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"set_nsp", nullptr, SocketIOClient::set_nsp, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"on", nullptr, SocketIOClient::on, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"once", nullptr, SocketIOClient::once, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"on_binary", nullptr, SocketIOClient::on_binary, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"off", nullptr, SocketIOClient::off, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"off_all", nullptr, SocketIOClient::off_all, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"socket_close", nullptr, SocketIOClient::socket_close, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"on_error", nullptr, SocketIOClient::on_error, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"off_error", nullptr, SocketIOClient::off_error, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"emit", nullptr, SocketIOClient::emit, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"set_connection_mode", nullptr, SocketIOClient::set_connection_mode, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"get_current_state", nullptr, SocketIOClient::get_current_state, nullptr, nullptr, nullptr, napi_default, nullptr},
    {"on_multi", nullptr, SocketIOClient::on_multi, nullptr, nullptr, nullptr, napi_default, nullptr},
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

static napi_module demoModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "client_socket_c",
    .nm_priv = ((void *)0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterSocketIoModule(void)
{
    napi_module_register(&demoModule);
}