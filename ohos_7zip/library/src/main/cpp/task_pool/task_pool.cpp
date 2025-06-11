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

#include "task_pool.h"
#include <ffrt/queue.h>
#include <ffrt/task.h>
#include <ffrt/type_def.h>
namespace Oh7zip {
TaskPool TaskPool::instance_;

typedef struct {
    ffrt_function_header_t header;
    ffrt_function_t func;
    ffrt_function_t afterFunc;
    void *arg;
} c_function_t;

static inline void FfrtExecFunctionWrapper(void *t)
{
    c_function_t *f = (c_function_t *)(t);
    if (f && f->func) {
        f->func(f->arg);
    }
}

static inline void FfrtDestroyFunctionWrapper(void *t)
{
    c_function_t *f = (c_function_t *)(t);
    if (f && f->afterFunc) {
        f->afterFunc(f->arg);
    }
}

#define FFRT_STATIC_ASSERT(cond, msg) int x(int static_assertion_##msg[(cond) ? 1 : -1])
ffrt_function_header_t *FfrtCreateFunctionWrapper(ffrt_function_t func, ffrt_function_t afterFunc, void *arg)
{
    FFRT_STATIC_ASSERT(sizeof(c_function_t) <= ffrt_auto_managed_function_storage_size,
                       size_of_function_must_be_less_than_ffrt_auto_managed_function_storage_size);

    c_function_t *f = (c_function_t *)ffrt_alloc_auto_managed_function_storage_base(ffrt_function_kind_queue);
    f->header.exec = FfrtExecFunctionWrapper;
    f->header.destroy = FfrtDestroyFunctionWrapper;
    f->func = func;
    f->afterFunc = afterFunc;
    f->arg = arg;
    return (ffrt_function_header_t *)f;
}

void TaskPool::ExecFunction(void *data)
{
    auto asyncData = static_cast<AsyncData *>(data);
    if (asyncData) {
        asyncData->func();
    }
}

void TaskPool::AfterExecFunction(void *data)
{
    auto asyncData = static_cast<AsyncData *>(data);
    if (asyncData) {
        if (asyncData->handle) {
            ffrt_task_handle_destroy(asyncData->handle);
            asyncData->handle = nullptr;
        }
        delete asyncData;
        asyncData = nullptr;
    }
}

TaskPool::TaskPool()
{
    (void)ffrt_queue_attr_init(&queueAttr_);
    ffrt_queue_attr_set_max_concurrency(&queueAttr_, defaultMaxRunningTask_);
    queue_ = ffrt_queue_create(ffrt_queue_concurrent, queueName_.c_str(), &queueAttr_);

    serialQueue_ = ffrt_queue_create(ffrt_queue_serial, serialQueueName_.c_str(), nullptr);
}

TaskPool::~TaskPool()
{
    if (queue_ != nullptr) {
        ffrt_queue_destroy(queue_);
        queue_ = nullptr;
    }
    ffrt_queue_attr_destroy(&queueAttr_);

    if (serialQueue_ != nullptr) {
        ffrt_queue_destroy(serialQueue_);
        serialQueue_ = nullptr;
    }
}

TaskPool &TaskPool::GetInstance()
{
    return instance_;
}
}