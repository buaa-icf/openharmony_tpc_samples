/*
  Copyright (C) 2022 Huawei Device Co., Ltd.

  This software is distributed under a license. The full license
  agreement can be found in the file LICENSE in this distribution.
  This software may not be copied, modified, sold or distributed
  other than expressed in the named license agreement.
  This software is distributed without any warranty.
*/

#include "napi/native_api.h"
#include "Smack.h"
#include "log.h"
#include "registration.h"
#include "room.h"
#include <js_native_api.h>
#include <js_native_api_types.h>
#include <string.h>

#define MAX_STRING_LENGTH 1024*5

static Smack *smack = nullptr;
static room *room1 = nullptr;
static registration *mregistration = nullptr;
napi_value js_sb;
size_t register_argc = 2;
size_t register_argc_group = 2;
size_t register_argc_invitation = 1;
size_t register_argc_MUCParticipant = 2;
size_t register_argc_HANDLE_SUBSCRIPTRION_REQUEST = 1;
napi_env register_env;
napi_env register_env_group;
napi_env register_env_invitation;
napi_env register_env_MUCParticipant;
napi_env register_env_HANDLE_SUBSCRIPTRION_REQUEST;

/**
 * 登录    OK
 * @param env
 * @param info
 * @return
 */

static napi_value login(napi_env env, napi_callback_info info) {
    size_t argc = 2;
    napi_value args[2] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    napi_valuetype valuetype1;
    napi_typeof(env, args[1], &valuetype1);

    char value0[MAX_STRING_LENGTH];
    size_t size0 = 0;
    napi_get_value_string_utf8(env, args[0], value0, MAX_STRING_LENGTH, &size0);

    char value1[MAX_STRING_LENGTH];
    size_t size1 = 0;
    napi_get_value_string_utf8(env, args[1], value1, MAX_STRING_LENGTH, &size1);

    smack = new Smack();
    napi_value sum;
    napi_create_int32(env, smack->login(value0, value1), &sum);

    return sum;
}

/**
 * 发送消息
 * @param env
 * @param info
 * @return
 */
static napi_value send(napi_env env, napi_callback_info info) {
    size_t argc = 2;
    napi_value args[2] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    napi_valuetype valuetype1;
    napi_typeof(env, args[1], &valuetype1);

    char value0[MAX_STRING_LENGTH];
    size_t size0 = 0;
    napi_get_value_string_utf8(env, args[0], value0, MAX_STRING_LENGTH, &size0);

    char value1[MAX_STRING_LENGTH];
    size_t size1 = 0;
    napi_get_value_string_utf8(env, args[1], value1, MAX_STRING_LENGTH, &size1);

    smack->send(value0, value1);

    napi_value sum;
    napi_create_string_utf8(env, value0, MAX_STRING_LENGTH, &sum);
    return sum;
}

/**
 * 获取好友列表
 * @param env
 * @param info
 * @return
 */
static napi_value getFriendList(napi_env env, napi_callback_info info) {

    napi_value sum;
    std::string str = smack->getFriendList();
    napi_create_string_utf8(env, str.c_str(), strlen(str.c_str()), &sum);
    return sum;
}

/**
 * 更改用户状态  OK
 * @param env
 * @param info
 * @return
 */
static napi_value changePresence(napi_env env, napi_callback_info info) {
    size_t argc = 2;
    napi_value args[2] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    napi_valuetype valuetype1;
    napi_typeof(env, args[1], &valuetype1);

    char value0[MAX_STRING_LENGTH];
    size_t size0 = 0;
    napi_get_value_string_utf8(env, args[0], value0, MAX_STRING_LENGTH, &size0);

    char value1[MAX_STRING_LENGTH];
    size_t size1 = 0;
    napi_get_value_string_utf8(env, args[1], value1, MAX_STRING_LENGTH, &size1);

    smack->changePresence(value0, value1);

    napi_value sum;
    napi_create_string_utf8(env, value0, MAX_STRING_LENGTH, &sum);
    return sum;
}

/**
 * 退出登录
 * @param env
 * @param info
 * @return
 */
static napi_value loginout(napi_env env, napi_callback_info info) {
    napi_value sum;
    smack->Loginout();

    napi_create_int32(env, 0, &sum);
    return sum;
}

/**
 * 修改密码
 * @param env
 * @param info
 * @return
 */
static napi_value changpwd(napi_env env, napi_callback_info info) {
    size_t argc = 1;
    napi_value args[1] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    char value0[MAX_STRING_LENGTH];
    size_t size0 = 0;
    napi_get_value_string_utf8(env, args[0], value0, MAX_STRING_LENGTH, &size0);

    smack->changePasswords(value0);
    napi_value sum;
    napi_create_string_utf8(env, value0, MAX_STRING_LENGTH, &sum);
    return sum;
}

/**
 * 注册   OK
 * @param env
 * @param info
 * @return
 */
static napi_value registers(napi_env env, napi_callback_info info) {
    size_t argc = 3;
    napi_value args[3] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    napi_valuetype valuetype1;
    napi_typeof(env, args[1], &valuetype1);

    napi_valuetype valuetype2;
    napi_typeof(env, args[2], &valuetype2);

    char value0[MAX_STRING_LENGTH];
    size_t size0 = 0;
    napi_get_value_string_utf8(env, args[0], value0, MAX_STRING_LENGTH, &size0);

    char value1[MAX_STRING_LENGTH];
    size_t size1 = 0;
    napi_get_value_string_utf8(env, args[1], value1, MAX_STRING_LENGTH, &size1);

    char value2[MAX_STRING_LENGTH];
    size_t size2 = 0;
    napi_get_value_string_utf8(env, args[2], value2, MAX_STRING_LENGTH, &size2);

    if (mregistration == nullptr) {
        mregistration = new registration();
    }

    napi_value sum;
    napi_create_int32(env, mregistration->createAccounts(value0, value1, value2), &sum);
    return sum;
}

/**
 * 添加好友
 */
