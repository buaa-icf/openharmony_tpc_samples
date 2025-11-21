/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
#include "ohos_utils/napi_handler.h"
#include "ohos_utils/ohos_log.h"
#include <stdbool.h>
#include <stdio.h>
#include <string>
#include "mediaextractor.h"
#include "mediacodec.h"
#include "surface_texture.h"

namespace mediacodec {
struct MediaSource {
    int32_t fd;
    int32_t offset;
    int32_t size;
};

static napi_ref mediaFormatRef_ = nullptr;

static MediaSource ParseMediaSource(napi_env env, const napi_value &obj)
{
    NapiHandler napiHandler(env);
    MediaSource result;
    result.fd = napiHandler.GetObjectProp<int32_t>(obj, "fd");
    result.offset = napiHandler.GetObjectProp<int32_t>(obj, "offset");
    result.size = napiHandler.GetObjectProp<int32_t>(obj, "length");
    return result;
}
static napi_value SerializeMediaSource(napi_env env, const MediaSource &data)
{
    NapiHandler napiHandler(env);
    napi_value result = napiHandler.CreateObject();
    napiHandler.SetObjectProp<int32_t>(result, "fd", data.fd);
    napiHandler.SetObjectProp<int32_t>(result, "offset", data.offset);
    napiHandler.SetObjectProp<int32_t>(result, "length", data.size);
    return result;
}

/**
 * MediaFormat
 */
static napi_value getString(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_1);
    MediaFormat *format = napiHandler.UnbindObject<MediaFormat>();

    if (format == nullptr) {
        LOGE("Unbind format is nullptr");
        return nullptr;
    }
    std::string key = napiHandler.ParseArgAs<std::string>(INDEX_0);

    // 功能实现
    std::string result = format->getString(key);

    return napiHandler.GetNapiValue<std::string>(result);
}

static napi_value getInteger(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_1);
    MediaFormat *format = napiHandler.UnbindObject<MediaFormat>();

    if (format == nullptr) {
        LOGE("Unbind format is nullptr");
        return nullptr;
    }

    std::string key = napiHandler.ParseArgAs<std::string>(INDEX_0);

    // 功能实现
    int32_t result = format->getInteger(key);
    return napiHandler.GetNapiValue<int32_t>(result);
}

static napi_value setInteger(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_2);
    MediaFormat *format = napiHandler.UnbindObject<MediaFormat>();

    if (format == nullptr) {
        LOGE("Unbind format is nullptr");
        return nullptr;
    }

    std::string key = napiHandler.ParseArgAs<std::string>(INDEX_0);
    int32_t value = napiHandler.ParseArgAs<int32_t>(INDEX_1);

    // 功能实现
    format->setInteger(key, value);
    return napiHandler.GetVoidValue();
}

static napi_value getLong(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_1);

    MediaFormat *format = napiHandler.UnbindObject<MediaFormat>();

    if (format == nullptr) {
        LOGE("Unbind format is nullptr");
        return nullptr;
    }

    std::string key = napiHandler.ParseArgAs<std::string>(INDEX_0);

    // 功能实现
    int64_t result = format->getLong(key);
    return napiHandler.GetNapiValue<int64_t>(result);
}

static napi_value getFloat(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_1);
    MediaFormat *format = napiHandler.UnbindObject<MediaFormat>();

    if (format == nullptr) {
        LOGE("Unbind format is nullptr");
        return nullptr;
    }

    std::string key = napiHandler.ParseArgAs<std::string>(INDEX_0);

    // 功能实现
    float result = format->getFloat(key);
    return napiHandler.GetNapiValue<float>(result);
}

static void JsAVFormatDestructor(napi_env env, void *nativeObject, void *finalize_hint)
{
    MediaFormat *instance = static_cast<MediaFormat *>(nativeObject);
    LOGD("destructor MediaFormat");
    if (instance == nullptr) {
        return;
    }
    delete instance;
}

static napi_value JsFormatConstructor(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, 0);

    LOGD("constructor MediaFormat");
    MediaFormat *format = new MediaFormat(nullptr);
    return napiHandler.BindObject(static_cast<void *>(format), mediacodec::JsAVFormatDestructor);
}

