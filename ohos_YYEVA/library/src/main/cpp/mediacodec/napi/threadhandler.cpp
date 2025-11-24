/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

#include "threadhandler.h"
#include <unordered_map>
#include <ohos/ohos_log.h>

const int32_t TH_TIMEOUT = 500;

ThreadHandler::ThreadHandler(const std::string &name) : name_(name) {}

ThreadHandler::~ThreadHandler()
{
    Stop();
}

void ThreadHandler::OnWork(const std::function<int32_t()> &onWork)
{
    onWork_ = onWork;
}

void ThreadHandler::OnFinish(const std::function<void()> &onFinish)
{
    onFinish_ = onFinish;
}

void ThreadHandler::Start()
{
    flag_ = true;
    done_ = false;
    LOGD("Thread %s Start", name_.c_str());
    thread_ = std::thread([&] {
        this->DoWork();
        if (onFinish_) {
            onFinish_();
        }
        LOGD("Thread %s End", name_.c_str());
        std::unique_lock<std::mutex> doneLock(mutex_);
        done_ = true;
        doneCond_.notify_all();
    });
    thread_.detach();
}

void ThreadHandler::Stop()
{
    Resume();
    flag_ = false;
    if (thread_.joinable()) {
        thread_.join();
    }

    do {
        std::unique_lock<std::mutex> lock(mutex_);
        doneCond_.wait(lock, [this]() {
            return done_.load();
        });
    } while (0);
    LOGD("Thread %s Stop", name_.c_str());
}

void ThreadHandler::Pause()
{
    pause_ = true;
}

void ThreadHandler::Resume()
{
    std::unique_lock<std::mutex> lock(pauseMutex_);
    pause_ = false;
    pauseCond_.notify_all();
}

void ThreadHandler::DoWork()
{
    while (flag_ == true) {
        done_ = false;
        if (pause_) {
            std::unique_lock<std::mutex> lock(pauseMutex_);
            pauseCond_.wait_for(lock, std::chrono::milliseconds(TH_TIMEOUT), [this]() {
                return !pause_.load();
            });
            if (pause_) {
                continue;
            }
        }
        if (onWork_) {
            int32_t state = onWork_();
            if (state < 0) {
                break;
            }
        }
    }
}