static napi_value addFriends(napi_env env, napi_callback_info info) {
    size_t argc = 3;
    napi_value args[3] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    napi_valuetype valuetype1;
    napi_typeof(env, args[1], &valuetype1);

    napi_valuetype valuetype2;
    napi_typeof(env, args[2], &valuetype1);

    char value0[MAX_STRING_LENGTH];
    size_t size0 = 0;
    napi_get_value_string_utf8(env, args[0], value0, MAX_STRING_LENGTH, &size0);

    char value1[MAX_STRING_LENGTH];
    size_t size1 = 0;
    napi_get_value_string_utf8(env, args[1], value1, MAX_STRING_LENGTH, &size1);

    char value2[MAX_STRING_LENGTH];
    size_t size2 = 0;
    napi_get_value_string_utf8(env, args[2], value2, MAX_STRING_LENGTH, &size2);

    smack->addFriends(value0, value1, value2);

    napi_value sum;
    napi_create_string_utf8(env, value0, MAX_STRING_LENGTH, &sum);
    return sum;
}

/**
 * 创建分组
 * @param env
 * @param info
 * @return
 */
static napi_value createGroup(napi_env env, napi_callback_info info) {
    size_t argc = 1;
    napi_value args[1] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    char value0[MAX_STRING_LENGTH];
    size_t size0 = 0;
    napi_get_value_string_utf8(env, args[0], value0, MAX_STRING_LENGTH, &size0);

    smack->createGroup(value0);

    napi_value sum;
    napi_create_string_utf8(env, value0, MAX_STRING_LENGTH, &sum);
    return sum;
}

/**
 * 删除好友
 * @param env
 * @param info
 * @return
 */
static napi_value delfriend(napi_env env, napi_callback_info info) {
    size_t argc = 1;
    napi_value args[1] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    char value0[MAX_STRING_LENGTH];
    size_t size0 = 0;
    napi_get_value_string_utf8(env, args[0], value0, MAX_STRING_LENGTH, &size0);

    smack->delfriends(value0);

    napi_value sum;
    napi_create_string_utf8(env, value0, MAX_STRING_LENGTH, &sum);
    return sum;
}

/**
 * 删除账户
 * @param env
 * @param info
 * @return
 */
static napi_value unregister(napi_env env, napi_callback_info info) {
    napi_value sum;

    smack->removeAccounts();
    napi_create_int32(env, 0, &sum);
    return sum;
}

/**
 * 更改好友分组
 * @param env
 * @param info
 * @return
 */
static napi_value changeFriendGroup(napi_env env, napi_callback_info info) {
    napi_value sum;
    size_t argc = 2;
    napi_value args[2] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);
    napi_valuetype valuetype1;
    napi_typeof(env, args[1], &valuetype1);

    char value0[MAX_STRING_LENGTH];
    size_t size0 = 0;
    napi_get_value_string_utf8(env, args[0], value0, MAX_STRING_LENGTH, &size0);
    char value1[MAX_STRING_LENGTH];
    size_t size1 = 1;
    napi_get_value_string_utf8(env, args[1], value1, MAX_STRING_LENGTH, &size1);

    smack->changeFriendGroup(value0, value1);
    napi_create_int32(env, 0, &sum);
    return sum;
}

static napi_value changeGroup(napi_env env, napi_callback_info info) {
    size_t argc = 2;
    napi_value args[2] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    napi_valuetype valuetype1;
    napi_typeof(env, args[1], &valuetype1);

    char value0[MAX_STRING_LENGTH];
    size_t size0 = 0;
    napi_get_value_string_utf8(env, args[0], value0, MAX_STRING_LENGTH, &size0);

    char value1[MAX_STRING_LENGTH];
    size_t size1 = 0;
    napi_get_value_string_utf8(env, args[1], value1, MAX_STRING_LENGTH, &size1);

    smack->changeGroup(value0, value1);

    napi_value sum;
    napi_create_int32(env, 0, &sum);
    return sum;
}

/**
 * 返回当前的消息数据
 * @param msg
 */
void message_received(const std::string &id, const std::string &msg) {
    napi_value napi_value_msg;
    napi_value napi_value_id;
    napi_value result;

    napi_create_string_utf8(register_env, msg.c_str(), strlen(msg.c_str()), &napi_value_msg);
    napi_create_string_utf8(register_env, id.c_str(), strlen(id.c_str()), &napi_value_id);
    napi_value argv[] = {napi_value_id, napi_value_msg};

    napi_value global, message_recv_func, arg;

    napi_status status = napi_get_global(register_env, &global);
    if (status != napi_ok) {
        LOGW("napi_get_global error, status:%d", status);
        return;
    }

    status = napi_get_named_property(register_env, global, "message_recv_func", &message_recv_func);
    if (status != napi_ok) {
        LOGW("napi_get_named_property message_recv_func error, status:%d", status);
        return;
    }
    napi_call_function(register_env, global, message_recv_func, register_argc, argv, &result);
}

static napi_value register_message(napi_env env, napi_callback_info info) {
    napi_value args[2] = {nullptr, nullptr};
    napi_get_cb_info(env, info, &register_argc, args, nullptr, nullptr);
    register_env = env;

    return NULL;
}

void message_received_group(const std::string &id, const std::string &msg) {
    napi_value napi_value_msg;
    napi_value napi_value_id;
    napi_value result;

    napi_create_string_utf8(register_env_group, msg.c_str(), strlen(msg.c_str()), &napi_value_msg);
    napi_create_string_utf8(register_env_group, id.c_str(), strlen(id.c_str()), &napi_value_id);
    napi_value argv[] = {napi_value_id, napi_value_msg};

    napi_value global, message_recv_func_group, arg;

    napi_status status = napi_get_global(register_env_group, &global);
    if (status != napi_ok) {
        LOGW("napi_get_global error, status:%d", status);
        return;
    }

    status = napi_get_named_property(register_env_group, global, "message_recv_func_group", &message_recv_func_group);
    if (status != napi_ok) {
        LOGW("napi_get_named_property message_recv_func_group error, status:%d", status);
        return;
    }
    napi_call_function(register_env_group, global, message_recv_func_group, register_argc_group, argv, &result);
}

static napi_value registerMessageGroup(napi_env env, napi_callback_info info) {
    napi_value args[2] = {nullptr, nullptr};
    napi_get_cb_info(env, info, &register_argc_group, args, nullptr, nullptr);
    register_env_group = env;

    return NULL;
}

