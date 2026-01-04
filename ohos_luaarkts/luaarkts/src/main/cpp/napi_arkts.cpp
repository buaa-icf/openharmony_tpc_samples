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
#include "napi_lua.h"
using namespace std;

namespace Ohos_LuaArkts {
napi_env g_env;

std::string TestHelloWorld(std::string msg)
{
    return msg + " too.";
}

void SetLogShowState(bool bLogShowState)
{
}

void InitLuaEnv(std::string sPath)
{
    napi_env env = aki::JSBind::GetScopedEnv();
    g_env = env;
    
    // 1.创建Lua状态
    lua_State *L = luaL_newstate();
    if (L == NULL) {
        return;
    }
    g_L = L;

    luaopen_base(L);
    luaL_openlibs(L);

    luaopen_mLualib(L);

    // 2.加载Lua文件
    int bRet = luaL_loadfile(L, sPath.c_str());
    if (bRet) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "ohos_luaarkts", "InitLuaEnv loadfile failed: %{public}s",
                     lua_tostring(L, -1));
        return;
    }

    // 3.运行Lua文件
    bRet = lua_pcall(L, 0, 0, 0);
    if (bRet) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "ohos_luaarkts", "InitLuaEnv pcall failed: %{public}s",
                     lua_tostring(L, -1));
        return;
    }

    return;
}

napi_status LoadModule(string pathModuleTs, napi_value *pResult)
{
    // 1. 使用napi_load_module加载Test文件中的模块
    return napi_load_module(g_env, pathModuleTs.c_str(), pResult);
}


void T2lSetVarInt(string strVarInt, int32_t intValue)
{
    auto L = g_L; /* variable in Lua */
    lua_pushinteger(L, intValue);
    lua_setglobal(L, strVarInt.c_str());
}

void T2lSetVarLong(string strVarLong, int64_t longValue)
{
    auto L = g_L; /* variable in Lua */
    lua_pushinteger(L, longValue);
    lua_setglobal(L, strVarLong.c_str());
}

void T2lSetVarDouble(string strVarDouble, double doubleValue)
{
    auto L = g_L; /* variable in Lua */
    lua_pushnumber(L, doubleValue);
    lua_setglobal(L, strVarDouble.c_str());
}

void T2lSetVarChar(string strVarChar, const char *charValue)
{
    auto L = g_L; /* variable in Lua */
    lua_pushstring(L, charValue);
    lua_setglobal(L, strVarChar.c_str());
}

void T2lSetVarBool(string strVarBool, bool boolValue)
{
    auto L = g_L; /* variable in Lua */
    lua_pushboolean(L, boolValue);
    lua_setglobal(L, strVarBool.c_str());
}

int T2lGetVarInt(string strVarInt)
{
    auto L = g_L; /* variable in Lua */
    lua_getglobal(L, strVarInt.c_str());
    auto result = lua_tointeger(L, -1);

    return result;
}

int64_t T2lGetVarLong(string strVarLong)
{
    auto L = g_L; /* variable in Lua */
    lua_getglobal(L, strVarLong.c_str());
    int64_t result = lua_tonumber(L, -1);

    return result;
}

double T2lGetVarDouble(string strVarDouble)
{
    auto L = g_L; /* variable in Lua */
    lua_getglobal(L, strVarDouble.c_str());
    auto result = lua_tonumber(L, -1);

    return result;
}

const char *T2lGetVarChar(string strVarChar)
{
    auto L = g_L; /* variable in Lua */
    lua_getglobal(L, strVarChar.c_str());
    size_t temLen;
    auto result = lua_tolstring(L, -1, &temLen);

    return result;
}

int T2lGetVarBool(string strVarBool)
{
    auto L = g_L; /* variable in Lua */
    lua_getglobal(L, strVarBool.c_str());
    auto result = lua_toboolean(L, -1);

    return result;
}


void T2lSetTableInt(std::string tab, std::string field, int32_t intValue)
{
    auto L = g_L; /* variable in Lua */
    lua_getglobal(L, tab.c_str());
    if (!lua_istable(L, -1)) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "ohos_luaarkts", "T2lSetTableInt: %{public}s is not a table",
                     tab.c_str());
        return;
    }
    lua_pushinteger(L, intValue); // 入栈
    int parStackOne = -2;         // 栈从-2开始
    lua_setfield(L, parStackOne, field.c_str());
}

