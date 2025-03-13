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

#include "minizipCompressNative.h"

static const char *LOGNAME_COM = "minizipcompressInfo";

MinizipCompressNative::MinizipCompressNative(std::string zipFilePath)
{
    zipFilePath_ = zipFilePath;
}

MinizipCompressNative::~MinizipCompressNative()
{
    Release();
}

void MinizipCompressNative::Release()
{
    if (zipWriter_) {
        mz_zip_writer_close(zipWriter_);
        mz_zip_writer_delete(&zipWriter_);
        zipWriter_ = nullptr;
    }
}

void MinizipCompressNative::SetCompressMethod(uint16_t compressMethod)
{
    compressMethod_ = compressMethod;
}

void MinizipCompressNative::SetCompressLevel(int16_t compressLevel)
{
    compressLevel_ = compressLevel;
}

int32_t MinizipCompressNative::Open()
{
    if(zipWriter_)
    {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, LOGNAME_COM,
                "zipWriter_ exist\n");
        return MZ_OK;
    }
    int32_t err = MZ_OK;

    zipWriter_ = mz_zip_writer_create();
    if(!zipWriter_)
    {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, LOGNAME_COM,
                "create zipWriter_ faild\n");
        return MZ_MEM_ERROR;
    }

    err = mz_zip_writer_open_file(zipWriter_, zipFilePath_.c_str(), 0, 0);
    if(err != MZ_OK)
    {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, LOGNAME_COM,
                "open writer file faild\n");
        return err;
    }
    
    return MZ_OK;
}

int32_t MinizipCompressNative::addFileToZip(std::string inputpath)
{
    std::queue<std::string> dirQueue;
    dirQueue.push(dirPath);

    while (!dirQueue.empty()) {
        std::string currentDir = dirQueue.front();
        dirQueue.pop();

        int32_t err;
        DIR *dir = mz_os_open_dir(inputpath.c_str());
        if(!dir)
        {
            OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, LOGNAME_COM,
                    "%{public}s is no exist\n", inputpath.c_str());
            return err;
        }

        struct dirent *entry = NULL;
        while((entry = mz_os_read_dir(dir)))
        {
            std::string name = entry->d_name;
            if(name == "." || name == "..") continue;

            std::string fullpPath = inputpath + "/" + name;
            if(mz_os_is_dir(fullpPath.c_str()) == MZ_OK)
            {
                dirQueue.push(fullpPath);
            }
            else if(mz_os_is_symlink(fullpPath.c_str()) == MZ_OK)
            {
                char actual_path[1024];
                mz_os_read_symlink(fullpPath.c_str(), actual_path, sizeof(actual_path));
                err = mz_zip_writer_add_file(zipWriter_, actual_path, fullpPath.c_str());
                if(err != MZ_OK)
                {
                    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, LOGNAME_COM,
                        "mz_zip_writer_add_file faild\n");
                    mz_os_close_dir(dir);
                    return err;
                }
            }
            else
            {
                err = mz_zip_writer_add_file(zipWriter_, fullpPath.c_str(), fullpPath.c_str());
                if(err != MZ_OK)
                {
                    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, LOGNAME_COM,
                        "mz_zip_writer_add_file faild\n");
                    mz_os_close_dir(dir);
                    return err;
                }
            }

        }
        mz_os_close_dir(dir);
    }


    return err;
}

int32_t MinizipCompressNative::Compress(std::vector<std::string> entries, std::string password)
{
    int32_t err = MZ_OK;
    const char *pwd = password.empty() ? NULL : password.c_str();

    mz_zip_writer_set_password(zipWriter_, pwd);
    mz_zip_writer_set_aes(zipWriter_, 0);
    mz_zip_writer_set_compress_method(zipWriter_, compressMethod_);
    mz_zip_writer_set_compress_level(zipWriter_, compressLevel_);

    for(int i = 0; i < entries.size(); i++)
    {
        addFileToZip(entries[i]);
    }

    return MZ_OK;
}

int64_t MinizipCompressNative::getStreamSize(void *stream)
{
    int64_t file_size = 0;

    mz_stream_os_seek(stream, 0, MZ_SEEK_END);
    file_size = mz_stream_os_tell(stream);
    if (file_size > INT32_MAX)
        OH_LOG_Print(LOG_APP, LOG_WARN, LOG_DOMAIN, LOGNAME_COM, 
            "File size is too large :%{public}ld", file_size);
    
    mz_stream_os_seek(stream, 0, MZ_SEEK_SET);

    return file_size;
}

int32_t MinizipCompressNative::CompressToMemory(void *stream, char *buffer, int64_t size)
{
    int32_t err = MZ_OK;
    int32_t read = 0;
    
    if (buffer) {
        read = mz_stream_os_read(stream, buffer, size);
        if (read != size)
            err = MZ_BUF_ERROR;
    }

    return err;
}

napi_value MinizipCompressNative::CompressToJS()
{
    int32_t err = MZ_OK;
    void *stream = NULL;
    char *buffer = nullptr;
    napi_value napiArrayBuffer = nullptr;
    napi_env env = aki::JSBind::GetScopedEnv();
    
    stream = mz_stream_os_create();
    err = mz_stream_os_open(stream, zipFilePath_.c_str(), MZ_OPEN_MODE_READ);
    if (err != MZ_OK) {
        OH_LOG_Print(LOG_APP, LOG_WARN, LOG_DOMAIN, LOGNAME_COM, 
                     "Cannot open file %{public}s in zip archive, err:%{public}d", zipFilePath_.c_str(), err);
        napi_value undefined = nullptr;
        napi_get_undefined(env, &undefined);
        return undefined;
    }

    int64_t size = this->getStreamSize(stream);
    napi_create_arraybuffer(env, size, (void **)(&buffer), &napiArrayBuffer);
    err = this->CompressToMemory(stream, buffer, size);
    if (err != MZ_OK) {
        OH_LOG_Print(LOG_APP, LOG_WARN, LOG_DOMAIN, LOGNAME_COM, "CompressToMemory Failed: %{public}d", err);
        napi_value undefined = nullptr;
        napi_get_undefined(env, &undefined);
        
        mz_stream_os_close(stream);
        mz_stream_os_delete(&stream);
        return undefined;
    }
    
    mz_stream_os_close(stream);
    mz_stream_os_delete(&stream);

    return napiArrayBuffer;
}

JSBIND_CLASS(MinizipCompressNative)
{
    JSBIND_CONSTRUCTOR<std::string>();
    JSBIND_METHOD(Open);
    JSBIND_METHOD(SetCompressMethod);
    JSBIND_METHOD(SetCompressLevel);
    JSBIND_METHOD(Compress);
    JSBIND_METHOD(CompressToJS);
}

JSBIND_ADDON(minizip_ng_compress)