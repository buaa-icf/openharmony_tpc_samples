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

#include <unordered_map>
#include "ohos_log.h"
#include "threadtask.h"
#include <pthread.h>

const int32_t TH_TIMEOUT_MS = 100;
const int32_t SYNC_TIMEOUT_MS = 500;

ThreadTask::ThreadTask(napi_env env, const std::string &name) : NapiObject(env), name_(name) {}

ThreadTask::~ThreadTask()
{
    Stop();
}

void ThreadTask::OnFinish(const std::function<void()> &onFinish)
{
    onFinish_ = onFinish;
}

void ThreadTask::OnWork(const std::function<void(napi_env env, const Task &)> &onWork)
{
    onWork_ = onWork;
}

void ThreadTask::Start()
{
    flag_ = true;
    done_ = false;
    thread_ = std::thread([&] {
        LOGD("Thread %s Start", name_.c_str());
        pthread_setname_np(pthread_self(), name_.c_str());
        this->DoWork();
        if (onFinish_) {
            onFinish_();
        }
        LOGD("Thread %s End", name_.c_str());
        std::unique_lock<std::mutex> doneLock(mutex_);
        done_ = true;
        doneCond_.notify_all();
    });
    // thread_.detach();
}

void ThreadTask::Stop()
{
    LOGD("Thread %s Stop to", name_.c_str());
    do {
        std::unique_lock<std::mutex> doneLock(syncMutex_);
        syncFlag_ = true;
        syncCond_.notify_all();
    } while (0);

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

Task ThreadTask::GetTask()
{
    std::unique_lock<std::mutex> lock(taskMutex_);
    taskCond_.wait_for(lock, std::chrono::milliseconds(TH_TIMEOUT_MS), [this]() {
        return !taskQueue_.empty();
    });
    if (taskQueue_.empty()) {
        return nullptr;
    }
    auto task = taskQueue_.front();
    taskQueue_.pop();
    return task;
}

void ThreadTask::DoWork()
{
    // CreateEnv();

    while (flag_ == true) {
        done_ = false;
        // napi_run_event_loop(GetEnv(), napi_event_mode_nowait);
        auto task = GetTask();
        if (task == nullptr) {
            continue;
        }

        if (onWork_) {
            onWork_(GetEnv(), task);
        }

        std::unique_lock<std::mutex> doneLock(syncMutex_);
        syncFlag_ = true;
        syncCond_.notify_all();
    }
    // napi_stop_event_loop(GetEnv());

    // DestroyEnv();
}

void ThreadTask::Post(const Task &task)
{
    std::unique_lock<std::mutex> doneLock(taskMutex_);
    taskQueue_.push(task);
    taskCond_.notify_all();
}

void ThreadTask::Send(const Task &task)
{
    syncFlag_ = false;
    do {
        std::unique_lock<std::mutex> lock(taskMutex_);
        taskQueue_.push(task);
        taskCond_.notify_all();
    } while (0);

    do {
        std::unique_lock<std::mutex> lock(syncMutex_);
        syncCond_.wait_for(lock, std::chrono::milliseconds(SYNC_TIMEOUT_MS), [this]() {
            return syncFlag_.load();
        });
    } while (0);
}