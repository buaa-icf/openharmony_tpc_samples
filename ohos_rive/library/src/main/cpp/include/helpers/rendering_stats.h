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

#pragma once
#ifndef OHOS_RIVE_RENDERING_STATS_H
#define OHOS_RIVE_RENDERING_STATS_H

#include <cstddef>
#include <stdint.h>

namespace ohos_rive {
constexpr size_t NUM_TWO = 2;

class RenderingStats {
    double mLatestMean = 0, mLatestVar = 0;
    double mRunningMean = 0, mRunningVar = 0;
    size_t mN = 0;
    size_t mNumToAvg;

public:
    RenderingStats(size_t numToAvg) : mNumToAvg(numToAvg) {}

    // Add a sample.
    // When mNumToAvg samples have been calculated, store the mean and
    // average and start again.
    void add(double x)
    {
        ++mN;
        auto prevMean = mRunningMean;
        mRunningMean = ((mN - 1) * mRunningMean + x) / mN;
        if (mN > 1) {
            mRunningVar = ((mN - NUM_TWO) * mRunningVar) / (mN - 1) + (x - prevMean) * (x - prevMean) / mN;
        }
        if (mN == mNumToAvg)
            restart();
    }

    void restart()
    {
        mLatestMean = mRunningMean;
        mLatestVar = mRunningVar;
        mN = 0;
    }

    double mean() const
    {
        return mLatestMean;
    }

    double var() const
    {
        return mLatestVar;
    }
};
} // namespace ohos_rive

#endif // OHOS_RIVE_RENDERING_STATS_H