void handleMUCParticipantPresenceListener(const std::string &nike, const std::string &presenceType) {
    napi_value napi_value_nike;
    napi_value napi_value_presenceType;
    napi_value result;

    napi_create_string_utf8(register_env_MUCParticipant, nike.c_str(), strlen(nike.c_str()), &napi_value_nike);
    napi_create_string_utf8(register_env_MUCParticipant, presenceType.c_str(), strlen(presenceType.c_str()), &napi_value_presenceType);
    napi_value argv[] = {napi_value_nike, napi_value_presenceType};

    napi_value global, message_recv_func_MUCParticipantPresence, arg;

    napi_status status = napi_get_global(register_env_MUCParticipant, &global);
    if (status != napi_ok) {
        LOGW("napi_get_global error, status:%d", status);
        return;
    }

    status = napi_get_named_property(register_env_MUCParticipant, global, "message_recv_func_MUCParticipantPresence", &message_recv_func_MUCParticipantPresence);
    if (status != napi_ok) {
        LOGW("napi_get_named_property message_recv_func_MUCParticipantPresence error, status:%d", status);
        return;
    }
    napi_call_function(register_env_MUCParticipant, global, message_recv_func_MUCParticipantPresence, register_argc_MUCParticipant, argv, &result);
}

static napi_value registerMUCParticipantPresenceListener(napi_env env, napi_callback_info info) {
    napi_value args[2] = {nullptr, nullptr};
    napi_get_cb_info(env, info, &register_argc_MUCParticipant, args, nullptr, nullptr);
    register_env_MUCParticipant = env;

    return NULL;
}

void handleMUCInvitationListener(const std::string &v0) {
    napi_value napi_value_0;
    napi_value result;

    napi_create_string_utf8(register_env_invitation, v0.c_str(), strlen(v0.c_str()), &napi_value_0);
    napi_value argv[] = {napi_value_0};

    napi_value global, message_recv_func_invitation, arg;
    napi_status status = napi_get_global(register_env_invitation, &global);
    if (status != napi_ok) {
        LOGW("napi_get_global error, status:%d", status);
        return;
    }
    status = napi_get_named_property(register_env_invitation, global, "message_recv_func_invitation", &message_recv_func_invitation);
    if (status != napi_ok) {
        LOGW("napi_get_named_property message_recv_func_invitation error, status:%d", status);
        return;
    }
    napi_call_function(register_env_invitation, global, message_recv_func_invitation, register_argc_invitation, argv, &result);
}

static napi_value registerInvitationListener(napi_env env, napi_callback_info info) {
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &register_argc_invitation, args, nullptr, nullptr);
    register_env_invitation = env;

    return NULL;
}

/**
 * createRoom
 * @param env
 * @param info
 * @return 
 */
static napi_value createRoom(napi_env env, napi_callback_info info) {
    size_t argc = 4;
    napi_value args[4] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    napi_valuetype valuetype1;
    napi_typeof(env, args[1], &valuetype1);

    napi_valuetype valuetype2;
    napi_typeof(env, args[2], &valuetype2);

    napi_valuetype valuetype3;
    napi_typeof(env, args[3], &valuetype3);

    char value0[MAX_STRING_LENGTH];
    size_t size0 = 0;
    napi_get_value_string_utf8(env, args[0], value0, MAX_STRING_LENGTH, &size0);

    char value1[MAX_STRING_LENGTH];
    size_t size1 = 0;
    napi_get_value_string_utf8(env, args[1], value1, MAX_STRING_LENGTH, &size1);

    char value2[MAX_STRING_LENGTH];
    size_t size2 = 0;
    napi_get_value_string_utf8(env, args[2], value2, MAX_STRING_LENGTH, &size2);

    char value3[MAX_STRING_LENGTH];
    size_t size3 = 0;
    napi_get_value_string_utf8(env, args[3], value3, MAX_STRING_LENGTH, &size3);

    if (room1 == nullptr) {
        room1 = new room();
    }
    room1->createRoom(smack->getClent(), value0, value1, value2, value3);

    napi_value sum;
    napi_create_string_utf8(env, value0, MAX_STRING_LENGTH, &sum);
    return sum;
}

/**
 * leave
 * @param env
 * @param info
 * @return 
 */
static napi_value leave(napi_env env, napi_callback_info info) {
    size_t argc = 1;
    napi_value args[1] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    char value0[MAX_STRING_LENGTH];
    size_t size0 = 0;
    napi_get_value_string_utf8(env, args[0], value0, MAX_STRING_LENGTH, &size0);

    if (room1 == nullptr) {
        room1 = new room();
    }
    room1->leave(value0);

    napi_value sum;
    napi_create_string_utf8(env, value0, MAX_STRING_LENGTH, &sum);
    return sum;
}

/**
 * sendGroupMessage
 * @param env
 * @param info
 * @return 
 */
static napi_value sendGroupMessage(napi_env env, napi_callback_info info) {
    size_t argc = 1;
    napi_value args[1] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    char value0[MAX_STRING_LENGTH];
    size_t size0 = 0;
    napi_get_value_string_utf8(env, args[0], value0, MAX_STRING_LENGTH, &size0);

    if (room1 == nullptr) {
        room1 = new room();
    }
    room1->sendGroupMessage(value0);

    napi_value sum;
    napi_create_string_utf8(env, value0, MAX_STRING_LENGTH, &sum);
    return sum;
}

/**
 * setSubject
 * @param env
 * @param info
 * @return 
 */
static napi_value setSubject(napi_env env, napi_callback_info info) {
    size_t argc = 1;
    napi_value args[1] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    char value0[MAX_STRING_LENGTH];
    size_t size0 = 0;
    napi_get_value_string_utf8(env, args[0], value0, MAX_STRING_LENGTH, &size0);

    if (room1 == nullptr) {
        room1 = new room();
    }
    room1->setSubject(value0);

    napi_value sum;
    napi_create_string_utf8(env, value0, MAX_STRING_LENGTH, &sum);
    return sum;
}

/**
 * join
 * @param env
 * @param info
 * @return 
 */
