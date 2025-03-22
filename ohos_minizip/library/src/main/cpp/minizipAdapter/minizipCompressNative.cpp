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

MinizipCompressNative::MinizipCompressNative(const std::string& catchPath, const std::string& zipFilePath)
    : catchPath_(catchPath), zipFilePath_(zipFilePath)
{
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

int32_t MinizipCompressNative::SetCompressMethod(uint16_t compressMethod)
{
    int32_t err = MZ_OK;
    if(compressMethod == 0 || compressMethod == 8 || compressMethod == 12 ||
         compressMethod == 14 || compressMethod == 93 || compressMethod == 95){
        compressMethod_ = compressMethod;
    } else 
        err = MZ_SUPPORT_ERROR;

    return err;
}

int32_t MinizipCompressNative::SetCompressLevel(int16_t compressLevel)
{
    int32_t err = MZ_OK;
    if(compressLevel == -1 || compressLevel == 2 || compressLevel == 6 || compressLevel == 9)
        compressLevel_ = compressLevel;
    else 
        err = MZ_SUPPORT_ERROR;

    return err;
}

int32_t MinizipCompressNative::SetzipFilePath(const std::string& zipFilePath)
{
    zipFilePath_ = zipFilePath;
}

int32_t MinizipCompressNative::Create()
{
    if(!zipFilePath_.empty()){
        isDiskCompress_ = true;
    }
    else if (zipFilePath_.empty() && !catchPath_.empty()) {
        isDiskCompress_ = false;
    }
    else{
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, LOGNAME_COM,
            "zipFilePath_ and catchPath_ is empty\n");
        return CompressError::CompressPathIsNull;
    }

    if(zipWriter_) {
        OH_LOG_Print(LOG_APP, LOG_WARN, LOG_DOMAIN, LOGNAME_COM,
                "zipWriter_ exist\n");
        return MZ_OK;
    }

    zipWriter_ = mz_zip_writer_create();
    if(!zipWriter_) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, LOGNAME_COM,
                "create zipWriter_ failed\n");
        return MZ_MEM_ERROR;
    }
    
    return MZ_OK;
}

void MinizipCompressNative::Close()
{
    Release();
}

bool MinizipCompressNative::isAbsolutePath(const std::string& path)
{
    if (path.empty())
        return false;

    size_t start = path.find_first_not_of(' ');
    if (start == std::string::npos) {
        return false;
    }

    return path[start] == '/';
}

int32_t MinizipCompressNative::AddSymlinkFile(const std::string& inputpath)
{
    char actual_path[1024];
    
    memset(actual_path, 0, sizeof(actual_path));
    strncpy(actual_path, inputpath.c_str(), sizeof(actual_path) - 1);
    actual_path[sizeof(actual_path) - 1] = '\0';

    std::vector<std::string> tmpVec;
    bool loop = false;
    while (mz_os_is_symlink(actual_path) == MZ_OK && !loop) {
        char tmp_path[1024];
        tmpVec.push_back(actual_path);
        mz_os_read_symlink(actual_path, tmp_path, sizeof(actual_path));
        if(!isAbsolutePath(tmp_path)) {
            char path_dir[1024];
            strncpy(path_dir, actual_path, sizeof(path_dir) - 1);
            path_dir[sizeof(path_dir) - 1] = 0;
            mz_path_remove_filename(path_dir);
            mz_path_combine(path_dir, tmp_path, sizeof(path_dir));

            memset(tmp_path, 0, sizeof(tmp_path));
            strncpy(tmp_path, path_dir, sizeof(tmp_path) - 1);
            tmp_path[sizeof(tmp_path) - 1] = '\0';
        }
        memset(actual_path, 0, sizeof(actual_path));
        strncpy(actual_path, tmp_path, sizeof(actual_path) - 1);
        actual_path[sizeof(actual_path) - 1] = '\0';

        for(int i = 0; i < tmpVec.size(); i++) {
            if (strcmp(actual_path, tmpVec[i].c_str()) == 0) {
                OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, LOGNAME_COM,
                    "symlink : %{public}s is loop link\n", inputpath.c_str());
                loop = true;
            }
        }
    }
    
    int32_t err = MZ_OK;
    if(!loop) {
        err = mz_zip_writer_add_file(zipWriter_, actual_path, inputpath.c_str());
        if(err != MZ_OK) {
            OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, LOGNAME_COM,
                "mz_zip_writer_add_file failed\n");
        }
    }

    return err;
}

