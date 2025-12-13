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

#include <vector>

#include "../../include/helpers/exception_handler.h"
#include "../../include/helpers/factories.h"
#include "../../include/helpers/resource.h"
#include "../../include/helpers/thread_state_pls.h"
#include "../../include/helpers/worker_ref.h"

#include "helpers/canvas_render_objects.h"
#include "helpers/image_decode.h"
#include "rive/math/math_types.hpp"
#include "rive/renderer/gl/render_buffer_gl_impl.hpp"
#include "rive/renderer/gl/render_context_gl_impl.hpp"
#include "rive/renderer/rive_render_factory.hpp"
#include "rive/renderer/rive_render_image.hpp"

using namespace rive;
using namespace rive::gpu;

namespace ohos_rive {
template <>
rive::rcp<rive::RenderImage> decode(rive::Span<const uint8_t> data, RendererType rendererType)
{
    rive::Factory *factory = GetFactory(rendererType);
    return factory->decodeImage(data);
}

template <>
rive::rcp<rive::Font> decode(rive::Span<const uint8_t> data, RendererType rendererType)
{
    rive::Factory *factory = GetFactory(rendererType);
    return factory->decodeFont(data);
}

template <>
rive::rcp<rive::AudioSource> decode(rive::Span<const uint8_t> data, RendererType rendererType)
{
    rive::Factory *factory = GetFactory(rendererType);
    return factory->decodeAudio(data);
}

class PLSRenderBuffer : public RenderBufferGLImpl {
public:
    PLSRenderBuffer(RenderBufferType type, RenderBufferFlags flags, size_t sizeInBytes)
        : RenderBufferGLImpl(type, flags, sizeInBytes), m_glWorker(RefWorker::RiveWorker())
    {
        if (std::this_thread::get_id() != m_glWorker->ThreadID()) {
            // We aren't on the GL thread. Init this object on the GL thread.
            // Keep this class alive until the worker thread finishes
            // initializing it.
            rcp<PLSRenderBuffer> thisRef = ref_rcp(this);
            m_bufferCreationWorkID = m_glWorker->Run([thisRef](DrawableThreadState *threadState) {
                auto plsState = reinterpret_cast<PLSThreadState *>(threadState);
                auto *renderContextImpl = plsState->renderContext()->static_impl_cast<RenderContextGLImpl>();
                thisRef->init(ref_rcp(renderContextImpl->state()));
            });
        } else {
            auto plsState = reinterpret_cast<PLSThreadState *>(m_glWorker->GetThreadState());
            auto *renderContextImpl = plsState->renderContext()->static_impl_cast<RenderContextGLImpl>();
            init(ref_rcp(renderContextImpl->state()));
            m_bufferCreationWorkID = WorkerThread::kWorkIDAlwaysFinished;
        }
    }

    ~PLSRenderBuffer() override
    {
        if (std::this_thread::get_id() != m_glWorker->ThreadID()) {
            // Ensure we are done initializing the buffers before we turn around
            // and delete them.
            m_glWorker->WaitUntilComplete(m_bufferCreationWorkID);
            // We aren't on the GL thread. Intercept the buffers before
            // ~RenderBufferGLImpl(), and then marshal them off to the GL thread
            // for deletion.
            auto bufferToDelete = detachBuffer();
            rcp<GLState> glState = ref_rcp(state());
            m_glWorker->Run([bufferToDelete, glState](DrawableThreadState *) {
                if (bufferToDelete != 0) {
                    glState->deleteBuffer(bufferToDelete);
                }
            });
        }
    }

    void *onMap() override
    {
        if (std::this_thread::get_id() != m_glWorker->ThreadID()) {
            // We aren't on the GL thread. Allocate a side buffer to fill.
            if (m_offThreadBufferDataMirror != nullptr) {
                LOGE("m_offThreadBufferDataMirror is nullptr");
                return nullptr;
            }
            m_offThreadBufferDataMirror.reset(new uint8_t[sizeInBytes()]);
            return m_offThreadBufferDataMirror.get();
        } else {
            return RenderBufferGLImpl::onMap();
        }
    }

