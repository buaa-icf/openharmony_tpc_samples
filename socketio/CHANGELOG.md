## v2.1.4-rc.0
- Send supports the transmission of multiple parameters.
- Added support for receiving multiple parameters in the on_rulti function.
- Change the dependency library address.

## v2.1.3

-  Optimized Shared Library Compilation: O3 and LTO Support

## v2.1.3-rc.2

- Fixed the issue of the number of callback function parameters in the on and emit methods and made improvements

## v2.1.3-rc.1

- Fixed the issue where emit callbacks could be overwritten across same or different event names

## v2.1.3-rc.0

- Fixed the issue where the dependent c++ static library caused conflicts with the dynamic libraries of other modules, leading to program crashes

## v2.1.2
- Fix repository from gitee to gitcode in oh-packaage.json5
- Release the official version

## v2.1.1
- Optimized the memory problem in the emit message processing process.
- Added fixed events "ping_pong" and "disconnect" to listen for heartbeat and disconnection events.
- Added an interface "get_current_state" to get the current state.
- Simple packaging of demo to match new features and interfaces.
- Modified the readme file to add descriptions of new interfaces and features.

## v2.1.1-rc.1
- Fixed the issue of duplicate emit messages.

## v2.1.1-rc.0
- Fixed the format of incoming parameters in the set_option and set_header interfaces.
- Fixed an issue where received messages contained special escape characters causing the program to crash.

## v2.1.0
- Socketio objects can be created in multiple scenarios.
- Support custom event name.
- Support to receive binary messages.
- Added set_headers for setting request headers.
- Added set_option for setting request parameter.
- Fixed server return json string parsing failure.
- Fixed client crash when server sends empty message.
- Fixed client failed to send array data.
- Fixed server failed to send array data.
- Fixed a data exception caused by the client receiving data buffer being too small.
- Fixed the exception of the client sending callback messages.

## v2.0.1
- 发布正式版本

## v2.0.1-rc.3
- 新增设置请求头header功能

## v2.0.1-rc.2
- 支持x86

## v2.0.1-rc.1

- 修复Openharmony4.1.0.66版本上connect接口调用crash问题，问题原因：由于系统napi_call_function接口在该版本上参数定义问题导致crash。

## v2.0.1-rc.0

- 修复socket.io接口connect调用crash问题

## v2.0.0

- 包管理工具由npm切换为ohpm
- DevEco Studio 版本： 4.1 Canary(4.1.3.317)
- OpenHarmony SDK:API11 (4.1.0.36)

## v1.0.1

- 适配3.1.0.200 IDE

## v1.0.0

- 实现功能

  作为与服务端之间建立链接的客户端库，使用c代码在ohos平台编译成.so文件，对外暴露connect、on、open、off、close、emit等接口。