/**
 * MediaExtractor
 */
static napi_value setMediaSource(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_1);
    MediaExtractor *mediaExtractor = napiHandler.UnbindObject<MediaExtractor>();

    if (mediaExtractor == nullptr) {
        LOGE("Unbind Extractor nullptr");
        return nullptr;
    }

    MediaSource mediaSource = napiHandler.ParseArgAs<MediaSource>(INDEX_0, [&](const napi_value &obj) -> MediaSource {
        return ParseMediaSource(env, obj);
    });

    mediaExtractor->setMediaSource(mediaSource.fd, mediaSource.offset, mediaSource.size);
    return napiHandler.GetVoidValue();
}

static napi_value setMediaUrl(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_1);
    MediaExtractor *mediaExtractor = napiHandler.UnbindObject<MediaExtractor>();

    if (mediaExtractor == nullptr) {
        LOGE("Unbind Extractor nullptr");
        return nullptr;
    }

    std::string url = napiHandler.ParseArgAs<std::string>(INDEX_0);

    mediaExtractor->setMediaUrl(url);
    return napiHandler.GetVoidValue();
}

static napi_value getTrackCount(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_0);
    MediaExtractor *mediaExtractor = napiHandler.UnbindObject<MediaExtractor>();

    if (mediaExtractor == nullptr) {
        LOGE("Unbind Extractor nullptr");
        return nullptr;
    }

    int32_t result = mediaExtractor->getTrackCount();
    return napiHandler.GetNapiValue<int32_t>(result);
}

static napi_value getTrackFormat(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_1);
    int32_t index = napiHandler.ParseArgAs<int32_t>(INDEX_0);

    MediaExtractor *mediaExtractor = napiHandler.UnbindObject<MediaExtractor>();

    if (mediaExtractor == nullptr) {
        LOGE("Unbind Extractor nullptr");
        return nullptr;
    }

    MediaFormat *format = mediaExtractor->getTrackFormat(index);

    napi_value constructor;
    napi_status status = napi_get_reference_value(env, mediaFormatRef_, &constructor);
    if (status != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "Failed to get constructor reference");
        return nullptr;
    }

    napi_value instance;
    status = napi_new_instance(env, constructor, 0, nullptr, &instance);
    if (status != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "Failed to create new instance");
        return nullptr;
    }
    NAPI_CALL(env, napi_wrap(env, instance, format, mediacodec::JsAVFormatDestructor, nullptr, nullptr));
    return instance;
}

static napi_value selectTrack(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_2);
    std::string type = napiHandler.ParseArgAs<std::string>(INDEX_0);
    int32_t index = napiHandler.ParseArgAs<int32_t>(INDEX_1);

    MediaExtractor *mediaExtractor = napiHandler.UnbindObject<MediaExtractor>();

    if (mediaExtractor == nullptr) {
        LOGE("Unbind Extractor nullptr");
        return nullptr;
    }

    mediaExtractor->selectTrack((char *)type.c_str(), index);
    return napiHandler.GetVoidValue();
}

static napi_value isSupportCodec(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_1);
    std::string codec = napiHandler.ParseArgAs<std::string>(INDEX_0);
    MediaExtractor *mediaExtractor = napiHandler.UnbindObject<MediaExtractor>();

    if (mediaExtractor == nullptr) {
        LOGE("Unbind Extractor nullptr");
        return nullptr;
    }

    bool result = mediaExtractor->isSupportCodec((char *)codec.c_str());
    return napiHandler.GetNapiValue<bool>(result);
}

static napi_value seekTo(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_2);
    int32_t start = napiHandler.ParseArgAs<int32_t>(INDEX_0);
    int32_t mode = napiHandler.ParseArgAs<int32_t>(INDEX_1);
    MediaExtractor *mediaExtractor = napiHandler.UnbindObject<MediaExtractor>();

    if (mediaExtractor == nullptr) {
        LOGE("Unbind Extractor nullptr");
        return nullptr;
    }

    mediaExtractor->seekTo(start, mode);
    return napiHandler.GetVoidValue();
}

