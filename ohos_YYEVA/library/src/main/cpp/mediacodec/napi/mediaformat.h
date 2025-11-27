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

#ifndef VIDEO_CODEC_FORMAT_H
#define VIDEO_CODEC_FORMAT_H
#include "demuxer.h"

class MediaFormat {
public:
    explicit MediaFormat(std::shared_ptr<OH_AVFormat> format);
    void SetInteger(const std::string &key, int32_t value);
    int32_t GetInteger(const std::string &key);
    int64_t GetLong(const std::string &key);
    float GetFloat(const std::string &key);
    std::string GetString(const std::string &key);
    std::string GetAndCheckKey(const std::string &key, const std::string &type);

private:
    std::shared_ptr<OH_AVFormat> format_ = nullptr;
};
#endif