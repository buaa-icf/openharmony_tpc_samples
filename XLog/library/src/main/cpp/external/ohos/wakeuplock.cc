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

#include "wakeuplock.h"
#include "assert/__assert.h"
#include "xlogger/xlogger.h"

#include "platform_comm.h"

namespace mars {
namespace comm {

WakeUpLock::WakeUpLock()
{
    object_ = wakeupLock_new();
    ASSERT(object_);
    xinfo2("new wakeuplock:%p", object_);
}

WakeUpLock::~WakeUpLock()
{
    ASSERT(object_);
    xinfo2("delete wakeuplock:%p", object_);

    if (IsLocking())
        wakeupLock_Unlock(object_);

    wakeupLock_delete(object_);
}

void WakeUpLock::Lock(int64_t _timelock)
{
    wakeupLock_Lock_Timeout(object_, _timelock);
}

void WakeUpLock::Lock()
{
    wakeupLock_Lock(object_);
}

void WakeUpLock::Unlock()
{
    wakeupLock_Unlock(object_);
}

bool WakeUpLock::IsLocking()
{
    return wakeupLock_IsLocking(object_);
}

} // namespace comm
} // namespace mars
