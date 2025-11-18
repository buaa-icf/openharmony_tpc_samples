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

#include <hilog/log.h>
#include "napi_arkts.h"
#include "napi_lua.h"

using namespace std;

namespace Ohos_LuaArkts {
lua_State *g_L;
static lua_State *GetLuaStateL()
{
    return g_L;
}

static int l2tLogDebug(lua_State *L)
{
    string log = lua_tostring(L, 1);
    OH_LOG_Print(LOG_APP, LOG_INFO, 0, "ohos_luaarkts", "%{public}s", log.c_str());

    return 0;
}

static int l2tLoadModule(lua_State *L)
{
    string pathModuleTs = lua_tostring(L, 1);
    napi_value Result;
    auto status = LoadModule(pathModuleTs, &Result);
    OH_LOG_Print(LOG_APP, LOG_INFO, 0, "ohos_luaarkts", "result of l2tLoadModule=%{public}d, pathModuleTs=%{public}s",
        status, pathModuleTs.c_str());

    return 0;
}

static int l2tCallModuleFunc(lua_State *L)
{
    string pathModuleTs = lua_tostring(L, 1);
    string strFunction = lua_tostring(L, 2);

    napi_value result;
    napi_status status = LoadModule(pathModuleTs, &result);
    OH_LOG_Print(LOG_APP, LOG_INFO, 0, "ohos_luaarkts", "result of l2tCallModuleFunc=%{public}d,\
        pathModuleTs=%{public}s", status, pathModuleTs.c_str());

    // 2. 使用napi_get_named_property获取info函数
    napi_value infoFn;
    status = napi_get_named_property(g_env, result, strFunction.c_str(), &infoFn);

    int parCount = lua_gettop(L);
    napi_value *pArgs = nullptr;
    int parOne = 2; // 从2开始
    if (parCount > parOne) {
        pArgs = new napi_value[parCount - parOne];
    }
    int parInitIndex = 3;
    for (int i = parInitIndex; i < parCount + 1; i++) {
        if (lua_isnumber(L, i)) {
            int value = lua_tointeger(L, i); // 将堆栈顶部的值转换为数字

            status = napi_create_int32(g_env, value, &pArgs[i - parInitIndex]);
        } else if (lua_isstring(L, i)) {
            string value = lua_tostring(L, i); // 将堆栈顶部的值转换为数字
            status = napi_create_string_utf8(g_env, value.c_str(), value.size(), &pArgs[i - parInitIndex]);
        }
    }
    napi_value resultCall = nullptr;
    // 3. 使用napi_call_function调用info函数
    int parIndex = 2;
    status = napi_call_function(g_env, result, infoFn, parCount - parIndex, pArgs, &resultCall);

    if (resultCall == nullptr) {
        return 0;
    }
    napi_valuetype resultType;
    napi_typeof(g_env, resultCall, &resultType);
    switch (resultType) {
        case napi_undefined:
            return 0;
        case napi_null:
            return 0;
        case napi_boolean: {
            bool resultBool;
            napi_get_value_bool(g_env, resultCall, &resultBool);
            lua_pushboolean(L, resultBool);
        }
            return 1;
        case napi_number: {
            int resultInt;
            napi_get_value_int32(g_env, resultCall, &resultInt);
            lua_pushinteger(L, resultInt);
        }
            return 1;
        case napi_string: {
            char tmpChar[2048];
            size_t size = sizeof(tmpChar);
            napi_get_value_string_utf8(g_env, resultCall, tmpChar, size, &size);
            lua_pushlstring(L, tmpChar, size);
        }
            return 1;
        case napi_bigint: {
            int64_t resultInt;
            napi_get_value_int64(g_env, resultCall, &resultInt);
            lua_pushnumber(L, resultInt);
        }
            return 1;
        default:
            lua_pushinteger(L, 0);
            return 1;
    }
        return 0;
}

static int l2tCallClass(lua_State *L)
{
        string pathModuleTs = lua_tostring(L, 1);
        string strClass = lua_tostring(L, 2);
        string strFunction = lua_tostring(L, 3);
        napi_value result;
        napi_status status = LoadModule(pathModuleTs, &result);
        OH_LOG_Print(LOG_APP, LOG_INFO, 0, "ohos_luaarkts", "result of l2tCallClass=%{public}d,\
            pathModuleTs=%{public}s", status, pathModuleTs.c_str());
        napi_value infoClass;
        status = napi_get_named_property(g_env, result, strClass.c_str(), &infoClass);
        napi_value infoFn;
        status = napi_get_named_property(g_env, infoClass, strFunction.c_str(), &infoFn);
        int parCount = lua_gettop(L);
        napi_value *pArgs = nullptr;
        int parIndexOne = 2; // 参数从2开始
        if (parCount > parIndexOne) {
            pArgs = new napi_value[parCount - parIndexOne];
    }
    parIndexOne = 4; // 参数从4开始
    for (int i = parIndexOne; i < parCount + 1; i++) {
        if (lua_isnumber(L, i)) {
            int value = lua_tointeger(L, i); // 将堆栈顶部的值转换为数字
            status = napi_create_int32(g_env, value, &pArgs[i - parIndexOne]);
        } else if (lua_isstring(L, i)) {
            string value = lua_tostring(L, i); // 将堆栈顶部的值转换为数字
            napi_value ntag;
            status = napi_create_string_utf8(g_env, value.c_str(), value.size(), &pArgs[i - parIndexOne]);
        }
    }
    napi_value resultCall = nullptr;
    parIndexOne = 3; // 参数从3开始
    status = napi_call_function(g_env, result, infoFn, parCount - parIndexOne, pArgs, &resultCall);
    if (resultCall == nullptr) {
        return 0;
    }
    napi_valuetype resultType;
    napi_typeof(g_env, resultCall, &resultType);
    switch (resultType) {
        case napi_undefined:
            return 0;
        case napi_null:
            return 0;
        case napi_boolean: {
            bool resultBool;
            napi_get_value_bool(g_env, resultCall, &resultBool);
            lua_pushboolean(L, resultBool);
        }
            return 1;
        case napi_number: {
            int resultInt;
            napi_get_value_int32(g_env, resultCall, &resultInt);
            lua_pushinteger(L, resultInt);
        }
            return 1;
        case napi_string: {
            char tmpChar[2048];
            size_t size = sizeof(tmpChar);
            napi_get_value_string_utf8(g_env, resultCall, tmpChar, size, &size);
            lua_pushlstring(L, tmpChar, size);
        }
            return 1;
        case napi_bigint: {
            int64_t resultInt;
            napi_get_value_int64(g_env, resultCall, &resultInt);
            lua_pushnumber(L, resultInt);
        }
            return 1;
        default:
            lua_pushinteger(L, 0);
            return 1;
        }
        return 0;
}

static int l2tSetModuleVarInt(lua_State *L)
{
    string pathModuleTs = lua_tostring(L, 1);
    string keyStr = lua_tostring(L, 2);
    int keyValue = lua_tointeger(L, 3);
    
    napi_value result;
    auto status = LoadModule(pathModuleTs, &result);
    OH_LOG_Print(LOG_APP, LOG_INFO, 0, "ohos_luaarkts", "result of l2tSetModuleVarInt = %{public}d,\
        pathModuleTs=%{public}s", status, pathModuleTs.c_str());
    // 创建一个表示int型整数的napi_value
    napi_value jsValue;
    napi_create_int32(g_env, keyValue, &jsValue);
    // 设置属性及值
    napi_set_named_property(g_env, result, keyStr.c_str(), jsValue);

    return 1;
}

static int l2tSetModuleVarLong(lua_State *L)
{
    string pathModuleTs = lua_tostring(L, 1);
    string keyStr = lua_tostring(L, 2);
    int keyValue = lua_tointeger(L, 3);

    napi_value result;
    auto status = LoadModule(pathModuleTs, &result);
    OH_LOG_Print(LOG_APP, LOG_INFO, 0, "ohos_luaarkts", "result of l2tSetModuleVarLong = %{public}d,\
        pathModuleTs=%{public}s", status, pathModuleTs.c_str());
    // 创建一个表示long型整数的napi_value
    napi_value jsValue;
    napi_create_int64(g_env, keyValue, &jsValue);
    // 设置属性及值
    napi_set_named_property(g_env, result, keyStr.c_str(), jsValue);

    return 1;
}

static int l2tSetModuleVarChar(lua_State *L)
{
    string pathModuleTs = lua_tostring(L, 1);
    string keyStr = lua_tostring(L, 2);
    string keyValue = lua_tostring(L, 3);

    napi_value result;
    auto status = LoadModule(pathModuleTs, &result);
    OH_LOG_Print(LOG_APP, LOG_INFO, 0, "ohos_luaarkts", "result of l2tSetModuleVarChar = %{public}d,\
        pathModuleTs=%{public}s", status, pathModuleTs.c_str());
    // 创建一个表示char型整数的napi_value
    napi_value jsValue;
    status = napi_create_string_utf8(g_env, keyValue.c_str(), keyValue.size(), &jsValue);
    if (status != napi_ok) {
        return -1;
    }
    // 设置属性及值
    status = napi_set_named_property(g_env, result, keyStr.c_str(), jsValue);
    if (status != napi_ok) {
        return -1;
    }
    
    return 1;
}

static int l2tSetModuleVarDouble(lua_State *L)
{
    string pathModuleTs = lua_tostring(L, 1);
    string keyStr = lua_tostring(L, 2);
    double keyValue = lua_tonumber(L, 3);

    napi_value result;
    auto status = LoadModule(pathModuleTs, &result);
    OH_LOG_Print(LOG_APP, LOG_INFO, 0, "ohos_luaarkts", "result of l2tSetModuleVarDouble = %{public}d,\
        pathModuleTs=%{public}s", status, pathModuleTs.c_str());
    // 创建一个表示double型整数的napi_value
    napi_value jsValue;
    status = napi_create_double(g_env, keyValue, &jsValue);
    if (status != napi_ok) {
        return -1;
    }
    // 设置属性及值
    status = napi_set_named_property(g_env, result, keyStr.c_str(), jsValue);
    if (status != napi_ok) {
        return -1;
    }
    
    return 1;
}

static int l2tSetModuleVarBool(lua_State *L)
{
    string pathModuleTs = lua_tostring(L, 1);
    string keyStr = lua_tostring(L, 2);
    bool keyValue = lua_toboolean(L, 3);

    napi_value result;
    auto status = LoadModule(pathModuleTs, &result);
    OH_LOG_Print(LOG_APP, LOG_INFO, 0, "ohos_luaarkts", "result of l2tSetModuleVarBool = %{public}d,\
        pathModuleTs=%{public}s", status, pathModuleTs.c_str());
    // 创建一个表示bool型整数的napi_value
    napi_value jsValue;
    status = napi_create_int32(g_env, keyValue, &jsValue);
    if (status != napi_ok) {
        return -1;
    }
    // 设置属性及值
    status = napi_set_named_property(g_env, result, keyStr.c_str(), jsValue);
    if (status != napi_ok) {
        return -1;
    }
    
    return 1;
}

static int l2tGetModuleVarInt(lua_State *L)
{
    string pathModuleTs = lua_tostring(L, 1);
    string keyStr = lua_tostring(L, 2);
    napi_value result;
    auto status = LoadModule(pathModuleTs, &result);
    OH_LOG_Print(LOG_APP, LOG_INFO, 0, "ohos_luaarkts", "result of l2tGetModuleVarInt = %{public}d,\
        pathModuleTs=%{public}s", status, pathModuleTs.c_str());
    napi_value value;
    napi_value key;
    napi_create_string_utf8(g_env, keyStr.c_str(), keyStr.size(), &key);
    // 4. 使用napi_get_property获取变量value
    napi_get_property(g_env, result, key, &value);

    int32_t tmpVal;
    status = napi_get_value_int32(g_env, value, &tmpVal);
    if (status != napi_ok) {
        return -1;
    }

    lua_pushnumber(L, tmpVal);

    return 1;
}

static int l2tGetModuleVarLong(lua_State *L)
{
    string pathModuleTs = lua_tostring(L, 1);
    string keyStr = lua_tostring(L, 2);
    
    napi_value result;
    auto status = LoadModule(pathModuleTs, &result);
    OH_LOG_Print(LOG_APP, LOG_INFO, 0, "ohos_luaarkts", "result of l2tGetModuleVarLong = %{public}d,\
        pathModuleTs=%{public}s", status, pathModuleTs.c_str());

    napi_value value;
    napi_value key;
    napi_create_string_utf8(g_env, keyStr.c_str(), keyStr.size(), &key);
    // 4. 使用napi_get_property获取变量value
    napi_get_property(g_env, result, key, &value);
    
    int64_t tmpVal;
    status = napi_get_value_int64(g_env, value, &tmpVal);
    if (status != napi_ok) {
        return -1;
    }

    lua_pushinteger(L, tmpVal);

    return 1;
}

static int l2tGetModuleVarChar(lua_State *L)
{
    string pathModuleTs = lua_tostring(L, 1);
    string keyStr = lua_tostring(L, 2);
    
    napi_value result;
    auto status = LoadModule(pathModuleTs, &result);
    OH_LOG_Print(LOG_APP, LOG_INFO, 0, "ohos_luaarkts", "result of l2tGetModuleVarChar = %{public}d,\
        pathModuleTs=%{public}s", status, pathModuleTs.c_str());
    napi_value value;
    napi_value key;
    napi_create_string_utf8(g_env, keyStr.c_str(), keyStr.size(), &key);

    // 4. 使用napi_get_property获取变量value
    napi_get_property(g_env, result, key, &value);

    char tmpChar[1024];
    size_t size = sizeof(tmpChar);
    napi_get_value_string_utf8(g_env, value, tmpChar, size, &size);
    if (status != napi_ok) {
        return -1;
    }

    lua_pushlstring(L, tmpChar, size);
    return 1;
}

static int l2tGetModuleVarDouble(lua_State *L)
{
    string pathModuleTs = lua_tostring(L, 1);
    string keyStr = lua_tostring(L, 2);

    napi_value result;
    auto status = LoadModule(pathModuleTs, &result);
    OH_LOG_Print(LOG_APP, LOG_INFO, 0, "ohos_luaarkts", "result of l2tGetModuleVarDouble = %{public}d,\
        pathModuleTs=%{public}s", status, pathModuleTs.c_str());
    napi_value value;
    napi_value key;
    napi_create_string_utf8(g_env, keyStr.c_str(), keyStr.size(), &key);
    // 4. 使用napi_get_property获取变量value
    napi_get_property(g_env, result, key, &value);

    double tmpVal;
    status = napi_get_value_double(g_env, value, &tmpVal);
    if (status != napi_ok) {
        return -1;
    }

    lua_pushnumber(L, tmpVal);
    return 1;
}

static int l2tGetModuleVarBool(lua_State *L)
{
    string pathModuleTs = lua_tostring(L, 1);
    string keyStr = lua_tostring(L, 2);
    
    napi_value result;
    auto status = LoadModule(pathModuleTs, &result);
    OH_LOG_Print(LOG_APP, LOG_INFO, 0, "ohos_luaarkts", "result of l2tGetModuleVarBool = %{public}d,\
        pathModuleTs=%{public}s", status, pathModuleTs.c_str());
    napi_value value;
    napi_value key;
    napi_create_string_utf8(g_env, keyStr.c_str(), keyStr.size(), &key);
    // 4. 使用napi_get_property获取变量value
    napi_get_property(g_env, result, key, &value);

    bool tmpBool;
    napi_get_value_bool(g_env, value, &tmpBool);
    if (status != napi_ok) {
        return -1;
    }
    lua_pushboolean(L, tmpBool);

    return 1;
}

static int l2tTestHelloWorld(lua_State *L)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, 0, "ohos_luaarkts", "hello world");

    return 0;
}

