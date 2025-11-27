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
#include "ohos_window.h"
#include <cstdio>
#include <native_window/external_window.h>
#include <native_buffer/native_buffer.h>
#include <native_window/graphic_error_code.h>
#include <EGL/egl.h>
#include "ohos_log.h"

int ANativeWindowSetBuffersGeometry(ANativeWindow *window, int width, int height, EGLint format)
{
    OHNativeWindow *nativeWindow = static_cast<ANativeWindow *>(window);
    if (nativeWindow == nullptr) {
        return NATIVE_ERROR_NOT_INIT;
    }
    int ret = 0;

    LOGD("set Geometry: %dx%d, format: %d->%d", height, width, format, format);
    if (width > 0) {
        if ((ret = OH_NativeWindow_NativeWindowHandleOpt(nativeWindow, SET_BUFFER_GEOMETRY, width, height)) != 0) {
            LOGE("set geometry failed, %d", ret);
            return ret;
        }
    }

    if (format > 0) {
        if ((ret = OH_NativeWindow_NativeWindowHandleOpt(nativeWindow, SET_FORMAT, format)) != 0) {
            LOGE("set format failed, %d", ret);
            return ret;
        }
    }
    return ret;
}

void ANativeWindowRelease(ANativeWindow *window)
{
    LOGD("release windown: %d", window);
    OHNativeWindow *nativeWindow = static_cast<ANativeWindow *>(window);
    if (nativeWindow == nullptr) {
        return;
    }
    OH_NativeWindow_NativeObjectUnreference(nativeWindow);
}

int ANativeWindowGetWidth(ANativeWindow *window)
{
    OHNativeWindow *nativeWindow = static_cast<ANativeWindow *>(window);
    if (nativeWindow == nullptr) {
        LOGE("native window is nullptr");
        return 0;
    }
    int stride;
    int height;
    if ((OH_NativeWindow_NativeWindowHandleOpt(nativeWindow, GET_BUFFER_GEOMETRY, &height, &stride)) != 0) {
        LOGE("getWidth: %d", 0);
        return 0;
    }
    LOGD("getWidth: %d", stride);
    return stride;
}

int ANativeWindowGetHeight(ANativeWindow *window)
{
    OHNativeWindow *nativeWindow = static_cast<ANativeWindow *>(window);
    if (nativeWindow == nullptr) {
        LOGE("native window is nullptr");
        return 0;
    }
    int stride;
    int height;
    if ((OH_NativeWindow_NativeWindowHandleOpt(nativeWindow, GET_BUFFER_GEOMETRY, &height, &stride)) != 0) {
        LOGE("getHeight: %d", 0);
        return 0;
    }
    LOGD("getHeight: %d", height);
    return height;
}
