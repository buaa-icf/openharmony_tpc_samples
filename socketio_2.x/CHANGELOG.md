## v1.0.6-rc.1

- Added support for multiple client instances in socketio_2.x

## v1.0.6-rc.0

- Fixed the issue where emit callbacks could be overwritten across same or different event names

## v1.0.5

- Fix repository from gitee to gitcode in oh-packaage.json5

## v1.0.4

- Fixed the issue where the dependent c++ static library caused conflicts with the dynamic libraries of other modules, leading to program crashes

## v1.0.4-rc.0

- Fix the problem that the client sends Uint8Array binary messages to the server and the data cannot be parsed
- Fix the problem that the client crashes when receiving special strings containing binary data from the server

## v1.0.3

- Optimized the memory problem in the emit message processing process.
- Added fixed events "ping_pong" and "disconnect" to listen for heartbeat and disconnection events.
- Added an interface "get_current_state" to get the current state.
- Simple packaging of demo to match new features and interfaces.
- Modified the readme file to add descriptions of new interfaces and features.

## v1.0.3-rc.0

- Fixed the issue of duplicate emit messages.

## v1.0.2

- Fix the problem that the set_option interface cannot be connected with {}.
- fix the problem that the array content is lost when sending the array data.
- Fix the problem that the client parses json string data when the server sends data with escape characters.

## v1.0.1

- Fixed an issue when the server returned json strings containing special characters.
- Binary data reception is supported.

## v1.0.0

- 实现功能

  作为与服务端之间建立链接的客户端库，使用c代码在ohos平台编译成.so文件，对外暴露connect、on、open、off、close、emit等接口。
