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

#include "models/worker_impl.h"
#include "helpers/exception_handler.h"
#include "helpers/thread_state_egl.h"

#include "rive/audio/audio_engine.hpp"
#include "rive/renderer/gl/render_target_gl.hpp"

#include "napi/native_api.h"
#include <native_drawing/drawing_bitmap.h>
#include <native_drawing/drawing_rect.h>
#include <native_window/external_window.h>
#include <sys/mman.h>

namespace ohos_rive {
std::unique_ptr<WorkerImpl> WorkerImpl::Make(SurfaceVariant surface,
                                             DrawableThreadState *threadState,
                                             const RendererType type)
{
    if (surface.index() <= 0) {
        LOGE("Invalid surface index.");
        return nullptr;
    }
    bool success = false;
    std::unique_ptr<WorkerImpl> impl;
    switch (type) {
        case RendererType::RIVE: {
            EGLNativeWindowType window = std::get<EGLNativeWindowType>(surface);
            impl = std::make_unique<PLSWorkerImpl>(window, threadState, &success);
            break;
        }
        case RendererType::CANVAS: {
            OHNativeWindow *window = std::get<OHNativeWindow *>(surface);
            impl = std::make_unique<CanvasWorkerImpl>(window, &success);
            break;
        }
        default:
            break;
    }
    if (!success) {
        impl->destroy(threadState);
        impl.reset();
    }
    return impl;
}

// 启动 Worker，记录起始帧时间并标记为已启动状态
void WorkerImpl::start(std::chrono::high_resolution_clock::time_point frameTime)
{
    m_lastFrameTime = frameTime; // 保存当前帧时间，用于后续帧间时间差计算
    m_isStarted = true;          // 设置启动标志，表示 Worker 已开始运行

#ifdef WITH_AUDIO
    // 若编译时开启音频支持，则启动 Rive 音频引擎
    if (auto engine = rive::AudioEngine::RuntimeEngine(false)) {
        engine->start();
    }
#endif
}

// 停止 Worker 的主流程
void WorkerImpl::stop()
{
    // 如果尚未启动，直接返回，避免重复操作
    if (!m_isStarted) {
        return;
    }
#ifdef WITH_RIVE_AUDIO
    // 若编译时开启音频支持，则停止 Rive 音频引擎
    if (auto engine = rive::AudioEngine::RuntimeEngine(false)) {
        engine->stop();
    }
#endif
    // 标记 Worker 为已停止状态
    m_isStarted = false;
}

// 执行一帧渲染的主流程
void WorkerImpl::doFrame(ITracer *tracer,
                         DrawableThreadState *threadState,
                         std::chrono::high_resolution_clock::time_point frameTime,
                         napi_threadsafe_function worker_tsfn)
{
    // 将帧时间转换为毫秒精度，方便后续日志或调试
    auto timestamp_ms = std::chrono::time_point_cast<std::chrono::milliseconds>(frameTime);

    // 若 Worker 未启动，直接跳过本帧
    if (!m_isStarted) {
        LOGE("Worker not started, skipping frame");
        return;
    }

    // 计算距离上一帧的耗时（毫秒）
    float elapsedMs = std::chrono::duration<float>(frameTime - m_lastFrameTime).count();
    m_lastFrameTime = frameTime; // 更新上一帧时间

    // 如果存在 JS 线程安全函数，则先发送 ADVANCE 事件到 JS 层
    if (worker_tsfn != nullptr) {
        auto *advanceData = new TSFNData{TSFNData::Type::ADVANCE};
        advanceData->elapsedMs = elapsedMs; // 传递帧间隔
        advanceData->frameTime = frameTime; // 传递当前帧时间
        advanceCompleted.store(false);      // 重置完成标志
        advanceData->completionCallback = [&]() {
            advanceCompleted.store(true); // JS 回调后设置完成
        };
        // 非阻塞调用，将任务投递到 JS 线程
        napi_call_threadsafe_function(worker_tsfn, advanceData, napi_tsfn_nonblocking);
        // 自旋等待 JS 层处理完毕
        while (!advanceCompleted.load()) {
            std::this_thread::yield();
        };
    }

    // 进入绘制阶段，记录性能追踪区间
    tracer->beginSection("draw()");
    prepareForDraw(threadState); // 准备绘制上下文

    // 再次通过线程安全函数通知 JS 层执行 DRAW 逻辑
    if (worker_tsfn != nullptr) {
        auto *drawData = new TSFNData{TSFNData::Type::DRAW};
        drawCompleted.store(false);
        drawData->completionCallback = [&]() { drawCompleted.store(true); };
        // 阻塞调用，确保 JS 绘制指令全部提交
        napi_call_threadsafe_function(worker_tsfn, drawData, napi_tsfn_blocking);
        // 自旋等待 JS 层绘制完成
        while (!drawCompleted.load()) {
            std::this_thread::yield();
        };
    }

    // 刷新 GPU 指令，提交渲染命令
    tracer->beginSection("flush()");
    flush(threadState);
    tracer->endSection(); // flush

    // 交换前后缓冲区，将渲染结果呈现到屏幕
    tracer->beginSection("swapBuffers()");
    threadState->SwapBuffers();
    tracer->endSection(); // SwapBuffers

    tracer->endSection(); // doFrame
}

/*
 * PLSWorkerImpl 构造函数：初始化基于 PLS（Pixel Local Storage）的 Worker 实现
 * 参数：
 *   window      – 平台原生窗口句柄（EGLNativeWindowType）
 *   threadState – 当前线程的绘制状态管理器
 *   success     – 输出参数，标记本阶段初始化是否成功
 */
PLSWorkerImpl::PLSWorkerImpl(EGLNativeWindowType window, DrawableThreadState *threadState, bool *success)
    : EGLWorkerImpl(window, threadState, success) // 先调用基类完成 EGL 相关初始化
{
    // 若基类 EGL 初始化失败，直接返回，不再继续
    if (!success) {
        LOGE("EGLWorkerImpl creation failed");
        return;
    }

    // 将通用线程状态转换为 EGL 专用状态，方便后续 EGL 调用
    auto eglThreadState = static_cast<EGLThreadState *>(threadState);

    // 将 EGL 上下文绑定到当前线程，确保后续 GL 指令在正确上下文执行
    eglThreadState->makeCurrent(m_eglSurface);

    // 获取 PLS 线程状态及其关联的 GPU 渲染上下文
    rive::gpu::RenderContext *renderContext = PLSWorkerImpl::PlsThreadState(eglThreadState)->renderContext();
    if (renderContext == nullptr) {
        LOGE("PLS render context is null, PLS not supported");
        return; // 当前环境不支持 PLS，提前结束
    }

    // 查询窗口实际宽高，用于创建与窗口尺寸匹配的渲染目标
    int32_t width = 0;
    int32_t height = 0;
    OH_NativeWindow_NativeWindowHandleOpt(reinterpret_cast<OHNativeWindow *>(window), GET_BUFFER_GEOMETRY, &height,
                                          &width);

    // 获取系统默认帧缓冲区的多重采样样本数，用于后续创建同采样配置的渲染目标
    GLint sampleCount;
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
    glGetIntegerv(GL_SAMPLES, &sampleCount);

    // 创建 PLS 渲染目标（FramebufferRenderTargetGL），尺寸与窗口一致，采样数与系统一致
    m_renderTarget = rive::make_rcp<rive::gpu::FramebufferRenderTargetGL>(width, height, 0, sampleCount);

    // 创建 Rive 渲染器，绑定到当前 GPU 渲染上下文
    m_plsRenderer = std::make_unique<rive::RiveRenderer>(renderContext);

    // 设置视口与窗口同尺寸，并清空背景为白色，避免首帧出现脏数据
    glViewport(0, 0, width, height);
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);

