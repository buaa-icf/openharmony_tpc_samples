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

#include "napi_handler.h"
#include "ohos_log.h"
#include <codecvt>
#include <condition_variable>
#include <cstdio>
#include <locale>
#include <memory>
#include <mutex>
#include <string>
#include <thread>
#include <uv.h>

const int32_t MAX_STR_LENGTH = 2048;
using SafeThreadHandler = std::shared_ptr<NapiThreadsafeHandler>;

NapiHandler::NapiHandler(const napi_env &env, napi_callback_info &info, int argn) : env_(env), argc_(argn)
{
    if (argc_ == 0) {
        napi_get_cb_info(env, info, &argc_, argv_, nullptr, nullptr);
    }
    if (argc_ > 0) {
        argv_ = new napi_value[argc_];
    }
    NAPI_CALL_RETURN_VOID(env_, napi_get_cb_info(env, info, &argc_, argv_, &thisArg_, &data_));
    NAPI_ASSERT_RETURN_VOID(env_, argc_ >= argn, "Wrong number of arguments");
}

NapiHandler::NapiHandler(const napi_env &env) : env_(env) {}

NapiHandler::~NapiHandler()
{
    if (argv_) {
        delete[] argv_;
    }
}

napi_env NapiHandler::GetEnv() const
{
    return env_;
}

bool NapiHandler::HasArgIndex(int index)
{
    return index < argc_;
}

napi_value NapiHandler::GetVoidValue()
{
    napi_value val;
    NAPI_CALL(env_, napi_get_undefined(env_, &val));
    return val;
}

void NapiHandler::DelRefValue(napi_ref ref)
{
    napi_delete_reference(env_, ref);
}

napi_value NapiHandler::CreateArray(int len, const std::function<napi_value(int)> &doArray)
{
    napi_value result = nullptr;
    NAPI_CALL(env_, napi_create_array_with_length(env_, len, &result));
    for (int i = 0; i < len; ++i) {
        napi_value obj = doArray(i);
        NAPI_CALL(env_, napi_set_element(env_, result, i, obj));
    }
    return result;
}

template <>
void NapiHandler::ParseArg<void>(const napi_value &arg) const
{
    return;
}

template <>
int32_t NapiHandler::ParseArg<int32_t>(const napi_value &arg) const
{
    int32_t result = -1;
    NAPI_CALL_HANDLE(env_, napi_get_value_int32(env_, arg, &result), result);
    return result;
}

template <>
uint32_t NapiHandler::ParseArg<uint32_t>(const napi_value &arg) const
{
    uint32_t result = -1;
    NAPI_CALL_HANDLE(env_, napi_get_value_uint32(env_, arg, &result), result);
    return result;
}

template <>
int64_t NapiHandler::ParseArg<int64_t>(const napi_value &arg) const
{
    int64_t result = -1;
    NAPI_CALL_HANDLE(env_, napi_get_value_int64(env_, arg, &result), result);
    return result;
}

template <>
uint64_t NapiHandler::ParseArg<uint64_t>(const napi_value &arg) const
{
    uint64_t result = -1;
    bool lose = false;
    NAPI_CALL_HANDLE(env_, napi_get_value_bigint_uint64(env_, arg, &result, &lose), result);
    return result;
}

template <>
double NapiHandler::ParseArg<double>(const napi_value &arg) const
{
    double result = 0;
    NAPI_CALL_HANDLE(env_, napi_get_value_double(env_, arg, &result), result);
    return result;
}

template <>
float NapiHandler::ParseArg<float>(const napi_value &arg) const
{
    double result = 0;
    NAPI_CALL_HANDLE(env_, napi_get_value_double(env_, arg, &result), result);
    return result;
}

template <>
bool NapiHandler::ParseArg<bool>(const napi_value &arg) const
{
    bool result = false;
    NAPI_CALL_HANDLE(env_, napi_get_value_bool(env_, arg, &result), result);
    return result;
}

template <>
ArrayBuffer NapiHandler::ParseArg<ArrayBuffer>(const napi_value &arg) const
{
    bool is_arraybuffer;
    NAPI_CALL_HANDLE(env_, napi_is_arraybuffer(env_, arg, &is_arraybuffer), {});
    if (!is_arraybuffer) {
        LOGE("Argument must be an ArrayBuffer");
        return {};
    }
    void *data = nullptr;
    size_t byte_length = 0;
    NAPI_CALL_HANDLE(env_, napi_get_arraybuffer_info(env_, arg, &data, &byte_length), {});
    if (byte_length <= 0) {
        return {};
    }
    ArrayBuffer arrayBuffer((uint8_t *)data, (uint8_t *)data + byte_length);
    return arrayBuffer;
}

template <>
std::string NapiHandler::ParseArg<std::string>(const napi_value &arg) const
{
    std::string result = "";
    size_t length = 0;

    NAPI_CALL_HANDLE(env_, napi_get_value_string_utf8(env_, arg, nullptr, 0, &length), result);
    if (length == 0) {
        return result;
    }
    if (length < 0) {
        LOGE("%s string too long to malloc failed, %d", __func__, length);
        return result;
    }

    std::unique_ptr<char[]> buf = std::make_unique<char[]>(length + 1);
    if (buf.get() == nullptr) {
        LOGE("%s nullptr js object to string malloc failed", __func__);
        return result;
    }
    std::fill(buf.get(), buf.get() + (length + 1), 0);
    NAPI_CALL_HANDLE(env_, napi_get_value_string_utf8(env_, arg, buf.get(), length + 1, &length), result);
    result = buf.get();
    return result;
}

