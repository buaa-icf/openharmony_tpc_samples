## 1.0.0

ohos_matisse is a lightweight and configurable media selector adapted for OpenHarmony (OHOS) platform. It provides complete image, video, and GIF selection functionality with multi-selection, preview, original quality options, and capture capabilities.

### Core Features

- **Multi-type Media Support**: Supports selection of various media types including images, videos, and GIFs, with configurable media type exclusivity
- **Flexible Multi-selection Configuration**: Supports global maximum selectable count limits, or separate maximum selectable counts per media type (independent limits for images/videos)
- **Capture Functionality**: Can enable camera capture entry, supporting direct capture and selection
- **Original Quality Option**: Supports original quality selection with configurable maximum original size (MB), automatically validated when checked
- **Preview Functionality**: Supports media preview with configurable auto-hide/show toolbar on click (autoHideToobar)
- **Rich Callback Mechanism**: Provides selection list callbacks and original quality check state callbacks, responding to selection changes in real-time
- **Orientation Restrictions**: Supports screen orientation restriction configuration, adapting to different usage scenarios

### Technical Features

- Developed based on OpenHarmony API12 (5.0.0.66)
- Implemented using ArkTS language
- Integrated with MediaLibraryKit photo picker component
- Provides complete type definitions and API documentation
- Supports installation via ohpm package manager

### Known Limitations (API12)

- Does not support `setPhotoBrowserUIElementVisibility` method to hide photo browser back button
- `autoHideToobar` functionality is limited, cannot simultaneously hide checkboxes
- Exiting photo browser requires using the system's built-in back button

**Recommendation**: For full feature support, please upgrade to API13 or higher.