static napi_value advance(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_0);
    MediaExtractor *mediaExtractor = napiHandler.UnbindObject<MediaExtractor>();

    if (mediaExtractor == nullptr) {
        LOGE("Unbind Extractor nullptr");
        return nullptr;
    }

    mediaExtractor->advance();
    return napiHandler.GetVoidValue();
}

static napi_value getSampleTime(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_0);
    MediaExtractor *mediaExtractor = napiHandler.UnbindObject<MediaExtractor>();

    if (mediaExtractor == nullptr) {
        LOGE("Unbind Extractor nullptr");
        return nullptr;
    }

    int32_t result = mediaExtractor->getTimestamp();
    return napiHandler.GetNapiValue<int32_t>(result);
}

static napi_value getTrackIndex(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_1);
    std::string type = napiHandler.ParseArgAs<std::string>(INDEX_0);

    MediaExtractor *mediaExtractor = napiHandler.UnbindObject<MediaExtractor>();

    if (mediaExtractor == nullptr) {
        LOGE("Unbind Extractor nullptr");
        return nullptr;
    }

    int32_t result = mediaExtractor->getTrackIndex(type);
    return napiHandler.GetNapiValue<int32_t>(result);
}

static napi_value release(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_0);
    MediaExtractor *mediaExtractor = napiHandler.UnbindObject<MediaExtractor>();

    if (mediaExtractor == nullptr) {
        LOGE("Unbind Extractor nullptr");
        return nullptr;
    }
    mediaExtractor->release();
    return napiHandler.GetVoidValue();
}

static void JsExtractorDestructor(napi_env env, void *nativeObject, void *finalize_hint)
{
    MediaExtractor *instance = static_cast<MediaExtractor *>(nativeObject);
    LOGD("destructor MediaExtractor");
    if (instance == nullptr) {
        return;
    }
    delete instance;
}

static napi_value JsExtractorConstructor(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_0);

    MediaExtractor *mediaExtractor = new MediaExtractor();
    LOGD("constructor MediaExtractor");
    return napiHandler.BindObject(static_cast<void *>(mediaExtractor), mediacodec::JsExtractorDestructor);
}

/**
 * MediaCodec
 */
static void JsCodecDestructor(napi_env env, void *nativeObject, void *finalize_hint)
{
    MediaCodec *instance = static_cast<MediaCodec *>(nativeObject);
    LOGD("destructor MediaCodec");
    if (instance == nullptr) {
        return;
    }
    delete instance;
}

static napi_value JsCodecConstructor(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, 1);

    LOGD("constructor MediaCodec");
    MediaCodec *codec = new MediaCodec();
    return napiHandler.BindObject(static_cast<void *>(codec), mediacodec::JsCodecDestructor);
}

static napi_value configure(napi_env env, napi_callback_info info)
{

    NapiHandler napiHandler(env, info, PARAM_COUNT_0);
    MediaCodec *mediaCodec = napiHandler.UnbindObject<MediaCodec>();

    if (mediaCodec == nullptr) {
        LOGE("Unbind MediaCodec nullptr");
        return nullptr;
    }

    int32_t colorFormat = -1;
    if (napiHandler.HasArgIndex(INDEX_0)) {
        colorFormat = napiHandler.ParseArgAs<int32_t>(INDEX_0);
    }
    SurfaceTexture *surface = nullptr;
    if (napiHandler.HasArgIndex(INDEX_1)) {
        surface = napiHandler.ParseArgAs<SurfaceTexture *>(INDEX_1, [&](const napi_value &obj) -> SurfaceTexture * {
            SurfaceTexture *t = nullptr;
            NAPI_CALL_HANDLE(env_, napi_unwrap(env, obj, reinterpret_cast<void **>(&t)), t);
            return t;
        });
    }
    mediaCodec->Configure(colorFormat, surface);
    return napiHandler.GetVoidValue();
}

static napi_value getState(napi_env env, napi_callback_info info)
{

    NapiHandler napiHandler(env, info, PARAM_COUNT_0);
    MediaCodec *mediaCodec = napiHandler.UnbindObject<MediaCodec>();

    if (mediaCodec == nullptr) {
        LOGE("Unbind MediaCodec nullptr");
        return nullptr;
    }

    int32_t state = mediaCodec->getState();
    return napiHandler.GetNapiValue<int32_t>(state);
}

