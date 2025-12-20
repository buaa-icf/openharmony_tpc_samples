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

#ifndef OHOS_RIVE_WORKER_THREAD_H
#define OHOS_RIVE_WORKER_THREAD_H

#include "general.h"
#include "thread.h"
#include "thread_state_egl.h"
#include <cassert>
#include <condition_variable>
#include <mutex>
#include <queue>
#include <stack>
#include <thread>

namespace ohos_rive {
class WorkerThread {
public:
    using Work = std::function<void(DrawableThreadState *)>;
    using WorkID = uint64_t;
    constexpr static WorkID kWorkIDAlwaysFinished = 0;

    // A worker object that starts a background thread to perform its tasks.
    WorkerThread(const char *name, Affinity affinity, const RendererType rendererType)
        : m_rendererType(rendererType), mName(name), mAffinity(affinity), mWorkMutex{}
    {
        // Don't launch the worker thread until all of our objects are fully
        // initialized.
        mThread = std::thread([this]() { ThreadMain(); });
    }

    virtual ~WorkerThread()
    {
        TerminateThread();
    }

    const std::thread::id ThreadID() const
    {
        return mThread.get_id();
    }

    // Only accessible on the worker thread.
    DrawableThreadState *GetThreadState() const
    {
        if (std::this_thread::get_id() != ThreadID()) {
            LOGE("GetThreadState() called from incorrect thread get id not same.");
            return nullptr;
        }
        if (m_threadState == nullptr) {
            LOGE("GetThreadState() called with null thread state");
            return nullptr;
        }
        return m_threadState.get();
    }

    WorkID Run(Work &&work)
    {
        if (work == nullptr) {
            LOGE("Run() called with null work function");
            return kWorkIDAlwaysFinished;
        }

        uint64_t pushedWorkID;
        {
            std::lock_guard workLock(mWorkMutex);
            if (mIsTerminated) {
                LOGE("Run() called on terminated thread");
                return kWorkIDAlwaysFinished;
            }
            mWorkQueue.emplace(std::move(work));
            pushedWorkID = ++m_lastPushedWorkID;
        }
        m_workPushedCondition.notify_one();
        return pushedWorkID;
    }

    void WaitUntilComplete(WorkID workID)
    {
        if (m_lastCompletedWorkID >= workID) {
            return; // Early out that doesn't require a mutex!
        }
        std::lock_guard<std::mutex> threadLock(mWorkMutex);
        while (m_lastCompletedWorkID < workID) {
            m_workedCompletedCondition.wait(mWorkMutex);
        }
    }

    void RunAndWait(Work &&work)
    {
        WaitUntilComplete(Run(std::move(work)));
    }

    void TerminateThread()
    {
        bool didSendTerminationToken = false;
        {
            std::lock_guard workLock(mWorkMutex);
            if (!mIsTerminated) {
                mWorkQueue.emplace(nullptr);
                mIsTerminated = true;
                didSendTerminationToken = true;
            }
        }
        if (didSendTerminationToken) {
            m_workPushedCondition.notify_one();
            // Check if the current thread is the worker thread itself. Since we
            // dispose async this could happen directly on the worker thread
            // itself.
            if (std::this_thread::get_id() == mThread.get_id()) {
                // A thread cannot join itself as it will deadlock. Detach it
                // and let it terminate.
                mThread.detach();
            } else {
                // It's safe to join from another thread.
                mThread.join();
                if (m_lastCompletedWorkID != m_lastPushedWorkID) {
                    LOGE("m_lastCompletedWorkID does not match m_lastPushedWorkID");
                }
            }
        }
    }

    RendererType GetRendererType() const
    {
        return m_rendererType;
    }

protected:
    const RendererType m_rendererType;

private:
    static std::unique_ptr<DrawableThreadState> MakeThreadState(const RendererType type);

    void ThreadMain()
    {
        SetAffinity(mAffinity);
        pthread_setname_np(pthread_self(), mName.c_str());

        m_threadState = MakeThreadState(m_rendererType);
        if (m_threadState == nullptr) {
            LOGE("Failed to create thread state");
            return;
        }

        std::unique_lock lock(mWorkMutex);
        bool runThread = true;
        while (runThread) {
            while (mWorkQueue.empty()) {
                m_workPushedCondition.wait(mWorkMutex);
            }
            Work work = mWorkQueue.front();
            mWorkQueue.pop();

            if (!work) {
                // A null function is a special token that tells the thread to
                // terminate.
                runThread = false;
                break;
            }

            lock.unlock();
            if (m_threadState != nullptr) {
                work(m_threadState.get());
            } else {
                LOGE("Work executed with null thread state");
            }
            lock.lock();

            ++m_lastCompletedWorkID;
            m_workedCompletedCondition.notify_all();
        }
        lock.unlock();
        m_threadState.reset();
    }

    const std::string mName;
    const Affinity mAffinity;

    WorkID m_lastPushedWorkID = kWorkIDAlwaysFinished;
    std::atomic<WorkID> m_lastCompletedWorkID = kWorkIDAlwaysFinished;
    bool mIsTerminated = false;

    std::queue<std::function<void(DrawableThreadState *)>> mWorkQueue;
    std::condition_variable_any m_workPushedCondition;
    std::condition_variable_any m_workedCompletedCondition;

    std::mutex mWorkMutex;
    std::thread mThread;
    std::unique_ptr<DrawableThreadState> m_threadState;
};
} // namespace ohos_rive

#endif // OHOS_RIVE_WORKER_THREAD_H
