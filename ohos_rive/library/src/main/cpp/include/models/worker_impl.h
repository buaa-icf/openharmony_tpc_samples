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

#ifndef OHOS_RIVE_MPF_WORKER_IMPL_H
#define OHOS_RIVE_MPF_WORKER_IMPL_H
#include <variant>

#include "canvas_renderer.h"
#include "helpers/thread_state_pls.h"
#include "helpers/tracer.h"
#include "refs.h"
#include "rive/renderer/gl/render_target_gl.hpp"
#include "rive/renderer/rive_renderer.hpp"
#include <atomic>
#include <native_window/external_window.h>
#include <thread>

// Either EGLNativeWindowType* or a NAPI surface.
// std::monostate holds an 'empty' variant.
using SurfaceVariant = std::variant<std::monostate, EGLNativeWindowType, OHNativeWindow *>;
namespace ohos_rive {
class Renderer;
constexpr size_t NUM_FOUR = 4;
struct TSFNData {
    enum class Type { ADVANCE, DRAW, DISPOSE };
    Type type;
    std::chrono::high_resolution_clock::time_point frameTime;
    float elapsedMs = 0.0f;
    std::function<void()> completionCallback = nullptr;
};
class WorkerImpl {
public:
    static std::unique_ptr<WorkerImpl> Make(SurfaceVariant, DrawableThreadState *, RendererType);

    virtual ~WorkerImpl()
    {
        // Call destroy() first!
        if (m_isStarted) {
            LOGE("Error: m_isStarted is true in destructor");
            return;
        }
    }

    void start(std::chrono::high_resolution_clock::time_point frameTime);

    void stop();

    void doFrame(ITracer *tracer,
                 DrawableThreadState *threadState,
                 std::chrono::high_resolution_clock::time_point frameTime,
                 Renderer* renderer,
                 napi_threadsafe_function worker_tsfn = nullptr);

    virtual void prepareForDraw(DrawableThreadState *) = 0;

    virtual void destroy(DrawableThreadState *) = 0;

    virtual void flush(DrawableThreadState *) = 0;

    [[nodiscard]] virtual rive::Renderer *renderer() const = 0;

    int32_t getWidth() const
    {
        return m_width;
    }

    int32_t getHeight() const
    {
        return m_height;
    }

protected:
    napi_env m_env = nullptr;
    napi_ref m_napiRendererRef = nullptr;
    napi_value m_napiDrawCallback = nullptr;
    napi_value m_napiAdvanceCallback = nullptr;
    std::chrono::high_resolution_clock::time_point m_lastFrameTime;
    bool m_isStarted = false;
    std::atomic<bool> drawCompleted;
    std::atomic<bool> advanceCompleted;
    int32_t m_width = 0;
    int32_t m_height = 0;
};

class EGLWorkerImpl : public WorkerImpl {
public:
    ~EGLWorkerImpl() override
    {
        // Call destroy() first!
        if (m_eglSurface != EGL_NO_SURFACE) {
            LOGE("Error: m_eglSurface is not EGL_NO_SURFACE in destructor");
            return;
        }
    }

    // 销毁 EGL 相关资源
    // 如果当前存在有效的 EGLSurface，则通过线程状态对象销毁它，并将句柄置为无效值
    void destroy(DrawableThreadState *threadState) override
    {
        if (m_eglSurface != EGL_NO_SURFACE) {
            auto eglThreadState = static_cast<EGLThreadState *>(threadState);
            eglThreadState->destroySurface(m_eglSurface);
            m_eglSurface = EGL_NO_SURFACE;
        }
    }

    void prepareForDraw(DrawableThreadState *threadState) override
    {
        // 将传入的线程状态指针转换为 EGL 线程状态，以便访问 EGL 相关资源
        auto eglThreadState = static_cast<EGLThreadState *>(threadState);
        // 将 EGL 上下文绑定到当前线程，确保后续绘制命令在此线程上执行
        eglThreadState->makeCurrent(m_eglSurface);
        // 清空绘制表面，为新的绘制帧做准备
        clear(threadState);
    }

    virtual void clear(DrawableThreadState *) const = 0;

protected:
    // 构造函数：根据传入的本地窗口句柄创建 EGL 绘图表面, 参数：
    // window       - 平台相关的本地窗口句柄（EGLNativeWindowType）
    // threadState  - 当前线程状态，需为 EGLThreadState 类型
    // success      - 出参，标志表面创建是否成功；调用前需置为 false，成功时置为 true
    EGLWorkerImpl(EGLNativeWindowType window, DrawableThreadState *threadState, bool *success)
    {
        *success = false;                                                 // 默认标记为失败
        auto eglThreadState = static_cast<EGLThreadState *>(threadState); // 获取 EGL 线程状态
        m_eglSurface = eglThreadState->createEGLSurface(window);          // 创建 EGL 表面
        if (m_eglSurface == EGL_NO_SURFACE)
            return;      // 创建失败则直接返回
        *success = true; // 创建成功，标记为 true
    }