static napi_value releaseOutputBuffer(napi_env env, napi_callback_info info)
{

    NapiHandler napiHandler(env, info, PARAM_COUNT_1);
    MediaCodec *mediaCodec = napiHandler.UnbindObject<MediaCodec>();

    if (mediaCodec == nullptr) {
        LOGE("Unbind MediaCodec nullptr");
        return nullptr;
    }

    int32_t frameIndex = napiHandler.ParseArgAs<int32_t>(INDEX_0);
    mediaCodec->ReleaseOutputBuffer(frameIndex);
    return napiHandler.GetVoidValue();
}

static napi_value flush(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_0);
    MediaCodec *mediaCodec = napiHandler.UnbindObject<MediaCodec>();

    if (mediaCodec == nullptr) {
        LOGE("Unbind MediaCodec nullptr");
        return nullptr;
    }
    mediaCodec->Flush();

    return napiHandler.GetVoidValue();
}

static napi_value releaseDecoder(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_0);
    MediaCodec *mediaCodec = napiHandler.UnbindObject<MediaCodec>();

    if (mediaCodec == nullptr) {
        LOGE("Unbind MediaCodec nullptr");
        return nullptr;
    }
    mediaCodec->Release();

    return napiHandler.GetVoidValue();
}

static napi_value setSpeed(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_1);
    MediaCodec *mediaCodec = napiHandler.UnbindObject<MediaCodec>();

    if (mediaCodec == nullptr) {
        LOGE("Unbind MediaCodec nullptr");
        return nullptr;
    }

    float speed = napiHandler.ParseArgAs<float>(INDEX_0);
    mediaCodec->SetSpeed(speed);

    return napiHandler.GetVoidValue();
}

static napi_value setVolume(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_1);
    MediaCodec *mediaCodec = napiHandler.UnbindObject<MediaCodec>();

    if (mediaCodec == nullptr) {
        LOGE("Unbind MediaCodec nullptr");
        return nullptr;
    }

    float volume = napiHandler.ParseArgAs<float>(INDEX_0);
    mediaCodec->SetVolum(volume);

    return napiHandler.GetVoidValue();
}

static napi_value setMute(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_1);
    MediaCodec *mediaCodec = napiHandler.UnbindObject<MediaCodec>();

    if (mediaCodec == nullptr) {
        LOGE("Unbind MediaCodec nullptr");
        return nullptr;
    }

    bool mute = napiHandler.ParseArgAs<bool>(INDEX_0);
    mediaCodec->SetMute(mute);

    return napiHandler.GetVoidValue();
}

static napi_value CreatePixelmap(napi_env env, const OhosPixelMapCreateOps &ops, const std::vector<uint8_t> &buffer)
{
    if (buffer.empty()) {
        LOGD("buffer is empty");
        return nullptr;
    }
    napi_value pixelMap;
    int32_t res = OH_PixelMap_CreatePixelMap(env, ops, (uint8_t *)buffer.data(), buffer.size(), &pixelMap);
    if (res != IMAGE_RESULT_SUCCESS || pixelMap == nullptr) {
        LOGE("create pixelmap failed, %d", res);
        return nullptr;
    }
    return pixelMap;
}

static napi_value SerializeCodeInfoAttr(napi_env env, const CodeInfoAttr &data)
{
    NapiHandler napiHandler(env);
    napi_value result = napiHandler.CreateObject();
    napiHandler.SetObjectProp<int64_t>(result, "pts", data.pts);
    napiHandler.SetObjectProp<int32_t>(result, "frameIndex", data.frameIndex);
    napiHandler.SetObjectProp<int32_t>(result, "flags", data.flags);
    napiHandler.SetObjectProp<CodeInfoAttr>(result, "image", data, [&](const CodeInfoAttr &buffer) -> napi_value {
        return CreatePixelmap(napiHandler.GetEnv(), buffer.ops, buffer.buffer);
    });
    return result;
}

