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

#ifndef VIDEO_CODEC_EXTRACTOR_H
#define VIDEO_CODEC_EXTRACTOR_H
#include <bits/alltypes.h>
#include <mutex>
#include <memory>
#include <atomic>
#include <thread>
#include <unistd.h>
#include <fstream>
#include "multimedia/player_framework/native_avbuffer.h"
#include "demuxer.h"
#include "sample_info.h"
#include "mediaformat.h"

class MediaExtractor {
public:
    MediaExtractor();
    ~MediaExtractor();
    void setMediaSource(int32_t fd, int32_t offset, int32_t size);
    void setMediaUrl(const std::string &url);

    int32_t getTrackCount();
    MediaFormat *getTrackFormat(int32_t trackId);
    void selectTrack(const std::string &type, int32_t trackId);
    int32_t getTrackIndex(const std::string &type);
    bool isSupportCodec(const std::string &codec);
    void seekTo(int32_t start, int32_t type);
    void advance();
    int32_t getTimestamp();
    void release();
    // readSampleData : (id : number) = > ArrayBuffer;

    SampleInfo &getSampleInfo()
    {
        return sampleInfo_;
    }

    int32_t ReadSample(const std::string &type, CodecBufferInfo &codecInfo);

private:
    std::unique_ptr<Demuxer> demuxer_ = nullptr;
    SampleInfo sampleInfo_;
    std::mutex mutex_;
};
#endif