    void *m_eglSurface = EGL_NO_SURFACE;
};

class PLSWorkerImpl : public EGLWorkerImpl {
public:
    PLSWorkerImpl(EGLNativeWindowType, DrawableThreadState *, bool *success);

    void destroy(DrawableThreadState *threadState) override;

    void clear(DrawableThreadState *threadState) const override;

    void flush(DrawableThreadState *threadState) override;

    [[nodiscard]] rive::Renderer *renderer() const override;

    void prepareForDraw(DrawableThreadState *threadState) override
    {
        // 将传入的线程状态指针转换为 EGL 线程状态，以便访问 EGL 相关资源
        auto eglThreadState = static_cast<EGLThreadState *>(threadState);
        // 将 EGL 上下文绑定到当前线程，确保后续绘制命令在此线程上执行
        eglThreadState->makeCurrent(m_eglSurface);
        // 检查窗口尺寸是否与当前渲染目标一致，不一致则重新创建渲染目标
        checkNativeWindowSize();
        // 清空绘制表面，为新的绘制帧做准备
        clear(threadState);
    }

    void checkNativeWindowSize()
    {
        // 查询窗口实际宽高，用于创建与窗口尺寸匹配的渲染目标
        int32_t width = 0;
        int32_t height = 0;
        OH_NativeWindow_NativeWindowHandleOpt(reinterpret_cast<OHNativeWindow *>(m_window), GET_BUFFER_GEOMETRY,
                                              &height, &width);
        if (m_width != width || m_height != height) {
            // 获取系统默认帧缓冲区的多重采样样本数，用于后续创建同采样配置的渲染目标
            GLint sampleCount;
            glBindFramebuffer(GL_FRAMEBUFFER, 0);
            glGetIntegerv(GL_SAMPLES, &sampleCount);

            // 创建 PLS 渲染目标（FramebufferRenderTargetGL），尺寸与窗口一致，采样数与系统一致
            m_renderTarget = rive::make_rcp<rive::gpu::FramebufferRenderTargetGL>(width, height, 0, sampleCount);
            m_width = width;
            m_height = height;
        }
    }

private:
    rive::rcp<rive::gpu::RenderTargetGL> m_renderTarget;

    std::unique_ptr<rive::RiveRenderer> m_plsRenderer;

    // Cast away [threadState] to the the thread state expected by this
    // implementation.
    static PLSThreadState *PlsThreadState(DrawableThreadState *threadState)
    {
        // Quite hacky, but this is a way to sort this out in C++ without
        // RTTI...
        return static_cast<PLSThreadState *>(threadState);
    }

    EGLNativeWindowType m_window;
};

class CanvasWorkerImpl : public WorkerImpl {
public:
    CanvasWorkerImpl(OHNativeWindow *window, bool *success) : m_canvasRenderer{std::make_unique<CanvasRenderer>()}
    {
        *success = true;
        m_nativeWindow = window;
        getDrawingCanvas();
    }

    ~CanvasWorkerImpl() override
    {
        // Call destroy() first!
        if (m_nativeWindow != nullptr) {
            LOGE("Error: m_nativeWindow is not nullptr in destructor");
            return;
        }
    }

    [[nodiscard]] rive::Renderer *renderer() const override
    {
        return m_canvasRenderer.get();
    }

    void flush(DrawableThreadState *) override;

    void prepareForDraw(DrawableThreadState *) override;

    void destroy(DrawableThreadState *) override;

    void getDrawingCanvas(bool isGetWindowSize = true);

private:
    bool requestAndPrepareBuffer(NativeWindowBuffer **outBuffer,
                                 int *outFenceFd,
                                 BufferHandle **outBufferHandle,
                                 uint32_t **outMappedAddr) const;

    bool getBitmapData(void **outBitmapAddr,
                       int32_t *outBitmapWidth,
                       int32_t *outBitmapHeight,
                       int32_t *outBitmapStrideBytes) const;

    std::unique_ptr<CanvasRenderer> m_canvasRenderer;
    OH_Drawing_Bitmap *cScreenBitmap_ = nullptr;
    OH_Drawing_Canvas *cScreenCanvas_ = nullptr;
    OHNativeWindow *m_nativeWindow = nullptr;
    OH_Drawing_ColorFormat colorType = COLOR_FORMAT_RGBA_8888;
    OH_Drawing_AlphaFormat alphaType = ALPHA_FORMAT_PREMUL;
    int32_t width_ = 0;
    int32_t height_ = 0;
};

} // namespace ohos_rive
#endif // OHOS_RIVE_MPF_WORKER_IMPL_H
