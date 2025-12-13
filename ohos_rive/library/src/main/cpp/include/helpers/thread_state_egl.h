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

#ifndef OHOS_RIVE_THREAD_STATE_EGL_H
#define OHOS_RIVE_THREAD_STATE_EGL_H

#include "general.h"
#include "napi/native_api.h"
#include <arkui/native_node_napi.h>
#include <EGL/egl.h>
#include <GLES3/gl3.h>
#include <native_window/external_window.h>

namespace ohos_rive {
class DrawableThreadState {
public:
    virtual ~DrawableThreadState() {};
    virtual void SwapBuffers() = 0;
};

class EGLThreadState : public DrawableThreadState {
public:
    EGLThreadState();

    ~EGLThreadState() override = 0;

    EGLSurface createEGLSurface(EGLNativeWindowType window);

    virtual void destroySurface(EGLSurface) = 0;

    virtual void makeCurrent(EGLSurface) = 0;

    void SwapBuffers() override;

    // 获取EGL状态的方法
    EGLDisplay getDisplay() const
    {
        return m_display;
    }
    EGLConfig getConfig() const
    {
        return m_config;
    }
    EGLContext getContext() const
    {
        return m_context;
    }
    EGLSurface getCurrentSurface() const
    {
        return m_currentSurface;
    }

protected:
    EGLSurface m_currentSurface = EGL_NO_SURFACE;
    EGLDisplay m_display = EGL_NO_DISPLAY;
    EGLContext m_context = EGL_NO_CONTEXT;
    EGLConfig m_config = nullptr;
};

class CanvasThreadState : public DrawableThreadState {
public:
    void SwapBuffers() override {}
};
} // namespace ohos_rive

#endif // OHOS_RIVE_THREAD_STATE_EGL_H