static napi_value bind(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_2);
    MediaCodec *mediaCodec = napiHandler.UnbindObject<MediaCodec>();
    if (mediaCodec == nullptr) {
        LOGE("Unbind Extractor nullptr");
        return nullptr;
    }

    MediaExtractor *mediaExtractor =
        napiHandler.ParseArgAs<MediaExtractor *>(INDEX_0, [&](const napi_value &obj) -> MediaExtractor * {
            MediaExtractor *t = nullptr;
            NAPI_CALL_HANDLE(env_, napi_unwrap(env, obj, reinterpret_cast<void **>(&t)), t);
            return t;
        });
    if (mediaExtractor == nullptr) {
        LOGE("Unbind Extractor nullptr");
        return nullptr;
    }
    mediaCodec->Init(mediaExtractor->getSampleInfo());
    napi_ref statusMethodRef = napiHandler.ParseArgAs<napi_ref>(INDEX_1);
    std::shared_ptr<NapiWrapper> wrapper = std::make_shared<NapiWrapper>(env, NW_NEVER);

    mediaCodec->BindExtractor(mediaExtractor, [wrapper, statusMethodRef](int32_t status, const CodeInfoAttr &attr) {
        wrapper->BindMethod("StatusChanged", statusMethodRef);
        auto getParam = [status, codec = std::move(attr)](napi_env env, std::vector<napi_value> &params) {
            NapiHandler h(env);
            params = {h.GetNapiValue<int32_t>(status),
                h.GetNapiValue<CodeInfoAttr>(codec, [&](const CodeInfoAttr &attr) -> napi_value {
                    return SerializeCodeInfoAttr(env, attr);
                })};
        };
        NapiWrapper::JsCall(wrapper, "StatusChanged", getParam);
    });
    return napiHandler.GetVoidValue();
}

static napi_value start(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_0);
    MediaCodec *mediaCodec = napiHandler.UnbindObject<MediaCodec>();
    if (mediaCodec == nullptr) {
        LOGE("Unbind Extractor nullptr");
        return nullptr;
    }

    mediaCodec->Start();
    return napiHandler.GetVoidValue();
}

static napi_value stop(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_0);
    MediaCodec *mediaCodec = napiHandler.UnbindObject<MediaCodec>();

    if (mediaCodec == nullptr) {
        LOGE("Unbind Extractor nullptr");
        return nullptr;
    }

    mediaCodec->Stop();
    return napiHandler.GetVoidValue();
}

static napi_value restart(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_0);
    MediaCodec *mediaCodec = napiHandler.UnbindObject<MediaCodec>();

    if (mediaCodec == nullptr) {
        LOGE("Unbind Extractor nullptr");
        return nullptr;
    }

    mediaCodec->Restart();
    return napiHandler.GetVoidValue();
}

static napi_value pause(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_0);
    MediaCodec *mediaCodec = napiHandler.UnbindObject<MediaCodec>();

    if (mediaCodec == nullptr) {
        LOGE("Unbind Extractor nullptr");
        return nullptr;
    }

    mediaCodec->Pause();
    return napiHandler.GetVoidValue();
}

static napi_value resume(napi_env env, napi_callback_info info)
{

    NapiHandler napiHandler(env, info, PARAM_COUNT_0);
    MediaCodec *mediaCodec = napiHandler.UnbindObject<MediaCodec>();
    if (mediaCodec == nullptr) {
        LOGE("Unbind Extractor nullptr");
        return nullptr;
    }

    mediaCodec->Resume();
    return napiHandler.GetVoidValue();
}

// SurfaceTexture
static void JsSurfaceTextureDestructor(napi_env env, void *nativeObject, void *finalize_hint)
{
    SurfaceTexture *instance = static_cast<SurfaceTexture *>(nativeObject);
    LOGD("destructor SurfaceTexture");
    if (instance == nullptr) {
        return;
    }
    delete instance;
}

static napi_value JsSurfaceTextureConstructor(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_1);
    int64_t surfaceId = napiHandler.ParseArgAs<int64_t>(INDEX_0);

    SurfaceTexture *surfaceTexture = new SurfaceTexture(surfaceId);
    LOGD("constructor SurfaceTexture");
    return napiHandler.BindObject(static_cast<void *>(surfaceTexture), mediacodec::JsSurfaceTextureDestructor);
}

