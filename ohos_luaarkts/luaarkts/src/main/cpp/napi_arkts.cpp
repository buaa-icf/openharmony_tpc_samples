/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
#include "napi_arkts.h"
#include <hilog/log.h>
#include <string>
#include <aki/jsbind.h>
#include "napi_common.h"
#include "napi_lua.h"
using namespace std;

namespace Ohos_LuaArkts {
napi_env g_env;

std::string TestHelloWorld(std::string msg) {
    if (g_bLog)
        OH_LOG_Print(LOG_APP, LOG_INFO, 0, "testTag", "func=%{public}s,line=%{public}d,file=%{public}s", __FUNCTION__,
                     __LINE__, GetFileName(__FILE__).c_str());
    return msg + " too.";
}

void SetLogShowState(bool bLogShowState) { g_bLog = bLogShowState; }

void InitLuaEnv(std::string sPath)
{
    if (g_bLog)
        OH_LOG_Print(LOG_APP, LOG_INFO, 0, "testTag", "func=%{public}s,line=%{public}d,file=%{public}s", __FUNCTION__,
                     __LINE__, GetFileName(__FILE__).c_str());
    if (g_bLog)
        OH_LOG_Print(LOG_APP, LOG_INFO, 0, "testTag",
                     "0.初始化InitLuaEnv接口"
                     ",func=%{public}s,line=%{public}d,file=%{public}s",
                     __FUNCTION__, __LINE__, GetFileName(__FILE__).c_str());
    if (g_bLog)
        OH_LOG_Print(LOG_APP, LOG_INFO, 0, "testTag",
                     "1.通过AKI接口获取env"
                     ",func=%{public}s,line=%{public}d,file=%{public}s",
                     __FUNCTION__, __LINE__, GetFileName(__FILE__).c_str());

    napi_env env = aki::JSBind::GetScopedEnv();
    g_env = env;

    if (g_bLog)
        OH_LOG_Print(LOG_APP, LOG_INFO, 0, "testTag",
                     "2.初始化lua虚拟机"
                     ",func=%{public}s,line=%{public}d,file=%{public}s",
                     __FUNCTION__, __LINE__, GetFileName(__FILE__).c_str());
    // 1.创建Lua状态
    lua_State *L = luaL_newstate();
    if (L == NULL) {
        if (g_bLog)
            OH_LOG_Print(LOG_APP, LOG_INFO, 0, "testTag",
                         "lua虚拟机初始化失败"
                         ",func=%{public}s,line=%{public}d,file=%{public}s",
                         __FUNCTION__, __LINE__, GetFileName(__FILE__).c_str());
        return;
    }
    if (g_bLog)
        OH_LOG_Print(LOG_APP, LOG_INFO, 0, "testTag",
                     "3.保存lua虚拟机"
                     ",func=%{public}s,line=%{public}d,file=%{public}s",
                     __FUNCTION__, __LINE__, GetFileName(__FILE__).c_str());
    g_L = L;

    if (g_bLog)
        OH_LOG_Print(LOG_APP, LOG_INFO, 0, "testTag",
                     "4.载入lua虚拟机基础库"
                     ",func=%{public}s,line=%{public}d,file=%{public}s",
                     __FUNCTION__, __LINE__, GetFileName(__FILE__).c_str());
    luaopen_base(L);
    luaL_openlibs(L);

    if (g_bLog)
        OH_LOG_Print(LOG_APP, LOG_INFO, 0, "testTag",
                     "5.c++向lua虚拟机注册接口"
                     ",func=%{public}s,line=%{public}d,file=%{public}s",
                     __FUNCTION__, __LINE__, GetFileName(__FILE__).c_str());
    luaopen_mLualib(L);

    DLOGINFO("testTag", "6.准备加载lua文件,获取参数lua沙箱地址=%{public}s", sPath.c_str());
    // 2.加载Lua文件
    int bRet = luaL_loadfile(L, sPath.c_str());
    if (bRet) {
        if (g_bLog)
            OH_LOG_Print(LOG_APP, LOG_INFO, 0, "testTag",
                         "读取lua文件失败"
                         ",func=%{public}s,line=%{public}d,file=%{public}s",
                         __FUNCTION__, __LINE__, GetFileName(__FILE__).c_str());
        return;
    }

    if (g_bLog)
        OH_LOG_Print(LOG_APP, LOG_INFO, 0, "testTag",
                     "7.c++开始运行lua入口文件"
                     ",func=%{public}s,line=%{public}d,file=%{public}s",
                     __FUNCTION__, __LINE__, GetFileName(__FILE__).c_str());
    // 3.运行Lua文件
    bRet = lua_pcall(L, 0, 0, 0);
    if (bRet) {
        if (g_bLog)
            OH_LOG_Print(LOG_APP, LOG_INFO, 0, "testTag",
                         "接口调用失败"
                         ",func=%{public}s,line=%{public}d,file=%{public}s",
                         __FUNCTION__, __LINE__, GetFileName(__FILE__).c_str());
        return;
    }

    return;
}

napi_status LoadModule(string pathModuleTs, napi_value *pResult) {
    if (g_bLog)
        OH_LOG_Print(LOG_APP, LOG_INFO, 0, "testTag", "func=%{public}s,line=%{public}d,file=%{public}s", __FUNCTION__,
                     __LINE__, GetFileName(__FILE__).c_str());
    // 1. 使用napi_load_module加载Test文件中的模块
    return napi_load_module(g_env, pathModuleTs.c_str(), pResult);
}


void T2lSetVarInt(string strVarInt, int32_t intValue)
{
    if (g_bLog)
        OH_LOG_Print(LOG_APP, LOG_INFO, 0, "testTag", "func=%{public}s,line=%{public}d,file=%{public}s", __FUNCTION__,
                     __LINE__, GetFileName(__FILE__).c_str());

    auto L = g_L; /* variable in Lua */
    lua_pushinteger(L, intValue);
    lua_setglobal(L, strVarInt.c_str());
}

void T2lSetVarLong(string strVarLong, int64_t longValue)
{
    if (g_bLog)
        OH_LOG_Print(LOG_APP, LOG_INFO, 0, "testTag", "func=%{public}s,line=%{public}d,file=%{public}s", __FUNCTION__,
                     __LINE__, GetFileName(__FILE__).c_str());

    auto L = g_L; /* variable in Lua */
    lua_pushinteger(L, longValue);
    lua_setglobal(L, strVarLong.c_str());
}

void T2lSetVarDouble(string strVarDouble, double doubleValue)
{
    if (g_bLog)
        OH_LOG_Print(LOG_APP, LOG_INFO, 0, "testTag", "func=%{public}s,line=%{public}d,file=%{public}s", __FUNCTION__,
                     __LINE__, GetFileName(__FILE__).c_str());

    auto L = g_L; /* variable in Lua */
    lua_pushnumber(L, doubleValue);
    lua_setglobal(L, strVarDouble.c_str());
}

void T2lSetVarChar(string strVarChar, const char *charValue)
{
    if (g_bLog)
        OH_LOG_Print(LOG_APP, LOG_INFO, 0, "testTag", "func=%{public}s,line=%{public}d,file=%{public}s", __FUNCTION__,
                     __LINE__, GetFileName(__FILE__).c_str());

    auto L = g_L; /* variable in Lua */
    lua_pushstring(L, charValue);
    lua_setglobal(L, strVarChar.c_str());
}

void T2lSetVarBool(string strVarBool, bool boolValue)
{
    if (g_bLog)
        OH_LOG_Print(LOG_APP, LOG_INFO, 0, "testTag", "func=%{public}s,line=%{public}d,file=%{public}s", __FUNCTION__,
                     __LINE__, GetFileName(__FILE__).c_str());

    auto L = g_L; /* variable in Lua */
    lua_pushboolean(L, boolValue);
    lua_setglobal(L, strVarBool.c_str());
}

int T2lGetVarInt(string strVarInt)
{
    if (g_bLog)
        OH_LOG_Print(LOG_APP, LOG_INFO, 0, "testTag", "func=%{public}s,line=%{public}d,file=%{public}s", __FUNCTION__,
                     __LINE__, GetFileName(__FILE__).c_str());

    auto L = g_L; /* variable in Lua */
    // 4.读取变量
    lua_getglobal(L, strVarInt.c_str());
    auto result = lua_tointeger(L, -1);

    return result;
}

int64_t T2lGetVarLong(string strVarLong)
{
    if (g_bLog)
        OH_LOG_Print(LOG_APP, LOG_INFO, 0, "testTag", "func=%{public}s,line=%{public}d,file=%{public}s", __FUNCTION__,
                     __LINE__, GetFileName(__FILE__).c_str());

    auto L = g_L; /* variable in Lua */
    // 4.读取变量
    lua_getglobal(L, strVarLong.c_str());
    int64_t result = lua_tonumber(L, -1);

    return result;
}

double T2lGetVarDouble( string strVarDouble) 
{
    if (g_bLog)
        OH_LOG_Print(LOG_APP, LOG_INFO, 0, "testTag", "func=%{public}s,line=%{public}d,file=%{public}s", __FUNCTION__,
                     __LINE__, GetFileName(__FILE__).c_str());

    auto L = g_L; /* variable in Lua */
    // 4.读取变量
    lua_getglobal(L, strVarDouble.c_str());
    auto result = lua_tonumber(L, -1);

    return result;
}

const char *T2lGetVarChar(string strVarChar)
{
    if (g_bLog)
        OH_LOG_Print(LOG_APP, LOG_INFO, 0, "testTag", "func=%{public}s,line=%{public}d,file=%{public}s", __FUNCTION__,
                     __LINE__, GetFileName(__FILE__).c_str());

    auto L = g_L; /* variable in Lua */
    // 4.读取变量
    lua_getglobal(L, strVarChar.c_str());
    size_t temLen;
    auto result = lua_tolstring(L, -1, &temLen);

    return result;
}

int T2lGetVarBool(string strVarBool) 
{
    if (g_bLog)
        OH_LOG_Print(LOG_APP, LOG_INFO, 0, "testTag", "func=%{public}s,line=%{public}d,file=%{public}s", __FUNCTION__,
                     __LINE__, GetFileName(__FILE__).c_str());

    auto L = g_L; /* variable in Lua */
    // 4.读取变量
    lua_getglobal(L, strVarBool.c_str());
    auto result = lua_toboolean(L, -1);

    return result;
}


void T2lSetTableInt(std::string tab, std::string field, int32_t intValue)
{
    if (g_bLog)
        OH_LOG_Print(LOG_APP, LOG_INFO, 0, "testTag", "func=%{public}s,line=%{public}d,file=%{public}s", __FUNCTION__,
                     __LINE__, GetFileName(__FILE__).c_str());

    auto L = g_L; /* variable in Lua */
    // 5.读取table
    lua_getglobal(L, tab.c_str());
    lua_pushinteger(L, intValue); // 入栈
    int parStackOne = -2;         // 栈从-2开始
    lua_setfield(L, parStackOne, field.c_str());
}

void T2lSetTableLong(std::string tab, std::string field, int64_t intValue)
{
    if (g_bLog)
        OH_LOG_Print(LOG_APP, LOG_INFO, 0, "testTag", "func=%{public}s,line=%{public}d,file=%{public}s", __FUNCTION__,
                     __LINE__, GetFileName(__FILE__).c_str());

    auto L = g_L; /* variable in Lua */
    // 5.读取table
    lua_getglobal(L, tab.c_str());
    lua_pushnumber(L, intValue); // 入栈
    int parStackOne = -2;        // 栈从-2开始
    lua_setfield(L, parStackOne, field.c_str());
}

void T2lSetTableDouble(std::string tab, std::string field, double intValue)
{
    if (g_bLog)
        OH_LOG_Print(LOG_APP, LOG_INFO, 0, "testTag", "func=%{public}s,line=%{public}d,file=%{public}s", __FUNCTION__,
                     __LINE__, GetFileName(__FILE__).c_str());

    auto L = g_L; /* variable in Lua */
    // 5.读取table
    lua_getglobal(L, tab.c_str());
    lua_pushnumber(L, intValue); // 入栈
    int parStackOne = -2;        // 栈从-2开始
    lua_setfield(L, parStackOne, field.c_str());
}

void T2lSetTableString(std::string tab, std::string field, std::string intValue)
{
    if (g_bLog)
        OH_LOG_Print(LOG_APP, LOG_INFO, 0, "testTag", "func=%{public}s,line=%{public}d,file=%{public}s", __FUNCTION__,
                     __LINE__, GetFileName(__FILE__).c_str());

    auto L = g_L; /* variable in Lua */
    // 5.读取table
    lua_getglobal(L, tab.c_str());
    lua_pushstring(L, intValue.c_str()); // 入栈
    int parStackOne = -2;                // 栈从-2开始
    lua_setfield(L, parStackOne, field.c_str());
}

void T2lSetTableBool( std::string tab, std::string field, bool intValue) 
{
    if (g_bLog)
        OH_LOG_Print(LOG_APP, LOG_INFO, 0, "testTag", "func=%{public}s,line=%{public}d,file=%{public}s", __FUNCTION__,
                     __LINE__, GetFileName(__FILE__).c_str());

    auto L = g_L; /* variable in Lua */
    // 5.读取table
    lua_getglobal(L, tab.c_str());
    lua_pushboolean(L, intValue); // 入栈
    int parStackOne = -2;         // 栈从-2开始
    lua_setfield(L, parStackOne, field.c_str());
}


int T2lGetTableInt(string strTableName, string strVarInt)
{
    if (g_bLog)
        OH_LOG_Print(LOG_APP, LOG_INFO, 0, "testTag", "func=%{public}s,line=%{public}d,file=%{public}s", __FUNCTION__,
                     __LINE__, GetFileName(__FILE__).c_str());

    auto L = g_L; /* variable in Lua */
    // 5.读取table
    lua_getglobal(L, strTableName.c_str());
    lua_getfield(L, -1, strVarInt.c_str());
    auto valInt = lua_tointeger(L, -1);

    return valInt;
}

int64_t T2lGetTableLong(string strTableName, string strVarLong)
{
    if (g_bLog)
        OH_LOG_Print(LOG_APP, LOG_INFO, 0, "testTag", "func=%{public}s,line=%{public}d,file=%{public}s", __FUNCTION__,
                     __LINE__, GetFileName(__FILE__).c_str());

    auto L = g_L; /* variable in Lua */
    // 5.读取table
    lua_getglobal(L, strTableName.c_str());
    lua_getfield(L, -1, strVarLong.c_str());
    int64_t valLong = lua_tonumber(L, -1);

    return valLong;
}

double T2lGetTableDouble(string strTableName, string strVarDouble)
{
    if (g_bLog)
        OH_LOG_Print(LOG_APP, LOG_INFO, 0, "testTag", "func=%{public}s,line=%{public}d,file=%{public}s", __FUNCTION__,
                     __LINE__, GetFileName(__FILE__).c_str());

    auto L = g_L; /* variable in Lua */
    // 5.读取table
    lua_getglobal(L, strTableName.c_str());
    lua_getfield(L, -1, strVarDouble.c_str());
    auto valDouble = lua_tonumber(L, -1);

    return valDouble;
}

const char *T2lGetTableChar(string strTableName, string strVarChar)
{
    if (g_bLog)
        OH_LOG_Print(LOG_APP, LOG_INFO, 0, "testTag", "func=%{public}s,line=%{public}d,file=%{public}s", __FUNCTION__,
                     __LINE__, GetFileName(__FILE__).c_str());

    auto L = g_L; /* variable in Lua */
    // 5.读取table
    lua_getglobal(L, strTableName.c_str());
    lua_getfield(L, -1, strVarChar.c_str());
    size_t sizeLen;
    auto valChar = lua_tolstring(L, -1, &sizeLen);

    return valChar;
}

int T2lGetTableBool(string strTableName, string strVarBool)
{
    if (g_bLog)
        OH_LOG_Print(LOG_APP, LOG_INFO, 0, "testTag", "func=%{public}s,line=%{public}d,file=%{public}s", __FUNCTION__,
                     __LINE__, GetFileName(__FILE__).c_str());

    auto L = g_L; /* variable in Lua */
    // 5.读取table
    lua_getglobal(L, strTableName.c_str());
    lua_getfield(L, -1, strVarBool.c_str());
    size_t sizeLen;
    auto valBool = lua_toboolean(L, -1);

    return valBool;
}

napi_value TestNAPI(napi_env env, napi_callback_info info) {
    if (g_bLog)
        OH_LOG_Print(LOG_APP, LOG_INFO, 0, "testTag", "func=%{public}s,line=%{public}d,file=%{public}s", __FUNCTION__,
                     __LINE__, GetFileName(__FILE__).c_str());

    size_t requireArgc = 2;
    size_t argc = 2;
    napi_value args[2] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    napi_valuetype valuetype1;
    napi_typeof(env, args[1], &valuetype1);

    double value0;
    napi_get_value_double(env, args[0], &value0);

    double value1;
    napi_get_value_double(env, args[1], &value1);

    napi_value sum;
    napi_create_double(env, value0 + value1, &sum);

    return sum;
}

napi_value T2lCallFunction(napi_env env, napi_callback_info info)
{
    if (g_bLog)
        OH_LOG_Print(LOG_APP, LOG_INFO, 0, "testTag", "func=%{public}s,line=%{public}d,file=%{public}s", __FUNCTION__,
                     __LINE__, GetFileName(__FILE__).c_str());

    auto L = g_L; /* variable in Lua */
    size_t argc = 0;
    napi_value argv[20] = {nullptr};
    napi_get_cb_info(env, info, &argc, nullptr, nullptr, nullptr);
    DLOGINFO("testTag", "t2lCallFunction2参数个数=%{public}d", (int)argc);
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);

