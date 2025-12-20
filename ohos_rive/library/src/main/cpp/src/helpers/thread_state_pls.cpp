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

#include "../../include/helpers/thread_state_pls.h"
#include <cassert>

namespace ohos_rive {
PLSThreadState::PLSThreadState()
{
    LOGI("PLSThreadState constructor called");

    // Create a 1x1 Pbuffer surface that we can use to guarantee m_context is
    // always current on this thread.
    const EGLint PbufferAttrs[] = {
        EGL_WIDTH, 1, EGL_HEIGHT, 1, EGL_NONE,
    };
    m_backgroundSurface = eglCreatePbufferSurface(m_display, m_config, PbufferAttrs);
    EGL_ERR_CHECK();
    if (m_backgroundSurface == EGL_NO_SURFACE) {
        LOGE("Failed to create a 1x1 background Pbuffer surface for PLS");
        return;
    }

    LOGI("Successfully created background Pbuffer surface");

    EGLBoolean result = eglMakeCurrent(m_display, m_backgroundSurface, m_backgroundSurface, m_context);
    if (result == EGL_FALSE) {
        LOGE("Failed to make background surface current");
        return;
    }
    m_currentSurface = m_backgroundSurface;

    m_renderContext = rive::gpu::RenderContextGLImpl::MakeContext();
    if (m_renderContext == nullptr) {
        LOGE("Failed to create PLS render context");
    } else {
        LOGI("Successfully created PLS render context");
    }
}

PLSThreadState::~PLSThreadState()
{
    LOGI("PLSThreadState destructor called");

    if (m_currentSurface != m_backgroundSurface) {
        LOGE("Current surface is not background surface in destructor, switching back");
        makeCurrent(m_backgroundSurface);
    }

    if (m_currentSurface != m_backgroundSurface) {
        LOGE("Failed to switch to background surface, current surface may not be valid");
        return;
    }

    m_renderContext.reset();
    LOGI("PLS render context released");

    if (m_backgroundSurface != EGL_NO_SURFACE) {
        eglDestroySurface(m_display, m_backgroundSurface);
        EGL_ERR_CHECK();
        m_backgroundSurface = EGL_NO_SURFACE;
        LOGI("Background surface destroyed");
    }
}

void PLSThreadState::destroySurface(EGLSurface eglSurface)
{
    if (eglSurface == EGL_NO_SURFACE) {
        LOGE("Attempted to destroy EGL_NO_SURFACE");
        return;
    }

    if (eglSurface == m_backgroundSurface) {
        LOGE("Cannot destroy background surface");
        return;
    }

    LOGI("Destroying EGL surface: %p", eglSurface);

    if (m_currentSurface == eglSurface) {
        LOGI("Surface to destroy is current, switching to background surface");
        // Make sure m_context always stays current.
        makeCurrent(m_backgroundSurface);
    }

    eglDestroySurface(m_display, eglSurface);
    EGL_ERR_CHECK();

    LOGI("EGL surface destroyed successfully");
}

void PLSThreadState::makeCurrent(EGLSurface eglSurface)
{
    if (eglSurface == m_currentSurface) {
        LOGI("Surface %{public}p is already current", eglSurface);
        return;
    }

    if (eglSurface == EGL_NO_SURFACE) {
        LOGE("Cannot make EGL_NO_SURFACE current");
        return;
    }

    LOGI("Making surface current: %{public}p -> %{public}p", m_currentSurface, eglSurface);

    EGLBoolean result = eglMakeCurrent(m_display, eglSurface, eglSurface, m_context);
    if (result == EGL_FALSE) {
        LOGE("Failed to make surface current: %{public}p", eglSurface);
        return;
    }

    m_currentSurface = eglSurface;
    EGL_ERR_CHECK();

    LOGI("Successfully made surface current: %{public}p", eglSurface);
}
} // namespace ohos_rive
