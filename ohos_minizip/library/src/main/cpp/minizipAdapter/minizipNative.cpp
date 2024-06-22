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

#include <bits/alltypes.h>
#include <unistd.h>
#include <aki/jsbind.h>
#include "hilog/log.h"
#include "minizipNative.h"

static const char *LOGNAME = "minizipInfo";

MinizipNative::MinizipNative(std::string zipFilePath)
{
    zipFilePath_= zipFilePath;
}

MinizipNative::~MinizipNative()
{
    Release();
}

int32_t MinizipNative::Open()
{
    if (zipReader_) {
        OH_LOG_Print(LOG_APP, LOG_WARN, LOG_DOMAIN, LOGNAME, "ZipFile Already Open");
        return MZ_OK;
    }

    int32_t err = MZ_OK;
    if (access(zipFilePath_.c_str(), F_OK) != 0) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, LOGNAME, "ZipFile does not exist");
        return MZ_DATA_ERROR;
    }
    zipReader_ = mz_zip_reader_create();
    if (!zipReader_) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, LOGNAME, "MZ_MEM_ERROR");
        return MZ_MEM_ERROR;
    }
    err = mz_zip_reader_open_file(zipReader_, zipFilePath_.c_str());
    if (err != MZ_OK) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, LOGNAME,
                     "Cannot open zip file: %{public}s\n", zipFilePath_.c_str());
        mz_zip_reader_delete(&zipReader_);
        zipReader_ = nullptr;
        return err;
    }
    return MZ_OK;
}

void MinizipNative::Release()
{
    if (zipReader_) {
        mz_zip_reader_close(zipReader_);
        mz_zip_reader_delete(&zipReader_);
        zipReader_ = nullptr;
    }
}

std::vector<std::string> MinizipNative::GetEntryNames()
{
    if (entryInfoMap_.empty()) {
        GetEntrysInfo();
    }
    if (entryNames_.empty()) {
        for (const auto &keys : entryInfoMap_) {
            entryNames_.push_back(keys.first);
        }
    }
    return entryNames_;
}

int32_t MinizipNative::GetEntrysInfo()
{
    mz_zip_file *fileInfo = NULL;
    int32_t err = MZ_OK;
    if (!zipReader_) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, LOGNAME, "MZ_MEM_ERROR");
        return MZ_MEM_ERROR;
    }
    err = mz_zip_reader_goto_first_entry(zipReader_);
    if (err != MZ_OK && err != MZ_END_OF_LIST) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, LOGNAME,
                     "Error %{public}" PRId32 " going to first entry in archive\n", err);
        return err;
    }
    
    do {
        err = mz_zip_reader_entry_get_info(zipReader_, &fileInfo);
        if (err != MZ_OK) {
            OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, LOGNAME,
                         "Error %" PRId32 " getting entry info in archive\n", err);
            break;
        }
        MinizipEntryInfo minizipEntryInfo;
        if (fileInfo->flag & MZ_ZIP_FLAG_ENCRYPTED) {
            minizipEntryInfo.isEncryptedFlag = true;
        }
        std::string entryName;
        entryName.assign(fileInfo->filename);
        minizipEntryInfo.entryNameSize = fileInfo->filename_size;
        minizipEntryInfo.uncompressedSize = fileInfo->uncompressed_size;
        entryInfoMap_.insert(std::make_pair(entryName, minizipEntryInfo));
        err = mz_zip_reader_goto_next_entry(zipReader_);
        if (err != MZ_OK && err != MZ_END_OF_LIST) {
            OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, LOGNAME,
                         "Error %" PRId32 " going to next entry in archive\n", err);
            break;
        }
    } while (err == MZ_OK);
    if (err == MZ_END_OF_LIST) {
        return MZ_OK;
    }
    return err;
}

int32_t MinizipNative::ExtractFileToMemory(std::string entryName, char *buffer, int64_t *size, const char *password)
{
    MinizipEntryInfo minizipEntryInfo;
    int32_t bytesRead = 0;
    int32_t err = MZ_OK;
    if (!zipReader_) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, LOGNAME, "MZ_MEM_ERROR");
        return MZ_MEM_ERROR;
    }
    minizipEntryInfo = entryInfoMap_[entryName];
    if (minizipEntryInfo.uncompressedSize > *size) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, LOGNAME, "BufferSize not enough");
        return MZ_BUF_ERROR;
    }
    if (entryInfoMap_[entryName].isEncryptedFlag) {
        mz_zip_reader_set_password(zipReader_, password);
    }
    err = mz_zip_reader_locate_entry(zipReader_, entryName.c_str(), 0);
    if (err != MZ_OK) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, LOGNAME,
                     "File %{public}s not found in zip archive\n", entryName.c_str());
        return err;
    }
    
    err = mz_zip_reader_entry_open(zipReader_);
    if (err != MZ_OK) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, LOGNAME,
                     "Cannot open file %{public}s in zip archive\n, err:%{public}d", entryName.c_str(), err);
        return err;
    }
    
    bytesRead = mz_zip_reader_entry_read(zipReader_, buffer, *size);
    if (bytesRead < 0) {
        OH_LOG_Print(LOG_APP, LOG_WARN, LOG_DOMAIN, LOGNAME,
                     "Failed to read file %{public}s from zip archive\n", entryName.c_str());
        *size = 0;
    } else {
        *size = bytesRead;
    }
    
    err = mz_zip_reader_entry_close(zipReader_);
    if (err != MZ_OK) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, LOGNAME, "Cannot mz_zip_reader_entry_close %{public}d", err);
        return err;
    }
    if (bytesRead < 0) {
        return bytesRead;
    }
    return MZ_OK;
}

napi_value MinizipNative::ExtractFileToJS(std::string entryName, std::string password)
{
    int64_t size = entryInfoMap_[entryName.c_str()].uncompressedSize;
    char *buffer = nullptr;
    napi_value napiArrayBuffer = nullptr;
    napi_env env = aki::JSBind::GetScopedEnv();
    napi_create_arraybuffer(env, size, (void **)(&buffer), &napiArrayBuffer);
    int32_t err = this->ExtractFileToMemory(entryName.c_str(), buffer, &size, password.c_str());
    if (err != MZ_OK) {
        OH_LOG_Print(LOG_APP, LOG_WARN, LOG_DOMAIN, LOGNAME, "ExtractFileToMemory Failed: %{public}d", err);
        napi_value undefined = nullptr;
        napi_get_undefined(env, &undefined);
        return undefined;
    }
    return napiArrayBuffer;
}

JSBIND_CLASS(MinizipNative)
{
    JSBIND_CONSTRUCTOR<std::string>();
    JSBIND_METHOD(Open);
    JSBIND_METHOD(GetEntryNames);
    JSBIND_METHOD(ExtractFileToJS);
}

JSBIND_ADDON(minizip_ng)