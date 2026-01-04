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

#ifndef OHOS_LUAARKTS_NAPI_ARKTS_H
#define OHOS_LUAARKTS_NAPI_ARKTS_H

#include <string>
#include "napi/native_api.h"

namespace Ohos_LuaArkts {
extern napi_env g_env;

napi_value TestNAPI(napi_env env, napi_callback_info info);
napi_value T2lCallFunction(napi_env env, napi_callback_info info);
napi_value T2lCallFunctionWithType(napi_env env, napi_callback_info info);

std::string TestHelloWorld(std::string msg);
void InitLuaEnv(std::string sPath);
void SetLogShowState(bool bLogShowState);
napi_status LoadModule(std::string pathModuleTs, napi_value *pResult);
void T2lSetVarInt(std::string strVarInt, int32_t intValue);
void T2lSetVarLong(std::string strVarLong, int64_t longValue);
void T2lSetVarDouble(std::string strVarDouble, double doubleValue);
void T2lSetVarChar(std::string strVarChar, const char* charValue);
void T2lSetVarBool(std::string strVarBool, bool boolValue);
int T2lGetVarInt(std::string strVarInt);
int64_t T2lGetVarLong(std::string strVarLong);
double T2lGetVarDouble(std::string strVarDouble);
const char* T2lGetVarChar(std::string strVarChar);
int T2lGetVarBool(std::string strVarBool);
void T2lSetTableInt(std::string tab, std::string field, int value);
void T2lSetTableLong(std::string tab, std::string field, int64_t value);
void T2lSetTableDouble(std::string tab, std::string field, double value);
void T2lSetTableString(std::string tab, std::string field, std::string value);
void T2lSetTableBool(std::string tab, std::string field, bool value);
int T2lGetTableInt(std::string strTableName, std::string strVarInt);
int64_t T2lGetTableLong(std::string strTableName, std::string strVarLong);
double T2lGetTableDouble(std::string strTableName, std::string strVarDouble);
const char *T2lGetTableChar(std::string strTableName, std::string strVarChar);
int T2lGetTableBool(std::string strTableName, std::string strVarBool);
} // namespace Ohos_LuaArkts

#endif // OHOS_LUAARKTS_NAPI_ARKTS_H
