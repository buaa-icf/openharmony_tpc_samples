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

#include "../../include/helpers/worker_ref.h"
#include "../../include/helpers/thread_state_pls.h"
#include <memory>
#include <mutex>
#include <thread>

using namespace rive;

namespace ohos_rive {
static std::mutex g_refWorkerMutex;

static std::unique_ptr<RefWorker> g_canvasWorker;

rcp<RefWorker> RefWorker::RiveWorker()
{
    static enum class RiveRendererSupport { UNKNOWN, NO, YES } isSupported;
    static std::unique_ptr<RefWorker> s_riveWorker;

    std::lock_guard<std::mutex> lock(g_refWorkerMutex);

    if (isSupported == RiveRendererSupport::UNKNOWN) {
        if (s_riveWorker != nullptr) {
            LOGE("s_riveWorker should be null when creating new Rive RefWorker");
            return nullptr;
        }
        LOGI("Creating *Rive* RefWorker");

        std::unique_ptr<RefWorker> candidateWorker = std::make_unique<RefWorker>(RendererType::RIVE);
        // Check if PLS is supported.
        candidateWorker->RunAndWait([](ohos_rive::DrawableThreadState *threadState) {
            PLSThreadState *plsThreadState = static_cast<PLSThreadState *>(threadState);
            isSupported =
                plsThreadState->renderContext() != nullptr ? RiveRendererSupport::YES : RiveRendererSupport::NO;
        });
        if (isSupported == RiveRendererSupport::UNKNOWN) {
            LOGE("s_isSupported should not be Unknown after checking renderer support");
            return nullptr;
        }
        if (isSupported == RiveRendererSupport::YES) {
            // The Rive renderer is supported!
            s_riveWorker = std::move(candidateWorker);
        } else {
            LOGI("Rive renderer is not supported. Falling back on Canvas.");
        }
    }

    if (s_riveWorker != nullptr) {
        ++s_riveWorker->m_externalRefCount; // Increment the external ref count.
    }
    return rcp(s_riveWorker.get());
}

rcp<RefWorker> RefWorker::CanvasWorker()
{
    std::lock_guard<std::mutex> lock(g_refWorkerMutex);
    if (g_canvasWorker == nullptr) {
        LOGI("Creating *Canvas* RefWorker");
        g_canvasWorker = std::make_unique<RefWorker>(RendererType::CANVAS);
    }
    ++g_canvasWorker->m_externalRefCount; // Increment the external ref count.
    return rcp(g_canvasWorker.get());
}

rcp<RefWorker> RefWorker::CurrentOrFallback(RendererType rendererType)
{
    // N.B. if fallback changes, `GetFactory()` also needs to change.
    rcp<RefWorker> currentOrFallback;
    switch (rendererType) {
        case RendererType::NONE:
            LOGE("Renderer type is None");
            break;
        case RendererType::RIVE:
            currentOrFallback = RiveWorker();
            break;
        case RendererType::CANVAS:
            currentOrFallback = CanvasWorker();
            break;
    }
    return currentOrFallback;
}

RefWorker::~RefWorker()
{
    LOGI("Deleting the RefWorker with %s", RendererName(GetRendererType()));
    TerminateThread();
}

void RefWorker::ref()
{
    std::lock_guard<std::mutex> lock(g_refWorkerMutex);
    ++m_externalRefCount;
}

void RefWorker::unref()
{
    std::lock_guard<std::mutex> lock(g_refWorkerMutex);
    if (m_externalRefCount <= 0) {
        LOGE("unref() called with m_externalRefCount <= 0");
        return;
    }
    if (--m_externalRefCount == 0) {
        ExternalRefCountDidReachZero();
    }
}

void RefWorker::ExternalRefCountDidReachZero()
{
    switch (GetRendererType()) {
        case RendererType::NONE: {
            LOGE("Renderer type is None");
            break;
        }
        case RendererType::RIVE: {
            // Release the Rive worker's GPU resources, but keep the GL context
            // alive. We have simple way to release GPU resources here instead,
            // without having to pay the hefty price of destroying and
            // re-creating the entire GL context.
            Run([](ohos_rive::DrawableThreadState *threadState) {
                PLSThreadState *plsThreadState = static_cast<PLSThreadState *>(threadState);
                rive::gpu::RenderContext *renderContext = plsThreadState->renderContext();
                if (renderContext != nullptr) {
                    LOGI("Releasing resources on the Rive renderer");
                    renderContext->releaseResources();
                }
            });
            break;
        }
        case RendererType::CANVAS: {
            // Delete the entire Canvas context.
            if (g_canvasWorker.get() != this) {
                LOGE("g_canvasWorker.get() != this in ExternalRefCountDidReachZero");
                break;
            }
            auto workerToDestroy = g_canvasWorker.release(); // Transfer ownership
            std::thread([workerToDestroy]() {
                // This 'delete' will call ~RefWorker -> ~WorkerThread ->
                // TerminateThread(). Because this is a separate thread,
                // TerminateThread() will call mThread.join() which will block
                // safely until the worker is finished.
                delete workerToDestroy;
            }).detach();
            break;
        }
    }
}
} // namespace ohos_rive