static napi_value join(napi_env env, napi_callback_info info) {
    napi_value sum;

    if (room1 == nullptr) {
        room1 = new room();
    }
    room1->join();
    napi_create_int32(env, 0, &sum);
    return sum;
}

/**
 * join
 * @param env
 * @param info
 * @return 
 */
static napi_value destroy(napi_env env, napi_callback_info info) {
    size_t argc = 2;
    napi_value args[2] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    napi_valuetype valuetype1;
    napi_typeof(env, args[1], &valuetype1);

    char value0[MAX_STRING_LENGTH];
    size_t size0 = 0;
    napi_get_value_string_utf8(env, args[0], value0, MAX_STRING_LENGTH, &size0);

    char value1[MAX_STRING_LENGTH];
    size_t size1 = 0;
    napi_get_value_string_utf8(env, args[1], value1, MAX_STRING_LENGTH, &size1);

    if (room1 == nullptr) {
        room1 = new room();
    }
    JID jid(value0);
    room1->destroy("reason", jid, value1);

    napi_value sum;
    napi_create_int32(env, 0, &sum);
    return sum;
}

static napi_value kick(napi_env env, napi_callback_info info) {
    size_t argc = 2;
    napi_value args[2] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    napi_valuetype valuetype1;
    napi_typeof(env, args[1], &valuetype1);

    char value0[MAX_STRING_LENGTH];
    size_t size0 = 0;
    napi_get_value_string_utf8(env, args[0], value0, MAX_STRING_LENGTH, &size0);

    char value1[MAX_STRING_LENGTH];
    size_t size1 = 0;
    napi_get_value_string_utf8(env, args[1], value1, MAX_STRING_LENGTH, &size1);

    if (room1 == nullptr) {
        room1 = new room();
    }
    room1->kick(value0, value1);

    napi_value sum;
    napi_create_int32(env, 0, &sum);
    return sum;
}

static napi_value ban(napi_env env, napi_callback_info info) {
    size_t argc = 2;
    napi_value args[2] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    napi_valuetype valuetype1;
    napi_typeof(env, args[1], &valuetype1);

    char value0[MAX_STRING_LENGTH];
    size_t size0 = 0;
    napi_get_value_string_utf8(env, args[0], value0, MAX_STRING_LENGTH, &size0);

    char value1[MAX_STRING_LENGTH];
    size_t size1 = 0;
    napi_get_value_string_utf8(env, args[1], value1, MAX_STRING_LENGTH, &size1);

    if (room1 == nullptr) {
        room1 = new room();
    }
    room1->ban(value0, value1);

    napi_value sum;
    napi_create_int32(env, 0, &sum);
    return sum;
}

static napi_value grantVoice(napi_env env, napi_callback_info info) {
    size_t argc = 2;
    napi_value args[2] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    napi_valuetype valuetype1;
    napi_typeof(env, args[1], &valuetype1);

    char value0[MAX_STRING_LENGTH];
    size_t size0 = 0;
    napi_get_value_string_utf8(env, args[0], value0, MAX_STRING_LENGTH, &size0);

    char value1[MAX_STRING_LENGTH];
    size_t size1 = 0;
    napi_get_value_string_utf8(env, args[1], value1, MAX_STRING_LENGTH, &size1);

    if (room1 == nullptr) {
        room1 = new room();
    }
    room1->grantVoice(value0, value1);

    napi_value sum;
    napi_create_int32(env, 0, &sum);
    return sum;
}
static napi_value grantVoices(napi_env env, napi_callback_info info) {
    size_t argc = 2;
    napi_value args[2] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    napi_valuetype valuetype1;
    napi_typeof(env, args[1], &valuetype1);

    char value0[MAX_STRING_LENGTH];
    size_t size0 = 0;
    napi_get_value_string_utf8(env, args[0], value0, MAX_STRING_LENGTH, &size0);

    char value1[MAX_STRING_LENGTH];
    size_t size1 = 0;
    napi_get_value_string_utf8(env, args[1], value1, MAX_STRING_LENGTH, &size1);

    if (room1 == nullptr) {
        room1 = new room();
    }
    room1->grantVoices(value0, value1);

    napi_value sum;
    napi_create_int32(env, 0, &sum);
    return sum;
}

static napi_value revokeVoice(napi_env env, napi_callback_info info) {
    size_t argc = 2;
    napi_value args[2] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    napi_valuetype valuetype1;
    napi_typeof(env, args[1], &valuetype1);

    char value0[MAX_STRING_LENGTH];
    size_t size0 = 0;
    napi_get_value_string_utf8(env, args[0], value0, MAX_STRING_LENGTH, &size0);

    char value1[MAX_STRING_LENGTH];
    size_t size1 = 0;
    napi_get_value_string_utf8(env, args[1], value1, MAX_STRING_LENGTH, &size1);

    if (room1 == nullptr) {
        room1 = new room();
    }
    room1->revokeVoice(value0, value1);

    napi_value sum;
    napi_create_int32(env, 0, &sum);
    return sum;
}
static napi_value revokeVoices(napi_env env, napi_callback_info info) {
    size_t argc = 2;
    napi_value args[2] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    napi_valuetype valuetype1;
    napi_typeof(env, args[1], &valuetype1);

    char value0[MAX_STRING_LENGTH];
    size_t size0 = 0;
    napi_get_value_string_utf8(env, args[0], value0, MAX_STRING_LENGTH, &size0);

    char value1[MAX_STRING_LENGTH];
    size_t size1 = 0;
    napi_get_value_string_utf8(env, args[1], value1, MAX_STRING_LENGTH, &size1);

    if (room1 == nullptr) {
        room1 = new room();
    }
    room1->revokeVoices(value0, value1);

    napi_value sum;
    napi_create_int32(env, 0, &sum);
    return sum;
}

