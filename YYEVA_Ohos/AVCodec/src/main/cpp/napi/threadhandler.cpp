#include "threadhandler.h"
#include <unordered_map>
#include <ohos_utils/ohos_log.h>

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
        while (flag_ == true) {
            done_ = false;
            if (pause_) {
                std::unique_lock<std::mutex> lock(pauseMutex_);
                pauseCond_.wait_for(lock, std::chrono::milliseconds(500), [this]() {
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
