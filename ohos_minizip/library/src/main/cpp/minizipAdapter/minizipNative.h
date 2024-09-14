/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

#ifndef MINIZIP_NG_MINIZIPNATIVE_H
#define MINIZIP_NG_MINIZIPNATIVE_H

#include <vector>
#include <map>
#include <string>
#include <cstdint>

#include "napi/native_api.h"

#include "mz.h"
#include "mz_os.h"
#include "mz_strm.h"
#include "mz_strm_buf.h"
#include "mz_strm_split.h"
#include "mz_zip.h"
#include "mz_zip_rw.h"

struct MinizipEntryInfo {
    uint16_t entryNameSize = 0;
    int64_t uncompressedSize = 0;
    bool isEncryptedFlag = false;
    std::string originName;
};

class MinizipNative {
public:
    explicit MinizipNative(std::string zipFilePath);
    ~MinizipNative();
    int32_t Open();
    void SetCharEncoding(int32_t charEncoding);
    std::vector<std::string> GetEntryNames();
    napi_value ExtractFileToJS(std::string entryName, std::string password);
private:
    MinizipNative() = delete;
    void Release();
    bool AddEntryInfo(mz_zip_file *fileInfo);
    int32_t GetEntrysInfo();
    int32_t ExtractFileToMemory(std::string entryName, char *buffer, int64_t *size, const char *password);
    std::string zipFilePath_;
    void *zipReader_ {nullptr};
    int32_t charEncoding_ {-1};
    std::vector<std::string> entryNames_;
    std::map<std::string, MinizipEntryInfo> entryInfoMap_;
};

#endif // MINIZIP_NG_MINIZIPNATIVE_H
