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
#ifndef UTILS_NAPI_SAFE_WRAPPER_H
#define UTILS_NAPI_SAFE_WRAPPER_H
#include "native_common.h"
#include "ohos_log.h"
#include <functional>
#include <napi/native_api.h>
#include <memory>
#include <atomic>
#include <mutex>

template <typename T>
class NapiSafeWrapper : public std::enable_shared_from_this<NapiSafeWrapper<T>> {
private:
    std::shared_ptr<T> nativeObject_;
    std::atomic<bool> isValid_ {true};
    std::mutex validityMutex_;
    napi_ref jsWrapperRef_ {nullptr};
    napi_env env_ {nullptr};

public:
    explicit NapiSafeWrapper(std::shared_ptr<T> object) : nativeObject_(std::move(object)) {}

    template <typename... Args>
    explicit NapiSafeWrapper(Args &&...args) : nativeObject_(std::make_shared<T>(std::forward<Args>(args)...))
    {
    }

    virtual ~NapiSafeWrapper()
    {
        ReleaseJsWrapper();
        Invalidate();
    }

    std::shared_ptr<T> operator->()
    {
        std::lock_guard<std::mutex> lock(validityMutex_);
        if (!IsValid()) {
            throw std::runtime_error("Attempted to use invalidated native object");
        }
        return nativeObject_;
    }

    const std::shared_ptr<T> operator->() const
    {
        std::lock_guard<const std::mutex> lock(validityMutex_);
        if (!IsValid()) {
            throw std::runtime_error("Attempted to use invalidated native object");
        }
        return nativeObject_;
    }

    void Invalidate()
    {
        std::lock_guard<std::mutex> lock(validityMutex_);
        isValid_.store(false, std::memory_order_release);

        // 清理 JavaScript 引用
        if (env_ && jsWrapperRef_) {
            napi_delete_reference(env_, jsWrapperRef_);
            jsWrapperRef_ = nullptr;
            env_ = nullptr;
        }
    }

    bool IsValid() const
    {
        return isValid_.load(std::memory_order_acquire);
    }

    std::shared_ptr<T> GetSafeObject()
    {
        std::lock_guard<std::mutex> lock(validityMutex_);
        return nativeObject_;
    }

    void SetSafeObject(const std::shared_ptr<T> &object)
    {
        std::lock_guard<std::mutex> lock(validityMutex_);
        nativeObject_ = object;
    }

    void SetJsWrapper(napi_env env, napi_ref wrapperRef)
    {
        std::lock_guard<std::mutex> lock(validityMutex_);
        if (!IsValid()) {
            return;
        }

        env_ = env;
        jsWrapperRef_ = wrapperRef;
    }

    void SetJsWrapper(napi_env env, napi_value wrapper)
    {
        std::lock_guard<std::mutex> lock(validityMutex_);
        if (!IsValid()) {
            return;
        }

        env_ = env;
        napi_create_reference(env_, wrapper, 1, &jsWrapperRef_);
    }

    napi_value GetJsWrapper()
    {
        std::lock_guard<std::mutex> lock(validityMutex_);
        if (!env_ || !jsWrapperRef_ || !IsValid()) {
            return nullptr;
        }

        napi_value result;
        napi_get_reference_value(env_, jsWrapperRef_, &result);
        return result;
    }

    void ReleaseJsWrapper()
    {
        std::lock_guard<std::mutex> lock(validityMutex_);
        if (!env_ || !jsWrapperRef_ || !IsValid()) {
            return;
        }

        uint32_t count;
        napi_reference_unref(env_, jsWrapperRef_, &count);
        LOGD("Release unref %d", count);
        if (count == 0) {
            napi_delete_reference(env_, jsWrapperRef_);
            jsWrapperRef_ = nullptr;
        }
    }
};
#endif