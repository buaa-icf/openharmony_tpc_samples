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

#include "../../include/helpers/worker_thread.h"
#include "../../include/helpers/thread_state_pls.h"
#include <memory>

namespace ohos_rive {
std::unique_ptr<DrawableThreadState> WorkerThread::MakeThreadState(const RendererType type)
{
    LOGI("WorkerThread::MakeThreadState creating thread state for renderer type: %{public}d", static_cast<int>(type));

    switch (type) {
        case RendererType::CANVAS:
            LOGI("Creating CanvasThreadState for OHOS");
            return std::make_unique<CanvasThreadState>();

        case RendererType::RIVE:
            LOGI("Creating PLSThreadState for OHOS");
            return std::make_unique<PLSThreadState>();

        default:
            LOGE("Unknown renderer type: %d, defaulting to PLSThreadState", static_cast<int>(type));
            return std::make_unique<PLSThreadState>();
    }
}
} // namespace ohos_rive