    // 首次交换缓冲区，将初始空白帧呈现到屏幕，确保后续绘制节奏正常
    eglSwapBuffers(eglThreadState->getDisplay(), m_eglSurface);

    // 全部初始化成功，标记 success 为 true
    *success = true;
}

void PLSWorkerImpl::destroy(DrawableThreadState *threadState)
{
    m_plsRenderer.reset();
    m_renderTarget.reset();
    EGLWorkerImpl::destroy(threadState);
}

// 清空当前渲染目标，为下一帧绘制做准备
void PLSWorkerImpl::clear(DrawableThreadState *threadState) const
{
    // 获取当前线程的 PLS 状态，确保使用正确的渲染上下文
    PLSThreadState *plsThreadState = PLSWorkerImpl::PlsThreadState(threadState);
    // 取出 GPU 渲染上下文，用于提交清空命令
    rive::gpu::RenderContext *renderContext = plsThreadState->renderContext();
    // 开始新帧，指定渲染目标尺寸、加载动作为清空，并设置清空颜色为白色（0xFFFFFFFF）
    renderContext->beginFrame({
        .renderTargetWidth = m_renderTarget->width(),
        .renderTargetHeight = m_renderTarget->height(),
        .loadAction = rive::gpu::LoadAction::clear,
        .clearColor = 0xFFFFFFFF,
    });
}

