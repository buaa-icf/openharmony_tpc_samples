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

#include <multimedia/image_framework/image_source_mdk.h>
#include <multimedia/image_framework/image_pixel_map_mdk.h>

const int32_t MAX_STR_LENGTH = 2048;

NapiHandler::NapiHandler(const napi_env &env, napi_callback_info &info, int argn) : env_(env), argc_(argn)
{
    if (argc_ == 0) {
        napi_get_cb_info(env, info, &argc_, argv_, nullptr, nullptr);
    }
    argv_ = new napi_value[argn];
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

napi_status NapiHandler::ParseArgs(int index, const std::function<napi_status(const napi_value &)> &doArgs)
{
    napi_status status;
    NAPI_ASSERT_BASE(env_, index < argc_, "Index out of range", napi_invalid_arg);
    NAPI_CALL_HANDLE(env_, status = doArgs(argv_[index]), status);
    return napi_ok;
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
void NapiHandler::ParseArg<void>(const napi_value &arg)
{
    return;
}

template <>
int NapiHandler::ParseArg<int>(const napi_value &arg)
{
    int result = -1;
    NAPI_CALL_HANDLE(env_, napi_get_value_int32(env_, arg, &result), result);
    return result;
}

template <>
int64_t NapiHandler::ParseArg<int64_t>(const napi_value &arg)
{
    int64_t result = -1;
    NAPI_CALL_HANDLE(env_, napi_get_value_int64(env_, arg, &result), result);
    return result;
}

template <>
uint64_t NapiHandler::ParseArg<uint64_t>(const napi_value &arg)
{
    uint64_t result = -1;
    bool lose = false;
    NAPI_CALL_HANDLE(env_, napi_get_value_bigint_uint64(env_, arg, &result, &lose), result);
    return result;
}

template <>
double NapiHandler::ParseArg<double>(const napi_value &arg)
{
    double result = 0;
    NAPI_CALL_HANDLE(env_, napi_get_value_double(env_, arg, &result), result);
    return result;
}

template <>
float NapiHandler::ParseArg<float>(const napi_value &arg)
{
    double result = 0;
    NAPI_CALL_HANDLE(env_, napi_get_value_double(env_, arg, &result), result);
    return result;
}

template <>
bool NapiHandler::ParseArg<bool>(const napi_value &arg)
{
    bool result = false;
    NAPI_CALL_HANDLE(env_, napi_get_value_bool(env_, arg, &result), result);
    return result;
}

template <>
ArrayBuffer NapiHandler::ParseArg<ArrayBuffer>(const napi_value &arg)
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
std::string NapiHandler::ParseArg<std::string>(const napi_value &arg)
{
    std::string result = "";
    size_t length = 0;

    NAPI_CALL_HANDLE(env_, napi_get_value_string_utf8(env_, arg, nullptr, 0, &length), result);

    if (length <= 0 || length > MAX_STR_LENGTH) {
        LOGE("%s string too long malloc failed", __func__);
        return result;
    }

    std::unique_ptr<char[]> buf = std::make_unique<char[]>(length + 1);
    if (buf.get() == nullptr) {
        LOGE("%s nullptr js object to string malloc failed", __func__);
        return result;
    }

    (void)memset(buf.get(), 0, length + 1);
    NAPI_CALL_HANDLE(env_, napi_get_value_string_utf8(env_, arg, buf.get(), length + 1, &length), result);
    result = buf.get();
    return result;
}

template <>
napi_ref NapiHandler::ParseArg<napi_ref>(const napi_value &arg)
{
    napi_ref result = nullptr;
    NAPI_CALL_HANDLE(env_, napi_create_reference(env_, arg, 1, &result), result);
    return result;
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

    std::memcpy(bufferPtr, v.data(), v.size());
    return val;
}

#if 0

    OhosImageSourceOps ops {};
    napi_value imageSource;
    napi_value pixelMap;

    // 用读取到的Raw数据创建ImageSource。
    int ret = OH_ImageSource_CreateFromData(env_, (uint8_t *)buffer.data(), buffer.size(), &ops, &imageSource);
    if (ret != 0) {
        LOGE("create image source failed, %d", ret);
        return nullptr;
    }

    // 初始化native层的ImageSource。
    ImageSourceNative *imageSourceNative_c = OH_ImageSource_InitNative(env_, imageSource);
    if (imageSourceNative_c == nullptr) {
        LOGE("image source init failed");
        return nullptr;
    }
    OhosImageDecodingOps decodingOps {};
    // 创建pixelMap。
    ret = OH_ImageSource_CreatePixelMap(imageSourceNative_c, &decodingOps, &pixelMap);
    if (ret != 0) {
        LOGE("create pixelmap failed, %d", ret);
        return nullptr;
    }
    OH_ImageSource_Release(imageSourceNative_c);
    return pixelMap;
#endif

bool NapiHandler::HasObjectProp(int index, const std::string &prop)
{
    bool result = false;
    NAPI_CALL_HANDLE(env_, napi_has_named_property(env_, argv_[index], prop.c_str(), &result), result);
    return result;
}

void NapiHandler::QueueWork(const napi_ref &funcRef, const std::vector<napi_value> &args)
{
    struct DataHandler {
        std::vector<napi_value> args;
        napi_ref funcRef;
        napi_env env;
        bool complete;
    };

    NapiAsyncHandler *processHandler = new NapiAsyncHandler(env_, "QueueWork");

    std::shared_ptr<DataHandler> dataHandler = processHandler->Bind<DataHandler>();
    dataHandler->args = args;
    dataHandler->funcRef = funcRef;
    dataHandler->env = env_;
    processHandler->OnWork([&](napi_env env, void *data) -> napi_status {
        DataHandler *q = (DataHandler *)data;
        napi_value jsFunc, result;
        napi_get_reference_value(env, q->funcRef, &jsFunc);
        return napi_call_function(env, nullptr, jsFunc, q->args.size(), q->args.data(), &result);
    });
#ifdef OHOS_USE_LIBUV
    uv_loop_s *loop = nullptr;
    napi_get_uv_event_loop(env_, &loop);
    uv_work_t *work = new uv_work_t;
    work->data = (void *)processHandler;
    uv_queue_work(
        loop, work,
        [](uv_work_t *work) {
            NapiAsyncHandler *tmpHandler = reinterpret_cast<NapiAsyncHandler *>(work->data);
            std::shared_ptr<DataHandler> d = tmpHandler->Get<DataHandler>();
            tmpHandler->DoWork(d->env);
        },
        [](uv_work_t *work, int status) {
            NapiAsyncHandler *tmpHandler = reinterpret_cast<NapiAsyncHandler *>(work->data);
            delete tmpHandler;
            delete work;
        });
#else

#endif
}

napi_value NapiHandler::BindObject(void *object, napi_finalize destructor)
{
    NAPI_CALL(env_, napi_wrap(env_, thisArg_, object, destructor, nullptr, nullptr));
    return thisArg_;
}

napi_value NapiHandler::Promise(NapiAsyncHandler *asyncHandler)
{
    if (asyncHandler == nullptr) {
        return nullptr;
    }
    napi_value promise = asyncHandler->CreatePromise();

    JsCall(asyncHandler);
    return promise;
}

napi_value NapiHandler::CreateObject()
{
    napi_value result;
    NAPI_CALL(env_, napi_create_object(env_, &result));
    return result;
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

void NapiHandler::JsCall(NapiAsyncHandler *asyncHandler)
{
    if (asyncHandler == nullptr) {
        return;
    }
    napi_async_work asyncWork;

    napi_status status = napi_create_async_work(
        env_, nullptr, asyncHandler->GetResource(),
        [](napi_env env, void *data) {
            NapiAsyncHandler *asyncHandler = reinterpret_cast<NapiAsyncHandler *>(data);
            asyncHandler->DoWork(env);
        },
        [](napi_env env, napi_status status, void *data) {
            NapiAsyncHandler *asyncHandler = reinterpret_cast<NapiAsyncHandler *>(data);
            asyncHandler->DoFinish(env);
            delete asyncHandler;
        },
        (void *)asyncHandler, &asyncWork);
    if (status != napi_ok) {
        LOGE("create async work failed, %d", status);
        return;
    }
    napi_queue_async_work(env_, asyncWork);
}

napi_value NapiHandler::GetArg(int32_t index)
{
    return argv_[index];
}
