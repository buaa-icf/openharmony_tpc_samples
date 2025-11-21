#include "surface_texture.h"
#include <unordered_map>
#include <ohos_utils/ohos_log.h>
#include <native_window/external_window.h>
#include <EGL/egl.h>
#include <EGL/egl.h>
#include <EGL/eglext.h>
#include <GLES3/gl3.h>
#include <GLES2/gl2ext.h>
#include <thread>

SurfaceTexture::SurfaceTexture(int64_t surfaceId) : surfaceId_(surfaceId)
{
    //    image_ = OH_ConsumerSurface_Create();
    image_ = OH_NativeImage_Create(surfaceId, GL_TEXTURE_EXTERNAL_OES);
    if (image_ == nullptr) {
        LOGE("create native image failed, surfaceId: %d", surfaceId);
        return;
    }
    window_ = OH_NativeImage_AcquireNativeWindow(image_);
    if (window_ == nullptr) {
        LOGE("acquire native window failed, surfaceId: %d", surfaceId);
        return;
    }

    OH_OnFrameAvailableListener listener = {this, [](void *context) {
                                                SurfaceTexture *surface = static_cast<SurfaceTexture *>(context);
                                                if (surface == nullptr) {
                                                    return;
                                                }
                                                surface->OnFrameAvailable();
                                            }};
    int ret = OH_NativeImage_SetOnFrameAvailableListener(image_, listener);
    if (ret != 0) {
        LOGE("set onFrame listener failed, %d", ret);
    }
}

SurfaceTexture::~SurfaceTexture()
{
    Release();
}

void SurfaceTexture::UpdateTexImage()
{
    if (image_ != nullptr) {
        OH_NativeImage_UpdateSurfaceImage(image_);
    }
}

void SurfaceTexture::SetOnFrameAvailableListener(const std::function<void()> &onFrameAvailable)
{
    onFrameAvailable_ = onFrameAvailable;
}

void SurfaceTexture::SetDefaultBufferSize(int32_t width, int32_t height)
{
    if (window_ == nullptr) {
        LOGE("window acquire failed");
        return;
    }
    int code = SET_BUFFER_GEOMETRY;
    int32_t ret = OH_NativeWindow_NativeWindowHandleOpt(window_, code, width, height);
}

void SurfaceTexture::Release()
{
    if (image_) {
        LOGE("release native image");
        OH_NativeImage_DetachContext(image_);
        OH_NativeImage_Destroy(&image_);
        image_ = nullptr;
    }
    window_ = nullptr;
}

void SurfaceTexture::OnFrameAvailable()
{
    if (onFrameAvailable_ == nullptr) {
        return;
    }
    onFrameAvailable_();
}

OHNativeWindow *SurfaceTexture::GetWindow()
{
    return window_;
}
