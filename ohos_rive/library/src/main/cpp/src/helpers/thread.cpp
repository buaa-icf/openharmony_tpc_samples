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

#include "../../include/helpers/thread.h"
#include "../../include/helpers/general.h"

#include <pthread.h>
#include <sched.h>
#include <sys/syscall.h>
#include <unistd.h>

namespace ohos_rive {
constexpr size_t DIVISOR = 2;

static pid_t GetTid()
{
    return syscall(SYS_gettid);
}

int32_t GetNumCpus()
{
    static int32_t sNumCpus = []() -> int32_t { // 明确指定返回类型�?int32_t
        pid_t pid = GetTid();
        cpu_set_t cpuSet;
        CPU_ZERO(&cpuSet);

        int result = sched_getaffinity(pid, sizeof(cpuSet), &cpuSet);
        if (result != 0) {
            LOGE("Failed to get CPU affinity, using sysconf instead");
            // 回退方案：使用系统配置获取CPU数量
            return static_cast<int32_t>(sysconf(_SC_NPROCESSORS_CONF));
        }

        int32_t numCpus = 0;
        int maxCpus = sysconf(_SC_NPROCESSORS_CONF);
        for (int32_t cpu = 0; cpu < maxCpus; ++cpu) {
            if (CPU_ISSET(cpu, &cpuSet)) {
                ++numCpus;
            }
        }

        LOGI("Detected %{public}d available CPUs out of %{public}d total", numCpus, maxCpus);
        return numCpus > 0 ? numCpus : 1; // 确保至少返回1个CPU
    }();

    return sNumCpus;
}

void SetAffinity(int32_t cpu)
{
    if (cpu < 0 || cpu >= GetNumCpus()) {
        LOGE("Invalid CPU index: %{public}d, available CPUs: 0-%{public}d", cpu, GetNumCpus() - 1);
        return;
    }

    cpu_set_t cpuSet;
    CPU_ZERO(&cpuSet);
    CPU_SET(cpu, &cpuSet);

    int result = sched_setaffinity(GetTid(), sizeof(cpuSet), &cpuSet);
    if (result != 0) {
        LOGE("Failed to set CPU affinity to core %d", cpu);
    } else {
        LOGI("Successfully set thread affinity to CPU %d", cpu);
    }
}

void SetAffinity(Affinity affinity)
{
    const int32_t numCpus = GetNumCpus();
    if (numCpus <= 0) {
        LOGE("No available CPUs for setting affinity");
        return;
    }

    cpu_set_t cpuSet;
    CPU_ZERO(&cpuSet);

    int cpusSet = 0;
    for (int32_t cpu = 0; cpu < numCpus; ++cpu) {
        switch (affinity) {
            case Affinity::NONE:
                CPU_SET(cpu, &cpuSet);
                cpusSet++;
                break;
            case Affinity::EVEN:
                if (cpu % DIVISOR == 0) {
                    CPU_SET(cpu, &cpuSet);
                    cpusSet++;
                }
                break;
            case Affinity::ODD:
                if (cpu % DIVISOR == 1) {
                    CPU_SET(cpu, &cpuSet);
                    cpusSet++;
                }
                break;
        }
    }

    if (cpusSet == 0) {
        LOGE("No CPUs selected for affinity pattern, using all CPUs");
        // 如果没有选择任何CPU，回退到使用所有CPU
        for (int32_t cpu = 0; cpu < numCpus; ++cpu) {
            CPU_SET(cpu, &cpuSet);
        }
    }

    int result = sched_setaffinity(GetTid(), sizeof(cpuSet), &cpuSet);
    if (result != 0) {
        LOGE("Failed to set affinity pattern");
    } else {
        LOGI("Successfully set affinity pattern, %{public}d CPUs selected", cpusSet);
    }
}
} // namespace ohos_rive