    string strFunc = "";
    if (argc == 0) {
        DLOGINFO("testTag", "参数个数不能为0,第一个参数必须是函数名=%{public}d", (int)argc);
        return nullptr;
    }

    char buf[512] = {0};
    size_t sizeBuff = sizeof(buf);
    size_t result = 0;
    auto status = napi_get_value_string_utf8(env, argv[0], buf, sizeBuff, &result);
    DLOGINFO("testTag", "获取函数名结果status=%{public}d", status);
    strFunc = std::string(buf);
    if (strFunc == "") {
        if (g_bLog)
            OH_LOG_Print(LOG_APP, LOG_INFO, 0, "testTag",
                         "t2lCallFunction失败,函数名为空"
                         ",func=%{public}s,line=%{public}d,file=%{public}s",
                         __FUNCTION__, __LINE__, GetFileName(__FILE__).c_str());
        return nullptr;
    }
    DLOGINFO("testTag", "准备调用的接口名=%{public}s", strFunc.c_str());
    lua_getglobal(L, strFunc.c_str()); // 获取函数，压入栈中

    // 开始压入参数
    for (int i = 1; i < argc; i++) {
        auto it = argv[i];
        napi_valuetype resultType;
        napi_typeof(g_env, it, &resultType);
        switch (resultType) {
            case napi_undefined:
                return 0;
            case napi_null:
                return 0;
            case napi_boolean: {
                bool resultBool;
                napi_get_value_bool(g_env, it, &resultBool);
                lua_pushboolean(L, resultBool);
                if (g_bLog)
                    OH_LOG_Print(LOG_APP, LOG_INFO, 0, "testTag",
                                 "压入bool"
                                 ",func=%{public}s,line=%{public}d,file=%{public}s",
                                 __FUNCTION__, __LINE__, GetFileName(__FILE__).c_str());
            } break;
            case napi_number: {
                int resultInt;
                napi_get_value_int32(g_env, it, &resultInt);
                lua_pushinteger(L, resultInt);
                if (g_bLog)
                    OH_LOG_Print(LOG_APP, LOG_INFO, 0, "testTag",
                                 "压入int"
                                 ",func=%{public}s,line=%{public}d,file=%{public}s",
                                 __FUNCTION__, __LINE__, GetFileName(__FILE__).c_str());
            } break;
            case napi_string: {
                char tmpChar[2048];
                size_t size = sizeof(tmpChar);
                napi_get_value_string_utf8(g_env, it, tmpChar, size, &size);
                if (g_bLog)
                    OH_LOG_Print(LOG_APP, LOG_INFO, 0, "testTag",
                                 "压入string"
                                 ",func=%{public}s,line=%{public}d,file=%{public}s",
                                 __FUNCTION__, __LINE__, GetFileName(__FILE__).c_str());
            } break;
            case napi_bigint: {
                int64_t resultInt;
                napi_get_value_int64(g_env, it, &resultInt);
                lua_pushnumber(L, resultInt);
                if (g_bLog)
                    OH_LOG_Print(LOG_APP, LOG_INFO, 0, "testTag",
                                 "压入int64"
                                 ",func=%{public}s,line=%{public}d,file=%{public}s",
                                 __FUNCTION__, __LINE__, GetFileName(__FILE__).c_str());
            } break;
            default: {
                DLOGINFO("testTag", "不支持的类型=%{public}d", resultType);
            } break;
            }
    }