static napi_value updateTexImage(napi_env env, napi_callback_info info)
{

    NapiHandler napiHandler(env, info, PARAM_COUNT_0);
    SurfaceTexture *surface = napiHandler.UnbindObject<SurfaceTexture>();
    if (surface == nullptr) {
        LOGE("Unbind surface nullptr");
        return nullptr;
    }

    surface->UpdateTexImage();
    return napiHandler.GetVoidValue();
}

static napi_value setOnFrameAvailableListener(napi_env env, napi_callback_info info)
{

    NapiHandler napiHandler(env, info, PARAM_COUNT_1);
    SurfaceTexture *surface = napiHandler.UnbindObject<SurfaceTexture>();
    if (surface == nullptr) {
        LOGE("Unbind surface nullptr");
        return nullptr;
    }

    napi_ref updateRef = napiHandler.ParseArgAs<napi_ref>(INDEX_0);
    std::shared_ptr<NapiWrapper> wrapper = std::make_shared<NapiWrapper>(env, NW_NEVER);

    surface->SetOnFrameAvailableListener([wrapper, updateRef]() {
        wrapper->BindMethod("onFrameAvailable", updateRef);
        auto getParam = [](napi_env env, std::vector<napi_value> &params) {};
        NapiWrapper::JsCall(wrapper, "onFrameAvailable", getParam);
    });
    return napiHandler.GetVoidValue();
}

static napi_value setDefaultBufferSize(napi_env env, napi_callback_info info)
{

    NapiHandler napiHandler(env, info, PARAM_COUNT_2);
    SurfaceTexture *surface = napiHandler.UnbindObject<SurfaceTexture>();
    if (surface == nullptr) {
        LOGE("Unbind surface nullptr");
        return nullptr;
    }

    int32_t width = napiHandler.ParseArgAs<int32_t>(INDEX_0);
    int32_t height = napiHandler.ParseArgAs<int32_t>(INDEX_1);
    surface->SetDefaultBufferSize(width, height);
    return napiHandler.GetVoidValue();
}

static napi_value releaseSurface(napi_env env, napi_callback_info info)
{

    NapiHandler napiHandler(env, info, PARAM_COUNT_0);
    SurfaceTexture *surface = napiHandler.UnbindObject<SurfaceTexture>();
    if (surface == nullptr) {
        LOGE("Unbind surface nullptr");
        return nullptr;
    }
    surface->Release();
    return napiHandler.GetVoidValue();
}

} // namespace mediacodec

EXTERN_C_START
static napi_value InitMediaCodec(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        DECLARE_NAPI_FUNCTION("start", mediacodec::start),
        DECLARE_NAPI_FUNCTION("stop", mediacodec::stop),
        DECLARE_NAPI_FUNCTION("restart", mediacodec::restart),
        DECLARE_NAPI_FUNCTION("resume", mediacodec::resume),
        DECLARE_NAPI_FUNCTION("pause", mediacodec::pause),
        DECLARE_NAPI_FUNCTION("bind", mediacodec::bind),
        DECLARE_NAPI_FUNCTION("configure", mediacodec::configure),
        DECLARE_NAPI_FUNCTION("getState", mediacodec::getState),
        DECLARE_NAPI_FUNCTION("releaseOutputBuffer", mediacodec::releaseOutputBuffer),
        DECLARE_NAPI_FUNCTION("flush", mediacodec::flush),
        DECLARE_NAPI_FUNCTION("release", mediacodec::releaseDecoder),
        DECLARE_NAPI_FUNCTION("setSpeed", mediacodec::setSpeed),
        DECLARE_NAPI_FUNCTION("setVolume", mediacodec::setVolume),
        DECLARE_NAPI_FUNCTION("setMute", mediacodec::setMute),
    };

    napi_value mediaCodec = nullptr;
    std::string className = "MediaCodec";
    napi_define_class(env, className.c_str(), className.length(), mediacodec::JsCodecConstructor, nullptr,
        sizeof(desc) / sizeof(desc[0]), desc, &mediaCodec);
    napi_set_named_property(env, exports, "MediaCodec", mediaCodec);
    return exports;
}

