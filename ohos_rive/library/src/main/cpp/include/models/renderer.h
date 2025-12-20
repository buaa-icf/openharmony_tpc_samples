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

#ifndef OHOS_RIVE_RENDERER_H
#define OHOS_RIVE_RENDERER_H

#include "../helpers/factories.h"
#include "../helpers/render_type.h"
#include "../helpers/tracer.h"
#include "../helpers/worker_ref.h"
#include "worker_impl.h"
#include <napi/native_api.h>

namespace ohos_rive {
class Renderer {
public:
    // Constructor and destructor
    explicit Renderer(napi_env env,
                      napi_value ohosRenderer,
                      bool trace = false,
                      RendererType rendererType = RendererType::RIVE);
    ~Renderer();

    // Lifecycle management
    void ScheduleDispose();

    // Surface management
    void SetSurface(SurfaceVariant &surface);
    int GetWidth() const;
    int GetHeight() const;

    // Renderer access
    rive::Renderer *GetRendererOnWorkerThread() const;
    RendererType GetRendererType() const
    {
        return m_worker->GetRendererType();
    };

    // Rendering control
    void Start();
    void Stop();
    void DoFrame();

    // Performance metrics
    double AverageFps() const
    {
        return m_averageFps;
    }

private:
    // Constants
    static constexpr uint8_t kMaxScheduledFrames = 2;
    static constexpr int INVALID_DIMENSION = -1;

    rive::rcp<RefWorker> m_worker;
    napi_value m_renderer;

    napi_env m_env;
    napi_ref m_rendererRef = nullptr;

    SurfaceVariant m_surface = std::monostate{};

    std::thread::id m_workerThreadID;
    std::unique_ptr<WorkerImpl> m_workerImpl;
    std::atomic_uint8_t m_numScheduledFrames = 0;

    // FPS calculation
    std::chrono::steady_clock::time_point m_fpsLastFrameTime;
    std::atomic<double> m_averageFps = -1.0f;
    double m_fpsSum = 0.0f;
    int m_fpsCount = 0;

    // State tracking
    std::atomic<bool> m_isDisposeScheduled = false;

    // Tracing
    std::unique_ptr<ITracer> m_tracer;

    // Helper methods
    static std::unique_ptr<ITracer> MakeTracer(bool trace);
    void CalculateFps(std::chrono::high_resolution_clock::time_point frameTime);
    void AcquireSurface(SurfaceVariant &surface);
    void ReleaseSurface(SurfaceVariant &surface);

    bool CallRendererMethod(const char *methodName);
    void StartRenderer(std::chrono::high_resolution_clock::time_point now);
    void DoMeshFrame();

    // About threadsafe
    napi_threadsafe_function m_tsfn = nullptr;
    static void TSFNCallback(napi_env env, napi_value js_callback, void *context, void *data);
    static void TSFNCallbackExecuteCallback(napi_env env, napi_value js_callback, TSFNData *tsfnData);
    std::chrono::high_resolution_clock::time_point m_lastMeshFrameTime;
};

extern OhosRiveRenderFactory *g_RiveFactory;
} // namespace ohos_rive
#endif // OHOS_RIVE_RENDERER_H