static napi_value setAffiliation(napi_env env, napi_callback_info info) {
    size_t argc = 3;
    napi_value args[3] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    napi_valuetype valuetype1;
    napi_typeof(env, args[1], &valuetype1);

    napi_valuetype valuetype2;
    napi_typeof(env, args[2], &valuetype2);

    char value0[MAX_STRING_LENGTH];
    size_t size0 = 0;
    napi_get_value_string_utf8(env, args[0], value0, MAX_STRING_LENGTH, &size0);

    char value1[MAX_STRING_LENGTH];
    size_t size1 = 0;
    napi_get_value_string_utf8(env, args[1], value1, MAX_STRING_LENGTH, &size1);

    char value2[MAX_STRING_LENGTH];
    size_t size2 = 0;
    napi_get_value_string_utf8(env, args[2], value2, MAX_STRING_LENGTH, &size2);

    if (room1 == nullptr) {
        room1 = new room();
    }
    room1->setAffiliation(value0, value1, value2);

    napi_value sum;
    napi_create_string_utf8(env, value0, MAX_STRING_LENGTH, &sum);
    return sum;
}

static napi_value setRole(napi_env env, napi_callback_info info) {
    size_t argc = 3;
    napi_value args[3] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    napi_valuetype valuetype1;
    napi_typeof(env, args[1], &valuetype1);

    napi_valuetype valuetype2;
    napi_typeof(env, args[2], &valuetype2);

    char value0[MAX_STRING_LENGTH];
    size_t size0 = 0;
    napi_get_value_string_utf8(env, args[0], value0, MAX_STRING_LENGTH, &size0);

    char value1[MAX_STRING_LENGTH];
    size_t size1 = 0;
    napi_get_value_string_utf8(env, args[1], value1, MAX_STRING_LENGTH, &size1);

    char value2[MAX_STRING_LENGTH];
    size_t size2 = 0;
    napi_get_value_string_utf8(env, args[2], value2, MAX_STRING_LENGTH, &size2);

    if (room1 == nullptr) {
        room1 = new room();
    }
    room1->setRole(value0, value1, value2);

    napi_value sum;
    napi_create_string_utf8(env, value0, MAX_STRING_LENGTH, &sum);
    return sum;
}
static napi_value setRoles(napi_env env, napi_callback_info info) {
    size_t argc = 3;
    napi_value args[3] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    napi_valuetype valuetype1;
    napi_typeof(env, args[1], &valuetype1);

    napi_valuetype valuetype2;
    napi_typeof(env, args[2], &valuetype2);

    char value0[MAX_STRING_LENGTH];
    size_t size0 = 0;
    napi_get_value_string_utf8(env, args[0], value0, MAX_STRING_LENGTH, &size0);

    char value1[MAX_STRING_LENGTH];
    size_t size1 = 0;
    napi_get_value_string_utf8(env, args[1], value1, MAX_STRING_LENGTH, &size1);

    char value2[MAX_STRING_LENGTH];
    size_t size2 = 0;
    napi_get_value_string_utf8(env, args[2], value2, MAX_STRING_LENGTH, &size2);

    if (room1 == nullptr) {
        room1 = new room();
    }
    room1->setRoles(value0, value1, value2);

    napi_value sum;
    napi_create_string_utf8(env, value0, MAX_STRING_LENGTH, &sum);
    return sum;
}
static napi_value setPresence(napi_env env, napi_callback_info info) {
    size_t argc = 2;
    napi_value args[2] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    napi_valuetype valuetype1;
    napi_typeof(env, args[1], &valuetype1);

    char value0[MAX_STRING_LENGTH];
    size_t size0 = 0;
    napi_get_value_string_utf8(env, args[0], value0, MAX_STRING_LENGTH, &size0);

    char value1[MAX_STRING_LENGTH];
    size_t size1 = 0;
    napi_get_value_string_utf8(env, args[1], value1, MAX_STRING_LENGTH, &size1);

    if (room1 == nullptr) {
        room1 = new room();
    }
    room1->setPresence(value0, value1);

    napi_value sum;
    napi_create_string_utf8(env, value0, MAX_STRING_LENGTH, &sum);
    return sum;
}

static napi_value invite(napi_env env, napi_callback_info info) {
    size_t argc = 2;
    napi_value args[2] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    napi_valuetype valuetype1;
    napi_typeof(env, args[1], &valuetype1);

    char value0[MAX_STRING_LENGTH];
    size_t size0 = 0;
    napi_get_value_string_utf8(env, args[0], value0, MAX_STRING_LENGTH, &size0);

    char value1[MAX_STRING_LENGTH];
    size_t size1 = 0;
    napi_get_value_string_utf8(env, args[1], value1, MAX_STRING_LENGTH, &size1);

    if (room1 == nullptr) {
        room1 = new room();
    }
    JID jids(value0);
    room1->invite(jids, value1);

    napi_value sum;
    napi_create_string_utf8(env, value0, MAX_STRING_LENGTH, &sum);
    return sum;
}

static napi_value requestRoomConfig(napi_env env, napi_callback_info info) {
    napi_value sum;

    if (room1 == nullptr) {
        room1 = new room();
    }
    std::string str = room1->requestRoomConfig();
    napi_create_string_utf8(env, str.c_str(), strlen(str.c_str()), &sum);
    return sum;
}

static napi_value requestList(napi_env env, napi_callback_info info) {
    napi_value sum;
    size_t argc = 1;
    napi_value args[1] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    char value0[MAX_STRING_LENGTH];
    size_t size0 = 0;
    napi_get_value_string_utf8(env, args[0], value0, MAX_STRING_LENGTH, &size0);

    if (room1 == nullptr) {
        room1 = new room();
    }
    std::string str = room1->requestList(value0);
    napi_create_string_utf8(env, str.c_str(), strlen(str.c_str()), &sum);
    return sum;
}

static napi_value getRoomItems(napi_env env, napi_callback_info info) {
    napi_value sum;

    if (room1 == nullptr) {
        room1 = new room();
    }
    std::string str = room1->getRoomItems();
    napi_create_string_utf8(env, str.c_str(), strlen(str.c_str()), &sum);
    return sum;
}

static napi_value getRoomInfo(napi_env env, napi_callback_info info) {
    napi_value sum;

    if (room1 == nullptr) {
        room1 = new room();
    }
    std::string str = room1->getRoomInfo();
    napi_create_string_utf8(env, str.c_str(), strlen(str.c_str()), &sum);
    return sum;
}

