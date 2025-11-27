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

#ifndef VIDEO_CODEC_CODEC_H
#define VIDEO_CODEC_CODEC_H
#include <bits/alltypes.h>
#include <mutex>
#include <memory>
#include <atomic>
#include <thread>
#include <unistd.h>
#include <functional>
#include <fstream>
#include "video_decoder.h"
#include "audio_decoder.h"
#include <napi/native_api.h>
#include <multimedia/image_framework/image_mdk_common.h>
#include <multimedia/image_framework/image_pixel_map_mdk.h>
#include <native_image/native_image.h>
#include "surface_texture.h"
#include "threadhandler.h"
#include "ohos/napi_object.h"

typedef enum { PLAY_INIT = 0, PLAY_START = 1, PLAY_ON, PLAY_PAUSE, PLAY_EOS, PLAY_END } PLAY_STATUS;

typedef struct {
    int64_t pts;
    int32_t flags;
    int32_t frameIndex;
    std::vector<uint8_t> buffer;
    OhosPixelMapCreateOps ops;
} CodeInfoAttr;
using StatusCallback = std::function<void(int32_t, const CodeInfoAttr &)>;

class MediaExtractor;
class MediaCodec : public NapiObject {
public:
    explicit MediaCodec(const napi_env &env);
    ~MediaCodec();

    int32_t CreateVideoDecoder(const SampleInfo &sampleInfo);
    int32_t CreateAudioDecoder(const SampleInfo &sampleInfo);
    int32_t StartVideoDecoder();
    int32_t StartAudioDecoder();
    int32_t Init(SampleInfo &sampleInfo);
    void Configure(int32_t colorFormat, const std::shared_ptr<SurfaceTexture> &surface);
    void BindExtractor(std::shared_ptr<MediaExtractor> extractor, const StatusCallback &callback);
    int32_t Start();
    void Stop(bool inner = false);
    void Pause();
    void Resume();
    void Restart();
    int32_t SetConfigure(int32_t colorFormat, const std::shared_ptr<SurfaceTexture> &surface);
    void ReleaseOutputBuffer(int32_t frameIndex);
    int32_t GetState();
    void Flush();
    void SetSpeed(float speed);
    void SetVolum(float volume);
    void SetMute(bool mute);
    void Release();

private:
    int32_t VideoDecInputThread();
    int32_t VideoDecOutputThread();
    bool ProcessVideoWithAudio(CodecBufferInfo &bufferInfo,
        std::chrono::time_point<std::chrono::system_clock> &lastPushTime, int64_t perSinkTimeThreshold);
    bool ProcessVideoWithoutAudio(
        CodecBufferInfo &bufferInfo, std::chrono::time_point<std::chrono::system_clock> &lastPushTime);
    bool CalculateSyncParameters(CodecBufferInfo &bufferInfo, int64_t framePosition, int64_t &waitTimeUs,
        bool &dropFrame, int64_t perSinkTimeThreshold);
    bool RenderAndRelease(CodecBufferInfo &bufferInfo, int64_t waitTimeUs, bool dropFrame);
    void DumpOutput(CodecBufferInfo &bufferInfo, int64_t timestamp);

    void StopAudioDecoder(bool wait = true);
    void StopVideoDecoder(bool wait = true);
    void ReleaseAudio();
    void ReleaseVideo();
    void EmptyQueue(queue<CodecBufferInfo> &codecQue);
    void ReleaseOutputBuffer(int32_t frameIndex, bool dropFrame, int64_t timestamp);

    int32_t AudioDecInputThread();
    int32_t AudioDecOutputThread();

    void StartRelease();
    void ReleaseThread();
    int64_t GetCurrentTime();
    bool ProcessAudioOutput(CodecBufferInfo &bufferInfo);
    void WriteOutputFileWithStrideYUV420P(
        uint8_t *bufferAddr, std::vector<uint8_t> &buffer, OhosPixelMapCreateOps &ops);
    void WriteOutputFileWithStrideYUV420SP(
        uint8_t *bufferAddr, std::vector<uint8_t> &buffer, OhosPixelMapCreateOps &ops);
    void WriteOutputFileWithStrideRGBA(uint8_t *bufferAddr, std::vector<uint8_t> &buffer, OhosPixelMapCreateOps &ops);
    void OnStatusOccured(int32_t status, const CodeInfoAttr &codecInfo = {.pts = 0, .flags = 0, .frameIndex = 0});

private:
    std::unique_ptr<VideoDecoder> videoDecoder_ = nullptr;
    std::shared_ptr<AudioDecoder> audioDecoder_ = nullptr;
    CodecUserData *videoDecContext_ = nullptr;
    CodecUserData *audioDecContext_ = nullptr;
    std::shared_ptr<ThreadHandler> videoDecInputThread_;
    std::shared_ptr<ThreadHandler> videoDecOutputThread_;
    std::shared_ptr<ThreadHandler> audioDecInputThread_;
    std::shared_ptr<ThreadHandler> audioDecOutputThread_;
    OH_AudioStreamBuilder *builder_ = nullptr;
    OH_AudioRenderer *audioRenderer_ = nullptr;

    std::atomic<bool> isStarted_ {false};
    std::atomic<bool> isReleased_ {true};

    bool isMute_ = false;

    float volume_ = 0;
    float speed_ = 1.0;
    int64_t nowTimeStamp_ = 0;
    int64_t audioTimeStamp_ = 0;
    int64_t writtenSampleCnt_ = 0;
    int64_t audioBufferPts_ = 0;
    int64_t position_ = 0;
    SampleInfo sampleInfo_;
    std::atomic<PLAY_STATUS> state_ {PLAY_INIT};

    int32_t colorFormat_ = AV_PIXEL_FORMAT_NV12;
    std::shared_ptr<SurfaceTexture> surface_ = nullptr;
    int32_t codecRunMode_ = BUFFER;

    std::shared_ptr<MediaExtractor> extractor_ = nullptr;
    StatusCallback statusCallback_ = nullptr;
};
#endif