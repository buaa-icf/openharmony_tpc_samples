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

#include "compress.h"
#include "task_pool/task_pool.h"
#include <fstream>
#include <filesystem>
#include <cstdio>

#if __has_include(<hilog/log.h>)
#include <hilog/log.h>
#define OH7ZIP_HAS_HILOG 1
#else
#define OH7ZIP_HAS_HILOG 0
#endif


extern int Main2(int, char **);

namespace Oh7zip {

static constexpr unsigned int OH7ZIP_LOG_DOMAIN = 0x0201;
static constexpr const char* OH7ZIP_LOG_TAG = "oh7zip";

static constexpr int MaxSupportFmt = 6;
static const std::string supportFmt_[MaxSupportFmt]{"zip", "7z", "tar", "xz", "gzip", "bzip2"};

static void LogIllegalDst(const std::string &dst, const char *reason)
{
    const char *safeReason = (reason == nullptr) ? "(null)" : reason;

#if OH7ZIP_HAS_HILOG
    OH_LOG_Print(LOG_APP, LOG_ERROR, OH7ZIP_LOG_DOMAIN, OH7ZIP_LOG_TAG,
        "illegal dst, reason=%{public}s dst=%{public}s", safeReason, dst.c_str());
#endif
}

static void LogDstParentPermOnWriteFail(const std::string &dst)
{
    std::filesystem::path dstPath(dst);
    std::filesystem::path parentPath = dstPath.parent_path();
    if (parentPath.empty()) {
        std::error_code ec;
        parentPath = std::filesystem::current_path(ec);
    }
    std::error_code ec;
    auto st = std::filesystem::status(parentPath, ec);
    auto perms = st.permissions();

    char rwx[10] = {
        (perms & std::filesystem::perms::owner_read) != std::filesystem::perms::none ? 'r' : '-',
        (perms & std::filesystem::perms::owner_write) != std::filesystem::perms::none ? 'w' : '-',
        (perms & std::filesystem::perms::owner_exec) != std::filesystem::perms::none ? 'x' : '-',
        (perms & std::filesystem::perms::group_read) != std::filesystem::perms::none ? 'r' : '-',
        (perms & std::filesystem::perms::group_write) != std::filesystem::perms::none ? 'w' : '-',
        (perms & std::filesystem::perms::group_exec) != std::filesystem::perms::none ? 'x' : '-',
        (perms & std::filesystem::perms::others_read) != std::filesystem::perms::none ? 'r' : '-',
        (perms & std::filesystem::perms::others_write) != std::filesystem::perms::none ? 'w' : '-',
        (perms & std::filesystem::perms::others_exec) != std::filesystem::perms::none ? 'x' : '-',
        '\0'
    };

#if OH7ZIP_HAS_HILOG
    OH_LOG_Print(LOG_APP, LOG_ERROR, OH7ZIP_LOG_DOMAIN, OH7ZIP_LOG_TAG,
        "write-open failed, dst=%{public}s parent=%{public}s perms(oct)=%{public}o perms(rwx)=%{public}s ec=%{public}d",
        dst.c_str(), parentPath.string().c_str(), static_cast<unsigned>(perms), rwx, ec.value());
#endif
}

static bool HasWritePermission(std::string path)
{
    std::ofstream ofs(path);
    if (!ofs.is_open()) {
        return false;
    }
    ofs.close();
    std::filesystem::remove(path);
    return true;
}

static int IsSupport(std::string fmt)
{
    for (int i = 0; i < MaxSupportFmt; i++) { 
        if (supportFmt_[i].compare(fmt) == 0) {
            return i < (MaxSupportFmt >> 1) ? 0 : 1;
        }
    }
    return -1;
}

static ErrorInfo CheckDstPath(const std::string &dst)
{
    if (dst.empty()) {
        LogIllegalDst(dst, "dst empty");
        return ErrorInfo::ILLEGAL_DST;
    }
    std::filesystem::path dstPath(dst);
    std::filesystem::path parentPath = dstPath.parent_path();
    if (parentPath.empty()) {
        parentPath = std::filesystem::current_path();
    }
    if (!std::filesystem::exists(parentPath) || !std::filesystem::is_directory(parentPath)) {
        LogIllegalDst(dst, "parent missing or not directory");
        return ErrorInfo::ILLEGAL_DST;
    }
    if (std::filesystem::exists(dstPath) && std::filesystem::is_directory(dstPath)) {
        LogIllegalDst(dst, "dst is a directory");
        return ErrorInfo::ILLEGAL_DST;
    }
    return ErrorInfo::OK;
}

static ErrorInfo CheckConfig(std::shared_ptr<Config7z> config)
{
    if (config == nullptr) {
        return ErrorInfo::CONFIG_NULL;
    }
    if (config->src.empty()) {
        return ErrorInfo::ILLEGAL_SRC;
    }
    for (int i = 0; i < config->src.size(); i++) {
        if (!std::filesystem::exists(config->src[i])) {
            return ErrorInfo::ILLEGAL_SRC;
        }
    }
    int ret = IsSupport(config->fmt);
    if (ret < 0) {
        return ErrorInfo::COMPRESS_FMT_NOT_SUPPURT;
    } else if (ret == 1 && std::filesystem::is_directory(config->src[0])) {
        return ErrorInfo::COMPRESS_FMT_SRC_ILLEGAL;
    } else {
        
    }
    ErrorInfo dstRet = CheckDstPath(config->dst);
    if (dstRet != ErrorInfo::OK) {
        return dstRet;
    }
    if (!HasWritePermission(config->dst)) {
        LogDstParentPermOnWriteFail(config->dst);
        return ErrorInfo::DST_NO_PERMISSION;
    }
    return ErrorInfo::OK;
}

ErrorInfo Compress::CompressSync(std::shared_ptr<Config7z> config)
{
    ErrorInfo ret = CheckConfig(config);
    if (ret != ErrorInfo::OK) {
        return ret;
    }
    int index = 0;
    const size_t Max = 128;
    const char *cmd[Max] = {nullptr};
    std::string exe = "7zz";
    std::string option = "a";
    std::string fmt = "-t" + config->fmt;
    std::string pwd = "-p";
    std::string recursion = "-r";
    std::vector<std::string> xr(config->xr.size(), "-xr");
    cmd[index++] = exe.c_str();
    cmd[index++] = option.c_str();
    cmd[index++] = config->dst.c_str();
    cmd[index++] = fmt.c_str();
    if (!config->pwd.empty()) {
        pwd += config->pwd;
        cmd[index++] = pwd.c_str();
    }
    cmd[index++] = recursion.c_str();
    for (int i = 0; i < config->src.size(); i++) {
        cmd[index++] = config->src[i].c_str();
    }
    for (int i = 0; i < config->xr.size(); i++) {
        xr[i] += config->xr[i];
        cmd[index++] = xr[i].c_str();
    }

    try {
        ret = !Main2(index, (char **)cmd) ? ErrorInfo::OK : ErrorInfo::COMPRESS_FAIL;
    } catch (...) {
        ret = ErrorInfo::COMPRESS_FAIL;
    }
    return ret;
}

std::shared_future<ErrorInfo> Compress::CompressAsync(std::shared_ptr<Config7z> config)
{
    auto promise = std::make_shared<std::promise<ErrorInfo>>();
    auto func = [this](std::shared_ptr<std::promise<ErrorInfo>> promise, std::shared_ptr<Config7z> config) {
        if (config == nullptr) {
            return;
        }
        if (promise != nullptr) {
            promise->set_value(CompressSync(config));
        } else {
            CompressSync(config);
        }
    };
    TaskPool::GetInstance().PushTask(ffrt_queue_priority_high, func, promise, config);
    return promise->get_future().share();
}
}