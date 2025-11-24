#include "mediaextractor.h"
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
#include "mediaextractor.h"
#include "ohos/ohos_log.h"

MediaExtractor::MediaExtractor(const napi_env &env) : NapiObject(env), demuxer_(nullptr)
{
    std::lock_guard<std::mutex> lock(mutex_);
    demuxer_ = std::make_unique<Demuxer>();
}

int32_t MediaExtractor::GetTrackCount()
{
    std::lock_guard<std::mutex> lock(mutex_);
    if (demuxer_ == nullptr) {
        LOGE("getTrackCount failed, demuxer not init");
        return 0;
    }
    return demuxer_->GetTrackCount();
}

MediaFormat *MediaExtractor::GetTrackFormat(int32_t trackId)
{
    std::lock_guard<std::mutex> lock(mutex_);
    if (demuxer_ == nullptr) {
        LOGE("getTrackCount failed, demuxer not init");
        return nullptr;
    }
    return new MediaFormat(demuxer_->GetTrackFormat(trackId));
}

void MediaExtractor::Release()
{
    std::lock_guard<std::mutex> lock(mutex_);
    if (demuxer_) {
        demuxer_->Release();
        demuxer_.reset();
        demuxer_ = nullptr;
    }
}

void MediaExtractor::SelectTrack(const std::string &type, int32_t trackId)
{
    std::lock_guard<std::mutex> lock(mutex_);
    if (demuxer_ == nullptr) {
        LOGE("selectTrack failed, demuxer not init");
        return;
    }
    if (type == "Audio") {
        demuxer_->SelectAudioTrack(trackId, sampleInfo_);
    } else if (type == "Video") {
        demuxer_->SelectVideoTrack(trackId, sampleInfo_);
    }
}

bool MediaExtractor::IsSupportCodec(const std::string &codec)
{
    std::lock_guard<std::mutex> lock(mutex_);
    if (demuxer_ == nullptr) {
        LOGE("seekTo failed, demuxer not init");
        return false;
    }
    std::shared_ptr<OH_AVFormat> format = demuxer_->GetTrackFormat(demuxer_->GetVideoTrackId());
    char *mime = nullptr;
    OH_AVFormat_GetStringValue(format.get(), OH_MD_KEY_CODEC_MIME, const_cast<char const **>(&mime));
    if (mime == nullptr) {
        LOGE("get mime type failed");
        return false;
    }
    std::string str(mime);
    return (str.find(codec) != str.npos);
}

void MediaExtractor::SeekTo(int32_t start, int32_t mode)
{
    std::lock_guard<std::mutex> lock(mutex_);
    int32_t ret = AVCODEC_SAMPLE_ERR_OK;
    if (demuxer_ == nullptr) {
        LOGE("seekTo failed, demuxer not init");
        return;
    }
    ret = demuxer_->Seek(start, static_cast<OH_AVSeekMode>(mode));
    CHECK_AND_RETURN_LOG(ret == AVCODEC_SAMPLE_ERR_OK, "Seek Error");
}

void MediaExtractor::Advance() {}

int32_t MediaExtractor::GetTimestamp()
{
    std::lock_guard<std::mutex> lock(mutex_);
    if (demuxer_ == nullptr) {
        LOGE("getTimesample failed, demuxer not init");
        return 0;
    }
    return demuxer_->GetTimestamp();
}

int32_t MediaExtractor::ReadSample(const std::string &type, CodecBufferInfo &codecInfo)
{
    std::lock_guard<std::mutex> lock(mutex_);
    if (demuxer_ == nullptr) {
        LOGE("ReadSample failed, demuxer not init");
        return -1;
    }
    if (type == "Video") {
        return demuxer_->ReadSample(
            demuxer_->GetVideoTrackId(), reinterpret_cast<OH_AVBuffer *>(codecInfo.buffer), codecInfo.attr);
    } else if (type == "Audio") {
        return demuxer_->ReadSample(
            demuxer_->GetAudioTrackId(), reinterpret_cast<OH_AVBuffer *>(codecInfo.buffer), codecInfo.attr);
    }
    return -1;
}

void MediaExtractor::SetMediaSource(int32_t fd, int32_t offset, int32_t size)
{
    std::lock_guard<std::mutex> lock(mutex_);
    if (demuxer_ == nullptr) {
        LOGE("setMediaSource failed, demuxer not init");
        return;
    }
    sampleInfo_.inputFd = fd;
    sampleInfo_.inputFileOffset = offset;
    sampleInfo_.inputFileSize = size;
    sampleInfo_.inputFilePath = "";
    int32_t ret = demuxer_->Create(sampleInfo_);
    if (ret != AVCODEC_SAMPLE_ERR_OK) {
        AVCODEC_SAMPLE_LOGE("Create demuxer failed");
        return;
    }
    AVCODEC_SAMPLE_LOGD("Create demuxer success");
}

void MediaExtractor::SetMediaUrl(const std::string &url)
{
    std::lock_guard<std::mutex> lock(mutex_);
    if (demuxer_ == nullptr) {
        LOGE("setMediaUrl failed, demuxer not init");
        return;
    }
    sampleInfo_.inputFilePath = url;
    int32_t ret = demuxer_->Create(sampleInfo_);
    if (ret != AVCODEC_SAMPLE_ERR_OK) {
        AVCODEC_SAMPLE_LOGE("Create demuxer failed");
        return;
    }
    AVCODEC_SAMPLE_LOGD("Create demuxer success");
}

int32_t MediaExtractor::GetTrackIndex(const std::string &type)
{
    std::lock_guard<std::mutex> lock(mutex_);
    if (demuxer_ == nullptr) {
        LOGE("getTrackIndex failed, demuxer not init");
        return -1;
    }
    if (type == "Audio") {
        return demuxer_->GetAudioTrackId();
    } else if (type == "Video") {
        return demuxer_->GetVideoTrackId();
    }
    return -1;
}

MediaExtractor::~MediaExtractor()
{
    Release();
}