void T2lSetTableLong(std::string tab, std::string field, int64_t intValue)
{
    auto L = g_L; /* variable in Lua */
    lua_getglobal(L, tab.c_str());
    if (!lua_istable(L, -1)) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "ohos_luaarkts", "T2lSetTableLong: %{public}s is not a table",
                     tab.c_str());
        return;
    }
    lua_pushnumber(L, intValue); // 入栈
    int parStackOne = -2;        // 栈从-2开始
    lua_setfield(L, parStackOne, field.c_str());
}

void T2lSetTableDouble(std::string tab, std::string field, double intValue)
{
    auto L = g_L; /* variable in Lua */
    lua_getglobal(L, tab.c_str());
    if (!lua_istable(L, -1)) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "ohos_luaarkts", "T2lSetTableDouble: %{public}s is not a table",
                     tab.c_str());
        return;
    }
    lua_pushnumber(L, intValue); // 入栈
    int parStackOne = -2;        // 栈从-2开始
    lua_setfield(L, parStackOne, field.c_str());
}

void T2lSetTableString(std::string tab, std::string field, std::string intValue)
{
    auto L = g_L; /* variable in Lua */
    lua_getglobal(L, tab.c_str());
    if (!lua_istable(L, -1)) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "ohos_luaarkts", "T2lSetTableString: %{public}s is not a table",
                     tab.c_str());
        return;
    }
    lua_pushstring(L, intValue.c_str()); // 入栈
    int parStackOne = -2;                // 栈从-2开始
    lua_setfield(L, parStackOne, field.c_str());
}

void T2lSetTableBool(std::string tab, std::string field, bool intValue)
{
    auto L = g_L; /* variable in Lua */
    lua_getglobal(L, tab.c_str());
    if (!lua_istable(L, -1)) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "ohos_luaarkts", "T2lSetTableBool: %{public}s is not a table",
                     tab.c_str());
        return;
    }
    lua_pushboolean(L, intValue); // 入栈
    int parStackOne = -2;         // 栈从-2开始
    lua_setfield(L, parStackOne, field.c_str());
}


int T2lGetTableInt(string strTableName, string strVarInt)
{
    auto L = g_L; /* variable in Lua */
    lua_getglobal(L, strTableName.c_str());
    if (!lua_istable(L, -1)) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "ohos_luaarkts", "T2lGetTableInt: %{public}s is not a table",
                     strTableName.c_str());
        return 0;
    }
    lua_getfield(L, -1, strVarInt.c_str());
    auto valInt = lua_tointeger(L, -1);

    return valInt;
}

int64_t T2lGetTableLong(string strTableName, string strVarLong)
{
    auto L = g_L; /* variable in Lua */
    lua_getglobal(L, strTableName.c_str());
    if (!lua_istable(L, -1)) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "ohos_luaarkts", "T2lGetTableLong: %{public}s is not a table",
                     strTableName.c_str());
        return 0;
    }
    lua_getfield(L, -1, strVarLong.c_str());
    int64_t valLong = lua_tonumber(L, -1);

    return valLong;
}

double T2lGetTableDouble(string strTableName, string strVarDouble)
{
    auto L = g_L; /* variable in Lua */
    lua_getglobal(L, strTableName.c_str());
    if (!lua_istable(L, -1)) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "ohos_luaarkts", "T2lGetTableDouble: %{public}s is not a table",
                     strTableName.c_str());
        return 0.0;
    }
    lua_getfield(L, -1, strVarDouble.c_str());
    auto valDouble = lua_tonumber(L, -1);

    return valDouble;
}

const char *T2lGetTableChar(string strTableName, string strVarChar)
{
    auto L = g_L; /* variable in Lua */
    lua_getglobal(L, strTableName.c_str());
    if (!lua_istable(L, -1)) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "ohos_luaarkts", "T2lGetTableChar: %{public}s is not a table",
                     strTableName.c_str());
        return "";
    }
    lua_getfield(L, -1, strVarChar.c_str());
    size_t sizeLen;
    auto valChar = lua_tolstring(L, -1, &sizeLen);

    return valChar;
}

int T2lGetTableBool(string strTableName, string strVarBool)
{
    auto L = g_L; /* variable in Lua */
    lua_getglobal(L, strTableName.c_str());
    if (!lua_istable(L, -1)) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "ohos_luaarkts", "T2lGetTableBool: %{public}s is not a table",
                     strTableName.c_str());
        return 0;
    }
    lua_getfield(L, -1, strVarBool.c_str());
    auto valBool = lua_toboolean(L, -1);

    return valBool;
}

