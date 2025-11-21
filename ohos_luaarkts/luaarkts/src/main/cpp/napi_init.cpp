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

#include <aki/jsbind.h>
#include <string>
#include "napi/native_api.h"
#include "napi_arkts.h"

using namespace std;
bool g_bLog = false;
namespace Ohos_LuaArkts {
// napi注册
EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"TestNAPI", nullptr, TestNAPI, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"T2lCallFunction", nullptr, T2lCallFunction, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"T2lCallFunctionWithType", nullptr, T2lCallFunctionWithType, nullptr, nullptr, nullptr, napi_default, nullptr}
    };
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);

    exports = aki::JSBind::BindSymbols(env, exports); // aki::BindSymbols 函数传入 js 对象绑定符号
    return exports;
}
EXTERN_C_END

static napi_module demoModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "luaarkts",
    .nm_priv = ((void *)0),
    .reserved = {0},
};
extern "C" __attribute__((constructor)) void RegisterEntryModule(void) { napi_module_register(&demoModule); }
// JSBIND_ADDON(luaarkts)                  //AKI导出c++模块

// arkts注册
JSBIND_GLOBAL()
{
    JSBIND_FUNCTION(TestHelloWorld);    // 测试helloworld
    JSBIND_FUNCTION(SetLogShowState);   // 设置日志显示状态
    JSBIND_FUNCTION(InitLuaEnv);        // 初始化lua环境
    
    JSBIND_FUNCTION(T2lSetVarInt);      // 设置lua中变量,int
    JSBIND_FUNCTION(T2lSetVarLong);     // 设置lua中变量,long
    JSBIND_FUNCTION(T2lSetVarDouble);   // 设置lua中变量,double
    JSBIND_FUNCTION(T2lSetVarChar);     // 设置lua中变量,char
    JSBIND_FUNCTION(T2lSetVarBool);     // 设置lua中变量,bool
    JSBIND_FUNCTION(T2lGetVarInt);      // 获取lua中变量,int
    JSBIND_FUNCTION(T2lGetVarLong);     // 获取lua中变量,long
    JSBIND_FUNCTION(T2lGetVarDouble);   // 获取lua中变量,double
    JSBIND_FUNCTION(T2lGetVarChar);     // 获取lua中变量,char
    JSBIND_FUNCTION(T2lGetVarBool);     // 获取lua中变量,bool
    
    JSBIND_FUNCTION(T2lSetTableInt);    // 获取lua中,Table的变量-int
    JSBIND_FUNCTION(T2lSetTableLong);    // 获取lua中,Table的变量-long
    JSBIND_FUNCTION(T2lSetTableDouble);    // 获取lua中,Table的变量-double
    JSBIND_FUNCTION(T2lSetTableString);    // 获取lua中,Table的变量-char
    JSBIND_FUNCTION(T2lSetTableBool);    // 获取lua中,Table的变量-bool
    JSBIND_FUNCTION(T2lGetTableInt);    // 获取lua中,Table的变量-int
    JSBIND_FUNCTION(T2lGetTableLong);   // 获取lua中,Table的变量-long
    JSBIND_FUNCTION(T2lGetTableDouble); // 获取lua中,Table的变量-double
    JSBIND_FUNCTION(T2lGetTableChar);   // 获取lua中,Table的变量-char
    JSBIND_FUNCTION(T2lGetTableBool);   // 获取lua中,Table的变量-bool
}
} // namespace Ohos_LuaArkts