static napi_value declineInvitation(napi_env env, napi_callback_info info) {
    size_t argc = 3;
    napi_value args[3] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    napi_valuetype valuetype1;
    napi_typeof(env, args[1], &valuetype1);

    napi_valuetype valuetype2;
    napi_typeof(env, args[2], &valuetype2);

    char value0[MAX_STRING_LENGTH];
    size_t size0 = 0;
    napi_get_value_string_utf8(env, args[0], value0, MAX_STRING_LENGTH, &size0);

    char value1[MAX_STRING_LENGTH];
    size_t size1 = 0;
    napi_get_value_string_utf8(env, args[1], value1, MAX_STRING_LENGTH, &size1);

    char value2[MAX_STRING_LENGTH];
    size_t size2 = 0;
    napi_get_value_string_utf8(env, args[2], value2, MAX_STRING_LENGTH, &size2);

    if (smack == nullptr) {
        smack = new Smack();
    }
    smack->declineInvitation(value0, value1, value2);

    napi_value sum;
    napi_create_string_utf8(env, value0, MAX_STRING_LENGTH, &sum);
    return sum;
}

static napi_value createOrJoinRoom(napi_env env, napi_callback_info info) {
    size_t argc = 4;
    napi_value args[4] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    napi_valuetype valuetype1;
    napi_typeof(env, args[1], &valuetype1);

    napi_valuetype valuetype2;
    napi_typeof(env, args[2], &valuetype2);

    napi_valuetype valuetype3;
    napi_typeof(env, args[3], &valuetype2);

    char value0[MAX_STRING_LENGTH];
    size_t size0 = 0;
    napi_get_value_string_utf8(env, args[0], value0, MAX_STRING_LENGTH, &size0);

    char value1[MAX_STRING_LENGTH];
    size_t size1 = 0;
    napi_get_value_string_utf8(env, args[1], value1, MAX_STRING_LENGTH, &size1);

    char value2[MAX_STRING_LENGTH];
    size_t size2 = 0;
    napi_get_value_string_utf8(env, args[2], value2, MAX_STRING_LENGTH, &size2);

    char value3[MAX_STRING_LENGTH];
    size_t size3 = 0;
    napi_get_value_string_utf8(env, args[3], value3, MAX_STRING_LENGTH, &size3);

    if (smack == nullptr) {
        smack = new Smack();
    }
    if (room1 == nullptr) {
        room1 = new room();
    }
    Client *client = smack->getClent();
    JID &jid = smack->getMyJID();
    room1->createOrJoinRoom(client, value0, value1, value2, jid.username(), value3);

    napi_value sum;
    napi_create_string_utf8(env, value0, MAX_STRING_LENGTH, &sum);
    return sum;
}

static napi_value setRoomConfig(napi_env env, napi_callback_info info) {
    napi_value sum;
    size_t argc = 1;
    napi_value args[1] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    char value0[MAX_STRING_LENGTH];
    size_t size0 = 0;
    napi_get_value_string_utf8(env, args[0], value0, MAX_STRING_LENGTH, &size0);

    if (room1 == nullptr) {
        room1 = new room();
    }
    room1->setRoomConfig(value0);
    napi_create_string_utf8(env, value0, MAX_STRING_LENGTH, &sum);
    return sum;
}

static napi_value setPassword(napi_env env, napi_callback_info info) {
    napi_value sum;
    size_t argc = 1;
    napi_value args[1] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    char value0[MAX_STRING_LENGTH];
    size_t size0 = 0;
    napi_get_value_string_utf8(env, args[0], value0, MAX_STRING_LENGTH, &size0);

    if (room1 == nullptr) {
        room1 = new room();
    }
    room1->setPassword(value0);
    napi_create_string_utf8(env, value0, MAX_STRING_LENGTH, &sum);
    return sum;
}

static napi_value bans(napi_env env, napi_callback_info info) {
    size_t argc = 2;
    napi_value args[2] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    napi_valuetype valuetype1;
    napi_typeof(env, args[1], &valuetype1);

    char value0[MAX_STRING_LENGTH];
    size_t size0 = 0;
    napi_get_value_string_utf8(env, args[0], value0, MAX_STRING_LENGTH, &size0);

    char value1[MAX_STRING_LENGTH];
    size_t size1 = 0;
    napi_get_value_string_utf8(env, args[1], value1, MAX_STRING_LENGTH, &size1);

    if (room1 == nullptr) {
        room1 = new room();
    }
    room1->bans(value0, value1);

    napi_value sum;
    napi_create_string_utf8(env, value0, MAX_STRING_LENGTH, &sum);
    return sum;
}

static napi_value setNick(napi_env env, napi_callback_info info) {
    napi_value sum;
    size_t argc = 1;
    napi_value args[1] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    char value0[MAX_STRING_LENGTH];
    size_t size0 = 0;
    napi_get_value_string_utf8(env, args[0], value0, MAX_STRING_LENGTH, &size0);

    if (room1 == nullptr) {
        room1 = new room();
    }
    room1->setNick(value0);
    napi_create_string_utf8(env, value0, MAX_STRING_LENGTH, &sum);
    return sum;
}

static napi_value isJoined(napi_env env, napi_callback_info info) {
    napi_value sum;

    if (room1 == nullptr) {
        room1 = new room();
    }
    std::string str = room1->isJoined();
    napi_create_string_utf8(env, str.c_str(), strlen(str.c_str()), &sum);
    return sum;
}
static napi_value nick(napi_env env, napi_callback_info info) {
    napi_value sum;

    if (room1 == nullptr) {
        room1 = new room();
    }
    std::string str = room1->nick();
    napi_create_string_utf8(env, str.c_str(), strlen(str.c_str()), &sum);
    return sum;
}

static napi_value isConnected(napi_env env, napi_callback_info info) {
    napi_value sum;

    if (smack == nullptr) {
        smack = new Smack();
    }
    int32_t num = 0;
    if (smack->isConnected()) {
        num = 1;
    }
    napi_create_int32(env, num, &sum);
    return sum;
}

static napi_value username(napi_env env, napi_callback_info info) {
    napi_value value;
    if (smack == nullptr) {
        smack = new Smack();
    }
    std::string str = smack->username();
    napi_create_string_utf8(env, str.c_str(), strlen(str.c_str()), &value);
    return value;
}