int32_t MinizipCompressNative::AddFile(const std::string& inputpath)
{
    int32_t err = MZ_OK;
    bool is_dir = false;
    if (mz_os_is_dir(inputpath.c_str()) == MZ_OK) {
        is_dir = true;
    } else if(mz_os_is_symlink(inputpath.c_str()) == MZ_OK) {
        err = AddSymlinkFile(inputpath);
    } else {
        err = mz_zip_writer_add_file(zipWriter_, inputpath.c_str(), inputpath.c_str());
        if(err != MZ_OK)
        {
            OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, LOGNAME_COM,
                "mz_zip_writer_add_file failed\n");
        }
    }

    if(!is_dir)
        return err;

    std::queue<std::string> dirQueue;
    dirQueue.push(inputpath);

    while (!dirQueue.empty()) {
        std::string currentDir = dirQueue.front();
        dirQueue.pop();

        DIR *dir = mz_os_open_dir(currentDir.c_str());
        if(!dir) {
            OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, LOGNAME_COM,
                    "%{public}s is no exist\n", currentDir.c_str());
            return err;
        }

        struct dirent *entry = NULL;
        while((entry = mz_os_read_dir(dir))) {
            std::string name = entry->d_name;
            if(name == "." || name == "..") continue;

            std::string fullpPath = currentDir + "/" + name;
            if(mz_os_is_dir(fullpPath.c_str()) == MZ_OK) {
                dirQueue.push(fullpPath);
            } else if(mz_os_is_symlink(fullpPath.c_str()) == MZ_OK) {
                err = AddSymlinkFile(fullpPath);
                if(err != MZ_OK) {
                    mz_os_close_dir(dir);
                    return err;
                }
            } else {
                err = mz_zip_writer_add_file(zipWriter_, fullpPath.c_str(), fullpPath.c_str());
                if(err != MZ_OK) {
                    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, LOGNAME_COM,
                        "mz_zip_writer_add_file failed\n");
                    mz_os_close_dir(dir);
                    return err;
                }
            }
        }
        mz_os_close_dir(dir);
    }
    return err;
}

int32_t MinizipCompressNative::CompressInternal(const std::vector<std::string>& entries, const std::string& zipFilePath, const std::string& password)
{
    if(zipFilePath.empty()) return CompressError::CompressPathIsNull;
    
    int32_t err = mz_zip_writer_open_file(zipWriter_, zipFilePath.c_str(), 0, 0);
    if(err != MZ_OK) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, LOGNAME_COM,
                "open writer file failed\n");
        return err;
    }
    
    const char *pwd = password.empty() ? NULL : password.c_str();
    mz_zip_writer_set_password(zipWriter_, pwd);
    mz_zip_writer_set_aes(zipWriter_, 0);
    mz_zip_writer_set_compress_method(zipWriter_, compressMethod_);
    mz_zip_writer_set_compress_level(zipWriter_, compressLevel_);

    int32_t tmp_err = MZ_OK;
    for(int i = 0; i < entries.size(); i++) {
        tmp_err = AddFile(entries[i]);
        if(tmp_err != MZ_OK) {
            err = tmp_err;
        }
    }

    return err;
}


int32_t MinizipCompressNative::Compress(const std::vector<std::string>& entries, const std::string& password)
{
    return CompressInternal(entries, zipFilePath_, password);
}

int64_t MinizipCompressNative::GetStreamSize(void *stream)
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
    
    if (buffer) {
        int32_t read = mz_stream_os_read(stream, buffer, size);
        if (read != size)
            err = MZ_BUF_ERROR;
    }

    return err;
}

napi_value MinizipCompressNative::CompressToJS(const std::vector<std::string>& entries, const std::string& password)
{
    napi_env env = aki::JSBind::GetScopedEnv();
    if(isDiskCompress_){
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, LOGNAME_COM,
            "please use Compress\n");
        napi_value undefined = nullptr;
        napi_get_undefined(env, &undefined);
        return undefined;
    }

    int pos = entries[0].find_last_of("/");
    std::string filename = "";
    if(pos != std::string::npos){
        filename = entries[0].substr(pos + 1);
    }
    std::string zipFilePath = catchPath_ + "/" + "minizip_" + filename + "_tmp.zip";
    int32_t err = CompressInternal(entries, zipFilePath, password);
    if (err != MZ_OK) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, LOGNAME_COM, 
                     "Compress file %{public}s failed, err:%{public}d", zipFilePath.c_str(), err);
        napi_value undefined = nullptr;
        napi_get_undefined(env, &undefined);
        return undefined;
    }
    Close();

    void *stream = mz_stream_os_create();
    err = mz_stream_os_open(stream, zipFilePath.c_str(), MZ_OPEN_MODE_READ);
    if (err != MZ_OK) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, LOGNAME_COM, 
                     "Cannot open file %{public}s in zip archive, err:%{public}d", zipFilePath.c_str(), err);
        napi_value undefined = nullptr;
        napi_get_undefined(env, &undefined);
        return undefined;
    }

    int64_t size = this->GetStreamSize(stream);
    char *buffer = nullptr;
    napi_value napiArrayBuffer = nullptr;
    napi_create_arraybuffer(env, size, (void **)(&buffer), &napiArrayBuffer);
    err = this->CompressToMemory(stream, buffer, size);
    if (err != MZ_OK) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, LOGNAME_COM, "CompressToMemory Failed: %{public}d", err);
        napi_value undefined = nullptr;
        napi_get_undefined(env, &undefined);
        
        mz_stream_os_close(stream);
        mz_stream_os_delete(&stream);
        return undefined;
    }
    
    mz_stream_os_close(stream);
    mz_stream_os_delete(&stream);

    int result = remove(zipFilePath.c_str());
    if (result != 0) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, LOGNAME_COM, 
            "remove file %{public}s failed", zipFilePath.c_str());
    }

    return napiArrayBuffer;
}

JSBIND_CLASS(MinizipCompressNative)
{
    JSBIND_CONSTRUCTOR<std::string>();
    JSBIND_CONSTRUCTOR<std::string, std::string>();
    JSBIND_METHOD(Create);
    JSBIND_METHOD(Close);
    JSBIND_METHOD(SetCompressMethod);
    JSBIND_METHOD(SetCompressLevel);
    JSBIND_METHOD(SetzipFilePath);
    JSBIND_METHOD(Compress);
    JSBIND_METHOD(CompressToJS);
}

JSBIND_ADDON(minizip_ng_compress)