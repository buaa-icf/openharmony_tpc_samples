#include "napi_object.h"
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

NapiObject::NapiObject(const napi_env &env) : env_(env) {}

NapiObject::~NapiObject()
{
    CleanRef();
}

void NapiObject::BindRef(const napi_ref &ref)
{
    object_ref_ = ref;
}

int32_t NapiObject::AddRef()
{
    uint32_t count = 0;
    if (env_ == nullptr || object_ref_ == nullptr) {
        LOGE("add object ref nullptr");
        return 0;
    }
    NAPI_CALL_BASE(env_, napi_reference_ref(env_, object_ref_, &count), count);
    LOGD("Add ref: %d", count);
    return count;
}

int32_t NapiObject::UnRef()
{
    uint32_t count = 0;
    if (env_ == nullptr || object_ref_ == nullptr) {
        LOGE("del object ref nullptr");
        return 0;
    }
    NAPI_CALL_BASE(env_, napi_reference_unref(env_, object_ref_, &count), count);
    LOGD("Un ref: %d", count);
    return count;
}

void NapiObject::CleanRef()
{
    if (env_ == nullptr || object_ref_ == nullptr) {
        LOGE("clean object ref nullptr");
        return;
    }
    NAPI_CALL_RETURN_VOID(env_, napi_delete_reference(env_, object_ref_));
}

bool NapiObject::IsValid()
{
    uint32_t count = 0;
    if (env_ == nullptr || object_ref_ == nullptr) {
        LOGE("ref not valid");
        return false;
    }
    napi_status status = napi_reference_ref(env_, object_ref_, &count);
    if (status != napi_ok) {
        return false;
    }
    napi_reference_unref(env_, object_ref_, &count);
    return count > 0;
}

int32_t NapiObject::GetID()
{
    return static_cast<int32_t>(reinterpret_cast<uintptr_t>(this));
}
