# 版本记录

## 1.1.7-rc.2

---

1. 'MixData' add optional parameter 'fontSize' and 'maxLines' for adjusting text font size and limiting maximum line.
2. Add 'setStopAtLast' to support stopping at the last frame of animation without destroying the screen and sending the 'Vapstate.ATLAST' event. After manually calling 'stop', the screen will be destroyed.
3. 'MixData' add optional parameter 'textHeightMarginRatio' for adjusting text height margin ratio which is 0.95 defaultly.

## 1.1.7-rc.1

---

1. Fixed the color issue at the edge of the picture.
2. Fixed the issue where color blocks automatically appeared when not filled.
3. Fixed the issue where emojis were not displayed.
4. Fixed the issue of json parsing crash.
5. Fixed the issue of incorrect data length reading.
6. Fixed the crash issue when the stop interface and XComponent destruction occurred simultaneously.
7. Fix the issue where callback scenarios have a probability of crashing.

## 1.1.6

---

1. Optimized Shared Library Compilation: O3 and LTO Support

## 1.1.6-rc.3

---

1. Fixed the issue of incorrect reading of vapc information.
2. Fix the issue of incomplete video information acquisition.
3. Fix the issue of long text being truncated.

## 1.1.6-rc.2

---

1. Add asynchronous stop functionality with Promise pattern and callback separation mechanism
2. Optimize error handling for stop operations

## 1.1.6-rc.1

---

1. Fixed the issue of incorrect rendering when starting to play the animation after rotating the screen.
2. Supports obtaining online video information and filling vap videos with byte streams.
3. Fixed the issue where the video fill element ended prematurely.

## 1.1.5

---

1. Fix rendering error after screen rotation.

## 1.1.5-rc.1

---

1. Fix the crash problem when multiple animations play continuously at the same time.

## 1.1.4

---

1. Fixed the abnormal stop of multiple animations playing at the same time.
2. Fix the crash problem when stop.

## 1.1.3

---

1. Fix loop bug.

## 1.1.2

---

1. Fix the memory leak.

## 1.1.1

---

1. 增强vap视频融合的通用性以及填充模式
2. 同步上游社区代码，修复在快速创建销毁xcomponent组件时出现的crash问题

## 1.1.0

---

1. 兼容部分MP4文件
2. 优化监听逻辑
3. 修复特定场景下的闪退

## 1.0.0 初版

---

1. 发布1.0.0初版