static napi_value connect(napi_env env, napi_callback_info info) {
    napi_value sum;

    if (smack == nullptr) {
        smack = new Smack();
    }
    int32_t num = 0;
    if (smack->connect()) {
        num = 1;
    }
    napi_create_int32(env, num, &sum);
    return sum;
}

static napi_value setServer(napi_env env, napi_callback_info info) {
    napi_value sum;
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);
    char value0[MAX_STRING_LENGTH];
    size_t size0 = 0;
    napi_get_value_string_utf8(env, args[0], value0, MAX_STRING_LENGTH, &size0);
    if (smack == nullptr) {
        smack = new Smack();
    }
    smack->setServer(value0);
    napi_create_string_utf8(env, value0, MAX_STRING_LENGTH, &sum);
    return sum;
}

static napi_value setUsernameAndPassword(napi_env env, napi_callback_info info) {

    size_t argc = 2;
    napi_value args[2] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    napi_valuetype valuetype1;
    napi_typeof(env, args[1], &valuetype1);

    char value0[MAX_STRING_LENGTH];
    size_t size0 = 0;
    napi_get_value_string_utf8(env, args[0], value0, MAX_STRING_LENGTH, &size0);

    char value1[MAX_STRING_LENGTH];
    size_t size1 = 0;
    napi_get_value_string_utf8(env, args[1], value1, MAX_STRING_LENGTH, &size1);
    if (smack == nullptr) {
        smack = new Smack();
    }
    smack->setUsernameAndPassword(value0, value1);
    napi_value sum;
    //    napi_create_string_utf8(env, value0, MAX_STRING_LENGTH, &sum);
    napi_create_int32(env, 0, &sum);
    return sum;
}
static napi_value setPort(napi_env env, napi_callback_info info) {
    size_t argc = 1;
    napi_value args[1] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    napi_valuetype valuetype0;

    napi_typeof(env, args[0], &valuetype0);

    int32_t value0 = 0;
    napi_get_value_int32(env, args[0], &value0);

    if (smack == nullptr) {
        smack = new Smack();
    }
    smack->setPort(value0);
    napi_value sum;
    napi_create_int32(env, value0, &sum);
    return sum;
}
static napi_value password(napi_env env, napi_callback_info info) {
    napi_value sum;

    if (smack == nullptr) {
        smack = new Smack();
    }
    std::string str = smack->password();
    napi_create_string_utf8(env, str.c_str(), strlen(str.c_str()), &sum);
    return sum;
}

static napi_value resource(napi_env env, napi_callback_info info) {
    napi_value sum;

    if (smack == nullptr) {
        smack = new Smack();
    }
    std::string str = smack->resource();
    napi_create_string_utf8(env, str.c_str(), strlen(str.c_str()), &sum);
    return sum;
}

static napi_value setResource(napi_env env, napi_callback_info info) {
    napi_value sum;
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);
    char value0[MAX_STRING_LENGTH];
    size_t size0 = 0;
    napi_get_value_string_utf8(env, args[0], value0, MAX_STRING_LENGTH, &size0);
    if (smack == nullptr) {
        smack = new Smack();
    }
    smack->setResource(value0);
    napi_create_string_utf8(env, value0, MAX_STRING_LENGTH, &sum);
    return sum;
};

static napi_value onLogin(napi_env env, napi_callback_info info) {
    napi_value sum;
    if (smack == nullptr) {
        smack = new Smack();
    }
    int32_t num = smack->login() ? 1 : 0;
    napi_create_int32(env, num, &sum);
    return sum;
}
static napi_value server(napi_env env, napi_callback_info info) {
    napi_value sum;

    if (smack == nullptr) {
        smack = new Smack();
    }
    std::string str = smack->server();
    napi_create_string_utf8(env, str.c_str(), strlen(str.c_str()), &sum);
    return sum;
}

static napi_value authed(napi_env env, napi_callback_info info) {
    napi_value sum;
    if (smack == nullptr) {
        smack = new Smack();
    }
    int32_t num = smack->authed();
    napi_create_int32(env, num, &sum);
    return sum;
}
static napi_value port(napi_env env, napi_callback_info info) {
    napi_value sum;
    if (smack == nullptr) {
        smack = new Smack();
    }
    int32_t num = smack->port();
    napi_create_int32(env, num, &sum);
    return sum;
}
static napi_value compression(napi_env env, napi_callback_info info) {
    napi_value sum;
    if (smack == nullptr) {
        smack = new Smack();
    }
    int32_t num = smack->compression();
    napi_create_int32(env, num, &sum);
    return sum;
}

static napi_value setAffiliations(napi_env env, napi_callback_info info) {
    napi_value sum;
    size_t argc = 3;
    napi_value args[3] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    napi_valuetype valuetype1;
    napi_typeof(env, args[1], &valuetype1);

    napi_valuetype valuetype2;
    napi_typeof(env, args[2], &valuetype2);

    char value0[MAX_STRING_LENGTH];
    size_t size0 = 0;
    napi_get_value_string_utf8(env, args[0], value0, MAX_STRING_LENGTH, &size0);

    char value1[MAX_STRING_LENGTH];
    size_t size1 = 0;
    napi_get_value_string_utf8(env, args[1], value1, MAX_STRING_LENGTH, &size1);

    char value2[MAX_STRING_LENGTH];
    size_t size2 = 0;
    napi_get_value_string_utf8(env, args[2], value2, MAX_STRING_LENGTH, &size2);

    if (room1 == nullptr) {
        room1 = new room();
    }
    room1->setAffiliation(value0, value1, value2);
    napi_create_string_utf8(env, value0, MAX_STRING_LENGTH, &sum);
    return sum;
}

