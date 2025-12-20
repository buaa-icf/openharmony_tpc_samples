/*
 * Copyright (C) 2025 Huawei Device Co., Ltd.
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

#include "helpers/general.h"
#include "helpers/exception_handler.h"
#include "helpers/factories.h"
#include "helpers/worker_ref.h"
#include "refs.h"
#include "rive/file.hpp"

#include <fcntl.h>
#include <unistd.h>

namespace ohos_rive {
constexpr size_t ARG_NUM_ZERO = 0;
constexpr size_t ARG_NUM_ONE = 1;
constexpr size_t ARG_NUM_TWO = 2;
constexpr size_t ARG_NUM_THREE = 3;
constexpr size_t ARG_NUM_FOUR = 4;
constexpr size_t ARG_NUM_FIVE = 5;
constexpr size_t ARG_NUM_SIX = 6;
constexpr size_t ARG_NUM_SEVEN = 7;
constexpr size_t ARG_NUM_EIGHT = 8;
constexpr size_t BUFFER_SIZE = 256;

OhosRiveRenderFactory *g_riveFactory;
OhosCanvasFactory g_CanvasFactory;

uint64_t Import(napi_env env,
                uint8_t *bytes,
                int32_t length,
                RendererType rendererType,
                rive::FileAssetLoader *assetLoader)
{
    rive::ImportResult result;
    auto *fileFactory = GetFactory(rendererType);
    if (fileFactory == nullptr) {
        LOGE("fileFactory is null");
        return 0;
    }

    auto *file = rive::File::import(rive::Span<const uint8_t>(bytes, length), fileFactory, &result, assetLoader)
                     // Release the RCP to a raw pointer.
                     // We will un-ref when deleting the file.
                     .release();
    if (result == rive::ImportResult::success) {
        return reinterpret_cast<uint64_t>(file);
    } else if (result == rive::ImportResult::unsupportedVersion) {
        ThrowUnsupportedRuntimeVersionException(env, "Unsupported Rive File Version.");
        return 0;
    } else if (result == rive::ImportResult::malformed) {
        ThrowMalformedFileException(env, "Malformed Rive File.");
        return 0;
    } else {
        ThrowRiveException(env, "Unknown error loading file.");
        return 0;
    }
}

rive::Alignment GetAlignment(napi_env env, napi_value jsAlignment)
{
    int32_t alignmentValue = 0;
    napi_status status = napi_get_value_int32(env, jsAlignment, &alignmentValue);
    if (status != napi_ok) {
        LOGE("Failed to get fit enum value");
        return rive::Alignment::center;
    }

    switch (alignmentValue) {
        case ARG_NUM_ZERO:
            return rive::Alignment::topLeft;
        case ARG_NUM_ONE:
            return rive::Alignment::topCenter;
        case ARG_NUM_TWO:
            return rive::Alignment::topRight;
        case ARG_NUM_THREE:
            return rive::Alignment::centerLeft;
        case ARG_NUM_FOUR:
            return rive::Alignment::center;
        case ARG_NUM_FIVE:
            return rive::Alignment::centerRight;
        case ARG_NUM_SIX:
            return rive::Alignment::bottomLeft;
        case ARG_NUM_SEVEN:
            return rive::Alignment::bottomCenter;
        case ARG_NUM_EIGHT:
            return rive::Alignment::bottomRight;
        default:
            return rive::Alignment::center;
    }
}

rive::Fit GetFit(napi_env env, napi_value jFit)
{
    int32_t fitValue = 0;
    napi_status status = napi_get_value_int32(env, jFit, &fitValue);
    if (status != napi_ok) {
        LOGE("Failed to get fit enum value");
        return rive::Fit::none;
    }

    switch (fitValue) {
        case ARG_NUM_ZERO:
            return rive::Fit::none;
        case ARG_NUM_ONE:
            return rive::Fit::fill;
        case ARG_NUM_TWO:
            return rive::Fit::contain;
        case ARG_NUM_THREE:
            return rive::Fit::cover;
        case ARG_NUM_FOUR:
            return rive::Fit::fitWidth;
        case ARG_NUM_FIVE:
            return rive::Fit::fitHeight;
        case ARG_NUM_SIX:
            return rive::Fit::scaleDown;
        case ARG_NUM_SEVEN:
            return rive::Fit::layout;
        default:
            return rive::Fit::none;
    }
}

rive::Factory *GetFactory(RendererType rendererType)
{
    LOGD("GetFactory called with renderer type: %{public}d", static_cast<int>(rendererType));

    if (rendererType == RendererType::RIVE && RefWorker::RiveWorker() != nullptr) {
        LOGD("Returning Rive factory");
        return static_cast<rive::Factory *>(g_riveFactory);
    }

    LOGD("Returning Canvas factory as fallback");
    return static_cast<rive::Factory *>(&g_CanvasFactory);
}

std::string NapiStringToString(napi_env env, napi_value jsString)
{
    if (jsString == nullptr) {
        return "";
    }

    size_t length = 0;
    napi_get_value_string_utf8(env, jsString, nullptr, 0, &length);

    std::string result;
    if (length > 0) {
        result.resize(length);
        napi_get_value_string_utf8(env, jsString, &result[0], length + 1, &length);
    }

    return result;
}

int32_t SizeTToInt(size_t value)
{
    return static_cast<int32_t>(value);
}

size_t NapiIntToSizeT(napi_env env, napi_value jsValue)
{
    if (jsValue == nullptr) {
        LOGW("NapiIntToSizeT() - input jsValue is null");
        return 0;
    }
    int64_t value;
    napi_status status = napi_get_value_int64(env, jsValue, &value);
    if (status != napi_ok) {
        LOGW("NapiIntToSizeT() - failed to get value");
        return 0;
    }

    if (value < 0) {
        LOGW("NapiIntToSizeT() - value is a negative number %ld", value);
        return 0;
    }

    return value > static_cast<size_t>(SIZE_MAX) ? SIZE_MAX : static_cast<size_t>(value);
}

#if defined(DEBUG) || defined(LOG)

void NreadyProcess(int &max_fd, fd_set &read_fds, FILE *stdout_input, FILE *stderr_input)
{
    char buffer[BUFFER_SIZE];
    int nready = select(max_fd + 1, &read_fds, nullptr, nullptr, nullptr);
    if (nready > 0) {
        if (stdout_input && FD_ISSET(fileno(stdout_input), &read_fds)) {
            if (fgets(buffer, sizeof(buffer), stdout_input)) {
                LOGI("%{public}s", buffer);
            }
        }

        if (stderr_input && FD_ISSET(fileno(stderr_input), &read_fds)) {
            if (fgets(buffer, sizeof(buffer), stderr_input)) {
                LOGE("%{public}s", buffer);
            }
        }
    }
}

[[noreturn]] void LogThread()
{
    int stdout_pipe[ARG_NUM_TWO];
    int stderr_pipe[ARG_NUM_TWO];

    if (pipe(stdout_pipe) == 0) {
        dup2(stdout_pipe[ARG_NUM_ONE], STDOUT_FILENO);
        close(stdout_pipe[ARG_NUM_ONE]);
    }

    if (pipe(stderr_pipe) == 0) {
        dup2(stderr_pipe[ARG_NUM_ONE], STDERR_FILENO);
        close(stderr_pipe[ARG_NUM_ONE]);
    }

    FILE *stdout_input = fdopen(stdout_pipe[0], "r");
    FILE *stderr_input = fdopen(stderr_pipe[0], "r");

    fd_set read_fds;

    while (true) {
        FD_ZERO(&read_fds);
        if (stdout_input) {
            FD_SET(fileno(stdout_input), &read_fds);
        }
        if (stderr_input) {
            FD_SET(fileno(stderr_input), &read_fds);
        }

        int max_fd = 0;
        if (stdout_input && stderr_input) {
            max_fd = (fileno(stdout_input) > fileno(stderr_input)) ? fileno(stdout_input) : fileno(stderr_input);
        } else if (stdout_input) {
            max_fd = fileno(stdout_input);
        } else if (stderr_input) {
            max_fd = fileno(stderr_input);
        }

        NreadyProcess(max_fd, read_fds, stdout_input, stderr_input);
    }
}

static std::string EglErrorToString(EGLenum err)
{
    switch (err) {
        case EGL_BAD_SURFACE:
            return "EGL_BAD_SURFACE";
        case EGL_BAD_DISPLAY:
            return "EGL_BAD_DISPLAY";
        case EGL_BAD_CURRENT_SURFACE:
            return "EGL_BAD_CURRENT_SURFACE";
        case EGL_BAD_MATCH:
            return "EGL_BAD_MATCH";
        case EGL_BAD_CONFIG:
            return "EGL_BAD_CONFIG";
        case EGL_BAD_PARAMETER:
            return "EGL_BAD_PARAMETER";
        case EGL_BAD_CONTEXT:
            return "EGL_BAD_CONTEXT";
        case EGL_BAD_NATIVE_PIXMAP:
            return "EGL_BAD_NATIVE_PIXMAP";
        case EGL_BAD_ATTRIBUTE:
            return "EGL_BAD_ATTRIBUTE";
        case EGL_BAD_NATIVE_WINDOW:
            return "EGL_BAD_NATIVE_WINDOW";
        case EGL_BAD_ACCESS:
            return "EGL_BAD_ACCESS";
        case EGL_BAD_ALLOC:
            return "EGL_BAD_ALLOC";
        case EGL_CONTEXT_LOST:
            return "EGL_CONTEXT_LOST";
        case EGL_NOT_INITIALIZED:
            return "EGL_NOT_INITIALIZED";
        default:
            return "";
    }
}

void CheckEglError(const char *file, int line)
{
    EGLenum err = eglGetError();

    while (err != EGL_SUCCESS) {
        std::string error = EglErrorToString(err);
        if (error.empty()) {
            LOGE("(%{public}d) %{public}s - %{public}s:%{public}d", err, "Unknown", file, line);
            return;
        }
        LOGE("(%{public}d) %{public}s - %{public}s:%{public}d", err, error.c_str(), file, line);
        err = eglGetError();
    }
}
#endif
} // namespace ohos_rive
