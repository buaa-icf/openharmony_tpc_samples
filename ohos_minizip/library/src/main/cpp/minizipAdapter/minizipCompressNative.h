/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

#ifndef MINIZIP_COMPRESS_NATIVE_H
#define MINIZIP_COMPRESS_NATIVE_H

#include <string>
#include <vector>
#include <queue>
// #include <bits/alltypes.h>
// #include <unistd.h>
#include <aki/jsbind.h>

#include "mz.h"
#include "mz_os.h"
#include "mz_strm.h"
#include "mz_strm_os.h"
#include "mz_strm_buf.h"
#include "mz_strm_split.h"
#include "mz_zip.h"
#include "mz_zip_rw.h"

#include "napi/native_api.h"
#include "hilog/log.h"

class MinizipCompressNative{
public:
    explicit MinizipCompressNative(std::string zipFilePath);
    ~MinizipCompressNative();

    int32_t Open();
    void SetCompressMethod(uint16_t compressMethod);
    void SetCompressLevel(int16_t compressLevel);
    int32_t Compress(std::vector<std::string> entries, std::string password);

    napi_value CompressToJS();

private:
    uint16_t compressMethod_ {MZ_COMPRESS_METHOD_DEFLATE};
    int16_t compressLevel_ {MZ_COMPRESS_LEVEL_DEFAULT};
    void *zipWriter_ {nullptr};
    std::string zipFilePath_;

    void Release();
    bool isAbsolutePath(std::string path);
    int32_t addFileToZip(std::string inputpath);
    int64_t getStreamSize(void *stream);
    int32_t CompressToMemory(void *stream, char *buffer, int64_t size);
};

#endif