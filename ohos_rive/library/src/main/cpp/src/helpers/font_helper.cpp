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

#include "../../include/helpers/font_helper.h"
#include "../../include/helpers/exception_handler.h"
#include "../../include/helpers/general.h"
#include "../../include/helpers/resource.h"

#include <memory>
#include <mutex>
#include <unordered_map>
#include <vector>

namespace ohos_rive {
std::vector<rive::rcp<rive::Font>> FontHelper::sFallbackFonts;
std::unordered_map<uint16_t, std::vector<rive::rcp<rive::Font>>> FontHelper::s_pickFontCache;
std::mutex FontHelper::sFallbackFontsMutex;
napi_env FontHelper::g_env = nullptr;

bool FontHelper::RegisterFallbackFont(napi_env env, napi_value array)
{
    if (!env || !array) {
        LOGE("RegisterFallbackFontOHOS - Invalid parameters");
        return false;
    }
    g_env = env;

    std::vector<uint8_t> bytes = ByteArrayToUint8Vec(env, array);
    if (bytes.empty()) {
        LOGE("RegisterFallbackFontOHOS - Empty font data");
        return false;
    }

    rive::rcp<rive::Font> fallback = HBFont::Decode(bytes);
    if (!fallback) {
        LOGE("RegisterFallbackFontOHOS - failed to decode byte fonts");
        return false;
    }

    sFallbackFonts.push_back(fallback);
    LOGI("Registered fallback font, total count: %{public}zu", sFallbackFonts.size());
    return true;
}

std::vector<uint8_t> FontHelper::GetSystemFontBytes()
{
    if (!g_env) {
        LOGE("GetSystemFontBytes - No N-API environment available");
        return {};
    }

    NativeResource<napi_value> fontHelperClass = FindClass(g_env, "FontHelper");
    if (!fontHelperClass.Get()) {
        LOGE("FontHelper class not found");
        return {};
    }

    napi_value result = NapiExceptionHandler::CallObjectMethod(g_env, fontHelperClass.Get(), "getFallbackFontBytes");
    return ByteArrayToUint8Vec(g_env, result);
}

const std::vector<rive::rcp<rive::Font>> &FontHelper::GetOrCreateFontCache(uint16_t weight)
{
    auto cacheIt = s_pickFontCache.find(weight);
    if (cacheIt != s_pickFontCache.end()) {
        return cacheIt->second;
    }

    std::vector<rive::rcp<rive::Font>> fontsVec;
    auto [iter, _] = s_pickFontCache.emplace(weight, std::move(fontsVec));
    return iter->second;
}

std::vector<rive::rcp<rive::Font>> FontHelper::FetchAndConvertFonts(uint16_t weight)
{
    std::vector<rive::rcp<rive::Font>> fontsVec;

    if (!g_env) {
        LOGE("Pickfonts - No N-API environment available");
        return fontsVec;
    }

    NativeResource<napi_value> pickerClass = FindClass(g_env, "FontFallbackStrategy");
    if (!pickerClass.Get()) {
        LOGE("FontFallbackStrategy class not found");
        return fontsVec;
    }

    napi_value weightParam;
    napi_status status = napi_create_uint32(g_env, weight, &weightParam);
    if (status != napi_ok) {
        LOGE("Failed to create weight parameter: %{public}d", status);
        return fontsVec;
    }

    napi_value fontList = GetObjectFromMethod(g_env, pickerClass.Get(), "pickFont", 1, &weightParam).Get();
    if (!NapiExceptionHandler::IsValueValid(g_env, fontList)) {
        LOGE("pickFont method return null");
        return fontsVec;
    }

    uint32_t length = 0;
    status = napi_get_array_length(g_env, fontList, &length);
    if (status != napi_ok || length == 0) {
        LOGE("Failed to get font list length(%{public}u): %{public}d", length, status);
        return fontsVec;
    }

    fontsVec.reserve(length);
    for (size_t i = 0; i < length; ++i) {
        napi_value fontArray;
        status = napi_get_element(g_env, fontList, i, &fontArray);
        if (status != napi_ok) {
            LOGE("Failed to get font array at index %{public}zu: %{public}d", i, status);
            continue;
        }

        std::vector<uint8_t> fontData = ByteArrayToUint8Vec(g_env, fontArray);
        if (fontData.empty()) {
            LOGE("Failed to convert font array at index %{public}zu", i);
            continue;
        }

        rive::rcp<rive::Font> font = HBFont::Decode(fontData);
        if (font) {
            fontsVec.push_back(std::move(font));
        } else {
            LOGE("Failed to decode font at index %{public}zu for weight %{public}d", i, weight);
        }
    }

    return fontsVec;
}

const std::vector<rive::rcp<rive::Font>> &FontHelper::Pickfonts(const uint16_t weight)
{
    auto cacheIt = s_pickFontCache.find(weight);
    if (cacheIt != s_pickFontCache.end()) {
        return cacheIt->second;
    }

    auto fontsVec = FetchAndConvertFonts(weight);
    auto [iter, _] = s_pickFontCache.emplace(weight, std::move(fontsVec));
    return iter->second;
}

rive::rcp<rive::Font> FontHelper::FindFontFallback(const rive::Unichar missing,
                                                   const uint32_t fallbackIndex,
                                                   const rive::Font *riveFont)
{
    std::lock_guard<std::mutex> lock(sFallbackFontsMutex);

    static uint16_t desiredWeight = 400;
    if (fallbackIndex == 0) {
        desiredWeight = riveFont->getWeight();
    }

    const std::vector<rive::rcp<rive::Font>> &pickedFonts = Pickfonts(desiredWeight);
    if (fallbackIndex < pickedFonts.size()) {
        return pickedFonts[fallbackIndex];
    }

    for (const rive::rcp<rive::Font> &fFont : sFallbackFonts) {
        if (fFont->hasGlyph(missing)) {
            return fFont;
        }
    }

    std::vector<uint8_t> fontBytes = FontHelper::GetSystemFontBytes();
    if (fontBytes.empty()) {
        LOGW("FindFontFallback - No system font found");
        return nullptr;
    }

    rive::rcp<rive::Font> systemFont = HBFont::Decode(fontBytes);
    if (!systemFont) {
        LOGE("FindFontFallback - failed to decode system font bytes");
        return nullptr;
    }

    if (!systemFont->hasGlyph(missing)) {
        LOGE("FindFontFallback - no fallback found");
        return nullptr;
    }

    LOGD("FindFontFallback - found a system fallback");
    return systemFont;
}
} // namespace ohos_rive
