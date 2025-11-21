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

#ifndef VIDEO_CODEC_THREADHANDLER_H
#define VIDEO_CODEC_THREADHANDLER_H
#include <string>
#include <memory>
#include <functional>
#include <atomic>
#include <thread>
#include <condition_variable>
#include <mutex>

class ThreadHandler {
public:
    ThreadHandler(const std::string &name);
    virtual ~ThreadHandler();
    void OnWork(const std::function<int32_t()> &onWork);
    void OnFinish(const std::function<void()> &onFinish);
    void Start();
    void Stop();
    void Pause();
    void Resume();

private:
    std::atomic<bool> flag_ {false};
    std::atomic<bool> done_ {false};
    std::condition_variable doneCond_;
    std::mutex mutex_;
    std::condition_variable pauseCond_;
    std::atomic<bool> pause_ {false};
    std::mutex pauseMutex_;
    std::thread thread_;
    std::function<int32_t()> onWork_ = nullptr;
    std::function<void()> onFinish_ = nullptr;
    std::string name_;
};
#endif