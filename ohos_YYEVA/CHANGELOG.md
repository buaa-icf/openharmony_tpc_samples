## 1.0.1-rc.1

- The player exposes the hitTestBehavior property, allowing users to customize its settings.
- Fixed streaking issues during normal MP4 playback.

## 1.0.0

The YYEVA engine has been adapted to support HarmonyOS, including core functionalities such as playback,
and. It supports dynamic element replacement alpha channel video rendering.

### Core Features

- Implementing transparent video playback and masking/blending functions.
- Provides complete playback controls including play, pause, mute, loop, and frame-by-step
- Supports software/hardware decoding switching on devices with optimized 2D/3D GPU acceleration
- Enables dynamic element replacement via JSON/scripts for real-time updates of images, text, and audio tracks
- Features a pluggable plugin architecture extensible with NAPI/external filters and effects