void handleSubscriptionCall(const std::string &resultStr) {

    napi_value napi_value_resultStr;
    napi_value result;
    
    napi_create_string_utf8(register_env_HANDLE_SUBSCRIPTRION_REQUEST, resultStr.c_str(), strlen(resultStr.c_str()), &napi_value_resultStr);
    napi_value argv[] = {napi_value_resultStr};
    napi_value global, handle_subscription_request_func, arg;

    napi_status status = napi_get_global(register_env_HANDLE_SUBSCRIPTRION_REQUEST, &global);
    if (status != napi_ok) {
        LOGW("handle_subscription_request_func error, status:%d", status);
        return;
    }

    status = napi_get_named_property(register_env_HANDLE_SUBSCRIPTRION_REQUEST, global, "handle_subscription_request_func", &handle_subscription_request_func);
    if (status != napi_ok) {
        LOGW("napi_get_named_property subscription_request_func error, status:%d", status);
        return;
    }
    
    napi_call_function(register_env_HANDLE_SUBSCRIPTRION_REQUEST, global, handle_subscription_request_func, register_argc_HANDLE_SUBSCRIPTRION_REQUEST, argv, &result);
}

static napi_value handleSubscriptionRequestListener(napi_env env, napi_callback_info info) {
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &register_argc_HANDLE_SUBSCRIPTRION_REQUEST, args, nullptr, nullptr);
    register_env_HANDLE_SUBSCRIPTRION_REQUEST = env;
    return NULL;
}

static napi_value receiveFriends(napi_env env, napi_callback_info info) {
    napi_value sum;
    size_t argc = 3;
    napi_value args[3] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    napi_valuetype valuetype1;
    napi_typeof(env, args[1], &valuetype1);

    napi_valuetype valuetype2;
    napi_typeof(env, args[2], &valuetype2);

    char value0[MAX_STRING_LENGTH];
    size_t size0 = 0;
    napi_get_value_string_utf8(env, args[0], value0, MAX_STRING_LENGTH, &size0);

    char value1[MAX_STRING_LENGTH];
    size_t size1 = 0;
    napi_get_value_string_utf8(env, args[1], value1, MAX_STRING_LENGTH, &size1);

    char value2[MAX_STRING_LENGTH];
    size_t size2 = 0;
    napi_get_value_string_utf8(env, args[2], value2, MAX_STRING_LENGTH, &size2);

    if (smack == nullptr) {
        smack = new Smack();
    }
    smack->receiveFriends(value0, value1, value2);
    napi_create_string_utf8(env, value0, MAX_STRING_LENGTH, &sum);
    return sum;
}

static napi_value rejectFriends(napi_env env, napi_callback_info info) {
    napi_value sum;
    size_t argc = 2;
    napi_value args[2] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    napi_valuetype valuetype1;
    napi_typeof(env, args[1], &valuetype1);

    char value0[MAX_STRING_LENGTH];
    size_t size0 = 0;
    napi_get_value_string_utf8(env, args[0], value0, MAX_STRING_LENGTH, &size0);

    char value1[MAX_STRING_LENGTH];
    size_t size1 = 0;
    napi_get_value_string_utf8(env, args[1], value1, MAX_STRING_LENGTH, &size1);

    if (smack == nullptr) {
        smack = new Smack();
    }
    smack->rejectFriends(value0, value1);

    napi_create_string_utf8(env, value0, MAX_STRING_LENGTH, &sum);

    return sum;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports) {
    napi_property_descriptor desc[] = {
        {"login", nullptr, login, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"kick", nullptr, kick, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"ban", nullptr, ban, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"grantVoice", nullptr, grantVoice, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"grantVoices", nullptr, grantVoices, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"revokeVoice", nullptr, revokeVoice, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"revokeVoices", nullptr, revokeVoices, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"createRoom", nullptr, createRoom, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"send", nullptr, send, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"leave", nullptr, leave, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"destroy", nullptr, destroy, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"sendGroupMessage", nullptr, sendGroupMessage, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setSubject", nullptr, setSubject, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"join", nullptr, join, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"loginout", nullptr, loginout, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"addFriends", nullptr, addFriends, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"delfriend", nullptr, delfriend, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"createGroup", nullptr, createGroup, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"changePresence", nullptr, changePresence, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"registers", nullptr, registers, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"changpwd", nullptr, changpwd, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getFriendList", nullptr, getFriendList, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"unregister", nullptr, unregister, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"changeFriendGroup", nullptr, changeFriendGroup, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"changeGroup", nullptr, changeGroup, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"register_message", nullptr, register_message, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setAffiliation", nullptr, setAffiliation, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setRole", nullptr, setRole, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setRoles", nullptr, setRoles, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setPresence", nullptr, setPresence, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"invite", nullptr, invite, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"requestRoomConfig", nullptr, requestRoomConfig, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"requestList", nullptr, requestList, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getRoomItems", nullptr, getRoomItems, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"declineInvitation", nullptr, declineInvitation, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"registerInvitationListener", nullptr, registerInvitationListener, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getRoomInfo", nullptr, getRoomInfo, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"createOrJoinRoom", nullptr, createOrJoinRoom, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setPassword", nullptr, setPassword, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setRoomConfig", nullptr, setRoomConfig, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"registerMUCParticipantPresenceListener", nullptr, registerMUCParticipantPresenceListener, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"bans", nullptr, bans, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setNick", nullptr, setNick, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"isJoined", nullptr, isJoined, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"nick", nullptr, nick, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"isConnected", nullptr, isConnected, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"username", nullptr, username, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"connect", nullptr, connect, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setServer", nullptr, setServer, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setUsernameAndPassword", nullptr, setUsernameAndPassword, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setPort", nullptr, setPort, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"password", nullptr, password, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"resource", nullptr, resource, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setResource", nullptr, setResource, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"onLogin", nullptr, onLogin, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"server", nullptr, server, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"authed", nullptr, authed, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"port", nullptr, port, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"compression", nullptr, compression, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setAffiliations", nullptr, setAffiliations, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"handleSubscriptionRequestListener", nullptr, handleSubscriptionRequestListener, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"receiveFriends", nullptr, receiveFriends, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"rejectFriends", nullptr, rejectFriends, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"registerMessageGroup", nullptr, registerMessageGroup, nullptr, nullptr, nullptr, napi_default, nullptr}};

    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}
EXTERN_C_END

static napi_module
    demoModule = {
        .nm_version = 1,
        .nm_flags = 0,
        .nm_filename = nullptr,
        .nm_register_func = Init,
        .nm_modname = "libhello",
        .nm_priv = ((void *)0),
        .reserved = {
            0},
};

extern "C" __attribute__((constructor)) void RegisterModule(void) {
    napi_module_register(&demoModule);
}