static int l2cTestCallBack(lua_State *L)
{
    const char *pStrFunction = lua_tostring(L, 1);

    lua_getglobal(L, pStrFunction); // 获取函数，压入栈中
    int iRet = lua_pcall(L, 0, 0, 0); // 调用函数，调用完成以后，会将返回值压入栈中，2表示参数个数，1表示返回结果个数。
    if (iRet) {
        const char *pErrorMsg = lua_tostring(L, -1);
        OH_LOG_Print(LOG_APP, LOG_INFO, 0, "ohos_luaarkts", "pErrorMsg = %{public}s", pErrorMsg);
    }
    return 0;
}

static const struct luaL_Reg myLib[] = {
    {"l2tLogDebug", l2tLogDebug},                     // 调用c++日志接口,info
    {"l2tTestHelloWorld", l2tTestHelloWorld},         // 测试helloworld
    {"l2tLoadModule", l2tLoadModule},                 // 加载arkts模块
    {"l2tCallModuleFunc", l2tCallModuleFunc},         // 请求arkts模块函数
    {"l2tGetModuleVarInt", l2tGetModuleVarInt},       // 获取arkts模块变量-int类型
    {"l2tGetModuleVarLong", l2tGetModuleVarLong},     // 获取arkts模块变量-long类型
    {"l2tGetModuleVarChar", l2tGetModuleVarChar},     // 获取arkts模块变量-char类型
    {"l2tGetModuleVarDouble", l2tGetModuleVarDouble}, // 获取arkts模块变量-double类型
    {"l2tGetModuleVarBool", l2tGetModuleVarBool},     // 获取arkts模块变量-bool类型
    {"l2tCallClass", l2tCallClass},                   // 测试动态加载系统库里的模块并调用
    {"l2cTestCallBack", l2cTestCallBack},             // 测试c++直接回调

    {NULL, NULL} // 数组中最后一对必须是{NULL, NULL}，用来表示结束
};

int luaopen_mLualib(lua_State *L)
{
    luaL_newlib(L, myLib);         // 注册导出类
    lua_setglobal(L, "cc");
    return 1;                      // 把myLib表压入了栈中，所以就需要返回1
}
} // namespace Ohos_LuaArkts