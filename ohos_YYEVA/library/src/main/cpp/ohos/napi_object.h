/*
 * Copyright (C) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
#ifndef UTILS_NAPI_OBJECT_H
#define UTILS_NAPI_OBJECT_H
#include "native_common.h"
#include "ohos_log.h"
#include <functional>
#include <napi/native_api.h>

class NapiObject {
public:
    explicit NapiObject(const napi_env &env);
    NapiObject();
    virtual ~NapiObject();
    napi_env CreateEnv();
    void DestroyEnv();
    void BindRef(const napi_value &value);
    int32_t AddRef();
    int32_t UnRef();
    void CleanRef();
    bool IsValid();
    int32_t GetID();
    napi_env GetEnv();

private:
    bool created_ = false;
    napi_env env_ = nullptr;
    napi_ref object_ref_ = nullptr;
};
#endif