// 将当前帧的渲染命令提交到 GPU，完成 PLS（Pixel Local Storage）管线的 flush 操作
void PLSWorkerImpl::flush(DrawableThreadState *threadState) const
{
    // 获取当前线程的 PLS 状态对象，确保上下文正确
    PLSThreadState *plsThreadState = PLSWorkerImpl::PlsThreadState(threadState);
    // 取出与当前线程绑定的 Rive GPU 渲染上下文
    rive::gpu::RenderContext *renderContext = plsThreadState->renderContext();
    // 向 GPU 提交渲染命令，使用已构建的帧缓冲区渲染目标
    renderContext->flush({.renderTarget = m_renderTarget.get()});
}

rive::Renderer *PLSWorkerImpl::renderer() const
{
    return m_plsRenderer.get();
}

/* CanvasWorkerImpl */
void CanvasWorkerImpl::destroy(DrawableThreadState *)
{
    OH_Drawing_CanvasDestroy(cScreenCanvas_);
    cScreenCanvas_ = nullptr;
    m_canvasRenderer->UnlockAndPost();
    m_canvasRenderer.reset();

    OH_Drawing_BitmapDestroy(cScreenBitmap_);
    cScreenBitmap_ = nullptr;

    OH_NativeWindow_DestroyNativeWindow(m_nativeWindow);
    m_nativeWindow = nullptr;
}

void CanvasWorkerImpl::getDrawingCanvas()
{
    OH_NativeWindow_NativeWindowHandleOpt(m_nativeWindow, GET_BUFFER_GEOMETRY, &height_, &width_);
    if (width_ <= 0 || height_ <= 0) {
        LOGE("Invalid window dimensions: %{public}d, %{public}d", width_, height_);
        return;
    }

    cScreenBitmap_ = OH_Drawing_BitmapCreate();
    if (!cScreenBitmap_) {
        LOGE("fail to create bitmap");
        return;
    }
    OH_Drawing_BitmapFormat cFormat{colorType, alphaType};
    OH_Drawing_BitmapBuild(cScreenBitmap_, width_, height_, &cFormat);
    cScreenCanvas_ = OH_Drawing_CanvasCreate();
    if (!cScreenCanvas_) {
        LOGE("fail to create canvas");
        return;
    }
    OH_Drawing_CanvasBind(cScreenCanvas_, cScreenBitmap_);
}

void CanvasWorkerImpl::prepareForDraw(DrawableThreadState *) const
{
    if (!cScreenCanvas_) {
        return;
    }

    // 若窗口尺寸发生变化，重新将画布绑定到渲染器，确保绘制区域正确
    if (m_canvasRenderer->Width() != width_ || m_canvasRenderer->Height() != height_) {
        m_canvasRenderer->BindCanvas(cScreenCanvas_);
    } else {
        // 尺寸未变，仅清空画布背景为白色（0xFFFFFFFF），准备新一帧绘制
        OH_Drawing_CanvasClear(cScreenCanvas_, 0xFFFFFFFF);
    }
}

