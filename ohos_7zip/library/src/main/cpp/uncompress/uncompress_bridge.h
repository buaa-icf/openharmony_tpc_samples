/*
 * Copyright (C) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef __7Z_UNCOMPRESS_BRIDGE_H__
#define __7Z_UNCOMPRESS_BRIDGE_H__

#include "napi_help/napi_help.h"
#include "uncompress.h"

namespace Oh7zip {
class UncompressBridge : public Uncompress {
public:
    struct AsyncData {
        napi_deferred deferred;
        napi_async_work asyncWork;
        void *data;
        std::shared_ptr<Config7z> config{nullptr};
        ErrorInfo errorCode{ErrorInfo::OK};
    };
    static napi_value ExtractSync(napi_env env, napi_callback_info info);
    static napi_value ExtractAsync(napi_env env, napi_callback_info info);
    static napi_value Construct(napi_env env, napi_callback_info info);
    static napi_value Exports(napi_env env, napi_value &exports);
    UncompressBridge() = default;
    ~UncompressBridge();

private:
    static void AsyncExecute(napi_env env, void *data);
    static void AsyncComplete(napi_env env, napi_status status, void *data);
    std::shared_ptr<Config7z> Parse(napi_env env, napi_value value);
};
} // namespace Oh7zip

#endif