template <>
napi_ref NapiHandler::ParseArg<napi_ref>(const napi_value &arg) const
{
    napi_ref result = nullptr;
    NAPI_CALL_HANDLE(env_, napi_create_reference(env_, arg, 1, &result), result);
    return result;
}

template <>
SafeThreadHandler NapiHandler::ParseArg<SafeThreadHandler>(const napi_value &arg) const
{
    SafeThreadHandler asyncHandler = std::make_shared<NapiThreadsafeHandler>(env_);
    asyncHandler->BindMethodRef(arg);
    return asyncHandler;
}

template <>
napi_value NapiHandler::GetNapiValue<bool>(const bool &v)
{
    napi_value val;
    NAPI_CALL(env_, napi_get_boolean(env_, v, &val));
    return val;
}

template <>
napi_value NapiHandler::GetNapiValue<int32_t>(const int32_t &v)
{
    napi_value val;
    NAPI_CALL(env_, napi_create_int32(env_, v, &val));
    return val;
}

template <>
napi_value NapiHandler::GetNapiValue<int64_t>(const int64_t &v)
{
    napi_value val;
    NAPI_CALL(env_, napi_create_int64(env_, v, &val));
    return val;
}

template <>
napi_value NapiHandler::GetNapiValue<uint64_t>(const uint64_t &v)
{
    napi_value val;
    NAPI_CALL(env_, napi_create_int64(env_, static_cast<int64_t>(v), &val));
    return val;
}

template <>
napi_value NapiHandler::GetNapiValue<float>(const float &v)
{
    napi_value val;
    NAPI_CALL(env_, napi_create_double(env_, v, &val));
    return val;
}

template <>
napi_value NapiHandler::GetNapiValue<double>(const double &v)
{
    napi_value val;
    NAPI_CALL(env_, napi_create_double(env_, v, &val));
    return val;
}

template <>
napi_value NapiHandler::GetNapiValue<std::string>(const std::string &v)
{
    napi_value val;
    NAPI_CALL(env_, napi_create_string_utf8(env_, v.c_str(), v.length(), &val));
    return val;
}

template <>
napi_value NapiHandler::GetNapiValue<napi_ref>(const napi_ref &v)
{
    napi_value val;
    NAPI_CALL(env_, napi_get_reference_value(env_, v, &val));
    return val;
}

template <>
napi_value NapiHandler::GetNapiValue<ArrayBuffer>(const ArrayBuffer &v)
{
    napi_value val;
    if (v.empty()) {
        LOGD("buffer is empty");
        return nullptr;
    }
    void *bufferPtr = nullptr;
    NAPI_CALL(env_, napi_create_arraybuffer(env_, v.size(), &bufferPtr, &val));

    if (bufferPtr == nullptr) {
        LOGE("ArrayBuffer data pointer is null");
        return nullptr;
    }
    std::copy(v.begin(), v.end(), static_cast<uint8_t *>(bufferPtr));
    return val;
}

bool NapiHandler::HasObjectProp(int index, const std::string &prop)
{
    bool result = false;
    NAPI_CALL_HANDLE(env_, napi_has_named_property(env_, argv_[index], prop.c_str(), &result), result);
    return result;
}

napi_value NapiHandler::BindObject(void *object, napi_finalize destructor)
{
    NAPI_CALL(env_, napi_wrap(env_, thisArg_, object, destructor, nullptr, nullptr));
    return thisArg_;
}

void *NapiHandler::UnbindObject()
{
    void *t = nullptr;
    NAPI_CALL_HANDLE(env_, napi_unwrap(env_, thisArg_, reinterpret_cast<void **>(&t)), t);
    return t;
}

napi_value NapiHandler::CreateObject()
{
    napi_value result;
    NAPI_CALL(env_, napi_create_object(env_, &result));
    return result;
}

napi_value NapiHandler::GetArg(int32_t index)
{
    return argv_[index];
}

napi_value NapiHandler::GetThis()
{
    return thisArg_;
}

napi_valuetype NapiHandler::GetArgType(int index)
{
    napi_valuetype type;
    napi_typeof(env_, argv_[index], &type);
    return type;
}

template <>
void NapiHandler::DefaultValue()
{
    return;
}
template <>
int32_t NapiHandler::DefaultValue()
{
    return 0;
}
template <>
double NapiHandler::DefaultValue()
{
    return 0;
}
template <>
napi_ref NapiHandler::DefaultValue()
{
    return nullptr;
}
template <>
std::string NapiHandler::DefaultValue()
{
    return "";
}

SafeThreadHandler NapiHandler::ParseSafeMethod(int index, const std::string &method)
{
    SafeThreadHandler asyncHandler = ParseArgAs<SafeThreadHandler>(index);
    asyncHandler->CreateSafeThread(method);
    return asyncHandler;
}
