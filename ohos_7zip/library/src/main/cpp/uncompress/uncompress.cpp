/*
 * Copyright (C) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "uncompress.h"
#include "mz.h"
#include "mz_os.h"
#include "mz_strm.h"
#include "mz_zip.h"
#include "mz_zip_rw.h"
#include "task_pool/task_pool.h"
#include <cerrno>
#include <clocale>
#include <cstddef>
#include <cstdio>
#include <filesystem>
#include <fstream>
#include <map>
#include <random>

extern int Main2(int, char **);

namespace Oh7zip {
static std::string TryCreateTmpFile()
{
    constexpr size_t bits = 8;
    constexpr size_t offset = 10;
    constexpr size_t maxBound = 35;
    std::random_device random;
    std::mt19937 generate(random());
    std::uniform_int_distribution<> dis(0, maxBound);
    std::string tmp = "tmp_";
    for (int i = 0; i < bits; i++) {
        int j = dis(generate);
        tmp += (i < offset) ? ('0' + j) : ('a' + j - offset);
    }
    tmp += ".ohos";
    return tmp;
}

static bool HasWritePermission(std::string& path)
{
    std::string fileName = path + "/" + TryCreateTmpFile();
    std::ofstream ofs(fileName);
    if (!ofs.is_open()) {
        return false;
    }
    ofs.close();
    std::filesystem::remove(fileName);
    return true;
}

static ErrorInfo CheckConfig(std::shared_ptr<Config7z> config)
{
    if (config == nullptr) {
        return ErrorInfo::CONFIG_NULL;
    }
    if (config->src.empty()) {
        return ErrorInfo::ILLEGAL_SRC;
    }
    if (!std::filesystem::exists(config->src)) {
        return ErrorInfo::ILLEGAL_SRC;
    }
    if (config->dst.empty()) {
        return ErrorInfo::ILLEGAL_DST;
    }
    if (!std::filesystem::is_directory(config->dst)) {
        return ErrorInfo::ILLEGAL_DST;
    }
    if (!HasWritePermission(config->dst)) {
        return ErrorInfo::DST_NO_PERMISSION;
    }
    return ErrorInfo::OK;
}

static std::pair<bool, bool> CheckZipEncodeUtf8AndEncrypt(void *zipHandle)
{
    mz_zip_file *fileInfo = NULL;
    int32_t err = 0;
    bool isUtf8 = true;
    bool isEncrypt = false;
    err = mz_zip_reader_goto_first_entry(zipHandle);
    do {
        err = mz_zip_reader_entry_get_info(zipHandle, &fileInfo);
        if (err != MZ_OK || fileInfo == NULL) {
            break;
        }
        if (fileInfo->flag & MZ_ZIP_FLAG_ENCRYPTED) {
            isEncrypt = true;
        }
        if (!(fileInfo->flag & MZ_ZIP_FLAG_UTF8)) {
            isUtf8 = false;
        }
        err = mz_zip_reader_goto_next_entry(zipHandle);
        if (err != MZ_OK && err != MZ_END_OF_LIST) {
            break;
        }
    } while (err == MZ_OK);
    return std::pair<bool, bool>(isUtf8, isEncrypt);
}

static ErrorInfo ExtractByZip(std::shared_ptr<Config7z> config)
{
    void *zipHandle = mz_zip_reader_create();
    if (mz_zip_reader_open_file(zipHandle, config->src.c_str()) != MZ_OK) {
        mz_zip_reader_delete(&zipHandle);
        return ErrorInfo::UNCOMPRESS_FAIL;
    }
    auto info = CheckZipEncodeUtf8AndEncrypt(zipHandle);
    if (info.second) {
        if (config->pwd.empty()) {
            mz_zip_reader_delete(&zipHandle);
            return ErrorInfo::MISSING_PASSWORD;
        }
        mz_zip_reader_set_password(zipHandle, config->pwd.c_str());
    }
    // ����ֻ��֪����utf8����,��֪������ʲô���룬ֻ�ǳ���ʹ��936,����������룬��Ҫ�����������룬�û�֪���𣿿������û����룿
    if (!info.first) {
        mz_zip_reader_set_encoding(zipHandle, MZ_ENCODING_CODEPAGE_936);
    }
    if (mz_zip_reader_save_all(zipHandle, config->dst.c_str()) != MZ_OK) {
        mz_zip_reader_delete(&zipHandle);
        return ErrorInfo::UNCOMPRESS_FAIL;
    }
    mz_zip_reader_delete(&zipHandle);
    return ErrorInfo::OK;
}

static ErrorInfo ExtractBy7zip(std::shared_ptr<Config7z> config)
{
    ErrorInfo ret = ErrorInfo::OK;
    int index = 0;
    const size_t Max = 10;
    const char *cmd[Max] = {nullptr};
    std::string exe = "7zz";
    std::string option = "x";
    std::string yes = "-y";
    std::string pwdcmd = "-p";
    std::string aoa = "-aoa";

    cmd[index++] = exe.c_str();
    cmd[index++] = option.c_str();
    cmd[index++] = yes.c_str();
    cmd[index++] = aoa.c_str();

    if (!config->pwd.empty()) {
        pwdcmd += config->pwd;
        cmd[index++] = pwdcmd.c_str();
    }
    std::string dst = "-o" + config->dst;
    cmd[index++] = dst.c_str();
    cmd[index++] = config->src.c_str();
    try {
        ret = !Main2(index, (char **)cmd) ? ErrorInfo::OK : ErrorInfo::UNCOMPRESS_FAIL;
    } catch (...) {
        int err = errno;
        if (err == ENOTTY || err == EEXIST || err == ENOENT) {
            ret = ErrorInfo::MISSING_PASSWORD;
        } else {
            ret = ErrorInfo::UNCOMPRESS_FAIL;
        }
    }
    return ret;
}

static bool IsZipFile(const std::string& path)
{
    size_t len = path.size();
    if (len < 2) {
        return false;
    }
    if (path[len - 1] == 'p' && path[len - 2] == 'i' && path[len - 3] == 'z') {
        return true;
    }
    return false;
}

ErrorInfo Uncompress::ExtractSync(std::shared_ptr<Config7z> config)
{
    ErrorInfo ret = CheckConfig(config);
    if (ret != ErrorInfo::OK) {
        return ret;
    }
    if (IsZipFile(config->src)) {
        ret = ExtractByZip(config);
    } else {
        ret = ExtractBy7zip(config);
    }
    return ret;
}

std::shared_future<ErrorInfo> Uncompress::ExtractAsync(std::shared_ptr<Config7z> config)
{
    auto promise = std::make_shared<std::promise<ErrorInfo>>();
    auto func = [this](std::shared_ptr<std::promise<ErrorInfo>> promise, std::shared_ptr<Config7z> config) {
        if (config == nullptr) {
            return;
        }
        if (promise != nullptr) {
            promise->set_value(ExtractSync(config));
        } else {
            ExtractSync(config);
        }
    };
    TaskPool::GetInstance().PushTask(ffrt_queue_priority_high, func, promise, config);
    return promise->get_future().share();
}

}