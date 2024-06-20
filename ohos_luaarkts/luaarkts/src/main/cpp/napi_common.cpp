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

#include "napi_common.h"
using namespace std;

bool g_bLog = false;

namespace Ohos_LuaArkts {
string GetFileName(string path)
{
    size_t found = path.find_last_of("/"); // 查找最后一个斜杠或反斜杠的位置
    if (found != string::npos) {
        string filename = path.substr(found + 1); // 截取最后一个斜杠后面的内容
        return filename;
    }

    return path;
}
} // namespace Ohos_LuaArkts