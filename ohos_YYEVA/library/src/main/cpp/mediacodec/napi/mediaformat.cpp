/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "mediaformat.h"
#include <unordered_map>
#include <ohos/ohos_log.h>

struct MediaDict {
    std::string key;
    std::string type;
};

const std::unordered_map<std::string, MediaDict> MEDIA_FORMAT_VALUES = {
    // 视频相关常量
    {"width",                       {OH_MD_KEY_WIDTH, "integer"}                    },
    {"height",                      {OH_MD_KEY_HEIGHT, "integer"}                   },
    {"frame-rate",                  {OH_MD_KEY_FRAME_RATE, "float"}                 },
    {"duration",                    {OH_MD_KEY_DURATION, "long"}                    },
    {"color-format",                {OH_MD_KEY_COLOR_PRIMARIES, "integer"}          },
    {"i-frame-interval",            {OH_MD_KEY_I_FRAME_INTERVAL, "integer"}         },
    {"bitrate",                     {OH_MD_KEY_BITRATE, "integer"}                  },
    {"max-input-size",              {"max-input-size", "integer"}                   },
    {"rotation-degrees",            {"rotation-degrees", "integer"}                 },
    {"stride",                      {"stride", "integer"}                           },
    {"slice-height",                {"slice-height", "integer"}                     },
    {"crop-left",                   {"crop-left", "integer"}                        },
    {"crop-right",                  {"crop-right", "integer"}                       },
    {"crop-top",                    {"crop-top", "integer"}                         },
    {"crop-bottom",                 {"crop-bottom", "integer"}                      },

    // 音频相关常量
    {"sample-rate",                 {OH_MD_KEY_AUD_SAMPLE_RATE, "integer"}          },
    {"channel-count",               {OH_MD_KEY_AUD_CHANNEL_COUNT, "integer"}        },
    {"aac-profile",                 {"aac-profile", "integer"}                      },
    {"is-adts",                     {"is-adts", "integer"}                          },
    {"pcm-encoding",                {"pcm-encoding", "integer"}                     },
    {"bitrate-mode",                {OH_MD_KEY_VIDEO_ENCODE_BITRATE_MODE, "integer"}},

    // 编解码器相关常量
    {"mime",                        {OH_MD_KEY_CODEC_MIME, "string"}                },
    {"codecs",                      {"codecs", "string"}                            },
    {"profile",                     {OH_MD_KEY_PROFILE, "integer"}                  },
    {"level",                       {"level", "integer"}                            },
    {"complexity",                  {"complexity", "integer"}                       },
    {"quality",                     {"quality", "integer"}                          },

    // 轨道相关常量
    {"track-id",                    {"track-id", "integer"}                         },
    {"language",                    {"language", "string"}                          },
    {"max-bitrate",                 {"max-bitrate", "integer"}                      },
    {"capture-rate",                {"capture-rate", "float"}                       },
    {"repeat-previous-frame-after", {"repeat-previous-frame-after", "long"}         },
    {"push-blank-buffers-on-stop",  {"push-blank-buffers-on-stop", "integer"}       },

    // 时间相关常量
    {"time-scale",                  {"time-scale", "integer"}                       },
    {"presentation-time",           {"presentation-time", "long"}                   },
    {"decoder-config",              {"decoder-config", "string"}                    },
    {"encoder-delay",               {"encoder-delay", "integer"}                    },
    {"encoder-padding",             {"encoder-padding", "integer"}                  },

    // 容器格式相关
    {"container-format",            {"container-format", "string"}                  },
    {"file-format",                 {"file-format", "string"}                       },
    {"display-width",               {"display-width", "integer"}                    },
    {"display-height",              {"display-height", "integer"}                   },

    // 特定编解码器常量
    {"hdr-static-info",             {"hdr-static-info", "string"}                   },
    {"hdr10-plus-info",             {"hdr10-plus-info", "string"}                   },
    {"dolby-vision-profile",        {"dolby-vision-profile", "integer"}             },
    {"sei",                         {"sei", "string"}                               }
};

MediaFormat::MediaFormat(std::shared_ptr<OH_AVFormat> format) : format_(format) {}

int32_t MediaFormat::GetInteger(const std::string &key)
{
    std::string dictKey = GetAndCheckKey(key, "integer");
    if (dictKey == "") {
        LOGE("cannot find key: %s", key.c_str());
        return -1;
    }
    int result;
    OH_AVFormat_GetIntValue(format_.get(), dictKey.c_str(), &result);
    return result;
}

int64_t MediaFormat::GetLong(const std::string &key)
{
    std::string dictKey = GetAndCheckKey(key, "long");
    if (dictKey == "") {
        LOGE("cannot find key: %s", key.c_str());
        return -1;
    }
    int64_t result;
    OH_AVFormat_GetLongValue(format_.get(), dictKey.c_str(), &result);
    return result;
}

std::string MediaFormat::GetString(const std::string &key)
{
    std::string dictKey = GetAndCheckKey(key, "string");
    if (dictKey == "") {
        LOGE("cannot find key: %s", key.c_str());
        return "";
    }
    char *result;
    OH_AVFormat_GetStringValue(format_.get(), dictKey.c_str(), const_cast<char const **>(&result));
    return std::string(result);
}

void MediaFormat::SetInteger(const std::string &key, int32_t value)
{
    std::string dictKey = GetAndCheckKey(key, "integer");
    if (dictKey == "") {
        LOGE("cannot find key: %s", key.c_str());
        return ;
    }
    OH_AVFormat_SetIntValue(format_.get(), dictKey.c_str(), value);
}

float MediaFormat::GetFloat(const std::string &key)
{
    std::string dictKey = GetAndCheckKey(key, "float");
    if (dictKey == "") {
        LOGE("cannot find key: %s", key.c_str());
        return -1;
    }
    double result;
    OH_AVFormat_GetDoubleValue(format_.get(), dictKey.c_str(), &result);
    return result;
}

std::string MediaFormat::GetAndCheckKey(const std::string &key, const std::string &type)
{
    if (MEDIA_FORMAT_VALUES.find(key) == MEDIA_FORMAT_VALUES.end()) {
        LOGE("not find key: %s", key.c_str());
        return "";
    }
    const MediaDict &dict = MEDIA_FORMAT_VALUES.at(key);
    if (dict.type != type) {
        LOGE("type not correct: %s != %s", dict.type.c_str(), type.c_str());
        return "";
    }
    return dict.key;
}