bool CanvasWorkerImpl::requestAndPrepareBuffer(NativeWindowBuffer **outBuffer,
                                               int *outFenceFd,
                                               BufferHandle **outBufferHandle,
                                               uint32_t **outMappedAddr) const
{
    int fenceFd = 0;
    int ret = OH_NativeWindow_NativeWindowRequestBuffer(m_nativeWindow, outBuffer, &fenceFd);
    if (ret != 0 || *outBuffer == nullptr) {
        LOGE("flush: request buffer failed");
        return false;
    }

    *outBufferHandle = OH_NativeWindow_GetBufferHandleFromNative(*outBuffer);
    if (!*outBufferHandle) {
        return false;
    }

    *outMappedAddr = static_cast<uint32_t *>(
        mmap(nullptr, (*outBufferHandle)->size, PROT_READ | PROT_WRITE, MAP_SHARED, (*outBufferHandle)->fd, 0));
    if (*outMappedAddr == MAP_FAILED) {
        LOGE("flush: mmap failed");
        return false;
    }

    *outFenceFd = fenceFd;
    return true;
}

bool CanvasWorkerImpl::getBitmapData(void **outBitmapAddr,
                                     int32_t *outBitmapWidth,
                                     int32_t *outBitmapHeight,
                                     int32_t *outBitmapStrideBytes) const
{
    void *bitmapAddr = OH_Drawing_BitmapGetPixels(cScreenBitmap_);
    if (!bitmapAddr) {
        LOGE("flush: get bitmap pixels failed");
        return false;
    }

    int32_t bitmapWidth = OH_Drawing_BitmapGetWidth(cScreenBitmap_);
    int32_t bitmapHeight = OH_Drawing_BitmapGetHeight(cScreenBitmap_);
    if (bitmapWidth <= 0 || bitmapHeight <= 0) {
        LOGE("flush: invalid bitmap dimensions");
        return false;
    }

    *outBitmapAddr = bitmapAddr;
    *outBitmapWidth = bitmapWidth;
    *outBitmapHeight = bitmapHeight;
    *outBitmapStrideBytes = bitmapWidth * NUM_FOUR;
    return true;
}

void CanvasWorkerImpl::flush(DrawableThreadState *) const
{
    if (!cScreenCanvas_ || !m_nativeWindow || !m_canvasRenderer || !cScreenBitmap_) {
        return;
    }

    NativeWindowBuffer *buffer = nullptr;
    int fenceFd = 0;
    BufferHandle *bufferHandle = nullptr;
    uint32_t *mappedAddr = nullptr;
    if (!requestAndPrepareBuffer(&buffer, &fenceFd, &bufferHandle, &mappedAddr)) {
        return;
    }

    void *bitmapAddr = nullptr;
    int32_t bitmapWidth = 0;
    int32_t bitmapHeight = 0;
    int32_t bitmapStrideBytes = 0;
    if (!getBitmapData(&bitmapAddr, &bitmapWidth, &bitmapHeight, &bitmapStrideBytes)) {
        munmap(mappedAddr, bufferHandle->size);
        return;
    }
    int32_t windowWidth = 0;
    int32_t windowHeight = 0;
    OH_NativeWindow_NativeWindowHandleOpt(m_nativeWindow, GET_BUFFER_GEOMETRY, &windowHeight, &windowWidth);
    int32_t windowStrideBytes = bufferHandle->stride;

    uint8_t *srcPixels = static_cast<uint8_t *>(bitmapAddr);
    uint8_t *dstPixels = reinterpret_cast<uint8_t *>(mappedAddr);
    for (int32_t y = 0; y < bitmapHeight && y < windowHeight; ++y) {
        uint8_t *srcRow = srcPixels + y * bitmapStrideBytes;
        uint8_t *dstRow = dstPixels + y * windowStrideBytes;

        int32_t copyWidthBytes = std::min(bitmapWidth, windowWidth) * 4;
        std::copy(srcRow, srcRow + copyWidthBytes, dstRow);
    }

    Region region{nullptr, 0};
    OH_NativeWindow_NativeWindowFlushBuffer(m_nativeWindow, buffer, fenceFd, region);

    munmap(mappedAddr, bufferHandle->size);
}
} // namespace ohos_rive
