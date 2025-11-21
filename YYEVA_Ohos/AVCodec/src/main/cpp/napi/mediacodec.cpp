#include "mediacodec.h"
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
#include "mediacodec.h"
#include "mediaextractor.h"
#include <native_window/external_window.h>

constexpr int BALANCE_VALUE = 5;
using namespace std::string_literals;
using namespace std::chrono_literals;
static const int MS_TO_S = 1000;
constexpr int64_t WAIT_TIME_US_THRESHOLD_WARNING = -1 * 40 * 1000; // warning threshold 40ms
constexpr int64_t WAIT_TIME_US_THRESHOLD = 1 * 1000 * 1000;        // max sleep time 1s
constexpr int64_t SINK_TIME_US_THRESHOLD = 100000;                 // max sink time 100ms
constexpr int32_t BYTES_PER_SAMPLE_2 = 2;                          // 2 bytes per sample
constexpr double VSYNC_TIME = 1000 / 60;                           // frame time
constexpr double LIP_SYNC_BALANCE_VALUE = 2;                       // the balance value of sync sound and picture
constexpr int8_t YUV420_SAMPLE_RATIO = 2;
constexpr int32_t TRIPLE_SPEED_MULTIPLIER = 3;
constexpr int32_t DOUBLE_SPEED_MULTIPLIER = 2;
constexpr int64_t MICROSECOND_TO_S = 1000000;
constexpr int64_t NANO_TO_S = 1000000000;

MediaCodec::MediaCodec() {}

MediaCodec::~MediaCodec()
{
    StartRelease();
}

