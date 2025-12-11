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

#ifndef OHOS_UTILS_THREADTASK_H
#define OHOS_UTILS_THREADTASK_H
#include <string>
#include <memory>
#include <functional>
#include <atomic>
#include <thread>
#include <condition_variable>
#include <mutex>
#include <queue>
#include "napi_async_handler.h"
#include "napi_object.h"

using Task = std::function<void()>;
class ThreadTask : public NapiObject {
public:
    ThreadTask(napi_env env, const std::string &name);
    virtual ~ThreadTask();
    void OnFinish(const std::function<void()> &onFinish);
    void OnWork(const std::function<void(napi_env env, const Task &)> &onWork);
    void DoWork();
    void Start();
    void Stop();
    void Post(const Task &task);
    void Send(const Task &task);

private:
    Task GetTask();

private:
    std::atomic<bool> flag_ {false};
    std::atomic<bool> done_ {false};
    std::condition_variable doneCond_;
    std::mutex mutex_;
    std::thread thread_;
    std::function<void(napi_env env, const Task &)> onWork_ = nullptr;
    std::function<void()> onFinish_ = nullptr;
    std::string name_;

    std::queue<Task> taskQueue_;
    std::condition_variable taskCond_;
    std::mutex taskMutex_;

    std::condition_variable syncCond_;
    std::mutex syncMutex_;
    std::atomic<bool> syncFlag_ {false};
};
#endif // OHOS_UTILS_THREADTASK_H