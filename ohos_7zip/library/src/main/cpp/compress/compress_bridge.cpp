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

#include "compress_bridge.h"

namespace Oh7zip {
CompressBridge::~CompressBridge() {}

void CompressBridge::AsyncExecute(napi_env env, void *data)
{
    AsyncData *async = reinterpret_cast<AsyncData *>(data);
    if (async == nullptr) {
        return;
    }
    auto obj = reinterpret_cast<CompressBridge *>(async->data);
    if (obj == nullptr) {
        async->errorCode = ErrorInfo::ASYNCDATA_NULL;
        return;
    }
    async->errorCode = obj->Compress::CompressSync(async->config);
}

void CompressBridge::AsyncComplete(napi_env env, napi_status status, void *data)
{
    AsyncData *async = reinterpret_cast<AsyncData *>(data);
    if (async == nullptr) {
        return;
    }
    NapiHelp help(env);
    napi_value result = help.CreateInt32(static_cast<int32_t>(async->errorCode));
    help.ResolveDeferred(async->deferred, result);
    help.DeleteAsyncWorker(async->asyncWork);
    delete async;
    async = nullptr;
}

std::shared_ptr<Config7z> CompressBridge::Parse(napi_env env, napi_value jsObject)
{
    NapiHelp help(env);
    auto config = std::make_shared<Config7z>();
    bool isExist = help.CheckHasproperty(jsObject, "src");
    if (isExist) {
        config->src = help.GetStringFromObject(jsObject, "src");
    }
    isExist = help.CheckHasproperty(jsObject, "dst");
    if (isExist) {
        config->dst = help.GetStringFromObject(jsObject, "dst");
    }
    isExist = help.CheckHasproperty(jsObject, "pwd");
    if (isExist) {
        config->pwd = help.GetStringFromObject(jsObject, "pwd");
    }
    isExist = help.CheckHasproperty(jsObject, "fmt");
    if (isExist) {
        config->fmt = help.GetStringFromObject(jsObject, "fmt");
    }
    return config;
}

napi_value CompressBridge::CompressSync(napi_env env, napi_callback_info info)
{
    napi_value result = nullptr;
    napi_value jsthis = nullptr;
    NapiHelp help(env);
    auto args = help.GetCallbackInfoArgs(info);
    if (args.size() != 1) {
        return nullptr;
    }
    jsthis = help.GetCallbackInfoJsObject(info);
    auto obj = reinterpret_cast<CompressBridge *>(help.Unwrap(jsthis));
    auto config = obj->Parse(env, args[0]);
    size_t ret = static_cast<size_t>(obj->Compress::CompressSync(config));
    result = help.CreateInt32(ret);
    return result;
}

napi_value CompressBridge::CompressAsync(napi_env env, napi_callback_info info)
{
    napi_value promise = nullptr;
    napi_value jsthis = nullptr;
    NapiHelp help(env);
    auto args = help.GetCallbackInfoArgs(info);
    if (args.size() != 1) {
        return nullptr;
    }
    jsthis = help.GetCallbackInfoJsObject(info);
    auto obj = reinterpret_cast<CompressBridge *>(help.Unwrap(jsthis));
    AsyncData *asyncData = new AsyncData;
    asyncData->data = obj;
    asyncData->config = obj->Parse(env, args[0]);
    help.CreatePromise(&asyncData->deferred, &promise);
    help.CreateAsyncWorker("CompressAsync", AsyncExecute, AsyncComplete, asyncData, &asyncData->asyncWork);
    help.QueueAsyncWorker(asyncData->asyncWork, napi_qos_default);
    return promise;
}

napi_value CompressBridge::Construct(napi_env env, napi_callback_info info)
{
    NapiHelp help(env);
    napi_value jsthis = help.GetCallbackInfoJsObject(info);
    auto object = new CompressBridge;
    help.Wrap(
        jsthis,
        [](napi_env env, void *finalize_data, void *finalize_hint) {
            if (finalize_data != nullptr) {
                delete reinterpret_cast<CompressBridge *>(finalize_data);
                finalize_data = nullptr;
            }
        },
        object);
    return jsthis;
}

napi_value CompressBridge::Exports(napi_env env, napi_value &exports)
{
    napi_property_descriptor descClass[] = {
        {"compressSync", nullptr, CompressSync, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"compressAsync", nullptr, CompressAsync, nullptr, nullptr, nullptr, napi_default, nullptr}};
    napi_value cons;
    NapiHelp help(env);
    help.DefineClass("Compress", Construct, descClass, sizeof(descClass) / sizeof(descClass[0]), &cons);
    help.CreateReference(cons, 1);
    help.SetProportyWithName(exports, "Compress", cons);
    return exports;
}
}