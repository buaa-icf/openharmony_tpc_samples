import {MediaFormat} from 'libmediacodec.so'
import {media} from '@kit.MediaKit'

export class MediaConstant {
  static readonly KEY_WIDTH: string = "width";
  static readonly KEY_HEIGHT: string = "height";
  static readonly KEY_FRAME_RATE: string = "frame-rate";
  static readonly KEY_DURATION: string = "duration";
  static readonly KEY_COLOR_FORMAT: string = "color-format";
  static readonly KEY_I_FRAME_INTERVAL: string = "i-frame-interval";
  static readonly KEY_BIT_RATE: string = "bitrate";
  static readonly KEY_MAX_INPUT_SIZE: string = "max-input-size";
  static readonly KEY_ROTATION: string = "rotation-degrees";
  static readonly KEY_STRIDE: string = "stride";
  static readonly KEY_SLICE_HEIGHT: string = "slice-height";
  static readonly KEY_CROP_LEFT: string = "crop-left";
  static readonly KEY_CROP_RIGHT: string = "crop-right";
  static readonly KEY_CROP_TOP: string = "crop-top";
  static readonly KEY_CROP_BOTTOM: string = "crop-bottom";

  // 音频相关常量
  static readonly KEY_SAMPLE_RATE: string = "sample-rate";
  static readonly KEY_CHANNEL_COUNT: string = "channel-count";
  static readonly KEY_AAC_PROFILE: string = "aac-profile";
  static readonly KEY_IS_ADTS: string = "is-adts";
  static readonly KEY_PCM_ENCODING: string = "pcm-encoding";
  static readonly KEY_BITRATE_MODE: string = "bitrate-mode";

  // 编解码器相关常量
  static readonly KEY_MIME: string = "mime";
  static readonly KEY_CODECS: string = "codecs";
  static readonly KEY_PROFILE: string = "profile";
  static readonly KEY_LEVEL: string = "level";
  static readonly KEY_COMPLEXITY: string = "complexity";
  static readonly KEY_QUALITY: string = "quality";

  // 轨道相关常量
  static readonly KEY_TRACK_ID: string = "track-id";
  static readonly KEY_LANGUAGE: string = "language";
  static readonly KEY_MAX_BIT_RATE: string = "max-bitrate";
  static readonly KEY_CAPTURE_RATE: string = "capture-rate";
  static readonly KEY_REPEAT_PREVIOUS_FRAME_AFTER: string = "repeat-previous-frame-after";
  static readonly KEY_PUSH_BLANK_BUFFERS_ON_STOP: string = "push-blank-buffers-on-stop";

  // 时间相关常量
  static readonly KEY_TIME_SCALE: string = "time-scale";
  static readonly KEY_PRESENTATION_TIME: string = "presentation-time";
  static readonly KEY_DECODER_CONFIG: string = "decoder-config";
  static readonly KEY_ENCODER_DELAY: string = "encoder-delay";
  static readonly KEY_ENCODER_PADDING: string = "encoder-padding";

  // 容器格式相关
  static readonly KEY_CONTAINER_FORMAT: string = "container-format";
  static readonly KEY_FILE_FORMAT: string = "file-format";
  static readonly KEY_DISPLAY_WIDTH: string = "display-width";
  static readonly KEY_DISPLAY_HEIGHT: string = "display-height";

  // 特定编解码器常量
  static readonly KEY_HDR_STATIC_INFO: string = "hdr-static-info";
  static readonly KEY_HDR10_PLUS_INFO: string = "hdr10-plus-info";
  static readonly KEY_DOLBY_VISION_PROFILE: string = "dolby-vision-profile";
  static readonly KEY_SEI: string = "sei";

  static readonly SEEK_TO_PREVIOUS_SYNC: number = media.SeekMode.SEEK_PREV_SYNC;
  static readonly SEEK_TO_NEXT_SYNC: number = media.SeekMode.SEEK_NEXT_SYNC;
  static readonly SEEK_TO_CLOSEST_SYNC: number = media.SeekMode.SEEK_CLOSEST;

  static readonly PLAY_INIT: number = 0;
  static readonly PLAY_START: number = 1;
  static readonly PLAY_ON: number = 2;
  static readonly PLAY_PAUSE: number = 3;
  static readonly PLAY_EOS: number = 4;
  static readonly PLAY_END: number = 5;

  static readonly COLOR_FormatYUV420Planar: number = 1;
  static readonly COLOR_FormatNV12: number = 2;
  static readonly COLOR_FormatNV21: number = 3;
  static readonly COLOR_FormatSurface: number = 4;
  static readonly COLOR_FormatRGBA : number = 5;
}