napi_value TestNAPI(napi_env env, napi_callback_info info)
{
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

// 辅助函数：获取函数名
static std::string GetFunctionName(napi_env env, napi_value argv0)
{
    char buf[512] = {0};
    size_t sizeBuff = sizeof(buf);
    size_t result = 0;
    auto status = napi_get_value_string_utf8(env, argv0, buf, sizeBuff, &result);
    if (status != napi_ok) {
        return "";
    }
    return std::string(buf);
}

// 辅助函数：处理基本类型参数
static bool PushBasicTypeParameter(lua_State* L, napi_value arg)
{
    napi_valuetype resultType;
    napi_typeof(g_env, arg, &resultType);
    
    switch (resultType) {
        case napi_boolean: {
            bool resultBool;
            napi_get_value_bool(g_env, arg, &resultBool);
            lua_pushboolean(L, resultBool);
            return true;
        }
        case napi_number: {
            int64_t resultInt;
            napi_get_value_int64(g_env, arg, &resultInt);
            lua_pushinteger(L, resultInt);
            return true;
        }
        case napi_bigint: {
            uint64_t resultInt;
            bool lossless;
            napi_get_value_bigint_uint64(g_env, arg, &resultInt, &lossless);
            if (!lossless) {
                return false;
            }
            lua_pushnumber(L, resultInt);
            return true;
        }
        case napi_undefined:
        case napi_null:
            return false;
        default:
            return false;
    }
}

// 辅助函数：处理字符串参数
static bool PushStringParameter(lua_State* L, napi_value arg)
{
    size_t size = 0;
    napi_status status = napi_get_value_string_utf8(g_env, arg, nullptr, 0, &size);
    if (status != napi_ok) {
        return false;
    }
    
    char *tmpChar = new char[size + 1];
    status = napi_get_value_string_utf8(g_env, arg, tmpChar, size + 1, &size);
    if (status != napi_ok) {
        delete[] tmpChar;
        tmpChar = nullptr;
        return false;
    }
    
    tmpChar[size] = '\0';
    lua_pushlstring(L, tmpChar, size);
    delete[] tmpChar;
    tmpChar = nullptr;
    return true;
}

// 辅助函数：处理参数（T2lCallFunction版本）
static bool PushParameters(lua_State* L, napi_value argv[], int argc)
{
    for (int i = 1; i < argc; i++) {
        auto arg = argv[i];
        napi_valuetype resultType;
        napi_typeof(g_env, arg, &resultType);
        
        switch (resultType) {
            case napi_undefined:
            case napi_null:
                return false;
            case napi_boolean:
            case napi_number:
            case napi_bigint:
                if (!PushBasicTypeParameter(L, arg)) {
                    return false;
                }
                break;
            case napi_string:
                if (!PushStringParameter(L, arg)) {
                    return false;
                }
                break;
            default:
                return false;
        }
    }
    return true;
}

// 辅助函数：处理带类型格式的参数（T2lCallFunctionWithType版本）
static bool ParseTypeFormat(const std::string& typeStr, int& curPos, std::string& format)
{
    int startPos = typeStr.find("%", curPos);
    if (startPos == std::string::npos) {
        return false;
    }
    
    int endPos = typeStr.find("%", startPos + 1);
    if (endPos == std::string::npos) {
        endPos = typeStr.size();
    }
    
    format = typeStr.substr(startPos, endPos - startPos);
    curPos = endPos;
    return true;
}

// 辅助函数：处理带类型检查的参数
static bool PushTypedParameter(lua_State* L, napi_value arg, const std::string& format)
{
    napi_valuetype resultType;
    napi_typeof(g_env, arg, &resultType);
    
    switch (resultType) {
        case napi_boolean:
            if (format == "%d") {
                bool resultBool;
                napi_get_value_bool(g_env, arg, &resultBool);
                lua_pushboolean(L, resultBool);
                return true;
            }
            break;
        case napi_number:
            if (format == "%d") {
                int64_t resultInt;
                napi_get_value_int64(g_env, arg, &resultInt);
                lua_pushinteger(L, resultInt);
                return true;
            } else if (format == "%f" || format == "%lf") {
                double resultDouble;
                napi_get_value_double(g_env, arg, &resultDouble);
                lua_pushnumber(L, resultDouble);
                return true;
            }
            break;
        case napi_string:
            if (format == "%s") {
                return PushStringParameter(L, arg);
            }
            break;
        default:
            break;
    }
    return false;
}

// 辅助函数：处理带类型格式的参数
static bool PushTypedParameters(lua_State* L, napi_value argv[], int argc, const std::string& typeStr)
{
    int curPos = 0;
    
    for (int i = 2; i < argc; i++) {
        std::string format;
        if (!ParseTypeFormat(typeStr, curPos, format)) {
            return false;
        }
        
        if (!PushTypedParameter(L, argv[i], format)) {
            return false;
        }
    }
    return true;
}

// 辅助函数：处理Lua函数调用结果
static napi_value HandleLuaCallResult(lua_State* L, int argc, int paramOffset)
{
    int iRet = lua_pcall(L, argc - paramOffset, 1, 0);
    if (iRet) {
        const char *pErrorMsg = lua_tostring(L, -1);
        OH_LOG_Print(LOG_APP, LOG_INFO, 0, "ohos_luaarkts", "pErrorMsg = %{public}s", pErrorMsg);
        return nullptr;
    }
    
    napi_value result = nullptr;
    napi_status status;
    
    int type = lua_type(L, -1);
    switch (type) {
        case LUA_TSTRING: {
            string value = lua_tostring(L, -1); // 将堆栈顶部的值转换为字符串
            status = napi_create_string_utf8(g_env, value.c_str(), value.size(), &result);
            break;
        }
        case LUA_TNUMBER: {
            int value = lua_tointeger(L, -1); // 将堆栈顶部的值转换为数字
            status = napi_create_int32(g_env, value, &result);
            break;
        }
        case LUA_TBOOLEAN: {
            bool value = lua_toboolean(L, -1);
            status = napi_get_boolean(g_env, value, &result);
            napi_valuetype napiType;
            napi_typeof(g_env, result, &napiType);
            break;
        }
        default:
            break;
    }
    
    return (status == napi_ok) ? result : nullptr;
}

// 辅助函数：处理带类型格式的Lua函数调用结果
static napi_value HandleTypedLuaCallResult(lua_State* L, int argc)
{
    int iRet = lua_pcall(L, argc - 2, 1, 0);
    if (iRet) {
        const char *pErrorMsg = lua_tostring(L, -1);
        OH_LOG_Print(LOG_APP, LOG_INFO, 0, "ohos_luaarkts", "pErrorMsg = %{public}s", pErrorMsg);
        return nullptr;
    }
    
    napi_value result = nullptr;
    napi_status status;
    
    if (lua_isinteger(L, -1)) {
        int64_t value = lua_tointeger(L, -1);
        status = napi_create_int64(g_env, value, &result);
    } else if (lua_isnumber(L, -1)) {
        double value = lua_tonumber(L, -1);
        status = napi_create_double(g_env, value, &result);
    } else if (lua_isstring(L, -1)) {
        string value = lua_tostring(L, -1);
        status = napi_create_string_utf8(g_env, value.c_str(), value.size(), &result);
    } else {
        return nullptr;
    }
    
    return (status == napi_ok) ? result : nullptr;
}

napi_value T2lCallFunction(napi_env env, napi_callback_info info)
{
    auto L = g_L;
    size_t argc = 0;
    napi_value argv[20] = {nullptr};
    napi_get_cb_info(env, info, &argc, nullptr, nullptr, nullptr);
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);

    if (argc == 0) {
        return nullptr;
    }

    std::string strFunc = GetFunctionName(env, argv[0]);
    if (strFunc.empty()) {
        return nullptr;
    }

    lua_getglobal(L, strFunc.c_str());

    if (!PushParameters(L, argv, argc)) {
        return nullptr;
    }

    return HandleLuaCallResult(L, argc, 1);
}

