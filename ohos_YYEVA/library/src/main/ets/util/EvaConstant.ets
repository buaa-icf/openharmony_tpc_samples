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

/**
 * YYEVA 常量定义
 * 包含视频模式、错误类型、错误消息等常量
 */
export class EvaConstant {
  public static readonly TAG = 'EvaAnimPlayer'

  // 视频模式
  public static readonly VIDEO_MODE_NORMAL_MP4_NONE = -2  // 无检测状态
  public static readonly VIDEO_MODE_NORMAL_MP4 = -1        // 正常mp4
  // 视频对齐方式 (兼容老版本视频模式)
  public static readonly VIDEO_MODE_SPLIT_HORIZONTAL = 1              // 视频左右对齐（alpha左\rgb右）
  public static readonly VIDEO_MODE_SPLIT_VERTICAL = 2                // 视频上下对齐（alpha上\rgb下）
  public static readonly VIDEO_MODE_SPLIT_HORIZONTAL_REVERSE = 3      // 视频左右对齐（rgb左\alpha右）
  public static readonly VIDEO_MODE_SPLIT_VERTICAL_REVERSE = 4        // 视频上下对齐（rgb上\alpha下）
  public static readonly YYEVAColorRegion_AlphaMP4_alphaHalfRightTop = 5  // 视频上下对齐（rgb上\alpha下）1/4 elpha

  // 状态码
  public static readonly OK = 0  // 成功

  // 错误类型
  public static readonly REPORT_ERROR_TYPE_EXTRACTOR_EXC = 10001  // MediaExtractor exception
  public static readonly REPORT_ERROR_TYPE_DECODE_EXC = 10002     // MediaCodec exception
  public static readonly REPORT_ERROR_TYPE_CREATE_THREAD = 10003  // 线程创建失败
  public static readonly REPORT_ERROR_TYPE_CREATE_RENDER = 10004  // render创建失败
  public static readonly REPORT_ERROR_TYPE_PARSE_CONFIG = 10005   // 配置解析失败
  public static readonly REPORT_ERROR_TYPE_CONFIG_PLUGIN_MIX = 10006  // 融合动画资源获取失败
  public static readonly REPORT_ERROR_TYPE_FILE_ERROR = 10007     // 文件无法读取
  public static readonly REPORT_ERROR_TYPE_HEVC_NOT_SUPPORT = 10008  // 不支持h265

  // 错误消息
  public static readonly ERROR_MSG_EXTRACTOR_EXC = '0x1 MediaExtractor exception'  // MediaExtractor exception
  public static readonly ERROR_MSG_DECODE_EXC = '0x2 MediaCodec exception'         // MediaCodec exception
  public static readonly ERROR_MSG_CREATE_THREAD = '0x3 thread create fail'        // 线程创建失败
  public static readonly ERROR_MSG_CREATE_RENDER = '0x4 render create fail'         // render创建失败
  public static readonly ERROR_MSG_PARSE_CONFIG = '0x5 parse config fail'          // 配置解析失败
  public static readonly ERROR_MSG_CONFIG_PLUGIN_MIX = '0x6 yyeva fail'            // 融合动画资源获取失败
  public static readonly ERROR_MSG_FILE_ERROR = '0x7 file can\'t read'            // 文件无法读取
  public static readonly ERROR_MSG_HEVC_NOT_SUPPORT = '0x8 hevc not support'      // 不支持h265

  /**
   * 获取错误消息
   * @param errorType 错误类型
   * @param errorMsg 额外错误消息
   * @return 完整的错误消息
   */
  public static getErrorMsg(errorType: number, errorMsg?: string | null): string {
    let baseMsg: string
    switch (errorType) {
      case EvaConstant.REPORT_ERROR_TYPE_EXTRACTOR_EXC:
        baseMsg = EvaConstant.ERROR_MSG_EXTRACTOR_EXC
        break
      case EvaConstant.REPORT_ERROR_TYPE_DECODE_EXC:
        baseMsg = EvaConstant.ERROR_MSG_DECODE_EXC
        break
      case EvaConstant.REPORT_ERROR_TYPE_CREATE_THREAD:
        baseMsg = EvaConstant.ERROR_MSG_CREATE_THREAD
        break
      case EvaConstant.REPORT_ERROR_TYPE_CREATE_RENDER:
        baseMsg = EvaConstant.ERROR_MSG_CREATE_RENDER
        break
      case EvaConstant.REPORT_ERROR_TYPE_PARSE_CONFIG:
        baseMsg = EvaConstant.ERROR_MSG_PARSE_CONFIG
        break
      case EvaConstant.REPORT_ERROR_TYPE_CONFIG_PLUGIN_MIX:
        baseMsg = EvaConstant.ERROR_MSG_CONFIG_PLUGIN_MIX
        break
      case EvaConstant.REPORT_ERROR_TYPE_FILE_ERROR:
        baseMsg = EvaConstant.ERROR_MSG_FILE_ERROR
        break
      case EvaConstant.REPORT_ERROR_TYPE_HEVC_NOT_SUPPORT:
        baseMsg = EvaConstant.ERROR_MSG_HEVC_NOT_SUPPORT
        break
      default:
        baseMsg = 'unknown'
        break
    }
    return `${baseMsg} ${errorMsg || ''}`
  }

  // 注册EvaAnim播放时的相关事件（对应Android中IEvaAnimListener中的接口）
  public static readonly EVENT_ID_ON_VIDEO_CONFIG_READY = 'onVideoConfigReady';
  public static readonly EVENT_ID_ON_VIDEO_START = 'onVideoStart';
  public static readonly EVENT_ID_ON_VIDEO_RESTART = 'onVideoRestart';
  public static readonly EVENT_ID_ON_VIDEO_RENDER = 'onVideoRender';
  public static readonly EVENT_ID_ON_VIDEO_COMPLETE = 'onVideoComplete';
  public static readonly EVENT_ID_ON_VIDEO_DESTROY = 'onVideoDestroy';
  public static readonly EVENT_ID_ON_FAILED = 'onFailed';
  // 尺寸发生变化
  public static readonly EVENT_ID_SIZE_CHANGED = 'sieze_changed';


  //支持的视频编码类型
  public static readonly MIME_HEVC: string = 'video/hevc';
}