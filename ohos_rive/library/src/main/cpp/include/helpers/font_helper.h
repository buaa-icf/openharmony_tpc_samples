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

#ifndef OHOS_RIVE_FONT_HELPER_H
#define OHOS_RIVE_FONT_HELPER_H

#include "general.h"
#include "napi/native_api.h"
#include "rive/text/font_hb.hpp"
#include <arkui/native_node_napi.h>
#include <mutex>
#include <unordered_map>
#include <vector>

namespace ohos_rive {
class FontHelper {
private:
    static std::unordered_map<uint16_t, std::vector<rive::rcp<rive::Font>>> s_pickFontCache;
    static std::mutex sFallbackFontsMutex;

    static const std::vector<rive::rcp<rive::Font>> &Pickfonts(const uint16_t weight);
    static const std::vector<rive::rcp<rive::Font>> &GetOrCreateFontCache(uint16_t weight);
    static std::vector<rive::rcp<rive::Font>> FetchAndConvertFonts(uint16_t weight);

    static napi_env g_env;

public:
    static std::vector<rive::rcp<rive::Font>> sFallbackFonts;

    static void ResetCache()
    {
        std::lock_guard<std::mutex> lock(FontHelper::sFallbackFontsMutex);
        FontHelper::s_pickFontCache.clear();
    }

    static bool RegisterFallbackFont(napi_env env, napi_value array);

    static std::vector<uint8_t> GetSystemFontBytes();

    static rive::rcp<rive::Font> FindFontFallback(const rive::Unichar missing,
                                                  const uint32_t fallbackIndex,
                                                  const rive::Font *riveFont);
};
} // namespace ohos_rive

#endif // OHOS_RIVE_FONT_HELPER_H

