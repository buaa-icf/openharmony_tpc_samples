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

#ifndef UTILS_NAPI_ASYNC_DATA_H
#define UTILS_NAPI_ASYNC_DATA_H
#include "native_common.h"
#include "ohos_log.h"
#include <functional>
#include <memory>
#include <napi/native_api.h>
#include <cinttypes>
#include <string>
#include <mutex>
#include <variant>
#include "napi_context.h"

template <class T>
struct AsyncWorkerT {
    using Type = std::function<T(napi_env)>;
};

template <class T>
struct AsyncFinalizerT {
    using Type = std::function<napi_value(napi_env, T)>;
};

template <class T>
struct AsyncFreeT {
    using Type = std::function<void(T)>;
};

// void 类型的特化版本
template <>
struct AsyncWorkerT<void> {
    using Type = std::function<void(napi_env)>;
};

template <>
struct AsyncFinalizerT<void> {
    using Type = std::function<napi_value(napi_env)>;
};

template <>
struct AsyncFreeT<void> {
    using Type = std::function<void()>;
};

// 别名模板，方便使用
template <class T>
using AsyncWorker = typename AsyncWorkerT<T>::Type;

template <class T>
using AsyncFinalizer = typename AsyncFinalizerT<T>::Type;

template <class T>
using AsyncFree = typename AsyncFreeT<T>::Type;

template <class U, class T>
class NapiAsyncData {
public:
    using StorageType = typename std::conditional<std::is_void<T>::value, int32_t, T>::type;

    explicit NapiAsyncData(std::shared_ptr<U> object) : nativeObject_(std::move(object)) {}

    template <typename... Args>
    explicit NapiAsyncData(Args &&...args) : nativeObject_(std::make_shared<U>(std::forward<Args>(args)...))
    {
    }

    ~NapiAsyncData()
    {
        if (freeFunc_) {
            if constexpr (std::is_void<T>::value) {
                freeFunc_();
            } else {
                freeFunc_(data_);
            }
        }
    }

    std::shared_ptr<U> operator->()
    {
        return nativeObject_;
    }

    void DoWork(napi_env env)
    {
        if (workFunc_) {
            if constexpr (std::is_void<T>::value) {
                workFunc_(env);
            } else {
                data_ = workFunc_(env);
            }
        }
    }

    napi_value DoFinish(napi_env env)
    {
        napi_value result = nullptr;
        if (finishFunc_) {
            LOGD("async work finish");
            if constexpr (std::is_void<T>::value) {
                result = finishFunc_(env);
                if (result == nullptr) {
                    napi_get_undefined(env, &result);
                }
            } else {
                result = finishFunc_(env, data_);
            }
        } else {
            if constexpr (std::is_void<T>::value) {
                napi_get_undefined(env, &result);
            }
        }
        return result;
    }

    void OnWork(const AsyncWorker<T> &workFunc)
    {
        workFunc_ = workFunc;
    }

    void OnFinish(const AsyncFinalizer<T> &finishFunc)
    {
        finishFunc_ = finishFunc;
    }

    void OnFree(const AsyncFree<T> &freeFunc)
    {
        freeFunc_ = freeFunc;
    }

private:
    napi_status status_ = napi_ok;
    AsyncWorker<T> workFunc_ = nullptr;
    AsyncFinalizer<T> finishFunc_ = nullptr;
    AsyncFree<T> freeFunc_ = nullptr;
    StorageType data_;
    std::shared_ptr<U> nativeObject_ = nullptr;
};
#endif // UTILS_NAPI_ASYNC_HANDLER_H