    int iRet =
        lua_pcall(L, argc - 1, 1, 0); // 调用函数，调用完成以后，会将返回值压入栈中，2表示参数个数，1表示返回结果个数。
    if (iRet) {
        if (g_bLog)
            OH_LOG_Print(LOG_APP, LOG_INFO, 0, "testTag",
                         "调用lua失败"
                         ",func=%{public}s,line=%{public}d,file=%{public}s",
                         __FUNCTION__, __LINE__, GetFileName(__FILE__).c_str());
        const char *pErrorMsg = lua_tostring(L, -1);
        DLOGINFO("testTag", "str=%{public}s", pErrorMsg);
    } else {
        napi_value result = nullptr;
        if (g_bLog)
            OH_LOG_Print(LOG_APP, LOG_INFO, 0, "testTag",
                         "调用lua成功"
                         ",func=%{public}s,line=%{public}d,file=%{public}s",
                         __FUNCTION__, __LINE__, GetFileName(__FILE__).c_str());
        if (lua_isnumber(L, -1)) {
            int value = lua_tointeger(L, -1); // 将堆栈顶部的值转换为数字

            status = napi_create_int32(g_env, value, &result);
            DLOGINFO("testTag", "状态,结果=%{public}d", status);
        } else if (lua_isstring(L, -1)) {
            string value = lua_tostring(L, -1); // 将堆栈顶部的值转换为数字

            napi_value ntag;
            status = napi_create_string_utf8(g_env, value.c_str(), value.size(), &result);
            DLOGINFO("testTag", "状态,结果=%{public}d", status);
        } else {
            if (g_bLog)
                OH_LOG_Print(LOG_APP, LOG_INFO, 0, "testTag",
                             "无参数或不不支持参数,直接返回"
                             ",func=%{public}s,line=%{public}d,file=%{public}s",
                             __FUNCTION__, __LINE__, GetFileName(__FILE__).c_str());
            return nullptr;
        }
        return result;
    }

    return nullptr;
}
} // namespace Ohos_LuaArkts