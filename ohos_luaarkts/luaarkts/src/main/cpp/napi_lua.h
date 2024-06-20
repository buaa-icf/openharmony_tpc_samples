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

#ifndef OHOS_LUAARKTS_NAPI_LUA_H
#define OHOS_LUAARKTS_NAPI_LUA_H
extern "C" {
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
}

extern lua_State *g_L;

namespace Ohos_LuaArkts {
int luaopen_mLualib(lua_State *L);
} // namespace Ohos_LuaArkts

#endif // OHOS_LUAARKTS_NAPI_LUA_H
