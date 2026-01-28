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

#ifndef OHOS_WAKEUPLOCK_H_
#define OHOS_WAKEUPLOCK_H_

#include <stdint.h>

namespace mars {
namespace comm {

class WakeUpLock {
public:
    WakeUpLock();
    ~WakeUpLock();

    void Lock(int64_t _timelock); // ms
    void Lock();
    void Unlock();
    bool IsLocking();

private:
    void *object_;
};

} // namespace comm
} // namespace mars
#endif /* WAKEUPLOCK_H_ */
