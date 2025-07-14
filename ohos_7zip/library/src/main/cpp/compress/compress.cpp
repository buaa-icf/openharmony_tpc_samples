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

extern int Main2(int, char **);

namespace Oh7zip {

static constexpr int MaxSupportFmt = 6;
static const std::string supportFmt_[MaxSupportFmt]{"zip", "7z", "tar", "xz", "gzip", "bzip2"};

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
    if (config->dst.empty()) {
        return ErrorInfo::ILLEGAL_DST;
    }
    int ret = IsSupport(config->fmt);
    if (ret < 0) {
        return ErrorInfo::COMPRESS_FMT_NOT_SUPPURT;
    } else if (ret == 1 && std::filesystem::is_directory(config->src[0])) {
        return ErrorInfo::COMPRESS_FMT_SRC_ILLEGAL;
    } else {
        
    }
    if (!HasWritePermission(config->dst)) {
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