napi_value T2lCallFunctionWithType(napi_env env, napi_callback_info info)
{
    auto L = g_L;
    size_t argc = 0;
    napi_value argv[20] = {nullptr};
    napi_get_cb_info(env, info, &argc, nullptr, nullptr, nullptr);
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);

    if (argc == 0) {
        return nullptr;
    }

    std::string strFunc = GetFunctionName(env, argv[0]);
    if (strFunc.empty()) {
        return nullptr;
    }

    lua_getglobal(L, strFunc.c_str());

    // 获取类型格式字符串
    size_t typeSize = 0;
    napi_status status = napi_get_value_string_utf8(env, argv[1], nullptr, 0, &typeSize);
    if (status != napi_ok) {
        return nullptr;
    }
    
    char *typeBuff = new char[typeSize + 1];
    status = napi_get_value_string_utf8(env, argv[1], typeBuff, typeSize + 1, &typeSize);
    if (status != napi_ok) {
        delete[] typeBuff;
        typeBuff = nullptr;
        return nullptr;
    }
    
    typeBuff[typeSize] = '\0';
    std::string typeStr = std::string(typeBuff);
    delete[] typeBuff;
    typeBuff = nullptr;

    if (!PushTypedParameters(L, argv, argc, typeStr)) {
        return nullptr;
    }

    return HandleTypedLuaCallResult(L, argc);
}
} // namespace Ohos_LuaArkts