static napi_value InitMediaFormat(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        DECLARE_NAPI_FUNCTION("getString", mediacodec::getString),
        DECLARE_NAPI_FUNCTION("getInteger", mediacodec::getInteger),
        DECLARE_NAPI_FUNCTION("getLong", mediacodec::getLong),
        DECLARE_NAPI_FUNCTION("getFloat", mediacodec::getFloat),
        DECLARE_NAPI_FUNCTION("setInteger", mediacodec::setInteger),
    };

    napi_value mediaExtractor = nullptr;
    std::string className = "MediaFormat";
    napi_define_class(env, className.c_str(), className.length(), mediacodec::JsFormatConstructor, nullptr,
        sizeof(desc) / sizeof(desc[0]), desc, &mediaExtractor);

    napi_status status = napi_create_reference(env, mediaExtractor, 1, &mediacodec::mediaFormatRef_);
    if (status != napi_ok) {
        LOGE("Failed to create MediaFormat constructor reference");
        return nullptr;
    }
    napi_set_named_property(env, exports, "MediaFormat", mediaExtractor);
    return exports;
}

static napi_value InitMediaExtractor(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {DECLARE_NAPI_FUNCTION("setMediaSource", mediacodec::setMediaSource),
        DECLARE_NAPI_FUNCTION("setMediaUrl", mediacodec::setMediaUrl),
        DECLARE_NAPI_FUNCTION("getTrackCount", mediacodec::getTrackCount),
        DECLARE_NAPI_FUNCTION("getTrackFormat", mediacodec::getTrackFormat),
        DECLARE_NAPI_FUNCTION("getTrackIndex", mediacodec::getTrackIndex),
        DECLARE_NAPI_FUNCTION("selectTrack", mediacodec::selectTrack),
        DECLARE_NAPI_FUNCTION("isSupportCodec", mediacodec::isSupportCodec),
        DECLARE_NAPI_FUNCTION("seekTo", mediacodec::seekTo), DECLARE_NAPI_FUNCTION("advance", mediacodec::advance),
        DECLARE_NAPI_FUNCTION("getSampleTime", mediacodec::getSampleTime),
        DECLARE_NAPI_FUNCTION("release", mediacodec::release)};

    napi_value mediaExtractor = nullptr;
    std::string className = "MediaExtractor";
    napi_define_class(env, className.c_str(), className.length(), mediacodec::JsExtractorConstructor, nullptr,
        sizeof(desc) / sizeof(desc[0]), desc, &mediaExtractor);
    napi_set_named_property(env, exports, "MediaExtractor", mediaExtractor);
    return exports;
}

static napi_value InitSurfaceTexture(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {DECLARE_NAPI_FUNCTION("updateTexImage", mediacodec::updateTexImage),
        DECLARE_NAPI_FUNCTION("setOnFrameAvailableListener", mediacodec::setOnFrameAvailableListener),
        DECLARE_NAPI_FUNCTION("setDefaultBufferSize", mediacodec::setDefaultBufferSize),
        DECLARE_NAPI_FUNCTION("release", mediacodec::releaseSurface)};

    napi_value surfaceTexture = nullptr;
    std::string className = "SurfaceTexture";
    napi_define_class(env, className.c_str(), className.length(), mediacodec::JsSurfaceTextureConstructor, nullptr,
        sizeof(desc) / sizeof(desc[0]), desc, &surfaceTexture);
    napi_set_named_property(env, exports, "SurfaceTexture", surfaceTexture);
    return exports;
}

static napi_value Init(napi_env env, napi_value exports)
{
    InitMediaFormat(env, exports);
    InitMediaCodec(env, exports);
    InitMediaExtractor(env, exports);
    InitSurfaceTexture(env, exports);
    return exports;
}
EXTERN_C_END

static napi_module mediaCodecModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "mediacodec",
    .nm_priv = ((void *)0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterModule(void)
{
    napi_module_register(&mediaCodecModule);
}