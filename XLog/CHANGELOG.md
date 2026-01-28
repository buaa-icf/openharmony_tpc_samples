
## 1.0.0 

Adapted the YYEVA library engine for HarmonyOS, covering core capabilities such as playing, rendering, and plugins. Supports dynamic element replacement and transparent channel video rendering.

### Core Features

 - Supports Alpha channel rendering, enabling transparent video playing and masking/blending on HarmonyOS
 - Provides complete playback controls including play, pause, mute, loop, and frame-by-step
 - Supports software/hardware decoding switching on devices with optimized 2D/3D GPU acceleration
 - Enables dynamic element replacement via JSON/scripts for real-time updates of images, text, and audio tracks
 - Features a pluggable plugin architecture extensible with NAPI/external filters and effects
 - Completes HarmonyOS media pipeline adaptation with lifecycle management (Ability/Page) and background recovery