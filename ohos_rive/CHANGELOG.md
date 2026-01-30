## 1.0.1

- Added audio library functionality to support sound playback for Rive animations with audio
- Fixed landscape rendering issue where one of two RiveAnimationView would often fail to render
- Fixed RiveAnimationView background transparency issue
- Optimized animation loading time for improved performance

## 1.0.0

The Rive animation engine has been adapted for OpenHarmony (OHOS), including core functionalities such as playback control,
state machine management, and dynamic content replacement. It supports interactive vector animation rendering with hardware acceleration.

### Core Features

- Implementing Rive animation playback with complete controls including play, pause, reset, loop, and speed adjustment
- Provides state machine support for interactive animations with input-driven behaviors
- Supports dynamic content replacement via ArkTS APIs for real-time updates of images, text
- Enables multiple resource loading methods including local assets, network resources, and custom asset loaders
- Features font fallback mechanism for handling missing fonts gracefully
- Supports blend modes and masking effects for advanced visual compositions