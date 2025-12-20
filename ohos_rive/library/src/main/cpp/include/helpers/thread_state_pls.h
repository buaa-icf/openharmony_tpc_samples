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

#pragma once
#ifndef OHOS_RIVE_THREAD_STATE_PLS_H
#define OHOS_RIVE_THREAD_STATE_PLS_H

#include <memory>
// clang-format off
// Put #include "thread_state_egl.h" before #include "rive/renderer/gl/render_context_gl_impl.hpp".
// Otherwise, compilation errors will occur.
#include "thread_state_egl.h"
#include "rive/renderer/gl/render_context_gl_impl.hpp"
// clang-format on

namespace ohos_rive {
class PLSThreadState : public EGLThreadState {
public:
    PLSThreadState();
    ~PLSThreadState() override;

    rive::gpu::RenderContext *renderContext() const
    {
        return m_renderContext.get();
    }

    void destroySurface(EGLSurface eglSurface) override;

    void makeCurrent(EGLSurface eglSurface) override;

private:
    std::unique_ptr<rive::gpu::RenderContext> m_renderContext;

    // 1x1 Pbuffer surface that allows us to make the GL context current without
    // a window surface.
    EGLSurface m_backgroundSurface;
};
} // namespace ohos_rive

#endif // OHOS_RIVE_THREAD_STATE_PLS_H

