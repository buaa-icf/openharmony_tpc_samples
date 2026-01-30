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

#include "models/renderer.h"
#include "helpers/exception_handler.h"
#include "helpers/general.h"
#include "helpers/resource.h"
#include "models/canvas_renderer.h"
#include <js_native_api.h>

using namespace std::chrono_literals;

namespace ohos_rive {
void Renderer::TSFNCallback(napi_env env, napi_value js_callback, void *context, void *data)
{
    if (env == nullptr || data == nullptr) {
        return;
    }

    auto *tsfnData = static_cast<TSFNData *>(data);
    Renderer *renderer = static_cast<Renderer *>(context);

    if (!renderer || renderer->m_isDisposeScheduled) {
        delete tsfnData;
        return;
    }
    napi_handle_scope scope;
    napi_open_handle_scope(env, &scope);

    TSFNCallbackExecuteCallback(env, js_callback, tsfnData);
    napi_close_handle_scope(env, scope);
    if (tsfnData->completionCallback) {
        tsfnData->completionCallback();
    }
    delete tsfnData;
}

void Renderer::TSFNCallbackExecuteCallback(napi_env env, napi_value js_callback, TSFNData *tsfnData)
{
    napi_value method;
    napi_status status;

    switch (tsfnData->type) {
        case TSFNData::Type::ADVANCE: {
            if (napi_get_named_property(env, js_callback, "advance", &method) != napi_ok) {
                LOGE("TSFNCallback napi_get_named_property ADVANCE failed");
                return;
            }

            napi_value elapsedMsValue;
            napi_create_double(env, tsfnData->elapsedMs, &elapsedMsValue);
            napi_value argv[] = {elapsedMsValue};

            status = napi_call_function(env, js_callback, method, 1, argv, nullptr);
            if (status != napi_ok) {
                LOGE("TSFNCallback napi_call_function ADVANCE failed");
            }
            break;
        }
        case TSFNData::Type::DRAW: {
            if (napi_get_named_property(env, js_callback, "draw", &method) != napi_ok) {
                LOGE("TSFNCallback napi_get_named_property DRAW failed");
                return;
            }

            status = napi_call_function(env, js_callback, method, 0, nullptr, nullptr);
            if (status != napi_ok) {
                LOGE("TSFNCallback napi_call_function DRAW failed");
            }
            break;
        }
        case TSFNData::Type::DISPOSE: {
            napi_get_named_property(env, js_callback, "disposeDependencies", &method);
            napi_call_function(env, js_callback, method, 0, nullptr, nullptr);
            break;
        }
    }
}

Renderer::Renderer(napi_env env, napi_value ohosRenderer, bool trace, const RendererType rendererType)
    : m_worker(RefWorker::CurrentOrFallback(rendererType)),
      m_renderer(ohosRenderer),
      m_env(env),
      m_tracer(MakeTracer(trace))
{
    // Create a persistent reference to the renderer object
    if (env != nullptr && ohosRenderer != nullptr) {
        napi_create_reference(env, ohosRenderer, 1, &m_rendererRef);
    }
}

Renderer::~Renderer()
{
    if (m_tsfn != nullptr) {
        napi_release_threadsafe_function(m_tsfn, napi_tsfn_abort);
        m_tsfn = nullptr;
    }
    if (!m_isDisposeScheduled) {
        LOGE("Renderer was deleted directly instead of scheduling disposal!");
    }
}

// 异步调度销毁流程，确保线程安全且只执行一次
void Renderer::ScheduleDispose()
{
    // 原子标记：若已置位则直接返回，防止重复销毁
    bool isDisposed = m_isDisposeScheduled.exchange(true);
    if (isDisposed) {
        return;
    }

    // 在工作线程中完成真正的资源释放
    m_worker->Run([this](DrawableThreadState *threadState) {
        // 1. 销毁底层渲染实现
        if (m_workerImpl) {
            m_workerImpl->destroy(threadState);
        }

        // 2. 通过 TSFN 通知 JS 层执行 disposeDependencies
        if (m_tsfn != nullptr) {
            auto *data = new TSFNData{TSFNData::Type::DISPOSE};
            napi_call_threadsafe_function(m_tsfn, data, napi_tsfn_blocking);
        }

        // 3. 释放 NAPI 持久引用，防止内存泄漏
        if (m_rendererRef != nullptr && m_env != nullptr) {
            napi_delete_reference(m_env, m_rendererRef);
            m_rendererRef = nullptr;
        }

        // 4. 释放 surface 资源
        ReleaseSurface(m_surface);
        // 5. 自毁，注意此时已无任何外部引用
        delete this;
    });
}

void Renderer::SetSurface(SurfaceVariant &surface)
{
    if (m_isDisposeScheduled) {
        return;
    }

    // 保留旧surface的最后一帧，直到surface完成切换，防止黑屏。
    auto oldSurface = m_surface;
    OHNativeWindow *oldNativeWindow = nullptr;
    if (auto oldWindow = std::get_if<EGLNativeWindowType>(&oldSurface)) {
        oldNativeWindow = reinterpret_cast<OHNativeWindow *>(*oldWindow);
    }
    OH_NativeWindow_SetBufferHold(oldNativeWindow);

    AcquireSurface(surface);

    m_worker->Run([this, oldSurface](DrawableThreadState *threadState) mutable {
        m_workerThreadID = std::this_thread::get_id();
        if (m_workerImpl) {
            m_workerImpl->destroy(threadState);
            m_workerImpl.reset();
            ReleaseSurface(oldSurface);
        }

        if (m_surface.index() > 0) {
            m_workerImpl = WorkerImpl::Make(m_surface, threadState, m_worker->GetRendererType());
        }
    });
}

rive::Renderer *Renderer::GetRendererOnWorkerThread() const
{
    if (!m_workerImpl) {
        return nullptr;
    }
    return m_workerImpl->renderer();
}

// 启动渲染器：创建线程安全函数（TSFN）并在工作线程中初始化底层渲染实现
void Renderer::Start()
{
    // 若已调度销毁则直接返回，避免对已释放资源操作
    if (m_isDisposeScheduled) {
        return;
    }

    // 从持久引用中获取 JS 层 renderer 对象
    napi_value ohosRenderer;
    napi_status tmpStatus = napi_get_reference_value(m_env, m_rendererRef, &ohosRenderer);
    if (tmpStatus != napi_ok) {
        LOGE("Failed to create reference for renderer");
        return;
    }

    // 创建线程安全函数名称
    napi_value resource_name;
    napi_create_string_utf8(m_env, "RendererTSFN", NAPI_AUTO_LENGTH, &resource_name);

    // 创建线程安全函数，用于跨线程回调 JS 层方法（advance/draw/dispose）
    napi_status status = napi_create_threadsafe_function(m_env, ohosRenderer, nullptr, resource_name,
                                                         0, // Initial thread count
                                                         1, // Max thread count
                                                         nullptr,
                                                         nullptr, // finalizer
                                                         this, TSFNCallback, &m_tsfn);
    if (status != napi_ok) {
        m_tsfn = nullptr;
    }

    m_worker->Run([this](DrawableThreadState *threadState) {
        if (!m_workerImpl) {
            return;
        }

        auto now = std::chrono::steady_clock::now();
        m_fpsLastFrameTime = now;
        m_workerImpl->start(now);
    });
}

// 停止渲染循环
// 若已调度销毁则直接返回，避免对已释放资源操作
void Renderer::Stop()
{
    if (m_isDisposeScheduled) {
        return;
    }
    // 在工作线程中安全地停止底层渲染实现
    m_worker->Run([this](DrawableThreadState *threadState) {
        if (!m_workerImpl) {
            return;
        }
        m_workerImpl->stop();
    });
}

// 执行一帧渲染：若未处于销毁流程且未超限，则向工作线程投递渲染任务
void Renderer::DoFrame()
{
    // 若已触发销毁流程，直接返回，避免对已释放资源操作
    if (m_isDisposeScheduled) {
        return;
    }

    // 防止帧任务堆积：若已调度帧数达到上限，跳过本次请求
    if (m_numScheduledFrames >= kMaxScheduledFrames) {
        return;
    }

    m_worker->Run([this](DrawableThreadState *threadState) {
        if (!m_workerImpl) {
            return;
        }

        auto now = std::chrono::high_resolution_clock::now();
        m_workerImpl->doFrame(m_tracer.get(), threadState, now, this, m_tsfn);
        m_numScheduledFrames--;
        CalculateFps(now);
    });

    // 增加已调度帧计数，表示已提交一个异步帧任务
    m_numScheduledFrames++;
}

std::unique_ptr<ITracer> Renderer::MakeTracer(bool trace)
{
    if (!trace) {
        return std::make_unique<NoopTracer>();
    } else {
        return std::make_unique<Tracer>();
    }
}

void Renderer::CalculateFps(std::chrono::high_resolution_clock::time_point frameTime)
{
    m_tracer->beginSection("CalculateFps()");
    static constexpr int FPS_SAMPLES = 10;
    double elapsed = std::chrono::duration<double>(frameTime - m_fpsLastFrameTime).count();
    if (elapsed == 0) {
        return;
    }
    m_fpsSum += 1.0f / elapsed;
    m_fpsCount++;
    if (m_fpsCount == FPS_SAMPLES) {
        m_averageFps = m_fpsSum / static_cast<double>(FPS_SAMPLES);
        m_fpsSum = 0;
        m_fpsCount = 0;
    }
    m_fpsLastFrameTime = frameTime;
    m_tracer->endSection();
}

void Renderer::AcquireSurface(SurfaceVariant &surface)
{
    if (auto *window = std::get_if<EGLNativeWindowType>(&surface)) {
        OH_NativeWindow_NativeObjectReference(reinterpret_cast<void *>(*window));
        m_surface = *window;
    } else if (auto *window = std::get_if<OHNativeWindow *>(&surface)) {
        OH_NativeWindow_NativeObjectReference(reinterpret_cast<void *>(*window));
        m_surface = *window;
    }
}

void Renderer::ReleaseSurface(SurfaceVariant &surface)
{
    if (auto *window = std::get_if<EGLNativeWindowType>(&surface)) {
        OH_NativeWindow_NativeObjectUnreference(reinterpret_cast<void *>(*window));
    } else if (auto *window = std::get_if<OHNativeWindow *>(&surface)) {
        OH_NativeWindow_NativeObjectUnreference(reinterpret_cast<void *>(*window));
    }
}

int Renderer::GetWidth(bool isDraw) const
{
    if (GetRendererType() == RendererType::CANVAS) {
        if (m_workerThreadID == std::thread::id{} || !m_workerImpl) {
            return INVALID_DIMENSION;
        }

        auto renderer = static_cast<CanvasRenderer *>(GetRendererOnWorkerThread());
        return renderer ? renderer->Width() : INVALID_DIMENSION;
    } else if (auto window = std::get_if<EGLNativeWindowType>(&m_surface)) {
        if (!isDraw) {
            int width = 0;
            int height = 0;
            OHNativeWindow *nativeWindow = reinterpret_cast<OHNativeWindow *>(*window);
            OH_NativeWindow_NativeWindowHandleOpt(nativeWindow, GET_BUFFER_GEOMETRY, &height, &width);
            return width;
        } else if (m_workerImpl) {
            return m_workerImpl->getWidth();
        }
    }

    return INVALID_DIMENSION;
}

int Renderer::GetHeight(bool isDraw) const
{
    if (GetRendererType() == RendererType::CANVAS) {
        if (m_workerThreadID == std::thread::id{} || !m_workerImpl) {
            return INVALID_DIMENSION;
        }

        auto renderer = static_cast<CanvasRenderer *>(GetRendererOnWorkerThread());
        return renderer ? renderer->Height() : INVALID_DIMENSION;
    } else if (auto window = std::get_if<EGLNativeWindowType>(&m_surface)) {
        if (!isDraw) {
            int width = 0;
            int height = 0;
            OHNativeWindow *nativeWindow = reinterpret_cast<OHNativeWindow *>(*window);
            OH_NativeWindow_NativeWindowHandleOpt(nativeWindow, GET_BUFFER_GEOMETRY, &height, &width);
            return height;
        } else if (m_workerImpl) {
            return m_workerImpl->getHeight();
        }
    }
    return INVALID_DIMENSION;
}

bool Renderer::CallRendererMethod(const char *methodName)
{
    if (m_env == nullptr || methodName == nullptr || m_renderer == nullptr) {
        return false;
    }

    napi_value method;
    if (napi_get_named_property(m_env, m_renderer, methodName, &method) != napi_ok) {
        return false;
    }

    napi_valuetype type;
    napi_typeof(m_env, method, &type);
    if (type != napi_function) {
        return false;
    }

    napi_value result;
    if (napi_call_function(m_env, m_renderer, method, 0, nullptr, &result) != napi_ok) {
        return false;
    }
    return true;
}
} // namespace ohos_rive
