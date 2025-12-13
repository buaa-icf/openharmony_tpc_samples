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

#ifndef OHOS_RIVE_WORKER_REF_H
#define OHOS_RIVE_WORKER_REF_H

#include "render_type.h"
#include "rive/refcnt.hpp"
#include "thread_state_egl.h"
#include "worker_thread.h"

namespace ohos_rive {
class RefWorker : public WorkerThread {
public:
    // Returns the current worker of the requested renderer type, or the current
    // Canvas worker if the requested type is not supported.
    static rive::rcp<RefWorker> CurrentOrFallback(RendererType);

    // Returns the Rive renderer worker, or null if it is not supported.
    static rive::rcp<RefWorker> RiveWorker();

    // Returns the current Canvas renderer worker.
    static rive::rcp<RefWorker> CanvasWorker();

    ~RefWorker() override;

    // These methods work with rive::rcp<> for tracking _external_ references.
    // They don't necessarily delete this object when the external ref count
    // goes to zero, and they may have other side effects as well.
    void ref();
    void unref();

    static const char *RendererName(RendererType rendererType)
    {
        switch (rendererType) {
            case RendererType::NONE:
                LOGE("RendererName called with RendererType::NONE");
                return "";
            case RendererType::CANVAS:
                return "Canvas";
            case RendererType::RIVE:
                return "Rive";
        }
    }

public:
    explicit RefWorker(const RendererType rendererType)
        : WorkerThread(RendererName(rendererType), Affinity::NONE, rendererType)
    {
    }
private:
    void ExternalRefCountDidReachZero();

    size_t m_externalRefCount = 0;
};
} // namespace ohos_rive

#endif // OHOS_RIVE_WORKER_REF_H

