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

#include <algorithm>
#include <thread>
#include <vector>

#include "../../include/helpers/thread_state_egl.h"
namespace ohos_rive {
constexpr size_t ARG_NUM_EIGHT = 8;
static bool config_has_attribute(EGLDisplay display, EGLConfig config, EGLint attribute, EGLint value)
{
    EGLint outValue = 0;
    EGLBoolean result = eglGetConfigAttrib(display, config, attribute, &outValue);
    EGL_ERR_CHECK();
    return result && (outValue == value);
}

static bool InitializeDisplay(EGLDisplay &display)
{
    display = eglGetDisplay(EGL_DEFAULT_DISPLAY);
    if (display == EGL_NO_DISPLAY) {
        EGL_ERR_CHECK();
        LOGE("eglGetDisplay() failed.");
        return false;
    }
    LOGI("EGL display obtained successfully");

    EGLint majorVersion;
    EGLint minorVersion;
    if (!eglInitialize(display, &majorVersion, &minorVersion)) {
        EGL_ERR_CHECK();
        LOGE("eglInitialize() failed.");
        return false;
    }
    LOGI("EGL initialized successfully, version: %{public}d.%{public}d", majorVersion, minorVersion);
    return true;
}

static const EGLint configAttributes[] = {EGL_RENDERABLE_TYPE,
                                          EGL_OPENGL_ES3_BIT, // 支持 ES 3.0
                                          EGL_SURFACE_TYPE,    EGL_WINDOW_BIT, EGL_RED_SIZE,   ARG_NUM_EIGHT,
                                          EGL_GREEN_SIZE,      ARG_NUM_EIGHT,  EGL_BLUE_SIZE,  ARG_NUM_EIGHT,
                                          EGL_ALPHA_SIZE,      ARG_NUM_EIGHT,  EGL_DEPTH_SIZE, 0,
                                          EGL_STENCIL_SIZE,    ARG_NUM_EIGHT,  EGL_NONE};

static bool IsConfigMatching(EGLDisplay display, EGLConfig cfg)
{
    if (!config_has_attribute(display, cfg, EGL_RED_SIZE, ARG_NUM_EIGHT)) {
        return false;
    }
    if (!config_has_attribute(display, cfg, EGL_GREEN_SIZE, ARG_NUM_EIGHT)) {
        return false;
    }
    if (!config_has_attribute(display, cfg, EGL_BLUE_SIZE, ARG_NUM_EIGHT)) {
        return false;
    }
    if (!config_has_attribute(display, cfg, EGL_STENCIL_SIZE, ARG_NUM_EIGHT)) {
        return false;
    }
    return config_has_attribute(display, cfg, EGL_DEPTH_SIZE, 0);
}

static bool GetAvailableConfigs(EGLDisplay display, std::vector<EGLConfig> &configs)
{
    EGLint num_configs = 0;
    if (!eglChooseConfig(display, configAttributes, nullptr, 0, &num_configs)) {
        EGL_ERR_CHECK();
        LOGE("eglChooseConfig() didn't find any configs");
        return false;
    }
    LOGI("Found %{public}d EGL configs", num_configs);

    if (num_configs == 0) {
        LOGE("No EGL configs found");
        return false;
    }

    configs.resize(num_configs);
    if (!eglChooseConfig(display, configAttributes, configs.data(), num_configs, &num_configs)) {
        EGL_ERR_CHECK();
        LOGE("eglChooseConfig() failed to retrieve configs");
        return false;
    }
    configs.resize(num_configs);
    return true;
}

static bool ChooseEGLConfig(EGLDisplay display, EGLConfig &config)
{
    std::vector<EGLConfig> supportedConfigs;
    if (!GetAvailableConfigs(display, supportedConfigs)) {
        return false;
    }

    const auto configIter = std::find_if(supportedConfigs.cbegin(), supportedConfigs.cend(),
                                         [display](EGLConfig cfg) { return IsConfigMatching(display, cfg); });

    config = (configIter != supportedConfigs.cend()) ? *configIter : supportedConfigs[0];
    LOGI("EGL config selected: %p", config);
    return true;
}

static bool CreateEGLContext(EGLDisplay display, EGLConfig config, EGLContext &context)
{
    const EGLint contextAttributes[] = {EGL_CONTEXT_CLIENT_VERSION, 3, EGL_NONE};

    context = eglCreateContext(display, config, nullptr, contextAttributes);
    if (context == EGL_NO_CONTEXT) {
        LOGE("eglCreateContext() failed.");
        EGL_ERR_CHECK();
        return false;
    }
    LOGI("EGL context created successfully: %{public}p", context);
    return true;
}

EGLThreadState::EGLThreadState()
{
    LOGI("EGLThreadState constructor called");

    if (!InitializeDisplay(m_display)) {
        return;
    }

    if (!ChooseEGLConfig(m_display, m_config)) {
        return;
    }

    CreateEGLContext(m_display, m_config, m_context);
}

EGLThreadState::~EGLThreadState()
{
    LOGI("EGLThreadState destructor called");

    if (m_context != EGL_NO_CONTEXT) {
        LOGI("Destroying EGL context");
        eglDestroyContext(m_display, m_context);
        EGL_ERR_CHECK();
        m_context = EGL_NO_CONTEXT;
    }

    LOGI("Releasing EGL thread");
    eglReleaseThread();
    EGL_ERR_CHECK();

    if (m_display != EGL_NO_DISPLAY) {
        LOGI("Terminating EGL display");
        eglTerminate(m_display);
        EGL_ERR_CHECK();
        m_display = EGL_NO_DISPLAY;
    }

    LOGI("EGLThreadState destroyed successfully");
}

EGLSurface EGLThreadState::createEGLSurface(EGLNativeWindowType window)
{
    if (!window) {
        return EGL_NO_SURFACE;
    }

    EGLSurface surface = eglCreateWindowSurface(m_display, m_config, window, nullptr);
    return surface;
}

void EGLThreadState::SwapBuffers()
{
    if (m_currentSurface != EGL_NO_SURFACE && m_display != EGL_NO_DISPLAY) {
        eglSwapBuffers(m_display, m_currentSurface);
    }
}

void EGLThreadState::makeCurrent(EGLSurface surface)
{
    if (surface == EGL_NO_SURFACE) {
        LOGE("makeCurrent: Invalid surface");
        return;
    }

    EGLBoolean result = eglMakeCurrent(m_display, surface, surface, m_context);
    if (result == EGL_FALSE) {
        LOGE("eglMakeCurrent failed");
        EGL_ERR_CHECK();
    } else {
        m_currentSurface = surface;
        LOGD("Surface made current: %p", surface);
    }
}
} // namespace ohos_rive