    void onUnmap() override
    {
        if (std::this_thread::get_id() != m_glWorker->ThreadID()) {
            // We aren't on the GL thread. Marshal our side buffer to the GL
            // thread to update the buffer.
            const uint8_t *sideBufferData = m_offThreadBufferDataMirror.release();
            if (sideBufferData == nullptr) {
                LOGE("sideBufferData is nullptr");
                return;
            }
            // Keep this class alive until the worker thread finishes updating
            // the buffer.
            rcp<PLSRenderBuffer> thisRef = ref_rcp(this);
            m_glWorker->Run([sideBufferData, thisRef](DrawableThreadState *) {
                void *ptr = thisRef->RenderBufferGLImpl::onMap();
                if (ptr && sideBufferData) {
                    auto *dst = static_cast<uint8_t *>(ptr);
                    std::copy(sideBufferData, sideBufferData + thisRef->sizeInBytes(), dst);
                }
                thisRef->RenderBufferGLImpl::onUnmap();
                delete[] sideBufferData;
            });
        } else {
            if (m_offThreadBufferDataMirror) {
                LOGE("m_offThreadBufferDataMirror is not nullptr");
                return;
            }
            RenderBufferGLImpl::onUnmap();
        }
    }

protected:
    const rcp<RefWorker> m_glWorker;
    std::unique_ptr<uint8_t[]> m_offThreadBufferDataMirror;
    RefWorker::WorkID m_bufferCreationWorkID;
};

OhosImage::OhosImage(int width, int height, std::unique_ptr<const uint8_t[]> imageDataRGBAPtr)
    : RiveRenderImage(width, height), m_glWorker(ohos_rive::RefWorker::RiveWorker())
{
    // Create the texture on the worker thread where the GL context is
    // current.
    const uint8_t *imageDataRGBA = imageDataRGBAPtr.release();
    m_textureCreationWorkID = m_glWorker->Run([this, imageDataRGBA](ohos_rive::DrawableThreadState *threadState) {
        auto plsState = reinterpret_cast<ohos_rive::PLSThreadState *>(threadState);
        uint32_t mipLevelCount = math::msb(m_Height | m_Width);
        auto *renderContextImpl = plsState->renderContext()->static_impl_cast<RenderContextGLImpl>();
        resetTexture(renderContextImpl->makeImageTexture(m_Width, m_Height, mipLevelCount, imageDataRGBA));
        delete[] imageDataRGBA;
    });
}

OhosImage::~OhosImage()
{
    // Ensure we are done initializing the texture before we turn around and
    // delete it.
    m_glWorker->WaitUntilComplete(m_textureCreationWorkID);
    // Since this is the destructor, we know nobody else is using this
    // object anymore and there is not a race condition from accessing the
    // texture from any thread.
    Texture *texture = releaseTexture();
    if (texture != nullptr) {
        // Delete the texture on the worker thread where the GL context is
        // current.
        m_glWorker->Run([texture](ohos_rive::DrawableThreadState *) { texture->unref(); });
    }
}

rcp<RenderBuffer> OhosRiveRenderFactory::makeRenderBuffer(RenderBufferType type,
                                                          RenderBufferFlags flags,
                                                          size_t sizeInBytes)
{
    m_isMesh = true;
    return make_rcp<PLSRenderBuffer>(type, flags, sizeInBytes);
}

rcp<RenderImage> OhosRiveRenderFactory::decodeImage(Span<const uint8_t> encodedBytes)
{
    return renderImageFromNapiDecode(this->env, encodedBytes, false);
}

rive::rcp<rive::RenderBuffer> OhosCanvasFactory::makeRenderBuffer(rive::RenderBufferType type,
                                                                  rive::RenderBufferFlags flags,
                                                                  size_t sizeInBytes)
{
    return rive::make_rcp<rive::DataRenderBuffer>(type, flags, sizeInBytes);
}

rive::rcp<rive::RenderImage> OhosCanvasFactory::decodeImage(rive::Span<const uint8_t> encodedBytes)
{
    return make_rcp<CanvasRenderImage>(encodedBytes);
}

rive::rcp<rive::RenderShader> OhosCanvasFactory::makeLinearGradient(float sx,
                                                                    float sy,
                                                                    float ex,
                                                                    float ey,
                                                                    const rive::ColorInt colors[],
                                                                    const float stops[],
                                                                    size_t count)
{
    LinearData position = {sx, sy, ex, ey};
    return rive::rcp<rive::RenderShader>(new LinearGradientCanvasShader(position, colors, stops, count));
}

rive::rcp<rive::RenderShader> OhosCanvasFactory::makeRadialGradient(float cx,
                                                                    float cy,
                                                                    float radius,
                                                                    const rive::ColorInt colors[],
                                                                    const float stops[],
                                                                    size_t count)
{
    RadialData position = {cx, cy, radius};
    return rive::rcp<rive::RenderShader>(new RadialGradientCanvasShader(position, colors, stops, count));
}

rive::rcp<rive::RenderPath> OhosCanvasFactory::makeRenderPath(rive::RawPath &rawPath, rive::FillRule fillRule)
{
    return rive::make_rcp<CanvasRenderPath>(rawPath, fillRule);
}

rive::rcp<rive::RenderPath> OhosCanvasFactory::makeEmptyRenderPath()
{
    return rive::make_rcp<CanvasRenderPath>();
}

rive::rcp<rive::RenderPaint> OhosCanvasFactory::makeRenderPaint()
{
    return rive::make_rcp<CanvasRenderPaint>();
}
} // namespace ohos_rive
