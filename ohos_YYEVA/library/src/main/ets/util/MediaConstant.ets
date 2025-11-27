import {MediaFormat} from 'libmediacodec.so'
import {media} from '@kit.MediaKit'

export class MediaConstant {
  public static readonly KEY_WIDTH: string = 'width';
  public static readonly KEY_HEIGHT: string = 'height';
  public static readonly KEY_FRAME_RATE: string = 'frame-rate';
  public static readonly KEY_DURATION: string = 'duration';
  public static readonly KEY_COLOR_FORMAT: string = 'color-format';
  public static readonly KEY_I_FRAME_INTERVAL: string = 'i-frame-interval';
  public static readonly KEY_BIT_RATE: string = 'bitrate';
  public static readonly KEY_MAX_INPUT_SIZE: string = 'max-input-size';
  public static readonly KEY_ROTATION: string = 'rotation-degrees';
  public static readonly KEY_STRIDE: string = 'stride';
  public static readonly KEY_SLICE_HEIGHT: string = 'slice-height';
  public static readonly KEY_CROP_LEFT: string = 'crop-left';
  public static readonly KEY_CROP_RIGHT: string = 'crop-right';
  public static readonly KEY_CROP_TOP: string = 'crop-top';
  public static readonly KEY_CROP_BOTTOM: string = 'crop-bottom';

  // 音频相关常量
  public static readonly KEY_SAMPLE_RATE: string = 'sample-rate';
  public static readonly KEY_CHANNEL_COUNT: string = 'channel-count';
  public static readonly KEY_AAC_PROFILE: string = 'aac-profile';
  public static readonly KEY_IS_ADTS: string = 'is-adts';
  public static readonly KEY_PCM_ENCODING: string = 'pcm-encoding';
  public static readonly KEY_BITRATE_MODE: string = 'bitrate-mode';

  // 编解码器相关常量
  public static readonly KEY_MIME: string = 'mime';
  public static readonly KEY_CODECS: string = 'codecs';
  public static readonly KEY_PROFILE: string = 'profile';
  public static readonly KEY_LEVEL: string = 'level';
  public static readonly KEY_COMPLEXITY: string = 'complexity';
  public static readonly KEY_QUALITY: string = 'quality';

  // 轨道相关常量
  public static readonly KEY_TRACK_ID: string = 'track-id';
  public static readonly KEY_LANGUAGE: string = 'language';
  public static readonly KEY_MAX_BIT_RATE: string = 'max-bitrate';
  public static readonly KEY_CAPTURE_RATE: string = 'capture-rate';
  public static readonly KEY_REPEAT_PREVIOUS_FRAME_AFTER: string = 'repeat-previous-frame-after';
  public static readonly KEY_PUSH_BLANK_BUFFERS_ON_STOP: string = 'push-blank-buffers-on-stop';

  // 时间相关常量
  public static readonly KEY_TIME_SCALE: string = 'time-scale';
  public static readonly KEY_PRESENTATION_TIME: string = 'presentation-time';
  public static readonly KEY_DECODER_CONFIG: string = 'decoder-config';
  public static readonly KEY_ENCODER_DELAY: string = 'encoder-delay';
  public static readonly KEY_ENCODER_PADDING: string = 'encoder-padding';

  // 容器格式相关
  public static readonly KEY_CONTAINER_FORMAT: string = 'container-format';
  public static readonly KEY_FILE_FORMAT: string = 'file-format';
  public static readonly KEY_DISPLAY_WIDTH: string = 'display-width';
  public static readonly KEY_DISPLAY_HEIGHT: string = 'display-height';

  // 特定编解码器常量
  public static readonly KEY_HDR_STATIC_INFO: string = 'hdr-static-info';
  public static readonly KEY_HDR10_PLUS_INFO: string = 'hdr10-plus-info';
  public static readonly KEY_DOLBY_VISION_PROFILE: string = 'dolby-vision-profile';
  public static readonly KEY_SEI: string = 'sei';

  public static readonly SEEK_TO_PREVIOUS_SYNC: number = media.SeekMode.SEEK_PREV_SYNC;
  public static readonly SEEK_TO_NEXT_SYNC: number = media.SeekMode.SEEK_NEXT_SYNC;
  public static readonly SEEK_TO_CLOSEST_SYNC: number = media.SeekMode.SEEK_CLOSEST;

  public static readonly PLAY_INIT: number = 0;
  public static readonly PLAY_START: number = 1;
  public static readonly PLAY_ON: number = 2;
  public static readonly PLAY_PAUSE: number = 3;
  public static readonly PLAY_EOS: number = 4;
  public static readonly PLAY_END: number = 5;

  public static readonly COLOR_FORMAT_YUV420_PLANAR: number = 1;
  public static readonly COLOR_FORMAT_NV12: number = 2;
  public static readonly COLOR_FORMAT_NV21: number = 3;
  public static readonly COLOR_FORMAT_SURFACE: number = 4;
  public static readonly COLOR_FORMAT_RGBA : number = 5;
}