int32_t MediaCodec::CreateAudioDecoder(const SampleInfo &sampleInfo)
{
    AVCODEC_SAMPLE_LOGW("audio mime:%{public}s", sampleInfo.audioCodecMime.c_str());
    int32_t ret = audioDecoder_->Create(sampleInfo.audioCodecMime);
    if (ret != AVCODEC_SAMPLE_ERR_OK) {
        AVCODEC_SAMPLE_LOGE("Create audio decoder failed, mime:%{public}s", sampleInfo_.audioCodecMime.c_str());
    } else {
        audioDecContext_ = new CodecUserData;
        ret = audioDecoder_->Config(sampleInfo, audioDecContext_);
        CHECK_AND_RETURN_RET_LOG(ret == AVCODEC_SAMPLE_ERR_OK, ret, "Audio Decoder config failed");
        OH_AudioStreamBuilder_Create(&builder_, AUDIOSTREAM_TYPE_RENDERER);
        OH_AudioStreamBuilder_SetLatencyMode(builder_, AUDIOSTREAM_LATENCY_MODE_NORMAL);
        // 设置音频采样率
        OH_AudioStreamBuilder_SetSamplingRate(builder_, sampleInfo_.audioSampleRate);
        // 设置音频声道
        OH_AudioStreamBuilder_SetChannelCount(builder_, sampleInfo_.audioChannelCount);
        // 设置音频采样格式
        OH_AudioStreamBuilder_SetSampleFormat(builder_, AUDIOSTREAM_SAMPLE_S16LE);
        // 设置音频流的编码类型
        OH_AudioStreamBuilder_SetEncodingType(builder_, AUDIOSTREAM_ENCODING_TYPE_RAW);
        // 设置输出音频流的工作场景
        OH_AudioStreamBuilder_SetRendererInfo(builder_, AUDIOSTREAM_USAGE_MOVIE);
        AVCODEC_SAMPLE_LOGW("Init audioSampleRate: %{public}d, ChannelCount: %{public}d", sampleInfo_.audioSampleRate,
            sampleInfo_.audioChannelCount);
        OH_AudioRenderer_Callbacks callbacks;
        // 配置回调函数
#ifndef DEBUG_DECODE
        callbacks.OH_AudioRenderer_OnWriteData = SampleCallback::OnRenderWriteData;
#else
        callbacks.OH_AudioRenderer_OnWriteData = nullptr;
#endif
        callbacks.OH_AudioRenderer_OnStreamEvent = SampleCallback::OnRenderStreamEvent;
        callbacks.OH_AudioRenderer_OnInterruptEvent = SampleCallback::OnRenderInterruptEvent;
        callbacks.OH_AudioRenderer_OnError = SampleCallback::OnRenderError;
        // 设置输出音频流的回调
        OH_AudioStreamBuilder_SetRendererCallback(builder_, callbacks, audioDecContext_);
        OH_AudioStreamBuilder_GenerateRenderer(builder_, &audioRenderer_);
    }
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t MediaCodec::CreateVideoDecoder(const SampleInfo &sampleInfo)
{
    AVCODEC_SAMPLE_LOGW("video mime:%{public}s", sampleInfo.videoCodecMime.c_str());
    int32_t ret = videoDecoder_->Create(sampleInfo.videoCodecMime, sampleInfo.codecType);
    if (ret != AVCODEC_SAMPLE_ERR_OK) {
        AVCODEC_SAMPLE_LOGW("Create video decoder failed, mime:%{public}s", sampleInfo_.videoCodecMime.c_str());
    } else {
        videoDecContext_ = new CodecUserData;
        videoDecContext_->isDecFirstFrame = true;
    }
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t MediaCodec::Init(SampleInfo &sampleInfo)
{
    if (isReleased_ == false) {
        return AVCODEC_SAMPLE_ERR_OK;
    }
    do {
        if (isStarted_) {
            OnStatusOccured(AVCODEC_SAMPLE_ERR_ERROR);
            return AVCODEC_SAMPLE_ERR_ERROR;
        }
    } while (0);

    sampleInfo_ = sampleInfo;
    sampleInfo_.codecRunMode = BUFFER;
    sampleInfo_.codecType = VIDEO_HW_DECODER;
    sampleInfo_.pixelFormat = AV_PIXEL_FORMAT_NV12; // AV_PIXEL_FORMAT_YUVI420;
    videoDecoder_ = std::make_unique<VideoDecoder>();
    videoDecInputThread_ = std::make_shared<ThreadHandler>("VideoDecInput");
    videoDecOutputThread_ = std::make_shared<ThreadHandler>("VideoDecOutput");

    int32_t ret;
    if (sampleInfo.audioCodecMime != "") {
        audioDecoder_ = std::make_unique<AudioDecoder>();
        audioDecInputThread_ = std::make_shared<ThreadHandler>("AudioDecInput");
        audioDecOutputThread_ = std::make_shared<ThreadHandler>("AudioDecOutput");
        ret = CreateAudioDecoder(sampleInfo_);
        if (ret != AVCODEC_SAMPLE_ERR_OK) {
            AVCODEC_SAMPLE_LOGE("Create audio decoder failed");
            OnStatusOccured(AVCODEC_SAMPLE_ERR_ERROR);
            ReleaseAudio();
            return AVCODEC_SAMPLE_ERR_ERROR;
        }
    }

    ret = CreateVideoDecoder(sampleInfo_);
    if (ret != AVCODEC_SAMPLE_ERR_OK) {
        AVCODEC_SAMPLE_LOGE("Create video decoder failed");
        OnStatusOccured(AVCODEC_SAMPLE_ERR_ERROR);
        ReleaseAudio();
        ReleaseVideo();
        return AVCODEC_SAMPLE_ERR_ERROR;
    }
    isReleased_ = false;

    if (audioDecContext_ != nullptr) {
        audioDecContext_->sampleInfo = &sampleInfo_;
    }
    ret = SetConfigure(colorFormat_, surface_);
    if (ret != AVCODEC_SAMPLE_ERR_OK) {
        AVCODEC_SAMPLE_LOGE("Set Config failed");
        OnStatusOccured(AVCODEC_SAMPLE_ERR_ERROR);
        Release();
        return AVCODEC_SAMPLE_ERR_OK;
    }
    OnStatusOccured(PLAY_INIT);

    AVCODEC_SAMPLE_LOGI("Succeed");
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t MediaCodec::StartVideoDecoder()
{
    if (videoDecContext_) {
        std::unique_lock<std::mutex> lock(videoDecContext_->inputMutex);
        EmptyQueue(videoDecContext_->inputBufferInfoQueue);
    }

    if (videoDecContext_) {
        std::unique_lock<std::mutex> lock(videoDecContext_->outputMutex);
        EmptyQueue(videoDecContext_->outputBufferInfoQueue);
    }

    videoDecInputThread_->OnWork([&]() -> int32_t {
        return VideoDecInputThread();
    });
    videoDecInputThread_->OnFinish([&]() {

    });
    videoDecInputThread_->Start();

    videoDecOutputThread_->OnWork([&]() -> int32_t {
        return VideoDecOutputThread();
    });
    videoDecOutputThread_->OnFinish([&]() {
        isStarted_ = false;

        writtenSampleCnt_ = 0;
        audioBufferPts_ = 0;
        StopVideoDecoder(false);
        if (state_ != PLAY_EOS) {
            state_ = PLAY_END;
        }
        CodeInfoAttr attr;
        attr.flags = 0;
        attr.pts = position_;
        attr.frameIndex = std::lround(position_ * sampleInfo_.frameRate / MICROSECOND_TO_S);
        OnStatusOccured(state_, attr);
    });
    videoDecOutputThread_->Start();

    int32_t ret = videoDecoder_->Start();
    if (ret != AVCODEC_SAMPLE_ERR_OK) {
        AVCODEC_SAMPLE_LOGE("Video Decoder start failed");
        return ret;
    }
    return AVCODEC_SAMPLE_ERR_OK;
}

void MediaCodec::StopVideoDecoder(bool wait)
{
    if (wait) {
        LOGD("wait video thread, %p", videoDecContext_);
        if (videoDecContext_ != nullptr) {
            videoDecContext_->inputCond.notify_all();
            videoDecContext_->outputCond.notify_all();
        }
        if (videoDecInputThread_ != nullptr) {
            videoDecInputThread_->Stop();
        }
        if (videoDecOutputThread_ != nullptr) {
            videoDecOutputThread_->Stop();
        }
    }
    LOGD("stop video");
    if (videoDecoder_) {
        videoDecoder_->Stop();
    }
}

int32_t MediaCodec::StartAudioDecoder()
{
    if (audioDecContext_) {
        std::unique_lock<std::mutex> lock(audioDecContext_->inputMutex);
        EmptyQueue(audioDecContext_->inputBufferInfoQueue);
    }

    if (audioDecContext_) {
        std::unique_lock<std::mutex> lock(audioDecContext_->outputMutex);
        EmptyQueue(audioDecContext_->outputBufferInfoQueue);
    }

    audioDecInputThread_->OnWork([&]() -> int32_t {
        return AudioDecInputThread();
    });
    audioDecInputThread_->OnFinish([&]() {});
    audioDecInputThread_->Start();

    audioDecOutputThread_->OnWork([&]() -> int32_t {
        return AudioDecOutputThread();
    });
    audioDecOutputThread_->OnFinish([&]() {
        do {
            AVCODEC_SAMPLE_LOGI("Audio Out buffer render");
            std::unique_lock<std::mutex> lockRender(audioDecContext_->renderMutex);
            audioDecContext_->renderCond.wait_for(lockRender, 500ms, [this]() {
                return audioDecContext_->renderQueue.size() < 1;
            });
        } while (0);

        StopAudioDecoder(false);
    });
    audioDecOutputThread_->Start();
    LOGD("start audio");
    if (audioRenderer_) {
        OH_AudioRenderer_Start(audioRenderer_);
    }
    int32_t ret = audioDecoder_->Start();
    if (ret != AVCODEC_SAMPLE_ERR_OK) {
        AVCODEC_SAMPLE_LOGE("Audio Decoder start failed");
        return ret;
    }

    return AVCODEC_SAMPLE_ERR_OK;
}

void MediaCodec::StopAudioDecoder(bool wait)
{
    if (wait) {
        LOGD("wait audio thread, %p", audioDecContext_);
        if (audioDecContext_ != nullptr) {
            audioDecContext_->inputCond.notify_all();
            audioDecContext_->outputCond.notify_all();
        }
        if (audioDecInputThread_ != nullptr) {
            audioDecInputThread_->Stop();
        }
        if (audioDecOutputThread_ != nullptr) {
            audioDecOutputThread_->Stop();
        }
    }
    LOGD("stop audio");

    if (audioDecoder_) {
        audioDecoder_->Stop();
    }
    if (audioRenderer_) {
        OH_AudioRenderer_Stop(audioRenderer_);
    }
}

int32_t MediaCodec::SetConfigure(int32_t colorFormat, SurfaceTexture *surface)
{
    sampleInfo_.codecRunMode = codecRunMode_;
    if (colorFormat > 0) {
        sampleInfo_.pixelFormat = static_cast<OH_AVPixelFormat>(colorFormat);
    }
    LOGD("pixelFormat: %d, surfaceId: %p", colorFormat, surface);

    if (codecRunMode_ == SURFACE) {
        if (surface == nullptr) {
            sampleInfo_.window = nullptr;
            LOGE("not bind surface");
            return -1;
        }
        if (sampleInfo_.window == surface->GetWindow()) {
            return AVCODEC_SAMPLE_ERR_OK;
        }
        sampleInfo_.window = surface->GetWindow();
    }

    LOGD("Config surface");
    int32_t ret = videoDecoder_->Config(sampleInfo_, videoDecContext_);
    if (ret != AVCODEC_SAMPLE_ERR_OK) {
        OnStatusOccured(ret);
        return ret;
    }
    return AVCODEC_SAMPLE_ERR_OK;
}

void MediaCodec::Configure(int32_t colorFormat, SurfaceTexture *surface)
{
    colorFormat_ = colorFormat;
    surface_ = surface;
    if (surface_ != nullptr) {
        codecRunMode_ = SURFACE;
    } else {
        codecRunMode_ = BUFFER;
    }
    if (isReleased_) {
        return;
    }
    int32_t ret = SetConfigure(colorFormat_, surface_);
    if (ret != AVCODEC_SAMPLE_ERR_OK) {
        AVCODEC_SAMPLE_LOGE("Set Config failed");
        OnStatusOccured(AVCODEC_SAMPLE_ERR_ERROR);
        Release();
        return;
    }
}

void MediaCodec::BindExtractor(MediaExtractor *extractor, const StatusCallback &callback)
{
    extractor_ = extractor;
    statusCallback_ = callback;
}

int32_t MediaCodec::Start()
{
    LOGD("Start");
    isMute_ = true;
    if (isStarted_ == true) {
        Stop(true);
    }
    isMute_ = false;
    if (Init(sampleInfo_) != AVCODEC_SAMPLE_ERR_OK) {
        LOGE("Init failed");
        return AVCODEC_SAMPLE_ERR_ERROR;
    }
    if (extractor_) {
        extractor_->seekTo(0, SEEK_MODE_NEXT_SYNC);
    }
    isStarted_ = true;

    int32_t ret = AVCODEC_SAMPLE_ERR_OK;

    state_ = PLAY_START;
    CodeInfoAttr attr;
    attr.flags = 0;
    attr.pts = position_;
    attr.frameIndex = std::lround(position_ * sampleInfo_.frameRate / MICROSECOND_TO_S);
    OnStatusOccured(PLAY_START, attr);

    if (videoDecContext_) {
        ret = StartVideoDecoder();
        if (ret != AVCODEC_SAMPLE_ERR_OK) {
            isStarted_ = false;
            StopVideoDecoder();
            return ret;
        }
    }

    if (audioDecContext_) {
        ret = StartAudioDecoder();
        if (ret != AVCODEC_SAMPLE_ERR_OK) {
            isStarted_ = false;
            StopAudioDecoder();
            return ret;
        }
    }

    AVCODEC_SAMPLE_LOGI("Player started successfully");

    return AVCODEC_SAMPLE_ERR_OK;
}

void MediaCodec::Stop(bool inner)
{
    LOGD("Stop");
    isStarted_ = false;

    StopAudioDecoder();
    StopVideoDecoder();

    if (inner == false) {
        state_ = PLAY_END;
        OnStatusOccured(state_);
    }
}

void MediaCodec::Pause()
{
    LOGD("Pause");
    if (videoDecInputThread_ != nullptr) {
        videoDecInputThread_->Pause();
    }
    if (videoDecOutputThread_ != nullptr) {
        videoDecOutputThread_->Pause();
    }
    if (audioDecInputThread_ != nullptr) {
        audioDecInputThread_->Pause();
    }
    if (audioDecOutputThread_ != nullptr) {
        audioDecOutputThread_->Pause();
    }
    if (audioRenderer_) {
        OH_AudioRenderer_Pause(audioRenderer_);
    }

    state_ = PLAY_PAUSE;
    OnStatusOccured(PLAY_PAUSE);
}

void MediaCodec::Resume()
{
    LOGD("Resume");
    if (audioRenderer_) {
        OH_AudioRenderer_Start(audioRenderer_);
    }
    if (videoDecInputThread_ != nullptr) {
        videoDecInputThread_->Resume();
    }
    if (videoDecOutputThread_ != nullptr) {
        videoDecOutputThread_->Resume();
    }

    if (audioDecInputThread_ != nullptr) {
        audioDecInputThread_->Resume();
    }
    if (audioDecOutputThread_ != nullptr) {
        audioDecOutputThread_->Resume();
    }
}

void MediaCodec::Restart()
{
    LOGD("Restart");
    position_ = 0;
    if (extractor_) {
        extractor_->seekTo(0, SEEK_MODE_NEXT_SYNC);
    }
    Start();
}

void MediaCodec::ReleaseOutputBuffer(int32_t frameIndex)
{
    if (state_ != PLAY_ON) {
        return;
    }
}

int32_t MediaCodec::getState()
{
    return static_cast<int32_t>(state_);
}

void MediaCodec::SetSpeed(float speed)
{
    if (this->speed_ == speed) {
        AVCODEC_SAMPLE_LOGE("Same speed value");
        return;
    }
    this->speed_ = speed;
    if (audioRenderer_) {
        OH_AudioRenderer_SetSpeed(audioRenderer_, this->speed_);
    }

    if (audioDecContext_) {
        audioDecContext_->speed = this->speed_;
    }
}

void MediaCodec::SetVolum(float volume)
{
    if (audioRenderer_) {
        OH_AudioRenderer_SetVolume(audioRenderer_, volume);
    }
}

void MediaCodec::SetMute(bool mute)
{
    if (mute || volume_ == 0) {
        if (audioRenderer_) {
            OH_AudioRenderer_GetVolume(audioRenderer_, &volume_);
        }
    }
    if (mute) {
        SetVolum(0);
    } else {
        SetVolum(volume_);
    }
}

void MediaCodec::StartRelease()
{
    AVCODEC_SAMPLE_LOGI("StartRelease");
    Stop(true);
    Release();
}

void MediaCodec::ReleaseThread() {}

void MediaCodec::ReleaseAudio()
{
    if (audioDecInputThread_ != nullptr) {
        audioDecInputThread_->Stop();
        audioDecInputThread_.reset();
        audioDecInputThread_ = nullptr;
    }

    if (audioDecOutputThread_ != nullptr) {
        audioDecOutputThread_->Stop();
        audioDecOutputThread_.reset();
        audioDecOutputThread_ = nullptr;
    }
    if (audioRenderer_ != nullptr) {
        OH_AudioRenderer_Release(audioRenderer_);
        audioRenderer_ = nullptr;
    }
    if (audioDecoder_ != nullptr) {
        audioDecoder_->Release();
        audioDecoder_.reset();
    }
    if (audioDecContext_ != nullptr) {
        delete audioDecContext_;
        audioDecContext_ = nullptr;
    }
    if (builder_ != nullptr) {
        OH_AudioStreamBuilder_Destroy(builder_);
        builder_ = nullptr;
    }
    // 清空队列
    while (audioDecContext_ && !audioDecContext_->renderQueue.empty()) {
        audioDecContext_->renderQueue.pop();
    }
}

void MediaCodec::ReleaseVideo()
{
    if (videoDecInputThread_ != nullptr) {
        videoDecInputThread_->Stop();
        videoDecInputThread_.reset();
        videoDecInputThread_ = nullptr;
    }
    if (videoDecOutputThread_ != nullptr) {
        videoDecOutputThread_->Stop();
        videoDecOutputThread_.reset();
        videoDecOutputThread_ = nullptr;
    }
    if (videoDecoder_ != nullptr) {
        videoDecoder_->Release();
        videoDecoder_.reset();
    }
    if (videoDecContext_ != nullptr) {
        delete videoDecContext_;
        videoDecContext_ = nullptr;
    }
}

void MediaCodec::EmptyQueue(queue<CodecBufferInfo> &codecQue)
{
    queue<CodecBufferInfo> emptyQue;
    std::swap(codecQue, emptyQue);
}

void MediaCodec::ReleaseOutputBuffer(int32_t frameIndex, bool dropFrame, int64_t timestamp)
{
    int32_t ret = videoDecoder_->FreeOutputBuffer(frameIndex, sampleInfo_.codecRunMode ? false : !dropFrame, timestamp);
    if (ret != AVCODEC_SAMPLE_ERR_OK) {
        AVCODEC_SAMPLE_LOGE("FreeOutputBuffer failed: %{public}d", ret);
        return;
    }
}

void MediaCodec::Release()
{
    isStarted_ = false;
    if (isReleased_.exchange(true, std::memory_order_acq_rel)) {
        return;
    }
    ReleaseAudio();
    ReleaseVideo();
    surface_ = nullptr;
    extractor_ = nullptr;

    // 触发回调
    // sampleInfo_.playDoneCallback(sampleInfo_.playDoneCallbackData);

    LOGD("Release");
}

void MediaCodec::DumpOutput(CodecBufferInfo &bufferInfo, int64_t timestamp)
{
    CodeInfoAttr infoAttr;
    infoAttr.flags = bufferInfo.attr.flags;
    infoAttr.pts = bufferInfo.attr.pts;
    infoAttr.frameIndex =
        std::lround(bufferInfo.attr.pts * sampleInfo_.frameRate / MICROSECOND_TO_S); // bufferInfo.bufferIndex;
    infoAttr.buffer.clear();
    if (sampleInfo_.codecRunMode == BUFFER) {
        uint8_t *bufferAddr = OH_AVBuffer_GetAddr(reinterpret_cast<OH_AVBuffer *>(bufferInfo.buffer));
        CHECK_AND_RETURN_LOG(bufferAddr != nullptr, "Buffer is nullptr");

        infoAttr.buffer.reserve(bufferInfo.attr.size);
        infoAttr.buffer.assign(bufferAddr, bufferAddr + bufferInfo.attr.size);
        infoAttr.ops.width = videoDecContext_->width;
        infoAttr.ops.height = videoDecContext_->height;
        infoAttr.ops.pixelFormat = sampleInfo_.pixelFormat;
        infoAttr.ops.alphaType = 0;
    }

    LOGD("buffer size: %d -> %d", bufferInfo.attr.size, infoAttr.buffer.size());

    OnStatusOccured(state_, infoAttr);
}

void MediaCodec::WriteOutputFileWithStrideYUV420P(
    uint8_t *bufferAddr, std::vector<uint8_t> &buffer, OhosPixelMapCreateOps &ops)
{
    CHECK_AND_RETURN_LOG(bufferAddr != nullptr, "Buffer is nullptr");
    auto &info = sampleInfo_;
    int32_t videoWidth = videoDecContext_->width *
        ((info.videoCodecMime == OH_AVCODEC_MIMETYPE_VIDEO_HEVC && info.hevcProfile == HEVC_PROFILE_MAIN_10) ? 2 : 1);
    int32_t &stride = videoDecContext_->widthStride;
    int32_t uvWidth = videoWidth / YUV420_SAMPLE_RATIO;
    int32_t uvStride = stride / YUV420_SAMPLE_RATIO;

    ops.width = videoWidth;
    ops.height = videoDecContext_->height;
    ops.pixelFormat = AV_PIXEL_FORMAT_YUVI420;
    ops.alphaType = 0;

    LOGD("YUV420P: width: %d, height: %d, heightStride: %d, widthStride: %d", videoDecContext_->width,
        videoDecContext_->height, videoDecContext_->heightStride, videoDecContext_->widthStride);

    // copy Y
    for (int32_t row = 0; row < videoDecContext_->height; row++) {
        buffer.insert(buffer.end(), reinterpret_cast<uint8_t *>(bufferAddr), bufferAddr + videoWidth);
        bufferAddr += stride;
    }
    bufferAddr += (videoDecContext_->heightStride - videoDecContext_->height) * stride;

    // copy U
    for (int32_t row = 0; row < (videoDecContext_->height / YUV420_SAMPLE_RATIO); row++) {
        buffer.insert(buffer.end(), reinterpret_cast<uint8_t *>(bufferAddr), bufferAddr + uvWidth);
        bufferAddr += uvStride;
    }
    bufferAddr += (videoDecContext_->heightStride - videoDecContext_->height) / YUV420_SAMPLE_RATIO * uvStride;
    // copy V
    for (int32_t row = 0; row < (videoDecContext_->height / YUV420_SAMPLE_RATIO); row++) {
        buffer.insert(buffer.end(), reinterpret_cast<uint8_t *>(bufferAddr), bufferAddr + uvWidth);
        bufferAddr += uvStride;
    }
}

void MediaCodec::WriteOutputFileWithStrideYUV420SP(
    uint8_t *bufferAddr, std::vector<uint8_t> &buffer, OhosPixelMapCreateOps &ops)
{
    CHECK_AND_RETURN_LOG(bufferAddr != nullptr, "Buffer is nullptr");
    auto &info = sampleInfo_;
    int bytesPerPixel =
        ((info.videoCodecMime == OH_AVCODEC_MIMETYPE_VIDEO_HEVC && info.hevcProfile == HEVC_PROFILE_MAIN_10) ? 2 : 1);

    int32_t videoWidth = videoDecContext_->width * bytesPerPixel;
    int32_t &stride = videoDecContext_->widthStride;
    int32_t uvWidth = videoWidth / YUV420_SAMPLE_RATIO;
    int32_t uvStride = stride / YUV420_SAMPLE_RATIO;

    ops.width = videoWidth;
    ops.height = videoDecContext_->height;
    ops.pixelFormat = AV_PIXEL_FORMAT_NV21;
    ops.alphaType = 0;

    int32_t totalYSize = videoDecContext_->heightStride * stride;
    int32_t totalUVSize = (videoDecContext_->heightStride / 2) * uvStride;
    int32_t totalFrameSize = totalYSize + totalUVSize;
    LOGD("YUV420SP: width: %d, height: %d, heightStride: %d, widthStride: %d, total: %d", videoDecContext_->width,
        videoDecContext_->height, videoDecContext_->heightStride, videoDecContext_->widthStride, totalFrameSize);

    // copy Y
    for (int32_t row = 0; row < videoDecContext_->height; row++) {
        buffer.insert(buffer.end(), reinterpret_cast<uint8_t *>(bufferAddr), bufferAddr + videoWidth);
        bufferAddr += stride;
    }
    bufferAddr += (videoDecContext_->heightStride - videoDecContext_->height) * stride;

    // copy U
    for (int32_t row = 0; row < (videoDecContext_->height / YUV420_SAMPLE_RATIO); row++) {
        buffer.insert(buffer.end(), reinterpret_cast<uint8_t *>(bufferAddr), bufferAddr + uvWidth);
        bufferAddr += uvStride;
    }
    bufferAddr += (videoDecContext_->heightStride - videoDecContext_->height) / YUV420_SAMPLE_RATIO * uvStride;
    // copy V
    for (int32_t row = 0; row < (videoDecContext_->height / YUV420_SAMPLE_RATIO); row++) {
        buffer.insert(buffer.end(), reinterpret_cast<uint8_t *>(bufferAddr), bufferAddr + uvWidth);
        bufferAddr += uvStride;
    }
}

void MediaCodec::WriteOutputFileWithStrideRGBA(
    uint8_t *bufferAddr, std::vector<uint8_t> &buffer, OhosPixelMapCreateOps &ops)
{
    CHECK_AND_RETURN_LOG(bufferAddr != nullptr, "Buffer is nullptr");
    auto &info = sampleInfo_;
    int32_t width = videoDecContext_->width *
        ((info.videoCodecMime == OH_AVCODEC_MIMETYPE_VIDEO_HEVC && info.hevcProfile == HEVC_PROFILE_MAIN_10) ? 2 : 1);
    int32_t &stride = videoDecContext_->widthStride;
    LOGD("RGBA: width: %d, height: %d, heightStride: %d, widthStride: %d", videoDecContext_->width,
        videoDecContext_->height, videoDecContext_->heightStride, videoDecContext_->widthStride);

    for (int32_t row = 0; row < videoDecContext_->heightStride; row++) {
        buffer.insert(
            buffer.end(), reinterpret_cast<uint8_t *>(bufferAddr), bufferAddr + width * 4); // 4: RGBA 4 channels
        bufferAddr += stride;
    }
}

int64_t MediaCodec::GetCurrentTime()
{
    auto now = std::chrono::steady_clock::now();
    auto now_ns = std::chrono::time_point_cast<std::chrono::nanoseconds>(now);
    return now_ns.time_since_epoch().count();
}

int32_t MediaCodec::VideoDecInputThread()
{
    if (isStarted_ == false) {
        return -1;
    }

    std::unique_lock<std::mutex> lock(videoDecContext_->inputMutex);
    bool condRet = videoDecContext_->inputCond.wait_for(lock, 5s, [this]() {
        if (videoDecContext_->inputBufferInfoQueue.empty()) {}
        bool ret = !isStarted_ || !videoDecContext_->inputBufferInfoQueue.empty();
        return ret;
    });
    if (videoDecContext_->inputBufferInfoQueue.empty()) {
        return 0;
    }

    CodecBufferInfo bufferInfo = videoDecContext_->inputBufferInfoQueue.front();
    videoDecContext_->inputBufferInfoQueue.pop();
    videoDecContext_->inputFrameCount++;
    lock.unlock();
    if (extractor_ == nullptr) {
        LOGE("not bind MediaExtractor");
        return -1;
    }
    int32_t ret = extractor_->ReadSample("Video", bufferInfo);
    CHECK_AND_RETURN_RET_LOGE(ret == AVCODEC_SAMPLE_ERR_OK, 0, "Video ReadSample failed, %{public}d", ret);

    ret = videoDecoder_->PushInputBuffer(bufferInfo);

    CHECK_AND_RETURN_RET_LOGE(ret == AVCODEC_SAMPLE_ERR_OK, -1, "Push data failed, thread out");
    CHECK_AND_RETURN_RET_LOGI(
        !(bufferInfo.attr.flags & AVCODEC_BUFFER_FLAGS_EOS), -1, "Catch EOS, video in thread out");
    return 0;
}

bool MediaCodec::ProcessVideoWithoutAudio(
    CodecBufferInfo &bufferInfo, std::chrono::time_point<std::chrono::system_clock> &lastPushTime)
{
    DumpOutput(bufferInfo, GetCurrentTime());

    ReleaseOutputBuffer(bufferInfo.bufferIndex, false, GetCurrentTime());
    this->speed_ == 1 ? sampleInfo_.frameInterval = MICROSECOND_TO_S / sampleInfo_.frameRate :
        this->speed_ == DOUBLE_SPEED_MULTIPLIER ?
                        sampleInfo_.frameInterval = MICROSECOND_TO_S / sampleInfo_.frameRate / DOUBLE_SPEED_MULTIPLIER :
                        sampleInfo_.frameInterval = MICROSECOND_TO_S / sampleInfo_.frameRate / TRIPLE_SPEED_MULTIPLIER;
    std::this_thread::sleep_until(lastPushTime + std::chrono::microseconds(sampleInfo_.frameInterval));
    lastPushTime = std::chrono::system_clock::now();

    return true;
}
bool MediaCodec::CalculateSyncParameters(CodecBufferInfo &bufferInfo, int64_t framePosition, int64_t &waitTimeUs,
    bool &dropFrame, int64_t perSinkTimeThreshold)
{
    // after seek, audio render flush, framePosition = 0, then writtenSampleCnt = 0
    int64_t latency =
        (audioDecContext_->frameWrittenForSpeed - framePosition) * 1000 * 1000 / sampleInfo_.audioSampleRate / speed_;
    AVCODEC_SAMPLE_LOGI("VD latency: %{public}li writtenSampleCnt: %{public}li", latency, writtenSampleCnt_);

    nowTimeStamp_ = GetCurrentTime();
    int64_t anchorDiff = (nowTimeStamp_ - audioTimeStamp_) / 1000;

    // us, audio buffer accelerate render time
    int64_t audioPlayedTime = audioDecContext_->currentPosAudioBufferPts - latency + anchorDiff;
    // us, video buffer expected render time
    int64_t videoPlayedTime = bufferInfo.attr.pts;
    position_ = videoPlayedTime;

    // audio render timestamp and now timestamp diff
    waitTimeUs = videoPlayedTime - audioPlayedTime; // us

    AVCODEC_SAMPLE_LOGI("VD bufferInfo.bufferIndex: %{public}li", bufferInfo.bufferIndex);
    AVCODEC_SAMPLE_LOGI("VD audioPlayedTime: %{public}li, videoPlayedTime: %{public}li, nowTimeStamp_:%{public}ld, "
                        "audioTimeStamp_ :%{public}ld, waitTimeUs :%{public}ld, anchordiff :%{public}ld",
        audioPlayedTime, videoPlayedTime, nowTimeStamp_, audioTimeStamp_, waitTimeUs, anchorDiff);
    dropFrame = false;
    // video buffer is too late, drop it
    if (waitTimeUs < WAIT_TIME_US_THRESHOLD_WARNING) {
        dropFrame = true;
        AVCODEC_SAMPLE_LOGI("VD buffer is too late");
    } else {
        // AVCODEC_SAMPLE_LOGE("VD buffer is too early waitTimeUs:%{public}ld", waitTimeUs);
        // [0, ), render it wait waitTimeUs, max 1s
        // [-40, 0), render it
        if (waitTimeUs > WAIT_TIME_US_THRESHOLD) {
            waitTimeUs = WAIT_TIME_US_THRESHOLD;
        }
        // per frame render time reduced by frame interval
        if (waitTimeUs > sampleInfo_.frameInterval + perSinkTimeThreshold) {
            waitTimeUs = sampleInfo_.frameInterval + perSinkTimeThreshold;
            AVCODEC_SAMPLE_LOGE("VD buffer is too early and reduced, waitTimeUs: %{public}ld", waitTimeUs);
        }
    }
    return true;
}
bool MediaCodec::RenderAndRelease(CodecBufferInfo &bufferInfo, int64_t waitTimeUs, bool dropFrame)
{
    if (static_cast<double>(waitTimeUs) > VSYNC_TIME * LIP_SYNC_BALANCE_VALUE) {
        std::this_thread::sleep_for(std::chrono::microseconds(
            static_cast<int64_t>(static_cast<double>(waitTimeUs) - VSYNC_TIME * LIP_SYNC_BALANCE_VALUE)));
    }
    DumpOutput(bufferInfo, GetCurrentTime());
    ReleaseOutputBuffer(
        bufferInfo.bufferIndex, dropFrame, VSYNC_TIME * LIP_SYNC_BALANCE_VALUE * MS_TO_S + GetCurrentTime());
    return true;
}
bool MediaCodec::ProcessVideoWithAudio(CodecBufferInfo &bufferInfo,
    std::chrono::time_point<std::chrono::system_clock> &lastPushTime, int64_t perSinkTimeThreshold)
{
    // get audio render position
    int64_t framePosition = 0;
    int64_t timestamp = 0;
    int32_t ret = OH_AudioRenderer_GetTimestamp(audioRenderer_, CLOCK_MONOTONIC, &framePosition, &timestamp);
    AVCODEC_SAMPLE_LOGI("VD framePosition: %{public}li, nowTimeStamp: %{public}li", framePosition, nowTimeStamp_);
    audioTimeStamp_ = timestamp; // ns

    // audio render getTimeStamp error, render it
    if (ret != AUDIOSTREAM_SUCCESS || (timestamp == 0) || (framePosition == 0)) {

        // first frame, render without wait
        ret = videoDecoder_->FreeOutputBuffer(
            bufferInfo.bufferIndex, sampleInfo_.codecRunMode ? false : true, GetCurrentTime());
        if (ret != AVCODEC_SAMPLE_ERR_OK) {
            AVCODEC_SAMPLE_LOGW("FreeOutputBuffer failed: %{public}d", ret);
            return false;
        }
        std::this_thread::sleep_until(lastPushTime + std::chrono::microseconds(sampleInfo_.frameInterval));
        lastPushTime = std::chrono::system_clock::now();
        return true;
    }
    int64_t waitTimeUs = 0;
    bool dropFrame = false;

    if (!CalculateSyncParameters(bufferInfo, framePosition, waitTimeUs, dropFrame, perSinkTimeThreshold)) {
        return false;
    }

    return RenderAndRelease(bufferInfo, waitTimeUs, dropFrame);
}

int32_t MediaCodec::VideoDecOutputThread()
{
    sampleInfo_.frameInterval = MICROSECOND_TO_S / sampleInfo_.frameRate;
    int64_t perSinkTimeThreshold = MS_TO_S / sampleInfo_.frameRate * MS_TO_S; // max per sink time

    state_ = PLAY_ON;
    thread_local auto lastPushTime = std::chrono::system_clock::now();
    CHECK_AND_RETURN_RET_LOGI(isStarted_, -1, "VD Decoder output thread out");
    std::unique_lock<std::mutex> lock(videoDecContext_->outputMutex);
    bool condRet = videoDecContext_->outputCond.wait_for(lock, 5s, [this]() {
        return !isStarted_ || !videoDecContext_->outputBufferInfoQueue.empty();
    });
    CHECK_AND_RETURN_RET_LOGI(isStarted_, -1, "VD Decoder output thread out");
    CHECK_AND_RETURN_RET_LOGI(!videoDecContext_->outputBufferInfoQueue.empty(), 0,
        "Buffer queue is empty, continue, cond ret: %{public}d", condRet);
    CodecBufferInfo bufferInfo = videoDecContext_->outputBufferInfoQueue.front();
    position_ = bufferInfo.attr.pts;
    videoDecContext_->outputBufferInfoQueue.pop();

    videoDecContext_->outputFrameCount++;
    AVCODEC_SAMPLE_LOGW("Video Out buffer count: %{public}u, frameIndex: %{public}d, size: %{public}d, flag: "
                        "%{public}u, pts: %{public}" PRId64,
        videoDecContext_->outputFrameCount, bufferInfo.bufferIndex, bufferInfo.attr.size, bufferInfo.attr.flags,
        bufferInfo.attr.pts);
    if (bufferInfo.attr.flags & AVCODEC_BUFFER_FLAGS_EOS) {
        state_ = PLAY_EOS;
        return -1;
    }

    lock.unlock();
    bool success = false;
    if (!audioDecContext_) {
        success = ProcessVideoWithoutAudio(bufferInfo, lastPushTime);
    } else {
        success = ProcessVideoWithAudio(bufferInfo, lastPushTime, perSinkTimeThreshold);
    }
    if (!success) {
        return -1;
    }
    return 0;
}

int32_t MediaCodec::AudioDecInputThread()
{
    CHECK_AND_RETURN_RET_LOGI(isStarted_, -1, "Decoder input thread out");
    std::unique_lock<std::mutex> lock(audioDecContext_->inputMutex);
    bool condRet = audioDecContext_->inputCond.wait_for(lock, 5s, [this]() {
        return !isStarted_ || !audioDecContext_->inputBufferInfoQueue.empty();
    });
    CHECK_AND_RETURN_RET_LOGI(isStarted_, -1, "Work done, thread out");
    CHECK_AND_RETURN_RET_LOGI(!audioDecContext_->inputBufferInfoQueue.empty(), 0,
        "Buffer queue is empty, continue, cond ret: %{public}d", condRet);

    CodecBufferInfo bufferInfo = audioDecContext_->inputBufferInfoQueue.front();
    audioDecContext_->inputBufferInfoQueue.pop();
    audioDecContext_->inputFrameCount++;
    lock.unlock();
    if (extractor_ == nullptr) {
        LOGE("MediaExtractor not bind");
        return -1;
    }
    int32_t ret = extractor_->ReadSample("Audio", bufferInfo);
    CHECK_AND_RETURN_RET_LOGE(ret == AVCODEC_SAMPLE_ERR_OK, 0, "Audio ReadSample failed, %{public}d", ret);

    ret = audioDecoder_->PushInputBuffer(bufferInfo);
    CHECK_AND_RETURN_RET_LOGE(ret == AVCODEC_SAMPLE_ERR_OK, -1, "Push data failed, thread out");

    CHECK_AND_RETURN_RET_LOGI(!(bufferInfo.attr.flags & AVCODEC_BUFFER_FLAGS_EOS), -1, "AudioIn Catch EOS, thread out");
    return 0;
}

bool MediaCodec::ProcessAudioOutput(CodecBufferInfo &bufferInfo)
{
    int32_t ret = audioDecoder_->FreeOutputBuffer(bufferInfo.bufferIndex, true);
    if (ret != AVCODEC_SAMPLE_ERR_OK) {
        AVCODEC_SAMPLE_LOGW("FreeOutputBuffer failed: %{public}d", ret);
        return false;
    }

    //    SAMPLE_S16LE 2 bytes per frame
    writtenSampleCnt_ += (bufferInfo.attr.size / sampleInfo_.audioChannelCount / BYTES_PER_SAMPLE_2);
    AVCODEC_SAMPLE_LOGI("writtenSampleCnt_: %{public}ld, bufferInfo.attr.size: %{public}d, "
                        "sampleInfo_.audioChannelCount: %{public}d",
        writtenSampleCnt_, bufferInfo.attr.size, sampleInfo_.audioChannelCount);

    audioBufferPts_ = bufferInfo.attr.pts;
    audioDecContext_->endPosAudioBufferPts = audioBufferPts_;

    std::unique_lock<std::mutex> lockRender(audioDecContext_->renderMutex);
    audioDecContext_->renderCond.wait_for(lockRender, 20ms, [this, bufferInfo]() {
        return audioDecContext_->renderQueue.size() < BALANCE_VALUE * bufferInfo.attr.size;
    });

    return true;
}

int32_t MediaCodec::AudioDecOutputThread()
{
    CHECK_AND_RETURN_RET_LOGI(isStarted_, -1, "Decoder output thread out");
    std::unique_lock<std::mutex> lock(audioDecContext_->outputMutex);
    bool condRet = audioDecContext_->outputCond.wait_for(lock, 5s, [this]() {
        return !isStarted_ || !audioDecContext_->outputBufferInfoQueue.empty();
    });
    CHECK_AND_RETURN_RET_LOGI(isStarted_, -1, "Decoder output thread out");
    CHECK_AND_RETURN_RET_LOGI(!audioDecContext_->outputBufferInfoQueue.empty(), 0,
        "Buffer queue is empty, continue, cond ret: %{public}d", condRet);

    CodecBufferInfo bufferInfo = audioDecContext_->outputBufferInfoQueue.front();
    audioDecContext_->outputBufferInfoQueue.pop();
    CHECK_AND_RETURN_RET_LOGI(!(bufferInfo.attr.flags & AVCODEC_BUFFER_FLAGS_EOS), -1, "Catch EOS, thread out");

    audioDecContext_->outputFrameCount++;
    AVCODEC_SAMPLE_LOGW("Audio Out buffer count: %{public}u, frameIndex: %{public}d, size: %{public}d, flag: "
                        "%{public}u, pts: %{public}" PRId64,
        audioDecContext_->outputFrameCount, bufferInfo.bufferIndex, bufferInfo.attr.size, bufferInfo.attr.flags,
        bufferInfo.attr.pts);

    uint8_t *source = OH_AVBuffer_GetAddr(reinterpret_cast<OH_AVBuffer *>(bufferInfo.buffer));
    CHECK_AND_RETURN_RET_LOGE(source != nullptr, -1, "AVBuffer GetAddr is nullptr");
    for (int i = 0; i < bufferInfo.attr.size; i++) {
        audioDecContext_->renderQueue.push(*(source + i));
    }

    lock.unlock();
    if (!ProcessAudioOutput(bufferInfo)) {
        return -1;
    }
    return 0;
}

void MediaCodec::OnStatusOccured(int32_t status, const CodeInfoAttr &codecInfo)
{
    if (isMute_) {
        return;
    }
    LOGD("OnStatus: %d", status);
    if (statusCallback_ != nullptr) {
        statusCallback_(status, codecInfo);
    }
}

void MediaCodec::Flush()
{
    if (videoDecoder_) {
        videoDecoder_->Flush();
    }
    if (audioDecoder_) {
        audioDecoder_->Flush();
    }
    if (audioRenderer_) {
        OH_AudioRenderer_Flush(audioRenderer_);
    }
}
